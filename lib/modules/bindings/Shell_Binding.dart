// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wassalni/core/constounts/varaible.dart';
// import 'package:wassalni/modules/shell/controllers/App_Settings.dart';
// import 'package:wassalni/modules/shell/controllers/mode_controller.dart';

// /// تسجيل متحكمات الواجهة (يُستدعى مع OrderBinding وAuth)
// class ShellBinding extends Bindings {

//     late final String  initialLanguage ;
//   late final ThemeMode initialTheme;
//   Future<void> intlaseApp()async {

//   // 2. قراءة الإعدادات المحفوظة
//   final prefs = await SharedPreferences.getInstance();
// final  List<String> supportedLanguages = ['ar', 'en'];
//   // استرجاع اللغة
//   final savedLanguage = prefs.getString(Varaible.codelangouge);

//    initialLanguage = supportedLanguages.contains(savedLanguage)
//       ? savedLanguage!
//       : 'ar';

//   // استرجاع الثيم
//   final savedTheme = prefs.getString('app_theme');

//   switch (savedTheme) {
//     case 'light':
//       initialTheme = ThemeMode.light;
//       break;
//     case 'dark':
//       initialTheme = ThemeMode.dark;
//       break;
//     default:
//       initialTheme = ThemeMode.system;
//   }
//   }
//   @override
//   void dependencies()async {
//     await intlaseApp();
//     Get.put(
//       AppSettingsController(
//         initialLanguage:initialLanguage,
//         initialThemeMode: initialTheme,
//       ),
//       permanent: true,
//     );
//     Get.put(ModeController(), permanent: true);
//   }
// }
import 'package:get/get.dart';
import 'package:wassalni/modules/shell/controllers/mode_controller.dart';

/// متحكمات الهيكل الرئيسي (وضع زبون/سائق)
/// AppSettingsController مسجّل في InitialBinding لأنه يحتاج قيماً من main
class ShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ModeController(), permanent: true);
  }
}
