import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netshift/controller/splash_controller.dart';
import 'package:netshift/controller/stop_watch_controller.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/widgets/home/connect_button.dart';
import 'package:netshift/core/widgets/dns/dns_status.dart';
import 'package:netshift/core/widgets/common/offline_banner.dart';

class ConnectionControlsPanel extends StatelessWidget {
  ConnectionControlsPanel({super.key});

  final StopWatchController stopWatchController = Get.find();
  final SplashScreenController splashController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (splashController.isOffline.value)
            OfflineBanner(splashController: splashController),
          const SizedBox(height: 20),
          Text(
            stopWatchController.formatDuration(
              stopWatchController.elapsedTime.value,
            ),
            style: TextStyle(
              fontFamily: 'IRANSansX',
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppColors.timer,
            ),
          ),
          const SizedBox(height: 40),
          ConnectButton(),
          const SizedBox(height: 40),
          const DNSStatus(),
        ],
      ),
    );
  }
}
