import 'package:get/get.dart';
import 'package:netshift/controller/blocked_apps_controller.dart';
import 'package:netshift/controller/check_for_update_controller.dart';
import 'package:netshift/controller/foreground_controller.dart';
import 'package:netshift/controller/glow_controller.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/controller/splash_controller.dart';
import 'package:netshift/controller/stop_watch_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashScreenController());
    Get.lazyPut(() => NetshiftEngineController());
    Get.lazyPut(() => CheckForUpdateController());
    Get.lazyPut(() => ForegroundController());
    Get.lazyPut(() => StopWatchController());
    Get.lazyPut(() => GlowController());
    Get.lazyPut(() => BlockedAppsController());
  }
}

