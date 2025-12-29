import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/controller/random_dns_generator_controller.dart';
import 'package:netshift/controller/splash_controller.dart';
import 'package:netshift/gen/assets.gen.dart';
import 'package:netshift/core/widgets/dns/add_dns.dart';
import 'package:netshift/core/widgets/common/custom_floating_action_button.dart';
import 'package:netshift/core/widgets/common/custom_snack_bar.dart';
import 'package:netshift/core/widgets/dns/dns_generator_dialog.dart';

class MobileActionsPanel extends StatelessWidget {
  MobileActionsPanel({super.key});

  final NetshiftEngineController netshiftEngineController = Get.find();
  final SplashScreenController splashScreenController = Get.find();

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => RandomDnsGeneratorController());
    final RandomDnsGeneratorController randomDnsGeneratorController =
        Get.find();

    return Padding(
      padding: const EdgeInsets.only(right: 12, left: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomFloatingActionButton(
            path: Assets.svg.generateDns,
            onTap: () =>
                _handleGenerateDns(context, randomDnsGeneratorController),
          ),
          CustomFloatingActionButton(
            path: Assets.svg.addDns,
            onTap: () => _handleAddDns(context),
          ),
        ],
      ),
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
