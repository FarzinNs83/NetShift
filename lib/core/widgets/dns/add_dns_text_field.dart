import 'package:flutter/material.dart';
import 'package:netshift/core/resources/app_colors.dart';

class AddDNSTextField extends StatelessWidget {
  final String label;
  final Icon suffixIcon;
  final TextEditingController controller;

  const AddDNSTextField({
    super.key,
    required this.label,
    required this.suffixIcon,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller,
        cursorColor: AppColors.addDnsTextField,
        style: TextStyle(
          color: AppColors.textfieldTextColor,
          fontFamily: 'Poppins',
          fontSize: 16,
        ),
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          suffixIconColor: AppColors.addDnsTextField,
          filled: true,
          fillColor: AppColors.addDnsTextFieldBack,
          labelText: label,
          labelStyle: TextStyle(
            color: AppColors.addDnsTextField,
            fontSize: 15,
            fontFamily: 'Poppins',
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.addDnsTextFieldActivated,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.addDnsTextFieldFocused,
              width: 2,
            ),
          ),
          hintStyle: TextStyle(
            color: Colors.grey.withValues(alpha: 0.8),
            fontSize: 14,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
