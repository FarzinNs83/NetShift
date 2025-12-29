import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netshift/core/services/platform_service.dart';
import 'package:netshift/controller/single_dns_ping_controller.dart';
import 'package:netshift/controller/sorted_dns_ping_controller.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/models/dns_model.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/widgets/common/app_bar.dart';
import 'package:netshift/core/widgets/common/custom_snack_bar.dart';
import 'package:netshift/core/widgets/dns/dns_ping_card.dart';
import 'package:netshift/core/widgets/common/flutter_toast.dart';
import 'package:netshift/core/widgets/ping/ping_header.dart';
import 'package:netshift/core/widgets/ping/ping_loading_state.dart';
import 'package:netshift/core/widgets/ping/ping_progress_indicator.dart';

class DNSPing extends StatelessWidget {
  DNSPing({super.key});

  final NetshiftEngineController netshiftEngineController = Get.find();

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SortedDnsPingController());
    final dnsPingController = Get.find<SortedDnsPingController>();
    Get.lazyPut(() => SingleDnsPingController());
    final singleDnsPingController = Get.find<SingleDnsPingController>();

    final isDesktop =
        PlatformService.isDesktop && MediaQuery.of(context).size.width >= 800;

    return Obx(
      () => Scaffold(
        floatingActionButton: _buildFab(dnsPingController),
        backgroundColor: AppColors.background,
        appBar: isDesktop
            ? null
            : CustomAppBar(
                centerTitle: true,
                title: "DNS Ping Result",
                fontSize: 24,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
        body: isDesktop
            ? _buildDesktopBody(dnsPingController, singleDnsPingController)
            : _buildMobileBody(dnsPingController, singleDnsPingController),
      ),
    );
  }

  Widget _buildFab(SortedDnsPingController controller) {
    return FloatingActionButton(
      backgroundColor: AppColors.dnsPingflashBack,
      onPressed: () => _handleRefresh(controller),
      child: controller.isPinging.value
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.dnsPingflash,
              ),
            )
          : Icon(Icons.flash_on, size: 32, color: AppColors.dnsPingflash),
    );
  }

  Widget _buildDesktopBody(
    SortedDnsPingController dnsPingController,
    SingleDnsPingController singleDnsPingController,
  ) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PingHeader(
            controller: dnsPingController,
            onRefresh: () => _handleRefresh(dnsPingController),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: _buildDesktopContent(
              dnsPingController,
              singleDnsPingController,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopContent(
    SortedDnsPingController dnsPingController,
    SingleDnsPingController singleDnsPingController,
  ) {
    if (dnsPingController.pingResultMap.isEmpty) {
      return const PingLoadingState();
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 2.2,
      ),
      itemCount: dnsPingController.dnsNames.length,
      itemBuilder: (context, index) => DnsPingCard(
        name: dnsPingController.dnsNames[index],
        primaryDns: dnsPingController.primaryDnsList[index],
        secondaryDns: dnsPingController.secondaryDnsList[index],
        avgPing: dnsPingController.avgPingList[index],
        primaryPing: dnsPingController.primaryPingList[index],
        secondaryPing: dnsPingController.secondaryPingList[index],
        isDesktop: true,
        onApply: () =>
            _handleApply(dnsPingController, singleDnsPingController, index),
      ),
    );
  }

  Widget _buildMobileBody(
    SortedDnsPingController dnsPingController,
    SingleDnsPingController singleDnsPingController,
  ) {
    if (dnsPingController.pingResultMap.isEmpty) {
      return const PingLoadingState();
    }

    return Column(
      children: [
        PingProgressIndicator(
          completed: dnsPingController.completedCount.value,
          total: dnsPingController.totalCount.value,
          isVisible: dnsPingController.isPinging.value,
          isMobile: true,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
            child: ListView.builder(
              itemCount: dnsPingController.dnsNames.length,
              itemBuilder: (context, index) => DnsPingCard(
                name: dnsPingController.dnsNames[index],
                primaryDns: dnsPingController.primaryDnsList[index],
                secondaryDns: dnsPingController.secondaryDnsList[index],
                avgPing: dnsPingController.avgPingList[index],
                primaryPing: dnsPingController.primaryPingList[index],
                secondaryPing: dnsPingController.secondaryPingList[index],
                onApply: () => _handleApply(
                  dnsPingController,
                  singleDnsPingController,
                  index,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleRefresh(SortedDnsPingController controller) {
    if (controller.isPinging.value) {
      CustomSnackBar(
        title: "Operation Failed",
        message: "Failed to Ping, Please Wait for the Ping to Complete",
        backColor: Colors.red.shade700.withValues(alpha: 0.9),
        iconColor: Colors.white,
        icon: Icons.error_outline,
        textColor: Colors.white,
      ).customSnackBar();
      return;
    }
    controller.refreshDnsPingResults();
    if (Platform.isAndroid) {
      FlutterToast(message: "Pinging...").flutterToast();
    }
  }

  void _handleApply(
    SortedDnsPingController dnsPingController,
    SingleDnsPingController singleDnsPingController,
    int index,
  ) {
    if (PlatformService.isDesktop && netshiftEngineController.isActive.value) {
      _showErrorSnackBar("Failed to apply DNS, please stop the service first");
      return;
    }

    if (Platform.isAndroid && netshiftEngineController.isActive.value) {
      _showErrorSnackBar(
        "Failed to START SERVICE, please stop the service first",
      );
      return;
    }

    if ((Platform.isAndroid &&
            netshiftEngineController.isPermissionGiven.value) ||
        Platform.isWindows ||
        Platform.isMacOS) {
      if (!netshiftEngineController.isActive.value) {
        _applyDns(dnsPingController, singleDnsPingController, index);
      }
    }
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

  void _applyDns(
    SortedDnsPingController dnsPingController,
    SingleDnsPingController singleDnsPingController,
    int index,
  ) {
    netshiftEngineController.selectedDns.value = DnsModel(
      name: dnsPingController.dnsNames[index],
      primaryDNS: dnsPingController.primaryDnsList[index],
      secondaryDNS: dnsPingController.secondaryDnsList[index],
    );
    netshiftEngineController.saveSelectedDnsValue();
    singleDnsPingController.pingPrimaryDns();
    singleDnsPingController.pingSecondaryDns();
    CustomSnackBar(
      title: "Operation Success",
      message:
          "${netshiftEngineController.selectedDns.value.name} Has Been Applied Successfully",
      backColor: const Color.fromARGB(255, 50, 189, 122).withValues(alpha: 0.9),
      iconColor: Colors.white,
      icon: Icons.check_circle_outline,
      textColor: Colors.white,
    ).customSnackBar();
  }
}
