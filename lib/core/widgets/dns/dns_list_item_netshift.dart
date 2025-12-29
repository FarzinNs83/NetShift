import 'package:flutter/material.dart';
import 'package:netshift/models/dns_model.dart';
import 'package:netshift/core/resources/app_colors.dart';

class DnsListItemNetshift extends StatelessWidget {
  const DnsListItemNetshift({
    super.key,
    required this.dns,
    required this.onTap,
  });

  final DnsModel dns;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.dnsSelectionContainerNetShiftContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.dnsSelectionContainerNetShiftBorderContainer,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dns.name,
                      style: TextStyle(
                        color: AppColors.dnsSelectionContainerNetShiftDnsName,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Primary: ${dns.primaryDNS}",
                      style: TextStyle(
                        color: AppColors.dnsSelectionContainerNetShiftDns,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Secondary: ${dns.secondaryDNS}',
                      style: TextStyle(
                        color: AppColors.dnsSelectionContainerNetShiftDns,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              dns.name.contains('*')
                  ? const Icon(
                      Icons.remove_circle,
                      color: Color.fromARGB(255, 255, 30, 0),
                    )
                  : const Icon(
                      Icons.check_circle,
                      color: Color.fromARGB(255, 48, 136, 51),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
