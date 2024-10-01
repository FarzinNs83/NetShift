// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dns_changer/theme/theme_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; 
import 'package:url_launcher/url_launcher.dart'; 

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // متد برای بررسی وجود به‌روزرسانی
  Future<bool> _checkForUpdate() async {
    const apiUrl =
        'https://api.mrsf.ir/api/update/check/?id=1005'; 

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['updateAvailable'] == true) {
          return true;
        }
      }
    } catch (e) {
      debugPrint('Error checking for update: $e');
    }

    return false;
  }


  Future<String?> _getDownloadLink() async {
    const apiUrl =
        'https://api.mrsf.ir/api/update/download/?id=1005'; 

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['downloadUrl'];
      }
    } catch (e) {
      debugPrint('Error getting download link: $e');
    }

    return null;
  }

  Future<void> _downloadUpdate() async {
    final downloadLink = await _getDownloadLink();

    if (downloadLink != null && downloadLink.isNotEmpty) {
      if (await canLaunch(downloadLink)) {
        await launch(downloadLink);
      } else {
        throw 'Could not launch $downloadLink';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.theme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Settings'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          _buildSettingTile(
            context,
            title: 'Dark Mode',
            icon: theme.brightness == Brightness.dark
                ? Icons.nightlight_round
                : Icons.wb_sunny,
            iconColor: theme.brightness == Brightness.dark
                ? Colors.yellow
                : Colors.orange,
            onTap: () {
              themeProvider.toggleTheme();
            },
          ),
          _buildSettingTile(
            context,
            title: 'Check for Updates',
            icon: Icons.system_update,
            onTap: () async {
              bool updateAvailable = await _checkForUpdate();
              if (updateAvailable) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Update available! Click to download.'),
                    action: SnackBarAction(
                      label: 'Download',
                      onPressed: _downloadUpdate,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No updates available.')),
                );
              }
            },
          ),
          
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required String title,
    String? subtitle,
    required IconData icon,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.theme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.textTheme.titleMedium?.color,
                ),
              )
            : null,
        trailing: Icon(
          icon,
          color: iconColor ?? theme.iconTheme.color,
        ),
        onTap: onTap,
      ),
    );
  }
}
