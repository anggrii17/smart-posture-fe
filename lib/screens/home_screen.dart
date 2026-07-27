import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

import '../model/posture.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import '../widgets/pitch_card.dart';
import '../widgets/posture_table.dart';
import '../widgets/warning_card.dart';
import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final AudioPlayer player = AudioPlayer();
  bool isPlayingWarning = false;

  double pitch = 0;
  String status = "Loading...";

  List<Posture> logs = [];

  Timer? timer;
  Timer? logTimer;

  bool isWarningShown = true;
  bool isFirstLoad = true;
  bool hasUnreadNotification = false;
  bool espConnected = false;

  @override
  void initState() {
    super.initState();

    loadNotificationStatus();

    getCurrentPosture();
    getPostureLogs();

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => getCurrentPosture(),
    );

    logTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => getPostureLogs(),
    );
  }

  Future<void> loadNotificationStatus() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      hasUnreadNotification =
          prefs.getBool("hasUnreadNotification") ?? false;
    });
  }

  //=========================
  // CURRENT POSTURE
  //=========================

  Future<void> getCurrentPosture() async {
    try {
      final data = await ApiService.getCurrentPosture();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("espConnected", true);
      setState(() {
        espConnected = true;
      });

      pitch =
          double.tryParse(data["pitch"].toString()) ?? 0;

      status =
          data["status"]?.toString() ?? "Unknown";

      setState(() {});

        if (isFirstLoad) {
          isFirstLoad = false;
        }


        if (status == "Tidak Ergonomis" &&
            !isWarningShown &&
            !isFirstLoad) {

        isWarningShown = true;

        final prefs =
            await SharedPreferences.getInstance();

        await prefs.setBool(
          "hasUnreadNotification",
          true,
        );

        setState(() {
          hasUnreadNotification = true;
        });

        await vibrateWarning();

        await playWarningSound();

        debugPrint("Notif dipanggil");
        await NotificationService.showNotification(
          title: "Peringatan Postur",
          body:
              "Postur Anda sedang tidak ergonomis",
        );

        if (mounted) {
          showWarningDialog();
        }
      }

      if (status == "Ergonomis") {

        isWarningShown = false;

        Vibration.cancel();

        await player.stop();

        isPlayingWarning = false;

      }

    } catch (e) {
        setState(() {
          espConnected = false;
        });

        debugPrint(e.toString());
          }
        }

  //=========================
  // LOG DATABASE
  //=========================

  Future<void> getPostureLogs() async {
    try {
      logs = await ApiService.getLogs();

      logs.sort(
        (a, b) => DateTime.parse(b.timestamp)
            .compareTo(
          DateTime.parse(a.timestamp),
        ),
      );

      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //=========================
  // POPUP WARNING
  //=========================

  void showWarningDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
              ),
              SizedBox(width: 10),
              Text("Peringatan"),
            ],
          ),
          content: Text(
            "Postur Anda sedang tidak ergonomis.\n\n"
            "Pitch : ${pitch.toStringAsFixed(1)}°",
          ),
          actions: [
            
            FilledButton(
              onPressed: () async {

                Vibration.cancel();

                await player.stop();

                isPlayingWarning = false;

                Navigator.pop(context);

              },

              child: const Text("Ubah Potur"),
            ),
          ],
        );
      },
    );
  }

  //=========================
  // VIBRATION
  //=========================

  Future<void> vibrateWarning() async {
  final prefs = await SharedPreferences.getInstance();

  final vibrationEnabled =
      prefs.getBool("vibration") ?? true;

  if (!vibrationEnabled) return;

  final hasVibrator =
      await Vibration.hasVibrator() ?? false;

  if (!hasVibrator) return;

  Vibration.vibrate(
    pattern: [0, 500, 500],
    repeat: 0,
  );
}

Future<void> playWarningSound() async {

  if (isPlayingWarning) return;

  isPlayingWarning = true;

  await player.setReleaseMode(ReleaseMode.loop);

  await player.play(
    AssetSource("audio/warning.mp3"),
  );
}

  @override
  void dispose() {
    timer?.cancel();
    logTimer?.cancel();
    player.dispose();
    super.dispose();
  }
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          //=========================
          // BACKGROUND HEADER
          //=========================

          Container(
            height: 250,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff2F46D8),
                  Color(0xff5146E5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [

                //=========================
                // HEADER
                //=========================

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  child: Row(
                    children: [

                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            Text(
                              "Smart Posture",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 4),

                            Text(
                              "Monitoring System",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Stack(
                        children: [

                          IconButton(
                            icon: const Icon(
                              Icons.notifications_none_rounded,
                              color: Colors.white,
                              size: 30,
                            ),

                            onPressed: () async {

                              final prefs =
                                  await SharedPreferences.getInstance();

                              await prefs.setBool(
                                "hasUnreadNotification",
                                false,
                              );

                              setState(() {
                                hasUnreadNotification =
                                    false;
                              });

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const NotificationScreen(),
                                ),
                              );
                            },
                          ),

                          if (hasUnreadNotification)
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration:
                                    const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                //=========================
                // CONTENT
                //=========================

                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xffF4F7FC),
                      borderRadius: BorderRadius.only(
                        topLeft:
                            Radius.circular(35),
                        topRight:
                            Radius.circular(35),
                      ),
                    ),

                    child: SingleChildScrollView(
                      padding:
                          const EdgeInsets.all(20),

                      child: Column(
                        children: [

                          const SizedBox(height: 5),

                          WarningCard(
                            status: status,
                          ),

                          const SizedBox(height: 20),

                          PitchCard(
                            pitch: pitch,
                            logs: logs,
                          ),

                          const SizedBox(height: 20),

                          PostureTable(
                            logs: logs,
                          ),

                          const SizedBox(height: 100),

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
