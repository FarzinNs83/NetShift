import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:netshift/core/resources/extention_sized.dart';
import 'package:netshift/controller/check_for_update_controller.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/controller/splash_controller.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/services/windows_local_notif.dart';
import 'package:netshift/core/services/windows_title_bar_box.dart';
import 'package:netshift/core/widgets/check_for_update_widget.dart';
import 'package:netshift/core/widgets/double_tap_to_exit.dart';
import 'package:netshift/core/widgets/flutter_toast.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final NetshiftEngineController netshiftEngineController = Get.find();
  @override
  Widget build(BuildContext context) {
    return DoubleTapToExit(
      child: GetBuilder<CheckForUpdateController>(
        init: CheckForUpdateController(),
        builder: (controller) {
          if (controller.updateIsAvailable.value) {
            return const CheckForUpdateWidget();
          }
          return GetBuilder<SplashScreenController>(
            init: SplashScreenController(),
            builder: (splashController) {
              if (splashController.isOnline.value &&
                  !splashController.isError.value) {
                return Scaffold(
                  // WINDOWS
                  appBar: Platform.isWindows
                      ? const PreferredSize(
                          preferredSize: Size.fromHeight(60),
                          child: WindowsTitleBarBox(),
                        )
                      : null,
                  backgroundColor: AppColors.splashScreenBackground,
                  body: Stack(
                    children: [
                      // Next Version
                      // Align(
                      //   alignment: const AlignmentDirectional(3, -0.3),
                      //   child: Container(
                      //     height: 300,
                      //     width: 300,
                      //     decoration: const BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       color: Color(0xFF7C4DFF),
                      //     ),
                      //   ),
                      // ),
                      // Align(
                      //   alignment: const AlignmentDirectional(-3, -0.3),
                      //   child: Container(
                      //     height: 300,
                      //     width: 300,
                      //     decoration: const BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       color: Color(0xFF9575CD),
                      //     ),
                      //   ),
                      // ),
                      // Align(
                      //   alignment: const AlignmentDirectional(0, -1.2),
                      //   child: Container(
                      //     height: 300,
                      //     width: 600,
                      //     decoration: const BoxDecoration(
                      //       gradient: LinearGradient(
                      //         colors: [
                      //           Color.fromARGB(255, 5, 129, 113),
                      //           Color.fromARGB(255, 64, 163, 140),
                      //         ],
                      //         begin: Alignment.topLeft,
                      //         end: Alignment.bottomRight,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Align(
                      //   alignment: const AlignmentDirectional(0, 1.2),
                      //   child: Container(
                      //     height: 250,
                      //     width: 600,
                      //     decoration: const BoxDecoration(
                      //       gradient: LinearGradient(
                      //         colors: [
                      //           Color(0xFF536DFE),
                      //           Color(0xFF8C9EFF),
                      //         ],
                      //         begin: Alignment.topCenter,
                      //         end: Alignment.bottomCenter,
                      //       ),
                      //       borderRadius: BorderRadius.vertical(
                      //           top: Radius.circular(200)),
                      //     ),
                      //   ),
                      // ),
                      // BackdropFilter(
                      //   filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                      //   child: Container(
                      //     decoration:
                      //         const BoxDecoration(color: Colors.transparent),
                      //   ),
                      // ),
                      Center(
                        child: Text(
                          "NetShift DNS",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Calistoga',
                            fontSize: 42,
                            fontWeight: FontWeight.w600,
                            color: AppColors.splashScreenTitle,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 50,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Fetching Data",
                                  style: TextStyle(
                                    color: AppColors.splashScreenFetchData,
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                8.width,
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: SpinKitThreeBounce(
                                    color: AppColors.splashScreenSpinKit,
                                    controller:
                                        splashController.animationController,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else if (splashController.isOffline.value) {
                return Scaffold(
                  // WINDOWS
                  appBar: Platform.isWindows
                      ? const PreferredSize(
                          preferredSize: Size.fromHeight(60),
                          child: WindowsTitleBarBox(),
                        )
                      : null,
                  backgroundColor: AppColors.splashScreenBackground,
                  body: Stack(
                    children: [
                      Center(
                        child: Text(
                          "NetShift DNS",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Calistoga',
                            fontSize: 42,
                            fontWeight: FontWeight.w600,
                            color: AppColors.splashScreenTitle,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 50,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Loading",
                                  style: TextStyle(
                                    color: AppColors.splashScreenFetchData,
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                8.width,
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: SpinKitThreeBounce(
                                    color: AppColors.splashScreenSpinKit,
                                    controller:
                                        splashController.animationController,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else if (splashController.isError.value) {
                return Scaffold(
                  // WINDOWS
                  appBar: Platform.isWindows
                      ? const PreferredSize(
                          preferredSize: Size.fromHeight(60),
                          child: WindowsTitleBarBox(),
                        )
                      : null,
                  backgroundColor: AppColors.splashScreenBackground,
                  body: Stack(
                    children: [
                      Center(
                        child: Text(
                          "NetShift DNS",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Calistoga',
                            fontSize: 42,
                            fontWeight: FontWeight.w600,
                            color: AppColors.splashScreenTitle,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 50,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                splashController.getDnsListOnline();
                                netshiftEngineController.getIpAddress();
                              },
                              child: SizedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Try Again",
                                      style: TextStyle(
                                        color: AppColors.splashScreenTryAgain,
                                        fontSize: 20,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    8.width,
                                    Icon(
                                      Icons.refresh,
                                      color: AppColors.splashScreenTryAgainIcon,
                                      size: 28,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            16.height,
                            Text(
                              "Keep Having Connection Issues?",
                              style: TextStyle(
                                color: AppColors.offlineStatusText1,
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            10.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Switch To ",
                                  style: TextStyle(
                                    color: AppColors.offlineStatusText,
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                6.width,
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(
                                      color: Color.fromARGB(255, 255, 235, 58),
                                      width: 2,
                                    ),
                                    backgroundColor:
                                        Colors.black.withValues(alpha: 0.3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (Platform.isAndroid) {
                                      FlutterToast(
                                              message:
                                                  "Starting in Offline Mode")
                                          .flutterToast();
                                    } else if (Platform.isWindows) {
                                      WindowsLocalNotif(
                                              body: "Starting in Offline Mode",
                                              title: "NetShift Service")
                                          .showNotification();
                                    }
                                    splashController.online.remove('online');
                                    splashController.getDnsListOffline();
                                  },
                                  child: const Text(
                                    "Offline Mode",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 235, 255, 58),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                throw Exception("Unhandled state in SplashScreen");
              }
            },
          );
        },
      ),
    );
  }
}
