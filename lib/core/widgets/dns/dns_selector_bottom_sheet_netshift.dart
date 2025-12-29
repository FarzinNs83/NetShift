import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/controller/single_dns_ping_controller.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/widgets/common/dis.dart';
import 'package:netshift/core/widgets/dns/dns_list_item_netshift.dart';

class DNSSelectorBottomSheetNetShift extends StatelessWidget {
  DNSSelectorBottomSheetNetShift({super.key});
  final NetshiftEngineController netshiftEngineController = Get.find();
  final SingleDnsPingController dnsPingController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Dis(
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.7,
        minChildSize: 0.3,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.dnsSelectionContainerNetShiftBackground,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                _DnsSelectorHeader(onClose: () => Navigator.pop(context)),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: netshiftEngineController.dnsListNetShift.length,
                    itemBuilder: (context, index) {
                      final dns =
                          netshiftEngineController.dnsListNetShift[index];
                      return DnsListItemNetshift(
                        dns: dns,
                        onTap: () {
                          netshiftEngineController.selectedDns.value = dns;
                          dnsPingController.pingPrimaryDns();
                          dnsPingController.pingSecondaryDns();
                          netshiftEngineController.saveSelectedDnsValue();
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DnsSelectorHeader extends StatelessWidget {
  const _DnsSelectorHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Select DNS',
            style: TextStyle(
              color: AppColors.dnsSelectionContainerNetShiftAppBarText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: Icon(
              Icons.close,
              color: AppColors.dnsSelectionContainerNetShiftCloseIcon,
            ),
          ),
        ],
      ),
    );
  }
}
