import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_network_flutter/common/framework/permissions/permission_service.dart';
import 'package:social_network_flutter/common/framework/storages/preferences_storage.dart';

// abstract class INotificationService {
//   Future<void> init();

//   Future<void> showNotification({
//     required String title,
//     required String body,
//     String? payload,
//   });

//   void onNotificationTap(Function(String) onTap);
// }

class NotificationService {
  final IPreferencesStorage preferencesStorage;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Колбэк для навигации
  void Function(String payload)? onNotificationTap;

  NotificationService({required this.preferencesStorage});

  Future<void> init() async {
    // final hasSystemPermission = await permissionService.canSendNotifications();
    // if (!hasSystemPermission) {
    //   final status = await permissionService.requestNotificationIfNeeded();
    //   if (!status.isGranted) {
    //     return;
    //   }
    // }
    final hasPermission = await _checkFcmPermission();
    if (!hasPermission) {
      final granted = await requestFcmPermission();
      if (!granted) return;
    }
    // 1. Инициализируем локальные уведомления
    await _initLocalNotifications();

    // 3. Обработка уведомлений в разных состояниях
    _setupForegroundHandler(); // Приложение открыто
    _setupBackgroundHandler(); // Приложение свёрнуто
    await _checkInitialMessage(); // Приложение было убито

    // 4. Получаем и отправляем токен
    await _handleToken();
  }

  Future<bool> _checkFcmPermission() async {
    final settings = await _fcm.getNotificationSettings();
    final isAuthorized =
        settings.authorizationStatus == AuthorizationStatus.authorized;

    // Сохраняем в preferencesStorage, если нужно
    if (!isAuthorized) {
      await preferencesStorage.load();
      preferencesStorage.requestNotificationPermissions = false;
      await preferencesStorage.save();
    }

    return isAuthorized;
  }

  Future<bool> requestPermissions() async {
    // final systemGranted = await permissionService.requestNotificationIfNeeded();
    // if (!systemGranted.isGranted) return false;

    return await requestFcmPermission();
  }

  Future<bool> requestFcmPermission() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final granted =
        settings.authorizationStatus == AuthorizationStatus.authorized;

    if (granted) {
      await preferencesStorage.load();
      preferencesStorage.requestNotificationPermissions = true;
      await preferencesStorage.save();
    }

    return granted;
  }

  // ============ ИНИЦИАЛИЗАЦИЯ ЛОКАЛЬНЫХ УВЕДОМЛЕНИЙ ============

  Future<void> _initLocalNotifications() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _localNotifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _handleLocalNotificationTap,
    );
  }

  void _handleLocalNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null && onNotificationTap != null) {
      onNotificationTap!(payload);
    }
  }

  // ============ FCM ХЭНДЛЕРЫ ============

  // 1️⃣ FOREGROUND: приложение открыто
  void _setupForegroundHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
      _handleMessage(message);
    });
  }

  // 2️⃣ BACKGROUND: приложение свёрнуто, пользователь нажал на уведомление
  void _setupBackgroundHandler() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(message);
    });
  }

  // 3️⃣ TERMINATED: приложение было убито, запустилось через уведомление
  Future<void> _checkInitialMessage() async {
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      await _savePendingNotification(initialMessage.data['payload']);
      _handleMessage(initialMessage);
    }
  }

  void _showLocalNotification(RemoteMessage message) {
    final data = message.data;
    final title = message.notification?.title ?? data['title'];
    final body = message.notification?.body ?? data['body'];
    final payload = data['payload'];

    if (title == null || body == null) return;

    _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch.hashCode,
      title: title,
      body: body,
      payload: payload,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'main_channel',
          'Основной канал',
          channelDescription: 'Уведомления приложения',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  void _handleMessage(RemoteMessage message) {
    final payload = message.data['payload'];
    if (payload != null && onNotificationTap != null) {
      onNotificationTap!(payload);
    }
  }

  Future<void> _handleToken() async {
    final token = await _fcm.getToken();

    await _sendTokenToServer(token);

    _fcm.onTokenRefresh.listen((newToken) {
      _sendTokenToServer(newToken);
    });
  }

  Future<void> _sendTokenToServer(String? token) async {
    if (token == null) return;
    // TODO: Отправить токен на твой бэкенд
    // await api.registerToken(token);
  }

  Future<void> _savePendingNotification(String? payload) async {
    if (payload == null || payload == "") return;
    await preferencesStorage.load();
    preferencesStorage.pendingNotification = payload;
    await preferencesStorage.save();
  }

  Future<String?> getPendingNotification() async {
    await preferencesStorage.load();
    String? pending = preferencesStorage.pendingNotification;
    preferencesStorage.pendingNotification = null;
    await preferencesStorage.save();
    return pending;
  }
}
