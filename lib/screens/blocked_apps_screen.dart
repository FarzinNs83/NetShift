import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:netshift/core/resources/extention_sized.dart';
import 'package:netshift/core/resources/media_query_size.dart';
import 'package:netshift/controller/blocked_apps_controller.dart';
import 'package:netshift/core/resources/app_colors.dart';

class BlockedAppsScreen extends StatelessWidget {
  BlockedAppsScreen({super.key});
  final BlockedAppsController blockedAppsController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Blocked Apps",
          style: TextStyle(
            color: AppColors.blockedAppBar,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.blockedAppBar),
          onPressed: () => Get.back(),
        ),
        actions: [
          PopupMenuButton(
            iconColor: AppColors.blockedAppBar,
            borderRadius: BorderRadius.circular(12),
            color: AppColors.dnsSelectionContainer,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: GestureDetector(
                    onTap: () {
                      blockedAppsController.isSystemApp.value =
                          !blockedAppsController.isSystemApp.value;
                      blockedAppsController.apps.clear();
                      blockedAppsController.installedApps();
                      blockedAppsController.saveSystemAppState();
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Obx(() {
                          return Checkbox(
                            value: blockedAppsController.isSystemApp.value,
                            onChanged: (value) {
                              blockedAppsController.isSystemApp.value = value!;
                              blockedAppsController.apps.clear();
                              blockedAppsController.installedApps();
                              blockedAppsController.saveSystemAppState();
                              Navigator.pop(context);
                            },
                          );
                        }),
                        Text(
                          'System Apps',
                          style: TextStyle(
                            color: AppColors.blockedAppBar,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: AppColors.background,
      ),
      body: Obx(() {
        if (blockedAppsController.apps.isEmpty) {
          return Center(
            child: SpinKitFoldingCube(color: AppColors.spinKitColor, size: 48),
          );
        }
        return ListView.builder(
          itemCount: blockedAppsController.apps.length,
          itemBuilder: (context, index) {
            final appList = blockedAppsController.apps[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  if (blockedAppsController.blockedApps.contains(
                    appList.packageName,
                  )) {
                    blockedAppsController.blockedApps.remove(
                      appList.packageName,
                    );
                    blockedAppsController.saveBlockedAppsList();
                    log("App Removed ${appList.packageName}");
                  } else {
                    blockedAppsController.blockedApps.add(appList.packageName);
                    blockedAppsController.saveBlockedAppsList();
                    log("App Added ${appList.packageName}");
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.blockedAppContainer,
                    border: Border.all(
                      color: AppColors.blockedAppContainerBorder,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      appList.icon != null && appList.icon!.isNotEmpty
                          ? Image.memory(appList.icon!, height: 32)
                          : const Icon(
                              Icons.android,
                              color: Colors.greenAccent,
                              size: 32,
                            ),
                      12.width,
                      SizedBox(
                        width: ScreenSize.width * 0.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appList.name,
                              style: TextStyle(
                                color: AppColors.blockedAppAppName,
                                fontSize: 18,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            6.height,
                            Text(
                              appList.packageName,
                              style: TextStyle(
                                color: AppColors.blockedAppAppName.withValues(
                                  alpha: 0.7,
                                ),
                                fontSize: 12,
                                fontFamily: 'Poppins',
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Obx(() {
                        return Checkbox(
                          side: const BorderSide(
                            color: Colors.black,
                            width: 1.5,
                          ),
                          checkColor: Colors.black,
                          activeColor: const Color.fromARGB(190, 105, 240, 127),
                          value: blockedAppsController.blockedApps.contains(
                            appList.packageName,
                          ),
                          onChanged: (value) {
                            if (value == true) {
                              blockedAppsController.blockedApps.add(
                                appList.packageName,
                              );
                              blockedAppsController.saveBlockedAppsList();
                              log("App Added ${appList.packageName}");
                            } else {
                              blockedAppsController.blockedApps.remove(
                                appList.packageName,
                              );
                              blockedAppsController.saveBlockedAppsList();
                              log("App Removed ${appList.packageName}");
                            }
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
