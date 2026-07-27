import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  bool notification = true;
  bool vibration = true;

  // STATUS ESP32
  bool espConnected = false;
  Timer? espTimer;

  @override
  void initState() {
    super.initState();

    loadSettings();

    checkESPConnection();

    espTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => checkESPConnection(),
    );
  }

  @override
  void dispose() {
    espTimer?.cancel();
    super.dispose();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      notification =
          prefs.getBool("notification") ?? true;

      vibration =
          prefs.getBool("vibration") ?? true;
    });
  }

  //========================
  // CEK KONEKSI ESP32
  //========================

  Future<void> checkESPConnection() async {

  try {

    final data = await ApiService.getCurrentPosture();

    DateTime lastUpdate =
        DateTime.parse(
          data['last_update'].replaceFirst(' ', 'T')
        ).add(
          const Duration(hours: 7),
        );


    DateTime now = DateTime.now();

    int diff =
        now.difference(lastUpdate).inSeconds;


    print("SELISIH ESP: $diff detik");


    if (mounted) {

      setState(() {

        espConnected = diff <= 3;

      });

    }


  } catch (e) {

    print("ERROR ESP: $e");

    if (mounted) {

      setState(() {

        espConnected = false;

      });

    }

  }
}

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
        children: [

          //========================
          // HEADER
          //========================

          Container(
            height: 200,
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

                const Padding(
                  padding: EdgeInsets.only(
                    left: 25,
                    top: 20,
                    bottom: 20,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Pengaturan",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xffF4F7FC),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),
                    ),

                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [

                        //========================
                        // PROFILE
                        //========================

                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(.15),
                                blurRadius: 15,
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [

                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Color(0xff304FFE),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 35,
                                ),
                              ),

                              SizedBox(width: 15),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    "Anggriani",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),

                                  SizedBox(height: 5),

                                  Text(
                                    "Mahasiswa",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        //========================
                        // SETTINGS
                        //========================

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(.15),
                                blurRadius: 15,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [

                              SwitchListTile(
                                secondary: const Icon(
                                  Icons.notifications_active,
                                ),
                                title: const Text("Notifikasi"),
                                subtitle: const Text(
                                  "Aktifkan peringatan postur",
                                ),
                                value: notification,
                                onChanged: (value) async {

                                  final prefs = await SharedPreferences.getInstance();

                                  await prefs.setBool(
                                    "notification",
                                    value,
                                  );

                                  setState(() {
                                    notification = value;
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: const Duration(milliseconds: 900),
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                        value
                                            ? "Notifikasi diaktifkan"
                                            : "Notifikasi dimatikan",
                                      ),
                                    ),
                                  );
                                },
                              ),

                              const Divider(height: 0),

                              SwitchListTile(
                                secondary: const Icon(
                                  Icons.vibration,
                                ),
                                title: const Text(
                                  "Getar Saat Warning",
                                ),
                                subtitle: const Text(
                                  "Getar saat postur tidak ergonomis",
                                ),
                                value: vibration,
                                onChanged: (value) async {

                                  final prefs = await SharedPreferences.getInstance();

                                  await prefs.setBool(
                                    "vibration",
                                    value,
                                  );

                                  setState(() {
                                    vibration = value;
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: const Duration(milliseconds: 900),
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                        value
                                            ? "Getar diaktifkan"
                                            : "Getar dimatikan",
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        //========================
                        // ESP32 STATUS
                        //========================

                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(.15),
                                blurRadius: 15,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [

                              CircleAvatar(
                                radius: 9,
                                backgroundColor: espConnected
                                    ? Colors.green
                                    : Colors.red,
                              ),

                              const SizedBox(width: 15),

                              Expanded(
                                child: Text(
                                  espConnected
                                      ? "ESP32 Connected"
                                      : "ESP32 Disconnected",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        //========================
                        // ABOUT
                        //========================

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(.15),
                                blurRadius: 15,
                              ),
                            ],
                          ),
                          child: Column(
                            children: const [

                              ListTile(
                                leading: Icon(Icons.info_outline),
                                title: Text("Versi Aplikasi"),
                                trailing: Text("1.0.0"),
                              ),

                              Divider(height: 0),

                              ListTile(
                                leading: Icon(Icons.code),
                                title: Text("Developer"),
                                trailing: Text("Anggriani"),
                              ),

                            ],
                          ),
                        ),

                        const SizedBox(height: 100),

                      ],
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