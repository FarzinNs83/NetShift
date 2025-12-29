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
  RxList<String> dnsNames = <String>[].obs;
  RxList<String> primaryDnsList = <String>[].obs;
  RxList<String> secondaryDnsList = <String>[].obs;
  RxList<String> avgPingList = <String>[].obs;
  RxList<String> primaryPingList = <String>[].obs;
  RxList<String> secondaryPingList = <String>[].obs;
  RxInt completedCount = 0.obs;
  RxInt totalCount = 0.obs;

  List<DnsModel> get combinedList => [
    ...netshiftEngineController.dnsListNetShift,
    ...netshiftEngineController.dnsListPersonal,
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
    List<Future<void>> pingFutures = <Future<void>>[];
    for (DnsModel item in combinedList) {
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
      int avgPing = (primaryPing == -1 || secondaryPing == -1)
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
    List<MapEntry<String, Map<String, String>>> sortedEntries =
        pingResultMap.entries.toList()..sort((
          MapEntry<String, Map<String, String>> a,
          MapEntry<String, Map<String, String>> b,
        ) {
          int pingA = int.parse(a.value['ping']!);
          int pingB = int.parse(b.value['ping']!);

          if (pingA == -1 && pingB == -1) return 0;
          if (pingA == -1) return 1;
          if (pingB == -1) return -1;
          return pingA.compareTo(pingB);
        });

    // Clear and rebuild display lists
    dnsNames.clear();
    primaryDnsList.clear();
    secondaryDnsList.clear();
    avgPingList.clear();
    primaryPingList.clear();
    secondaryPingList.clear();

    for (MapEntry<String, Map<String, String>> entry in sortedEntries) {
      dnsNames.add(entry.key);
      primaryDnsList.add(entry.value['primary']!);
      secondaryDnsList.add(entry.value['secondary']!);
      avgPingList.add(entry.value['ping']!);
      primaryPingList.add(entry.value['ping1']!);
      secondaryPingList.add(entry.value['ping2']!);
    }

    // Force UI update
    pingResultMap.refresh();
  }

  Future<void> refreshDnsPingResults() async {
    pingResultMap.clear();
    dnsNames.clear();
    primaryDnsList.clear();
    secondaryDnsList.clear();
    avgPingList.clear();
    primaryPingList.clear();
    secondaryPingList.clear();
    await sortedPing();
  }
}
