import 'dart:io';

import 'package:get/get.dart';
import 'package:netshift/controller/blocked_apps_controller.dart';
import 'package:netshift/core/services/dns_platform_service.dart';
import 'package:netshift/core/services/dns_storage_service.dart';
import 'package:netshift/core/services/ip_address_service.dart';
import 'package:netshift/models/dns_model.dart';

class NetshiftEngineController extends GetxController {
  late final DnsPlatformService _platformService;
  final DnsStorageService _storageService = DnsStorageService();
  final IpAddressService _ipAddressService = IpAddressService();

  // Connection state
  RxBool isActive = false.obs;
  RxBool isLoading = false.obs;
  RxBool isFetching = false.obs;
  RxBool isPermissionGiven = false.obs;
  RxBool isFlushing = false.obs;
  RxBool isIpAddress = false.obs;

  // DNS lists
  RxList<DnsModel> dnsListNetShift = <DnsModel>[].obs;
  RxList<DnsModel> dnsListPersonal = <DnsModel>[].obs;
  RxList<DnsModel> newDnsList = RxList();

  List<DnsModel> get combinedListDns => [
    ...dnsListNetShift,
    ...dnsListPersonal,
  ];

  // Selected DNS
  Rx<DnsModel> selectedDns = DnsModel(
    name: 'NetShift DNS',
    primaryDNS: '178.22.122.100',
    secondaryDNS: '78.157.42.100',
  ).obs;

  // Network interfaces (for Windows/macOS)
  RxMap<String, String> interfaces = RxMap();
  RxList<String> interfaceKeys = RxList();
  RxList<String> interfaceValues = RxList();
  RxString interfaceName = 'Select Interface'.obs;

  // IP address
  RxString ipAddressString = "".obs;

  // Dependencies
  final BlockedAppsController blockedAppsController =
      Get.find<BlockedAppsController>();

  @override
  void onInit() {
    super.onInit();
    _initializePlatformService();
    _loadSavedState();
  }

  void _initializePlatformService() {
    _platformService = DnsPlatformService.create();

    if (Platform.isAndroid) {
      _prepareAndroidDns();
    }

    if (_platformService.requiresInterfaceSelection) {
      _loadNetworkInterfaces();
    }
  }

  void _loadSavedState() {
    isActive.value = _storageService.loadConnectionStatus();
    isPermissionGiven.value = _storageService.loadPrepareDnsPermission();
    interfaceName.value = _storageService.loadInterfaceName();

    final DnsModel? savedDns = _storageService.loadSelectedDns();
    if (savedDns != null) {
      selectedDns.value = savedDns;
    }

    dnsListPersonal.value = _storageService.loadPersonalDnsList();
  }

  Future<void> _prepareAndroidDns() async {
    isPermissionGiven.value = false;
    bool success = await _platformService.prepareDns();
    isPermissionGiven.value = success;
    if (success) {
      _storageService.savePrepareDnsPermission(true);
    }
  }

  Future<void> _loadNetworkInterfaces() async {
    Map<String, String> networkInterfaces =
        await _platformService.getNetworkInterfaces();

    interfaces.value = networkInterfaces;
    interfaceKeys.value = networkInterfaces.keys.toList();
    interfaceValues.value = networkInterfaces.values.toList();

    // Auto-select first connected interface if none selected
    if (interfaceName.value == 'Select Interface' && interfaceKeys.isNotEmpty) {
      interfaceName.value = interfaceKeys.first;
      saveInterfaceName();
    }
  }

  // DNS Control Methods
  Future<void> startDns() async {
    if (Platform.isAndroid && !isPermissionGiven.value) {
      await _prepareAndroidDns();
    }

    isLoading.value = true;
    isActive.value = true;
    _storageService.saveConnectionStatus(true);

    try {
      await _platformService.startDns(
        primaryDns: selectedDns.value.primaryDNS,
        secondaryDns: selectedDns.value.secondaryDNS,
        interfaceName: interfaceName.value,
        disallowedApps: blockedAppsController.blockedApps.toList(),
      );

      if (Platform.isAndroid) {
        await Future.delayed(const Duration(seconds: 1));
      }
    } catch (e) {
      isActive.value = false;
      _storageService.saveConnectionStatus(false);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> stopDns() async {
    isActive.value = false;
    _storageService.saveConnectionStatus(false);

    try {
      await _platformService.stopDns(interfaceName: interfaceName.value);
    } catch (e) {
      // Error already logged in service
    }
  }

  Future<void> flushDns() async {
    isFlushing.value = true;
    try {
      await _platformService.flushDns();
    } finally {
      isFlushing.value = false;
    }
  }

  // Interface management
  void saveInterfaceName() {
    _storageService.saveInterfaceName(interfaceName.value);
  }

  Future<void> refreshNetworkInterfaces() async {
    await _loadNetworkInterfaces();
  }

  // DNS List Management
  void addDNS(String dnsName, String primaryDNS, String secondaryDNS) {
    DnsModel newDns = DnsModel(
      name: dnsName,
      primaryDNS: primaryDNS,
      secondaryDNS: secondaryDNS,
    );

    dnsListPersonal.add(newDns);
    selectedDns.value = newDns;

    _savePersonalDnsAndSelection();
  }

  void deleteDns(DnsModel dns) {
    dnsListPersonal.remove(dns);

    bool isSelectedDns =
        selectedDns.value.name == dns.name &&
        selectedDns.value.primaryDNS == dns.primaryDNS &&
        selectedDns.value.secondaryDNS == dns.secondaryDNS;

    if (isSelectedDns) {
      selectedDns.value = dnsListPersonal.isNotEmpty
          ? dnsListPersonal.first
          : dnsListNetShift.first;
    }

    _savePersonalDnsAndSelection();
  }

  void editDns(
    DnsModel oldDns,
    String newDnsName,
    String newPrimaryDNS,
    String newSecondaryDNS,
  ) {
    int index = dnsListPersonal.indexWhere(
      (DnsModel dns) =>
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

    _savePersonalDnsAndSelection();
  }

  void _savePersonalDnsAndSelection() {
    _storageService.savePersonalDnsList(dnsListPersonal);
    _storageService.saveSelectedDns(selectedDns.value);
  }

  void saveSelectedDnsValue() {
    _storageService.saveSelectedDns(selectedDns.value);
  }

  void savePersonalDns() {
    _storageService.savePersonalDnsList(dnsListPersonal);
  }

  // IP Address
  Future<void> getIpAddress() async {
    isIpAddress.value = true;

    IpAddressResult result = await _ipAddressService.getIpAddress();
    ipAddressString.value = result.ipAddress;

    isIpAddress.value = false;
  }

  // Legacy method names for backward compatibility
  Future<void> startDnsForAndroid() => startDns();
  Future<void> stopDnsForAndroid() => stopDns();
  Future<void> startDnsForWindows() => startDns();
  Future<void> stopDnsForWindows() => stopDns();
  Future<void> startDnsForMacOS() => startDns();
  Future<void> stopDnsForMacOS() => stopDns();
  Future<void> flushDnsForWindows() => flushDns();
  Future<void> flushDnsForMacOS() => flushDns();
  Future<void> prepareDns() => _prepareAndroidDns();
  Future<void> interfaceNameForWindows() => _loadNetworkInterfaces();
  Future<void> interfaceNameForMacOS() => _loadNetworkInterfaces();
}
