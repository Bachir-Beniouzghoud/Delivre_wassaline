import 'package:flutter/material.dart';
import 'package:wassalni/core/theme/Appcolors.dart';

/// اختصارات للثيم: بدل كتابة Theme.of(context) في كل مكان
/// وكلها تتبع الوضع الحالي (فاتح/داكن) تلقائياً
extension ContextX on BuildContext {
  /// الثيم الحالي
  ThemeData get theme => Theme.of(this);

  /// نظام ألوان Material 3
  ColorScheme get cs => theme.colorScheme;

  /// أنماط النصوص المعرّفة في AppTheme
  TextTheme get text => theme.textTheme;

  /// هل الوضع الحالي داكن؟
  bool get isDark => theme.brightness == Brightness.dark;

  /// لون خلفية البطاقات
  Color get cardColor => isDark ? AppColors.darkCard : AppColors.lightCard;

  /// لون حقول الإدخال والعناصر الخفيفة داخل البطاقة
  Color get inputColor => isDark ? AppColors.darkInput : AppColors.lightInput;

  /// لون الحدود
  Color get borderColor =>
      isDark ? AppColors.darkBorder : AppColors.lightBorder;

  /// لون النص الثانوي (العناوين الصغيرة والوصف)
  Color get mutedColor =>
      isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

  /// لون النص الأساسي
  Color get strongColor =>
      isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
}
