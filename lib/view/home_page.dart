import 'dart:io';

import 'package:dns_changer/model/dns_model.dart';
import 'package:dns_changer/theme/theme_provider.dart';
import 'package:dns_changer/view/dns_selection.dart';
import 'package:dns_changer/view/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DnsModel? selectedDNS;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadSelectedDNS();
  }


  Future<void> setDNS(String primary, String secondary) async {
    try {
      await Process.run(
        'netsh',
        [
          'interface',
          'ipv4',
          'set',
          'dns',
          'name="Wi-Fi"',
          'static',
          primary,
        ],
      );

      await Process.run(
        'netsh',
        [
          'interface',
          'ipv4',
          'add',
          'dns',
          'name="Wi-Fi"',
          secondary,
          'index=2'
        ],
      );

      await _saveSelectedDNS(primary, secondary);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> clearDNS() async {
    try {
      await Process.run(
        'netsh',
        ['interface', 'ipv4', 'set', 'dns', 'name="Wi-Fi"', 'dhcp'],
      );

      await _clearSelectedDNS();
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _saveSelectedDNS(String primary, String secondary) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('primaryDNS', primary);
    await prefs.setString('secondaryDNS', secondary);
  }

  Future<void> _loadSelectedDNS() async {
    final prefs = await SharedPreferences.getInstance();
    final primary = prefs.getString('primaryDNS');
    final secondary = prefs.getString('secondaryDNS');

    if (primary != null && secondary != null) {
      setState(() {
        selectedDNS =
            DnsModel(name: 'Custom', primary: primary, secondary: secondary);
      });
    }
  }

  Future<void> _clearSelectedDNS() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('primaryDNS');
    await prefs.remove('secondaryDNS');
  }

  void _openDNSSelectionPage() async {
    final dns = await Navigator.push<DnsModel>(
      context,
      MaterialPageRoute(
        builder: (context) => DnsSelection(
          onSelect: (selected) {
            setState(() {
              selectedDNS = selected;
            });
          },
        ),
      ),
    );

    if (dns != null) {
      setState(() {
        selectedDNS = dns;
      });
      await _saveSelectedDNS(dns.primary, dns.secondary);
    }
  }

  List<Widget> _pages() {
    return [
      _buildHomePage(),
      DnsSelection(onSelect: (dns) {
        setState(() {
          selectedDNS = dns;
        });
      }),
      const SettingsPage(),
    ];
  }

  Widget _buildHomePage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              selectedDNS != null
                  ? 'Selected DNS: ${selectedDNS!.name}'
                  : 'No DNS selected',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color(0xff6366f1))),
              onPressed: () async {
                if (selectedDNS != null) {
                  await setDNS(selectedDNS!.primary, selectedDNS!.secondary);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('DNS set to ${selectedDNS!.name}')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select a DNS first')),
                  );
                }
              },
              child: Text('Apply DNS'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await clearDNS();
                setState(() {
                  selectedDNS = null;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('DNS cleared')),
                );
              },
              child: Text('Clear DNS'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _pages()[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(0.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.dns,
                  text: 'DNS Selection',
                ),
                GButton(
                  icon: Icons.settings,
                  text: 'Settings',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
