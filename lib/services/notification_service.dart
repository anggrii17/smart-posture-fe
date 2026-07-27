import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationService {


  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();



  static const int postureNotificationId = 0;



  //========================
  // INIT
  //========================

  static Future<void> init() async {


    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('logooo');



    const InitializationSettings settings =
        InitializationSettings(
          android: initializationSettingsAndroid,
        );



    await plugin.initialize(settings);

  }




  //========================
  // TAMPILKAN NOTIFIKASI
  //========================

  static Future<void> showNotification({

    required String title,

    required String body,

  }) async {



    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(

      'posture_channel_v2',

      'Posture Warning',

      channelDescription:
          'Peringatan postur buruk',


      importance: Importance.max,

      priority: Priority.high,


      icon: 'logooo',


      playSound: false,

      enableVibration: true,

    );




    const NotificationDetails details =
        NotificationDetails(

          android: androidDetails,

        );





    await plugin.show(

      postureNotificationId,

      title,

      body,

      details,

    );


  }




  //========================
  // HAPUS 1 NOTIFIKASI
  //========================

  static Future<void> cancelPostureNotification() async {


    await plugin.cancel(

      postureNotificationId,

    );


  }



}