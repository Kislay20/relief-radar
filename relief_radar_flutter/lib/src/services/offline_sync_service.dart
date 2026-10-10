import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:relief_radar_client/relief_radar_client.dart';

import '../../client.dart';

/// Service managing local caching, offline persistence, and automatic background sync.
class OfflineSyncService {
  static const String _zonesBoxName = 'disaster_zones_cache';
  static const String _incidentsBoxName = 'incidents_cache';
  static const String _syncQueueBoxName = 'sync_action_queue';

  static const String _zonesKey = 'cached_zones_list';
  static const String _incidentsKey = 'cached_incidents_list';

  static Box<String>? _zonesBox;
  static Box<String>? _incidentsBox;
  static Box<String>? _syncQueueBox;

  static StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  static Timer? _connectivityDebounceTimer;

  /// In-memory queue for offline AI SOS triage messages.
  static final List<String> _pendingAiRequests = [];

  /// Returns unmodifiable list of pending AI SOS requests.
  static List<String> get pendingAiRequests =>
      List.unmodifiable(_pendingAiRequests);

  /// Queues an AI SOS triage message to auto-post when network is restored.
  static void queueAiTriage(String sosMessage) {
    _pendingAiRequests.add(sosMessage);
    pendingSyncCountNotifier.value =
        (_syncQueueBox?.length ?? 0) + _pendingAiRequests.length;
    debugPrint(
      '[OfflineSyncService] Queued offline AI SOS: "$sosMessage". Total AI queued: ${_pendingAiRequests.length}',
    );
  }

  /// Global notifier for device network availability.
  static final ValueNotifier<bool> isOnlineNotifier = ValueNotifier<bool>(true);

  /// Global notifier for pending offline queued actions.
  static final ValueNotifier<int> pendingSyncCountNotifier = ValueNotifier<int>(
    0,
  );

  /// Global notifier emitted when offline queue finishes syncing.
  static final ValueNotifier<String?> syncCompletionNotifier =
      ValueNotifier<String?>(null);

  /// Global notifier emitted when offline queue sync encounters an error.
  static final ValueNotifier<String?> syncErrorNotifier =
      ValueNotifier<String?>(null);

  /// Reference to client for automatic syncing on reconnect.
  static Client? _client;

  /// Concurrency guard preventing overlapping sync executions.
  static bool _isSyncing = false;

  /// Whether an offline sync queue flush is actively in progress.
  static bool get isSyncing => _isSyncing;

  /// Performs a lightweight health ping to the Serverpod backend.
  /// Returns true if the server actively responds, false otherwise.
  static Future<bool> pingServer([Client? clientToUse]) async {
    final c = clientToUse ?? _client;
    if (c == null) return false;
    try {
      await c.disasterZone.getAllActiveZones().timeout(
        const Duration(seconds: 4),
      );
      return true;
    } catch (e) {
      debugPrint(
        '[OfflineSyncService] DisasterZone ping failed on ${c.host} ($e). Retrying host in 1s...',
      );
      // Wait 1 second and retry current host before attempting full gateway failover
      await Future<void>.delayed(const Duration(milliseconds: 1000));
      try {
        await c.disasterZone.getAllActiveZones().timeout(
          const Duration(seconds: 3),
        );
        return true;
      } catch (retryErr) {
        debugPrint(
          '[OfflineSyncService] Retry on ${c.host} failed: $retryErr. Attempting gateway fallback...',
        );
      }

      if (kIsWeb) return false;
      final fellBack = await fallbackToNextGateway();
      if (fellBack && _client != null) {
        debugPrint(
          '[OfflineSyncService] Gateway failed over to ${_client!.host}. Verifying with active probe...',
        );
        try {
          await _client!.disasterZone.getAllActiveZones().timeout(
            const Duration(seconds: 3),
          );
          return true;
        } catch (probeErr) {
          debugPrint(
            '[OfflineSyncService] Post-failover probe failed: $probeErr',
          );
          return false;
        }
      }
      return false;
    }
  }

