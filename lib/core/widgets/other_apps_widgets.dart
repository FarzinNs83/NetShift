import 'dart:io';

import 'package:flutter/material.dart';
import 'package:netshift/gen/assets.gen.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class OtherAppsWidget extends StatelessWidget {
  const OtherAppsWidget({super.key});

  Future<void> _launchUrl() async {
    final Uri url = Uri.https('github.com', '/FarzinNs83/NetShift');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _launchUrlAutoShut() async {
    final url = Uri.https('github.com', '/FarzinNs83/AutoShut');
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
              // SvgPicture.asset(
              //   Assets.svg.github,
              //   width: 50.0,
              //   height: 50.0,
              //   colorFilter: ColorFilter.mode(
              //       AppColors.settingsCustomCardSupportIcon, BlendMode.srcIn),
              // ),
              Image.asset(
                Assets.png.tray,
                width: 60.0,
                height: 60.0,
              ),
              Text(
                Platform.isAndroid ? "NetShift Windows" : "NetShift",
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
            _launchUrlAutoShut();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 15.0,
            children: [
              // SvgPicture.asset(
              //   Assets.svg.telegram,
              //   width: 50.0,
              //   height: 50.0,
              //   colorFilter: ColorFilter.mode(
              //       AppColors.settingsCustomCardSupportIcon, BlendMode.srcIn),
              // ),
              Image.asset(
                Assets.svg.autoshut,
                width: 60.0,
                height: 60.0,
              ),
              Text(
                'AutoShut',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.settingsCustomCardTitle,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
