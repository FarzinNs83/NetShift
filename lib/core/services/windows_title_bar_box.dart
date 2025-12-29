import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:netshift/gen/assets.gen.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/services/windows_local_notif.dart';

class WindowsTitleBarBox extends StatelessWidget {
  const WindowsTitleBarBox({super.key});

  @override
  Widget build(BuildContext context) {
    return WindowTitleBarBox(
      child: Container(
        color: AppColors.backgroundAppBar,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: MoveWindow(
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Image.asset(Assets.png.tray, width: 16, height: 16),
                    const SizedBox(width: 8),
                    const Text(
                      'NetShift',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Row(children: [MinimizeWindowButton(), CloseWindowButton()]),
          ],
        ),
      ),
    );
  }
}

class MinimizeWindowButton extends StatelessWidget {
  const MinimizeWindowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.remove, color: AppColors.windowsTitleBarIcon),
      onPressed: () {
        appWindow.minimize();
      },
      tooltip: 'Minimize',
    );
  }
}

class CloseWindowButton extends StatelessWidget {
  const CloseWindowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.close, color: AppColors.windowsTitleBarIcon),
      onPressed: () {
        appWindow.hide();
        WindowsLocalNotif(
          body: "NetShift is running in the background",
          title: "Minimized to Tray",
        ).showNotification();
      },
      tooltip: 'Close',
    );
  }
}
