import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:blinking_border/blinking_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:netshift/core/resources/media_query_size.dart';
import 'package:netshift/controller/foreground_controller.dart';
import 'package:netshift/controller/glow_controller.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/controller/stop_watch_controller.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/services/windows_local_notif.dart';
import 'package:netshift/core/widgets/custom_snack_bar.dart';
import 'package:netshift/core/widgets/flutter_toast.dart';

class ConnectButton extends StatelessWidget {
  ConnectButton({super.key});
  final NetshiftEngineController netshiftEngineController = Get.put(
    NetshiftEngineController(),
  );
  final ForegroundController foregroundController = Get.put(
    ForegroundController(),
  );
  final StopWatchController stopWatchController = Get.put(
    StopWatchController(),
  );
  final GlowController glowController = Get.put(GlowController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isOn = netshiftEngineController.isActive.value;
      bool isLoading = netshiftEngineController.isLoading.value;
      bool isPermissionGranted =
          netshiftEngineController.isPermissionGiven.value;

      return GestureDetector(
        onTap: isLoading
            ? null
            : () {
                if (Platform.isAndroid && !isPermissionGranted) {
                  netshiftEngineController.prepareDns();
                  return;
                }
                if (Platform.isWindows &&
                    netshiftEngineController.interfaceName.value.contains(
                      'Select Interface',
                    )) {
                  CustomSnackBar(
                    title: "Operation Failed",
                    message:
                        "Failed to START SERVICE, please select an interface",
                    backColor: Colors.red.shade700.withValues(alpha: 0.9),
                    iconColor: Colors.white,
                    icon: Icons.error_outline,
                    textColor: Colors.white,
                  ).customSnackBar();
                  return;
                }
                if (Platform.isAndroid && isPermissionGranted && isOn) {
                  // FOR ANDROID
                  netshiftEngineController.stopDnsForAndroid();
                  foregroundController.stopService();
                  stopWatchController.stopWatchTime();
                  FlutterToast(
                    message: "Service Stopped Successfully",
                  ).flutterToast();
                } else if (Platform.isAndroid && isPermissionGranted && !isOn) {
                  // FOR ANDROID
                  netshiftEngineController.startDnsForAndroid();
                  foregroundController.startService(
                    netshiftEngineController.selectedDns.value.name,
                  );
                  stopWatchController.startWatchTime();
                  FlutterToast(
                    message: "Service Started Successfully",
                  ).flutterToast();
                } else if (Platform.isAndroid) {
                  log("Premission not granted!");
                } else if (Platform.isWindows && isOn) {
                  // FOR WINDOWS
                  netshiftEngineController.stopDnsForWindows();
                  stopWatchController.stopWatchTime();
                  WindowsLocalNotif(
                    body:
                        "NetShift has disconnected from the ${netshiftEngineController.selectedDns.value.name}.",
                    title: "Service Stopped",
                  ).showNotification();
                } else if (Platform.isWindows && !isOn) {
                  // FOR WINDOWS
                  netshiftEngineController.startDnsForWindows();
                  stopWatchController.startWatchTime();
                  WindowsLocalNotif(
                    body:
                        "NetShift has successfully connected to the ${netshiftEngineController.selectedDns.value.name}.",
                    title: "Service Started",
                  ).showNotification();
                } else if (Platform.isMacOS && isOn) {
                  // FOR MACOS
                  netshiftEngineController.stopDnsForMacOS();
                  stopWatchController.stopWatchTime();
                  WindowsLocalNotif(
                    body:
                        "NetShift has disconnected from the ${netshiftEngineController.selectedDns.value.name}.",
                    title: "Service Stopped",
                  ).showNotification();
                } else if (Platform.isMacOS && !isOn) {
                  // FOR MACOS
                  netshiftEngineController.startDnsForMacOS();
                  stopWatchController.startWatchTime();
                  WindowsLocalNotif(
                    body:
                        "NetShift has successfully connected to the ${netshiftEngineController.selectedDns.value.name}.",
                    title: "Service Started",
                  ).showNotification();
                }
              },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: math
              .min(ScreenSize.width * 0.55, ScreenSize.height * 0.27)
              .clamp(0, 200),
          width: math
              .min(ScreenSize.width * 0.55, ScreenSize.height * 0.27)
              .clamp(0, 200),
          decoration: BoxDecoration(
            color: isOn
                ? AppColors.connectButtonOn
                : AppColors.connectButtonOff,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: isOn
                    ? AppColors.connectButtonOnShadow
                    : AppColors.connectButtonOffShadow,
                blurRadius: isOn ? 0 : 16,
                spreadRadius: isOn ? 0 / 2 : 6,
              ),
            ],
          ),
          child: BlinkingBorder(
            blinkStyle: isOn ? BlinkStyle.glowing : BlinkStyle.cornerSweep,
            color: AppColors.connectButtonOnShadow,
            strokeWidth: isOn ? 8 : 3,
            duration: Duration(seconds: 2),
            borderRadius: BorderRadius.circular(150),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: isLoading
                  ? SpinKitWave(
                      key: const ValueKey("loading"),
                      color: AppColors.spinKit,
                      size: 40,
                    )
                  : Icon(
                      Icons.power_settings_new_outlined,
                      key: const ValueKey("icon"),
                      size: 120,
                      color: AppColors.powerIcon,
                    ),
            ),
          ),
        ),
      );
    });
  }
}
