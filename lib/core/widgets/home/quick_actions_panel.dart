import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/controller/random_dns_generator_controller.dart';
import 'package:netshift/controller/splash_controller.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/widgets/common/action_card.dart';
import 'package:netshift/core/widgets/dns/add_dns.dart';
import 'package:netshift/core/widgets/common/custom_snack_bar.dart';
import 'package:netshift/core/widgets/dns/dns_generator_dialog.dart';
import 'package:netshift/core/widgets/dns/main_dns_selector.dart';

class QuickActionsPanel extends StatelessWidget {
  QuickActionsPanel({super.key});

  final NetshiftEngineController netshiftEngineController = Get.find();
  final SplashScreenController splashScreenController = Get.find();

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => RandomDnsGeneratorController());
    final RandomDnsGeneratorController randomDnsGeneratorController =
        Get.find();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.dnsText,
          ),
        ),
        const SizedBox(height: 20),
        ActionCard(
          icon: Icons.auto_fix_high,
          title: "Generate Random DNS",
          subtitle: "Auto-generate optimized DNS settings",
          onTap: () =>
              _handleGenerateDns(context, randomDnsGeneratorController),
        ),
        const SizedBox(height: 16),
        ActionCard(
          icon: Icons.add_circle_outline,
          title: "Add Custom DNS",
          subtitle: "Configure your own DNS servers",
          onTap: () => _handleAddDns(context),
        ),
        const SizedBox(height: 16),
        ActionCard(
          icon: Icons.dns_rounded,
          title: "Browse DNS Providers",
          subtitle: "Choose from popular DNS services",
          onTap: () => _handleDnsSelection(context),
        ),
      ],
    );
  }

  void _handleDnsSelection(BuildContext context) {
    if (netshiftEngineController.isActive.value) {
      _showErrorSnackBar("Failed to SELECT DNS, please stop the service first");
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

  void _handleGenerateDns(
    BuildContext context,
    RandomDnsGeneratorController controller,
  ) {
    if (splashScreenController.isOffline.value) {
      _showErrorSnackBar(
        "Failed to GENERATE DNS, please start the app in online mode",
      );
      return;
    }

    controller.generateRandomDns();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DnsGeneratorDialog(),
    );
  }

  void _handleAddDns(BuildContext context) {
    if (netshiftEngineController.isActive.value) {
      _showErrorSnackBar("Failed to ADD DNS, please stop the service first");
      return;
    }

    showModalBottomSheet(
      context: context,
      sheetAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
        reverseDuration: const Duration(milliseconds: 300),
        reverseCurve: Curves.fastOutSlowIn,
      ),
      isScrollControlled: true,
      builder: (context) => const AddDnsBottomSheet(),
    );
  }

  void _showErrorSnackBar(String message) {
    CustomSnackBar(
      title: "Operation Failed",
      message: message,
      backColor: Colors.red.shade700.withValues(alpha: 0.9),
      iconColor: Colors.white,
      icon: Icons.error_outline,
      textColor: Colors.white,
    ).customSnackBar();
  }
}
