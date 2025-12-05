import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._internal();

  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  bool _welcomeShown = false; // <--- TAMBAHAN: flag global

  Future<void> init() async {
    if (_initialized) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(android: androidInit);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    final androidPlugin = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.requestNotificationsPermission();

    _initialized = true;
  }

  // dipanggil dari mana saja, tapi keluar notif cuma sekali
  Future<void> showWelcomeNotificationOnce() async {
    if (_welcomeShown) return;
    _welcomeShown = true;
    await _showWelcomeNotification();
  }

  // method internal, jangan dipanggil langsung dari luar
  Future<void> _showWelcomeNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'jokka_channel_id',
      'Jokka Notifications',
      channelDescription: 'Notifikasi dari aplikasi Jokka',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notifDetails = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      1,
      'Selamat datang di Jokka',
      'Temukan destinasi dan event menarik di Makassar.',
      notifDetails,
    );
  }
}
