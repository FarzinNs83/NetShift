import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netshift/controller/main_wrapper_controller.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/gen/assets.gen.dart';

class DesktopSidebar extends StatelessWidget {
  DesktopSidebar({super.key});

  final MainWrapperController mainWrapperController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.isDarkMode
              ? [const Color(0xFF1A1B21), const Color(0xFF1E2025)]
              : [
                  const Color.fromARGB(255, 231, 218, 250),
                  const Color.fromARGB(255, 220, 205, 245),
                ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.isDarkMode
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.indigo.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 50),
          // App Logo and Name
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: GradientAppColors.dnsStatusBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.isDarkMode
                            ? Colors.greenAccent.withValues(alpha: 0.3)
                            : Colors.indigo.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Image.asset(Assets.png.tray, width: 28, height: 28),
                ),
                const SizedBox(width: 12),
                Text(
                  'NetShift',
                  style: TextStyle(
                    fontFamily: 'Calistoga',
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textAppBar,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Divider(
            color: AppColors.isDarkMode
                ? Colors.greenAccent.withValues(alpha: 0.2)
                : Colors.indigo.withValues(alpha: 0.2),
            height: 1,
            indent: 20,
            endIndent: 20,
          ),
          const SizedBox(height: 20),
          // Navigation Items
          Obx(
            () => Column(
              children: [
                _SidebarItem(
                  icon: Icons.home_max_outlined,
                  label: 'Home',
                  isActive: mainWrapperController.selectedIndex.value == 0,
                  onTap: () => mainWrapperController.onSelectPage(0),
                ),
                _SidebarItem(
                  icon: Icons.dns_rounded,
                  label: 'DNS Settings',
                  isActive: mainWrapperController.selectedIndex.value == 1,
                  onTap: () => mainWrapperController.onSelectPage(1),
                ),
                _SidebarItem(
                  icon: Icons.speed_rounded,
                  label: 'DNS Ping',
                  isActive: mainWrapperController.selectedIndex.value == 2,
                  onTap: () => mainWrapperController.onSelectPage(2),
                ),
                _SidebarItem(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  isActive: mainWrapperController.selectedIndex.value == 3,
                  onTap: () => mainWrapperController.onSelectPage(3),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Version info at bottom
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Version 1.1.0',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: AppColors.isDarkMode
                    ? Colors.white54
                    : Colors.indigo.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: widget.isActive
                ? GradientAppColors.dnsStatusBackground
                : null,
            color: isHovered && !widget.isActive
                ? (AppColors.isDarkMode
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.indigo.withValues(alpha: 0.1))
                : null,
            borderRadius: BorderRadius.circular(12),
            boxShadow: widget.isActive
                ? [
                    BoxShadow(
                      color: AppColors.isDarkMode
                          ? Colors.greenAccent.withValues(alpha: 0.3)
                          : Colors.indigo.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: widget.isActive
                    ? Colors.white
                    : (AppColors.isDarkMode
                          ? Colors.white70
                          : Colors.indigo.withValues(alpha: 0.8)),
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(
                widget.label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: widget.isActive
                      ? FontWeight.w600
                      : FontWeight.w500,
                  color: widget.isActive
                      ? Colors.white
                      : (AppColors.isDarkMode
                            ? Colors.white70
                            : Colors.indigo.withValues(alpha: 0.8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
