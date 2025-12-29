import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackBar {
  final String title;
  final String message;
  final Color backColor;
  final Color iconColor;
  final Color textColor;
  final IconData icon;
  CustomSnackBar({
    required this.title,
    required this.message,
    required this.backColor,
    required this.iconColor,
    required this.icon,
    required this.textColor,
  });
  void customSnackBar() {
    Get.snackbar(
      title,
      message,
      backgroundColor: backColor,
      colorText: textColor,
      titleText: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins',
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      icon: Icon(icon, color: iconColor, size: 32),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      borderRadius: 10,
      isDismissible: true,
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      snackStyle: SnackStyle.FLOATING,
      barBlur: 3,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}
