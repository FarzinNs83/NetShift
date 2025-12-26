import 'dart:io';

class PlatformService {
  PlatformService._();

  static bool get isDesktop =>
      Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  static bool get isMobile => Platform.isAndroid || Platform.isIOS;

  static bool get isMacOS => Platform.isMacOS;

  static bool get isWindows => Platform.isWindows;

  static bool get isLinux => Platform.isLinux;

  static bool get isAndroid => Platform.isAndroid;

  static bool get isIOS => Platform.isIOS;

  static bool get supportsDesktopUI => isDesktop;

  static bool get supportsTray => isWindows || isMacOS;

  static bool get supportsFlushDns => isWindows || isMacOS;

  static bool get supportsInterfaceSelection => isWindows || isMacOS;

  static bool get supportsSplitTunneling => isAndroid;
}
