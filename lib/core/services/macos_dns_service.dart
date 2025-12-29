import 'dart:developer';
import 'dart:io';

import 'package:netshift/core/services/dns_platform_service.dart';

/// macOS-specific DNS service implementation using networksetup commands.
class MacOsDnsService implements DnsPlatformService {
  @override
  bool get requiresInterfaceSelection => true;

  @override
  Future<bool> prepareDns() async => true;

  @override
  Future<void> startDns({
    required String primaryDns,
    required String secondaryDns,
    required String interfaceName,
    List<String> disallowedApps = const [],
  }) async {
    try {
      String networkService = interfaceName.contains('Select Interface')
          ? await _getActiveNetworkService()
          : interfaceName;

      if (networkService.isEmpty) {
        log('No active network service found');
        throw Exception('No active network service found');
      }

      final ProcessResult result = await Process.run('osascript', [
        '-e',
        'do shell script "networksetup -setdnsservers \'$networkService\' $primaryDns $secondaryDns" with administrator privileges',
      ]);

      if (result.exitCode != 0) {
        log('Error setting DNS: ${result.stderr}');
        throw Exception('Error setting DNS: ${result.stderr}');
      }

      log('DNS configured successfully on $networkService');
    } catch (e) {
      log('Error configuring DNS: $e');
      rethrow;
    }
  }

  @override
  Future<void> stopDns({required String interfaceName}) async {
    try {
      String networkService = interfaceName.contains('Select Interface')
          ? await _getActiveNetworkService()
          : interfaceName;

      if (networkService.isEmpty) {
        log('No active network service found');
        return;
      }

      final ProcessResult resetResult = await Process.run('osascript', [
        '-e',
        'do shell script "networksetup -setdnsservers \'$networkService\' Empty" with administrator privileges',
      ]);

      if (resetResult.exitCode != 0) {
        log('Error resetting DNS: ${resetResult.stderr}');
        throw Exception('Error resetting DNS: ${resetResult.stderr}');
      }

      log('DNS reset to default on $networkService');
    } catch (e) {
      log('Error disabling DNS: $e');
      rethrow;
    }
  }

  @override
  Future<void> flushDns() async {
    try {
      await Process.run('dscacheutil', ['-flushcache']);
      await Process.run('osascript', [
        '-e',
        'do shell script "killall -HUP mDNSResponder" with administrator privileges',
      ]);
      log('DNS cache flushed on macOS');
    } catch (e) {
      log('Error flushing DNS cache: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, String>> getNetworkInterfaces() async {
    Map<String, String> interfaces = {};

    try {
      final ProcessResult result = await Process.run('networksetup', [
        '-listallnetworkservices',
      ]);

      if (result.exitCode != 0) {
        return {'Wi-Fi': 'Unknown'};
      }

      List<String> services = result.stdout.toString().split('\n');

      for (String service in services.skip(1)) {
        service = service.trim();
        if (service.isEmpty || service.startsWith('*')) continue;

        final ProcessResult ipResult = await Process.run('networksetup', [
          '-getinfo',
          service,
        ]);

        bool isConnected =
            ipResult.stdout.toString().contains('IP address:') &&
            !ipResult.stdout.toString().contains('IP address: none');

        interfaces[service] = isConnected ? 'Connected' : 'Disconnected';
      }

      // Sort to put connected interfaces first
      List<MapEntry<String, String>> sortedEntries = interfaces.entries.toList()
        ..sort((MapEntry<String, String> a, MapEntry<String, String> b) {
          if (a.value == b.value) return 0;
          return a.value == "Connected" ? -1 : 1;
        });

      return Map.fromEntries(sortedEntries);
    } catch (e) {
      log('Error getting macOS network services: $e');
      return {'Wi-Fi': 'Unknown'};
    }
  }

  Future<String> _getActiveNetworkService() async {
    try {
      final ProcessResult result = await Process.run('networksetup', [
        '-listallnetworkservices',
      ]);

      if (result.exitCode != 0) return 'Wi-Fi';

      List<String> services = result.stdout.toString().split('\n');
      for (String service in services.skip(1)) {
        service = service.trim();
        if (service.isEmpty || service.startsWith('*')) continue;

        final ProcessResult ipResult = await Process.run('networksetup', [
          '-getinfo',
          service,
        ]);

        if (ipResult.stdout.toString().contains('IP address:') &&
            !ipResult.stdout.toString().contains('IP address: none')) {
          return service;
        }
      }
      return 'Wi-Fi';
    } catch (e) {
      log('Error getting network service: $e');
      return 'Wi-Fi';
    }
  }
}
