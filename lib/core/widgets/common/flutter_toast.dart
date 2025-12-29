import 'dart:developer';

import 'package:flutter/services.dart';

class FlutterToast {
  final String message;
  static const platform = MethodChannel('com.netshift.dnschanger/toast');
  FlutterToast({required this.message});
  Future<void> flutterToast() async {
    try {
      await platform.invokeMethod('showToast', {'message': message});
    } on PlatformException catch (e) {
      log("Service Failed to Start $e");
    }
  }
}
