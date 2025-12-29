import 'dart:developer';
import 'dart:io';

import 'package:netshift/core/services/dns_platform_service.dart';

/// Windows-specific DNS service implementation using netsh commands.
class WindowsDnsService implements DnsPlatformService {
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
      final ProcessResult primaryDnsResult = await Process.run('netsh', [
        'interface',
        'ipv4',
        'set',
        'dns',
        'name="$interfaceName"',
        'static',
        primaryDns,
        'primary',
      ]);

      if (primaryDnsResult.exitCode != 0) {
        throw Exception('Error setting primary DNS: ${primaryDnsResult.stderr}');
      }

      final ProcessResult secondaryDnsResult = await Process.run('netsh', [
        'interface',
        'ipv4',
        'add',
        'dns',
        'name="$interfaceName"',
        secondaryDns,
        'index=2',
      ]);

      if (secondaryDnsResult.exitCode != 0) {
        throw Exception(
          'Error setting secondary DNS: ${secondaryDnsResult.stderr}',
        );
      }

      log('DNS configured successfully.');
    } catch (e) {
      log('Error configuring DNS: $e');
      rethrow;
    }
  }

  @override
  Future<void> stopDns({required String interfaceName}) async {
    try {
      final ProcessResult resetDnsResult = await Process.run('netsh', [
        'interface',
        'ipv4',
        'set',
        'dns',
        'name="$interfaceName"',
        'source=dhcp',
      ]);

      if (resetDnsResult.exitCode != 0) {
        throw Exception('Error resetting DNS: ${resetDnsResult.stderr}');
      }

      log('DNS reset to default.');
    } catch (e) {
      log('Error disabling DNS: $e');
      rethrow;
    }
  }

  @override
  Future<void> flushDns() async {
    ProcessResult result = await Process.run(
      'ipconfig',
      ['/flushdns'],
      runInShell: true,
    );
    log(result.stdout.toString());
  }

  @override
  Future<Map<String, String>> getNetworkInterfaces() async {
    ProcessResult result = await Process.run(
      'netsh',
      ['interface', 'show', 'interface'],
      runInShell: true,
    );

    String interfaceOutput = result.stdout.toString();
    return _parseNetshOutput(interfaceOutput);
  }

  Map<String, String> _parseNetshOutput(String output) {
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
      ..sort((MapEntry<String, String> a, MapEntry<String, String> b) {
        if (a.value == b.value) return 0;
        return a.value == "Connected" ? -1 : 1;
      });

    return Map.fromEntries(sortedEntries);
  }
}
