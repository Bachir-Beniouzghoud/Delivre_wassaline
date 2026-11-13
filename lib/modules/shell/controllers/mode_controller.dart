import 'package:get/get.dart';
import 'package:wassalni/core/enum/app_mode.dart';

/// يتحكم بوضع التطبيق (زبون/سائق) والتبويب المختار
///
/// القاعدة:
///  - الزبون لا يدخل وضع السائق إلا بعد موافقة مسؤول النظام (DriverStatus.approved)
///  - السائق المعتمد يتنقل بحرية بين الوضعين
class ModeController extends GetxController {
  /// الوضع الحالي
  final mode = AppMode.customer.obs;

  /// حالة طلب الترقية (تأتي من مستند المستخدم في Firestore)
  final driverStatus = DriverStatus.none.obs;

  /// رقم التبويب المختار في الشريط السفلي
  final tabIndex = 0.obs;

  /// جاري إرسال طلب الترقية
  final isRequesting = false.obs;

  /// هل يحق للمستخدم استعمال وضع السائق؟
  bool get canUseDriverMode => driverStatus.value == DriverStatus.approved;

  /// تُستدعى بعد تحميل المستخدم لتحديد الحالة والوضع الابتدائي
  void bindUser({required DriverStatus status}) {
    driverStatus.value = status;
    // إن سُحبت الموافقة والمستخدم في وضع السائق نعيده إلى وضع الزبون
    if (!canUseDriverMode && mode.value == AppMode.driver) {
      mode.value = AppMode.customer;
    }
  }

  /// يحاول التبديل إلى [target]، ويرجع false إذا مُنع (ليعرض الواجهة رسالة)
  bool switchTo(AppMode target) {
    if (target == mode.value) return true;
    if (target == AppMode.driver && !canUseDriverMode) return false;
    mode.value = target;
    tabIndex.value = 0; // نبدأ من أول تبويب في الوضع الجديد
    return true;
  }

  /// إرسال طلب الانضمام كسائق (يظهر عند مسؤول النظام للموافقة)
  Future<void> requestDriverAccess() async {
    if (driverStatus.value == DriverStatus.pending) return;
    isRequesting.value = true;
    try {
      // عبر UserRepository، وتبقى الموافقة النهائية بيد الإدارة فقط
      await Future<void>.delayed(const Duration(milliseconds: 400));
      driverStatus.value = DriverStatus.pending;
      Get.snackbar('', 'driver_request_sent'.tr);
    } finally {
      isRequesting.value = false;
    }
  }

  /// تغيير التبويب
  void selectTab(int i) => tabIndex.value = i;
}
