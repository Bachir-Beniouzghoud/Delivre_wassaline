import 'package:get/get.dart';
import 'package:wassalni/data/repositories/abstractInterface/users/Auth_intreface.dart';
import 'package:wassalni/modules/auth/controllers/AuthController.dart';
import 'package:wassalni/modules/auth/controllers/splashcontroler.dart';

// class SplashBinding extends Bindings {
//   @override
//   void dependencies() {
//     // Get.put وليس lazyPut: شاشة البداية لا تقرأ `controller` في build،
//     // وlazyPut لا يُنشئ الكنترولر إلا عند أول find، فلا تعمل onReady أبداً.
//     Get.put<SplashController>(
//       SplashController(
//         auth: Get.find<AuthFirebase>(),
//         authController: Get.find<Authcontroller>(),
//       ),
//     );
//   }
// }
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(
      SplashController(
        auth: Get.find<Authuser>(),              // كان AuthFirebase
        authController: Get.find<Authcontroller>(),
      ),
    );
  }
}