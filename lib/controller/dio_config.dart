import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:netshift/core/services/url_constant.dart';

final Dio dio = Dio();
void configureDio() {
  dio.options.baseUrl = UrlConstant.baseUrl + UrlConstant.ananas;
  dio.options.connectTimeout = const Duration(seconds: 7);
  dio.options.receiveTimeout = const Duration(seconds: 7);
  log("Connect timeout: ${dio.options.connectTimeout!.inSeconds} Seconds");
  log("Receive timeout: ${dio.options.receiveTimeout!.inSeconds} Seconds");
}

