import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:netshift/core/widgets/common/flutter_toast.dart';

class DoubleTapToExit extends StatefulWidget {
  final Widget child;

  const DoubleTapToExit({super.key, required this.child});

  @override
  State<DoubleTapToExit> createState() => _DoubleTapToExitState();
}

class _DoubleTapToExitState extends State<DoubleTapToExit> {
  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      child: widget.child,
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) >
                const Duration(seconds: 2)) {
          currentBackPressTime = now;
          FlutterToast(message: "Tap again to exit").flutterToast();
          return Future.value(false);
        }
        SystemNavigator.pop();
        return Future.value(true);
      },
    );
  }
}
