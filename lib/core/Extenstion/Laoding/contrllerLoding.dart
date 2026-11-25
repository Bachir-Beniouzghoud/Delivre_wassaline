
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLoaderController extends GetxController
    with GetSingleTickerProviderStateMixin {

  late AnimationController animationController;

  final RxBool isIndeterminate = true.obs;
  final RxDouble progress = 0.0.obs;
  final RxString statusMessage = '70'.tr.obs;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  void updateProgress(double value) {
    progress.value = value.clamp(0.0, 100.0);
    isIndeterminate.value = false;
  }

  void startIndeterminate() {
    isIndeterminate.value = true;
    animationController.repeat();
  }

  void setMessage(String message) {
    statusMessage.value = message;
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}

