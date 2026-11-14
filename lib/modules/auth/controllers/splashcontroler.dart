import 'package:get/get.dart';
import 'package:wassalni/data/repositories/abstractInterface/users/Auth_intreface.dart';
import 'package:wassalni/modules/auth/controllers/AuthController.dart';
import 'package:wassalni/routes/app_routes.dart';

class SplashController extends GetxController {
  final Authuser auth;
  final Authcontroller authController;
  SplashController({required this.auth, required this.authController});

  @override
  void onReady() {
    super.onReady();
    checkSession();
  }

  Future<void> checkSession() async {
    // لا توجد جلسة مسجلة
    if (auth.currentUid == null) {
      Get.offAllNamed(AppRoutes.auth);
      return;
    }

    try {
      // نحمّل المستخدم داخل Authcontroller.currentUser لأن AuthMiddleware
      // يفحصه قبل السماح بفتح /shell (وإلا يردّنا دائماً إلى صفحة الدخول)
      await authController.loadCurrentUser();

      if (authController.currentUser.value == null) {
        await auth.signOut();
        Get.offAllNamed(AppRoutes.auth);
        return;
      }

      Get.offAllNamed(AppRoutes.shell);
    } catch (e) {
      await auth.signOut();
      authController.currentUser.value = null;
      Get.offAllNamed(AppRoutes.auth);
    }
  }
}
