import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:netshift/core/resources/app_colors.dart';

class PingStatusIndicator extends StatelessWidget {
  const PingStatusIndicator({
    super.key,
    required this.isPinging,
    required this.pingResult,
  });

  final bool isPinging;
  final dynamic pingResult;

  @override
  Widget build(BuildContext context) {
    if (isPinging) {
      return SpinKitCircle(color: AppColors.spinKitColor, size: 24);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.isDarkMode
            ? Colors.greenAccent.withValues(alpha: 0.15)
            : Colors.indigo.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "$pingResult ms",
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.isDarkMode ? Colors.greenAccent : Colors.indigo,
        ),
      ),
    );
  }
}
