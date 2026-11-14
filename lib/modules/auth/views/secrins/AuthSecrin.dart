import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wassalni/core/Extenstion/Laoding/contrllerLoding.dart';
import 'package:wassalni/core/Extenstion/Laoding/lading.dart';
import 'package:wassalni/core/theme/Appcolors.dart';
import 'package:wassalni/modules/auth/controllers/AuthController.dart';
import 'package:wassalni/modules/auth/views/secrins/Login.dart';
import 'package:wassalni/modules/auth/views/secrins/SignIn.dart';
import 'package:wassalni/modules/auth/views/widgets/Widget_AuthePublic.dart';

class Authsecrin extends GetView<Authcontroller> {
  Authsecrin({super.key});
  final loaderController = Get.put(AppLoaderController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
            child: _buildAuthCard(context),
          ),
        ),
      ),
    );
  }

  //*******************Build Cared ************************************
  //*******************Build Cared ************************************
  //*******************Build Cared ************************************
  Widget _buildAuthCard(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: 390),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).cardTheme.color,
        // إطار مضيء خفيف
        border: Border.all(color: Theme.of(context).dividerColor, width: 1),
        // التوهج الضاوي (BoxShadow)
        boxShadow: [
          BoxShadow(
            color: AppColors.darkSurface.withValues(
              alpha: 0.25,
            ), // توهج خارجي أزرق سماوي
            blurRadius: 25,
            spreadRadius: 0,
            offset: const Offset(0, 0),
          ),
        ],
      ),

      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 26),
            // 1. الشعار (Logo) واسم التطبيق
            WidgetAuth(context: context).buildHeaderLogo(theme),
            const SizedBox(height: 26),
            Divider(thickness: 2, color: theme.dividerColor),
            const SizedBox(height: 26),
            WidgetAuth(context: context).buildModeSelector(context, controller),
            const SizedBox(height: 15),
            //حقول تسجيل الدخول
            Obx(() {
              if (controller.isLoading.value) {
                return AppLoader(
                  size: 80,
                  showBrand: false,
                  strokeWidth: 3,
                  showLabel: false,
                );
              }
              if (controller.isLogin.value) {
                return Login(controller: controller);
              } else {
                return Signin(controller: controller);
              }
              //  () => controller.isLogin.value
              //     ? Login(controller: controller)
              //     : ,
            }),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
