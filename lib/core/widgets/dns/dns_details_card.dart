import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/controller/single_dns_ping_controller.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/widgets/dns/dns_info_row.dart';

class DnsDetailsCard extends StatelessWidget {
  DnsDetailsCard({super.key});

  final NetshiftEngineController netshiftEngineController = Get.find();

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SingleDnsPingController());
    final SingleDnsPingController dnsPingController = Get.find();

    return Obx(
      () => Container(
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  dnsPingController.pingPrimaryDns();
                  dnsPingController.pingSecondaryDns();
                },
                icon: const Icon(Icons.speed, size: 20),
                label: const Text("Test DNS Latency"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.isDarkMode
                      ? const Color(0xFF16725C)
                      : Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
