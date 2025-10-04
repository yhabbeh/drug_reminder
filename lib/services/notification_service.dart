import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(settings);
  }

  Future<void> show(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'reminder_channel',
          'Reminders',
          importance: Importance.max,
          priority: Priority.high,
        );

    await _plugin.show(
      0,
      title,
      body,
      const NotificationDetails(android: androidDetails),
    );
  }

  Future<void> schedule(
    int id,
    String title,
    String body,
    DateTime dateTime,
  ) async {
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails('reminder_channel', 'Reminders'),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleDaily(
    int id,
    String title,
    String body,
    DateTime time,
  ) async {
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.local(
        time.year,
        time.month,
        time.day,
        time.hour,
        time.minute,
      ),
      const NotificationDetails(
        android: AndroidNotificationDetails('reminder_channel', 'Reminders'),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // daily at same time
    );
  }

  Future<void> scheduleWeekly(
    int id,
    String title,
    String body,
    DateTime time,
  ) async {
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.local(
        time.year,
        time.month,
        time.day,
        time.hour,
        time.minute,
      ),
      const NotificationDetails(
        android: AndroidNotificationDetails('reminder_channel', 'Reminders'),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime, // weekly
    );
  }
}
