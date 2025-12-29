import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:netshift/core/services/dns_platform_service.dart';

/// Android-specific DNS service implementation using VPN method channel.
class AndroidDnsService implements DnsPlatformService {
  static const MethodChannel _platform =
      MethodChannel("com.netshift.dnschanger/netdns");

  @override
  bool get requiresInterfaceSelection => false;

  @override
  Future<bool> prepareDns() async {
    try {
      await _platform.invokeMethod('prepareDns');
      return true;
    } on PlatformException catch (e) {
      log("Service Failed to Start $e");
      return false;
    }
  }

  @override
  Future<void> startDns({
    required String primaryDns,
    required String secondaryDns,
    required String interfaceName,
    List<String> disallowedApps = const [],
  }) async {
    try {
      await _platform.invokeMethod('startDns', {
        'dns1': primaryDns,
        'dns2': secondaryDns,
        'disallowedApps': disallowedApps,
      });
    } on PlatformException catch (e) {
      log("Service Failed to Start $e");
      rethrow;
    }
  }

  @override
  Future<void> stopDns({required String interfaceName}) async {
    try {
      await _platform.invokeMethod('stopDns');
    } on PlatformException catch (e) {
      log("Service Failed to Stop $e");
      rethrow;
    }
  }

  @override
  Future<void> flushDns() async {
    // Android doesn't support DNS flushing in the same way
    log('DNS flush not supported on Android');
  }

  @override
  Future<Map<String, String>> getNetworkInterfaces() async {
    // Android doesn't require interface selection
    return {};
  }
}
