import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netshift/gen/assets.gen.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportContent extends StatelessWidget {
  const SupportContent({super.key});

  Future<void> _launchUrl() async {
    final Uri url = Uri.https('github.com', '/FarzinNs83/NetShift');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  final String telegramId = 'feri_ns83';

  Future<void> launchUrlTelegram() async {
    final url = Uri.https('t.me', '/$telegramId');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            _launchUrl();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 15.0,
            children: [
              SvgPicture.asset(
                Assets.svg.github,
                width: 50.0,
                height: 50.0,
                colorFilter: ColorFilter.mode(
                  AppColors.settingsCustomCardSupportIcon,
                  BlendMode.srcIn,
                ),
              ),
              Text(
                'GitHub',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.settingsCustomCardTitle,
                ),
              ),
            ],
          ),
        ),
        VerticalDivider(
          indent: 20.0,
          endIndent: 20.0,
          color: AppColors.settingsVerticalDivider,
          width: 10.0,
          thickness: 2,
        ),
        GestureDetector(
          onTap: () {
            launchUrlTelegram();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 15.0,
            children: [
              SvgPicture.asset(
                Assets.svg.telegram,
                width: 50.0,
                height: 50.0,
                colorFilter: ColorFilter.mode(
                  AppColors.settingsCustomCardSupportIcon,
                  BlendMode.srcIn,
                ),
              ),
              Text(
                'Telegram',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.settingsCustomCardTitle,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