  /// Initializes Hive storage boxes and starts connectivity monitoring.
  static Future<void> initialize({Client? client}) async {
    _client = client;
    await Hive.initFlutter();

    _zonesBox = await Hive.openBox<String>(_zonesBoxName);
    _incidentsBox = await Hive.openBox<String>(_incidentsBoxName);
    _syncQueueBox = await Hive.openBox<String>(_syncQueueBoxName);

    // Synchronously set initial pending count from Hive plus in-memory AI queue
    pendingSyncCountNotifier.value =
        (_syncQueueBox?.length ?? 0) + _pendingAiRequests.length;

    // Reactively monitor box modifications
    _syncQueueBox?.watch().listen((_) {
      final total = (_syncQueueBox?.length ?? 0) + _pendingAiRequests.length;
      if (pendingSyncCountNotifier.value != total) {
        pendingSyncCountNotifier.value = total;
      }
    });

    // Default to online initially so physical device connection attempts are never hindered on launch
    isOnlineNotifier.value = true;
    try {
      final initialResults = await Connectivity().checkConnectivity();
      final hasInterface = initialResults.any(
        (r) => r != ConnectivityResult.none,
      );
      // Only set offline if an interface is definitively absent
      if (initialResults.isNotEmpty && !hasInterface) {
        isOnlineNotifier.value = false;
      }
    } catch (e) {
      debugPrint('[OfflineSyncService] Initial connectivity check error: $e');
      isOnlineNotifier.value = true;
    }

    // Monitor connectivity transitions: wait 1.5 seconds, then perform a server health check ping
    _connectivitySub?.cancel();
    _connectivityDebounceTimer?.cancel();
    _connectivitySub = Connectivity().onConnectivityChanged.listen((results) {
      _connectivityDebounceTimer?.cancel();
      _connectivityDebounceTimer = Timer(const Duration(milliseconds: 1500), () async {
        final hasInterface = results.any((r) => r != ConnectivityResult.none);
        if (!hasInterface) {
          debugPrint('[OfflineSyncService] Network interface lost (offline).');
          isOnlineNotifier.value = false;
          return;
        }

        debugPrint(
          '[OfflineSyncService] Network change detected. Pinging Serverpod backend...',
        );
        final serverReachable = await pingServer();

        if (serverReachable) {
          debugPrint(
            '[OfflineSyncService] Server ping succeeded! Setting online and processing sync queue.',
          );
          isOnlineNotifier.value = true;

          // Auto-sync queued offline actions when backend connectivity is verified
          if (_client != null) {
            await processSyncQueue(_client!);
          }
        } else {
          // Cellular data or Wi-Fi routing may need 2 seconds to settle on Android
          debugPrint(
            '[OfflineSyncService] Initial ping failed after network interface detected. Retrying in 2 seconds...',
          );
          await Future<void>.delayed(const Duration(seconds: 2));
          final retryReachable = await pingServer();
          if (retryReachable) {
            debugPrint(
              '[OfflineSyncService] Server ping succeeded on retry! Setting online and processing sync queue.',
            );
            isOnlineNotifier.value = true;
            if (_client != null) {
              await processSyncQueue(_client!);
            }
          } else {
            debugPrint(
              '[OfflineSyncService] Interface present but Serverpod backend unreachable after retry. Setting offline.',
            );
            isOnlineNotifier.value = false;
          }
        }
      });
    });
  }

  /// Sets the client instance used for synchronization and performs an initial background ping.
  static void registerClient(Client client) {
    _client = client;

    // Attempt an initial ping. If it fails, retry once after 2 seconds before
    // declaring offline — prevents transient startup failures (e.g., server still
    // warming up, adb reverse not yet settled) from showing OFFLINE incorrectly.
    pingServer(client).then((reachable) async {
      if (reachable) {
        isOnlineNotifier.value = true;
        if ((_syncQueueBox?.isNotEmpty ?? false) ||
            _pendingAiRequests.isNotEmpty) {
          processSyncQueue(client);
        }
      } else {
        // Wait 2 seconds and retry once before declaring offline
        await Future<void>.delayed(const Duration(seconds: 2));
        final retryReachable = await pingServer(client);
        isOnlineNotifier.value = retryReachable;
        if (retryReachable &&
            ((_syncQueueBox?.isNotEmpty ?? false) ||
                _pendingAiRequests.isNotEmpty)) {
          processSyncQueue(client);
        }
      }
    });
  }

  // ==========================================
  // CACHE: DISASTER ZONES
  // ==========================================

  /// Saves the active disaster zones list to Hive.
  static Future<void> cacheZones(List<DisasterZone> zones) async {
    try {
      final jsonList = zones.map((z) => z.toJson()).toList();
      await _zonesBox?.put(_zonesKey, jsonEncode(jsonList));
      debugPrint(
        '[OfflineSyncService] Cached ${zones.length} disaster zones locally.',
      );
    } catch (e) {
      debugPrint('[OfflineSyncService] Error caching zones: $e');
    }
  }

