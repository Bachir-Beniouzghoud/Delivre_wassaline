// import 'dart:async';

import 'dart:async';

import 'package:get/get.dart';
import 'package:wassalni/core/Extenstion/snakbar.dart';
import 'package:wassalni/core/enum/app_mode.dart';
import 'package:wassalni/core/services/network_guard.dart';
import 'package:wassalni/core/theme/Appcolors.dart';
import 'package:wassalni/data/models/Users/dilevre_model.dart';
import 'package:wassalni/data/models/Users/user_model.dart';
import 'package:wassalni/data/repositories/abstractInterface/users/user_intreface.dart';
import 'package:wassalni/modules/auth/controllers/AuthController.dart';

class ModeController extends GetxController {
  // ─────────────────────────────────────────────
  // 1) التبعيات (Dependencies): تُحقن من ShellBinding
  // ─────────────────────────────────────────────
  ModeController(this._auth, this._userRepository);

  final Authcontroller _auth; // مصدر المستخدم الحالي
  final UserRepository _userRepository; // الوصول إلى Firebase (عبر الواجهة)

  // ─────────────────────────────────────────────
  // 2) الحالة (State): يملكها هذا الـ Controller
  // ─────────────────────────────────────────────

  /// الوضع الحالي: customer أو driver. الافتراضي زبون.
  final mode = AppMode.customer.obs;

  /// حالة طلب السائق: none / pending / approved ...
  /// تأتي من Firebase عبر الـ Stream، ولا نعدّلها يدويًا أبدًا.
  late Rx<DriverStatus> driverStatus =
      _auth.currentUserDilevere.value?.driverStatus.obs ??
      DriverStatus.pending.obs;

  /// رقم التبويب المختار في الشريط السفلي
  final tabIndex = 0.obs;

  /// true أثناء إرسال الطلب (لتعطيل الزر وإظهار مؤشر تحميل)
  final isRequesting = false.obs;

  // ─────────────────────────────────────────────
  // 3) موارد يجب إغلاقها في onClose
  // ─────────────────────────────────────────────

  /// الاشتراك في Stream حالة السائق (لإلغائه عند الحاجة)
  StreamSubscription<DriverStatus>? _statusSub;

  /// "عامل" GetX يراقب تغيّر currentUser
  Worker? _userWorker;

  /// هل يحق له استخدام وضع السائق؟ فقط إن وافقت الإدارة.
  bool get canUseDriverMode => driverStatus.value == DriverStatus.approved;

  // ─────────────────────────────────────────────
  // 4) دورة الحياة
  // ─────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();

    // ever: ينفّذ الدالة في كل مرة تتغير فيها قيمة currentUser
    // (دخول، خروج، تحديث بيانات).
    _userWorker = ever<UserModel?>(_auth.currentUser, _onUserChanged);

    // ever لا يعمل للقيمة الحالية، فنستدعي الدالة يدويًا مرة واحدة
    // حتى لا نفوّت المستخدم المسجَّل أصلًا قبل إنشاء هذا الـ Controller.
    _onUserChanged(_auth.currentUser.value);
  }

  @override
  void onClose() {
    _statusSub
        ?.cancel(); // مهم: لا تترك الـ Stream مفتوحًا (تسريب ذاكرة وقراءات)
    _userWorker?.dispose();
    super.onClose();
  }

  // ─────────────────────────────────────────────
  // 5) التفاعل مع تغيّر المستخدم
  // ─────────────────────────────────────────────
  void _onUserChanged(UserModel? user) {
    // نلغي أي اشتراك قديم أولًا، وإلا سيعمل اشتراكان معًا لمستخدمين مختلفين
    _statusSub?.cancel();
    _statusSub = null;

    if (user == null) {
      // تسجيل خروج: نعيد كل شيء إلى الوضع الافتراضي
      driverStatus.value = DriverStatus.none;
      mode.value = AppMode.customer;
      tabIndex.value = 0;
      return;
    }

    // مستخدم موجود: نفتح Stream على مستنده في Firebase
    _statusSub = _userRepository
        .watchDriverStatus(user.id)
        .listen(
          _bindStatus, // عند كل حالة جديدة
          onError: (_) =>
              Snakbar.showMassge('connection_error'.tr, '', AppColors.error),
        );
  }

  /// تُستدعى كلما وصلت حالة جديدة من Firebase
  void _bindStatus(DriverStatus status) {
    driverStatus.value = status;

    // حالة خاصة: السائق سُحبت موافقته وهو داخل وضع السائق
    // نعيده فورًا إلى وضع الزبون حتى لا يبقى يستقبل طلبات.
    if (!canUseDriverMode && mode.value == AppMode.driver) {
      mode.value = AppMode.customer;
    }
  }

  // ─────────────────────────────────────────────
  // 6) تبديل الوضع
  // ─────────────────────────────────────────────

  /// يرجع true إن نجح التبديل، وfalse إن لم يُسمح به.
  bool switchTo(AppMode target) {
    if (target == mode.value) return true; // نفس الوضع، لا شيء يتغير

    // ممنوع الدخول لوضع السائق قبل الموافقة
    if (target == AppMode.driver && !canUseDriverMode) return false;

    mode.value = target;
    tabIndex.value = 0; // نبدأ من أول تبويب في الوضع الجديد
    return true;
  }

  void selectTab(int i) => tabIndex.value = i;

  // ─────────────────────────────────────────────
  // 7) إرسال طلب الانضمام كسائق
  // ─────────────────────────────────────────────
  Future<void> requestDriverAccess() async {
    final user = _auth.currentUser.value;

    // لا مستخدم، أو طلب قيد الإرسال الآن: لا نكرر الضغط
    if (user == null || isRequesting.value) return;

    // نفحص الحالة الحالية ونُعلم المستخدم بدل الخروج بصمت.
    // هذا هو إصلاح مشكلتك: كانت الدالة تعمل return دون أي رسالة.
    switch (driverStatus.value) {
      case DriverStatus.pending:
        Snakbar.showMassge(
          'driver_request_pending'.tr, // "تم إرسال طلبك وهو قيد المعالجة"
          '',
          AppColors.success,
        );
        return;

      case DriverStatus.approved:
        Snakbar.showMassge(
          'driver_already_approved'.tr, // "حسابك مفعّل كسائق بالفعل"
          '',
          AppColors.success,
        );
        return;

      default:
        break; // none أو rejected: نسمح بإرسال الطلب
    }

    if (!ensureOnline()) return; // إرسال طلب السائق يحتاج إنترنت

    isRequesting.value = true;
    try {
      // نبني DilevreModel من بيانات المستخدم فقط؛ باقي الحقول افتراضية.
      // الـ Repository هو من يفرض driverStatus = pending (قاعدة عمل).
      await _userRepository.requestDriverAccess(
        DilevreModel(userModel: user, driverStatus: DriverStatus.pending),
      );
      // driverStatus.value = DriverStatus.pending;
      // لا نغيّر driverStatus يدويًا هنا!
      // الـ Stream سيصل تلقائيًا بالقيمة pending من Firebase.
      Snakbar.showMassge('driver_request_sent'.tr, '', AppColors.success);
    } catch (e) {
      // نعرض الرسالة الحقيقية (AppException) بدل رسالة عامة تخفي السبب
      Snakbar.showMassge(e.toString(), '', AppColors.error);
    } finally {
      // finally ينفَّذ دائمًا (نجح أو فشل): نعيد الزر إلى حالته
      isRequesting.value = false;
    }
  }
}
// import 'package:get/get.dart';
// import 'package:wassalni/core/Extenstion/snakbar.dart';
// import 'package:wassalni/core/enum/app_mode.dart';
// import 'package:wassalni/core/enum/user_role.dart';
// import 'package:wassalni/core/theme/Appcolors.dart';
// import 'package:wassalni/data/models/Users/dilevre_model.dart';
// import 'package:wassalni/data/repositories/abstractInterface/users/user_intreface.dart';
// import 'package:wassalni/modules/auth/controllers/AuthController.dart';

