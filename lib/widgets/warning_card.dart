import 'package:flutter/material.dart';

class WarningCard extends StatelessWidget {
  final String status;

  const WarningCard({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool isGood = status == "Ergonomis";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          //-------------------------------- ICON

          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: isGood
                  ? Colors.green.shade50
                  : Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isGood
                  ? Icons.check_circle_outline
                  : Icons.warning_amber_rounded,
              color: isGood
                  ? Colors.green
                  : Colors.red,
              size: 42,
            ),
          ),

          const SizedBox(width: 18),

          //-------------------------------- TEXT

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  isGood
                      ? "Postur Baik"
                      : "Postur Buruk",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isGood
                        ? Colors.green
                        : Colors.red,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  isGood
                      ? "Pertahankan posisi duduk Anda."
                      : "Perbaiki posisi duduk Anda.",
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 15),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isGood
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: isGood
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
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