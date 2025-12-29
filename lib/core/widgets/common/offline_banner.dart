import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netshift/controller/splash_controller.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/resources/extention_sized.dart';
import 'package:netshift/core/services/windows_local_notif.dart';
import 'package:netshift/core/widgets/common/flutter_toast.dart';
import 'package:netshift/screens/splash_screen.dart';

class OfflineBanner extends StatelessWidget {
  final SplashScreenController splashController;

  const OfflineBanner({super.key, required this.splashController});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Switch Back To ",
          style: TextStyle(
            color: AppColors.offlineStatusText,
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        6.width,
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(
              color: Color.fromARGB(255, 20, 255, 118),
              width: 2,
            ),
            backgroundColor: Colors.black.withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => _switchToOnlineMode(splashController),
          child: const Text(
            "Online Mode",
            style: TextStyle(
              color: Color.fromARGB(255, 20, 255, 118),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _switchToOnlineMode(SplashScreenController splashController) {
    if (Platform.isWindows || Platform.isMacOS) {
      WindowsLocalNotif(
        body: "Starting in Online Mode",
        title: "NetShift Service",
      ).showNotification();
    } else if (Platform.isAndroid) {
      FlutterToast(message: "Starting in Online Mode").flutterToast();
    }

    splashController.online.remove('offline');
    splashController.getDnsListOnline();
    Get.offAll(() => SplashScreen());
  }
}
