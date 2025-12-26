import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:netshift/core/resources/extention_sized.dart';
import 'package:netshift/controller/single_dns_ping_controller.dart';
import 'package:netshift/controller/sorted_dns_ping_controller.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/models/dns_model.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/widgets/app_bar.dart';
import 'package:netshift/core/widgets/custom_snack_bar.dart';
import 'package:netshift/core/widgets/flutter_toast.dart';

class DNSPing extends StatelessWidget {
  DNSPing({super.key});

  final NetshiftEngineController netshiftEngineController = Get.find();
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SortedDnsPingController());
    final dnsPingController = Get.find<SortedDnsPingController>();
    Get.lazyPut(
      () => SingleDnsPingController(),
    );
    final singleDnsPingController = Get.find<SingleDnsPingController>();
    return Obx(
      () {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.dnsPingflashBack,
            child: Icon(
              Icons.flash_on,
              size: 32,
              color: AppColors.dnsPingflash,
            ),
            onPressed: () {
              if (dnsPingController.isPinging.value) {
                CustomSnackBar(
                  title: "Operation Failed",
                  message:
                      "Failed to Ping, Please Wait for the Ping to Complete",
                  backColor: Colors.red.shade700.withValues(alpha: 0.9),
                  iconColor: Colors.white,
                  icon: Icons.error_outline,
                  textColor: Colors.white,
                ).customSnackBar();
                return;
              }
              dnsPingController.refreshDnsPingResults();
              if (Platform.isAndroid) {
                FlutterToast(message: "Pinging...").flutterToast();
              }
            },
          ),
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(
            centerTitle: true,
            title: "DNS Ping Result",
            fontSize: 24,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
          body: dnsPingController.isPinging.value
              ? Center(
                  child: SpinKitCircle(color: AppColors.spinKitColor, size: 70),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView.builder(
                    itemCount: dnsPingController.pingResultMap.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.dnsPingContainerBorder,
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
                              Text(
                                dnsPingController.ananas[index],
                                style: TextStyle(
                                  color: AppColors.dnsPingName,
                                  fontSize: 22,
                                  fontFamily: 'IRANSansX',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Divider(
                                color: AppColors.dnsPingDivider,
                                thickness: 1.2,
                                height: 20,
                              ),
                              8.height,
                              Row(
                                children: [
                                  Icon(
                                    Icons.dns,
                                    color: AppColors.dnsPing,
                                    size: 18,
                                  ),
                                  8.width,
                                  Text(
                                    "${dnsPingController.ananas1[index]}  ->  ${dnsPingController.ananas4[index]} ms",
                                    style: TextStyle(
                                      color: AppColors.dnsPingText,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              8.height,
                              Row(
                                children: [
                                  Icon(
                                    Icons.dns_outlined,
                                    color: AppColors.dnsPing,
                                    size: 18,
                                  ),
                                  8.width,
                                  Expanded(
                                    child: Text(
                                      "${dnsPingController.ananas2[index]}  ->  ${dnsPingController.ananas5[index]} ms",
                                      style: TextStyle(
                                        color: AppColors.dnsPingText,
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              16.height,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.graphic_eq,
                                        color: AppColors.dnsPingGraphIcon,
                                        size: 18,
                                      ),
                                      8.width,
                                      Text(
                                        "Average Ping: ${dnsPingController.ananas3[index]} ms",
                                        style: TextStyle(
                                          color: AppColors.dnsPingResult,
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors
                                          .dnsPingApplyButtonForeground,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'IRANSansX',
                                      ),
                                      side: BorderSide(
                                        color:
                                            AppColors.dnsPingApplyButtonBorder,
                                        width: 2,
                                      ),
                                    ),
                                    onPressed: () {
                                      if (Platform.isAndroid &&
                                          netshiftEngineController
                                              .isPermissionGiven.value &&
                                          !netshiftEngineController
                                              .isActive.value) {
                                        netshiftEngineController
                                            .selectedDns.value = DnsModel(
                                          name: dnsPingController.ananas[index],
                                          primaryDNS:
                                              dnsPingController.ananas1[index],
                                          secondaryDNS:
                                              dnsPingController.ananas2[index],
                                        );
                                        netshiftEngineController
                                            .saveSelectedDnsValue();
                                        singleDnsPingController
                                            .pingPrimaryDns();
                                        singleDnsPingController
                                            .pingSecondaryDns();
                                        CustomSnackBar(
                                          title: "Operation Success",
                                          message:
                                              "${netshiftEngineController.selectedDns.value.name} Has Been Applied Successfully",
                                          backColor: const Color.fromARGB(
                                                  255, 50, 189, 122)
                                              .withValues(alpha: 0.9),
                                          iconColor: Colors.white,
                                          icon: Icons.error_outline,
                                          textColor: Colors.white,
                                        ).customSnackBar();
                                      } else if (Platform.isAndroid &&
                                          netshiftEngineController
                                              .isActive.value) {
                                        CustomSnackBar(
                                          title: "Operation Failed",
                                          message:
                                              "Failed to START SERVICE, please stop the service first",
                                          backColor: Colors.red.shade700
                                              .withValues(alpha: 0.9),
                                          iconColor: Colors.white,
                                          icon: Icons.error_outline,
                                          textColor: Colors.white,
                                        ).customSnackBar();
                                        return;
                                      } else if (Platform.isWindows &&
                                          netshiftEngineController
                                              .isActive.value) {
                                        CustomSnackBar(
                                          title: "Operation Failed",
                                          message:
                                              "Failed to START SERVICE, please stop the service first",
                                          backColor: Colors.red.shade700
                                              .withValues(alpha: 0.9),
                                          iconColor: Colors.white,
                                          icon: Icons.error_outline,
                                          textColor: Colors.white,
                                        ).customSnackBar();
                                        return;
                                      } else if (Platform.isWindows &&
                                          !netshiftEngineController
                                              .isActive.value) {
                                        netshiftEngineController
                                            .selectedDns.value = DnsModel(
                                          name: dnsPingController.ananas[index],
                                          primaryDNS:
                                              dnsPingController.ananas1[index],
                                          secondaryDNS:
                                              dnsPingController.ananas2[index],
                                        );
                                        netshiftEngineController
                                            .saveSelectedDnsValue();
                                        singleDnsPingController
                                            .pingPrimaryDns();
                                        singleDnsPingController
                                            .pingSecondaryDns();
                                        CustomSnackBar(
                                          title: "Operation Success",
                                          message:
                                              "${netshiftEngineController.selectedDns.value.name} Has Been Applied Successfully",
                                          backColor: const Color.fromARGB(
                                                  255, 50, 189, 122)
                                              .withValues(alpha: 0.9),
                                          iconColor: Colors.white,
                                          icon: Icons.error_outline,
                                          textColor: Colors.white,
                                        ).customSnackBar();
                                      }
                                    },
                                    child: const Text("Apply"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        );
      },
    );
  }
}
