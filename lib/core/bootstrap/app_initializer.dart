import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wassalni/core/bootstrap/app_config.dart';
import 'package:wassalni/core/constounts/varaible.dart';
import 'package:wassalni/firebase_options.dart';

/// كل ما يجب إنجازه قبل runApp: Firebase ثم قراءة الإعدادات المحفوظة
abstract final class AppInitializer {
  /// اللغات المدعومة (أضف 'fr' عندما تكتمل ترجمتها في AppTranslations)
  static const supportedLanguages = ['ar', 'en'];

  /// مفتاح حفظ الثيم في SharedPreferences
  static const _themeKey = 'app_theme';
      
  static Future<AppConfig> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _initFirebase();
    final prefs = await SharedPreferences.getInstance();
    return AppConfig(
      langCode: _readLanguage(prefs),
      themeMode: _readTheme(prefs),
    );
  }

  /// تهيئة Firebase (الفشل يُطبع فقط ولا يوقف التطبيق)
  static Future<void> _initFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint('Firebase Connected Successfully!');
    } catch (e) {
      debugPrint('Firebase Error: $e');
    }
  }

  /// اللغة المحفوظة إن كانت مدعومة، وإلا العربية
  static String _readLanguage(SharedPreferences prefs) {
    final saved = prefs.getString(Varaible.codelangouge);
    return supportedLanguages.contains(saved) ? saved! : 'ar';
  }
   
  /// الثيم المحفوظ، وإلا ثيم النظام
  static ThemeMode _readTheme(SharedPreferences prefs) {
    return switch (prefs.getString(_themeKey)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}
