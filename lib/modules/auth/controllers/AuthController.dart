import 'package:flutter/widgets.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:get/utils.dart';
import 'package:wassalni/core/Extenstion/snakbar.dart';
import 'package:wassalni/core/enum/user_role.dart';
import 'package:wassalni/core/theme/Appcolors.dart';
import 'package:wassalni/data/models/customer_model.dart';
import 'package:wassalni/data/models/user_model.dart';
import 'package:wassalni/data/repositories/abstractInterface/users/Auth_intreface.dart';
import 'package:wassalni/data/repositories/abstractInterface/users/user_intreface.dart';

class Authcontroller extends GetxController {
  final UserRepository userContract;
  final Authuser auth;
  // مفتاح التحقق من صحة النموذج
  final formKey = GlobalKey<FormState>();
  final forgotPasswordFormKey = GlobalKey<FormState>();
  //
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final roleController = TextEditingController();
  final usernameController = TextEditingController();
  // متغيرات الحالة التفاعلية (Reactive)

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final isPasswordVisible = false.obs;
  final errorMessage = ''.obs;
  final isLogin = true.obs;
  final currentUser = Rxn<UserModel>();
  Authcontroller({required this.userContract, required this.auth});

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  // تسجيل الدخول
  Future<void> login(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await auth.signIn(email, password);
    } catch (e) {
      Snakbar.showMassge(
        e.toString(),
        "56".tr,
        Get.theme.colorScheme.error,
      ); //56:خطا
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// التبديل بين تسجيل الدخول وإنشاء الحساب
  void changeAuthMode(bool loginMode) {
    isLogin.value = loginMode;
    // إزالة أخطاء التحقق عند تغيير الوضع
    formKey.currentState?.reset();
  }

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = false;

      if (isLogin.value) {
        //   AuthController لتسجيل الدخول
        login(
          emailController.value.text
              .trim(), //fonction text.trim() لازالة المسفات
          passwordController.value.toString(),
        );
      } else {
        //   AuthController لإنشاء الحساب
        regester(
          username: usernameController.value.text.trim(),
          email: emailController.value.text.trim(),
          password: passwordController.value.toString(),
          phone: phoneController.value.text.trim(),
          role: roleController.value.text.trim(),
        );
      }
    }
  }

  /// تبديل حالة إظهار وإخفاء كلمة المرور
  void togglePasswordVisibility() {
    obscurePassword.toggle();

    // isPasswordVisible.value = !isPasswordVisible.value;
  }

  // تسجيل الخروج
  Future<void> logout() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await auth.signOut(); //اضافة بعض التحققات مثل اذكان طلب نشط لايمكن تسجيل الخروج او اتخاذ اجرائات اخر ى
    } catch (e) {
      Snakbar.showMassge(
        e.toString(),
        "56".tr,
        Get.theme.colorScheme.error,
      ); //56:خطا
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // استعادة كلمة المرور
  Future<void> resetPassword(String email) async {
    try {
      if (forgotPasswordFormKey.currentState!.validate()) {
        errorMessage.value = '';
        isLoading.value = true;
        await auth.resetPassword(email);
        //         "83": "تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني. يُرجى التحقق من صندوق الوارد.",
        // "84": "تم بنجاح",

        Get.back();
        Snakbar.showMassge('83'.tr, "82".tr, AppColors.success);
      }
    } catch (e) {
      Snakbar.showMassge(
        e.toString(),
        "56".tr,
        Get.theme.colorScheme.error,
      ); //56:خطا

      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  //  كلمة المرور تغيير
  Future<void> updatePassword(
    String email,
    String oldPassword,
    String newPassword,
  ) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await auth.updatePassword(email, oldPassword, newPassword);
    } catch (e) {
      Snakbar.showMassge(
        e.toString(),
        "56".tr,
        Get.theme.colorScheme.error,
      ); //56:خطا
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  //انشاء الحساب  وحفظ البينات
  Future<void> regester({
    required String username,
    required String email,
    required String password, //يكون فاريغ في فاير بايز  ,ونستعمله في حين استخذمنا قاعدة بينات اخرى
    required String phone,
    String? role, //يكون افتراضيا customer
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      // 1. Create account in Firebase Authentication تسجيل الدخول من خلال فايربيز بالاميل وكلمة المرور
      final uid = await auth.signUp(email, password);
      // print("المعرف: $uid");
      // 2. Create User Model
      if (uid != null) {
        final usermodel = UserModel(
          id: uid,
          username: username,
          email: email,
          role: UserRole.customer,
          phone: phone,
          dateCreate: DateTime.now(),
        );
        final user = CustomerModel(userModel: usermodel).toMap();
        //  Save User Model in Firestore Database
        await userContract.createUser(user);
      }
    } catch (e) {
      // "56".tr, ==حطا
      Snakbar.showMassge(
        e.toString(),
        "56".tr,
        Get.theme.colorScheme.error,
      ); //56:خطا
    } finally {
      isLoading.value = false;
    }
  }
}
