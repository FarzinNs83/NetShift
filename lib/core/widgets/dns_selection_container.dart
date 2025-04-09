import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netshift/core/resources/extention_sized.dart';
import 'package:netshift/core/resources/media_query_size.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/core/resources/app_colors.dart';

class DnsSelectionContainer extends StatelessWidget {
  final Function() onPressed;
  final Color color;
  DnsSelectionContainer({
    super.key,
    required this.onPressed,
    required this.color,
  });

  final NetshiftEngineController netshiftEngineController =
      Get.put(NetshiftEngineController());
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(24),
        backgroundColor: AppColors.dnsSelectionContainer,
        side: BorderSide(
          color: color,
          width: 2,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: SizedBox(
          width: ScreenSize.height * 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                netshiftEngineController.selectedDns.value.name,
                style: TextStyle(
                  color: AppColors.dnsSelectionContainerName,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              8.width,
              Icon(
                Icons.keyboard_arrow_down_outlined,
                color: AppColors.dnsSelectionContainerName,
              ),
            ],
          )),
    );
  }
}
