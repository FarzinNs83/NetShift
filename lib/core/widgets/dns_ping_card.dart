import 'package:flutter/material.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/resources/extention_sized.dart';

class DnsPingCard extends StatelessWidget {
  final String name;
  final String primaryDns;
  final String secondaryDns;
  final String avgPing;
  final String primaryPing;
  final String secondaryPing;
  final VoidCallback? onApply;
  final bool isDesktop;

  const DnsPingCard({
    super.key,
    required this.name,
    required this.primaryDns,
    required this.secondaryDns,
    required this.avgPing,
    required this.primaryPing,
    required this.secondaryPing,
    this.onApply,
    this.isDesktop = false,
  });

  bool get isTimeout => avgPing == '-1';

  Color get pingColor {
    int pingValue = int.tryParse(avgPing) ?? -1;
    if (pingValue == -1) return Colors.red;
    if (pingValue < 50) return Colors.green;
    if (pingValue < 150) return Colors.lightGreen;
    if (pingValue < 300) return Colors.orange;
    return Colors.deepOrange;
  }

  String _formatPing(String ping) {
    return ping == '-1' ? 'Timeout' : '$ping ms';
  }

  @override
  Widget build(BuildContext context) {
    return isDesktop ? _buildDesktopCard() : _buildMobileCard();
  }

  Widget _buildDesktopCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.isDarkMode
            ? const Color(0xFF1E2025)
            : Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isTimeout
              ? Colors.red.withValues(alpha: 0.5)
              : AppColors.dnsPingContainerBorder.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.dnsPingContainerShadow.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          _buildDnsRow(Icons.dns, primaryDns, primaryPing),
          const SizedBox(height: 6),
          _buildDnsRow(Icons.dns_outlined, secondaryDns, secondaryPing),
          const Spacer(),
          _buildApplyButton(isDesktop: true),
        ],
      ),
    );
  }

  Widget _buildMobileCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isTimeout
              ? Colors.red.withValues(alpha: 0.5)
              : AppColors.dnsPingContainerBorder,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.dnsPingContainerShadow,
            blurRadius: 2,
            spreadRadius: 1,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMobileHeader(),
          Divider(
            color: AppColors.dnsPingDivider,
            thickness: 1.2,
            height: 20,
          ),
          8.height,
          _buildMobileDnsRow(Icons.dns, primaryDns, primaryPing),
          8.height,
          _buildMobileDnsRow(Icons.dns_outlined, secondaryDns, secondaryPing),
          16.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [_buildApplyButton(isDesktop: false)],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            name,
            style: TextStyle(
              color: AppColors.dnsPingName,
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _buildPingBadge(),
      ],
    );
  }

  Widget _buildMobileHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            name,
            style: TextStyle(
              color: AppColors.dnsPingName,
              fontSize: 20,
              fontFamily: 'IRANSansX',
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _buildPingBadge(isMobile: true),
      ],
    );
  }

  Widget _buildPingBadge({bool isMobile = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 10 : 12,
        vertical: isMobile ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: pingColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
      ),
      child: Text(
        isTimeout ? "Timeout" : "$avgPing ms",
        style: TextStyle(
          color: pingColor,
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDnsRow(IconData icon, String dns, String ping) {
    return Row(
      children: [
        Icon(icon, color: AppColors.dnsPing, size: 16),
        8.width,
        Expanded(
          child: Text(
            "$dns (${_formatPing(ping)})",
            style: TextStyle(
              color: AppColors.dnsPingText,
              fontSize: 12,
              fontFamily: 'Poppins',
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileDnsRow(IconData icon, String dns, String ping) {
    return Row(
      children: [
        Icon(icon, color: AppColors.dnsPing, size: 18),
        8.width,
        Expanded(
          child: Text(
            "$dns  ->  ${_formatPing(ping)}",
            style: TextStyle(
              color: AppColors.dnsPingText,
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildApplyButton({required bool isDesktop}) {
    if (isDesktop) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor:
                isTimeout ? Colors.grey : AppColors.dnsPingApplyButtonForeground,
            padding: const EdgeInsets.symmetric(vertical: 10),
            side: BorderSide(
              color: isTimeout ? Colors.grey : AppColors.dnsPingApplyButtonBorder,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: isTimeout ? null : onApply,
          child: const Text("Apply DNS"),
        ),
      );
    }

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor:
            isTimeout ? Colors.grey : AppColors.dnsPingApplyButtonForeground,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: const TextStyle(fontSize: 14, fontFamily: 'IRANSansX'),
        side: BorderSide(
          color: isTimeout ? Colors.grey : AppColors.dnsPingApplyButtonBorder,
          width: 2,
        ),
      ),
      onPressed: isTimeout ? null : onApply,
      child: const Text("Apply"),
    );
  }
}
