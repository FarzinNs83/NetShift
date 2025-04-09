import 'dart:developer';

import 'package:get/get.dart';
import 'package:netshift/controller/foreground_controller.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/controller/single_dns_ping_controller.dart';
import 'package:netshift/controller/stop_watch_controller.dart';
import 'package:netshift/core/services/windows_local_notif.dart';
import 'package:netshift/core/widgets/flutter_toast.dart';

class RestartEngine extends GetxController {
    final dnsPingController = Get.find<SingleDnsPingController>();
        final NetshiftEngineController netshiftEngineController = Get.find();
  final StopWatchController stopWatchController = Get.find();
  final ForegroundController foregroundController = Get.find();

  void restartEngineAndroid() async {
    log('Ananas1');

    await netshiftEngineController.stopDnsForAndroid();
    await foregroundController.stopService();
    stopWatchController.stopWatchTime();

    await netshiftEngineController.startDnsForAndroid();
    await foregroundController
        .startService(netshiftEngineController.selectedDns.value.name);
    stopWatchController.startWatchTime();

    FlutterToast(message: "Service Restarted Successfully").flutterToast();
  }

  void startEngineAndroid() {
    netshiftEngineController.startDnsForAndroid();
    foregroundController
        .startService(netshiftEngineController.selectedDns.value.name);
    stopWatchController.startWatchTime();
    netshiftEngineController.isActive.value = true;
    FlutterToast(message: "Service Started Successfully").flutterToast();
  }

  void restartEngineWindows() async {
    await netshiftEngineController.stopDnsForWindows();
    stopWatchController.stopWatchTime();
    await netshiftEngineController.startDnsForWindows();
    stopWatchController.startWatchTime();
    WindowsLocalNotif(body: "Service Restarted Successfully", title: "NetShift");
  }

  void startEngineWindows() {
    netshiftEngineController.startDnsForWindows();
    stopWatchController.startWatchTime();
    WindowsLocalNotif(body: "Service Started Successfully", title: "NetShift");
  }
}
