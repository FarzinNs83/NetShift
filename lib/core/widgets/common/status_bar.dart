import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netshift/core/resources/extention_sized.dart';
import 'package:netshift/core/resources/app_colors.dart';

class StatusIcon extends StatelessWidget {
  final String path;
  final String label;
  final String status;
  final Color color;
  final Function() onTap;
  final Color iconColor;
  const StatusIcon({
    super.key,
    required this.path,
    required this.label,
    required this.status,
    required this.color,
    required this.onTap,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  path,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
                4.width,
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontFamily: 'IRANSansX',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            8.height,
            Text(
              status,
              style: TextStyle(
                color: AppColors.statusText,
                fontFamily: 'IRANSansX',
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
