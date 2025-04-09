import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netshift/controller/theme_controller.dart';
import 'package:netshift/core/resources/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String title;
  final String fontFamily;
  final double fontSize;
  final FontWeight fontWeight;
  final bool centerTitle;
  final List<Widget> actions;
  CustomAppBar({
    super.key,
    this.height = kToolbarHeight,
    required this.title,
    required this.fontFamily,
    required this.fontSize,
    required this.fontWeight,
    this.centerTitle = false,
    this.actions = const [],
  });
  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return AppBar(
        centerTitle: centerTitle,
        backgroundColor: AppColors.background,
        title: Text(
          title,
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: 24,
            fontWeight: fontWeight,
            color: AppColors.textAppBar,
          ),
        ),
        actions: actions);
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
