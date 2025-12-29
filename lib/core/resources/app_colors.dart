import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  static bool isDarkMode = false;

  // ------------------ MAIN WRAPPER COLORS ------------------

  static Color get mainWrapperBackground => isDarkMode
      ? const Color(0xFF1A1B21)
      : const Color.fromARGB(255, 231, 218, 250);
  static Color get mainWrapperShadow => isDarkMode
      ? const Color.fromARGB(255, 40, 146, 95).withValues(alpha: 0.7)
      : const Color.fromARGB(230, 89, 70, 158);
  static Color get mainWrapperNavBarSelected => isDarkMode
      ? Colors.white.withAlpha(80)
      : const Color.fromARGB(180, 120, 110, 200);
  static Color get mainWrapperNavBarNotSelected =>
      isDarkMode ? Colors.transparent : Colors.transparent;
  static Color get mainWrapperNavBarSelectedShadow => isDarkMode
      ? const Color.fromARGB(255, 70, 207, 141).withValues(alpha: 0.3)
      : const Color.fromARGB(255, 119, 74, 202);

  static Color get mainWrapperNavBarIcons =>
      isDarkMode ? Colors.white : Colors.white;

  static Color get windowsTitleBarIcon =>
      isDarkMode ? Colors.greenAccent : Colors.white;

  // ------------------ SPLASH SCREEN COLORS ------------------

  static Color get splashScreenBackground => isDarkMode
      ? const Color(0xFF1A1B21)
      : const Color.fromARGB(255, 231, 218, 250);
  static Color get splashScreenTitle =>
      isDarkMode ? Colors.white : Colors.indigo;
  static Color get splashScreenFetchData =>
      isDarkMode ? Colors.white : Colors.indigo;
  static Color get splashScreenSpinKit =>
      isDarkMode ? Colors.white : Colors.indigo;
  static Color get splashScreenTryAgain => isDarkMode ? Colors.red : Colors.red;
  static Color get splashScreenTryAgainIcon =>
      isDarkMode ? Colors.red : Colors.red;
  static Color get checkForUpdateAnimatedIcon =>
      isDarkMode ? Colors.greenAccent : const Color.fromARGB(255, 119, 74, 202);
  static Color get checkForUpdateText =>
      isDarkMode ? Colors.white : const Color.fromARGB(255, 71, 59, 179);
  static Color get checkForUpdateLinearColor =>
      isDarkMode ? Colors.greenAccent : const Color.fromARGB(255, 71, 59, 179);
  static Color get checkForUpdateLinearBackgroundColor =>
      isDarkMode ? Colors.white : const Color.fromARGB(80, 71, 59, 179);

  // ------------------ HOME PAGE COLORS ------------------

  static Color get background => isDarkMode
      ? const Color(0xFF1A1B21)
      : const Color.fromARGB(255, 231, 218, 250);

  static Color get backgroundAppBar => isDarkMode
      ? const Color(0xFF1A1B21)
      : const Color.fromARGB(230, 71, 63, 181);
  static Color get timer =>
      isDarkMode ? Colors.white : const Color.fromARGB(255, 63, 65, 181);
  static Color get spinKitColor =>
      isDarkMode ? Colors.greenAccent : const Color.fromARGB(239, 76, 78, 179);

  static Color get textAppBar => isDarkMode ? Colors.white : Colors.indigo;

  static Color get iconAppBar => isDarkMode
      ? const Color.fromARGB(255, 70, 209, 142).withAlpha(50)
      : const Color.fromARGB(180, 94, 63, 181);

  static Color get download =>
      isDarkMode ? const Color(0xFF38AC72) : const Color(0xFF38AC72);

  static Color get ip =>
      isDarkMode ? const Color(0xFF428BC1) : const Color(0xFF428BC1);

  static Color get upload =>
      isDarkMode ? const Color(0xFFD2222D) : const Color(0xFFD2222D);

  static Color get worldMap => isDarkMode
      ? Colors.white.withValues(alpha: 0.34)
      : const Color.fromARGB(255, 81, 63, 181);

  static Color get connectButtonOn => isDarkMode
      ? const Color.fromARGB(150, 61, 173, 123)
      : const Color.fromARGB(172, 89, 70, 158).withValues(alpha: 0.7);

  static Color get connectButtonOff => isDarkMode
      ? const Color.fromARGB(120, 160, 160, 160)
      : const Color.fromARGB(170, 160, 160, 160);

  static Color get connectButtonOnShadow => isDarkMode
      ? const Color.fromARGB(255, 60, 214, 145).withValues(alpha: 0.6)
      : const Color.fromARGB(172, 89, 70, 158).withValues(alpha: 0.7);

  static Color get connectButtonOffShadow => isDarkMode
      ? const Color.fromARGB(209, 189, 189, 189).withValues(alpha: 0.6)
      : const Color.fromARGB(172, 89, 70, 158).withValues(alpha: 0.5);

  static Color get spinKit =>
      isDarkMode ? Colors.white.withAlpha(220) : Colors.white.withAlpha(220);

  static Color get powerIcon =>
      isDarkMode ? Colors.white.withAlpha(220) : Colors.white;

  static Color get dnsStatusShadow => isDarkMode
      ? Colors.greenAccent.withValues(alpha: 0.5)
      : const Color.fromARGB(255, 63, 75, 181);

  static Color get dnsStatusShadowText =>
      isDarkMode ? Colors.greenAccent.withValues(alpha: 0.7) : Colors.indigo;

  static Color get dnsStatusShadowText1 =>
      isDarkMode ? Colors.greenAccent.withValues(alpha: 0.7) : Colors.indigo;

  static Color get statusText => isDarkMode ? Colors.white : Colors.black;

  static Color get offlineStatusText =>
      isDarkMode ? const Color.fromARGB(223, 255, 255, 255) : Colors.indigo;

  static Color get offlineStatusText1 =>
      isDarkMode ? Colors.white : const Color.fromARGB(255, 37, 57, 170);
  static Color get interfaceTitle =>
      isDarkMode ? Colors.greenAccent : const Color.fromARGB(255, 37, 57, 170);

  static Color get interfaceName => isDarkMode ? Colors.white70 : Colors.indigo;

  static Color get interfaceHover => isDarkMode
      ? Colors.greenAccent.withValues(alpha: 0.5)
      : Colors.indigo.withValues(alpha: 0.5);

  static Color get interfaceHover1 => isDarkMode
      ? Colors.greenAccent.withValues(alpha: 0.3)
      : Colors.indigo.withValues(alpha: 0.3);

  static Color get interfaceClose =>
      isDarkMode ? Colors.greenAccent : Colors.indigo;

  static Color get interfaceCloseHover => isDarkMode
      ? Colors.greenAccent.withValues(alpha: 0.3)
      : Colors.indigo.withValues(alpha: 0.3);

  // ------------------ DNS PAGE COLORS ------------------

  static Color get appBarColorDnsPage =>
      isDarkMode ? Colors.transparent : Colors.indigo;

  static Color get appBarColorDnsPageText =>
      isDarkMode ? Colors.white : Colors.indigo;

  static Color get dnsText => isDarkMode ? Colors.white : Colors.indigo;

  static Color get dnsPinging => isDarkMode ? Colors.white : Colors.indigo;

  static Color get dnsSelectionContainer => isDarkMode
      ? const Color(0xFF1E2025)
      : const Color(0xFFB39DDB).withValues(alpha: 0.4);

  static Color get dnsSelectionContainerIcon => isDarkMode
      ? const Color.fromARGB(174, 105, 240, 175)
      : const Color(0xFF5E35B1);

  static Color get dnsSelectionContainerBorder => isDarkMode
      ? const Color(0xFF16725C)
      : const Color.fromARGB(255, 31, 30, 30);

  static Color get dnsSelectionContainerName =>
      isDarkMode ? Colors.white : const Color.fromARGB(255, 31, 30, 30);

  static Color get mainDnsSelectorSheet => isDarkMode
      ? const Color(0xFF1E2025)
      : const Color.fromARGB(255, 231, 218, 250);

  static Color get mainDnsSelectorSheetTongue =>
      isDarkMode ? Colors.white : Colors.indigo;

  static Color get mainDnsSelectorSheetColor =>
      isDarkMode ? Colors.transparent : Colors.transparent;

  static Color get dnsSelectionContainerNetShiftBackground => isDarkMode
      ? const Color(0xFF1E2025)
      : const Color.fromARGB(255, 231, 218, 250);

  static Color get dnsSelectionContainerNetShiftAppBarText =>
      isDarkMode ? Colors.white : Colors.indigo;

  static Color get dnsSelectionContainerNetShiftCloseIcon =>
      isDarkMode ? Colors.white : Colors.indigo;

  static Color get dnsSelectionContainerNetShiftContainer => isDarkMode
      ? const Color(0xFF292B33)
      : const Color(0xFFB39DDB).withValues(alpha: 0.4);

  static Color get dnsSelectionContainerNetShiftBorderContainer =>
      isDarkMode ? const Color(0xFF16725C) : Colors.indigo;

  static Color get dnsSelectionContainerNetShiftDnsName =>
      isDarkMode ? Colors.white : Colors.indigo;

  static Color get dnsSelectionContainerNetShiftDns =>
      isDarkMode ? Colors.grey : const Color.fromARGB(180, 63, 81, 181);

  static Color get dnsSelectorSheetPersonal => isDarkMode
      ? const Color(0xFF1E2025)
      : const Color.fromARGB(255, 231, 218, 250);

  static Color get dnsSelectorSheetPersonalAppBarText =>
      isDarkMode ? Colors.white : Colors.indigo;

  static Color get dnsSelectorSheetPersonalCloseIcon =>
      isDarkMode ? Colors.white : Colors.indigo;

  static Color get dnsSelectorSheetPersonalContainer => isDarkMode
      ? const Color(0xFF292B33)
      : const Color(0xFFB39DDB).withValues(alpha: 0.4);

  static Color get dnsSelectorSheetPersonalContainerBorder =>
      isDarkMode ? const Color(0xFF16725C) : Colors.indigo;

  static Color get dnsSelectorSheetPersonalDnsName =>
      isDarkMode ? Colors.white : Colors.indigo;

  static Color get dnsSelectorSheetPersonalDns =>
      isDarkMode ? Colors.grey : const Color.fromARGB(164, 63, 81, 181);

  static Color get dnsSelectorSheetPersonalDnsEdit =>
      isDarkMode ? const Color.fromARGB(197, 255, 255, 0) : Colors.yellow;

  static Color get dnsSelectorSheetPersonalDnsDelete =>
      isDarkMode ? const Color.fromARGB(197, 255, 82, 82) : Colors.red;

  static Color get dnsSelectorSheetPersonalNoDnsAddedText =>
      isDarkMode ? Colors.white : Colors.indigo;

  static Color get dnsSelectorSheetPersonalEditDnsBackground =>
      isDarkMode ? const Color(0xFF1E2025) : Colors.indigo;

  static Color get dnsSelectorSheetPersonalDeleteDnsBackground => isDarkMode
      ? const Color(0xFF1A1B21)
      : const Color.fromARGB(255, 231, 218, 250);

  static Color get dnsSelectorSheetPersonalDeleteDnsWarningIcon =>
      isDarkMode ? Colors.greenAccent : Colors.indigo;

  static Color get dnsSelectorSheetPersonalDeleteDnsWarningText =>
      isDarkMode ? Colors.greenAccent : Colors.indigo;

  static Color get dnsSelectorSheetPersonalDeleteDnsWarningText1 =>
      isDarkMode ? Colors.white70 : Colors.indigo.withValues(alpha: 0.8);

  static Color get dnsSelectorSheetPersonalDeleteDnsElevatedButton =>
      isDarkMode ? Colors.blueAccent : Colors.blueAccent;

  static Color get dnsSelectorSheetPersonalDeleteDnsElevatedButton1 =>
      isDarkMode ? Colors.white : Colors.indigo;

  static Color get dnsSelectorSheetPersonalDeleteDnsElevatedButtonShadow =>
      isDarkMode ? Colors.blueAccent.withValues(alpha: 0.4) : Colors.indigo;

  static Color get dnsSelectorSheetPersonalCancelDeleteDnsElevatedButton =>
      isDarkMode ? Colors.greenAccent : Colors.greenAccent;

  static Color get dnsSelectorSheetPersonalCancelDeleteDnsElevatedButton1 =>
      isDarkMode ? Colors.black : Colors.indigo;

  static Color
  get dnsSelectorSheetPersonalCancelDeleteDnsElevatedButtonShadow =>
      isDarkMode ? Colors.greenAccent.withValues(alpha: 0.4) : Colors.indigo;

  static Color get dnsSelectionContainerCopySnackBarText =>
      isDarkMode ? Colors.white : Colors.indigo;

  static Color get dnsSelectionContainerCopySnackBarBackground =>
      isDarkMode ? const Color.fromARGB(255, 47, 116, 82) : Colors.indigo;

  static Color get dnsSelectionContainerSelectedDns =>
      isDarkMode ? const Color(0xFF262626) : Colors.indigo;

  static Color get dnsSelectionContainerSelectedDnsAddress =>
      isDarkMode ? Colors.white : Colors.indigo;

  static Color get dnsSelectionCustomFloatingActionButtonBackground =>
      isDarkMode ? const Color(0xFF282A30) : Colors.indigo;

  static Color get dnsSelectionCustomFloatingAddDnsActionButtonBackground =>
      isDarkMode
      ? const Color(0xFF1E2025)
      : const Color.fromARGB(255, 196, 180, 221);

  static Color get dnsSelectionCustomButton =>
      isDarkMode ? const Color(0xFF16725C) : Colors.indigo;

  static Color get dnsSelectionCustomButtonText =>
      isDarkMode ? Colors.white : Colors.white;

  static Color get dnsSelectionCopy =>
      isDarkMode ? Colors.white : Colors.indigoAccent;

  static Color get dnsSelectionNeonGreen =>
      isDarkMode ? const Color.fromARGB(237, 118, 255, 187) : Colors.indigo;

  static Color get dnsSelectionLightBlack =>
      isDarkMode ? const Color.fromARGB(255, 46, 45, 45) : Colors.indigo;

  static Color get addDnsTextField =>
      isDarkMode ? const Color(0xFF16725C) : Colors.indigo;

  static Color get addDnsTextFieldBack => isDarkMode
      ? const Color(0xFF1A1B21).withValues(alpha: 0.8)
      : const Color(0xFFB39DDB).withValues(alpha: 0.4);

  static Color get addDnsTextFieldActivated => isDarkMode
      ? const Color(0xFF16725C).withValues(alpha: 0.7)
      : Colors.indigoAccent.withValues(alpha: 0.7);

  static Color get addDnsTextFieldFocused =>
      isDarkMode ? const Color(0xFF16725C) : Colors.indigoAccent;

  static Color get dnsGeneratorTitle =>
      isDarkMode ? Colors.white : Colors.indigoAccent.withValues(alpha: 0.7);

  static Color get dnsGeneratorIcon =>
      isDarkMode ? Colors.greenAccent : Colors.indigo;

  static Color get dnsGeneratorLoad =>
      isDarkMode ? Colors.white70 : Colors.indigo.withValues(alpha: 0.7);

  static Color get dnsGeneratorText => isDarkMode
      ? const Color.fromARGB(181, 105, 240, 175)
      : const Color.fromARGB(178, 64, 83, 190);

  static Color get dnsGeneratorButton =>
      isDarkMode ? Colors.greenAccent : Colors.indigo;

  static Color get textfieldTextColor =>
      isDarkMode ? Colors.white : Colors.indigo;

  // ------------------ DNS PING COLORS ------------------

  static Color get dnsPingBackground =>
      isDarkMode ? const Color(0xFF1A1B21) : Colors.indigo;

  static Color get dnsPingRefreshIcon =>
      isDarkMode ? Colors.white : Colors.indigo;

  static Color get dnsPingAppBarText =>
      isDarkMode ? Colors.white : Colors.indigo;

  static Color get dnsPingflash => isDarkMode
      ? const Color.fromARGB(221, 255, 255, 255)
      : const Color.fromARGB(221, 255, 255, 255);

  static Color get dnsPingflashBack =>
      isDarkMode ? const Color.fromARGB(255, 50, 156, 105) : Colors.indigo;

  static Color get dnsPingAppBarBackground =>
      isDarkMode ? const Color(0xFF1A1B21) : Colors.indigo;

  static Color get dnsPingContainerBackground =>
      isDarkMode ? const Color(0xFF262626) : Colors.indigo;

  static Color get dnsPingContainerBorder =>
      isDarkMode ? Colors.greenAccent : Colors.indigo;

  static Color get dnsPingContainerShadow =>
      isDarkMode ? Colors.greenAccent.withValues(alpha: 0.5) : Colors.indigo;

  static Color get dnsPingName =>
      isDarkMode ? Colors.greenAccent : Colors.indigo;

  static Color get dnsPingDivider =>
      isDarkMode ? Colors.greenAccent : Colors.indigo;

  static Color get dnsPing => isDarkMode ? Colors.greenAccent : Colors.indigo;

  static Color get dnsPingText =>
      isDarkMode ? Colors.white : const Color.fromARGB(179, 40, 53, 128);

  static Color get dnsPingGraphIcon =>
      isDarkMode ? Colors.greenAccent : Colors.indigo;

  static Color get dnsPingSpinkit =>
      isDarkMode ? Colors.white : const Color.fromARGB(179, 40, 53, 128);

  static Color get dnsPingResult =>
      isDarkMode ? Colors.white : const Color.fromARGB(179, 40, 53, 128);

  static Color get dnsPingApplyButtonForeground =>
      isDarkMode ? Colors.greenAccent : Colors.indigo;

  static Color get dnsPingApplyButtonBorder =>
      isDarkMode ? const Color.fromARGB(255, 76, 214, 148) : Colors.indigo;

  // ------------------ DNS SETTINGS COLORS ------------------

  static Color get settingsPageAppBar =>
      isDarkMode ? const Color(0xFF1A1B21) : Colors.indigo;

  static Color get settingsAppBarText =>
      isDarkMode ? Colors.white : Colors.indigo;

  static Color get settingsBackground =>
      isDarkMode ? const Color(0xFF1A1B21) : Colors.indigo;

  static Color get settingsGeneralCategory =>
      isDarkMode ? Colors.greenAccent : Colors.indigo;

  static Color get settingsGeneralCategoryDivider =>
      isDarkMode ? Colors.greenAccent : Colors.indigo;

  static Color get settingsGeneralThemeSwitcherActive =>
      isDarkMode ? Colors.greenAccent : Colors.indigo;

  static Color get settingsAppLanguage =>
      isDarkMode ? Colors.greenAccent : Colors.indigo;

  static Color get settingsSplitTunneling =>
      isDarkMode ? Colors.greenAccent : Colors.indigo;

  static Color get settingsAboutCategory =>
      isDarkMode ? Colors.greenAccent : Colors.indigo;

  static Color get settingsAboutDivider =>
      isDarkMode ? Colors.greenAccent : Colors.indigo;

  static Color get settingsSupport =>
      isDarkMode ? Colors.greenAccent : Colors.indigo;

  static Color get settingsCustomCardNotPressed =>
      isDarkMode ? const Color(0xFF262626) : const Color(0xFFC5CAE9);

  static Color get settingsCustomCardPressed =>
      isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFF9FA8DA);

  static Color get settingsCustomCardPressedShadow => isDarkMode
      ? Colors.greenAccent.withValues(alpha: 0.3)
      : const Color(0xFF7986CB);

  static Color get settingsCustomCardNotPressedShadow => isDarkMode
      ? Colors.greenAccent.withValues(alpha: 0.3)
      : const Color(0xFFB39DDB);

  static Color get settingsCustomCardTitle =>
      isDarkMode ? Colors.white : const Color(0xFF303F9F);

  static Color get settingsCustomCardSubTitle =>
      isDarkMode ? Colors.grey : const Color(0xFF3F51B5);

  static Color get settingsSnackBarBackground =>
      isDarkMode ? const Color(0xFF1A1B21) : const Color(0xFF3949AB);

  static Color get settingsSnackBarText =>
      isDarkMode ? Colors.greenAccent : Colors.white;

  static Color get settingsVerticalDivider =>
      isDarkMode ? Colors.greenAccent : const Color(0xFF5C6BC0);

  static Color get settingsIconColors =>
      isDarkMode ? Colors.greenAccent : Colors.indigo;

  static Color get settingsCustomCardBackground => isDarkMode
      ? const Color(0xFF1E2025)
      : const Color.fromARGB(255, 231, 218, 250);

  static Color get settingsCustomCardSupportIcon =>
      isDarkMode ? Colors.greenAccent : Colors.indigo;

  static Color get blockedAppBar => isDarkMode ? Colors.white : Colors.indigo;

  static Color get blockedAppContainer => isDarkMode
      ? const Color.fromARGB(80, 105, 240, 161)
      : const Color(0xFFB39DDB).withValues(alpha: 0.4);

  static Color get blockedAppContainerBorder =>
      isDarkMode ? Colors.greenAccent : Colors.indigo;

  static Color get blockedAppAppName =>
      isDarkMode ? Colors.white : Colors.indigo;

  static Color get policyAndServiceBackground => isDarkMode
      ? const Color(0xFF1A1B21)
      : const Color.fromARGB(255, 214, 193, 235);

  static Color get policyAndServiceTitle =>
      isDarkMode ? Colors.greenAccent : Colors.indigo;

  static Color get policyAndServiceText =>
      isDarkMode ? Colors.white : Colors.black;
}

