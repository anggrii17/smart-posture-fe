import 'package:flutter/material.dart';

import '../model/posture.dart';
import '../screens/navigation_screen.dart';

class PostureTable extends StatelessWidget {
  final List<Posture> logs;

  const PostureTable({
    super.key,
    required this.logs,
  });

  @override
  Widget build(BuildContext context) {
    // Ambil 3 data terbaru
    final latestLogs = logs.take(3).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // ================= HEADER =================
          const Row(
            children: [
              Icon(
                Icons.history,
                color: Color(0xff304FFE),
              ),
              SizedBox(width: 10),
              Text(
                "Riwayat Postur",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ================= DATA =================
          if (latestLogs.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text("Belum ada data"),
            ),

          ...latestLogs.map((log) {
            final bool good = log.status == "Ergonomis";

            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: good
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: good
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    child: Icon(
                      good
                          ? Icons.check_circle
                          : Icons.warning_amber_rounded,
                      color: good
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          good
                              ? "Ergonomis"
                              : "Tidak Ergonomis",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: good
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "Pitch : ${log.pitch.toStringAsFixed(1)}°",
                        ),

                        const SizedBox(height: 4),

                        Text(
                          log.timestamp,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),

          // ================= BUTTON =================
          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.history),
              label: const Text("Lihat Riwayat Lengkap"),
              onPressed: () {
                NavigationScreen.changeTab(
                  context,
                  1,
                );

              },
            ),
          ),
        ],
      ),
    );
  }
}