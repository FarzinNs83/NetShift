import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/screens/dns_page.dart';
import 'package:netshift/screens/dns_ping.dart';
import 'package:netshift/screens/home_page.dart';
import 'package:netshift/screens/settings_page.dart';

class MainWrapperController extends GetxController {
  final NetshiftEngineController netshiftEngineController =
      Get.find<NetshiftEngineController>();
  final List<Widget> _pages = [
    HomePage(),
    DNSPage(),
    DNSPing(),
    SettingsPage(),
  ];
  @override
  void onInit() {
    super.onInit();
    netshiftEngineController.getIpAddress();
  }

  RxInt selectedIndex = 0.obs;

  void onSelectPage(int index) {
    selectedIndex.value = index;
  }

  Widget get selectedPage => _pages[selectedIndex.value];
}
