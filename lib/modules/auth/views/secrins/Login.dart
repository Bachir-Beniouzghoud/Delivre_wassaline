import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:wassalni/modules/auth/controllers/AuthController.dart';
import 'package:wassalni/modules/auth/views/widgets/Widget_AuthePublic.dart';
import 'package:wassalni/modules/auth/views/widgets/Widget_login.dart';

class Login extends StatelessWidget {
  final Authcontroller controller;
  const Login({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisSize: MainAxisSize.min,
      children: [
        WidgetAuth(context: context).buildeContante("58".tr, "57".tr),
        const SizedBox(height: 28),
        // 3. حقل البريد الإلكتروني أو رقم الهاتف
        WidgetAuth(context: context).buildFieldLabel(theme, '59'.tr),
        const SizedBox(height: 8),
        WidgetAuth.buildField(
          controller,
          controller.emailController,
          TextInputType.emailAddress,
          Icon(Icons.email_outlined, size: 20),
        ),
        const SizedBox(height: 15),
        WidgetLogin().buildlablePassword(
          context,
          theme,
          controller: controller,
        ), //functin praivet
        // Password
        WidgetAuth.buildPasswordField(controller),
        SizedBox(height: 15),
        WidgetAuth.buildSubmitButton(context, controller, "62".tr),
      ],
    );
  }
}
