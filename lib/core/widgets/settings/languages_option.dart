import 'package:flutter/material.dart';
import 'package:netshift/core/resources/app_colors.dart';

class LanguagesOptionWidget extends StatefulWidget {
  const LanguagesOptionWidget({super.key});

  @override
  State<LanguagesOptionWidget> createState() => _LanguagesOptionWidgetState();
}

List<String> languageOptions = ['Persian', 'English'];

class _LanguagesOptionWidgetState extends State<LanguagesOptionWidget> {
  String currentOption = languageOptions[0];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        RadioListTile(
          title: Text(
            languageOptions[0],
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: (currentOption.contains(languageOptions[0]))
                  ? AppColors.settingsCustomCardTitle
                  : AppColors.settingsCustomCardSubTitle,
            ),
          ),
          value: languageOptions[0],
          groupValue: currentOption,
          activeColor: AppColors.settingsAppLanguage,
          onChanged: (value) {
            setState(() {
              currentOption = value.toString();
            });
          },
        ),
        Divider(
          color: AppColors.settingsGeneralCategoryDivider,
          thickness: 1.2,
          indent: 20.0,
          endIndent: 20.0,
          height: 10,
        ),
        RadioListTile(
          title: Text(
            languageOptions[1],
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: (currentOption.contains(languageOptions[1]))
                  ? AppColors.settingsCustomCardTitle
                  : AppColors.settingsCustomCardSubTitle,
            ),
          ),
          value: languageOptions[1],
          groupValue: currentOption,
          activeColor: AppColors.settingsAppLanguage,
          onChanged: (value) {
            setState(() {
              currentOption = value.toString();
            });
          },
        ),
      ],
    );
  }
}
