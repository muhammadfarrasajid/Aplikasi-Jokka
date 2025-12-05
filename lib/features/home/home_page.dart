import 'package:flutter/material.dart';
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
    NotificationService().showWelcomeNotificationOnce();
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: Center(child: Text('HomePage Jokka')));
  }
}
