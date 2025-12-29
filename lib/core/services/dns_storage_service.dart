import 'dart:developer';

import 'package:get_storage/get_storage.dart';
import 'package:netshift/models/dns_model.dart';

/// Service for persisting DNS-related data to local storage.
class DnsStorageService {
  final GetStorage _storage = GetStorage();
  final GetStorage _interfaceStorage = GetStorage();
  final GetStorage _personalDnsStorage = GetStorage();

  // Storage keys
  static const String _keyConnectionStatus = 'connectionButtonStatus';
  static const String _keySelectedDns = 'selectedDnsValue';
  static const String _keyPersonalDnsList = 'dnsListPersonal';
  static const String _keyInterfaceName = 'interfaceNameStore';
  static const String _keyPrepareDns = 'prepareDns';

  // Connection status
  void saveConnectionStatus(bool isActive) {
    _storage.write(_keyConnectionStatus, isActive);
  }

  bool loadConnectionStatus() {
    bool status = _storage.read(_keyConnectionStatus) ?? false;
    log("Your connection button state is: $status");
    return status;
  }

  // Selected DNS
  void saveSelectedDns(DnsModel dns) {
    _storage.write(_keySelectedDns, dns.toJson());
  }

  DnsModel? loadSelectedDns() {
    final dynamic dnsData = _storage.read(_keySelectedDns);
    if (dnsData != null) {
      DnsModel dns = DnsModel.fromJson(dnsData);
      log("Your selected DNS is: ${dns.name}");
      return dns;
    }
    return null;
  }

  // Personal DNS list
  void savePersonalDnsList(List<DnsModel> dnsList) {
    _personalDnsStorage.write(
      _keyPersonalDnsList,
      dnsList.map((DnsModel dns) => dns.toJson()).toList(),
    );
  }

  List<DnsModel> loadPersonalDnsList() {
    final dynamic dnsData = _personalDnsStorage.read(_keyPersonalDnsList);
    if (dnsData != null) {
      return (dnsData as List<dynamic>)
          .map(
            (dynamic item) => DnsModel.fromJson(Map<String, String>.from(item)),
          )
          .toList();
    }
    return [];
  }

  // Interface name
  void saveInterfaceName(String interfaceName) {
    _interfaceStorage.write(_keyInterfaceName, interfaceName);
  }

  String loadInterfaceName() {
    return _storage.read(_keyInterfaceName) ?? 'Select Interface';
  }

  // Prepare DNS permission (Android)
  void savePrepareDnsPermission(bool isPermissionGiven) {
    _storage.write(_keyPrepareDns, isPermissionGiven);
  }

  bool loadPrepareDnsPermission() {
    return _storage.read(_keyPrepareDns) ?? false;
  }
}
