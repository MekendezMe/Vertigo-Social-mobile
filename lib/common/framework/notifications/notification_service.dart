import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class INotificationService {
  Future<void> init();

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  });

  // Future<String?> getDeviceToken();

  void onNotificationTap(Function(Map<String, dynamic>) onTap);
}

class NotificationService implements INotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // final String?
  // _deviceToken; // В будущем получишь из Firebase или другого сервиса

  @override
  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // Настройка для iOS
    const iOSSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: _onNotificationTapBackground,
    );
  }

  @override
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'main_channel',
      'Основной канал',
      channelDescription: 'Уведомления приложения',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iOSDetails = DarwinNotificationDetails();

    const platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id: DateTime.now().millisecond,
      title: title,
      body: body,
      notificationDetails: platformDetails,
      payload: payload,
    );
  }

  // @override
  // Future<String?> getDeviceToken() async {
  //
  // }

  @override
  void onNotificationTap(Function(Map<String, dynamic>) onTap) {
    _onTapCallback = onTap;
  }

  void Function(Map<String, dynamic>)? _onTapCallback;

  void _onNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null && _onTapCallback != null) {
      final data = <String, dynamic>{};
      data['payload'] = payload;
      _onTapCallback!(data);
    }
  }

  @pragma('vm:entry-point')
  static void _onNotificationTapBackground(NotificationResponse response) {}
}
