import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netshift/core/resources/media_query_size.dart';
import 'package:netshift/core/services/platform_service.dart';
import 'package:netshift/controller/blocked_apps_controller.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/controller/theme_controller.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/screens/blocked_apps_screen.dart';
import 'package:netshift/core/widgets/app_bar.dart';
import 'package:netshift/core/widgets/custom_snack_bar.dart';
import 'package:netshift/core/widgets/other_apps_widgets.dart';
import 'package:netshift/core/widgets/settings_custom_card.dart';
import 'package:netshift/core/widgets/support_content.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});
  final ThemeController themeController = Get.find();
  final BlockedAppsController blockedAppsController = Get.find();
  final NetshiftEngineController netshiftEngineController = Get.find();

  @override
  Widget build(BuildContext context) {
    final isDesktop = PlatformService.isDesktop &&
        MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      appBar: isDesktop
          ? null
          : CustomAppBar(
              title: "Settings",
              fontFamily: 'IRANSansX',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              centerTitle: true,
            ),
      backgroundColor: AppColors.background,
      body: isDesktop ? _buildDesktopBody(context) : _buildMobileBody(context),
    );
  }

  Widget _buildDesktopBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              "Settings",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.dnsText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Customize your NetShift experience",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: AppColors.dnsText.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 32),
            // Settings Grid
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column - General Settings
                Expanded(
                  child: _buildSettingsSection(
                    title: "General",
                    children: [
                      _buildDesktopSettingsCard(
                        icon: themeController.isDarkMode
                            ? Icons.dark_mode
                            : Icons.light_mode,
                        title: "Appearance",
                        subtitle: themeController.isDarkMode
                            ? "Dark Mode Enabled"
                            : "Light Mode Enabled",
                        trailing: Switch(
                          activeColor:
                              AppColors.settingsGeneralThemeSwitcherActive,
                          value: themeController.isDarkMode,
                          onChanged: (value) {
                            themeController.toggleTheme();
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDesktopSettingsCard(
                        icon: Icons.apps_rounded,
                        title: "Other Apps",
                        subtitle: "Explore our other applications",
                        onTap: () => _showOtherApps(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                // Right Column - About
                Expanded(
                  child: _buildSettingsSection(
                    title: "About",
                    children: [
                      _buildDesktopSettingsCard(
                        icon: Icons.info_outline,
                        title: "App Version",
                        subtitle: _getVersionString(),
                      ),
                      const SizedBox(height: 16),
                      _buildDesktopSettingsCard(
                        icon: Icons.contact_support_outlined,
                        title: "Support",
                        subtitle: "Get help and contact us",
                        onTap: () => _showSupport(context),
                      ),
                      const SizedBox(height: 16),
                      _buildDesktopSettingsCard(
                        icon: Icons.code,
                        title: "Platform",
                        subtitle: _getPlatformString(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.isDarkMode
            ? const Color(0xFF1E2025)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.isDarkMode
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.indigo.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color:
                      AppColors.isDarkMode ? Colors.greenAccent : Colors.indigo,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.settingsGeneralCategory,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDesktopSettingsCard({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return MouseRegion(
      cursor:
          onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.isDarkMode
                ? const Color(0xFF262626)
                : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.isDarkMode
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.indigo.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.isDarkMode
                      ? Colors.greenAccent.withValues(alpha: 0.1)
                      : Colors.indigo.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: AppColors.settingsIconColors,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.settingsCustomCardTitle,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: AppColors.settingsCustomCardSubTitle,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing,
              if (onTap != null && trailing == null)
                Icon(
                  Icons.chevron_right,
                  color: AppColors.isDarkMode
                      ? Colors.greenAccent.withValues(alpha: 0.5)
                      : Colors.indigo.withValues(alpha: 0.5),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "General",
              style: TextStyle(
                color: AppColors.settingsGeneralCategory,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              color: AppColors.settingsGeneralCategoryDivider,
              thickness: 1.2,
              height: 32,
            ),
            const SizedBox(height: 16),
            SettingsCustomCard(
              title: "Dark Mode",
              subtitle: "Enable dark theme",
              icon: themeController.isDarkMode
                  ? Icons.dark_mode
                  : Icons.light_mode,
              trailing: Switch(
                activeColor: AppColors.settingsGeneralThemeSwitcherActive,
                value: themeController.isDarkMode,
                onChanged: (value) {
                  themeController.toggleTheme();
                },
              ),
            ),
            Platform.isAndroid
                ? SettingsCustomCard(
                    title: "Split Tunneling",
                    subtitle: "Filter apps ",
                    icon: Icons.app_blocking_outlined,
                    trailing: Icon(
                      Icons.keyboard_arrow_right_outlined,
                      color: AppColors.settingsSplitTunneling,
                      size: 29,
                    ),
                    onTap: () {
                      if (!netshiftEngineController.isActive.value) {
                        if (blockedAppsController.apps.isEmpty) {
                          blockedAppsController.installedApps();
                        }
                        Get.to(() => BlockedAppsScreen());
                      } else {
                        CustomSnackBar(
                          title: "Operation Failed",
                          message:
                              "Failed to OPEN, please stop the service first",
                          backColor:
                              Colors.red.shade700.withValues(alpha: 0.9),
                          iconColor: Colors.white,
                          icon: Icons.error_outline,
                          textColor: Colors.white,
                        ).customSnackBar();
                      }
                    },
                  )
                : const SizedBox(),
            const SizedBox(height: 16),
            SettingsCustomCard(
              title: "Other Apps",
              subtitle: "See What Apps We Created",
              icon: Icons.apps_rounded,
              trailing: Icon(
                Icons.keyboard_arrow_right_outlined,
                color: AppColors.settingsSplitTunneling,
                size: 29,
              ),
              onTap: () => _showOtherApps(context),
            ),
            const SizedBox(height: 32),
            Text(
              "About",
              style: TextStyle(
                color: AppColors.settingsAboutCategory,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              color: AppColors.settingsAboutDivider,
              thickness: 1.2,
              height: 32,
            ),
            const SizedBox(height: 16),
            SettingsCustomCard(
              title: "App Version",
              subtitle: _getVersionString(),
              icon: Icons.info,
              onTap: () {},
            ),
            const SizedBox(height: 16),
            SettingsCustomCard(
              title: "Support",
              subtitle: "Contact support team",
              icon: Icons.contact_support,
              trailing: Icon(
                Icons.keyboard_arrow_right_outlined,
                color: AppColors.settingsSupport,
                size: 29,
              ),
              onTap: () => _showSupport(context),
            ),
          ],
        ),
      ),
    );
  }

  String _getVersionString() {
    if (Platform.isWindows) return "Version 1.0.4";
    if (Platform.isMacOS) return "Version 1.1.0";
    return "Version 1.0.0";
  }

  String _getPlatformString() {
    if (Platform.isMacOS) return "macOS";
    if (Platform.isWindows) return "Windows";
    if (Platform.isLinux) return "Linux";
    if (Platform.isAndroid) return "Android";
    if (Platform.isIOS) return "iOS";
    return "Unknown";
  }

  void _showOtherApps(BuildContext context) {
    showModalBottomSheet(
      context: context,
      sheetAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
        reverseDuration: const Duration(milliseconds: 300),
        reverseCurve: Curves.fastOutSlowIn,
      ),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          width: double.infinity,
          height: ScreenSize.height * 0.2,
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 15.0,
          ),
          decoration: BoxDecoration(
            color: AppColors.settingsCustomCardBackground,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: const OtherAppsWidget(),
        );
      },
    );
  }

  void _showSupport(BuildContext context) {
    showModalBottomSheet(
      context: context,
      sheetAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
        reverseDuration: const Duration(milliseconds: 300),
        reverseCurve: Curves.fastOutSlowIn,
      ),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          width: double.infinity,
          height: ScreenSize.height * 0.2,
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 15.0,
          ),
          decoration: BoxDecoration(
            color: AppColors.settingsCustomCardBackground,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: const SupportContent(),
        );
      },
    );
  }
}
