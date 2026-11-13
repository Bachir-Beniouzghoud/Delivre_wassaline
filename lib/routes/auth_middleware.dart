import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wassalni/modules/auth/controllers/AuthController.dart';
import 'package:wassalni/routes/app_routes.dart';

/// يمنع فتح الصفحات المحمية قبل تسجيل الدخول
/// (حماية للواجهة فقط، والحماية الحقيقية في Firestore Rules)
class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final loggedIn = Get.find<Authcontroller>().currentUser.value != null;
    // غير مسجّل: صفحة الدخول، وإلا null أي مسموح
    return loggedIn ? null : const RouteSettings(name: AppRoutes.auth);
  }
}
