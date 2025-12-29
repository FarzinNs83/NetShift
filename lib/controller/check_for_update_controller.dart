import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:netshift/controller/dio_config.dart';
import 'package:netshift/core/services/url_constant.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckForUpdateController extends GetxController {
  RxString currentVersion = '1.0.0'.obs;
  RxString updateVersion = ''.obs;
  RxBool updateIsAvailable = false.obs;
  RxString appSize = ''.obs;

  Future<void> checkForUpdateAndroid() async {
    try {
      final response = await dio.get(UrlConstant.baseUrl + UrlConstant.ananas2);
      if (response.statusCode == 200) {
        final String status = response.data['status'];
        log(status);
        updateVersion.value = response.data['version'];
        if (response.data['size'] == null) {
          appSize.value = "0";
        } else {
          appSize.value = response.data['size'];
        }
        if (currentVersion.value == updateVersion.value) {
          log("No update available");
          updateIsAvailable.value = false;
        } else {
          log(
            "Update available version: ${updateVersion.value} with status code ${response.statusCode}",
          );
          updateIsAvailable.value = true;
        }
      } else {
        log("Error fetching update data: ${response.statusCode}");
      }
    } on DioException catch (e) {
      log("Error Getting Data from the url $e");
    }
  }

  Future<void> checkForUpdateWindows() async {
    try {
      final response = await dio.get(UrlConstant.baseUrl + UrlConstant.ananas4);
      if (response.statusCode == 200) {
        final String status = response.data['status'];
        log(status);
        updateVersion.value = response.data['version'];
        if (response.data['size'] == null) {
          appSize.value = "0";
        } else {
          appSize.value = response.data['size'];
        }
        if (currentVersion.value == updateVersion.value) {
          log("No update available");
          updateIsAvailable.value = false;
        } else {
          log(
            "Update available version: ${updateVersion.value} with status code ${response.statusCode}",
          );
          updateIsAvailable.value = true;
        }
      } else {
        log("Error fetching update data: ${response.statusCode}");
      }
    } on DioException catch (e) {
      log("Error Getting Data from the url $e");
    }
  }

  Future<void> checkForUpdateLinux() async {
    try {
      final response = await dio.get(UrlConstant.baseUrl + UrlConstant.ananas6);
      if (response.statusCode == 200) {
        final String status = response.data['status'];
        log(status);
        updateVersion.value = response.data['version'];
        if (response.data['size'] == null) {
          appSize.value = "0";
        } else {
          appSize.value = response.data['size'];
        }
        if (currentVersion.value == updateVersion.value) {
          log("No update available");
          updateIsAvailable.value = false;
        } else {
          log(
            "Update available version: ${updateVersion.value} with status code ${response.statusCode}",
          );
          updateIsAvailable.value = true;
        }
      } else {
        log("Error fetching update data: ${response.statusCode}");
      }
    } on DioException catch (e) {
      log("Error Getting Data from the url $e");
    }
  }

  Future<void> launchDownloadUrlAndroid() async {
    final url = Uri.parse(UrlConstant.baseUrl + UrlConstant.ananas3);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> launchDownloadUrlWindows() async {
    final url = Uri.parse(UrlConstant.baseUrl + UrlConstant.ananas5);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> launchDownloadUrlLinux() async {
    final url = Uri.parse(UrlConstant.baseUrl + UrlConstant.ananas7);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
