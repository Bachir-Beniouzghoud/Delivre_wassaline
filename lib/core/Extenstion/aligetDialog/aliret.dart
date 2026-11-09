import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wassalni/core/Extenstion/aligetDialog/Controler.dart';
import 'package:wassalni/core/theme/Appcolors.dart';


class AppConfirmDialog extends StatelessWidget {
  final String title;
  final String message;

  final String confirmText;
  final String cancelText;

  final String? successMessage;

  final IconData icon;

  final bool isDestructive;

  final Future<void> Function()? onConfirm;

  final AppDialogController controller;

  const AppConfirmDialog({
    super.key,

    required this.controller,
    required this.title,
    required this.message,

    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',

    this.successMessage,

    this.icon = Icons.help_outline,

    this.isDestructive = false,

    this.onConfirm,
  });

  /// عرض النافذة من أي مكان في التطبيق
  static Future<bool?> show({
    required String title,
    required String message,

    String confirmText = 'Confirm',
    String cancelText = 'Cancel',

    String? successMessage,

    IconData icon = Icons.help_outline,

    bool isDestructive = false,

    Future<void> Function()? onConfirm,
  }) {
    // إنشاء Controller مستقل لكل نافذة
    final controller = AppDialogController();

    return Get.dialog<bool>(
      AppConfirmDialog(
        controller: controller,

        title: title,
        message: message,

        confirmText: confirmText,
        cancelText: cancelText,

        successMessage: successMessage,

        icon: icon,

        isDestructive: isDestructive,

        onConfirm: onConfirm,
      ),

      barrierDismissible: false,

      barrierColor: Colors.black.withValues(alpha: 0.55),

      transitionDuration: const Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ألوان الثيم الحالي
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // تحديد لون زر التأكيد
    final primaryColor = isDestructive ? AppColors.error : AppColors.primary;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,

      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),

        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),

          child: Container(
            padding: const EdgeInsets.all(24),

            decoration: BoxDecoration(
              color: colorScheme.surface,

              borderRadius: BorderRadius.circular(24),

              border: Border.all(color: AppColors.border, width: 1),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                // أيقونة النافذة
                _buildIcon(primaryColor),

                const SizedBox(height: 18),

                // عنوان النافذة
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge,
                ),

                const SizedBox(height: 10),

                // محتوى النافذة
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
                ),

                // عرض الخطأ عند حدوثه
                Obx(() {
                  if (controller.errorMessage.value.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 16),

                    child: Text(
                      controller.errorMessage.value,
                      textAlign: TextAlign.center,

                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 26),

                // أزرار العمليات
                Row(
                  children: [
                    // زر الإلغاء
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          if (controller.isLoading.value) return;

                          Get.back(result: false);
                        },

                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,

                          side: const BorderSide(color: AppColors.border),

                          padding: const EdgeInsets.symmetric(vertical: 14),

                          shape: const StadiumBorder(),
                        ),

                        child: Text(cancelText),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // زر التأكيد
                    Expanded(
                      child: Obx(() {
                        final loading = controller.isLoading.value;

                        return ElevatedButton(
                          onPressed: loading
                              ? null
                              : () async {
                                  final success = await controller.execute(
                                    onConfirm: onConfirm,
                                  );

                                  if (success) {
                                    // إغلاق النافذة وإرجاع النتيجة
                                    Get.back(result: true);

                                    // عرض رسالة النجاح إذا تم تحديدها
                                    if (successMessage != null) {
                                      Get.snackbar(
                                        title,
                                        successMessage!,
                                        snackPosition: SnackPosition.TOP,
                                        backgroundColor: AppColors.textPrimary,
                                        colorText: Colors.white,
                                        margin: const EdgeInsets.all(16),
                                        borderRadius: 14,
                                        duration: const Duration(seconds: 3),
                                      );
                                    }
                                  }
                                },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,

                            disabledBackgroundColor: primaryColor.withValues(
                              alpha: 0.5,
                            ),

                            elevation: 0,

                            padding: const EdgeInsets.symmetric(vertical: 14),

                            shape: const StadiumBorder(),
                          ),

                          child: loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  confirmText,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// تصميم أيقونة النافذة
  Widget _buildIcon(Color color) {
    return Container(
      width: 56,
      height: 56,

      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        shape: BoxShape.circle,

        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),

      child: Icon(icon, color: color, size: 27),
    );
  }
}
