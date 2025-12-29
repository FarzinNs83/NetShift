import 'package:flutter/material.dart';
import 'package:netshift/core/resources/media_query_size.dart';
import 'package:netshift/models/dns_model.dart';
import 'package:netshift/core/resources/app_colors.dart';

class DnsListItemPersonal extends StatelessWidget {
  const DnsListItemPersonal({
    super.key,
    required this.dns,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final DnsModel dns;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.dnsSelectorSheetPersonalContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.dnsSelectorSheetPersonalContainerBorder,
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
                    SizedBox(
                      width: ScreenSize.width * 0.55,
                      child: Text(
                        dns.name,
                        style: TextStyle(
                          color: AppColors.dnsSelectorSheetPersonalDnsName,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Primary: ${dns.primaryDNS}",
                      style: TextStyle(
                        color: AppColors.dnsSelectorSheetPersonalDns,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Secondary: ${dns.secondaryDNS}',
                      style: TextStyle(
                        color: AppColors.dnsSelectorSheetPersonalDns,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: Icon(
                      Icons.edit_outlined,
                      color: AppColors.dnsSelectorSheetPersonalDnsEdit,
                      size: 30,
                    ),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: Icon(
                      Icons.delete_sweep_outlined,
                      color: AppColors.dnsSelectorSheetPersonalDnsDelete,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
