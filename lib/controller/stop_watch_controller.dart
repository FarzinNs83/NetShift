import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StopWatchController extends GetxController {
  final GetStorage timerBox = GetStorage();
  Timer? timer;
  DateTime? startTime;
  Rx<Duration> elapsedTime = Duration.zero.obs;
  RxBool isRunning = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedTime();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsedTime.value = DateTime.now().difference(startTime!);
    });
  }

  void startWatchTime() {
    startTime = DateTime.now();
    isRunning.value = true;
    timerBox.write('startTime', startTime!.millisecondsSinceEpoch);
    timerBox.write('isRunning', true);
    startTimer();
  }

  void stopWatchTime() {
    timer?.cancel();
    isRunning.value = false;
    timerBox.remove('startTime');
    timerBox.write('isRunning', false);
    elapsedTime.value = Duration.zero;
  }

  void loadSavedTime() {
    final startTimeInMillisecond = timerBox.read('startTime');
    final savedIsRunning = timerBox.read('isRunning') ?? false;
    if (startTimeInMillisecond != null && savedIsRunning) {
      startTime = DateTime.fromMillisecondsSinceEpoch(startTimeInMillisecond);
      isRunning.value = true;
      startTimer();
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
}
