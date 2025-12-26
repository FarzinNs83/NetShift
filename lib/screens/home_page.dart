import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:netshift/controller/foreground_controller.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/controller/splash_controller.dart';
import 'package:netshift/controller/stop_watch_controller.dart';
import 'package:netshift/core/services/platform_service.dart';
import 'package:netshift/gen/assets.gen.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/widgets/app_bar.dart';
import 'package:netshift/core/widgets/connect_button.dart';
import 'package:netshift/core/widgets/custom_snack_bar.dart';
import 'package:netshift/core/widgets/desktop_status_card.dart';
import 'package:netshift/core/widgets/dns_status.dart';
import 'package:netshift/core/widgets/interface_selection_dialog.dart';
import 'package:netshift/core/widgets/offline_banner.dart';
import 'package:netshift/core/widgets/status_bar.dart';
import 'package:netshift/core/widgets/world_map.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final NetshiftEngineController netshiftEngineController = Get.find();
  final StopWatchController stopWatchController = Get.find();
  final ForegroundController foregroundController = Get.find();
  final SplashScreenController splashController = Get.find();

  @override
  Widget build(BuildContext context) {
    final isDesktop = PlatformService.isDesktop &&
        MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: isDesktop ? null : _buildMobileAppBar(),
      body: isDesktop ? _buildDesktopBody(context) : _buildMobileBody(context),
    );
  }

  PreferredSizeWidget _buildMobileAppBar() {
    return CustomAppBar(
      title: "NetShift",
      fontFamily: 'Calistoga',
      fontSize: 24,
      fontWeight: FontWeight.w600,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: OutlinedButton(
            onPressed: () {},
            style: ButtonStyle(
              side: const WidgetStatePropertyAll(BorderSide.none),
              backgroundColor: WidgetStatePropertyAll(AppColors.iconAppBar),
            ),
            child: SvgPicture.asset(Assets.svg.crown),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopBody(BuildContext context) {
    return Stack(
      children: [
        const WorldMap(),
        Obx(
          () => Padding(
            padding: const EdgeInsets.all(32),
            child: Row(
              children: [
                Expanded(flex: 3, child: _buildConnectionControls()),
                const SizedBox(width: 32),
                Expanded(flex: 2, child: _buildStatusCards(context)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConnectionControls() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (splashController.isOffline.value)
          OfflineBanner(splashController: splashController),
        const SizedBox(height: 20),
        Text(
          stopWatchController.formatDuration(stopWatchController.elapsedTime.value),
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
    );
  }

  Widget _buildStatusCards(BuildContext context) {
    return Column(
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
    );
  }

  Widget _buildMobileBody(BuildContext context) {
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
                  stopWatchController.formatDuration(stopWatchController.elapsedTime.value),
                  style: TextStyle(
                    fontFamily: 'IRANSansX',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.timer,
                  ),
                ),
                ConnectButton(),
                const DNSStatus(),
                _buildMobileStatusIcons(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileStatusIcons(BuildContext context) {
    return Row(
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