  /// Retrieves cached disaster zones from Hive.
  static List<DisasterZone> getCachedZones() {
    try {
      final raw = _zonesBox?.get(_zonesKey);
      if (raw == null || raw.isEmpty) return [];

      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map(
            (item) => DisasterZone.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
    } catch (e) {
      debugPrint('[OfflineSyncService] Error reading cached zones: $e');
      return [];
    }
  }

  // ==========================================
  // CACHE: INCIDENTS
  // ==========================================

  /// Saves the recent incidents list to Hive.
  static Future<void> cacheIncidents(List<Incident> incidents) async {
    try {
      final jsonList = incidents.map((i) => i.toJson()).toList();
      await _incidentsBox?.put(_incidentsKey, jsonEncode(jsonList));
      debugPrint(
        '[OfflineSyncService] Cached ${incidents.length} incidents locally.',
      );
    } catch (e) {
      debugPrint('[OfflineSyncService] Error caching incidents: $e');
    }
  }

  /// Retrieves cached incidents from Hive.
  static List<Incident> getCachedIncidents() {
    try {
      final raw = _incidentsBox?.get(_incidentsKey);
      if (raw == null || raw.isEmpty) return [];

      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map(
            (item) => Incident.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();
    } catch (e) {
      debugPrint('[OfflineSyncService] Error reading cached incidents: $e');
      return [];
    }
  }

  /// Updates or inserts a single incident in the local cache.
  static Future<void> updateIncidentInCache(Incident incident) async {
    final cached = getCachedIncidents();
    final index = cached.indexWhere((i) => i.id == incident.id);
    if (index != -1) {
      cached[index] = incident;
    } else {
      cached.insert(0, incident);
    }
    await cacheIncidents(cached);
  }

  /// Updates an incident's status in the local cache.
  static Future<Incident?> updateIncidentStatusInCache(
    int incidentId,
    IncidentStatus newStatus,
  ) async {
    final cached = getCachedIncidents();
    final index = cached.indexWhere((i) => i.id == incidentId);
    if (index != -1) {
      final existing = cached[index];
      final updated = existing.copyWith(
        status: newStatus,
        resolvedAt: newStatus == IncidentStatus.resolved
            ? (existing.resolvedAt ?? DateTime.now())
            : existing.resolvedAt,
      );
      cached[index] = updated;
      await cacheIncidents(cached);
      return updated;
    }
    return null;
  }

  // ==========================================
  // OFFLINE WRITE: ACTION SYNC QUEUE
  // ==========================================

  /// Queues an incident status update action when operating offline.
  static Future<void> queueStatusUpdate(
    int incidentId,
    IncidentStatus newStatus,
  ) async {
    final payload = {
      'action': 'update_status',
      'incidentId': incidentId,
      'status': newStatus.name,
      'queuedAt': DateTime.now().toIso8601String(),
    };

    await _syncQueueBox?.add(jsonEncode(payload));
    pendingSyncCountNotifier.value =
        (_syncQueueBox?.length ?? 0) + _pendingAiRequests.length;
    debugPrint(
      '[OfflineSyncService] Queued offline action for Incident #$incidentId -> ${newStatus.name}. Total queued: ${pendingSyncCountNotifier.value}',
    );
  }

  /// Processes all queued actions and sends them to the Serverpod backend.
  static Future<int> processSyncQueue(Client client) async {
    final box = _syncQueueBox;
    if ((box == null || box.isEmpty) && _pendingAiRequests.isEmpty) {
      pendingSyncCountNotifier.value = 0;
      return 0;
    }

    if (_isSyncing) {
      debugPrint(
        '[OfflineSyncService] Sync already in progress, skipping duplicate invocation.',
      );
      return 0;
    }
    _isSyncing = true;

    int successCount = 0;

    try {
      // 1. Process pending offline AI triage SOS requests first
      if (_pendingAiRequests.isNotEmpty) {
        debugPrint(
          '[OfflineSyncService] Processing offline AI triage queue (${_pendingAiRequests.length} messages pending)...',
        );

        final pendingMessages = List<String>.from(_pendingAiRequests);
        for (final sosMessage in pendingMessages) {
          try {
            int targetZoneId = 1;
            double lat = 19.0760;
            double lon = 72.8777;
            NeedType needType = NeedType.other;
            String text = sosMessage;

            try {
              if (sosMessage.trim().startsWith('{')) {
                final json = jsonDecode(sosMessage) as Map<String, dynamic>;
                text = (json['text'] as String?) ?? sosMessage;
                targetZoneId = (json['zoneId'] as int?) ?? 1;
                if (json['need'] != null) {
                  needType = NeedType.values.firstWhere(
                    (n) => n.name == json['need'],
                    orElse: () => NeedType.other,
                  );
                }
              }
            } catch (_) {}

            final cachedZones = getCachedZones();
            if (cachedZones.isNotEmpty) {
              final matched = cachedZones.firstWhere(
                (z) => z.id == targetZoneId,
                orElse: () => cachedZones.first,
              );
              targetZoneId = matched.id ?? targetZoneId;
              lat = matched.center.latitude;
              lon = matched.center.longitude;
            }

            final result = await client.aiTriage.ingestAndTriageSos(
              zoneId: targetZoneId,
              needType: needType,
              rawSosDescription: text,
              latitude: lat + 0.002,
              longitude: lon + 0.002,
            );

            // Successfully processed -> remove from queue
            _pendingAiRequests.remove(sosMessage);
            successCount++;
            await updateIncidentInCache(result);
            pendingSyncCountNotifier.value =
                (box?.length ?? 0) + _pendingAiRequests.length;
            debugPrint(
              '[OfflineSyncService] Successfully auto-posted AI SOS: Incident #${result.id} (${result.aiSeverity}). Remaining in AI queue: ${_pendingAiRequests.length}',
            );
          } catch (e, stackTrace) {
            debugPrint(
              '[OfflineSyncService] Failed to auto-post AI SOS request: $e\n$stackTrace',
            );
            // Halt queue processing on connection failure so items aren't discarded
            break;
          }
        }
      }

      // 2. Process status updates from _syncQueueBox
      if (box != null && box.isNotEmpty) {
        debugPrint(
          '[OfflineSyncService] Processing offline sync queue (${box.length} actions pending)...',
        );

        final keys = List<dynamic>.from(box.keys);

        for (final key in keys) {
          final rawAction = box.get(key);
          if (rawAction == null) {
            await box.delete(key);
            pendingSyncCountNotifier.value =
                box.length + _pendingAiRequests.length;
            continue;
          }

          try {
            final data = jsonDecode(rawAction) as Map<String, dynamic>;
            final actionType = data['action'] as String?;

            if (actionType == 'update_status') {
              final incidentId = data['incidentId'] as int;
              final statusName = data['status'] as String;
              final status = IncidentStatus.values.firstWhere(
                (s) => s.name == statusName,
                orElse: () => IncidentStatus.open,
              );

              // Safely await the backend call for EACH item
              final result = await client.incident.updateIncidentStatus(
                incidentId,
                status,
              );

              // ONLY remove the item from Hive if the server explicitly accepted it
              if (result != null) {
                await box.delete(key);
                pendingSyncCountNotifier.value =
                    box.length + _pendingAiRequests.length;
                successCount++;

                // Refresh local cache with backend result
                await updateIncidentInCache(result);
                debugPrint(
                  '[OfflineSyncService] Synced queued status for Incident #$incidentId to ${status.name}. Remaining: ${box.length}',
                );
              } else {
                debugPrint(
                  '[OfflineSyncService] Server rejected update for Incident #$incidentId. Halting queue.',
                );
                syncErrorNotifier.value = null;
                syncErrorNotifier.value =
                    'Sync Failed: Server rejected status update. Retrying later.';
                break;
              }
            }
          } catch (e, stackTrace) {
            debugPrint(
              '[OfflineSyncService] Sync Failed with error: $e\n$stackTrace',
            );
            syncErrorNotifier.value = null;
            syncErrorNotifier.value =
                'Sync Failed: Server unreachable. Retrying later.';
            // Keep item in Hive and halt queue processing until next connectivity recovery
            break;
          }
        }
      }
    } finally {
      _isSyncing = false;
      pendingSyncCountNotifier.value =
          (box?.length ?? 0) + _pendingAiRequests.length;
    }

    if (successCount > 0) {
      final msg =
          '⚡ Successfully synced $successCount offline action(s) to Command Server!';
      syncCompletionNotifier.value = null;
      syncCompletionNotifier.value = msg;
      debugPrint('[OfflineSyncService] $msg');
    }

    return successCount;
  }

  /// Disposes background listeners.
  static void dispose() {
    _connectivityDebounceTimer?.cancel();
    _connectivitySub?.cancel();
  }
}
