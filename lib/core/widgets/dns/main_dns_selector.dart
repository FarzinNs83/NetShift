import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netshift/core/resources/media_query_size.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/widgets/dns/dns_selection.dart';
import 'package:netshift/core/widgets/dns/dns_selector_bottom_sheet_netshift.dart';
import 'package:netshift/core/widgets/dns/dns_selector_bottom_sheet_personal.dart';

class MainDNSSelector extends StatelessWidget {
  MainDNSSelector({super.key});
  final NetshiftEngineController netshiftEngineController = Get.put(
    NetshiftEngineController(),
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenSize.height * 0.35,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.mainDnsSelectorSheet,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: ScreenSize.height * 0.006,
            width: ScreenSize.width * 0.09,
            decoration: BoxDecoration(
              color: AppColors.mainDnsSelectorSheetTongue,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DNSSelection(
                icon: Icons.wifi_password_rounded,
                name: 'NetShift DNS',
                onPressed: () {
                  Navigator.of(context).pop();
                  showModalBottomSheet(
                    isScrollControlled: true,
                    sheetAnimationStyle: AnimationStyle(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.fastOutSlowIn,
                      reverseDuration: const Duration(milliseconds: 300),
                      reverseCurve: Curves.fastOutSlowIn,
                    ),
                    context: context,
                    backgroundColor: AppColors.mainDnsSelectorSheetColor,
                    builder: (context) {
                      return DNSSelectorBottomSheetNetShift();
                    },
                  );
                },
              ),
              DNSSelection(
                icon: Icons.dns_outlined,
                name: 'Personal DNS',
                onPressed: () {
                  Navigator.of(context).pop();
                  showModalBottomSheet(
                    isScrollControlled: true,
                    sheetAnimationStyle: AnimationStyle(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.fastOutSlowIn,
                      reverseDuration: const Duration(milliseconds: 300),
                      reverseCurve: Curves.fastOutSlowIn,
                    ),
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return DNSSelectorBottomSheetPersonal();
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
