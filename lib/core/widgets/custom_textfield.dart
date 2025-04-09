import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netshift/gen/assets.gen.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/widgets/custom_snack_bar.dart';

class CustomTextContainer extends StatelessWidget {
  final String dns;
  const CustomTextContainer({
    super.key,
    required this.dns,
  });

  void copyToClipboard(BuildContext context, String dns) {
    Clipboard.setData(ClipboardData(text: dns));
    CustomSnackBar(
      title: "Clipboard",
      message: "DNS has been copied!",
      backColor: const Color.fromARGB(255, 50, 189, 122),
      iconColor: Colors.white,
      icon: Icons.check_circle_outline_outlined,
      textColor: Colors.white,
    ).customSnackBar();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.dnsSelectionContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              dns,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: AppColors.dnsSelectionContainerSelectedDnsAddress,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: SvgPicture.asset(
              Assets.svg.copy,
              colorFilter:
                  ColorFilter.mode(AppColors.dnsSelectionCopy, BlendMode.srcIn),
            ),
            onPressed: () => copyToClipboard(context, dns),
          ),
        ],
      ),
    );
  }
}
