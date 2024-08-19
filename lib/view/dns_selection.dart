import 'package:dns_changer/model/dns_data.dart';
import 'package:dns_changer/model/dns_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DnsSelection extends StatefulWidget {
  final void Function(DnsModel) onSelect;

  DnsSelection({required this.onSelect});

  @override
  _DnsSelectionState createState() => _DnsSelectionState();
}

class _DnsSelectionState extends State<DnsSelection> {
  DnsModel? selectedDNS;

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$label copied to clipboard'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select DNS'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<DnsModel>(
              hint: Text('Select a DNS'),
              value: selectedDNS,
              isExpanded: true, 
              items: dnsOptions.map((DnsModel dns) {
                return DropdownMenuItem<DnsModel>(
                  value: dns,
                  child: Text(dns.name),
                );
              }).toList(),
              onChanged: (DnsModel? newValue) {
                setState(() {
                  selectedDNS = newValue!;
                  widget.onSelect(newValue);
                });
              },
            ),
            SizedBox(height: 20),
            if (selectedDNS != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Primary DNS:'),
                  TextField(
                    controller:
                        TextEditingController(text: selectedDNS!.primary),
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.copy),
                        onPressed: () {
                          _copyToClipboard(selectedDNS!.primary, 'Primary DNS');
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Secondary DNS:'),
                  TextField(
                    controller:
                        TextEditingController(text: selectedDNS!.secondary),
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.copy),
                        onPressed: () {
                          _copyToClipboard(
                              selectedDNS!.secondary, 'Secondary DNS');
                        },
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

