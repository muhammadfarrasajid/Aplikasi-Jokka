import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    // jalankan setelah frame pertama supaya context sudah siap
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestNotificationPermissionOnce();
    });
  }

  /// Minta izin notifikasi ke sistem, hanya sekali seumur hidup app.
  Future<void> _requestNotificationPermissionOnce() async {
    final prefs = await SharedPreferences.getInstance();

    final alreadyRequested =
        prefs.getBool('notifications_permission_requested') ?? false;

    // kalau sudah pernah diminta -> jangan minta lagi
    if (alreadyRequested) return;

    // tandai sudah pernah diminta, apapun respon user
    await prefs.setBool('notifications_permission_requested', true);

    // panggil permission sistem Android -> muncul dialog seperti screenshot
    await NotificationService().requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    // sementara UI simple dulu, nanti diganti sesuai Figma
    return const SafeArea(child: Center(child: Text('HomePage Jokka')));
  }
}
