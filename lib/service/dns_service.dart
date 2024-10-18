import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DNSService {
  static const String wifiInterfaceName = 'Wi-Fi';
  static const String ethernetInterfaceName = 'Ethernet';
  static const String nekoray = 'nekoray-tun';

  Future<void> setDNS(String primary, String secondary) async {
    if (Platform.isWindows) {
      await _setDNSForWindowsInterface(wifiInterfaceName, primary, secondary);
      await _setDNSForWindowsInterface(ethernetInterfaceName, primary, secondary);
    } else if (Platform.isMacOS) {
      await _setDNSForMacInterface(wifiInterfaceName, primary, secondary);
      await _setDNSForMacInterface(ethernetInterfaceName, primary, secondary);
    }
  }

  Future<void> _setDNSForWindowsInterface(
      String interfaceName, String primary, String secondary) async {
    try {
      final resultPrimary = await Process.run(
        'netsh',
        [
          'interface',
          'ipv4',
          'set',
          'dns',
          'name="$interfaceName"',
          'static',
          primary,
        ],
      );
      if (resultPrimary.exitCode != 0) {
        throw Exception(
            'Failed to set primary DNS on $interfaceName: ${resultPrimary.stderr}');
      }

      final resultSecondary = await Process.run(
        'netsh',
        [
          'interface',
          'ipv4',
          'add',
          'dns',
          'name="$interfaceName"',
          secondary,
          'index=2'
        ],
      );
      if (resultSecondary.exitCode != 0) {
        throw Exception(
            'Failed to set secondary DNS on $interfaceName: ${resultSecondary.stderr}');
      }

      await _saveSelectedDNS(primary, secondary);
    } catch (e) {
      if (kDebugMode) {
        print('Error while setting DNS on $interfaceName: $e');
      }
    }
  }

  Future<void> _setDNSForMacInterface(
      String interfaceName, String primary, String secondary) async {
    try {
      final resultPrimary = await Process.run(
        'networksetup',
        ['-setdnsservers', interfaceName, primary, secondary],
      );
      if (resultPrimary.exitCode != 0) {
        throw Exception(
            'Failed to set DNS on $interfaceName: ${resultPrimary.stderr}');
      }

      await _saveSelectedDNS(primary, secondary);
    } catch (e) {
      if (kDebugMode) {
        print('Error while setting DNS on $interfaceName: $e');
      }
    }
  }

  Future<void> clearDNSForAllInterfaces() async {
    try {
      if (Platform.isWindows) {
        await _clearDNSForWindowsInterface(wifiInterfaceName);
        await _clearDNSForWindowsInterface(ethernetInterfaceName);
        await _clearDNSForWindowsInterface(nekoray);
      } else if (Platform.isMacOS) {
        await _clearDNSForMacInterface(wifiInterfaceName);
        await _clearDNSForMacInterface(ethernetInterfaceName);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error while clearing DNS: $e');
      }
    }
  }

  Future<void> _clearDNSForWindowsInterface(String interfaceName) async {
    try {
      final result = await Process.run(
        'netsh',
        ['interface', 'ipv4', 'set', 'dns', 'name="$interfaceName"', 'dhcp'],
      );
      if (result.exitCode != 0) {
        throw Exception(
            'Failed to clear DNS on $interfaceName: ${result.stderr}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error while clearing DNS on $interfaceName: $e');
      }
    }
  }

  Future<void> _clearDNSForMacInterface(String interfaceName) async {
    try {
      final result = await Process.run(
        'networksetup',
        ['-setdnsservers', interfaceName, 'Empty'],
      );
      if (result.exitCode != 0) {
        throw Exception(
            'Failed to clear DNS on $interfaceName: ${result.stderr}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error while clearing DNS on $interfaceName: $e');
      }
    }
  }

  Future<void> _saveSelectedDNS(String primary, String secondary) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('primaryDNS', primary);
    await prefs.setString('secondaryDNS', secondary);
  }

  Future<void> _clearSelectedDNS() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('primaryDNS');
    await prefs.remove('secondaryDNS');
  }

  Future<Map<String, String?>> loadSelectedDNS() async {
    final prefs = await SharedPreferences.getInstance();
    final primary = prefs.getString('primaryDNS');
    final secondary = prefs.getString('secondaryDNS');
    return {
      'primary': primary,
      'secondary': secondary,
    };
  }

  Future<int?> pingDNS(String dns) async {
    try {
      final result = await Process.run(
        'ping',
        ['-n', '1', dns],
      );

      final output = result.stdout as String;

      final lines = output.split('\n');
      for (var line in lines) {
        if (line.contains('time=')) {
          final match = RegExp(r'time=(\d+)ms').firstMatch(line);
          if (match != null) {
            return int.parse(match.group(1)!);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error while pinging DNS: $e');
      }
    }
    return null;
  }
}
