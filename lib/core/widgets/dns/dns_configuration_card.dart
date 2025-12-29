import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/widgets/common/custom_snack_bar.dart';
import 'package:netshift/core/widgets/dns/dns_details_card.dart';
import 'package:netshift/core/widgets/dns/dns_selection_container.dart';
import 'package:netshift/core/widgets/dns/main_dns_selector.dart';

class DnsConfigurationCard extends StatelessWidget {
  DnsConfigurationCard({super.key});

  final NetshiftEngineController netshiftEngineController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "DNS Configuration",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.dnsText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Select and configure your preferred DNS servers",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: AppColors.dnsText.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 32),
          DnsSelectionContainer(
            onPressed: () => _handleDnsSelection(context),
            color: AppColors.dnsSelectionContainerIcon,
          ),
          const SizedBox(height: 32),
          DnsDetailsCard(),
        ],
      ),
    );
  }

  void _handleDnsSelection(BuildContext context) {
    if (netshiftEngineController.isActive.value) {
      CustomSnackBar(
        title: "Operation Failed",
        message: "Failed to SELECT DNS, please stop the service first",
        backColor: Colors.red.shade700.withValues(alpha: 0.9),
        iconColor: Colors.white,
        icon: Icons.error_outline,
        textColor: Colors.white,
      ).customSnackBar();
      return;
    }

    showModalBottomSheet(
      sheetAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        reverseDuration: const Duration(milliseconds: 300),
        reverseCurve: Curves.easeInOut,
      ),
      context: context,
      builder: (context) => MainDNSSelector(),
    );
  }
}
