import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/controller/stop_watch_controller.dart';

class ForegroundController extends GetxController {
  static const platform = MethodChannel("com.netshift.dnschanger/netdns");
  RxBool isRunning = false.obs;
  static const EventChannel statusChannel = EventChannel(
    "com.netshift.dnschanger/netdnsStatus",
  );
  String foregroundStatus = "none";
  RxString download = "0.00 MB".obs;
  RxString upload = "0.00 MB".obs;
  RxBool serviceStatus = false.obs;
  StreamSubscription? dataUsageSubscription;
  final status = GetStorage();
  NetshiftEngineController netshiftEngineController = Get.put(
    NetshiftEngineController(),
  );
  StopWatchController stopWatchController = Get.put(StopWatchController());
  Future<void> startService(String contextText) async {
    log("Foreground Service Started");
    try {
      await platform.invokeMethod("startService", {"contentText": contextText});
      isRunning.value = true;
      // statusService.write('isServiceRunning', true);
    } on PlatformException catch (e) {
      log("Service Failed to Start $e");
    }
  }

  Future<void> stopService() async {
    isRunning.value = false;
    // statusService.write('isServiceRunning', false);
    log("Foreground Service Stopped");
    try {
      await platform.invokeMethod("stopService");
    } on PlatformException catch (e) {
      log("Service Failed to Stop $e");
    }
    download.value = "0.00 MB";
    upload.value = "0.00 MB";
  }

  void listenToServiceStatus() {
    platform.setMethodCallHandler((call) async {
      if (call.method == "serviceStatusUpdate") {
        serviceStatus.value = call.arguments as bool;
        log("Service status updated: ${serviceStatus.value}");
        loadServiceStatus();
      } else if (call.method == 'dataUsageUpdate') {
        final Map<dynamic, dynamic> data = call.arguments;
        download.value =
            "${(data['download'] / (1024 * 1024)).toStringAsFixed(2)} MB";
        upload.value =
            "${(data['upload'] / (1024 * 1024)).toStringAsFixed(2)} MB";
      }
    });
  }

  Future<bool> serviceStatusKotlin() async {
    try {
      final bool stats = await platform.invokeMethod('getServiceStatus');
      return stats;
    } on PlatformException catch (e) {
      log("Error Getting service status : $e");
      return false;
    }
  }

  void ananas() async {
    serviceStatus.value = await serviceStatusKotlin();
    loadServiceStatus();
    log("****Service Status ananas : ${serviceStatus.value}****");
    log(
      "****Service Status ananas1 : ${netshiftEngineController.isActive.value}****",
    );
  }

  void loadServiceStatus() {
    if (netshiftEngineController.isActive.value && !serviceStatus.value) {
      log("Sabotaging");
      stopService();
      netshiftEngineController.isActive.value = false;
      netshiftEngineController.stopDnsForAndroid();
      stopWatchController.stopWatchTime();
      stopWatchController.timerBox.write('isRunning', false);
      stopWatchController.elapsedTime.value = Duration.zero;
    } else {
      log("Just Doing Nothing");
    }
  }

  @override
  void onClose() {
    dataUsageSubscription?.cancel();
    super.onClose();
  }
}
