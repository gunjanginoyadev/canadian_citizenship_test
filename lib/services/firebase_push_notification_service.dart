import 'package:canadian_citizenship/services/notification_servive.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

/// Background message handler (must be top-level)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('🔙 Background message received: ${message.messageId}');
}

class FirebasePushService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Request permissions (iOS & Android 13+)
    NotificationSettings settings = await _messaging.requestPermission();
    print('🔔 Notification permission status: ${settings.authorizationStatus}');

    // Subscribe to the "all_users" topic (compulsory)
    await _subscribeToAllUsersTopic();

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📲 Foreground message: ${message.notification?.title}');
      _showLocalNotification(message);
    });

    // Handle message when app is opened from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('🚀 App opened from terminated state by notification');
        // You can navigate to specific screen here
      }
    });

    // Handle message when app is resumed from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('🔄 App opened from background by notification');
      // You can navigate to specific screen here
    });

    // Init local notifications
    _initializeLocalNotifications();
  }

  static Future<void> _subscribeToAllUsersTopic() async {
    try {
      await _messaging.subscribeToTopic('all_users');
      print('✅ Successfully subscribed to "all_users" topic');
    } catch (e) {
      print('❌ Failed to subscribe to "all_users" topic: $e');
    }
  }

  static void _initializeLocalNotifications() {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    _localNotifications.initialize(initSettings);
  }

  static void _showLocalNotification(RemoteMessage message) {
    NotificationService.showNotification(
      id: message.hashCode,
      title: message.notification?.title,
      body: message.notification?.body,
      payLoad: message.data.toString(), // or pass custom payload
    );
  }

  // Optional: Method to unsubscribe from the topic (if needed later)
  static Future<void> unsubscribeFromAllUsersTopic() async {
    try {
      await _messaging.unsubscribeFromTopic('all_users');
      print('✅ Successfully unsubscribed from "all_users" topic');
    } catch (e) {
      print('❌ Failed to unsubscribe from "all_users" topic: $e');
    }
  }
}