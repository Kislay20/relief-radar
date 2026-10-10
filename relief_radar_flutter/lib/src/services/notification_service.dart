import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:relief_radar_client/relief_radar_client.dart';

/// Service managing high-priority local push notifications for urgent incident telemetry.
class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String criticalChannelId = 'relief_radar_critical_alerts_v2';
  static const String criticalChannelName = 'Critical Relief Radar SOS Alerts';

  static bool _isInitialized = false;

  /// Initializes the local notifications plugin and notification channels.
  static Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const darwinSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
        macOS: darwinSettings,
      );

      await _notificationsPlugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (response) {
          debugPrint(
            '[NotificationService] Notification tapped: ${response.payload}',
          );
        },
      );

      // On Android 13+ (API 33+), request notification permissions and register high-priority channel with custom siren
      if (!kIsWeb && Platform.isAndroid) {
        final androidPlugin = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        await androidPlugin?.requestNotificationsPermission();

        const channel = AndroidNotificationChannel(
          criticalChannelId,
          criticalChannelName,
          description:
              'High-priority alerts for emergency incidents (Severity >= 4)',
          importance: Importance.max,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('siren'),
          enableVibration: true,
        );
        await androidPlugin?.createNotificationChannel(channel);
      }

      _isInitialized = true;
      debugPrint(
        '[NotificationService] Initialized successfully with custom siren channel.',
      );
    } catch (e) {
      debugPrint('[NotificationService] Initialization error: $e');
    }
  }

  /// Triggers a high-priority local push notification for critical emergency incidents (severity >= 4).
  static Future<void> showCriticalIncidentNotification(
    Incident incident,
  ) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      final need = incident.needType.name.toUpperCase();
      final locationStr =
          '${incident.centroid.latitude.toStringAsFixed(4)}, ${incident.centroid.longitude.toStringAsFixed(4)}';
      final title = '🚨 CRITICAL SOS: $need at $locationStr';
      final body = incident.summary.trim().isNotEmpty
          ? incident.summary.trim()
          : 'High-severity emergency alert reported. Immediate responder deployment needed.';

      // Create a style with dynamic text and custom siren sound
      final dynamicAndroidDetails = AndroidNotificationDetails(
        criticalChannelId,
        criticalChannelName,
        channelDescription:
            'High-priority alerts for emergency incidents (Severity >= 4)',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'CRITICAL SOS ALERT',
        sound: const RawResourceAndroidNotificationSound('siren'),
        playSound: true,
        enableVibration: true,
        styleInformation: BigTextStyleInformation(
          body,
          contentTitle: title,
          summaryText: 'SEV ${incident.severity} EMERGENCY',
        ),
      );

      final finalDetails = NotificationDetails(
        android: dynamicAndroidDetails,
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          interruptionLevel: InterruptionLevel.critical,
        ),
      );

      final notificationId =
          (incident.id ?? DateTime.now().millisecondsSinceEpoch) % 100000;

      await _notificationsPlugin.show(
        id: notificationId,
        title: title,
        body: body,
        notificationDetails: finalDetails,
        payload: 'incident_${incident.id}',
      );
      debugPrint(
        '[NotificationService] Critical notification dispatched for incident #${incident.id}',
      );
    } catch (e) {
      debugPrint('[NotificationService] Error showing notification: $e');
    }
  }
}
