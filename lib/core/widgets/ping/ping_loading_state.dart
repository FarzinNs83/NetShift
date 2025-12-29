import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:netshift/core/resources/app_colors.dart';

class PingLoadingState extends StatelessWidget {
  const PingLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitCircle(color: AppColors.spinKitColor, size: 70),
          const SizedBox(height: 16),
          Text(
            "Starting ping tests...",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: AppColors.dnsText.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
