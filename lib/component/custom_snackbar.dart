import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dns_changer/theme/theme_provider.dart';

void showCustomSnackBar(BuildContext context, String message) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  final theme = themeProvider.theme;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: theme.snackBarTheme.backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    ),
  );
}
