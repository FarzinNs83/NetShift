import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:netshift/core/resources/extention_sized.dart';
import 'package:netshift/core/resources/media_query_size.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/controller/random_dns_generator_controller.dart';
import 'package:netshift/controller/single_dns_ping_controller.dart';
import 'package:netshift/controller/splash_controller.dart';
import 'package:netshift/gen/assets.gen.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/widgets/add_dns.dart';
import 'package:netshift/core/widgets/app_bar.dart';
import 'package:netshift/core/widgets/custom_floating_action_button.dart';
import 'package:netshift/core/widgets/custom_textfield.dart';
import 'package:netshift/core/widgets/dns_generator_dialog.dart';
import 'package:netshift/core/widgets/dns_selection_container.dart';
import 'package:netshift/core/widgets/custom_button.dart';
import 'package:netshift/core/widgets/main_dns_selector.dart';
import 'package:netshift/core/widgets/custom_snack_bar.dart';
import 'package:netshift/core/widgets/world_map.dart';

class DNSPage extends StatelessWidget {
  DNSPage({super.key});

  final NetshiftEngineController netshiftEngineController = Get.find();
  final splashScreenController = Get.find<SplashScreenController>();
  // final sortedDnsPingController = Get.put(SortedDnsPingController());
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SingleDnsPingController());
    final dnsPingController = Get.find<SingleDnsPingController>();
    Get.lazyPut(() => RandomDnsGeneratorController());
    final randomDnsGeneratorController =
        Get.find<RandomDnsGeneratorController>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: "Select DNS",
        fontFamily: 'Poppins',
        fontSize: 22,
        fontWeight: FontWeight.bold,
        centerTitle: true,
      ),
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const WorldMap(),
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: ScreenSize.height * 0.02),
                    DnsSelectionContainer(
                      onPressed: () {
                        if (netshiftEngineController.isActive.value) {
                          CustomSnackBar(
                            title: "Operation Failed",
                            message:
                                "Failed to SELECT DNS, please stop the service first",
                            backColor:
                                Colors.red.shade700.withValues(alpha: 0.9),
                            iconColor: Colors.white,
                            icon: Icons.error_outline,
                            textColor: Colors.white,
                          ).customSnackBar();
                        } else {
                          showModalBottomSheet(
                            sheetAnimationStyle: AnimationStyle(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                              reverseDuration:
                                  const Duration(milliseconds: 300),
                              reverseCurve: Curves.easeInOut,
                            ),
                            context: context,
                            builder: (context) {
                              return MainDNSSelector();
                            },
                          );
                        }
                      },
                      color: AppColors.dnsSelectionContainerIcon,
                    ),
                    SizedBox(height: ScreenSize.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Primary :",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppColors.dnsText,
                          ),
                        ),
                        dnsPingController.isPingP.value
                            ? SpinKitCircle(
                                color: AppColors.spinKitColor,
                                size: 22,
                              )
                            : Text(
                                "${dnsPingController.resultPingP} ms",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: AppColors.dnsText,
                                ),
                              ),
                      ],
                    ),
                    8.height,
                    CustomTextContainer(
                      dns:
                          netshiftEngineController.selectedDns.value.primaryDNS,
                    ),
                    SizedBox(height: ScreenSize.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Secondary :",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppColors.dnsText,
                          ),
                        ),
                        dnsPingController.isPingS.value
                            ? SpinKitCircle(
                                color: AppColors.spinKitColor,
                                size: 22,
                              )
                            : Text(
                                "${dnsPingController.resultPingS} ms",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: AppColors.dnsText,
                                ),
                              ),
                      ],
                    ),
                    8.height,
                    CustomTextContainer(
                      dns: netshiftEngineController
                          .selectedDns.value.secondaryDNS,
                    ),
                    SizedBox(height: ScreenSize.height * 0.03),
                    CustomButton(
                      text: "Ping",
                      onTap: () {
                        dnsPingController.pingPrimaryDns();
                        dnsPingController.pingSecondaryDns();
                      },
                    ),
                    // CustomButton(
                    //   text: "TEST",
                    //   onTap: () {
                    //     sortedDnsPingController.sortedPing();
                    //   },
                    // ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 12, left: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomFloatingActionButton(
                            path: Assets.svg.generateDns,
                            onTap: () {
                              if (splashScreenController.isOffline.value) {
                                CustomSnackBar(
                                  title: "Operation Failed",
                                  message:
                                      "Failed to GENERATE DNS, please start the app in online mode",
                                  backColor: Colors.red.shade700
                                      .withValues(alpha: 0.9),
                                  iconColor: Colors.white,
                                  icon: Icons.error_outline,
                                  textColor: Colors.white,
                                ).customSnackBar();
                                return;
                              }
                              randomDnsGeneratorController.generateRandomDns();
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return DnsGeneratorDialog();
                                },
                              );
                            },
                          ),
                          CustomFloatingActionButton(
                            path: Assets.svg.addDns,
                            onTap: () {
                              if (netshiftEngineController.isActive.value) {
                                CustomSnackBar(
                                  title: "Operation Failed",
                                  message:
                                      "Failed to ADD DNS, please stop the service first",
                                  backColor: Colors.red.shade700
                                      .withValues(alpha: 0.9),
                                  iconColor: Colors.white,
                                  icon: Icons.error_outline,
                                  textColor: Colors.white,
                                ).customSnackBar();
                              } else {
                                showModalBottomSheet(
                                  context: context,
                                  sheetAnimationStyle: AnimationStyle(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.fastOutSlowIn,
                                    reverseDuration:
                                        const Duration(milliseconds: 300),
                                    reverseCurve: Curves.fastOutSlowIn,
                                  ),
                                  isScrollControlled: true,
                                  builder: (context) =>
                                      const AddDnsBottomSheet(),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
