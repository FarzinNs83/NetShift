import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netshift/core/resources/media_query_size.dart';
import 'package:netshift/core/services/platform_service.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/controller/single_dns_ping_controller.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/widgets/common/app_bar.dart';
import 'package:netshift/core/widgets/common/custom_button.dart';
import 'package:netshift/core/widgets/common/custom_snack_bar.dart';
import 'package:netshift/core/widgets/dns/dns_configuration_card.dart';
import 'package:netshift/core/widgets/dns/dns_selection_container.dart';
import 'package:netshift/core/widgets/dns/main_dns_selector.dart';
import 'package:netshift/core/widgets/home/mobile_actions_panel.dart';
import 'package:netshift/core/widgets/home/mobile_dns_field.dart';
import 'package:netshift/core/widgets/home/quick_actions_panel.dart';
import 'package:netshift/core/widgets/home/world_map.dart';

class DNSPage extends StatelessWidget {
  DNSPage({super.key});

  final NetshiftEngineController netshiftEngineController = Get.find();

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SingleDnsPingController());
    final SingleDnsPingController dnsPingController = Get.find();

    final isDesktop =
        PlatformService.isDesktop && MediaQuery.of(context).size.width >= 800;

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
          ? _buildDesktopBody()
          : _buildMobileBody(dnsPingController),
    );
  }

  Widget _buildDesktopBody() {
    return Stack(
      children: [
        const WorldMap(),
        Padding(
          padding: const EdgeInsets.all(32),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: DnsConfigurationCard()),
              const SizedBox(width: 32),
              Expanded(flex: 2, child: QuickActionsPanel()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileBody(SingleDnsPingController dnsPingController) {
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
                    onPressed: () => _handleDnsSelection(),
                    color: AppColors.dnsSelectionContainerIcon,
                  ),
                  SizedBox(height: ScreenSize.height * 0.02),
                  MobileDnsField(
                    label: "Primary",
                    dns: netshiftEngineController.selectedDns.value.primaryDNS,
                    isPinging: dnsPingController.isPingP.value,
                    pingResult: dnsPingController.resultPingP,
                  ),
                  SizedBox(height: ScreenSize.height * 0.02),
                  MobileDnsField(
                    label: "Secondary",
                    dns:
                        netshiftEngineController.selectedDns.value.secondaryDNS,
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
                  MobileActionsPanel(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleDnsSelection() {
    if (netshiftEngineController.isActive.value) {
      CustomSnackBar(
        title: "Operation Failed",
        message: "Failed to SELECT DNS, please stop the service first",
        backColor: Colors.red.shade700.withValues(alpha: 0.9),
        iconColor: Colors.white,
        icon: Icons.error_outline,
        textColor: Colors.white,
      ).customSnackBar();
      return;
    }

    showModalBottomSheet(
      sheetAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        reverseDuration: const Duration(milliseconds: 300),
        reverseCurve: Curves.easeInOut,
      ),
      context: Get.context!,
      builder: (context) => MainDNSSelector(),
    );
  }
}
