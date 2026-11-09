import 'package:flutter/material.dart';
import 'package:wassalni/core/theme/Appcolors.dart';

/// الثيم الرئيسي لتطبيق TALIVO
abstract final class AppTheme {
  // =========================================================
  // الثيم الفاتح
  // =========================================================

  static ThemeData get lightTheme {
    return _buildTheme(isDark: false);
  }
  // =========================================================
  // الثيم الداكن
  // =========================================================

  static ThemeData get darkTheme {
    return _buildTheme(isDark: true);
  }

  // =========================================================
  // إنشاء الثيم المشترك
  // =========================================================

  static ThemeData _buildTheme({required bool isDark}) {
    final brightness = isDark ? Brightness.dark : Brightness.light;

    // تحديد الألوان حسب الوضع
    final background = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;

    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    final card = isDark ? AppColors.darkCard : AppColors.lightCard;

    final input = isDark ? AppColors.darkInput : AppColors.lightInput;

    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;

    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final divider = isDark ? AppColors.darkDivider : AppColors.lightDivider;

    // إعداد نظام الألوان الخاص بـ Material 3
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: brightness,
        ).copyWith(
          primary: AppColors.primary,
          onPrimary: AppColors.white,
          secondary: AppColors.secondary,
          onSecondary: AppColors.black,
          surface: surface,
          onSurface: textPrimary,
          error: AppColors.error,
          onError: AppColors.white,
          outline: border,
          primaryContainer: isDark
              ? const Color(0xFF15366D)
              : const Color(0xFFDCE9FF),
          onPrimaryContainer: isDark ? AppColors.white : AppColors.primaryDark,
          secondaryContainer: isDark
              ? const Color(0xFF50300B)
              : const Color(0xFFFFE8C7),
          onSecondaryContainer: isDark
              ? AppColors.secondaryLight
              : const Color(0xFF7A3D00),
        );

    return ThemeData(
      // =====================================================
      // الإعدادات العامة
      // =====================================================

      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,

      scaffoldBackgroundColor: background,

      fontFamily: 'Tajawal',

      visualDensity: VisualDensity.standard,

      // =====================================================
      // ألوان عامة
      // =====================================================
      primaryColor: AppColors.primary,
      dividerColor: divider,
      disabledColor: textSecondary.withValues(alpha: 0.45),

      // =====================================================
      // النصوص
      // =====================================================
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: textPrimary),
        bodyMedium: TextStyle(fontSize: 14, color: textSecondary),
        bodySmall: TextStyle(fontSize: 12, color: textSecondary),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),

      // =====================================================
      // AppBar
      // =====================================================
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          fontFamily: 'Tajawal',
        ),
        iconTheme: IconThemeData(color: textPrimary, size: 24),
      ),

      // =====================================================
      // Cards
      // =====================================================
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: border, width: 0.7),
        ),
      ),

      // =====================================================
      // Input Fields
      // =====================================================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: input,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        hintStyle: TextStyle(
          color: textSecondary,
          fontSize: 14,
          fontFamily: 'Tajawal',
        ),

        labelStyle: TextStyle(
          color: textSecondary,
          fontSize: 14,
          fontFamily: 'Tajawal',
        ),

        prefixIconColor: textSecondary,
        suffixIconColor: textSecondary,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),

        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border),
        ),
      ),

      // =====================================================
      // Filled Button - الزر الأساسي
      // =====================================================
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: isDark
              ? const Color(0xFF26354D)
              : const Color(0xFFD5DCE8),
          disabledForegroundColor: textSecondary,
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
      ),

      // =====================================================
      // Outlined Button - الزر الثانوي
      // =====================================================
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? AppColors.primaryLight : AppColors.primary,
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          side: BorderSide(
            color: isDark ? AppColors.primaryLight : AppColors.primary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
      ),

      // =====================================================
      // Text Button
      // =====================================================
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          minimumSize: const Size(48, 48),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'Tajawal',
          ),
        ),
      ),

      // =====================================================
      // Icons
      // =====================================================
      iconTheme: IconThemeData(color: textPrimary, size: 22),

      // =====================================================
      // Navigation Bar
      // =====================================================
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: AppColors.primary.withValues(
          alpha: isDark ? 0.25 : 0.12,
        ),
        elevation: 0,
        height: 70,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textPrimary,
            fontFamily: 'Tajawal',
          ),
        ),
      ),

      // =====================================================
      // Bottom Sheet
      // =====================================================
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: card,
        modalBackgroundColor: card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),

      // =====================================================
      // Dialog
      // =====================================================
      dialogTheme: DialogThemeData(
        backgroundColor: card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Tajawal',
        ),
        contentTextStyle: TextStyle(
          color: textSecondary,
          fontSize: 14,
          fontFamily: 'Tajawal',
        ),
      ),

      // =====================================================
      // SnackBar
      // =====================================================
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark
            ? const Color(0xFF26354D)
            : const Color(0xFF172033),
        contentTextStyle: const TextStyle(
          color: AppColors.white,
          fontFamily: 'Tajawal',
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // =====================================================
      // Progress Indicator
      // =====================================================
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: Color(0x332877F0),
      ),

      // =====================================================
      // Floating Action Button
      // =====================================================
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.black,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // =====================================================
      // Divider
      // =====================================================
      dividerTheme: DividerThemeData(color: divider, thickness: 1, space: 1),

      // =====================================================
      // Checkbox
      // =====================================================
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: const WidgetStatePropertyAll(AppColors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),

      // =====================================================
      // Text Selection
      // =====================================================
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionColor: Color(0x5578A8FF),
        selectionHandleColor: AppColors.primary,
      ),
    );
  }
}
