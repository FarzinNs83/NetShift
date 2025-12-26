import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:netshift/core/resources/extention_sized.dart';
import 'package:netshift/core/resources/media_query_size.dart';
import 'package:netshift/core/services/platform_service.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/controller/random_dns_generator_controller.dart';
import 'package:netshift/controller/single_dns_ping_controller.dart';
import 'package:netshift/controller/splash_controller.dart';
import 'package:netshift/gen/assets.gen.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/widgets/action_card.dart';
import 'package:netshift/core/widgets/add_dns.dart';
import 'package:netshift/core/widgets/app_bar.dart';
import 'package:netshift/core/widgets/custom_floating_action_button.dart';
import 'package:netshift/core/widgets/custom_textfield.dart';
import 'package:netshift/core/widgets/dns_generator_dialog.dart';
import 'package:netshift/core/widgets/dns_info_row.dart';
import 'package:netshift/core/widgets/dns_selection_container.dart';
import 'package:netshift/core/widgets/custom_button.dart';
import 'package:netshift/core/widgets/main_dns_selector.dart';
import 'package:netshift/core/widgets/custom_snack_bar.dart';
import 'package:netshift/core/widgets/world_map.dart';

class DNSPage extends StatelessWidget {
  DNSPage({super.key});

  final NetshiftEngineController netshiftEngineController = Get.find();
  final splashScreenController = Get.find<SplashScreenController>();

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SingleDnsPingController());
    final dnsPingController = Get.find<SingleDnsPingController>();
    Get.lazyPut(() => RandomDnsGeneratorController());
    final randomDnsGeneratorController = Get.find<RandomDnsGeneratorController>();

    final isDesktop = PlatformService.isDesktop &&
        MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: isDesktop
          ? null
          : CustomAppBar(
              title: "Select DNS",
              fontFamily: 'Poppins',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              centerTitle: true,
            ),
      backgroundColor: AppColors.background,
      body: isDesktop
          ? _buildDesktopBody(context, dnsPingController, randomDnsGeneratorController)
          : _buildMobileBody(context, dnsPingController, randomDnsGeneratorController),
    );
  }

  Widget _buildDesktopBody(
    BuildContext context,
    SingleDnsPingController dnsPingController,
    RandomDnsGeneratorController randomDnsGeneratorController,
  ) {
    return Stack(
      children: [
        const WorldMap(),
        Obx(
          () => Padding(
            padding: const EdgeInsets.all(32),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildDnsConfiguration(context, dnsPingController),
                ),
                const SizedBox(width: 32),
                Expanded(
                  flex: 2,
                  child: _buildQuickActions(context, randomDnsGeneratorController),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDnsConfiguration(BuildContext context, SingleDnsPingController dnsPingController) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "DNS Configuration",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.dnsText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Select and configure your preferred DNS servers",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: AppColors.dnsText.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 32),
          DnsSelectionContainer(
            onPressed: () => _handleDnsSelection(context),
            color: AppColors.dnsSelectionContainerIcon,
          ),
          const SizedBox(height: 32),
          _buildDnsDetailsCard(dnsPingController),
        ],
      ),
    );
  }

  Widget _buildDnsDetailsCard(SingleDnsPingController dnsPingController) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.isDarkMode
            ? const Color(0xFF1E2025)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.isDarkMode
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.indigo.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          DnsInfoRow(
            label: "Primary DNS",
            dns: netshiftEngineController.selectedDns.value.primaryDNS,
            isPinging: dnsPingController.isPingP.value,
            pingResult: dnsPingController.resultPingP,
          ),
          const SizedBox(height: 20),
          Divider(
            color: AppColors.isDarkMode
                ? Colors.white12
                : Colors.indigo.withValues(alpha: 0.1),
          ),
          const SizedBox(height: 20),
          DnsInfoRow(
            label: "Secondary DNS",
            dns: netshiftEngineController.selectedDns.value.secondaryDNS,
            isPinging: dnsPingController.isPingS.value,
            pingResult: dnsPingController.resultPingS,
          ),
          const SizedBox(height: 24),
          _buildPingButton(dnsPingController),
        ],
      ),
    );
  }

  Widget _buildPingButton(SingleDnsPingController dnsPingController) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          dnsPingController.pingPrimaryDns();
          dnsPingController.pingSecondaryDns();
        },
        icon: const Icon(Icons.speed, size: 20),
        label: const Text("Test DNS Latency"),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.isDarkMode ? const Color(0xFF16725C) : Colors.indigo,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, RandomDnsGeneratorController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.dnsText,
          ),
        ),
        const SizedBox(height: 20),
        ActionCard(
          icon: Icons.auto_fix_high,
          title: "Generate Random DNS",
          subtitle: "Auto-generate optimized DNS settings",
          onTap: () => _handleGenerateDns(context, controller),
        ),
        const SizedBox(height: 16),
        ActionCard(
          icon: Icons.add_circle_outline,
          title: "Add Custom DNS",
          subtitle: "Configure your own DNS servers",
          onTap: () => _handleAddDns(context),
        ),
        const SizedBox(height: 16),
        ActionCard(
          icon: Icons.dns_rounded,
          title: "Browse DNS Providers",
          subtitle: "Choose from popular DNS services",
          onTap: () => _handleDnsSelection(context),
        ),
      ],
    );
  }

  Widget _buildMobileBody(
    BuildContext context,
    SingleDnsPingController dnsPingController,
    RandomDnsGeneratorController randomDnsGeneratorController,
  ) {
    return Stack(
      children: [
        const WorldMap(),
        Obx(
          () => SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: ScreenSize.height * 0.02),
                  DnsSelectionContainer(
                    onPressed: () => _handleDnsSelection(context),
                    color: AppColors.dnsSelectionContainerIcon,
                  ),
                  SizedBox(height: ScreenSize.height * 0.02),
                  _buildMobileDnsField(
                    label: "Primary",
                    dns: netshiftEngineController.selectedDns.value.primaryDNS,
                    isPinging: dnsPingController.isPingP.value,
                    pingResult: dnsPingController.resultPingP,
                  ),
                  SizedBox(height: ScreenSize.height * 0.02),
                  _buildMobileDnsField(
                    label: "Secondary",
                    dns: netshiftEngineController.selectedDns.value.secondaryDNS,
                    isPinging: dnsPingController.isPingS.value,
                    pingResult: dnsPingController.resultPingS,
                  ),
                  SizedBox(height: ScreenSize.height * 0.03),
                  CustomButton(
                    text: "Ping",
                    onTap: () {
                      dnsPingController.pingPrimaryDns();
                      dnsPingController.pingSecondaryDns();
                    },
                  ),
                  const Spacer(),
                  _buildMobileActions(context, randomDnsGeneratorController),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileDnsField({
    required String label,
    required String dns,
    required bool isPinging,
    required dynamic pingResult,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$label :",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.dnsText,
              ),
            ),
            isPinging
                ? SpinKitCircle(color: AppColors.spinKitColor, size: 22)
                : Text(
                    "$pingResult ms",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: AppColors.dnsText,
                    ),
                  ),
          ],
        ),
        8.height,
        CustomTextContainer(dns: dns),
      ],
    );
  }

  Widget _buildMobileActions(BuildContext context, RandomDnsGeneratorController controller) {
    return Padding(
      padding: const EdgeInsets.only(right: 12, left: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomFloatingActionButton(
            path: Assets.svg.generateDns,
            onTap: () => _handleGenerateDns(context, controller),
          ),
          CustomFloatingActionButton(
            path: Assets.svg.addDns,
            onTap: () => _handleAddDns(context),
          ),
        ],
      ),
    );
  }

  void _handleDnsSelection(BuildContext context) {
    if (netshiftEngineController.isActive.value) {
      _showErrorSnackBar("Failed to SELECT DNS, please stop the service first");
      return;
    }

    showModalBottomSheet(
      sheetAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        reverseDuration: const Duration(milliseconds: 300),
        reverseCurve: Curves.easeInOut,
      ),
      context: context,
      builder: (context) => MainDNSSelector(),
    );
  }

  void _handleGenerateDns(BuildContext context, RandomDnsGeneratorController controller) {
    if (splashScreenController.isOffline.value) {
      _showErrorSnackBar("Failed to GENERATE DNS, please start the app in online mode");
      return;
    }

    controller.generateRandomDns();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DnsGeneratorDialog(),
    );
  }

  void _handleAddDns(BuildContext context) {
    if (netshiftEngineController.isActive.value) {
      _showErrorSnackBar("Failed to ADD DNS, please stop the service first");
      return;
    }

    showModalBottomSheet(
      context: context,
      sheetAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
        reverseDuration: const Duration(milliseconds: 300),
        reverseCurve: Curves.fastOutSlowIn,
      ),
      isScrollControlled: true,
      builder: (context) => const AddDnsBottomSheet(),
    );
  }

  void _showErrorSnackBar(String message) {
    CustomSnackBar(
      title: "Operation Failed",
      message: message,
      backColor: Colors.red.shade700.withValues(alpha: 0.9),
      iconColor: Colors.white,
      icon: Icons.error_outline,
      textColor: Colors.white,
    ).customSnackBar();
  }
}
