import 'package:flutter/material.dart';

/// الإعدادات الأولية المقروءة قبل تشغيل الواجهة
class AppConfig {
  const AppConfig({required this.langCode, required this.themeMode});

  final String langCode;
  final ThemeMode themeMode;
}
