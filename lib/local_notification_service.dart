import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  LocalNotificationService();

  FlutterLocalNotificationsPlugin _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings androidInitializationSettings = 
      AndroidInitializationSettings('app_icon');

    final DarwinInitializationSettings darwinInitializationSettings = 
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
      );
    
    const LinuxInitializationSettings linuxInitializationSettings = 
      LinuxInitializationSettings(
        defaultActionName: "Open notification"
      );

    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
      macOS: darwinInitializationSettings,
      linux: linuxInitializationSettings
    );

    await _localNotificationService.initialize(
      settings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse
      // onSelectNotification: onSelectNotification
    );
  }

  void _onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
    print('id $id');
  }

  void onSelectNotification(String? payload) {
    print("payload $payload");
  }

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
      final String? payload = notificationResponse.payload;
      if (notificationResponse.payload != null) {
        debugPrint('notification payload: $payload');
      }
      // await Navigator.push(
      //   context,
      //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
      // );
  }

  NotificationDetails _notificationDetails() {
    const AndroidNotificationDetails androidNotificationDetails = 
      AndroidNotificationDetails(
        "channel_id", 
        "channel_name",
        channelDescription: "description",
        importance: Importance.max,
        priority: Priority.max,
        playSound: true
      );

    const DarwinNotificationDetails darwinNotificationDetails = 
      DarwinNotificationDetails(
        threadIdentifier: "thread_id"
      );

    const LinuxNotificationDetails linuxNotificationDetails = 
      LinuxNotificationDetails();

    return const NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
      macOS: darwinNotificationDetails,
      linux: linuxNotificationDetails
    );
  }

  Future<void> showNotification(
    int id,
    String title,
    String body
  ) async {
    final details = _notificationDetails();
    await _localNotificationService.show(id, title, body, details);
  }

}
