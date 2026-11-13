import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wassalni/core/constounts/varaible.dart';

/// مسؤول عن إعدادات التطبيق العامة:
/// اللغة والثيم (Light / Dark / System)
class AppSettingsController extends GetxController {
  // ==============================
  // مفاتيح التخزين المحلي
  // ==============================

  static const String themeKey = 'app_theme';

  // ==============================
  // اللغات المدعومة
  // ==============================

  static const List<String> supportedLanguages = ['ar', 'en'];

  // ==============================
  // المتغيرات التفاعلية
  // ==============================

  /// اللغة الحالية
  final RxString languageCode = 'ar'.obs;

  /// وضع الثيم الحالي
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  // ==============================
  // Constructor
  // ==============================

  /// استقبال الإعدادات المحملة مسبقاً من main.dart
  AppSettingsController({
    required String initialLanguage,
    required ThemeMode initialThemeMode,
  }) {
    languageCode.value = initialLanguage;
    themeMode.value = initialThemeMode;
  }

  // ==============================
  // Getters
  // ==============================

  /// هل الوضع الحالي داكن؟
  bool get isDark {
    return themeMode.value == ThemeMode.dark ||
        (themeMode.value == ThemeMode.system &&
            WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark);
  }

  // ==============================
  // تغيير اللغة
  // ==============================

  /// تغيير لغة التطبيق وحفظها
  Future<void> changeLanguage(String code) async {
    // التأكد من أن اللغة مدعومة
    if (!supportedLanguages.contains(code)) {
      return;
    }

    // تحديث اللغة في Controller
    languageCode.value = code;

    // تحديث لغة واجهة التطبيق
    Get.updateLocale(Locale(code));

    // حفظ اللغة في الجهاز
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(Varaible.codelangouge, code);
  }

  // ==============================
  // تغيير الثيم
  // ==============================

  /// التبديل بين الوضع الفاتح والداكن
  Future<void> toggleTheme() async {
    // إذا كان داكناً ننتقل إلى الفاتح والعكس
    themeMode.value = isDark ? ThemeMode.light : ThemeMode.dark;

    // تطبيق الثيم الجديد
    Get.changeThemeMode(themeMode.value);

    // حفظ الاختيار
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      themeKey,
      themeMode.value == ThemeMode.dark ? 'dark' : 'light',
    );
  }

  // ==============================
  // إعادة الوضع إلى إعدادات النظام
  // ==============================

  /// اتباع ثيم الهاتف تلقائياً
  Future<void> useSystemTheme() async {
    themeMode.value = ThemeMode.system;

    Get.changeThemeMode(ThemeMode.system);

    final prefs = await SharedPreferences.getInstance();

    // حذف الاختيار المحفوظ ليعود التطبيق إلى إعداد النظام
    await prefs.remove(themeKey);
  }
}
