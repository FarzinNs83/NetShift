import 'package:flutter/material.dart';
import 'package:netshift/gen/assets.gen.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:window_manager/window_manager.dart';

class MacOSTitleBarBox extends StatelessWidget {
  const MacOSTitleBarBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      color: AppColors.backgroundAppBar,
      child: Row(
        children: [
          // macOS traffic light buttons spacing
          const SizedBox(width: 70),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanStart: (_) => windowManager.startDragging(),
              child: Row(
                children: [
                  Image.asset(Assets.png.tray, width: 16, height: 16),
                  const SizedBox(width: 8),
                  const Text(
                    'NetShift',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
