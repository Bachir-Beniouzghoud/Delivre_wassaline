import 'package:get/get.dart';

class AppDialogController extends GetxController {
  // حالة تنفيذ العملية
  final RxBool isLoading = false.obs;

  // رسالة الخطأ
  final RxString errorMessage = ''.obs;

  /// تنفيذ العملية عند الضغط على زر التأكيد
  Future<bool> execute({Future<void> Function()? onConfirm}) async {
    // منع تكرار تنفيذ العملية
    if (isLoading.value) return false;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // تنفيذ العملية التي يحددها المستخدم
      if (onConfirm != null) {
        await onConfirm();
      }

      return true;
    } catch (e) {
      // الاحتفاظ برسالة الخطأ لعرضها في الواجهة
      errorMessage.value = e.toString();

      return false;
    } finally {
      // إعادة حالة التحميل إلى وضعها الطبيعي
      isLoading.value = false;
    }
  }
}
