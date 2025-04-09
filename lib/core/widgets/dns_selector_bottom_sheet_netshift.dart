
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/controller/single_dns_ping_controller.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/widgets/dis.dart';

class DNSSelectorBottomSheetNetShift extends StatelessWidget {
  DNSSelectorBottomSheetNetShift({
    super.key,
  });
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select DNS',
                        style: TextStyle(
                          color:
                              AppColors.dnsSelectionContainerNetShiftAppBarText,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color:
                              AppColors.dnsSelectionContainerNetShiftCloseIcon,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: netshiftEngineController.dnsListNetShift.length,
                    itemBuilder: (context, index) {
                      final dns =
                          netshiftEngineController.dnsListNetShift[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            netshiftEngineController.selectedDns.value = dns;
                            dnsPingController.pingPrimaryDns();
                            dnsPingController.pingSecondaryDns();
                            netshiftEngineController.saveSelectedDnsValue();
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: AppColors
                                  .dnsSelectionContainerNetShiftContainer,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors
                                    .dnsSelectionContainerNetShiftBorderContainer,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      netshiftEngineController
                                          .dnsListNetShift[index].name,
                                      style: TextStyle(
                                        color: AppColors
                                            .dnsSelectionContainerNetShiftDnsName,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Primary: ${netshiftEngineController.dnsListNetShift[index].primaryDNS}",
                                      style: TextStyle(
                                        color: AppColors
                                            .dnsSelectionContainerNetShiftDns,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'Secondary: ${netshiftEngineController.dnsListNetShift[index].secondaryDNS}',
                                      style: TextStyle(
                                        color: AppColors
                                            .dnsSelectionContainerNetShiftDns,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                netshiftEngineController
                                        .dnsListNetShift[index].name
                                        .contains('*')
                                    ? const Icon(
                                        Icons.remove_circle,
                                        color: Color.fromARGB(255, 255, 30, 0),
                                      )
                                    : const Icon(
                                        Icons.check_circle,
                                        color: Color.fromARGB(255, 48, 136, 51),
                                      ),
                              ],
                            ),
                          ),
                        ),
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
