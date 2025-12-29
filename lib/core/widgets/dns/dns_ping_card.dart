import 'package:flutter/material.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/resources/extention_sized.dart';
import 'package:netshift/core/widgets/dns/dns_apply_button.dart';
import 'package:netshift/core/widgets/dns/dns_row_item.dart';
import 'package:netshift/core/widgets/ping/ping_badge.dart';

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
          _DnsPingCardHeader(name: name, avgPing: avgPing),
          const SizedBox(height: 12),
          DnsRowItem(icon: Icons.dns, dns: primaryDns, ping: primaryPing),
          const SizedBox(height: 6),
          DnsRowItem(
            icon: Icons.dns_outlined,
            dns: secondaryDns,
            ping: secondaryPing,
          ),
          const Spacer(),
          DnsApplyButton(
            onPressed: onApply,
            isDisabled: isTimeout,
            isDesktop: true,
          ),
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
          _DnsPingCardHeader(name: name, avgPing: avgPing, isMobile: true),
          Divider(color: AppColors.dnsPingDivider, thickness: 1.2, height: 20),
          8.height,
          DnsRowItem(
            icon: Icons.dns,
            dns: primaryDns,
            ping: primaryPing,
            isMobile: true,
          ),
          8.height,
          DnsRowItem(
            icon: Icons.dns_outlined,
            dns: secondaryDns,
            ping: secondaryPing,
            isMobile: true,
          ),
          16.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DnsApplyButton(
                onPressed: onApply,
                isDisabled: isTimeout,
                isDesktop: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DnsPingCardHeader extends StatelessWidget {
  const _DnsPingCardHeader({
    required this.name,
    required this.avgPing,
    this.isMobile = false,
  });

  final String name;
  final String avgPing;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            name,
            style: TextStyle(
              color: AppColors.dnsPingName,
              fontSize: isMobile ? 20 : 18,
              fontFamily: isMobile ? 'IRANSansX' : 'Poppins',
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        PingBadge(avgPing: avgPing, isMobile: isMobile),
      ],
    );
  }
}
