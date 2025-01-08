import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mat_salg/auth/custom_auth/firebase_auth.dart';
import 'package:mat_salg/my_ip.dart';
import 'package:mat_salg/logging.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:async'; // Import this to use Future and TimeoutException
import 'package:mat_salg/helper_components/flutter_flow/flutter_flow_util.dart';

// Top-level background handler function
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  logger.d('Title: ${message.notification?.title}');
  logger.d('Body: ${message.notification?.body}');
  logger.d('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  static const String baseUrl = ApiConstants.baseUrl;
  final appState = FFAppState();

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // name
    description: 'This channel is used for important notifications',
    importance: Importance.high,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    logger.d(message);
  }

  Future initLocalNotifications() async {
    const darwin = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher1');
    const settings = InitializationSettings(android: android, iOS: darwin);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          final message = RemoteMessage.fromMap(jsonDecode(response.payload!));
          handleMessage(message);
        }
      },
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future initPushNotifications() async {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

      // Register the top-level background message handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      if (Platform.isAndroid) {
        if (notification == null) return;
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@drawable/ic_launcher1',
            ),
          ),
          payload: jsonEncode(message.toMap()),
        );
      }
    });
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    await _firebaseMessaging.getAPNSToken();
    logger.d('Token: $fCMToken');
    await sendToken(fCMToken);

    initPushNotifications();
    initLocalNotifications();
  }

  Future<http.Response?> sendToken(String? fcmtoken) async {
    try {
      String? token = await firebaseAuthService.getToken(null);
      if (token == null) {
        return null;
      } else {
        // Check if fcmtoken is null before proceeding
        if (fcmtoken == null) {
          logger.d('FCM token is null');
          return null;
        }

        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo? androidInfo;
        IosDeviceInfo? iosInfo;

        // Fetch device information for Android or iOS
        if (Platform.isAndroid) {
          androidInfo = await deviceInfo.androidInfo;
        } else if (Platform.isIOS) {
          iosInfo = await deviceInfo.iosInfo;
        }

        // Handle the case where deviceInfo may be null
        if ((Platform.isAndroid && androidInfo == null) ||
            (Platform.isIOS && iosInfo == null)) {
          logger.d('Failed to fetch device information');
          return null;
        }

        // Create the user data as a Map
        final Map<String, dynamic> userData = {
          "token": fcmtoken,
          "device": Platform.isAndroid
              ? androidInfo!.model
              : iosInfo!.utsname.machine,
        };

        // Convert the Map to JSON
        final String jsonBody = jsonEncode(userData);
        final uri = Uri.parse('$baseUrl/push');
        final headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Add Bearer token if present
        };

        // Make the HTTP POST request
        final response = await http.post(
          uri,
          headers: headers,
          body: jsonBody,
        );

        logger.d('Response: ${response.statusCode} ${response.body}');
        return response;
      }
    } on SocketException catch (e) {
      logger.d('SocketException: ${e.message}');
      rethrow; // Rethrow the exception to let the caller handle it
    } catch (e) {
      logger.d('Exception: $e');
      rethrow; // Rethrow the exception to let the caller handle it
    }
  }
}
