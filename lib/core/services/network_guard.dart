import 'package:get/get.dart';
import 'package:wassalni/core/Extenstion/snakbar.dart';
import 'package:wassalni/core/services/Networksirvises.dart';
import 'package:wassalni/core/theme/Appcolors.dart';

/// فحص سريع قبل أي عملية شبكية، يعتمد على NetworkService.isOnline.
/// يرجع true إذا كان الاتصال متاحاً (أو الخدمة غير مسجلة)، وإلا يُظهر رسالة ويرجع false.
bool ensureOnline({bool showMessage = true}) {
  if (!Get.isRegistered<NetworkService>()) return true;
  if (Get.find<NetworkService>().isOnline.value) return true;
  if (showMessage) {
    Snakbar.showMassge('chaick_Network'.tr, '56'.tr, AppColors.error);
  }
  return false;
}
