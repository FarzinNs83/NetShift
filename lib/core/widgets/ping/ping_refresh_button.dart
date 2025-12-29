import 'package:flutter/material.dart';
import 'package:netshift/core/resources/app_colors.dart';

class PingRefreshButton extends StatelessWidget {
  const PingRefreshButton({
    super.key,
    required this.isPinging,
    required this.onRefresh,
  });

  final bool isPinging;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isPinging ? null : onRefresh,
      icon: isPinging
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Icon(Icons.refresh, size: 20),
      label: Text(isPinging ? "Pinging..." : "Refresh All"),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.isDarkMode
            ? const Color(0xFF16725C)
            : Colors.indigo,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
