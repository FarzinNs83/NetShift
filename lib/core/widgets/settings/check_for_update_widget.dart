import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:netshift/controller/check_for_update_controller.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/services/windows_title_bar_box.dart';
import 'package:netshift/core/widgets/common/flutter_toast.dart';
import 'package:window_manager/window_manager.dart';

class CheckForUpdateWidget extends StatelessWidget {
  const CheckForUpdateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final check = Get.find<CheckForUpdateController>();
    return Scaffold(
      appBar: Platform.isWindows
          ? const PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: WindowsTitleBarBox(),
            )
          : null,
      backgroundColor: AppColors.iconAppBar,
      body: Center(
        child: AlertDialog(
          backgroundColor: AppColors.background,
          title: Text(
            "New Update Available",
            style: TextStyle(color: AppColors.offlineStatusText),
          ),
          content: Obx(() {
            return Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Current Version: ${check.currentVersion.value}",
                    style: TextStyle(
                      color: AppColors.offlineStatusText,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "New Version: ${check.updateVersion.value}",
                    style: TextStyle(
                      color: AppColors.offlineStatusText,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "Update Size: ${check.appSize.value} MB",
                    style: TextStyle(
                      color: AppColors.offlineStatusText,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Would you like to update now?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.offlineStatusText,
                    ),
                  ),
                ],
              ),
            );
          }),
          actions: [
            TextButton(
              onPressed: () {
                if (Platform.isAndroid) {
                  FlutterToast(message: "Exiting the app...").flutterToast();
                  SystemNavigator.pop();
                } else if (Platform.isWindows) {
                  windowManager.close();
                }
              },
              child: const Text("Later"),
            ),
            ElevatedButton(
              onPressed: () {
                if (Platform.isAndroid) {
                  FlutterToast(message: "Redirecting...").flutterToast();
                  check.launchDownloadUrlAndroid();
                } else if (Platform.isWindows) {
                  check.launchDownloadUrlWindows();
                } else if (Platform.isLinux) {
                  check.launchDownloadUrlLinux();
                }
              },
              child: const Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}
