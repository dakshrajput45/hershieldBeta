import 'dart:convert'; // For JSON decoding
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:hershield/apis/user_profile_api.dart';
import 'package:hershield/helper/log.dart';

class HSNotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(settings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
      if (response.payload != null) {
        // Decode payload and handle notification click
        Map<String, dynamic> data = json.decode(response.payload!);
        await _handleNotificationClick(
            data); // Open Google Maps only when clicked
      }
    });

    await _updateFcmToken();

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      await HSUserApis.updateFcmToken(token: newToken);
    });

    // Listen to messages when app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // We show the local notification but do not trigger action here
      showLocalNotification(message);
    });

    // When the notification is clicked, handle it
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data.isNotEmpty) {
        _handleNotificationClick(message.data);
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    showLocalNotification(message);
  }

  static void showLocalNotification(RemoteMessage message) async {
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    // Show notification, but only trigger action when the notification is clicked
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? "🚨 SOS Alert!",
      message.notification?.body ?? "A nearby user needs help!",
      notificationDetails,
      payload: json.encode(message.data), // Send the full data to the callback
    );
  }

  // Handles the click on notification and opens Google Maps with location
  static Future<void> _handleNotificationClick(
      Map<String, dynamic> data) async {
    try {
      final latitude = data['latitude'];
      final longitude = data['longitude'];
      hsLog("User in need data: [lat: $latitude, long: $longitude]");
      final url = 'https://www.google.com/maps?q=$latitude,$longitude';
      hsLog(url);
      await FlutterWebBrowser.openWebPage(url: url);
    } catch (e) {
      hsLog("⚠️ Error parsing data or opening Google Maps: $e");
    }
  }

  static Future<void> _updateFcmToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();

      if (token != null) {
        await HSUserApis.updateFcmToken(token: token);
      }
    } catch (e) {
      hsLog("⚠️ Error in _updateFcmToken: $e");
    }
  }

  static const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.max,
    priority: Priority.high,
    sound: null,
    playSound: true,
    enableVibration: true,
  );
}
