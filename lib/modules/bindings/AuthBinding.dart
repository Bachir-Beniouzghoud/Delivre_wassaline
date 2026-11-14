import 'package:get/get.dart';
import 'package:wassalni/data/repositories/implementations/firebase/users/auth_firebase.dart';
import 'package:wassalni/data/repositories/implementations/firebase/users/user_Data_firbase.dart';
import 'package:wassalni/modules/auth/controllers/AuthController.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthFirebase());
    Get.lazyPut(() => UserDataFirbase());
    Get.lazyPut(
      () => Authcontroller(
        auth: Get.find<AuthFirebase>(),
        userContract: Get.find<UserDataFirbase>(),
      ),
      // fenix: true,
    );
  }
}
