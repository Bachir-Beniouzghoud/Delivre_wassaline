import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_navigation/src/snackbar/snackbar_controller.dart';

class Snakbar {
  static SnackbarController showMassge(
    String massege,
    String title,
    Color color,
  ) {
    return Get.snackbar(
      title,
      massege,
      snackPosition: SnackPosition.TOP,
      backgroundColor: color,
      colorText: Get.theme.colorScheme.onError,
    );
  }
}
