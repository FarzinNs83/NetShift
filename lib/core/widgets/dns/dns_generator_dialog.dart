import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:netshift/core/resources/extention_sized.dart';
import 'package:netshift/core/resources/media_query_size.dart';
import 'package:netshift/controller/random_dns_generator_controller.dart';
import 'package:netshift/core/resources/app_colors.dart';

class DnsGeneratorDialog extends StatelessWidget {
  DnsGeneratorDialog({super.key});

  final RandomDnsGeneratorController randomDnsGeneratorController = Get.put(
    RandomDnsGeneratorController(),
  );
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "DNS Generator",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: AppColors.dnsGeneratorTitle,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.close, color: AppColors.dnsGeneratorTitle),
            ),
          ],
        ),
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 14),
          height: ScreenSize.height * 0.24,
          width: ScreenSize.width * 0.24,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              randomDnsGeneratorController.isGenerating.value
                  ? SpinKitFadingCircle(
                      color: AppColors.dnsGeneratorIcon,
                      size: 70,
                    )
                  : Icon(
                      Icons.check_circle_outline_sharp,
                      color: AppColors.dnsGeneratorIcon,
                      size: 70,
                    ),
              20.height,
              randomDnsGeneratorController.isGenerating.value
                  ? Text(
                      "Generating DNS...",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: AppColors.dnsGeneratorLoad,
                      ),
                    )
                  : Text(
                      "DNS Generated",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: AppColors.dnsGeneratorText,
                      ),
                    ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              randomDnsGeneratorController.isGenerating.value
                  ? TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.dnsGeneratorButton,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "OK",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
              // 12.width,
            ],
          ),
        ],
      ),
    );
  }
}
