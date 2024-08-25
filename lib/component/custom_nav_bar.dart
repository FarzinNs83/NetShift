import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:dns_changer/theme/theme_provider.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChange;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.theme;

    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16), 
          topRight: Radius.circular(16)
        ),
        color: theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.bottomNavigationBarTheme.selectedItemColor!
                .withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, -7),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: GNav(
            rippleColor: theme.bottomNavigationBarTheme.selectedItemColor!
                .withOpacity(0.2),
            hoverColor: theme.bottomNavigationBarTheme.selectedItemColor!
                .withOpacity(0.1),
            gap: 8,
            color: theme.bottomNavigationBarTheme.unselectedItemColor!,
            activeColor: theme.bottomNavigationBarTheme.selectedItemColor!,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: theme
                .bottomNavigationBarTheme.selectedItemColor!
                .withOpacity(0.2),
            backgroundColor: theme.bottomNavigationBarTheme.backgroundColor!,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.dns,
                text: 'DNS Selection',
              ),
              GButton(
                icon: Icons.speed,
                text: 'Fastest DNS',
              ),
              GButton(
                icon: Icons.settings,
                text: 'Settings',
              ),
            ],
            selectedIndex: selectedIndex,
            onTabChange: onTabChange,
          ),
        ),
      ),
    );
  }
}
