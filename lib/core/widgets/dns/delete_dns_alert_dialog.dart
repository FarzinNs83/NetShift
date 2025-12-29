import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/controller/single_dns_ping_controller.dart';
import 'package:netshift/core/resources/app_colors.dart';

class DeleteDNSAlertDialog extends StatelessWidget {
  DeleteDNSAlertDialog({
    super.key,
    required this.netshiftEngineController,
    required this.dns,
  });

  final NetshiftEngineController netshiftEngineController;
  final dynamic dns;
  final SingleDnsPingController dnsPingController = Get.put(
    SingleDnsPingController(),
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.dnsSelectorSheetPersonalDeleteDnsBackground,
      title: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppColors.dnsSelectorSheetPersonalDeleteDnsWarningIcon,
          ),
          const SizedBox(width: 8),
          Text(
            "Delete DNS",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.dnsSelectorSheetPersonalDeleteDnsWarningText,
            ),
          ),
        ],
      ),
      content: Text(
        "Are you sure you want to delete this DNS?",
        style: TextStyle(
          fontSize: 16,
          color: AppColors.dnsSelectorSheetPersonalDeleteDnsWarningText1,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                AppColors.dnsSelectorSheetPersonalDeleteDnsElevatedButton,
            foregroundColor:
                AppColors.dnsSelectorSheetPersonalDeleteDnsElevatedButton1,
            elevation: 5,
            shadowColor:
                AppColors.dnsSelectorSheetPersonalDeleteDnsElevatedButtonShadow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel", style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                AppColors.dnsSelectorSheetPersonalCancelDeleteDnsElevatedButton,
            foregroundColor: AppColors
                .dnsSelectorSheetPersonalCancelDeleteDnsElevatedButton1,
            elevation: 5,
            shadowColor: AppColors
                .dnsSelectorSheetPersonalCancelDeleteDnsElevatedButtonShadow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            netshiftEngineController.deleteDns(dns);

            dnsPingController.pingPrimaryDns();
            dnsPingController.pingSecondaryDns();
            netshiftEngineController.savePersonalDns();
          },
          child: const Text("Delete", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
