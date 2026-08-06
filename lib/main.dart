import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';

import 'package:skripsi_anggi/screens/navigation_screen.dart';
import 'services/notification_service.dart';
import 'services/fcm_service.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print("Background Message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(
    _firebaseMessagingBackgroundHandler,
  );

  await NotificationService.init();

  await FCMService.init();

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