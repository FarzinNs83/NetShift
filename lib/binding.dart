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
    Get.lazyPut(() => SplashScreenController(), fenix: true);
    Get.lazyPut(() => NetshiftEngineController(), fenix: true);
    Get.lazyPut(() => CheckForUpdateController(), fenix: true);
    Get.lazyPut(() => ForegroundController(), fenix: true);
    Get.lazyPut(() => StopWatchController(), fenix: true);
    Get.lazyPut(() => GlowController(), fenix: true);
    Get.lazyPut(() => BlockedAppsController(), fenix: true);
  }
}

