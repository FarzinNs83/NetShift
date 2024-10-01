import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dns_changer/theme/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
            icon: theme.brightness == Brightness.dark ? Icons.nightlight_round : Icons.wb_sunny,
            iconColor: theme.brightness == Brightness.dark ? Colors.yellow : Colors.orange,
            onTap: () {
              themeProvider.toggleTheme();
            },
          ),
          _buildSettingTile(
            context,
            title: 'Version Info',
            subtitle: '1.0.2',
            icon: Icons.info_outline,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('App version 1.0.2')),
              );
            },
          ),
          _buildSettingTile(
            context,
            title: 'Contact Us',
            icon: Icons.email_outlined,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contacs will be availabe soon.')),
              );
            },
          ),
          _buildSettingTile(
            context,
            title: 'Privacy Policy',
            icon: Icons.lock_outline,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Privacy policy link will be available soon.')),
              );
            },
          ),
          _buildSettingTile(
            context,
            title: 'Terms of Service',
            icon: Icons.description_outlined,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Terms of service link will be available soon.')),
              );
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
