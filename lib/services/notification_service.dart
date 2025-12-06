import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._internal();

  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Inisialisasi plugin notifikasi
  Future<void> init() async {
    if (_initialized) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(android: androidInit);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    _initialized = true;
  }

  /// Minta izin notifikasi ke sistem (Android 13+)
  Future<void> requestPermission() async {
    final androidPlugin = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.requestNotificationsPermission();
  }

  /// (opsional) nanti bisa dipakai kalau mau kirim notif dari tempat lain
  Future<void> showWelcomeNotification() async {
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
      'Notifikasi Jokka aktif',
      'Kami akan mengirim info destinasi dan event menarik untukmu.',
      notifDetails,
    );
  }
}
