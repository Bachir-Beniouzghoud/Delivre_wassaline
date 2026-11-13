import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:wassalni/core/Extenstion/context_x.dart';
import 'package:wassalni/modules/shell/controllers/App_Settings.dart';

class TalivoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TalivoAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<AppSettingsController>();
    return AppBar(
      // الشعار
      title: Text(
        'app_name'.tr,
        style: context.text.headlineMedium?.copyWith(
          color: context.cs.primary,
          letterSpacing: 1,
        ),
      ),
      actions: [  
// const _ModeSwitcher(),
        // const _LanguageMenu(),
        // زر الثيم: Obx لأن الأيقونة تتغير مع الحالة

      ],
    );
    
  }
}
