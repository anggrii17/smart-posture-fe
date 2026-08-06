import 'package:firebase_messaging/firebase_messaging.dart';
import 'api_service.dart';

class FCMService {
  static Future<void> init() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings =
        await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("Permission: ${settings.authorizationStatus}");

    String? token = await messaging.getToken();

    print("================================");
    print("FCM TOKEN");
    print(token);
    print("================================");

    if (token != null) {
      try {
        bool berhasil = await ApiService.saveToken(token);
        print("TOKEN TERSIMPAN : $berhasil");
      } catch (e) {
        print("GAGAL SIMPAN TOKEN : $e");
      }
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground Notification");
      print(message.notification?.title);
      print(message.notification?.body);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification Clicked");
    });
  }
}