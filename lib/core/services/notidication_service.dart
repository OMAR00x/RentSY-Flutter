import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:saved/firebase_options.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  @pragma('vm:entry-point')
  static Future<void> firebaseMessaginhBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await _initializedLocalNotification();
    await _showFlutterNotification(message);
  }

  static Future<void> initializeNotification() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');
      await _showFlutterNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("App opened from background notification : ${message.data}");
      _handleNotificationTap(message);
    });

    await _getFcmToken();
    await _initializedLocalNotification();
    await _getInitialNotification();

    await _setupNotificationChannels();
  }

  static Future<void> _showFlutterNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    Map<String, dynamic> data = message.data;

    String title = notification?.title ?? data['title'] ?? 'No Title';
    String body = notification?.body ?? data['body'] ?? 'No body';

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      channelDescription: 'Notiffication channel for basic test',
      icon: 'notification_icon',

      priority: Priority.high,
      importance: Importance.high,
    );
    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  static Future<void> _initializedLocalNotification() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('notification_icon');

    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
    final InitializationSettings initSetting = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initSetting,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log('User tapped notification: ${response.payload}');
      },
    );
  }

  static Future<void> _getInitialNotification() async {
    RemoteMessage? message = await FirebaseMessaging.instance
        .getInitialMessage();
    if (message != null) {
      log(
        "App launched from terminated state via notification : ${message.data}",
      );
      _handleNotificationTap(message);
    }
  }

  static void _handleNotificationTap(RemoteMessage message) {
    log('Notification tapped: ${message.data}');
  }

  static Future<void> _setupNotificationChannels() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      description: 'Notification channel for basic test',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  static Future<void> _getFcmToken() async {
    String? token = await _firebaseMessaging.getToken();
    log('FCM Token :: :: $token');

    _firebaseMessaging.onTokenRefresh.listen((String token) {
      log('FCM Token refreshed: $token');
    });
  }

  static Future<String?> getFcmToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      log('FCM Token retrieved: $token');
      return token;
    } catch (e) {
      log('Error getting FCM Token: $e');
      return null;
    }
  }
}
