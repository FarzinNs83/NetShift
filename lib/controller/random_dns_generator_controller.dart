// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart' as dio_pkg;
import 'package:get/get.dart';
import 'package:netshift/controller/dio_config.dart';
import 'package:netshift/core/services/url_constant.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/models/dns_model.dart';

class RandomDnsGeneratorController extends GetxController {
  final NetshiftEngineController netshiftEngineController = Get.find();
  List<DnsModel> generatedDnsList = <DnsModel>[];
  final Random random = Random();
  RxBool isGenerating = false.obs;

  Future<void> generateRandomDns() async {
    print("Starting DNS Generator");
    isGenerating.value = true;

    try {
      final dio_pkg.Response<dynamic> response = await dio.get(
        UrlConstant.baseUrl + UrlConstant.ananas1,
      );

      if (response.statusCode == 200) {
        generatedDnsList.clear();
        final String status = response.data['status'];
        final int code = response.data['code'];
        print("Generated DNS Status : $status");
        print("Generated DNS Code : ${code.toString()}");
        final Map<String, dynamic> validatedDnsData = jsonDecode(
          response.data['data'],
        );
        validatedDnsData['validateDNS'].forEach((dynamic json) {
          generatedDnsList.add(DnsModel.fromJson(json));
        });
        //TODO Will add dnsCounter later
        for (int dnsCount = 0; dnsCount < 1; dnsCount++) {
          if (generatedDnsList.isNotEmpty) {
            netshiftEngineController.dnsListPersonal.add(
              generatedDnsList[random.nextInt(generatedDnsList.length)],
            );
            netshiftEngineController.savePersonalDns();
            print("DNS Generated successfully");
          } else {
            print("No DNS generated from the API.");
          }
        }
      } else if (response.statusCode == 404) {
        print("Server error 404");
      } else {
        print("Unexpected server response: ${response.statusCode}");
      }
    } on dio_pkg.DioException catch (e) {
      print("Error generating DNS: ${e.message}");
    } finally {
      isGenerating.value = false;
    }
  }
}
