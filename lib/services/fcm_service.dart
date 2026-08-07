import 'package:firebase_messaging/firebase_messaging.dart';
import 'api_service.dart';


class FCMService {


  static Future<void> init() async {


    FirebaseMessaging messaging =
        FirebaseMessaging.instance;



    // Request permission notifikasi

    NotificationSettings settings =
        await messaging.requestPermission(

      alert: true,
      badge: true,
      sound: true,

    );



    print(
      "Permission: ${settings.authorizationStatus}",
    );



    // Ambil FCM Token

    String? token =
        await messaging.getToken();



    print("==============================");
    print("FCM TOKEN");
    print(token);
    print("==============================");



    // Simpan token ke backend

    if(token != null){


      try{


        bool berhasil =
            await ApiService.saveToken(token);



        print(
          "TOKEN TERSIMPAN : $berhasil",
        );



      }catch(e){


        print(
          "GAGAL SIMPAN TOKEN : $e",
        );


      }


    }




    // Notifikasi saat aplikasi sedang terbuka

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message){


        print(
          "Foreground Notification",
        );


        print(
          "Title : ${message.notification?.title}",
        );


        print(
          "Body : ${message.notification?.body}",
        );


      },
    );





    // Saat user klik notifikasi

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message){


        print(
          "Notification Clicked",
        );


      },
    );


  }


}