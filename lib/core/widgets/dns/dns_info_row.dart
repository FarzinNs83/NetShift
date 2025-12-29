import 'package:flutter/material.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/widgets/ping/ping_status_indicator.dart';

class DnsInfoRow extends StatelessWidget {
  final String label;
  final String dns;
  final bool isPinging;
  final dynamic pingResult;

  const DnsInfoRow({
    super.key,
    required this.label,
    required this.dns,
    required this.isPinging,
    required this.pingResult,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.isDarkMode
                ? Colors.greenAccent.withValues(alpha: 0.1)
                : Colors.indigo.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.dns,
            color: AppColors.isDarkMode ? Colors.greenAccent : Colors.indigo,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: AppColors.dnsText.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dns,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.dnsText,
                ),
              ),
            ],
          ),
        ),
        PingStatusIndicator(isPinging: isPinging, pingResult: pingResult),
      ],
    );
  }
}
