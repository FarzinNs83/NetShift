import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:netshift/controller/system_chrome_controller.dart';
import 'package:netshift/core/resources/app_colors.dart';

class ThemeController extends GetxController {
  final GetStorage _storage = GetStorage();
  final String _key = 'isDarkMode';

  bool isDarkMode = false;
  @override
  void onInit() {
    super.onInit();
    isDarkMode = _storage.read<bool>(_key) ?? true;
    AppColors.isDarkMode = isDarkMode;
    GradientAppColors.isDarkMode = isDarkMode;
  }

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    AppColors.isDarkMode = isDarkMode;
    GradientAppColors.isDarkMode = isDarkMode;
    SystemChromeController().setSystemUIOverlayStyle();
    _storage.write(_key, isDarkMode);
    Get.forceAppUpdate();
  }
}
