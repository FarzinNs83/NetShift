import 'package:flutter/material.dart';
import 'package:netshift/core/resources/app_colors.dart';

class PingProgressIndicator extends StatelessWidget {
  final int completed;
  final int total;
  final bool isVisible;
  final bool isMobile;

  const PingProgressIndicator({
    super.key,
    required this.completed,
    required this.total,
    required this.isVisible,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    if (isMobile) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        color: AppColors.isDarkMode
            ? Colors.greenAccent.withValues(alpha: 0.1)
            : Colors.indigo.withValues(alpha: 0.1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.isDarkMode ? Colors.greenAccent : Colors.indigo,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "Pinging $completed/$total DNS servers...",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: AppColors.isDarkMode ? Colors.greenAccent : Colors.indigo,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.isDarkMode
            ? Colors.greenAccent.withValues(alpha: 0.1)
            : Colors.indigo.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.isDarkMode ? Colors.greenAccent : Colors.indigo,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            "Pinging $completed/$total",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: AppColors.isDarkMode ? Colors.greenAccent : Colors.indigo,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
