// dns_widgets.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DNSDetailRow extends StatelessWidget {
  final String label;
  final int? pingTime;
  final bool isLoading;
  final TextEditingController controller;
  final String copyLabel;

  const DNSDetailRow({
    super.key,
    required this.label,
    this.pingTime,
    required this.isLoading,
    required this.controller,
    required this.copyLabel,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            isLoading
                ? SizedBox(
                    height: 16,
                    width: 16,
                    child: SpinKitFadingCircle(
                      duration: const Duration(seconds: 1),
                      color: Theme.of(context).primaryColor,
                      size: 16,
                    ),
                  )
                : (pingTime != null
                    ? Text("$pingTime ms", style: textStyle)
                    : const Text("Timeout",
                        style: TextStyle(fontSize: 12, color: Colors.red))),
          ],
        ),
        TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: controller.text));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('$copyLabel copied to clipboard'),
                ));
              },
            ),
          ),
        ),
      ],
    );
  }
}
