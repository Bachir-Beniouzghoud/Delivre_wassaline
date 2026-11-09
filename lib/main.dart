import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wassalni/core/constounts/varaible.dart';
import 'package:wassalni/core/localization/Translations.dart';
import 'package:wassalni/core/theme/AppTheme.dart';
import 'package:wassalni/firebase_options.dart';
import 'package:wassalni/routes/Pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? langCode = prefs.getString(Varaible.codelangouge);
  Get.lazyPut(() => LanguageController());
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase Connected Successfully!');
    debugPrint('Firebase App: ${Firebase.app().name}');
  } catch (e) {
    debugPrint('Firebase Error: $e');
  }
  runApp(MyApp(langCode: langCode));
}

class MyApp extends StatelessWidget {
  final String? langCode;
  const MyApp({super.key, this.langCode});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: PagesRout.authsecrin,
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme,
      // themeMode: ThemeMode.system,
      translations: AppTranslations(),
      locale: langCode != null ? Locale(langCode!) : Get.deviceLocale,
      getPages: PagesRout.pages,
    );
  }
}
