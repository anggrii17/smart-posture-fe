import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:skripsi_anggi/screens/navigation_screen.dart';

import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);

  // Inisialisasi Local Notification
  await NotificationService.init();

  runApp(const SmartPosture());
}

class SmartPosture extends StatelessWidget {
  const SmartPosture({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Posture',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF304FFE),
        scaffoldBackgroundColor: const Color(0xffF4F7FC),
      ),
      home: const NavigationScreen(),
    );
  }
}