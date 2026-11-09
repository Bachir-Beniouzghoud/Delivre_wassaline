import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:wassalni/core/theme/Appcolors.dart';
import 'package:wassalni/modules/auth/views/widgets/Widget_AuthePublic.dart';

class WidgetLogin {
  void Function()? onTap;
  WidgetLogin({this.onTap});
  Widget buildlablePassword(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        WidgetAuth(context: context).buildFieldLabel(theme, '63'.tr),
        TextButton(
          onPressed: () {
            onTap;
          },
          // Get.to page reset Password
          child: Text(
            "64".tr, //forget Password
            style: theme.textTheme.bodyLarge!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
