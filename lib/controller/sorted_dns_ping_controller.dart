import 'dart:async';
import 'dart:developer';

import 'package:dart_ping/dart_ping.dart';
import 'package:get/get.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/models/dns_model.dart';

class SortedDnsPingController extends GetxController {
  final NetshiftEngineController netshiftEngineController = Get.find();
  RxBool isPinging = false.obs;
  RxMap<String, Map<String, String>> pingResultMap =
      <String, Map<String, String>>{}.obs;
  RxList<String> ananas = <String>[].obs;
  RxList<String> ananas1 = <String>[].obs;
  RxList<String> ananas2 = <String>[].obs;
  RxList<String> ananas3 = <String>[].obs;
  RxList<String> ananas4 = <String>[].obs;
  RxList<String> ananas5 = <String>[].obs;
  RxInt completedCount = 0.obs;
  RxInt totalCount = 0.obs;

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
    isPinging.value = true;
    completedCount.value = 0;
    totalCount.value = combinedList.length;

    // Launch all pings in parallel
    List<Future<void>> pingFutures = [];
    for (var item in combinedList) {
      pingFutures.add(_pingDns(item));
    }

    // Wait for all to complete
    await Future.wait(pingFutures);

    // Sort results and update display lists
    _sortAndUpdateLists();
    isPinging.value = false;
    log(pingResultMap.toString());
  }

  Future<void> _pingDns(DnsModel item) async {
    try {
      // Ping both DNS servers in parallel with timeout
      final results = await Future.wait([
        _pingWithTimeout(item.primaryDNS),
        _pingWithTimeout(item.secondaryDNS),
      ]);

      int primaryPing = results[0];
      int secondaryPing = results[1];
      int avgPing =
          (primaryPing == -1 || secondaryPing == -1)
              ? -1
              : (primaryPing + secondaryPing) ~/ 2;

      pingResultMap[item.name] = {
        "ping": avgPing.toString(),
        "primary": item.primaryDNS,
        "secondary": item.secondaryDNS,
        "ping1": primaryPing.toString(),
        "ping2": secondaryPing.toString(),
      };

      completedCount.value++;

      // Update sorted lists immediately so UI shows new result
      _sortAndUpdateLists();
    } catch (e) {
      log('Error pinging ${item.name}: $e');
      pingResultMap[item.name] = {
        "ping": '-1',
        "primary": item.primaryDNS,
        "secondary": item.secondaryDNS,
        "ping1": '-1',
        "ping2": '-1',
      };
      completedCount.value++;
      _sortAndUpdateLists();
    }
  }

  Future<int> _pingWithTimeout(String address) async {
    try {
      final ping = Ping(address, count: 1, timeout: 4);
      final result = await ping.stream.first.timeout(
        const Duration(seconds: 5),
        onTimeout: () => PingData(
          response: null,
          summary: null,
          error: PingError(ErrorType.requestTimedOut),
        ),
      );

      if (result.response != null && result.response!.time != null) {
        return result.response!.time!.inMilliseconds;
      }
      return -1;
    } catch (e) {
      return -1;
    }
  }

  void _sortAndUpdateLists() {
    // Sort by ping (fastest first, timeouts last)
    var sortedEntries = pingResultMap.entries.toList()
      ..sort((a, b) {
        int pingA = int.parse(a.value['ping']!);
        int pingB = int.parse(b.value['ping']!);

        if (pingA == -1 && pingB == -1) return 0;
        if (pingA == -1) return 1;
        if (pingB == -1) return -1;
        return pingA.compareTo(pingB);
      });

    // Clear and rebuild display lists
    ananas.clear();
    ananas1.clear();
    ananas2.clear();
    ananas3.clear();
    ananas4.clear();
    ananas5.clear();

    for (var entry in sortedEntries) {
      ananas.add(entry.key);
      ananas1.add(entry.value['primary']!);
      ananas2.add(entry.value['secondary']!);
      ananas3.add(entry.value['ping']!);
      ananas4.add(entry.value['ping1']!);
      ananas5.add(entry.value['ping2']!);
    }

    // Force UI update
    pingResultMap.refresh();
  }

  Future<void> refreshDnsPingResults() async {
    pingResultMap.clear();
    ananas.clear();
    ananas1.clear();
    ananas2.clear();
    ananas3.clear();
    ananas4.clear();
    ananas5.clear();
    await sortedPing();
  }
}
