import 'package:dart_ping/dart_ping.dart';
import 'package:get/get.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';

class SingleDnsPingController extends GetxController {
  final NetshiftEngineController netshiftEngineController = Get.find();
  RxBool isPingP = false.obs;
  RxBool isPingS = false.obs;
  RxString resultPingP = ''.obs;
  RxString resultPingS = ''.obs;
  @override
  void onInit() {
    super.onInit();
    pingPrimaryDns();
    pingSecondaryDns();
  }

  Future<void> pingPrimaryDns() async {
    isPingP.value = true;
    final primaryPingResult = await Ping(
      netshiftEngineController.selectedDns.value.primaryDNS,
      count: 1,
    ).stream.first;
    if (primaryPingResult.response != null &&
        primaryPingResult.response!.time != null) {
      resultPingP.value = primaryPingResult.response!.time!.inMilliseconds
          .toString();
    } else {
      resultPingP.value = "-1";
    }
    isPingP.value = false;
  }

  Future<void> pingSecondaryDns() async {
    isPingS.value = true;
    final secondaryPingResult = await Ping(
      netshiftEngineController.selectedDns.value.secondaryDNS,
      count: 1,
    ).stream.first;
    if (secondaryPingResult.response != null &&
        secondaryPingResult.response!.time != null) {
      resultPingS.value = secondaryPingResult.response!.time!.inMilliseconds
          .toString();
    } else {
      resultPingS.value = "-1";
    }
    isPingS.value = false;
  }
}
