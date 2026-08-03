import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';

import 'api_service.dart';


final AudioPlayer backgroundPlayer = AudioPlayer();


Future<void> initializeBackgroundService() async {

  final service = FlutterBackgroundService();


  await service.configure(

    androidConfiguration: AndroidConfiguration(

      onStart: onStart,

      autoStart: true,

      isForegroundMode: true,

      notificationChannelId:
          'posture_service',

      initialNotificationTitle:
          'Smart Posture',

      initialNotificationContent:
          'Monitoring postur aktif',

      foregroundServiceNotificationId:
          888,

    ),


    iosConfiguration: IosConfiguration(

      autoStart: true,

      onForeground: onStart,

    ),

  );


  await service.startService();

}



@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {


  Timer.periodic(
    const Duration(seconds: 1),
    (timer) async {


      try {

        final data =
            await ApiService.getCurrentPosture();


        String status =
            data["status"].toString();


        if(status == "Tidak Ergonomis"){


          final prefs =
              await SharedPreferences.getInstance();


          bool alreadyWarning =
              prefs.getBool(
                "backgroundWarning"
              ) ?? false;



          if(!alreadyWarning){


            await prefs.setBool(
              "backgroundWarning",
              true,
            );


            // GETAR

            bool? hasVibrator =
                await Vibration.hasVibrator();


            if(hasVibrator == true){

              Vibration.vibrate(
                pattern: [
                  0,
                  500,
                  500
                ],
                repeat: 0,
              );

            }



            // SUARA

            await backgroundPlayer.setReleaseMode(
              ReleaseMode.loop,
            );


            await backgroundPlayer.play(
              AssetSource(
                "audio/warning.mp3",
              ),
            );



            // NOTIFICATION

            FlutterLocalNotificationsPlugin()
                .show(

              999,

              "Peringatan Postur",

              "Postur Anda tidak ergonomis",

              const NotificationDetails(

                android:
                  AndroidNotificationDetails(

                    "posture_warning",

                    "Posture Warning",

                    importance:
                      Importance.max,

                    priority:
                      Priority.high,

                  ),

              ),

            );


          }



        } else {


          await prefsReset();


          Vibration.cancel();

          await backgroundPlayer.stop();


        }



      } catch(e){

        print(
          "Background error : $e"
        );

      }


    },

  );

}



Future<void> prefsReset() async {

  final prefs =
      await SharedPreferences.getInstance();


  await prefs.setBool(
    "backgroundWarning",
    false,
  );

}