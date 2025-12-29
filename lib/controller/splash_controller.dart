import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'package:dio/dio.dart' as dio_pkg;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:netshift/controller/check_for_update_controller.dart';
import 'package:netshift/controller/dio_config.dart';
import 'package:netshift/controller/foreground_controller.dart';
import 'package:netshift/core/services/url_constant.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/main_wrapper.dart';
import 'package:netshift/models/dns_model.dart';
import 'package:netshift/core/widgets/settings/check_for_update_widget.dart';

class SplashScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> progressController;
  final NetshiftEngineController netshiftEngineController = Get.find();
  final CheckForUpdateController checkForUpdateController = Get.find();
  final ForegroundController foregroundController = Get.find();
  RxBool isOnline = true.obs;
  RxBool isOffline = false.obs;
  final offline = GetStorage();
  final online = GetStorage();
  RxList<DnsModel> newOnlineDnsList = RxList();
  RxBool isError = false.obs;
  final ReceivePort receivePort = ReceivePort();
  List<DnsModel> newOfflineDnsList = [
    DnsModel(
      name: 'NetShift DNS',
      primaryDNS: "178.22.122.100",
      secondaryDNS: "78.157.42.100",
    ),
    DnsModel(
      name: 'Electro DNS',
      primaryDNS: "78.157.42.100",
      secondaryDNS: "78.157.42.101",
    ),
    DnsModel(
      name: 'Radar DNS',
      primaryDNS: "10.202.10.10",
      secondaryDNS: "10.202.10.11",
    ),
    DnsModel(
      name: 'Shelter DNS',
      primaryDNS: "78.157.60.6",
      secondaryDNS: "78.157.60.242",
    ),
    DnsModel(
      name: 'Google DNS',
      primaryDNS: "8.8.8.8",
      secondaryDNS: "8.8.4.4",
    ),
    DnsModel(
      name: 'CloudFlare DNS',
      primaryDNS: "1.1.1.1",
      secondaryDNS: "1.0.0.1",
    ),
    DnsModel(
      name: 'Open DNS',
      primaryDNS: "208.67.222.222",
      secondaryDNS: "208.67.220.220",
    ),
    DnsModel(
      name: 'Quad9 DNS (AD)',
      primaryDNS: "9.9.9.9",
      secondaryDNS: "149.112.112.112",
    ),
    DnsModel(
      name: 'Beshkan DNS',
      primaryDNS: "181.41.194.177",
      secondaryDNS: "181.41.194.186",
    ),
    DnsModel(
      name: 'Shecan DNS',
      primaryDNS: "178.22.122.100",
      secondaryDNS: "185.51.200.2",
    ),
    DnsModel(
      name: '403 DNS',
      primaryDNS: "10.202.10.202",
      secondaryDNS: "10.202.10.102",
    ),
    DnsModel(
      name: 'Begzar DNS',
      primaryDNS: "185.55.226.26",
      secondaryDNS: "185.55.226.25",
    ),
    DnsModel(
      name: 'Shatel DNS',
      primaryDNS: "85.15.1.14",
      secondaryDNS: "85.15.1.15",
    ),
    DnsModel(
      name: 'Pishgaman DNS',
      primaryDNS: "5.202.100.100",
      secondaryDNS: "5.202.100.101",
    ),
    DnsModel(
      name: 'Level3 DNS',
      primaryDNS: "209.244.0.3",
      secondaryDNS: "209.244.0.4",
    ),
    DnsModel(
      name: 'Comodo Secure DNS',
      primaryDNS: "8.26.56.26",
      secondaryDNS: "8.20.247.20",
    ),
    DnsModel(
      name: 'Verisign DNS',
      primaryDNS: "64.6.64.6",
      secondaryDNS: "64.6.65.6",
    ),
  ];

  @override
  void onInit() async {
    super.onInit();
    configureDio();
    if (Platform.isAndroid) {
      foregroundController.serviceStatusKotlin();
      foregroundController.ananas();
      foregroundController.listenToServiceStatus();
    }
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    loadOnline();
    loadOffline();
    if (isOnline.value) {
      if (Platform.isAndroid) {
        checkForUpdateController.checkForUpdateAndroid();
      } else if (Platform.isWindows) {
        checkForUpdateController.checkForUpdateWindows();
      } else if (Platform.isLinux) {
        checkForUpdateController.checkForUpdateLinux();
      }
      getDnsListOnline();
    } else if (isOffline.value) {
      getDnsListOffline();
    }
    progressController = Tween<double>(
      begin: 0,
      end: 0.8,
    ).animate(animationController);
  }

  Future<void> getDnsListOnline() async {
    update();
    isError.value = false;
    isOffline.value = false;
    saveOffline();
    isOnline.value = true;
    saveOnline();
    try {
      final dio_pkg.Response<dynamic> response = await dio.get(
        UrlConstant.baseUrl + UrlConstant.ananas,
      );
      if (response.statusCode == 200) {
        newOnlineDnsList.clear();
        netshiftEngineController.dnsListNetShift.clear();
        final Map<String, dynamic> dnsProvidersData = jsonDecode(
          response.data['data'],
        );
        dnsProvidersData['dns_providers'].forEach((dynamic json) {
          newOnlineDnsList.add(DnsModel.fromJson(json));
        });
        newOnlineDnsList.sort((a, b) {
          if (a.name.contains('**') && !b.name.contains('**')) return 1;
          if (!a.name.contains('**') && b.name.contains('**')) return -1;
          return 0;
        });
        netshiftEngineController.dnsListNetShift.addAll(newOnlineDnsList);
        await Future.delayed(const Duration(milliseconds: 500));
        if (checkForUpdateController.updateIsAvailable.value) {
          log("Please update the app");
          Get.to(() => const CheckForUpdateWidget());
        } else {
          Get.offAll(() => MainWrapper());
        }
      } else {
        isError.value = true;
        update();
      }
    } on dio_pkg.DioException catch (e) {
      isError.value = true;
      update();
      log("Error: $e");
    }
  }

  Future<void> getDnsListOffline() async {
    update();
    isOnline.value = false;
    saveOnline();
    isOffline.value = true;
    saveOffline();
    netshiftEngineController.dnsListNetShift.addAll(newOfflineDnsList);
    await Future.delayed(const Duration(seconds: 2));
    Get.offAll(() => MainWrapper());
  }

  void saveOnline() {
    online.write('online', isOnline.value);
  }

  void loadOnline() {
    isOnline.value = online.read('online') ?? true;
    log("Online value is : ${isOnline.value}");
  }

  void saveOffline() {
    offline.write('offline', isOffline.value);
  }

  void loadOffline() {
    isOffline.value = offline.read('offline') ?? false;
    log("Offline value is : ${isOffline.value}");
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
