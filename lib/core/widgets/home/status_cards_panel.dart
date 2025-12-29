import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/gen/assets.gen.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/widgets/common/custom_snack_bar.dart';
import 'package:netshift/core/widgets/desktop/desktop_status_card.dart';
import 'package:netshift/core/widgets/settings/interface_selection_dialog.dart';

class StatusCardsPanel extends StatelessWidget {
  StatusCardsPanel({super.key});

  final NetshiftEngineController netshiftEngineController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DesktopStatusCard(
            icon: Assets.svg.flush,
            label: 'Flush DNS',
            status: netshiftEngineController.isFlushing.value
                ? "Flushed Successfully"
                : "Click to Flush",
            color: AppColors.download,
            iconColor: const Color(0xFF38AC72),
            onTap: _handleFlushDns,
          ),
          const SizedBox(height: 16),
          DesktopStatusCard(
            icon: Assets.svg.global,
            label: 'IP Address',
            status: netshiftEngineController.isIpAddress.value
                ? "Getting IP..."
                : netshiftEngineController.ipAddressString.value,
            color: AppColors.ip,
            iconColor: const Color(0xFF428BC1),
            onTap: () => netshiftEngineController.getIpAddress(),
          ),
          const SizedBox(height: 16),
          DesktopStatusCard(
            icon: Assets.svg.interface,
            label: 'Network Interface',
            status: netshiftEngineController.interfaceName.value,
            color: AppColors.upload,
            iconColor: const Color(0xFFD2222D),
            onTap: () => InterfaceSelectionDialog.show(context),
          ),
        ],
      ),
    );
  }

  void _handleFlushDns() {
    if (netshiftEngineController.isActive.value) {
      CustomSnackBar(
        title: "Operation Failed",
        message: "Failed to FLUSH DNS, please stop the service first",
        backColor: Colors.red.shade700.withValues(alpha: 0.9),
        iconColor: Colors.white,
        icon: Icons.error_outline,
        textColor: Colors.white,
      ).customSnackBar();
      return;
    }

    if (Platform.isWindows) {
      netshiftEngineController.flushDnsForWindows();
    } else if (Platform.isMacOS) {
      netshiftEngineController.flushDnsForMacOS();
    }

    CustomSnackBar(
      title: "Operation Success",
      message: "FLUSHED DNS Successfully",
      backColor: const Color.fromARGB(80, 105, 240, 175),
      iconColor: Colors.greenAccent,
      icon: Icons.check_circle_outline_outlined,
      textColor: Colors.white,
    ).customSnackBar();
  }
}
