import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:get_storage/get_storage.dart';
import 'package:netshift/controller/blocked_apps_controller.dart';
import 'package:netshift/models/dns_model.dart';

class NetshiftEngineController extends GetxController {
  static const platform = MethodChannel("com.netshift.dnschanger/netdns");
  static const EventChannel statusChannel =
      EventChannel("com.netshift.dnschanger/netdnsStatus");
  String dnsStatus = "none";
  GetStorage storage = GetStorage();
  GetStorage interfaceNameStore = GetStorage();
  GetStorage dnsListPersonalStorage = GetStorage();
  RxBool isActive = false.obs;
  RxBool isLoading = false.obs;
  RxBool isFetching = false.obs;
  RxBool isPermissionGiven = false.obs;
  RxList<DnsModel> newDnsList = RxList();
  RxMap<String, String> interfaces = RxMap();
  RxList<String> interfaceKeys = RxList();
  RxList<String> interfaceValues = RxList();
  RxString interfaceName = 'Select Interface'.obs;
  RxBool isFlushing = false.obs;
  RxBool isIpAddress = false.obs;

  RxString ipAddressString = "".obs;

  var dnsListNetShift = [].obs;

  var dnsListPersonal = [].obs;

  List<DnsModel> get combinedListDns =>
      [...dnsListNetShift, ...dnsListPersonal];
  var selectedDns = DnsModel(
    name: 'NetShift DNS',
    primaryDNS: '178.22.122.100',
    secondaryDNS: '78.157.42.100',
  ).obs;
  final BlockedAppsController blockedAppsController =
      Get.put(BlockedAppsController());
  @override
  void onInit() {
    super.onInit();
    if (Platform.isAndroid) {
      prepareDns();
    }
    loadConnectButtonStatus();
    loadSelectedDnsValue();
    loadPersonalDns();
    loadPrepareService();
    if (Platform.isWindows) {
      interfaceNameForWindows();
      loadInterfaceName();
    }
  }

  Future<void> prepareDns() async {
    isPermissionGiven.value = false;
    try {
      await platform.invokeMethod('prepareDns');
      isPermissionGiven.value = true;
      savePrepareService();
    } on PlatformException catch (e) {
      log("Service Failed to Start $e");
    }
  }

  void savePrepareService() {
    storage.write('prepareDns', isPermissionGiven.value);
  }

  void loadPrepareService() {
    isPermissionGiven.value = storage.read('prepareDns') ?? false;
  }

  Future<void> startDnsForAndroid() async {
    if (isPermissionGiven.value) {
      prepareDns();
    }
    isLoading.value = true;
    isActive.value = true;
    saveConnectButtonStatus();
    try {
      await platform.invokeMethod('startDns', {
        'dns1': selectedDns.value.primaryDNS,
        'dns2': selectedDns.value.secondaryDNS,
        'disallowedApps': blockedAppsController.blockedApps.toList(),
      });
      await Future.delayed(const Duration(seconds: 1));
      isLoading.value = false;
    } on PlatformException catch (e) {
      log("Service Failed to Start $e");
    }
  }

  Future<void> stopDnsForAndroid() async {
    isActive.value = false;
    saveConnectButtonStatus();
    try {
      await platform.invokeMethod('stopDns');
    } on PlatformException catch (e) {
      log("Service Failed to Start $e");
    }
  }

