import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netshift/controller/foreground_controller.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/gen/assets.gen.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/widgets/common/custom_snack_bar.dart';
import 'package:netshift/core/widgets/settings/interface_selection_dialog.dart';
import 'package:netshift/core/widgets/common/status_bar.dart';

class MobileStatusIcons extends StatelessWidget {
  MobileStatusIcons({super.key});

  final NetshiftEngineController netshiftEngineController = Get.find();
  final ForegroundController foregroundController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Platform.isAndroid
              ? StatusIcon(
                  path: Assets.svg.download,
                  label: 'Download',
                  status: foregroundController.download.value,
                  color: AppColors.download,
                  iconColor: const Color(0xFF38AC72),
                  onTap: () {},
                )
              : StatusIcon(
                  path: Assets.svg.flush,
                  label: 'Flush DNS',
                  status: netshiftEngineController.isFlushing.value
                      ? "Flushed Succesfully"
                      : "Tap To Flush",
                  color: AppColors.download,
                  onTap: _handleFlushDns,
                  iconColor: const Color(0xFF38AC72),
                ),
          StatusIcon(
            path: Assets.svg.global,
            label: 'Address',
            status: netshiftEngineController.isIpAddress.value
                ? "IP: Getting IP..."
                : "IP: ${netshiftEngineController.ipAddressString}",
            color: AppColors.ip,
            onTap: () => netshiftEngineController.getIpAddress(),
            iconColor: const Color(0xFF428BC1),
          ),
          Platform.isAndroid
              ? StatusIcon(
                  path: Assets.svg.upload,
                  label: 'Upload',
                  status: foregroundController.upload.value,
                  color: AppColors.upload,
                  iconColor: const Color(0xFFD2222D),
                  onTap: () {},
                )
              : StatusIcon(
                  path: Assets.svg.interface,
                  label: 'Interface',
                  status: "${netshiftEngineController.interfaceName.value} ⏷",
                  color: AppColors.upload,
                  onTap: () => InterfaceSelectionDialog.show(context),
                  iconColor: const Color(0xFFD2222D),
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
