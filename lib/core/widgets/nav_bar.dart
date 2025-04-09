
import 'package:flutter/material.dart';
import 'package:netshift/core/resources/app_colors.dart';

class NavBar extends StatelessWidget {
  final Function() onTap;
  final IconData icon;
  final bool isActive;

  const NavBar({
    super.key,
    required this.onTap,
    required this.icon,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.linear,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.mainWrapperNavBarSelected
              : AppColors.mainWrapperNavBarNotSelected,
          shape: BoxShape.circle,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.mainWrapperNavBarSelectedShadow,
                    blurRadius: 8,
                    offset: const Offset(1, 6),
                    spreadRadius: 3,
                  )
                ]
              : [],
        ),
        // child: SvgPicture.asset(
        //   path,
        //   colorFilter: ColorFilter.mode(
        //       AppColors.mainWrapperNavBarIcons, BlendMode.srcIn),
        // ),
        child: Icon(
          icon,
          color: AppColors.mainWrapperNavBarIcons,
          size: 30,
        ),
      ),
    );
  }
}
