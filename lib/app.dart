import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wassalni/core/bootstrap/app_config.dart';
import 'package:wassalni/core/bootstrap/initial_binding.dart';
import 'package:wassalni/core/localization/Translations.dart';
import 'package:wassalni/core/theme/AppTheme.dart';
import 'package:wassalni/routes/Pages.dart';

/// جذر التطبيق: الثيمان والترجمة والمسارات فقط
class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.config});

  final AppConfig config;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      // الثيمان (الفاتح والداكن) والوضع المحفوظ
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: config.themeMode,

      // الترجمة
      translations: AppTranslations(),
      locale: Locale(config.langCode),
      fallbackLocale: const Locale('en'),

      // المسارات: تبدأ بشاشة البداية التي تفحص الجلسة
      initialRoute: AppPages.initial,
      getPages: AppPages.pages,
      initialBinding: InitialBinding(config),
    );
  }
}
