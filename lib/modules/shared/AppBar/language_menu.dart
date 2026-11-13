import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/state_manager.dart';
import 'package:wassalni/core/Extenstion/context_x.dart';
import 'package:wassalni/modules/shell/controllers/App_Settings.dart';

/// قائمة اختيار اللغة (AR / FR / EN)
class LanguageMenu extends StatelessWidget {
  const LanguageMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Get.find<AppSettingsController>();
    return Obx(() {
      return PopupMenuButton<String>(
        tooltip: 'language'.tr,
        onSelected: s.changeLanguage,
        itemBuilder: (context) => [
          for (final code in AppSettingsController.supportedLanguages)
            PopupMenuItem(
              value: code,
              child: Row(
                children: [
                  Expanded(child: Text(code.toUpperCase())),
                  if (code == s.languageCode.value)
                    Icon(Icons.check, size: 18, color: context.cs.primary),
                ],
              ),
            ),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            children: [
              Text(
                s.languageCode.value.toUpperCase(),
                style: context.text.labelLarge,
              ),
              const SizedBox(width: 2),
              const Icon(Icons.language, size: 18),
            ],
          ),
        ),
      );
    });
  }
}
