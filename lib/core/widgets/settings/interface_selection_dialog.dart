import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/widgets/common/custom_snack_bar.dart';

class InterfaceSelectionDialog {
  static void show(BuildContext context) {
    final netshiftEngineController = Get.find<NetshiftEngineController>();

    if (netshiftEngineController.isActive.value) {
      CustomSnackBar(
        title: "Operation Failed",
        message: "Failed to Select INTERFACE, please stop the service first",
        backColor: Colors.red.shade700.withValues(alpha: 0.9),
        iconColor: Colors.white,
        icon: Icons.error_outline,
        textColor: Colors.white,
      ).customSnackBar();
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Center(
          child: Text(
            "Select an Interface",
            style: TextStyle(
              color: AppColors.interfaceClose,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: SizedBox(
          height: 250,
          width: 300,
          child: ListView.builder(
            itemCount: netshiftEngineController.interfaceKeys.length,
            itemBuilder: (context, index) {
              final isConnected =
                  netshiftEngineController.interfaceValues[index] ==
                  'Connected';
              return ListTile(
                title: Text(
                  netshiftEngineController.interfaceKeys[index],
                  style: TextStyle(
                    color: AppColors.interfaceName,
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  netshiftEngineController.interfaceName.value =
                      netshiftEngineController.interfaceKeys[index];
                  netshiftEngineController.saveInterfaceName();
                  log(
                    "Interface changed to ${netshiftEngineController.interfaceName.value}",
                  );
                  Navigator.pop(context);
                },
                leading: Icon(
                  isConnected
                      ? Icons.wifi_password_sharp
                      : Icons.wifi_off_outlined,
                  color: isConnected
                      ? const Color.fromARGB(255, 72, 190, 133)
                      : Colors.redAccent,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hoverColor: AppColors.interfaceHover,
              );
            },
          ),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              overlayColor: WidgetStatePropertyAll(
                AppColors.interfaceCloseHover,
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Close",
              style: TextStyle(
                color: AppColors.interfaceClose,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
