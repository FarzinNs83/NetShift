import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netshift/controller/splash_controller.dart';
import 'package:netshift/controller/stop_watch_controller.dart';
import 'package:netshift/core/services/platform_service.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/widgets/home/connect_button.dart';
import 'package:netshift/core/widgets/home/connection_controls_panel.dart';
import 'package:netshift/core/widgets/dns/dns_status.dart';
import 'package:netshift/core/widgets/home/home_app_bar.dart';
import 'package:netshift/core/widgets/home/mobile_status_icons.dart';
import 'package:netshift/core/widgets/common/offline_banner.dart';
import 'package:netshift/core/widgets/home/status_cards_panel.dart';
import 'package:netshift/core/widgets/home/world_map.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final StopWatchController stopWatchController = Get.find();
  final SplashScreenController splashController = Get.find();

  @override
  Widget build(BuildContext context) {
    final isDesktop =
        PlatformService.isDesktop && MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: isDesktop ? null : const HomeAppBar(),
      body: isDesktop ? _buildDesktopBody() : _buildMobileBody(),
    );
  }

  Widget _buildDesktopBody() {
    return Stack(
      children: [
        const WorldMap(),
        Padding(
          padding: const EdgeInsets.all(32),
          child: Row(
            children: [
              Expanded(flex: 3, child: ConnectionControlsPanel()),
              const SizedBox(width: 32),
              Expanded(flex: 2, child: StatusCardsPanel()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileBody() {
    return Stack(
      children: [
        const WorldMap(),
        Obx(
          () => SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (splashController.isOffline.value)
                  OfflineBanner(splashController: splashController)
                else
                  const SizedBox(),
                Text(
                  stopWatchController.formatDuration(
                    stopWatchController.elapsedTime.value,
                  ),
                  style: TextStyle(
                    fontFamily: 'IRANSansX',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.timer,
                  ),
                ),
                ConnectButton(),
                const DNSStatus(),
                MobileStatusIcons(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
