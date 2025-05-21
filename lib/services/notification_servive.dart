import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugins =
      FlutterLocalNotificationsPlugin();

  static Future<void> initNotification() async {
    try {
      AndroidInitializationSettings initializationSettingsAndroid =
          const AndroidInitializationSettings('@mipmap/ic_launcher');

      var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );
      await notificationsPlugins.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (details) async {
          print(" --- received notification on tap: ${details.payload}");
        },
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );
    } catch (e) {
      print(" --- error in notification init: ${e.toString()}");
    }
  }

  static notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.max,
        // fullScreenIntent: true
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payLoad,
  }) async {
    print("_____* show notification");
    return notificationsPlugins.show(
      id,
      title,
      body,
      await notificationDetails(),
    );
  }

  static Future scheduleNotification({
    int id = 1,
    String? title,
    String? body,
    String? payLoad,
    required DateTime scheduledNotificationDateTime,
  }) async {
    print("**** START Schedule Notification");
    print("scheduled time: $scheduledNotificationDateTime");
    print("tz local: ${tz.local}");
    var time = tz.TZDateTime.from(scheduledNotificationDateTime, tz.local);
    return notificationsPlugins
        .zonedSchedule(
          id,
          'Canadian Citizenship',
          body,
          time,
          await notificationDetails(),
          payload: body,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          // uiLocalNotificationDateInterpretation:
          //     UILocalNotificationDateInterpretation.absoluteTime,
        )
        .then((value) => print("**** END Schedule Notification"));
  }

  static void cancelAllNotification() {
    notificationsPlugins.cancelAll();
  }

  static void cancelNotification(int id) {
    notificationsPlugins.cancel(id);
  }

  static Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
  }) async {
    // Get current date and time in local timezone
    final now = tz.TZDateTime.now(tz.local);

    print("Current time: ${now.hour}:${now.minute}");
    print("Scheduled time: ${time.hour}:${time.minute}");

    // Convert TimeOfDay to TZDateTime for today
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // Debug comparison
    print("Is before check: ${scheduledDate.isBefore(now)}");
    print("Scheduled timestamp: ${scheduledDate.millisecondsSinceEpoch}");
    print("Current timestamp: ${now.millisecondsSinceEpoch}");

    // If the time has already passed today, schedule for tomorrow
    if (scheduledDate.millisecondsSinceEpoch <= now.millisecondsSinceEpoch) {
      print("Time already passed, scheduling for tomorrow");
      scheduledDate = scheduledDate.add(Duration(days: 1));
    } else {
      print("Scheduling for today");
    }

    await notificationsPlugins.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      await notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      // uiLocalNotificationDateInterpretation:
      //     UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // ⬅️ repeat daily
      payload: body,
    );

    print("✔️ Daily notification scheduled at $scheduledDate");
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(
  NotificationResponse notificationResponse,
) async {
  debugPrint("notification tap");
}
