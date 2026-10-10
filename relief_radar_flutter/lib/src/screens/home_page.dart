import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:relief_radar_client/relief_radar_client.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';

import '../../client.dart';
import '../../main.dart';
import '../services/notification_service.dart';
import '../services/offline_sync_service.dart';
import '../theme/app_theme.dart';
import '../widgets/gateway_config_dialog.dart';
import 'login_page.dart';
import 'map_screen.dart';

/// Tactical Emergency Operations & Incident Command Dashboard.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentTabIndex = 0;
  LatLng? _targetMapLocation;
  Incident? _trackedIncident;
  final ValueNotifier<Incident?> _trackedIncidentNotifier =
      ValueNotifier<Incident?>(null);

  bool _isLoading = true;
  bool _isActionInProgress = false;
  String? _errorMessage;

  List<DisasterZone> _zones = [];
  List<Incident> _incidents = [];

  // Filter state
  NeedType? _selectedNeedType;
  int? _selectedZoneId;

  // Real-time WebSocket streaming telemetry state
  StreamSubscription<Incident>? _incidentStreamSub;
  Timer? _streamReconnectTimer;

  // Complete boot banner suppression flag: set to false ONLY after the first successful dashboard render
  bool _isFirstBoot = true;

  // Centralized notification state & lock to prevent spam / stacking
  DateTime _lastNotificationTime = DateTime.fromMillisecondsSinceEpoch(0);
  String? _lastNotificationKey;

  // Priority lock to protect sync success confirmations from being dismissed by live stream telemetry
  DateTime _syncSuccessActiveUntil = DateTime.fromMillisecondsSinceEpoch(0);

  /// Centralized tactical notification handler:
  /// - Strict notification lock to prevent spam & stacking
  /// - Priority guard: protects high-priority sync success snackbars from being cleared
  /// - Always clears pending SnackBars before presenting new state
  void _showCentralizedSnackBar({
    required Widget content,
    Color backgroundColor = const Color(0xFF1E2833),
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    String? deduplicationKey,
    bool isHighPriority = false,
  }) {
    if (!mounted) return;

    final now = DateTime.now();

    // Protect high-priority sync confirmation banners from being dismissed/overwritten by routine telemetry
    if (!isHighPriority && now.isBefore(_syncSuccessActiveUntil)) {
      debugPrint(
        '[HomePage] Suppressed routine SnackBar during sync confirmation: key=$deduplicationKey',
      );
      return;
    }

    // Suppress routine telemetry while offline sync queue is actively flushing
    if (!isHighPriority && OfflineSyncService.isSyncing) {
      debugPrint(
        '[HomePage] Suppressed routine SnackBar during active sync queue processing: key=$deduplicationKey',
      );
      return;
    }

    if (deduplicationKey != null &&
        deduplicationKey == _lastNotificationKey &&
        now.difference(_lastNotificationTime) <
            const Duration(milliseconds: 1500)) {
      return;
    }

    _lastNotificationTime = now;
    _lastNotificationKey = deduplicationKey;

    final messenger =
        rootScaffoldMessengerKey.currentState ?? ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        duration: duration,
        action: action,
        content: GlassContainer(
          borderRadius: BorderRadius.circular(14.0),
          glowColor: backgroundColor,
          borderColor: backgroundColor.withValues(alpha: 0.65),
          borderWidth: 1.2,
          backgroundColor: const Color(0xFF151C24).withValues(alpha: 0.92),
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
          child: content,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
    _initLiveTelemetryStream();
    OfflineSyncService.syncCompletionNotifier.addListener(
      _onOfflineSyncCompleted,
    );
    OfflineSyncService.syncErrorNotifier.addListener(
      _onOfflineSyncError,
    );
    OfflineSyncService.pendingSyncCountNotifier.addListener(
      _onPendingQueueChanged,
    );
    OfflineSyncService.isOnlineNotifier.addListener(_onConnectivityChanged);

    // If an offline sync completed before or during initialization, trigger it post-frame
    if (OfflineSyncService.syncCompletionNotifier.value != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onOfflineSyncCompleted();
      });
    }
  }

  @override
  void dispose() {
    OfflineSyncService.syncCompletionNotifier.removeListener(
      _onOfflineSyncCompleted,
    );
    OfflineSyncService.syncErrorNotifier.removeListener(
      _onOfflineSyncError,
    );
    OfflineSyncService.pendingSyncCountNotifier.removeListener(
      _onPendingQueueChanged,
    );
    OfflineSyncService.isOnlineNotifier.removeListener(_onConnectivityChanged);
    _streamReconnectTimer?.cancel();
    _incidentStreamSub?.cancel();
    _trackedIncidentNotifier.dispose();
    super.dispose();
  }

  void _onPendingQueueChanged() {
    if (mounted) setState(() {});
  }

  void _onOfflineSyncError() {
    final message = OfflineSyncService.syncErrorNotifier.value;
    if (message == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Error clears the sync success lock so immediate feedback is presented
      _syncSuccessActiveUntil = DateTime.fromMillisecondsSinceEpoch(0);

      _showCentralizedSnackBar(
        backgroundColor: const Color(0xFFB71C1C), // Tactical Red
        duration: const Duration(seconds: 4),
        deduplicationKey: 'sync_error_$message',
        isHighPriority: true,
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _onOfflineSyncCompleted() {
    final message = OfflineSyncService.syncCompletionNotifier.value;
    if (message == null || message.isEmpty) return;

    // Immediately protect the sync success banner from being dismissed/overwritten by routine live telemetry for 5 seconds
    _syncSuccessActiveUntil = DateTime.now().add(
      const Duration(milliseconds: 5000),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _showCentralizedSnackBar(
        backgroundColor: const Color(0xFF2E7D32), // Emerald Green
        duration: const Duration(seconds: 4),
        deduplicationKey:
            'sync_success_${DateTime.now().millisecondsSinceEpoch}',
        isHighPriority: true,
        content: Row(
          children: [
            const Icon(
              Icons.cloud_done_rounded,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 13,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      );
    });

    // Refresh dashboard data quietly with fresh backend telemetry
    if (mounted) {
      _fetchDashboardData(quiet: true);
    }
  }

  void _onConnectivityChanged() {
    final isOnline = OfflineSyncService.isOnlineNotifier.value;
    debugPrint('[HomePage] Connectivity changed: isOnline=$isOnline');
    if (isOnline && mounted) {
      _initLiveTelemetryStream();
    } else if (!isOnline && mounted) {
      _streamReconnectTimer?.cancel();
      _incidentStreamSub?.cancel();
      _incidentStreamSub = null;
    }
  }

  /// Connects to real-time incident telemetry over Serverpod WebSockets.
  void _initLiveTelemetryStream() {
    _streamReconnectTimer?.cancel();
    _incidentStreamSub?.cancel();
    _incidentStreamSub = null;

    // Only attempt streaming if device network is online
    if (!OfflineSyncService.isOnlineNotifier.value) return;

    client.openStreamingConnection();

    try {
      final stream = client.incident.watchIncidents();
      _incidentStreamSub = stream.listen(
        (incident) {
          _onLiveIncidentUpdate(incident);
        },
        onError: (error) {
          debugPrint('[Live Telemetry] WebSocket error: $error');
          // Defer strictly to global network state; do NOT toggle local UI flags
          if (OfflineSyncService.isOnlineNotifier.value && mounted) {
            _scheduleReconnect();
          }
        },
        onDone: () {
          debugPrint('[Live Telemetry] WebSocket closed');
          // Defer strictly to global network state; do NOT toggle local UI flags
          if (OfflineSyncService.isOnlineNotifier.value && mounted) {
            _scheduleReconnect();
          }
        },
        cancelOnError: true,
      );
    } catch (e) {
      debugPrint('[Live Telemetry] Failed to open stream: $e');
      if (OfflineSyncService.isOnlineNotifier.value && mounted) {
        _scheduleReconnect();
      }
    }
  }

  void _scheduleReconnect() {
    _streamReconnectTimer?.cancel();
    _streamReconnectTimer = Timer(const Duration(seconds: 4), () {
      if (mounted && OfflineSyncService.isOnlineNotifier.value) {
        debugPrint('[Live Telemetry] Attempting WebSocket reconnection...');
        _initLiveTelemetryStream();
      }
    });
  }

  /// Dynamically updates the UI feed and map markers upon receiving live telemetry.
  void _onLiveIncidentUpdate(Incident incoming) {
    if (!mounted) return;
    bool isNew = false;
    setState(() {
      final index = _incidents.indexWhere((i) => i.id == incoming.id);
      if (index != -1) {
        _incidents[index] = incoming;
      } else {
        isNew = true;
        _incidents.insert(0, incoming);
      }
    });

    // Trigger high-priority push notification if new incident has critical severity (>= 4)
    if (isNew && incoming.severity >= 4) {
      NotificationService.showCriticalIncidentNotification(incoming);
    }

    _showCentralizedSnackBar(
      backgroundColor: incoming.severity >= 4
          ? const Color(0xFF8B0000)
          : const Color(0xFF1B2B3A),
      duration: const Duration(seconds: 4),
      deduplicationKey: 'live_incident_${incoming.id}_${incoming.status.name}',
      action: SnackBarAction(
        label: 'MAP',
        textColor: const Color(0xFFFFD54F),
        onPressed: () {
          setState(() {
            _currentTabIndex = 1; // Switch to tactical map
            _targetMapLocation = LatLng(
              incoming.centroid.latitude,
              incoming.centroid.longitude,
            );
          });
        },
      ),
      content: Row(
        children: [
          Icon(
            isNew ? Icons.crisis_alert_rounded : Icons.sync_rounded,
            color: incoming.severity >= 4
                ? const Color(0xFFFF5252)
                : const Color(0xFF64B5F6),
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isNew
                      ? '🚨 LIVE TELEMETRY: NEW INCIDENT [SEV ${incoming.severity}]'
                      : '🔄 LIVE TELEMETRY: INCIDENT #${incoming.id} UPDATED',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    letterSpacing: 0.6,
                  ),
                ),
                Text(
                  incoming.summary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFE2E8F0),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Fetches active disaster zones and recent incidents from backend endpoints.
  /// Always saves a local copy to Hive cache. If network request fails, falls back
  /// to cached offline data.
  Future<void> _fetchDashboardData({bool quiet = false}) async {
    if (!mounted) return;
    if (!quiet) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final zonesFuture = client.disasterZone.getAllActiveZones();
      final incidentsFuture = client.incident.getAllRecentIncidents(limit: 50);

      final results = await Future.wait([zonesFuture, incidentsFuture]);
      final freshZones = results[0] as List<DisasterZone>;
      final freshIncidents = results[1] as List<Incident>;

      // Cache fresh data locally to Hive
      await OfflineSyncService.cacheZones(freshZones);
      await OfflineSyncService.cacheIncidents(freshIncidents);

      if (mounted) {
        setState(() {
          _zones = freshZones;
          _incidents = freshIncidents;
          _isLoading = false;
        });
        _isFirstBoot = false;
      }
    } catch (e) {
      debugPrint(
        '[Dashboard] Online fetch failed ($e). Reading from Hive cache...',
      );
      final cachedZones = OfflineSyncService.getCachedZones();
      final cachedIncidents = OfflineSyncService.getCachedIncidents();

      if (mounted) {
        setState(() {
          _zones = cachedZones.isNotEmpty ? cachedZones : _zones;
          _incidents = cachedIncidents.isNotEmpty
              ? cachedIncidents
              : _incidents;
          _isLoading = false;
        });

        // Completely bypass showing amber offline snackbar if _isFirstBoot is true!
        if (!_isFirstBoot && !quiet) {
          if (cachedZones.isNotEmpty || cachedIncidents.isNotEmpty) {
            _showCentralizedSnackBar(
              backgroundColor: const Color(0xFFE65100),
              duration: const Duration(seconds: 4),
              deduplicationKey: 'offline_mode_cached_notice',
              content: const Row(
                children: [
                  Icon(Icons.offline_bolt_rounded, color: Colors.white),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'OFFLINE MODE: Displaying cached emergency telemetry from local storage.',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            );
          } else {
            setState(() {
              _errorMessage =
                  'No network connection and no offline cached data available: $e';
            });
          }
        }
      }
    }
  }

  /// Triggers a manual sync and reconnect attempt when tapping the indicator badge.
  Future<void> _handleManualSyncTap() async {
    _showCentralizedSnackBar(
      content: const Row(
        children: [
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFFFFD54F),
            ),
          ),
          SizedBox(width: 10),
          Text(
            'Verifying connection and processing sync queue...',
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
      duration: const Duration(seconds: 2),
    );

    final serverReachable = await OfflineSyncService.pingServer(client);
    if (!serverReachable) {
      OfflineSyncService.isOnlineNotifier.value = false;
      if (mounted) {
        _showCentralizedSnackBar(
          backgroundColor: const Color(0xFFB71C1C),
          duration: const Duration(seconds: 4),
          deduplicationKey: 'manual_sync_failed',
          isHighPriority: true,
          content: const Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Sync Failed: Server unreachable. Retrying later.',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return;
    }

    OfflineSyncService.isOnlineNotifier.value = true;
    _initLiveTelemetryStream();
    final synced = await OfflineSyncService.processSyncQueue(client);
    await _fetchDashboardData(quiet: true);

    if (!mounted) return;
    if (synced == 0 && OfflineSyncService.pendingSyncCountNotifier.value == 0) {
      _showCentralizedSnackBar(
        content: const Text(
          'Sync queue is up to date.',
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// Seeds realistic mock operations data for demonstration and testing.
  Future<void> _seedMockData() async {
    setState(() => _isActionInProgress = true);
    try {
      final success = await client.ops.seedMockData();
      if (success) {
        if (mounted) {
          _showCentralizedSnackBar(
            backgroundColor: const Color(0xFF2E7D32),
            deduplicationKey: 'seed_mock_success',
            content: const Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'Mock disaster zones & incidents seeded successfully!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }
        await _fetchDashboardData();
      }
    } catch (e) {
      if (mounted) {
        _showCentralizedSnackBar(
          backgroundColor: const Color(0xFFB71C1C),
          deduplicationKey: 'seed_mock_error',
          content: Text('Failed to seed data: $e'),
        );
      }
    } finally {
      if (mounted) setState(() => _isActionInProgress = false);
    }
  }

  bool _isGeneratingPdf = false;

  /// Fetches an AI-synthesized Situation Report and downloads it as a tactical PDF.
  Future<void> _exportSitrepPdf() async {
    if (_isGeneratingPdf) return;
    setState(() => _isGeneratingPdf = true);

    _showCentralizedSnackBar(
      backgroundColor: const Color(0xFF1E293B),
      duration: const Duration(seconds: 4),
      deduplicationKey: 'generating_pdf',
      content: const Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00E5FF)),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Synthesizing AI SitRep & Generating Tactical PDF...',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );

    try {
      final ByteData byteData = await client.sitrep.exportSituationReportPdf();
      final Uint8List bytes = byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      );

      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/Tactical_SitRep.pdf';
      final file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);

      if (mounted) {
        _showCentralizedSnackBar(
          backgroundColor: const Color(0xFF2E7D32),
          duration: const Duration(seconds: 3),
          deduplicationKey: 'pdf_success',
          content: Row(
            children: [
              const Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'SitRep PDF exported (${(bytes.length / 1024).toStringAsFixed(1)} KB). Opening document...',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      final result = await OpenFilex.open(filePath);
      if (result.type != ResultType.done && mounted) {
        _showCentralizedSnackBar(
          backgroundColor: const Color(0xFFE65100),
          content: Text('Could not open PDF viewer: ${result.message}'),
        );
      }
    } catch (e) {
      if (mounted) {
        _showCentralizedSnackBar(
          backgroundColor: const Color(0xFFB71C1C),
          deduplicationKey: 'pdf_error',
          content: Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Failed to export SitRep PDF: $e',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isGeneratingPdf = false);
    }
  }

  /// Updates incident status dynamically.
  /// If offline, queues the action in Hive and updates state locally.
  Future<void> _updateIncidentStatus(
    Incident incident,
    IncidentStatus newStatus,
  ) async {
    if (incident.id == null) return;

    // Fast-path: if currently offline, immediately queue to Hive without waiting for network timeout
    if (!OfflineSyncService.isOnlineNotifier.value) {
      await OfflineSyncService.queueStatusUpdate(incident.id!, newStatus);
      final localUpdated = await OfflineSyncService.updateIncidentStatusInCache(
        incident.id!,
        newStatus,
      );
      if (mounted) {
        setState(() {
          final index = _incidents.indexWhere((i) => i.id == incident.id);
          if (index != -1 && localUpdated != null) {
            _incidents[index] = localUpdated;
          }
        });
        final pending = OfflineSyncService.pendingSyncCountNotifier.value;
        _showCentralizedSnackBar(
          backgroundColor: const Color(0xFFE65100), // Tactical Amber
          duration: const Duration(seconds: 3),
          deduplicationKey: 'offline_queue_${incident.id}_${newStatus.name}',
          content: Row(
            children: [
              const Icon(Icons.cloud_off_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'OFFLINE: Incident #${incident.id} status updated locally to ${newStatus.name.toUpperCase()} ($pending queued for auto-sync).',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        );
      }
      return;
    }

    try {
      final updated = await client.incident.updateIncidentStatus(
        incident.id!,
        newStatus,
      );
      if (updated != null && mounted) {
        setState(() {
          final index = _incidents.indexWhere((i) => i.id == incident.id);
          if (index != -1) {
            _incidents[index] = updated;
          }
        });
        await OfflineSyncService.updateIncidentInCache(updated);
        if (mounted) {
          _showCentralizedSnackBar(
            backgroundColor: const Color(0xFF1E2833),
            duration: const Duration(seconds: 2),
            deduplicationKey: 'status_update_${incident.id}_${newStatus.name}',
            content: Text(
              'Incident #${incident.id} updated to ${newStatus.name.toUpperCase()}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint(
        '[Offline Write] Network failed ($e). Queuing action in Hive sync queue.',
      );
      // 1. Queue action in Hive (synchronously updates pendingSyncCountNotifier)
      await OfflineSyncService.queueStatusUpdate(incident.id!, newStatus);
      // 2. Optimistically update local cache and UI memory state
      final localUpdated = await OfflineSyncService.updateIncidentStatusInCache(
        incident.id!,
        newStatus,
      );
      if (mounted) {
        setState(() {
          final index = _incidents.indexWhere((i) => i.id == incident.id);
          if (index != -1 && localUpdated != null) {
            _incidents[index] = localUpdated;
          }
        });
        final pending = OfflineSyncService.pendingSyncCountNotifier.value;
        _showCentralizedSnackBar(
          backgroundColor: const Color(0xFFE65100), // Tactical Amber
          duration: const Duration(seconds: 3),
          deduplicationKey: 'offline_queue_${incident.id}_${newStatus.name}',
          content: Row(
            children: [
              const Icon(Icons.cloud_off_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'OFFLINE: Incident #${incident.id} status updated locally to ${newStatus.name.toUpperCase()} ($pending queued for auto-sync).',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  /// Confirms and handles tactical session logout.
  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: GlassContainer(
          glowColor: const Color(0xFFEF4444),
          padding: const EdgeInsets.all(20),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.power_settings_new_rounded,
                    color: Color(0xFFEF5350),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'TERMINATE OPS SESSION',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Are you sure you wish to log out of the Emergency Command Portal? '
                'Active telemetry updates will be paused.',
                style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 13),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(color: Color(0xFF94A3B8)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB71C1C),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('DISENGAGE & LOGOUT'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isActionInProgress = true);
      try {
        await sessionManager.signOutDevice();
      } catch (e) {
        debugPrint('Logout warning: $e');
      } finally {
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    UserInfo? user;
    try {
      user = sessionManager.signedInUser;
    } catch (_) {}

    // Filter and dynamically sort incidents: CRITICAL and HIGH severities float to the top
    final filteredIncidents = _incidents.where((i) {
      if (_selectedNeedType != null && i.needType != _selectedNeedType) {
        return false;
      }
      if (_selectedZoneId != null && i.zoneId != _selectedZoneId) {
        return false;
      }
      return true;
    }).toList();

    filteredIncidents.sort((a, b) {
      int getPriorityWeight(Incident inc) {
        final ai = inc.aiSeverity?.toUpperCase();
        if (ai == 'CRITICAL') return 4;
        if (ai == 'HIGH') return 3;
        if (ai == 'MODERATE') return 2;
        if (ai == 'LOW') return 1;
        if (inc.severity >= 5) return 4;
        if (inc.severity >= 4) return 3;
        if (inc.severity >= 3) return 2;
        return 1;
      }

      final weightA = getPriorityWeight(a);
      final weightB = getPriorityWeight(b);
      if (weightA != weightB) {
        return weightB.compareTo(weightA); // Higher priority floats to top
      }
      return b.firstReportAt.compareTo(a.firstReportAt);
    });

    final criticalCount = _incidents.where((i) => i.severity >= 4).length;
    final openCount = _incidents
        .where(
          (i) =>
              i.status == IncidentStatus.open ||
              i.status == IncidentStatus.escalated,
        )
        .length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF151C24),
        elevation: 4,
        shadowColor: Colors.black.withAlpha(150),
        leading: const Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: Icon(
            Icons.crisis_alert_rounded,
            color: Color(0xFFEF5350),
            size: 26,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'RELIEF RADAR',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                fontSize: 16,
              ),
            ),
            GestureDetector(
              onTap: _handleManualSyncTap,
              child: ListenableBuilder(
                listenable: Listenable.merge([
                  OfflineSyncService.isOnlineNotifier,
                  OfflineSyncService.pendingSyncCountNotifier,
                ]),
                builder: (context, _) {
                  return StatusBadge(
                    isOnline: OfflineSyncService.isOnlineNotifier.value,
                    pendingSyncCount:
                        OfflineSyncService.pendingSyncCountNotifier.value,
                    userLabel:
                        user?.email ?? user?.userName ?? 'TACTICAL COMMAND',
                  );
                },
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
            padding: const EdgeInsets.all(6),
            icon: const Icon(Icons.auto_awesome, color: Color(0xFFFFD54F)),
            tooltip: 'AI SOS Triage & Ingest',
            onPressed: () => _showAiTriageModal(context),
          ),
          IconButton(
            constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
            padding: const EdgeInsets.all(6),
            icon: _isGeneratingPdf
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFFF5252),
                      ),
                    ),
                  )
                : const Icon(
                    Icons.picture_as_pdf_rounded,
                    color: Color(0xFFFF5252),
                  ),
            tooltip: 'Export AI SitRep PDF',
            onPressed: _isGeneratingPdf ? null : _exportSitrepPdf,
          ),
          IconButton(
            constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
            padding: const EdgeInsets.all(6),
            icon: const Icon(Icons.settings_ethernet, color: Color(0xFF90CAF9)),
            tooltip: 'Configure Gateway',
            onPressed: () => showGatewayConfigSheet(context),
          ),
          IconButton(
            constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
            padding: const EdgeInsets.all(6),
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            tooltip: 'Refresh Telemetry',
            onPressed: _isLoading ? null : _fetchDashboardData,
          ),
          IconButton(
            constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
            padding: const EdgeInsets.all(6),
            icon: const Icon(
              Icons.power_settings_new_rounded,
              color: Color(0xFFEF5350),
            ),
            tooltip: 'Logout',
            onPressed: _isActionInProgress ? null : _confirmLogout,
          ),
          const SizedBox(width: 6),
        ],
      ),
      floatingActionButton: TactileScaleButton(
        onTap: () => _showAiTriageModal(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE53935), Color(0xFFB71C1C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: const Color(0xFFFF5252).withValues(alpha: 0.8),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD50000).withValues(alpha: 0.45),
                blurRadius: 16,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome, size: 20, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'AI SOS TRIAGE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentTabIndex,
        children: [
          RefreshIndicator(
            onRefresh: _fetchDashboardData,
            color: const Color(0xFFEF5350),
            backgroundColor: const Color(0xFF151C24),
            child: _buildBody(filteredIncidents, criticalCount, openCount),
          ),
          TacticalMapScreen(
            zones: _zones,
            incidents: _incidents,
            onStatusChanged: _updateIncidentStatus,
            targetLocation: _targetMapLocation,
            initialSelectedIncident: _trackedIncident,
            trackedIncidentNotifier: _trackedIncidentNotifier,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF151C24),
          border: Border(
            top: BorderSide(color: Color(0xFF283545), width: 1.0),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentTabIndex,
          onTap: (index) {
            setState(() {
              _currentTabIndex = index;
              if (index == 0) {
                _targetMapLocation = null;
                _trackedIncident = null;
              }
            });
          },
          backgroundColor: const Color(0xFF151C24),
          selectedItemColor: const Color(0xFFEF5350),
          unselectedItemColor: const Color(0xFF94A3B8),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              activeIcon: Icon(
                Icons.dashboard_rounded,
                color: Color(0xFFEF5350),
              ),
              label: 'OPERATIONS FEED',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: criticalCount > 0,
                label: Text('$criticalCount'),
                backgroundColor: const Color(0xFFD50000),
                child: const Icon(Icons.map_rounded),
              ),
              activeIcon: Badge(
                isLabelVisible: criticalCount > 0,
                label: Text('$criticalCount'),
                backgroundColor: const Color(0xFFD50000),
                child: const Icon(Icons.map_rounded, color: Color(0xFFEF5350)),
              ),
              label: 'TACTICAL MAP',
            ),
          ],
        ),
      ),
    );
  }

  /// Sets target location, tracks incident, opens details card, and switches to Tactical Map.
  void _trackIncidentOnMap(Incident incident) {
    setState(() {
      _targetMapLocation = LatLng(
        incident.centroid.latitude,
        incident.centroid.longitude,
      );
      _trackedIncident = incident;
      _currentTabIndex = 1;
    });

    _trackedIncidentNotifier.value = null;
    _trackedIncidentNotifier.value = incident;
  }

  Widget _buildBody(
    List<Incident> filteredIncidents,
    int criticalCount,
    int openCount,
  ) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 44,
              height: 44,
              child: CircularProgressIndicator(
                color: Color(0xFFEF5350),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'SYNCHRONIZING OPERATIONAL TELEMETRY...',
              style: TextStyle(
                color: Color(0xFFCBD5E1),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Target Gateway: ${client.host}',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B1214),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFC62828),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.cloud_off_rounded,
                  color: Color(0xFFEF5350),
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'TELEMETRY LINK INTERRUPTED',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFFFCDD2),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 10,
                children: [
                  ElevatedButton.icon(
                    onPressed: _fetchDashboardData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC62828),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text('RETRY TELEMETRY LINK'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => showGatewayConfigSheet(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF64B5F6),
                      side: const BorderSide(color: Color(0xFF1E3A5F)),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    icon: const Icon(Icons.settings_ethernet, size: 18),
                    label: const Text('CONFIGURE GATEWAY'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    if (_zones.isEmpty && _incidents.isEmpty) {
      return _buildEmptyState();
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        // 1. KPI Overview Metrics Bar
        _buildKpiMetricsBar(criticalCount, openCount),
        const SizedBox(height: 20),

        // 2. Active Disaster Zones Section
        _buildDisasterZonesSection(),
        const SizedBox(height: 20),

        // 3. Need Type Filter Chips
        _buildFilterBar(),
        const SizedBox(height: 14),

        // 4. Incidents Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'LIVE INCIDENTS (${filteredIncidents.length})',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 14,
                letterSpacing: 1.0,
              ),
            ),
            if (_selectedNeedType != null || _selectedZoneId != null)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedNeedType = null;
                    _selectedZoneId = null;
                  });
                },
                child: const Text(
                  'RESET FILTERS',
                  style: TextStyle(
                    color: Color(0xFFEF5350),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),

        // 5. Incident Cards List
        if (filteredIncidents.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF151C24),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF283545)),
            ),
            child: const Center(
              child: Text(
                'No incidents match the active filter criteria.',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
              ),
            ),
          )
        else
          ...filteredIncidents.map(_buildIncidentCard),

        const SizedBox(height: 80),
      ],
    );
  }

  /// Empty state when no zones or incidents exist yet.
  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xFF151C24),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF283545), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(120),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF172C1D),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF2E7D32), width: 2),
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  color: Color(0xFF81C784),
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'ALL SECTORS SECURE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'No active disaster zones or critical emergencies found in the database. '
                'The monitoring grid is currently standing by.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 26),
              ElevatedButton.icon(
                onPressed: _isActionInProgress ? null : _seedMockData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC62828), // Emergency Red
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                ),
                icon: _isActionInProgress
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.bolt_rounded, size: 20),
                label: Text(
                  _isActionInProgress
                      ? 'SEEDING TELEMETRY...'
                      : 'LOAD DEMO DISASTER DATA',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() => _currentTabIndex = 1);
                },
                icon: const Icon(Icons.map_rounded, size: 16),
                label: const Text('OPEN TACTICAL MAP'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF00E5FF),
                  side: const BorderSide(color: Color(0xFF00838F)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _isLoading ? null : _fetchDashboardData,
                icon: const Icon(
                  Icons.refresh,
                  size: 16,
                  color: Color(0xFF94A3B8),
                ),
                label: const Text(
                  'Refresh Telemetry',
                  style: TextStyle(color: Color(0xFF94A3B8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Metric counters bar across top of dashboard.
  Widget _buildKpiMetricsBar(int criticalCount, int openCount) {
    return Row(
      children: [
        Expanded(
          child: _buildKpiCard(
            title: 'ACTIVE ZONES',
            value: _zones.length.toString(),
            icon: Icons.radar_rounded,
            color: const Color(0xFF42A5F5), // Tactical Blue
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildKpiCard(
            title: 'OPEN INCIDENTS',
            value: openCount.toString(),
            icon: Icons.warning_amber_rounded,
            color: const Color(0xFFFFA726), // Amber Warning
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildKpiCard(
            title: 'CRITICAL (SEV 4-5)',
            value: criticalCount.toString(),
            icon: Icons.local_fire_department_rounded,
            color: const Color(0xFFEF5350), // Emergency Crimson
          ),
        ),
      ],
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      builder: (context, animVal, child) {
        return Transform.translate(
          offset: Offset(0, 10 * (1.0 - animVal)),
          child: Opacity(
            opacity: animVal,
            child: child,
          ),
        );
      },
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        borderRadius: BorderRadius.circular(12),
        glowColor: color,
        blurSigma: 12.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 18),
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.7),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFFCBD5E1),
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Carousel of active disaster zones.
  Widget _buildDisasterZonesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'DISASTER SECTORS',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 14,
                letterSpacing: 1.0,
              ),
            ),
            Text(
              '${_zones.length} MONITORED',
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 115,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _zones.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (ctx, i) {
              final zone = _zones[i];
              final isSelected = _selectedZoneId == zone.id;
              final zoneColor = _getZoneKindColor(zone.kind);
              final glow = isSelected ? const Color(0xFFEF5350) : zoneColor;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedZoneId = isSelected ? null : zone.id;
                  });
                },
                child: GlassContainer(
                  width: 220,
                  padding: const EdgeInsets.all(12),
                  borderRadius: BorderRadius.circular(12),
                  glowColor: glow,
                  borderWidth: isSelected ? 1.8 : 1.0,
                  blurSigma: 12.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B1214),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              zone.kind.toUpperCase(),
                              style: const TextStyle(
                                color: Color(0xFFEF5350),
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Icon(
                            isSelected
                                ? Icons.filter_alt
                                : Icons.radar_outlined,
                            size: 16,
                            color: isSelected
                                ? const Color(0xFFEF5350)
                                : const Color(0xFF64748B),
                          ),
                        ],
                      ),
                      Text(
                        zone.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'LAT: ${zone.center.latitude.toStringAsFixed(2)}° | LON: ${zone.center.longitude.toStringAsFixed(2)}°',
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 10,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Need Type Filter selector chips.
  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(
            label: 'ALL TYPES',
            isSelected: _selectedNeedType == null,
            onSelected: () => setState(() => _selectedNeedType = null),
          ),
          const SizedBox(width: 8),
          ...NeedType.values.map((type) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: _buildFilterChip(
                label: type.name.toUpperCase(),
                isSelected: _selectedNeedType == type,
                onSelected: () => setState(() => _selectedNeedType = type),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFC62828) : const Color(0xFF151C24),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFEF5350)
                : const Color(0xFF283545),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF94A3B8),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Color _getAiSeverityColor(String? severity) {
    switch (severity?.toUpperCase()) {
      case 'CRITICAL':
        return const Color(0xFFFF1744); // Neon Emergency Red
      case 'HIGH':
        return const Color(0xFFFF6D00); // Blaze Orange
      case 'MODERATE':
        return const Color(0xFFFFD600); // Tactical Amber
      case 'LOW':
        return const Color(0xFF00E676); // Tactical Green
      default:
        return const Color(0xFF64B5F6);
    }
  }

  /// Triggers on-demand AI triage for an existing incident.
  Future<void> _triggerAiTriageForIncident(Incident incident) async {
    if (incident.id == null) return;
    _showCentralizedSnackBar(
      content: Row(
        children: [
          const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFFFFD54F),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'AI triaging Incident #${incident.id}...',
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
      duration: const Duration(seconds: 2),
    );

    try {
      final updated = await client.aiTriage.triageIncident(incident.id!);
      if (updated != null && mounted) {
        setState(() {
          final idx = _incidents.indexWhere((i) => i.id == incident.id);
          if (idx != -1) _incidents[idx] = updated;
        });
        await OfflineSyncService.updateIncidentInCache(updated);
        _showCentralizedSnackBar(
          backgroundColor: const Color(0xFF2E7D32),
          isHighPriority: true,
          content: Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                color: Color(0xFFFFD54F),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '⚡ AI Triaged Incident #${incident.id} -> ${updated.aiSeverity} [${(updated.aiTags ?? []).join(', ')}]',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showCentralizedSnackBar(
          backgroundColor: const Color(0xFFB71C1C),
          content: Text('AI Triage error: $e'),
        );
      }
    }
  }

  /// Displays the interactive modal allowing the user to feed raw SOS messages into the AI triage system.
  void _showAiTriageModal(BuildContext context) {
    final sosController = TextEditingController();
    int selectedZoneId = _zones.isNotEmpty ? (_zones.first.id ?? 1) : 1;
    NeedType selectedNeed = NeedType.rescue;
    bool isProcessing = false;

    final presets = [
      'Flash flood: 5 civilians trapped on rooftop, water surging rapidly, infant in distress!',
      'Structural collapse: 2 first responders crushed under concrete rubble, severe bleeding.',
      'Refugee camp potable water contamination: 200 civilians requiring urgent medical rations.',
      'Wildfire front expanding toward residential sector, 12 elderly residents isolated.',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return GlassContainer(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              glowColor: const Color(0xFF00E5FF),
              blurSigma: 16.0,
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00E5FF).withAlpha(30),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFF00E5FF)),
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: Color(0xFF00E5FF),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AI EMERGENCY SOS TRIAGE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              Text(
                                'Automated classification, severity scoring & priority dispatch',
                                style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'QUICK SOS TEST PRESETS:',
                      style: TextStyle(
                        color: Color(0xFF64B5F6),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: presets.map((p) {
                        return ActionChip(
                          backgroundColor: const Color(0xFF1E2833),
                          side: const BorderSide(color: Color(0xFF334155)),
                          label: Text(
                            p.length > 38 ? '${p.substring(0, 36)}...' : p,
                            style: const TextStyle(
                              color: Color(0xFFE2E8F0),
                              fontSize: 11,
                            ),
                          ),
                          onPressed: () {
                            setModalState(() {
                              sosController.text = p;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),

                    const Text(
                      'RAW DISTRESS / SOS MESSAGE:',
                      style: TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: sosController,
                      maxLines: 3,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF0F151B),
                        hintText:
                            'Type or paste raw citizen distress call or emergency radio message...',
                        hintStyle: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF334155),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF00E5FF),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Options: Zone & Need Type
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ASSIGNED ZONE',
                                style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<int>(
                                isExpanded: true,
                                initialValue: selectedZoneId,
                                dropdownColor: const Color(0xFF161E27),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFF0F151B),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items: _zones.map((z) {
                                  return DropdownMenuItem<int>(
                                    value: z.id ?? 1,
                                    child: Text(
                                      z.name,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setModalState(() => selectedZoneId = val);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'INITIAL NEED TYPE',
                                style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<NeedType>(
                                isExpanded: true,
                                initialValue: selectedNeed,
                                dropdownColor: const Color(0xFF161E27),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFF0F151B),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items: NeedType.values.map((n) {
                                  return DropdownMenuItem<NeedType>(
                                    value: n,
                                    child: Text(
                                      n.name.toUpperCase(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setModalState(() => selectedNeed = val);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Dispatch Button
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton.icon(
                        onPressed: isProcessing
                            ? null
                            : () async {
                                final text = sosController.text.trim();
                                if (text.isEmpty) {
                                  _showCentralizedSnackBar(
                                    backgroundColor: const Color(0xFFB71C1C),
                                    content: const Text(
                                      'Please enter or select a raw SOS message.',
                                    ),
                                  );
                                  return;
                                }

                                // 1. Immediate offline check: Queue offline if device is already disconnected
                                if (!OfflineSyncService
                                    .isOnlineNotifier
                                    .value) {
                                  OfflineSyncService.queueAiTriage(text);
                                  if (ctx.mounted) {
                                    Navigator.of(ctx).pop();
                                  }
                                  _showCentralizedSnackBar(
                                    backgroundColor: const Color(0xFF1B5E20),
                                    isHighPriority: true,
                                    duration: const Duration(seconds: 4),
                                    content: const Row(
                                      children: [
                                        Icon(
                                          Icons.cloud_off_rounded,
                                          color: Color(0xFFFFD54F),
                                          size: 22,
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            'SOS saved offline. Will auto-post when network is restored.',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                  return;
                                }

                                setModalState(() => isProcessing = true);
                                try {
                                  final activeZone = _zones.firstWhere(
                                    (z) => z.id == selectedZoneId,
                                    orElse: () => _zones.isNotEmpty
                                        ? _zones.first
                                        : DisasterZone(
                                            id: selectedZoneId > 0
                                                ? selectedZoneId
                                                : 1,
                                            name: 'Zone Sector',
                                            kind: 'flood',
                                            center: GeographyPoint(
                                              latitude: 19.0760,
                                              longitude: 72.8777,
                                            ),
                                          ),
                                  );

                                  final targetZoneId =
                                      activeZone.id ??
                                      (selectedZoneId > 0 ? selectedZoneId : 1);

                                  debugPrint(
                                    '[AiTriage] Submitting SOS: zone=$targetZoneId, need=$selectedNeed, text=$text',
                                  );

                                  final newIncident = await client.aiTriage
                                      .ingestAndTriageSos(
                                        zoneId: targetZoneId,
                                        needType: selectedNeed,
                                        rawSosDescription: text,
                                        latitude:
                                            activeZone.center.latitude + 0.002,
                                        longitude:
                                            activeZone.center.longitude + 0.002,
                                      )
                                      .timeout(const Duration(seconds: 15));

                                  debugPrint(
                                    '[AiTriage] SOS Ingestion Succeeded: Incident #${newIncident.id} -> ${newIncident.aiSeverity}',
                                  );

                                  if (ctx.mounted) {
                                    Navigator.of(ctx).pop();
                                  }

                                  if (mounted) {
                                    setState(() {
                                      // Clear any active filters so the new incident is immediately visible on dashboard
                                      _selectedNeedType = null;
                                      _selectedZoneId = null;
                                      _incidents.removeWhere(
                                        (i) => i.id == newIncident.id,
                                      );
                                      _incidents.insert(0, newIncident);
                                    });

                                    await OfflineSyncService.updateIncidentInCache(
                                      newIncident,
                                    );

                                    _showCentralizedSnackBar(
                                      backgroundColor: const Color(0xFF1B5E20),
                                      isHighPriority: true,
                                      duration: const Duration(seconds: 4),
                                      content: Row(
                                        children: [
                                          const Icon(
                                            Icons.auto_awesome,
                                            color: Color(0xFFFFD54F),
                                            size: 22,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              '⚡ AI TRIAGED -> ${newIncident.aiSeverity}! Dispatched Incident #${newIncident.id} [${(newIncident.aiTags ?? []).join(', ')}]',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                } catch (e, st) {
                                  debugPrint(
                                    '[AiTriage] Ingest SOS failed: $e\n$st',
                                  );
                                  setModalState(() => isProcessing = false);

                                  if (ctx.mounted) {
                                    Navigator.of(ctx).pop();
                                  }

                                  final errStr = e.toString();
                                  final isNetworkError =
                                      e is SocketException ||
                                      e is ServerpodClientNetworkException ||
                                      errStr.contains('Connection refused') ||
                                      errStr.contains('errno = 111') ||
                                      errStr.contains('errno = 103') ||
                                      errStr.contains('Failed host lookup') ||
                                      errStr.contains(
                                        'Software caused connection abort',
                                      ) ||
                                      errStr.contains(
                                        'Network is unreachable',
                                      ) ||
                                      errStr.contains('SocketException') ||
                                      errStr.contains('TimeoutException');

                                  // If offline or server cannot be reached, do not display Connection refused
                                  // Instead, queue offline and present success confirmation banner
                                  if (isNetworkError) {
                                    OfflineSyncService.queueAiTriage(text);
                                    OfflineSyncService.isOnlineNotifier.value =
                                        false;

                                    _showCentralizedSnackBar(
                                      backgroundColor: const Color(0xFF1B5E20),
                                      isHighPriority: true,
                                      duration: const Duration(seconds: 4),
                                      content: const Row(
                                        children: [
                                          Icon(
                                            Icons.cloud_off_rounded,
                                            color: Color(0xFFFFD54F),
                                            size: 22,
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              'SOS saved offline. Will auto-post when network is restored.',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                    return;
                                  }

                                  _showCentralizedSnackBar(
                                    backgroundColor: const Color(0xFFB71C1C),
                                    isHighPriority: true,
                                    duration: const Duration(seconds: 6),
                                    content: Row(
                                      children: [
                                        const Icon(
                                          Icons.error_outline_rounded,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            'SOS Triage Failed: $errStr',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                        icon: isProcessing
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.flash_on_rounded, size: 20),
                        label: Text(
                          isProcessing
                              ? 'AI CLASSIFYING DISTRESS...'
                              : 'RUN AI TRIAGE & DISPATCH',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD32F2F),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Individual Incident card with status update action and AI triage badges.
  Widget _buildIncidentCard(Incident incident) {
    final severityColor = _getSeverityColor(incident.severity);
    final statusColor = _getStatusColor(incident.status);
    final aiColor = _getAiSeverityColor(incident.aiSeverity);
    final isCriticalOrHigh =
        incident.aiSeverity == 'CRITICAL' ||
        incident.aiSeverity == 'HIGH' ||
        incident.severity >= 4;

    final cardBorderColor = isCriticalOrHigh
        ? aiColor.withValues(alpha: 0.70)
        : const Color(0xFF00E5FF).withValues(alpha: 0.25);
    final cardBorderWidth = isCriticalOrHigh ? 1.8 : 1.0;

    final cardGlowShadow = [
      BoxShadow(
        color: (isCriticalOrHigh ? aiColor : const Color(0xFF00E5FF))
            .withValues(alpha: 0.20),
        blurRadius: isCriticalOrHigh ? 16 : 10,
        spreadRadius: isCriticalOrHigh ? 1.5 : 0.5,
        offset: const Offset(0, 4),
      ),
    ];

    return TweenAnimationBuilder<double>(
      key: ValueKey(incident.id ?? incident.summary),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      builder: (context, animValue, child) {
        return Opacity(
          opacity: animValue,
          child: Transform.translate(
            offset: Offset(0, 14 * (1.0 - animValue)),
            child: child,
          ),
        );
      },
      child: GlassContainer(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(16),
        backgroundColor: const Color(0xFF1E2732).withValues(alpha: 0.70),
        borderColor: cardBorderColor,
        borderWidth: cardBorderWidth,
        blurSigma: 10.0,
        boxShadow: cardGlowShadow,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: AI Severity, Numeric Severity, NeedType badge, and Status Dropdown
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // AI Severity Badge
                if (incident.aiSeverity != null &&
                    incident.aiSeverity!.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: aiColor.withAlpha(35),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: aiColor, width: 1.2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome, color: aiColor, size: 11),
                        const SizedBox(width: 4),
                        Text(
                          'AI: ${incident.aiSeverity!.toUpperCase()}',
                          style: TextStyle(
                            color: aiColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                ],

                // Standard Severity badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: severityColor.withAlpha(40),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: severityColor),
                  ),
                  child: Text(
                    'SEV ${incident.severity}',
                    style: TextStyle(
                      color: severityColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 6),

                // NeedType badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2833),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getNeedIcon(incident.needType),
                        size: 11,
                        color: const Color(0xFFCBD5E1),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        incident.needType.name.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFFCBD5E1),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Status Dropdown Selector
                PopupMenuButton<IncidentStatus>(
                  initialValue: incident.status,
                  color: const Color(0xFF161E27),
                  onSelected: (newStatus) {
                    _updateIncidentStatus(incident, newStatus);
                  },
                  itemBuilder: (ctx) {
                    return IncidentStatus.values.map((status) {
                      return PopupMenuItem(
                        value: status,
                        child: Text(
                          status.name.toUpperCase(),
                          style: TextStyle(
                            color: _getStatusColor(status),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: statusColor.withAlpha(180)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          incident.status.name.toUpperCase(),
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_drop_down,
                          color: statusColor,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Incident Summary
            Text(
              incident.summary,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),

            // AI Tags Chips (Clean Tactical Cyan Design)
            if (incident.aiTags != null && incident.aiTags!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: incident.aiTags!.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D2238),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: const Color(0xFF0288D1).withAlpha(160),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.tag_rounded,
                          color: Color(0xFF4FC3F7),
                          size: 10,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          tag,
                          style: const TextStyle(
                            color: Color(0xFFE1F5FE),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],

            // Vulnerabilities Tags (Excludes any tags already rendered in AI Tags)
            () {
              final distinctVulnerabilities = incident.vulnerabilities.where((
                v,
              ) {
                final norm = v.trim().toLowerCase();
                if (incident.aiTags != null &&
                    incident.aiTags!.any(
                      (t) => t.trim().toLowerCase() == norm,
                    )) {
                  return false;
                }
                return true;
              }).toList();

              if (distinctVulnerabilities.isEmpty) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: distinctVulnerabilities.map((v) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF241C16),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFFE65100)),
                      ),
                      child: Text(
                        '⚠️ $v',
                        style: const TextStyle(
                          color: Color(0xFFFFB74D),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }(),

            const SizedBox(height: 10),

            // Footer info: Coordinates & SLA
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'COORDS: ${incident.centroid.latitude.toStringAsFixed(3)}°, ${incident.centroid.longitude.toStringAsFixed(3)}°',
                  style: const TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontSize: 10,
                    fontFamily: 'monospace',
                  ),
                ),
                Text(
                  'SLA: ${incident.baseSlaSeconds}s',
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Actions: Track on Map & On-demand AI Re-triage
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _trackIncidentOnMap(incident),
                    icon: const Icon(Icons.pin_drop_rounded, size: 14),
                    label: const Text('MAP TRACK'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF00E5FF),
                      side: const BorderSide(color: Color(0xFF00838F)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () => _triggerAiTriageForIncident(incident),
                  icon: const Icon(Icons.auto_awesome, size: 13),
                  label: const Text('AI RE-TRIAGE'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFFFD54F),
                    side: const BorderSide(color: Color(0xFFFFA000)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(int severity) {
    switch (severity) {
      case 5:
        return const Color(0xFFD50000); // Critical Deep Red
      case 4:
        return const Color(0xFFEF5350); // High Red
      case 3:
        return const Color(0xFFFFA726); // Moderate Amber
      case 2:
        return const Color(0xFFFFEE58); // Low Yellow
      default:
        return const Color(0xFF42A5F5); // Advisory Blue
    }
  }

  Color _getZoneKindColor(String kind) {
    switch (kind.toLowerCase()) {
      case 'flood':
        return const Color(0xFF00BCD4);
      case 'cyclone':
        return const Color(0xFFAB47BC);
      case 'landslide':
        return const Color(0xFFFF7043);
      case 'earthquake':
        return const Color(0xFFE53935);
      default:
        return const Color(0xFFFF9800);
    }
  }

  Color _getStatusColor(IncidentStatus status) {
    switch (status) {
      case IncidentStatus.open:
      case IncidentStatus.escalated:
        return const Color(0xFFEF5350);
      case IncidentStatus.assigned:
      case IncidentStatus.enRoute:
      case IncidentStatus.onScene:
        return const Color(0xFFFFA726);
      case IncidentStatus.resolved:
        return const Color(0xFF66BB6A);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  IconData _getNeedIcon(NeedType type) {
    switch (type) {
      case NeedType.rescue:
        return Icons.health_and_safety_rounded;
      case NeedType.medical:
        return Icons.medical_services_rounded;
      case NeedType.water:
        return Icons.water_drop_rounded;
      case NeedType.food:
        return Icons.restaurant_rounded;
      case NeedType.shelter:
        return Icons.roofing_rounded;
      case NeedType.evacuation:
        return Icons.directions_run_rounded;
      default:
        return Icons.report_problem_rounded;
    }
  }
}

/// Inline subtitle row showing user identity + connection status badge.
/// Status logic:
/// - 🟢 LIVE     — online, no pending items
/// - 🔵 SYNCING  — online, flushing queued items
/// - 🔴 OFFLINE  — no server connection
class StatusBadge extends StatefulWidget {
  final bool isOnline;
  final int pendingSyncCount;
  final String userLabel;

  const StatusBadge({
    super.key,
    this.isOnline = true,
    this.pendingSyncCount = 0,
    this.userLabel = 'TACTICAL COMMAND',
  });

  @override
  State<StatusBadge> createState() => _StatusBadgeState();
}

class _StatusBadgeState extends State<StatusBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = widget.isOnline;
    final pending = widget.pendingSyncCount;

    // Three distinct states:
    // online + empty  => LIVE (green)
    // online + queued => SYNCING (blue)
    // offline         => OFFLINE (amber)
    final bool isLive = isOnline && pending == 0;
    final bool isSyncing = isOnline && pending > 0;

    final Color dotColor;
    final String statusText;

    if (isLive) {
      dotColor = const Color(0xFF4CAF50);
      statusText = '● LIVE';
    } else if (isSyncing) {
      dotColor = const Color(0xFF42A5F5);
      statusText = '↑ SYNCING ($pending)';
    } else {
      dotColor = const Color(0xFFFFB300);
      statusText = pending > 0 ? '✕ OFFLINE ($pending)' : '✕ OFFLINE';
    }

    final statusWidget = FadeTransition(
      opacity: isLive ? _pulse : const AlwaysStoppedAnimation(1.0),
      child: Text(
        statusText,
        style: TextStyle(
          color: dotColor,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
        ),
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            widget.userLabel,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          '·',
          style: TextStyle(color: Color(0xFF4A5568), fontSize: 10),
        ),
        const SizedBox(width: 6),
        Tooltip(
          message: isLive
              ? 'Command Server Online — Telemetry Live'
              : isSyncing
              ? 'Syncing $pending offline action(s) to server. Tap to force sync.'
              : pending > 0
              ? '$pending offline action(s) queued. Tap to reconnect and sync.'
              : 'No server connection — tap to retry',
          child: statusWidget,
        ),
      ],
    );
  }
}
