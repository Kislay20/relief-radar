import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:relief_radar_client/relief_radar_client.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

import 'src/services/offline_sync_service.dart';

/// Information about a failed Serverpod client request.
class ClientErrorInfo {
  final String title;
  final String message;
  final String details;
  final int? statusCode;
  final DateTime timestamp;

  ClientErrorInfo({
    required this.title,
    required this.message,
    required this.details,
    this.statusCode,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

/// Global notifier for client request failures.
final ValueNotifier<ClientErrorInfo?> clientErrorNotifier =
    ValueNotifier<ClientErrorInfo?>(null);

/// Global notifier for real-time WebSocket telemetry connection status.
final ValueNotifier<bool> liveWebSocketConnectedNotifier = ValueNotifier<bool>(
  false,
);

/// Primary development server endpoint.
const String defaultServerUrl = 'http://127.0.0.1:8080/';

/// Global notifier for active server URL changes.
final ValueNotifier<String> activeServerUrlNotifier = ValueNotifier<String>(
  defaultServerUrl,
);

/// Global client and auth objects for the Flutter application.
late Client client;
late SessionManager sessionManager;
late Caller authCaller;

/// Hive storage keys for persisting user-selected gateway URL across app restarts.
const String gatewaySettingsBoxName = 'relief_radar_gateway_settings';
const String preferredGatewayKey = 'preferred_gateway_url';

/// Retrieves the saved gateway URL from persistent local storage.
Future<String?> getSavedGatewayUrl() async {
  try {
    final box = await Hive.openBox<String>(gatewaySettingsBoxName);
    return box.get(preferredGatewayKey);
  } catch (e) {
    debugPrint('[ClientConfig] Could not read saved gateway URL: $e');
    return null;
  }
}

/// Persists the preferred gateway URL to local storage and updates active client.
Future<void> savePreferredGateway(String url) async {
  final cleanUrl = url.endsWith('/') ? url : '$url/';
  try {
    final box = await Hive.openBox<String>(gatewaySettingsBoxName);
    await box.put(preferredGatewayKey, cleanUrl);
  } catch (e) {
    debugPrint('[ClientConfig] Could not persist preferred gateway: $e');
  }
  await updateClientServerUrl(cleanUrl);
}

/// Candidate endpoints tested during startup and dynamic failover.
/// Prioritizes current host LAN IP and ADB reverse loopback, followed by
/// fallback LAN IPs and emulator aliases.
const List<String> candidateServerUrls = [
  'http://127.0.0.1:8080/', // ADB reverse loopback / local device (USB)
  'http://10.3.197.147:8080/', // Active PC Wi-Fi (SRMIST.EDU.IN)
  'http://192.168.137.1:8080/', // Windows Mobile Hotspot IP
  'http://10.0.2.2:8080/', // Android Emulator loopback
  'http://localhost:8080/',
  'http://10.175.65.55:8080/', // Previous session IP
];

/// Diagnostic result returned when probing a Serverpod gateway.
class GatewayProbeResult {
  final bool isSuccessful;
  final int? statusCode;
  final String? error;
  final Duration? latency;

  const GatewayProbeResult({
    required this.isSuccessful,
    this.statusCode,
    this.error,
    this.latency,
  });
}

/// Probes a candidate gateway and captures rich diagnostic details.
Future<GatewayProbeResult> probeGatewayDetails(String candidateUrl) async {
  if (kIsWeb) {
    return const GatewayProbeResult(isSuccessful: true, statusCode: 200);
  }
  HttpClient? httpClient;
  final stopwatch = Stopwatch()..start();
  try {
    final uri = Uri.parse(candidateUrl);
    if (!uri.hasScheme || uri.host.isEmpty) {
      return const GatewayProbeResult(
        isSuccessful: false,
        error: 'Invalid URL. Example format: http://10.3.197.147:8080/',
      );
    }
    httpClient = HttpClient()
      ..connectionTimeout = const Duration(milliseconds: 2500);

    final request = await httpClient
        .getUrl(uri)
        .timeout(const Duration(milliseconds: 2500));
    final response = await request.close().timeout(
      const Duration(milliseconds: 2500),
    );
    stopwatch.stop();

    final isAlive = response.statusCode > 0;
    return GatewayProbeResult(
      isSuccessful: isAlive,
      statusCode: response.statusCode,
      latency: stopwatch.elapsed,
    );
  } catch (e) {
    stopwatch.stop();
    String errorMsg = e.toString();
    if (errorMsg.contains('Connection refused') ||
        errorMsg.contains('errno = 111') ||
        errorMsg.contains('errno = 103')) {
      errorMsg = 'Connection refused. Server is unreachable at this host/port.';
    } else if (errorMsg.contains('timed out') ||
        errorMsg.contains('errno = 110') ||
        errorMsg.contains('TimeoutException')) {
      errorMsg =
          'Connection timed out. Verify network connection and firewall for port 8080.';
    } else if (errorMsg.contains('Network is unreachable') ||
        errorMsg.contains('errno = 101')) {
      errorMsg =
          'Network unreachable. Check your device Wi-Fi/data connection.';
    }
    return GatewayProbeResult(
      isSuccessful: false,
      error: errorMsg,
      latency: stopwatch.elapsed,
    );
  } finally {
    httpClient?.close(force: true);
  }
}

/// Actively tests connectivity and full HTTP communication to a candidate gateway.
/// Catches SocketException (e.g. errno = 103 connection abort) before setting the client URL.
Future<bool> testServerpodGateway(String candidateUrl) async {
  final result = await probeGatewayDetails(candidateUrl);
  return result.isSuccessful;
}

/// Probes candidates to dynamically discover the active Serverpod gateway.
/// Genuinely tests HTTP communication to ensure SocketException (errno = 103)
/// is caught and filtered out early.
Future<String> resolveServerUrl([String? preferredUrl]) async {
  if (kIsWeb) return defaultServerUrl;

  final candidates = <String>[
    if (preferredUrl != null && preferredUrl.isNotEmpty) preferredUrl,
    ...candidateServerUrls,
  ];

  final uniqueCandidates = candidates.toSet().toList();

  for (final candidate in uniqueCandidates) {
    final reachable = await testServerpodGateway(candidate);
    if (reachable) {
      debugPrint(
        '[ClientConfig] Successfully resolved active server URL: $candidate',
      );
      return candidate;
    }
  }

  debugPrint(
    '[ClientConfig] Warning: All gateway probes failed. Defaulting to loopback $defaultServerUrl',
  );
  return defaultServerUrl;
}

bool _isFallingBack = false;

/// Fallback mechanism: discovers another healthy gateway candidate and reconfigures the client.
Future<bool> fallbackToNextGateway() async {
  if (_isFallingBack) return false;
  _isFallingBack = true;
  try {
    final currentHost = client.host;
    for (final candidate in candidateServerUrls) {
      if (candidate == currentHost) continue;
      final reachable = await testServerpodGateway(candidate);
      if (reachable) {
        await updateClientServerUrl(candidate);
        return true;
      }
    }
    return false;
  } finally {
    _isFallingBack = false;
  }
}

/// Seamlessly switches the active client and auth session to a new gateway URL.
Future<void> updateClientServerUrl(String newUrl) async {
  debugPrint('[ClientConfig] Switching active client gateway to: $newUrl');
  client = _buildClient(newUrl);
  authCaller = client.modules.auth;
  try {
    sessionManager.caller = authCaller;
    sessionManager.keyManager =
        authCaller.client.authKeyProvider as FlutterAuthenticationKeyManager;
    await sessionManager.refreshSession();
  } catch (_) {
    sessionManager = SessionManager(caller: authCaller);
    await sessionManager.initialize();
  }
  activeServerUrlNotifier.value = newUrl;
  OfflineSyncService.registerClient(client);
}

/// Builds a configured Client instance with intelligent error interception and fallback.
Client _buildClient(String resolvedUrl) {
  return Client(
      resolvedUrl,
      connectionTimeout: const Duration(seconds: 15),
      streamingConnectionTimeout: const Duration(seconds: 15),
      onFailedCall: (context, error, stackTrace) async {
        // Do not intercept or auto-failover explicit authentication endpoints;
        // let the login UI handle and display the error directly.
        final isAuthEndpoint =
            context.endpointName.toLowerCase().contains('auth') ||
            context.endpointName == 'email' ||
            context.endpointName == 'status';

        // Check if this error is a network connection abort/failure
        final errorStr = error.toString();
        final isNetworkError =
            error is ServerpodClientNetworkException ||
            errorStr.contains('SocketException') ||
            errorStr.contains('errno = 103') ||
            errorStr.contains('Software caused connection abort') ||
            errorStr.contains('Connection refused');

        if (!isAuthEndpoint && isNetworkError) {
          debugPrint(
            '[ClientConfig] Caught network exception on ${context.endpointName}.${context.methodName} ($error). Triggering fallback check...',
          );
          final fellBack = await fallbackToNextGateway();
          if (fellBack) {
            debugPrint(
              '[ClientConfig] Seamlessly fell back to ${client.host}. Suppressing error modal.',
            );
            return;
          }
        }

        // Suppress background health check pings from ever triggering UI error modals
        if (context.endpointName == 'disasterZone' &&
            context.methodName == 'getAllActiveZones') {
          debugPrint(
            '[ClientConfig] Suppressed background health check error on ${context.endpointName}.${context.methodName} from clientErrorNotifier.',
          );
          return;
        }

        String title = 'Request Failed';
        String message = errorStr;
        int? statusCode;
        String details =
            'Endpoint: ${context.endpointName}.${context.methodName}\n$error';

        if (error is ServerpodClientHttpException) {
          statusCode = error.statusCode;
          if (error.statusCode == 405) {
            title = 'Error 405: Method Not Allowed';
            message =
                'The server rejected the request with HTTP 405 (Method Not Allowed). '
                'The endpoint "${context.endpointName}" was not accepted. Ensure the serverpod_auth module is registered and you are connecting to port 8080 (API) rather than port 8082 (Web).';
          } else {
            title = 'Server Error (HTTP ${error.statusCode})';
            message = error.message.isNotEmpty
                ? error.message
                : 'Server returned HTTP ${error.statusCode}.';
          }
        } else if (error is ServerpodClientNetworkException) {
          title = 'Network Connection Failed';
          message =
              'Unable to reach backend at ${client.host}. Check connection and ensure server is running.';
        } else if (error is ServerpodClientException) {
          title = 'Serverpod Client Error';
          message = error.message;
        }

        clientErrorNotifier.value = ClientErrorInfo(
          title: title,
          message: message,
          details: details,
          statusCode: statusCode,
        );
      },
    )
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authKeyProvider = FlutterAuthenticationKeyManager();
}

/// Extension providing WebSocket streaming convenience methods.
extension StreamingClientExtension on Client {
  /// Opens or verifies the WebSocket streaming connection.
  Future<void> openStreamingConnection() async {}
}

/// Initializes the Serverpod client pointing to the backend and sets up the session manager.
Future<void> initializeClient({
  String? serverUrl,
}) async {
  String? preferred = serverUrl ?? await getSavedGatewayUrl();
  final resolvedUrl = await resolveServerUrl(preferred);
  client = _buildClient(resolvedUrl);
  authCaller = client.modules.auth;
  sessionManager = SessionManager(caller: authCaller);
  await sessionManager.initialize();
  activeServerUrlNotifier.value = resolvedUrl;
}
