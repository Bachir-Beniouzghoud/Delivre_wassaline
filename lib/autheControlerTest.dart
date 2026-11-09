
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthScreenController extends GetxController {
  // =====================================================
  // Form & Text Controllers
  // =====================================================

  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // =====================================================
  // Reactive Variables
  // =====================================================

  /// true = تسجيل الدخول، false = إنشاء حساب
  final isLogin = true.obs;

  /// إظهار أو إخفاء كلمة المرور
  final obscurePassword = true.obs;

  /// حالة تحميل الزر
  final isLoading = false.obs;

  /// الدور المحدد للتسجيل التجريبي
  final selectedRole = RxnString();

  // =====================================================
  // Change Authentication Mode
  // =====================================================

  /// التبديل بين تسجيل الدخول وإنشاء الحساب
  void changeAuthMode(bool loginMode) {
    isLogin.value = loginMode;

    // إزالة أخطاء التحقق عند تغيير الوضع
    formKey.currentState?.reset();
  }

  // =====================================================
  // Password Visibility
  // =====================================================

  /// إظهار أو إخفاء كلمة المرور
  void togglePasswordVisibility() {
    obscurePassword.toggle();
  }

  // =====================================================
  // Email Validation
  // =====================================================

  /// التحقق من صحة البريد الإلكتروني
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'auth.email_required'.tr;
    }

    if (!GetUtils.isEmail(value.trim())) {
      return 'auth.email_invalid'.tr;
    }

    return null;
  }

  // =====================================================
  // Password Validation
  // =====================================================

  /// التحقق من كلمة المرور
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'auth.password_required'.tr;
    }

    if (value.length < 6) {
      return 'auth.password_short'.tr;
    }

    return null;
  }

  // =====================================================
  // Select Demo Role
  // =====================================================

  /// تحديد الدور التجريبي
  void selectRole(String role) {
    selectedRole.value = role;
  }

  // =====================================================
  // Submit Authentication
  // =====================================================

  /// تنفيذ تسجيل الدخول أو إنشاء الحساب
  Future<void> submit() async {
    // التحقق من صحة الحقول
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final email = emailController.text.trim();
      final password = passwordController.text;

      if (isLogin.value) {
        // اربط هنا AuthController لتسجيل الدخول
        debugPrint('Login: $email');
      } else {
        // اربط هنا AuthController لإنشاء الحساب
        debugPrint('Register: $email');
      }
    } catch (e) {
      debugPrint('Authentication error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // =====================================================
  // Forgot Password
  // =====================================================

  /// الانتقال إلى استعادة كلمة المرور
  void forgotPassword() {
    // اربط هنا شاشة استعادة كلمة المرور
  }

  // =====================================================
  // Lifecycle
  // =====================================================

  @override
  void onClose() {
    // التخلص من موارد الحقول عند إغلاق الشاشة
    emailController.dispose();
    passwordController.dispose();

    super.onClose();
  }
}
