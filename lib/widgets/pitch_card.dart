import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../model/posture.dart';

class PitchCard extends StatelessWidget {
  final double pitch;
  final List<Posture> logs;

  const PitchCard({
    super.key,
    required this.pitch,
    required this.logs,
  });

  @override
  Widget build(BuildContext context) {
    // Ambil 6 data terakhir lalu urutkan dari lama -> baru
    final chartLogs = logs.reversed.take(6).toList().reversed.toList();

    final spots = chartLogs.asMap().entries.map((e) {
      return FlSpot(
        e.key.toDouble(),
        e.value.pitch,
      );
    }).toList();

    double maxY = 60;

    if (chartLogs.isNotEmpty) {
      maxY = chartLogs
              .map((e) => e.pitch)
              .reduce((a, b) => a > b ? a : b) +
          10;

      if (maxY < 40) {
        maxY = 40;
      }
    }

    return Container(
      padding: const EdgeInsets.all(18),
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
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${pitch.toStringAsFixed(1)}°",
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff304FFE),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Sudut Pitch",
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: SizedBox(
              height: 160,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: maxY,

                  borderData: FlBorderData(show: false),

                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 15,
                    drawVerticalLine: false,
                  ),

                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),

                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),

                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        reservedSize: 30,
                        interval: 15,
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            "${value.toInt()}°",
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),

                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();

                          if (index >= chartLogs.length) {
                            return const SizedBox();
                          }

                          final time =
                              chartLogs[index].timestamp.substring(11, 16);

                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              time,
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: const Color(0xff304FFE),
                      barWidth: 4,

                      dotData: const FlDotData(show: true),

                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xff304FFE).withOpacity(.15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}