import 'package:flutter/material.dart';
import 'package:netshift/core/resources/app_colors.dart';

class DnsApplyButton extends StatelessWidget {
  const DnsApplyButton({
    super.key,
    required this.onPressed,
    required this.isDisabled,
    this.isDesktop = false,
  });

  final VoidCallback? onPressed;
  final bool isDisabled;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: isDisabled
                ? Colors.grey
                : AppColors.dnsPingApplyButtonForeground,
            padding: const EdgeInsets.symmetric(vertical: 10),
            side: BorderSide(
              color: isDisabled
                  ? Colors.grey
                  : AppColors.dnsPingApplyButtonBorder,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: isDisabled ? null : onPressed,
          child: const Text("Apply DNS"),
        ),
      );
    }

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: isDisabled
            ? Colors.grey
            : AppColors.dnsPingApplyButtonForeground,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: const TextStyle(fontSize: 14, fontFamily: 'IRANSansX'),
        side: BorderSide(
          color: isDisabled ? Colors.grey : AppColors.dnsPingApplyButtonBorder,
          width: 2,
        ),
      ),
      onPressed: isDisabled ? null : onPressed,
      child: const Text("Apply"),
    );
  }
}
