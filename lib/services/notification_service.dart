import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Set to true in tests to bypass native channel calls.
  static bool isTest = false;

  /// Initialize the notification settings.
  static Future<void> init() async {
    if (isTest) {
      print('--- NOTIFICATION SERVICE: Skipping init in test mode');
      return;
    }
    tz.initializeTimeZones();

    // Android: uses launcher icon as default for notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS/macOS settings
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false, // Request explicitly in UI
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification click if needed
      },
    );
  }

  /// Request permissions dynamically.
  static Future<bool> requestPermissions() async {
    if (isTest) {
      print('--- NOTIFICATION SERVICE: Bypassing requestPermissions in test mode');
      return true;
    }
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      return await androidImplementation?.requestNotificationsPermission() ?? false;
    } else if (Platform.isIOS) {
      return await _notificationsPlugin
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(
                alert: true,
                badge: true,
                sound: true,
              ) ??
          false;
    } else if (Platform.isMacOS) {
      return await _notificationsPlugin
              .resolvePlatformSpecificImplementation<
                  MacOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(
                alert: true,
                badge: true,
                sound: true,
              ) ??
          false;
    }
    return true;
  }

  /// Fire an immediate notification (useful for mileage-based triggers).
  static Future<void> showImmediateNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (isTest) {
      print('--- NOTIFICATION SERVICE (MOCK SHOW): id=$id, title="$title", body="$body"');
      return;
    }
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'maintenance_reminders',
      'Maintenance Reminders',
      channelDescription: 'Alerts when maintenance is due soon or overdue',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    await _notificationsPlugin.show(id, title, body, platformDetails, payload: payload);
  }

  /// Schedule a notification for a future date (useful for time-based triggers).
  /// Uses UTC to avoid needing complex native timezone package integration.
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    if (isTest) {
      print('--- NOTIFICATION SERVICE (MOCK SCHEDULE): id=$id, title="$title", body="$body", date=$scheduledDate');
      return;
    }
    // Do not schedule in the past
    if (scheduledDate.isBefore(DateTime.now())) {
      return;
    }

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'scheduled_reminders',
      'Scheduled Reminders',
      channelDescription: 'Timed reminders for maintenance tasks',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const DarwinNotificationDetails darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate.toUtc(), tz.UTC),
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  /// Cancel a specific notification.
  static Future<void> cancelNotification(int id) async {
    if (isTest) {
      print('--- NOTIFICATION SERVICE (MOCK CANCEL): id=$id');
      return;
    }
    await _notificationsPlugin.cancel(id);
  }

  /// Cancel all notifications.
  static Future<void> cancelAllNotifications() async {
    if (isTest) {
      print('--- NOTIFICATION SERVICE (MOCK CANCEL ALL)');
      return;
    }
    await _notificationsPlugin.cancelAll();
  }
}
