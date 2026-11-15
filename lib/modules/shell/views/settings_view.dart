import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wassalni/core/Extenstion/context_x.dart';
import 'package:wassalni/core/theme/Appcolors.dart';
import 'package:wassalni/modules/auth/controllers/AuthController.dart';
import 'package:wassalni/modules/shared/common_widgets.dart';
import 'package:wassalni/modules/shared/widgets/section_title.dart';
import 'package:wassalni/modules/shell/controllers/App_Settings.dart';

/// شاشة الإعدادات: الثيم واللغة وتسجيل الخروج
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Get.find<AppSettingsController>();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // الوضع الداكن
        AppCard(
          child: Obx(
            () => SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(Icons.dark_mode_outlined),
              title: Text('dark_mode'.tr),
              value: s.isDark,
              onChanged: (_) => s.toggleTheme(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // اللغة
        AppCard(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle('language'.tr, icon: Icons.language),
                const SizedBox(height: 10),
                SegmentedButton<String>(
                  segments: [
                    for (final c in AppSettingsController.supportedLanguages)
                      ButtonSegment(value: c, label: Text(c.toUpperCase())),
                  ],
                  selected: {s.languageCode.value},
                  onSelectionChanged: (v) => s.changeLanguage(v.first),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // تسجيل الخروج
        AppCard(
          onTap: Get.find<Authcontroller>().logout,
          child: Row(
            children: [
              const Icon(Icons.logout_rounded, color: AppColors.error),
              const SizedBox(width: 12),
              Text(
                'logout'.tr,
                style: context.text.titleMedium?.copyWith(color: AppColors.error),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
