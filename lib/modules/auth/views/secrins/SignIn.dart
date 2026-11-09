import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:wassalni/modules/auth/controllers/AuthController.dart';
import 'package:wassalni/modules/auth/views/widgets/Widget_AuthePublic.dart';

class Signin extends StatelessWidget {
  final Authcontroller controller;

  const Signin({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      mainAxisSize: MainAxisSize.min,
      children: [
        // 2. العنوان الترحيبي والوصف
        WidgetAuth(context: context).buildeContante("71".tr, "72".tr),
        // "57".tr, // 'Sign in to continue your deliveries and manage shipments.',
        ///add translate
        //  "58".tr, // 'Welcome back'
        const SizedBox(height: 15),
        WidgetAuth().buildFieldLabel(theme, "75".tr),
        //*****************phone****************
        WidgetAuth.buildField(
          controller,
          controller.phoneController,
          TextInputType.phone,
          Icon(Icons.phone, size: 20),
        ),
        const SizedBox(height: 15),
        //************************* *
        ///email
        // 3.حقل البريد الإلكتروني أ
        WidgetAuth(context: context).buildFieldLabel(theme, '59'.tr),

        WidgetAuth.buildField(
          controller,
          controller.emailController,
          TextInputType.emailAddress,
          Icon(Icons.email_outlined, size: 20),
        ),
        const SizedBox(height: 15),
        //*****************usernme
        WidgetAuth().buildFieldLabel(theme, "76".tr),
        WidgetAuth.buildField(
          controller,
          controller.usernameController,
          TextInputType.name,
          Icon(Icons.person_2_outlined, size: 20),
        ),
        //************************** */
        const SizedBox(height: 15),
        //************************** */
        WidgetAuth().buildFieldLabel(theme, "63".tr),
        // Password
        WidgetAuth.buildPasswordField(controller),

        SizedBox(height: 15),
        WidgetAuth.buildSubmitButton(context, controller, "61".tr),
      ],
    );
  }
}
