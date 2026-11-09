import 'package:flutter/material.dart';

/// ألوان الهوية البصرية لتطبيق TALIVO
abstract final class AppColors {
  // =========================================================
  // ألوان الهوية الأساسية
  // =========================================================

  /// Royal Blue - اللون الأساسي
  // static const Color primary = Color(0xFF0755D9);
  /// النجاح - Delivered

  static const Color success = Color(0xFF16A34A);

  /// درجة أفتح من الأزرق
  static const Color primaryLight = Color(0xFF2878F0);

  /// درجة أغمق من الأزرق
  static const Color primaryDark = Color(0xFF0642A8);

  /// اللون الثانوي البرتقالي
  static const Color secondary = Color(0xFFFF9500);

  /// درجة أفتح من البرتقالي
  static const Color secondaryLight = Color(0xFFFFAA33);

  /// الأبيض
  static const Color white = Color(0xFFFFFFFF);

  /// الأسود
  static const Color black = Color(0xFF000000);

  // =========================================================
  // ألوان الوضع الفاتح Light Theme
  // =========================================================

  static const Color lightBackground = Color(0xFFF5F7FC);

  static const Color lightSurface = Color(0xFFFFFFFF);

  static const Color lightCard = Color(0xFFFFFFFF);

  static const Color lightInput = Color(0xFFF1F4F9);

  static const Color lightTextPrimary = Color(0xFF172033);

  static const Color lightTextSecondary = Color(0xFF667085);

  static const Color lightBorder = Color(0xFFE3E8F0);

  static const Color lightDivider = Color(0xFFE9EDF4);

  // =========================================================
  // ألوان الوضع الداكن Dark Theme
  // =========================================================

  /// خلفية التطبيق الرئيسية - قريبة من تصميم Figma
  static const Color darkBackground = Color(0xFF020817);

  /// لون الأسطح العامة
  static const Color darkSurface = Color(0xFF0B1426);

  /// لون البطاقات
  static const Color darkCard = Color(0xFF111D33);

  /// لون حقول الإدخال
  static const Color darkInput = Color(0xFF1B2940);

  /// النص الأساسي
  static const Color darkTextPrimary = Color(0xFFFFFFFF);

  /// النص الثانوي
  static const Color darkTextSecondary = Color(0xFFA5B1C5);

  /// الحدود
  static const Color darkBorder = Color(0xFF293852);

  /// الفواصل
  static const Color darkDivider = Color(0xFF202D43);

  // =========================================================
  // الألوان الدلالية Semantic Colors
  // =========================================================

  /// النجاح - Delivered
  // static const Color success = Color(0xFF16A36A);

  /// الخطأ - Cancelled / Rejected
  static const Color error = Color(0xFFE5484D);

  /// التحذير - Pending
  static const Color warning = Color(0xFFFF9500);

  /// المعلومات - Confirmed
  static const Color info = Color(0xFF2583E8);

  // =========================================================
  // ألوان حالات الطلب
  // =========================================================

  static const Color pending = Color(0xFFFF9500);

  static const Color confirmed = Color(0xFF2583E8);

  static const Color inProgress = Color(0xFF8257E5);

  static const Color delivered = Color(0xFF16A36A);

  static const Color cancelled = Color(0xFFE5484D);

  static const Color rejected = Color(0xFFCF3540);
  static const Color primary = Color(0xFF2563EB);

  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);

  static const Color border = Color(0xFFE2E8F0);
  // static const Color error = Color(0xFFEF4444);
  // TALIVO Brand Identity
  // static const Color primary = Color(0xFF2563EB);
  static const Color brandAccent = Color(0xFF00F0FF);

  // Loader colors
  static const Color loaderGlow = Color(0xFF00F0FF);
  static const Color loaderDarkBackground = Color(0xFF0F172A);

  // // Text colors
  // static const Color textPrimary = Color(0xFF0F172A);
  // static const Color textSecondary = Color(0xFF64748B);

  // // Border
  // static const Color border = Color(0xFFE2E8F0);
}
