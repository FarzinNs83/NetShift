import 'package:flutter/material.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/resources/extention_sized.dart';

class DnsRowItem extends StatelessWidget {
  const DnsRowItem({
    super.key,
    required this.icon,
    required this.dns,
    required this.ping,
    this.isMobile = false,
  });

  final IconData icon;
  final String dns;
  final String ping;
  final bool isMobile;

  String get formattedPing => ping == '-1' ? 'Timeout' : '$ping ms';

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Row(
        children: [
          Icon(icon, color: AppColors.dnsPing, size: 18),
          8.width,
          Expanded(
            child: Text(
              "$dns  ->  $formattedPing",
              style: TextStyle(
                color: AppColors.dnsPingText,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Icon(icon, color: AppColors.dnsPing, size: 16),
        8.width,
        Expanded(
          child: Text(
            "$dns ($formattedPing)",
            style: TextStyle(
              color: AppColors.dnsPingText,
              fontSize: 12,
              fontFamily: 'Poppins',
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
