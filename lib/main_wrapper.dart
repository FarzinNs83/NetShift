import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netshift/core/resources/media_query_size.dart';
import 'package:netshift/controller/main_wrapper_controller.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/services/platform_service.dart';
import 'package:netshift/core/services/windows_title_bar_box.dart';
import 'package:netshift/core/services/macos_title_bar_box.dart';
import 'package:netshift/core/widgets/desktop/desktop_sidebar.dart';
import 'package:netshift/core/widgets/common/double_tap_to_exit.dart';
import 'package:netshift/core/widgets/common/nav_bar.dart';

class MainWrapper extends StatelessWidget {
  MainWrapper({super.key});

  final MainWrapperController mainWrapperController =
      Get.put(MainWrapperController());

  @override
  Widget build(BuildContext context) {
    // Use desktop layout for macOS and Windows on larger screens
    final isDesktopLayout =
        PlatformService.isDesktop && MediaQuery.of(context).size.width >= 800;

    if (isDesktopLayout) {
      return _buildDesktopLayout(context);
    }
    return _buildMobileLayout(context);
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainWrapperBackground,
      body: Column(
        children: [
          // Title bar for Windows/macOS
          if (Platform.isWindows) const WindowsTitleBarBox(),
          if (Platform.isMacOS) const MacOSTitleBarBox(),
          // Main content with sidebar
          Expanded(
            child: Row(
              children: [
                // Sidebar navigation
                DesktopSidebar(),
                // Main content area
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: Platform.isMacOS
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(12),
                            )
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: Platform.isMacOS
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(12),
                            )
                          : BorderRadius.zero,
                      child: Obx(() => mainWrapperController.selectedPage),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return DoubleTapToExit(
      child: Scaffold(
        // WINDOWS (small window)
        appBar: Platform.isWindows
            ? const PreferredSize(
                preferredSize: Size.fromHeight(60),
                child: WindowsTitleBarBox(),
              )
            : null,
        backgroundColor: AppColors.mainWrapperBackground,
        body: Obx(() => mainWrapperController.selectedPage),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.all(9),
              width: ScreenSize.width,
              decoration: BoxDecoration(
                gradient: GradientAppColors.mainWrapperBottomNavContainer,
                borderRadius: BorderRadius.circular(36),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.mainWrapperShadow,
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: BottomAppBar(
                color: Colors.transparent,
                elevation: 0,
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      NavBar(
                        onTap: () => mainWrapperController.onSelectPage(0),
                        icon: Icons.home_max_outlined,
                        isActive:
                            mainWrapperController.selectedIndex.value == 0,
                      ),
                      NavBar(
                        onTap: () => mainWrapperController.onSelectPage(1),
                        icon: Icons.dns_rounded,
                        isActive:
                            mainWrapperController.selectedIndex.value == 1,
                      ),
                      NavBar(
                        onTap: () => mainWrapperController.onSelectPage(2),
                        icon: Icons.speed_rounded,
                        isActive:
                            mainWrapperController.selectedIndex.value == 2,
                      ),
                      NavBar(
                        onTap: () => mainWrapperController.onSelectPage(3),
                        icon: Icons.settings_outlined,
                        isActive:
                            mainWrapperController.selectedIndex.value == 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
