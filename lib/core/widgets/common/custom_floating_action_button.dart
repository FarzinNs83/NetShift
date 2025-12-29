import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netshift/core/resources/app_colors.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final String path;
  final Function() onTap;
  const CustomFloatingActionButton({
    super.key,
    required this.path,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            AppColors.dnsSelectionCustomFloatingActionButtonBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(18),
        elevation: 2,
        minimumSize: const Size(60, 60),
      ),
      onPressed: onTap,
      child: SvgPicture.asset(path),
    );
  }
}
