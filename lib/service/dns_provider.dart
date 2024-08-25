import 'package:flutter/foundation.dart';
import 'package:dns_changer/model/dns_model.dart';

class DNSProvider with ChangeNotifier {
  DnsModel? _selectedDNS;
  bool _isDNSSet = false;
  bool _isPowerOn = false;

  DnsModel? get selectedDNS => _selectedDNS;
  bool get isDNSSet => _isDNSSet;
  bool get isPowerOn => _isPowerOn;

  void setDNS(DnsModel dns) {
    _selectedDNS = dns;
    _isDNSSet = true;
    _isPowerOn = false; 
    notifyListeners();
  }

  void clearDNS() {
    _selectedDNS = null;
    _isDNSSet = false;
    _isPowerOn = false; 
    notifyListeners();
  }

  void activateDNS() {
    if (_isDNSSet && _selectedDNS != null) {
      _isPowerOn = true;
      notifyListeners();
    }
  }

  void deactivateDNS() {
    if (_isPowerOn) {
      _isPowerOn = false;
      notifyListeners();
    }
  }

  void toggleDNS() {}
}
