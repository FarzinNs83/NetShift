import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dns_changer/model/dns_model.dart';
import 'package:dns_changer/service/dns_provider.dart';
import 'package:dns_changer/component/custom_nav_bar.dart';
import 'package:dns_changer/component/custom_title_bar.dart';
import 'package:dns_changer/component/custom_snackbar.dart';
import 'package:dns_changer/service/dns_service.dart';
import 'package:dns_changer/theme/theme_provider.dart';
import 'package:dns_changer/view/dns_selection.dart';
import 'package:dns_changer/view/settings_page.dart';
import 'package:dns_changer/view/fastest_dns.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final DNSService _dnsService = DNSService();

  @override
  void initState() {
    super.initState();
    _loadSelectedDNS();
  }

  Future<void> _loadSelectedDNS() async {
    final dns = await _dnsService.loadSelectedDNS();
    if (dns['primary'] != null && dns['secondary'] != null) {
      if (mounted) {
        Provider.of<DNSProvider>(context, listen: false).setDNS(
          DnsModel(
            name: 'Custom',
            primary: dns['primary']!,
            secondary: dns['secondary']!,
          ),
        );
      }
    }
  }

  Future<void> _toggleDNS() async {
    final dnsProvider = Provider.of<DNSProvider>(context, listen: false);
    if (dnsProvider.isDNSSet) {
      if (dnsProvider.isPowerOn) {
        await _clearDNSFromSystem();
        if (mounted) {
          dnsProvider.deactivateDNS();
          showCustomSnackBar(context, 'DNS Deactivated');
        }
      } else {
        if (dnsProvider.selectedDNS != null) {
          await _dnsService.setDNS(
            dnsProvider.selectedDNS!.primary,
            dnsProvider.selectedDNS!.secondary,
          );
          if (mounted) {
            dnsProvider.activateDNS();
            showCustomSnackBar(
                context, 'DNS set to ${dnsProvider.selectedDNS!.name}');
          }
        } else {
          if (mounted) {
            showCustomSnackBar(context, 'No DNS selected');
          }
        }
      }
    } else {
      if (mounted) {
        showCustomSnackBar(context, 'No DNS set');
      }
    }
  }

  Future<void> _clearDNSFromSystem() async {
    await _dnsService.clearDNSForAllInterfaces();
  }

  List<Widget> _pages() {
    return [
      _buildHomePage(),
      DnsSelection(
        onSelect: (dns) {
          if (mounted) {
            Provider.of<DNSProvider>(context, listen: false).setDNS(dns!);
          }
        },
        onRemove: (dns) async {
          final dnsProvider = Provider.of<DNSProvider>(context, listen: false);
          if (dnsProvider.selectedDNS != null &&
              dnsProvider.selectedDNS!.primary == dns.primary &&
              dnsProvider.selectedDNS!.secondary == dns.secondary) {
            await _clearDNSFromSystem();
            if (mounted) {
              dnsProvider.clearDNS();
              showCustomSnackBar(context, 'DNS removed and cleared');
            }
          }
        },
        onDNSChange: () {
          if (mounted) {
            Provider.of<DNSProvider>(context, listen: false).clearDNS();
          }
        },
      ),
      FastestDNSPage(
        onApply: (DnsModel dns) async {
          await _dnsService.setDNS(dns.primary, dns.secondary);
          if (mounted) {
            Provider.of<DNSProvider>(context, listen: false).setDNS(dns);
            showCustomSnackBar(context, 'DNS applied: ${dns.name}');
          }
        },
        onClear: () async {
          await _clearDNSFromSystem();
          if (mounted) {
            Provider.of<DNSProvider>(context, listen: false).clearDNS();
            showCustomSnackBar(context, 'DNS cleared');
          }
        },
      ),
      const SettingsPage(),
    ];
  }

  Widget _buildHomePage() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.theme;

    return Consumer<DNSProvider>(
      builder: (context, dnsProvider, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.scaffoldBackgroundColor, Colors.blueGrey.shade800],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _toggleDNS,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: dnsProvider.isDNSSet
                            ? (dnsProvider.isPowerOn
                                ? theme.primaryColor
                                : Colors.grey)
                            : Colors.grey.shade400,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (dnsProvider.isDNSSet
                                    ? (dnsProvider.isPowerOn
                                        ? theme.primaryColor
                                        : Colors.grey)
                                    : Colors.grey.shade400)
                                .withOpacity(0.5),
                            spreadRadius: dnsProvider.isPowerOn ? 8 : 3,
                            blurRadius: dnsProvider.isPowerOn ? 25 : 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.power_settings_new,
                        color: Colors.white,
                        size: 120,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            dnsProvider.isDNSSet
                                ? 'DNS: ${dnsProvider.selectedDNS!.name}'
                                : 'DNS is not set',
                            style: TextStyle(
                              fontSize: 18,
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (dnsProvider.isDNSSet) ...[
                            const SizedBox(height: 10),
                            Text(
                              dnsProvider.isPowerOn
                                  ? 'DNS is active'
                                  : 'DNS is set but inactive',
                              style: TextStyle(
                                fontSize: 16,
                                color: theme.primaryColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.theme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          const CustomTitleBar(),
          Expanded(
            child: _pages()[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
