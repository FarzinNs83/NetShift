import 'dart:io';

import 'package:netshift/core/services/android_dns_service.dart';
import 'package:netshift/core/services/macos_dns_service.dart';
import 'package:netshift/core/services/windows_dns_service.dart';

/// Abstract service for platform-specific DNS operations.
/// Use [DnsPlatformService.create] to get the appropriate implementation.
abstract class DnsPlatformService {
  /// Factory constructor that returns the appropriate platform implementation.
  factory DnsPlatformService.create() {
    if (Platform.isAndroid) {
      return AndroidDnsService();
    } else if (Platform.isWindows) {
      return WindowsDnsService();
    } else if (Platform.isMacOS) {
      return MacOsDnsService();
    }
    throw UnsupportedError('Platform not supported');
  }

  /// Start DNS with the given primary and secondary DNS servers.
  Future<void> startDns({
    required String primaryDns,
    required String secondaryDns,
    required String interfaceName,
    List<String> disallowedApps = const [],
  });

  /// Stop DNS and reset to default.
  Future<void> stopDns({required String interfaceName});

  /// Flush DNS cache.
  Future<void> flushDns();

  /// Get available network interfaces.
  Future<Map<String, String>> getNetworkInterfaces();

  /// Prepare DNS service (Android-specific, no-op on other platforms).
  Future<bool> prepareDns() async => true;

  /// Check if the platform requires interface selection.
  bool get requiresInterfaceSelection;
}
