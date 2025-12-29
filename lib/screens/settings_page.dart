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
import 'package:netshift/core/widgets/common/app_bar.dart';
import 'package:netshift/core/widgets/common/custom_snack_bar.dart';
import 'package:netshift/core/widgets/desktop/desktop_settings_card.dart';
import 'package:netshift/core/widgets/settings/other_apps_widgets.dart';
import 'package:netshift/core/widgets/settings/settings_custom_card.dart';
import 'package:netshift/core/widgets/settings/settings_section.dart';
import 'package:netshift/core/widgets/settings/support_content.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});
  final ThemeController themeController = Get.find();
  final BlockedAppsController blockedAppsController = Get.find();
  final NetshiftEngineController netshiftEngineController = Get.find();

  @override
  Widget build(BuildContext context) {
    final isDesktop =
        PlatformService.isDesktop && MediaQuery.of(context).size.width >= 800;

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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SettingsSection(
                    title: "General",
                    children: [
                      DesktopSettingsCard(
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
                      DesktopSettingsCard(
                        icon: Icons.apps_rounded,
                        title: "Other Apps",
                        subtitle: "Explore our other applications",
                        onTap: () => _showOtherApps(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: SettingsSection(
                    title: "About",
                    children: [
                      DesktopSettingsCard(
                        icon: Icons.info_outline,
                        title: "App Version",
                        subtitle: _getVersionString(),
                      ),
                      const SizedBox(height: 16),
                      DesktopSettingsCard(
                        icon: Icons.contact_support_outlined,
                        title: "Support",
                        subtitle: "Get help and contact us",
                        onTap: () => _showSupport(context),
                      ),
                      const SizedBox(height: 16),
                      DesktopSettingsCard(
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
                          backColor: Colors.red.shade700.withValues(alpha: 0.9),
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
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
          decoration: BoxDecoration(
            color: AppColors.settingsCustomCardBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
          decoration: BoxDecoration(
            color: AppColors.settingsCustomCardBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: const SupportContent(),
        );
      },
    );
  }
}
