import 'package:get/state_manager.dart';
import 'package:wassalni/core/enum/user_role.dart';
import 'package:wassalni/data/models/customer_model.dart';
import 'package:wassalni/data/models/user_model.dart';
import 'package:wassalni/data/repositories/abstractIntraface/users/Auth.dart';
import 'package:wassalni/data/repositories/abstractIntraface/users/user_contract.dart';

class Authcontroller extends GetxController {
  final UserContract userContract;
  final Auth auth;
  Authcontroller({required this.userContract, required this.auth});
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  // تسجيل الدخول
  Future<void> login(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await auth.signIn(email, password);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // تسجيل الخروج
  Future<void> logout() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await auth.signOut(); //اضافة بعض التحققات مثل اذكان طلب نشط لايمكن تسجيل الخروج او اتخاذ اجرائات اخر ى
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // استعادة كلمة المرور
  Future<void> resetPassword(String email) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await auth.resetPassword(email);
    } catch (e) {
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
    required String role, //يكون افتراضيا customer
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
          role: UserRole.customer.toString(),
          phone: phone,
          dateCreate: DateTime.now().toIso8601String(),
        );
        final user = CustomerModel(userModel: usermodel).toMap();
        //  Save User Model in Firestore Database
        await userContract.createUser(user);
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}