  // FOR WINDOWS START
  Future<void> startDnsForWindows() async {
    isLoading.value = true;
    isActive.value = true;
    saveConnectButtonStatus();
    try {
      final primaryDnsResult = await Process.run(
        'netsh',
        [
          'interface',
          'ipv4',
          'set',
          'dns',
          'name="${interfaceName.value}"',
          'static',
          selectedDns.value.primaryDNS,
          'primary'
        ],
      );

      if (primaryDnsResult.exitCode != 0) {
        throw Exception(
            'Error setting primary DNS: ${primaryDnsResult.stderr}');
      }

      final secondaryDnsResult = await Process.run(
        'netsh',
        [
          'interface',
          'ipv4',
          'add',
          'dns',
          'name="${interfaceName.value}"',
          selectedDns.value.secondaryDNS,
          'index=2'
        ],
      );

      if (secondaryDnsResult.exitCode != 0) {
        throw Exception(
            'Error setting secondary DNS: ${secondaryDnsResult.stderr}');
      }

      log('DNS configured successfully.');
    } catch (e) {
      log('Error configuring DNS: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> stopDnsForWindows() async {
    isActive.value = false;
    saveConnectButtonStatus();

    try {
      final resetDnsResult = await Process.run(
        'netsh',
        [
          'interface',
          'ipv4',
          'set',
          'dns',
          'name="${interfaceName.value}"',
          'source=dhcp',
        ],
      );

      if (resetDnsResult.exitCode != 0) {
        throw Exception('Error resetting DNS: ${resetDnsResult.stderr}');
      }

      log('DNS reset to default.');
    } catch (e) {
      log('Error disabling DNS: $e');
    }
  }

  Future<void> flushDnsForWindows() async {
    isFlushing.value = true;
    ProcessResult result =
        await Process.run('ipconfig', ['/flushdns'], runInShell: true);
    isFlushing.value = false;
    log(result.stdout);
  }

  void saveInterfaceName() {
    interfaceNameStore.write('interfaceNameStore', interfaceName.value);
  }

  void loadInterfaceName() {
    interfaceName.value =
        storage.read('interfaceNameStore') ?? 'Select Interface';
  }

  Future<void> interfaceNameForWindows() async {
    ProcessResult result = await Process.run(
        'netsh', ['interface', 'show', 'interface'],
        runInShell: true);

    String interfaceOutput = result.stdout;
    Map<String, String> allInterfaces = parseNetshOutput(interfaceOutput);
    interfaces.value = allInterfaces;
    interfaceKeys.addAll(interfaces.keys);
    interfaceValues.addAll(interfaces.values);
  }

  Map<String, String> parseNetshOutput(String output) {
    Map<String, String> interfaceMap = {};
    List<String> lines = output.split('\n');

    int nameIndex = -1;
    int stateIndex = -1;

    for (String line in lines) {
      line = line.trim();
      if (line.toLowerCase().contains("admin state")) {
        List<String> headers = line.split(RegExp(r'\s{2,}'));
        nameIndex = headers.indexOf("Interface Name");
        stateIndex = headers.indexOf("State");
        continue;
      }

      if (nameIndex != -1 && stateIndex != -1) {
        List<String> parts = line.split(RegExp(r'\s{2,}'));
        if (parts.length > stateIndex) {
          String name = parts[nameIndex].trim();
          String state = parts[stateIndex].trim();

          interfaceMap[name] = state;
        }
      }
    }

    List<MapEntry<String, String>> sortedEntries = interfaceMap.entries.toList()
      ..sort((a, b) {
        if (a.value == b.value) return 0;
        return a.value == "Connected" ? -1 : 1;
      });

    return Map.fromEntries(sortedEntries);
  }

  // FOR WINDOWS END
  void addDNS(String dnsName, primaryDNS, secondaryDNS) {
    dnsListPersonal.add(
      DnsModel(
        name: dnsName,
        primaryDNS: primaryDNS,
        secondaryDNS: secondaryDNS,
      ),
    );
    selectedDns.value = DnsModel(
      name: dnsName,
      primaryDNS: primaryDNS,
      secondaryDNS: secondaryDNS,
    );
    saveSelectedDnsValue();
  }

  void deleteDns(DnsModel dns) {
    dnsListPersonal.remove(dns);
    if (selectedDns.value.name == dns.name) {
      if (selectedDns.value.primaryDNS == dns.primaryDNS) {
        if (selectedDns.value.secondaryDNS == dns.secondaryDNS) {
          if (dnsListPersonal.isNotEmpty) {
            selectedDns.value = dnsListPersonal.first;
          } else if (dnsListPersonal.isEmpty) {
            selectedDns.value = dnsListNetShift.first;
          }
        }
      }
    }
    saveSelectedDnsValue();
  }

  void editDns(DnsModel oldDns, String newDnsName, String newPrimaryDNS,
      String newSecondaryDNS) {
    int index = dnsListPersonal.indexWhere(
      (dns) =>
          dns.name == oldDns.name &&
          dns.primaryDNS == oldDns.primaryDNS &&
          dns.secondaryDNS == oldDns.secondaryDNS,
    );
    if (index != -1) {
      dnsListPersonal[index] = DnsModel(
        name: newDnsName,
        primaryDNS: newPrimaryDNS,
        secondaryDNS: newSecondaryDNS,
      );
    }
    if (selectedDns.value.name == oldDns.name &&
        selectedDns.value.primaryDNS == oldDns.primaryDNS &&
        selectedDns.value.secondaryDNS == oldDns.secondaryDNS) {
      selectedDns.value = DnsModel(
        name: newDnsName,
        primaryDNS: newPrimaryDNS,
        secondaryDNS: newSecondaryDNS,
      );
    }

    saveSelectedDnsValue();
  }

  void saveConnectButtonStatus() {
    storage.write('connectionButtonStatus', isActive.value);
  }

  void loadConnectButtonStatus() {
    isActive.value = storage.read('connectionButtonStatus') ?? false;
    log("Your connection button state is : ${isActive.value.toString()}");
  }

  void saveSelectedDnsValue() {
    storage.write('selectedDnsValue', selectedDns.value.toJson());
  }

  void loadSelectedDnsValue() {
    var dnsData = storage.read('selectedDnsValue');
    if (dnsData != null) {
      selectedDns.value = DnsModel.fromJson(dnsData);
    }
    log("Your selected DNS is : ${selectedDns.value.name}");
  }

  void savePersonalDns() {
    dnsListPersonalStorage.write(
      'dnsListPersonal',
      dnsListPersonal.map((dns) => dns.toJson()).toList(),
    );
  }

  void loadPersonalDns() {
    var dnsData = dnsListPersonalStorage.read('dnsListPersonal');
    if (dnsData != null) {
      dnsListPersonal.value = (dnsData as List)
          .map((item) => DnsModel.fromJson(Map<String, String>.from(item)))
          .toList();
    }
  }

  void getIpAddress() async {
    try {
      isIpAddress.value = true;
      var ipAddress = IpAddress(type: RequestType.text);
      dynamic data = await ipAddress.getIpAddress();
      bool isIPv6 = data.contains(':');
      if (isIPv6) {
        ipAddressString.value = "Failed(IPv6)";
        log("Failed IPv6 detected");
      } else {
        ipAddressString.value = data;
        log(data.toString());
      }
      isIpAddress.value = false;
    } on IpAddressException catch (e) {
      log(e.message);
      ipAddressString.value = "Failed(Offline)";
      isIpAddress.value = false;
    }
  }
}
