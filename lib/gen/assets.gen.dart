/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// File path: assets/fonts/Calistoga-Regular.ttf
  String get calistogaRegular => 'assets/fonts/Calistoga-Regular.ttf';

  /// List of all assets
  List<String> get values => [calistogaRegular];
}

class $AssetsPngGen {
  const $AssetsPngGen();

  /// File path: assets/png/splash.png
  AssetGenImage get splash => const AssetGenImage('assets/png/splash.png');

  /// File path: assets/png/tray.ico
  String get tray => 'assets/png/tray.ico';

  /// List of all assets
  List<dynamic> get values => [splash, tray];
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/add_dns.svg
  String get addDns => 'assets/svg/add_dns.svg';

  /// File path: assets/svg/autoshut.ico
  String get autoshut => 'assets/svg/autoshut.ico';

  /// File path: assets/svg/cancel.svg
  String get cancel => 'assets/svg/cancel.svg';

  /// File path: assets/svg/close.svg
  String get close => 'assets/svg/close.svg';

  /// File path: assets/svg/copy.svg
  String get copy => 'assets/svg/copy.svg';

  /// File path: assets/svg/crown.svg
  String get crown => 'assets/svg/crown.svg';

  /// File path: assets/svg/dns.svg
  String get dns => 'assets/svg/dns.svg';

  /// File path: assets/svg/download.svg
  String get download => 'assets/svg/download.svg';

  /// File path: assets/svg/downloadcheck.svg
  String get downloadcheck => 'assets/svg/downloadcheck.svg';

  /// File path: assets/svg/flush.svg
  String get flush => 'assets/svg/flush.svg';

  /// File path: assets/svg/generate_dns.svg
  String get generateDns => 'assets/svg/generate_dns.svg';

  /// File path: assets/svg/github.svg
  String get github => 'assets/svg/github.svg';

  /// File path: assets/svg/global.svg
  String get global => 'assets/svg/global.svg';

  /// File path: assets/svg/home.svg
  String get home => 'assets/svg/home.svg';

  /// File path: assets/svg/interface.svg
  String get interface => 'assets/svg/interface.svg';

  /// File path: assets/svg/netshift.svg
  String get netshift => 'assets/svg/netshift.svg';

  /// File path: assets/svg/paint.svg
  String get paint => 'assets/svg/paint.svg';

  /// File path: assets/svg/ping.svg
  String get ping => 'assets/svg/ping.svg';

  /// File path: assets/svg/settings.svg
  String get settings => 'assets/svg/settings.svg';

  /// File path: assets/svg/telegram.svg
  String get telegram => 'assets/svg/telegram.svg';

  /// File path: assets/svg/trash.svg
  String get trash => 'assets/svg/trash.svg';

  /// File path: assets/svg/upload.svg
  String get upload => 'assets/svg/upload.svg';

  /// File path: assets/svg/world.svg
  String get world => 'assets/svg/world.svg';

  /// List of all assets
  List<String> get values => [
    addDns,
    autoshut,
    cancel,
    close,
    copy,
    crown,
    dns,
    download,
    downloadcheck,
    flush,
    generateDns,
    github,
    global,
    home,
    interface,
    netshift,
    paint,
    ping,
    settings,
    telegram,
    trash,
    upload,
    world,
  ];
}

class $AssetsTranslationsGen {
  const $AssetsTranslationsGen();

  /// File path: assets/translations/en-US.json
  String get enUS => 'assets/translations/en-US.json';

  /// File path: assets/translations/fa-IR.json
  String get faIR => 'assets/translations/fa-IR.json';

  /// List of all assets
  List<String> get values => [enUS, faIR];
}

class Assets {
  const Assets._();

  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsPngGen png = $AssetsPngGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();
  static const $AssetsTranslationsGen translations = $AssetsTranslationsGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
