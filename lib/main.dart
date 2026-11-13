// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wassalni/core/constounts/varaible.dart';
// import 'package:wassalni/core/localization/Translations.dart';
// import 'package:wassalni/core/theme/AppTheme.dart';
// import 'package:wassalni/firebase_options.dart';
// import 'package:wassalni/routes/Pages.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   final String? langCode = prefs.getString(Varaible.codelangouge);
//   Get.lazyPut(() => LanguageController());
//   try {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//     debugPrint('Firebase Connected Successfully!');
//     debugPrint('Firebase App: ${Firebase.app().name}');
//   } catch (e) {
//     debugPrint('Firebase Error: $e');
//   }
//   runApp(MyApp(langCode: langCode));
// }

// class MyApp extends StatelessWidget {
//   final String? langCode;
//   const MyApp({super.key, this.langCode});
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       initialRoute: PagesRout.authsecrin,
//       theme: AppTheme.darkTheme,
//       // darkTheme: AppTheme.darkTheme,
//       // themeMode: ThemeMode.system,
//       translations: AppTranslations(),
//       locale: langCode != null ? Locale(langCode!) : Get.deviceLocale,
//       getPages: PagesRout.pages,
//     );
//   }
// }

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wassalni/core/constounts/varaible.dart';
import 'package:wassalni/core/localization/Translations.dart';
import 'package:wassalni/core/theme/AppTheme.dart';
import 'package:wassalni/firebase_options.dart';
import 'package:wassalni/modules/shell/controllers/App_Settings.dart';
import 'package:wassalni/routes/Pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. تهيئة Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    debugPrint('Firebase Connected Successfully!');
  } catch (e) {
    debugPrint('Firebase Error: $e');
  }

  // 2. قراءة الإعدادات المحفوظة
  final prefs = await SharedPreferences.getInstance();

  // استرجاع اللغة
  final savedLanguage = prefs.getString(Varaible.codelangouge);

  const supportedLanguages = ['ar', 'en'];

  final initialLanguage = supportedLanguages.contains(savedLanguage)
      ? savedLanguage!
      : 'ar';

  // استرجاع الثيم
  final savedTheme = prefs.getString('app_theme');

  final ThemeMode initialTheme;

  switch (savedTheme) {
    case 'light':
      initialTheme = ThemeMode.light;
      break;
    case 'dark':
      initialTheme = ThemeMode.dark;
      break;
    default:
      initialTheme = ThemeMode.system;
  }

  // 3. تشغيل التطبيق بالإعدادات الأولية
  runApp(MyApp(langCode: initialLanguage, themeMode: initialTheme));
}

class MyApp extends StatelessWidget {
  final String langCode;
  final ThemeMode themeMode;

  const MyApp({super.key, required this.langCode, required this.themeMode});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      // المسار الأول
      initialRoute: PagesRout.authsecrin,

      // الثيمات
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // الترجمة
      translations: AppTranslations(),
      locale: Locale(langCode),
      fallbackLocale: const Locale('en'),

      // المسارات
      getPages: PagesRout.pages,

      // تسجيل Controller مرة واحدة
      initialBinding: BindingsBuilder(() {
        Get.put(
          AppSettingsController(
            initialLanguage: langCode,
            initialThemeMode: themeMode,
          ),
          permanent: true,
        );
      }),
    );
  }
}