class GradientAppColors {
  GradientAppColors._();
  static bool isDarkMode = false;
  static LinearGradient get dnsStatusBackground => isDarkMode
      ? const LinearGradient(
          colors: [
            Color.fromARGB(255, 29, 104, 85),
            Color.fromARGB(255, 24, 150, 112),
            Color(0xFF196856),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomLeft,
        )
      : const LinearGradient(
          colors: [
            Color.fromARGB(211, 101, 60, 140),
            Color.fromARGB(180, 90, 60, 180),
            Color.fromARGB(255, 133, 60, 140),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomLeft,
        );
  static LinearGradient get dnsStatusBackgroundHover => isDarkMode
      ? const LinearGradient(
          colors: [
            Color.fromARGB(255, 39, 124, 100),
            Color.fromARGB(255, 34, 170, 132),
            Color(0xFF21806A),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomLeft,
        )
      : const LinearGradient(
          colors: [
            Color.fromARGB(220, 101, 65, 140),
            Color.fromARGB(200, 90, 65, 180),
            Color.fromARGB(255, 133, 65, 140),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomLeft,
        );

  static LinearGradient get mainWrapperBottomNavContainer => isDarkMode
      ? const LinearGradient(
          colors: [Color(0xFF1A6B57), Color(0xFF1BA87D), Color(0xFF196856)],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        )
      : const LinearGradient(
          colors: [
            Color.fromARGB(255, 125, 70, 140),
            Color.fromARGB(255, 100, 60, 180),
            Color.fromARGB(255, 110, 60, 140),
          ],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        );
}
