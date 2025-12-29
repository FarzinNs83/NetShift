import 'package:flutter/material.dart';
import 'package:netshift/controller/sorted_dns_ping_controller.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/widgets/ping/ping_progress_indicator.dart';
import 'package:netshift/core/widgets/ping/ping_refresh_button.dart';

class PingHeader extends StatelessWidget {
  const PingHeader({
    super.key,
    required this.controller,
    required this.onRefresh,
  });

  final SortedDnsPingController controller;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "DNS Ping Results",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.dnsText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Test and compare DNS server latencies",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: AppColors.dnsText.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        Row(
          children: [
            PingProgressIndicator(
              completed: controller.completedCount.value,
              total: controller.totalCount.value,
              isVisible: controller.isPinging.value,
            ),
            const SizedBox(width: 16),
            PingRefreshButton(
              isPinging: controller.isPinging.value,
              onRefresh: onRefresh,
            ),
          ],
        ),
      ],
    );
  }
}
