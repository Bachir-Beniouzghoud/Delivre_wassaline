import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:wassalni/core/Extenstion/context_x.dart';
import 'package:wassalni/core/enum/app_mode.dart';
import 'package:wassalni/core/theme/Appcolors.dart';
import 'package:wassalni/modules/shell/controllers/mode_controller.dart';

/// قائمة تبديل الوضع: زبون / سائق (السائق مقفل حتى موافقة الإدارة)
class ModeSwitcher extends StatelessWidget {
  const ModeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ModeController>();
    return Obx(() {
      final current = c.mode.value;
      final locked = c.canUseDriverMode;
      return PopupMenuButton<AppMode>(
        tooltip: 'mode_switch_title'.tr,

        onSelected: (target) {
          // إن رفض المتحكم التبديل (غير معتمد) نعرض نافذة الشرح
          if (!c.switchTo(target)) _showLockedDialog(context, c);
        },
        itemBuilder: (context) => [
          _item(
            context,
            AppMode.customer,
            'mode_customer'.tr,
            Icons.person_outline,
            current,
            false,
          ),
          _item(
            context,
            AppMode.driver,
            'mode_driver'.tr,
            Icons.delivery_dining_outlined,
            current,
            locked,
          ),
        ],
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: context.inputColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.borderColor),
          ),
          child: Row(
            children: [
              Icon(
                current == AppMode.driver
                    ? Icons.delivery_dining_outlined
                    : Icons.person_outline,
                size: 18,
                color: context.cs.primary,
              ),
              const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
            ],
          ),
        ),
      );
    });
  }
}

/// عنصر قائمة: الاسم + الأيقونة + قفل إن لم يكن متاحاً
PopupMenuItem<AppMode> _item(
  BuildContext context,
  AppMode value,
  String title,
  IconData icon,
  AppMode current,
  bool locked,
) {
  final selected = value == current;
  return PopupMenuItem<AppMode>(
    value: value,
    child: Row(
      children: [
        Icon(icon, size: 20, color: locked ? context.mutedColor : null),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
              color: locked ? context.mutedColor : null,
            ),
          ),
        ),
        if (locked) const Icon(Icons.lock_outline, size: 16),
        if (selected) Icon(Icons.check, size: 18, color: context.cs.primary),
      ],
    ),
  );
}
//************************ */
//************************ */
//************************ */

/// نافذة تشرح أن وضع السائق يحتاج موافقة الإدارة، مع زر الطلب
void _showLockedDialog(BuildContext context, ModeController c) {
  Get.dialog(
    Obx(() {
      final status = c.driverStatus.value;
      final pending = status == DriverStatus.pending;
      return AlertDialog(
        title: Text('driver_locked_title'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('driver_locked_body'.tr),
            if (pending) ...[
              const SizedBox(height: 12),
              Text(
                'driver_pending'.tr,
                style: const TextStyle(
                  color: AppColors.warning,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            if (status == DriverStatus.rejected) ...[
              const SizedBox(height: 12),
              Text(
                'driver_rejected'.tr,
                style: const TextStyle(color: AppColors.error),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(onPressed: Get.back, child: Text('close'.tr)),
          // لا نعرض زر الطلب إن كان قيد المراجعة
          if (!pending)
            SizedBox(
              width: 170,
              // child: LoadingButton(
              //   label: 'driver_request'.tr,
              //   isLoading: c.isRequesting.value,
              //   onPressed: () async {
              //     await c.requestDriverAccess();
              //   },
              // ),
            ),
        ],
      );
    }),
  );
}
