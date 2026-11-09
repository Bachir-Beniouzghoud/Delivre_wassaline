// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';

// class AppLoaderController extends GetxController {
//   // نسبة تقدم العملية من 0 إلى 100
//   final RxDouble progress = 0.0.obs;

//   // تحديد نوع التحميل
//   final RxBool isIndeterminate = true.obs;

//   // الرسالة التي تظهر أسفل الشعار
//   final RxString statusMessage = "70".tr.obs;

//   // المرحلة الحالية
//   final RxString currentStep = ''.obs;

//   // هل انتهت العملية بنجاح؟
//   final RxBool isCompleted = false.obs;

//   /// تحديث نسبة التحميل
//   void updateProgress(double value) {
//     progress.value = value.clamp(0.0, 100.0);

//     isIndeterminate.value = false;

//     if (progress.value >= 100) {
//       isCompleted.value = true;
//     }
//   }

//   late final AnimationController animationController;
//   @override
//   void onInit() {
//     // إنشاء الحركة داخل Widget
//     animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1600),
//     )..repeat();
//     // TODO: implement onInit
//     super.onInit();
//   }
// @override
//   void dispose() {
//         animationController.dispose();

//     // TODO: implement dispose
//     super.dispose();
//   }
//   /// تغيير رسالة التحميل
//   void updateStatus(String message) {
//     statusMessage.value = message;
//   }

//   /// تغيير المرحلة الحالية
//   void updateStep(String step) {
//     currentStep.value = step;
//   }

//   /// تفعيل التحميل غير المحدد
//   void startIndeterminate({String? message}) {
//     isIndeterminate.value = true;
//     isCompleted.value = false;
//     progress.value = 0;
//     statusMessage.value = message ?? "70".tr;
//   }

//   /// إعادة ضبط الحالة
//   void reset() {
//     progress.value = 0;
//     isIndeterminate.value = true;
//     isCompleted.value = false;
//     statusMessage.value = "70".tr; //"70": 'Loading...',
//     currentStep.value = '';
//   }
// }

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

