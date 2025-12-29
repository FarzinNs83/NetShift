import 'package:flutter/material.dart';

class PingBadge extends StatelessWidget {
  const PingBadge({super.key, required this.avgPing, this.isMobile = false});

  final String avgPing;
  final bool isMobile;

  bool get isTimeout => avgPing == '-1';

  Color get pingColor {
    int pingValue = int.tryParse(avgPing) ?? -1;
    if (pingValue == -1) return Colors.red;
    if (pingValue < 50) return Colors.green;
    if (pingValue < 150) return Colors.lightGreen;
    if (pingValue < 300) return Colors.orange;
    return Colors.deepOrange;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 10 : 12,
        vertical: isMobile ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: pingColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
      ),
      child: Text(
        isTimeout ? "Timeout" : "$avgPing ms",
        style: TextStyle(
          color: pingColor,
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
