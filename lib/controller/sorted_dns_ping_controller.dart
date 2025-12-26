import 'dart:developer';

import 'package:dart_ping/dart_ping.dart';
import 'package:get/get.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/models/dns_model.dart';

class SortedDnsPingController extends GetxController {
  final NetshiftEngineController netshiftEngineController = Get.find();
  RxBool isPinging = false.obs;
  RxMap pingResultMap = {}.obs;
  RxList ananas = [].obs;
  RxList ananas1 = [].obs;
  RxList ananas2 = [].obs;
  RxList ananas3 = [].obs;
  RxList ananas4 = [].obs;
  RxList ananas5 = [].obs;

  List<DnsModel> get combinedList => [
        ...netshiftEngineController.dnsListNetShift,
        ...netshiftEngineController.dnsListPersonal
      ];

  @override
  void onInit() {
    super.onInit();
    sortedPing();
  }

  Future<void> sortedPing() async {
    for (var items in combinedList) {
      isPinging.value = true;

      final primaryPingResult =
          await Ping(items.primaryDNS, count: 1).stream.first;
      final secondaryPingResult =
          await Ping(items.secondaryDNS, count: 1).stream.first;

      if (primaryPingResult.response != null &&
          secondaryPingResult.response != null &&
          primaryPingResult.response!.time != null &&
          secondaryPingResult.response!.time != null) {
        int primaryPing = primaryPingResult.response!.time!.inMilliseconds;
        int secondaryPing = secondaryPingResult.response!.time!.inMilliseconds;
        int avgPing = (primaryPing + secondaryPing) ~/ 2;

        pingResultMap[items.name] = {
          "ping": avgPing.toString(),
          "primary": items.primaryDNS,
          "secondary": items.secondaryDNS,
          "ping1": primaryPing.toString(),
          "ping2": secondaryPing.toString(),
        };
      } else {
        pingResultMap[items.name] = {
          "ping": '-1',
          "primary": items.primaryDNS,
          "secondary": items.secondaryDNS,
          "ping1": '-1',
          "ping2": '-1',
        };
      }
    }

    pingResultMap.value = Map.fromEntries(
      pingResultMap.entries.toList()
        ..sort((a, b) {
          int pingA = int.parse(a.value['ping']!);
          int pingB = int.parse(b.value['ping']!);

          if (pingA == -1) return 1;
          if (pingB == -1) return -1;
          return pingA.compareTo(pingB);
        }),
    );
    for (var items in pingResultMap.entries) {
      ananas.add(items.key);
      ananas1.add(items.value['primary']);
      ananas2.add(items.value['secondary']);
      ananas3.add(items.value['ping']);
      ananas4.add(items.value['ping1']);
      ananas5.add(items.value['ping2']);
    }
    isPinging.value = false;
    log(pingResultMap.toString());
  }

  Future<void> refreshDnsPingResults() async {
    pingResultMap.clear();
    await sortedPing();

    pingResultMap.refresh();
    Get.forceAppUpdate();
  }
}
