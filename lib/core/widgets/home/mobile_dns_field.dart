import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:netshift/core/resources/extention_sized.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/widgets/common/custom_textfield.dart';

class MobileDnsField extends StatelessWidget {
  const MobileDnsField({
    super.key,
    required this.label,
    required this.dns,
    required this.isPinging,
    required this.pingResult,
  });

  final String label;
  final String dns;
  final bool isPinging;
  final dynamic pingResult;

  @override
  Widget build(BuildContext context) {
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
}
