import 'package:get/state_manager.dart';
import 'package:wassalni/data/models/user_model.dart';
import 'package:wassalni/data/repositories/contracts/users/Auth.dart';
import 'package:wassalni/data/repositories/contracts/users/user_contract.dart';

class Authcontroller extends GetxController {
  final UserContract userContract;
  final Auth auth;
  Authcontroller({required this.userContract, required this.auth});
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  Future<void> regester({
    required String username,
    required String email,
    required String password, //يكون فاريغ في فاير بايز  ,ونستعمله في حين استخذمنا قاعدة بينات اخرى
    required String phone,
    required String role,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      // 1. Create account in Firebase Authentication تسجيل الدخول من خلال فايربيز بالاميل وكلمة المرور
      final uid = await auth.signUp(email, password);
      // print("المعرف: $uid");
      // 2. Create User Model
      if (uid != null) {
        final user = UserModel(
          id: uid,
          username: username,
          email: email,
          phone: phone,
          dateCreate: DateTime.now().toIso8601String(),
        ).toMap();
        print("Map**********");
        print(user);
        //  Save User Model in Firestore Database
        await userContract.createUser(user);
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
}
