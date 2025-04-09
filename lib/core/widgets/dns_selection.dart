import 'package:flutter/material.dart';
import 'package:netshift/core/resources/media_query_size.dart';
import 'package:netshift/core/resources/app_colors.dart';

class DNSSelection extends StatefulWidget {
  final IconData icon;
  final String name;
  final void Function()? onTap;
  final void Function()? onPressed;
  const DNSSelection({
    super.key,
    required this.icon,
    required this.name,
    this.onTap,
    required this.onPressed,
  });

  @override
  State<DNSSelection> createState() => _DNSSelectionState();
}

class _DNSSelectionState extends State<DNSSelection> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    Color neonGreen = AppColors.dnsSelectionNeonGreen;
    Color lightBlack = AppColors.dnsSelectionLightBlack;
    final double scale = _isPressed ? 0.90 : 1.0;

    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          height: ScreenSize.height * 0.27,
          decoration: BoxDecoration(
            color: _isPressed ? lightBlack : neonGreen.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: neonGreen.withValues(alpha: 0.8),
                size: 62,
              ),
              const SizedBox(height: 8),
              Text(
                widget.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: neonGreen.withValues(alpha: 0.8),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
