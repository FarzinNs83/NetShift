import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class GlowController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController glowController;
  late RxDouble glowValue = 6.0.obs;

  @override
  void onInit() {
    super.onInit();
    glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    glowController.addListener(() {
      glowValue.value = 6 + (24 * glowController.value);
    });
  }

  @override
  void onClose() {
    glowController.dispose();
    super.onClose();
  }
}