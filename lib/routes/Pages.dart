// import 'package:get/get_navigation/get_navigation.dart';
// import 'package:wassalni/modules/auth/views/secrins/AuthSecrin.dart';
// import 'package:wassalni/modules/bindings/AuthBinding.dart';
// import 'package:wassalni/routes/app_routes.dart';

// class AppPages {
//   static const initial = AppRoutes.shell;

//   static const authsecrin = "/Authsecrin";

//   /// الهيكل الرئيسي (الشريط العلوي والسفلي) لوضعي الزبون والسائق
//   static const shell = '/shell';
//   static final pages = [
//     GetPage(name: authsecrin, page: () => Authsecrin(), binding: AuthBinding()),
//   ];
// }
import 'package:get/get.dart';
import 'package:wassalni/modules/auth/views/secrins/AuthSecrin.dart';
import 'package:wassalni/modules/auth/views/secrins/splash_view.dart';
import 'package:wassalni/modules/bindings/AuthBinding.dart';
import 'package:wassalni/modules/bindings/Shell_Binding.dart';
import 'package:wassalni/modules/bindings/SplashBinding.dart';
import 'package:wassalni/modules/bindings/orderBinding.dart';

import 'package:wassalni/modules/shell/views/main_shell.dart';
import 'package:wassalni/routes/app_routes.dart';
import 'package:wassalni/routes/auth_middleware.dart';

/// جدول الصفحات: كل مسار مع صفحته وبنديه وحارسه
abstract final class AppPages {
  static const initial = AppRoutes.splash;
  static final pages = <GetPage>[
    // شاشة البداية (بلا حارس لأنها هي من تقرر)
    // GetPage(name: AppRoutes.splash, page: () => const SplashView()),
    // Jxs6qs58@32
    // bachirbenyouzghd1as2@gmail.com
    GetPage(
      name: AppRoutes.auth,
      page: () => Authsecrin(),
      binding: AuthBinding(),
    ),
    // شاشة البداية (بلا حارس لأنها هي من تقرر)
    GetPage(
      name: AppRoutes.splash,
      binding: SplashBinding(),
      page: () => const SplashView(),
    ),

    // الهيكل الرئيسي (محمي)
    GetPage(
      name: AppRoutes.shell,
      page: () => const MainShell(),
      bindings: [ShellBinding(), OrderBinding()],
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
  ];
}