// class ModeController extends GetxController {
//   ModeController(this._auth, this._userRepository);

//   final Authcontroller _auth;
//   final UserRepository _userRepository;

//   UserRole? get mode => _auth.currentUser.value?.role;
//   final driverStatus = _auth.currentUserDilevere.value.driverStatus;
//   final tabIndex = 0.obs;
//   final isRequesting = false.obs;

//   StreamSubscription<DriverStatus>? _statusSub;
//   Worker? _userWorker;

//   bool get canUseDriverMode => driverStatus.value == DriverStatus.approved;

//   @override
//   void onInit() {
//     super.onInit();
//     // كلما تغيّر المستخدم (دخول/خروج) نعيد الاشتراك
//     _userWorker = ever<DilevreModel?>(
//       _auth.currentUserDilevere,
//       _onUserChanged,
//     );
//     _onUserChanged(_auth.currentUserDilevere.value); // الحالة الحالية
//   }

//   void _onUserChanged(DilevreModel? user) {
//     _statusSub?.cancel();
//     _statusSub = null;

//     if (user == null) {
//       // تسجيل خروج: نعيد كل شيء للوضع الافتراضي
//       driverStatus.value = DriverStatus.none;
//       mode.value = AppMode.customer;
//       tabIndex.value = 0;
//       return;
//     }

//     _statusSub = _userRepository
//         .watchDriverStatus(user.userModel.id)
//         .listen(
//           (status) => bindUser(status: status),
//           onError: (_) =>
//               Snakbar.showMassge('connection_error'.tr, '', AppColors.error),
//         );
//   }

//   void bindUser({required DriverStatus status}) {
//     driverStatus.value = status;
//     if (!canUseDriverMode && mode.value == AppMode.driver) {
//       mode.value = AppMode.customer;
//     }
//   }

//   bool switchTo(AppMode target) {
//     if (target == mode.value) return true;
//     if (target == AppMode.driver && !canUseDriverMode) return false;
//     mode.value = target;
//     tabIndex.value = 0;
//     return true;
//   }

//   Future<void> requestDriverAccess() async {
//     final user = _auth.currentUser.value;
//     if (user == null) return;
//     if (driverStatus.value == DriverStatus.pending ||
//         driverStatus.value == DriverStatus.approved) {
//       return;
//     }

//     isRequesting.value = true;
//     try {
//       final dataDilevery = DilevreModel(userModel: _auth.currentUser.value!);
//       await _userRepository.requestDriverAccess(dataDilevery);
//       // لا نغيّر driverStatus يدوياً: الـ Stream سيحدّثه من Firestore
//       Snakbar.showMassge('driver_request_sent'.tr, '', AppColors.success);
//     } catch (_) {
//       Snakbar.showMassge('request_failed'.tr, '', AppColors.error);
//     } finally {
//       isRequesting.value = false;
//     }
//   }

//   void selectTab(int i) => tabIndex.value = i;

//   @override
//   void onClose() {
//     _statusSub?.cancel();
//     _userWorker?.dispose();
//     super.onClose();
//   }
// }
