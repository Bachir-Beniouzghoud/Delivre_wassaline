import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/state_manager.dart';
import 'package:wassalni/core/Extenstion/Laoding/lading.dart';
import 'package:wassalni/core/constounts/function.dart';
import 'package:wassalni/core/constounts/varaible.dart';
import 'package:wassalni/core/localization/Translations.dart';
import 'package:wassalni/core/theme/Appcolors.dart';
import 'package:wassalni/modules/auth/controllers/AuthController.dart';

class WidgetAuth {
  final BuildContext? context;
  WidgetAuth({this.context});
  ThemeData get theme => Theme.of(context!);
  bool get isDark => theme.brightness == Brightness.dark;
  //************************  buildHeaderLogo***************************************
  /// بناء شعار TALIVO العلوي كما في التصميم
  Widget buildHeaderLogo(ThemeData theme) {
    // final isDark = theme.brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ///chainge langouge
        TextButton(
          onPressed: () async {
            if (Get.locale?.languageCode == 'ar') {
              await Get.find<LanguageController>().changeLanguage('en');
            } else {
              await Get.find<LanguageController>().changeLanguage('ar');
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.language,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
                size: 28,
              ),
              SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '60'.tr, //english //العربية
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 85),

        Expanded(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  Varaible.nameApp,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: Varaible.tajawalBold,
                    fontSize: 30,
                    color: AppColors.primary,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                // TTTTTTTTTTTT
                child: Padding(
                  padding: const EdgeInsets.only(top: 6.3),
                  child: Center(
                    child: Text(
                      "T",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //********************buildModeSelector **************** */
  //********************buildModeSelector **************** */
  //********************buildModeSelector **************** */
  Widget buildModeSelector(BuildContext context, Authcontroller controller) {
    return Obx(() {
      return Container(
        height: 60,
        width: double.infinity,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(bottom: 20),

        decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // سجل الدخول
            _buildModeButton(
              context,
              title: '62'.tr,
              isActive: controller.isLogin.value,
              isDark: isDark,
              onTap: () => controller.changeAuthMode(true),
            ),
            // إنشاء حساب جديد
            _buildModeButton(
              context,
              title: '61'.tr,
              isActive: !controller.isLogin.value,
              isDark: isDark,
              onTap: () => controller.changeAuthMode(false),
            ),
          ],
        ),
      );
    });
  }

  /// عنوان صغير فوق كل حقل إدخال
  Widget buildFieldLabel(ThemeData theme, String label) {
    return Text(
      label,
      style: theme.textTheme.labelLarge!.copyWith(fontSize: 18),
    );
  }

  Widget _buildModeButton(
    BuildContext context, {
    required String title,
    required bool isActive,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          // // padding: const EdgeInsets.all(4),
          decoration: isActive
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: !isDark ? AppColors.lightCard : AppColors.darkCard,
                  border: BoxBorder.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                )
              : BoxDecoration(),
          child: Center(
            child: Text(
              title,
              style: theme.textTheme.bodyLarge!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isActive
                    ? AppColors.primary
                    : (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextPrimary),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ________________________________________________________________________________
  //  ************************Build filde  *****************************
  // __________________________________________________________________________
  static Widget buildField(
    Authcontroller controller,
    TextEditingController textEditingController,
    TextInputType keyboardType,
    Icon icon, {
    bool? isUsernaname,
  }) {
    return TextFormField(
      controller: textEditingController,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: keyboardType == TextInputType.emailAddress
            ? 'exmple@gmail.com'
            : "",
        prefixIcon: icon,
      ),
      validator: (value) {
        // ************username******************
        if (keyboardType == TextInputType.name) {
          return Functionstatic.validateusername(value);
        }
        // ***************emailAddress***************
        if (keyboardType == TextInputType.emailAddress) {
          return Functionstatic.validteEmail(value);
        }
        //*****************************phone */
        if (TextInputType.phone == keyboardType) {
          return Functionstatic.validateAlgerianPhone(value);
        }
        return null;
      },
    );
  }

  // ________________________________________________________________________________
  //  ************************Password *****************************
  // ________________________________________________________________________________
  static Widget buildPasswordField(Authcontroller controller) {
    return Obx(
      () => TextFormField(
        controller: controller.passwordController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        obscureText: controller.obscurePassword.value,

        decoration: InputDecoration(
          suffixIcon: IconButton(
            tooltip: controller.obscurePassword.value
                ? 'auth.show_password'.tr
                : 'auth.hide_password'.tr,
            onPressed: controller.togglePasswordVisibility,
            icon: Icon(
              controller.obscurePassword.value
                  ? Icons.lock_outline_rounded
                  : Icons.lock_open_outlined,
            ),
          ),
          hintText: '***********',
          prefixIcon: Icon(Icons.password_sharp, size: 20),
        ),
        validator: (pasword) {
          if (controller.isLogin.value) {
            if (pasword!.isEmpty) {
              return "66".tr; //'Password is required'
            }
            if (pasword.length < 8) {
              return "68".tr; //'Password must be at least 8 characters'
            }
            return null;
          }
          return Functionstatic.validatePassword(pasword);
        },
      ),
    );
  }

  static Widget buildDivider(BuildContext context) {
    return Divider(
      color: Theme.of(context).dividerColor,
      thickness: 0.8,
      height: 1,
    );
  }

  static Widget buildSubmitButton(
    BuildContext context,
    Authcontroller controller,
    String titel,
  ) {
    return Center(
      child: SizedBox(
        height: 55,
        width: 250,
        child: FilledButton(
          onPressed: (controller.submit),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.arrow_back_rounded, size: 30),
                const SizedBox(width: 15),
                Text(
                  titel,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildeContante(String titel, String subtitel) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            titel,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineLarge,
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            subtitel,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ),
      ],
    );
  }

  //****************************** */
  //****************************** */
  //****************************** */
  //****************************** */

  static Future<void> showForgotPasswordDialog(
    Authcontroller controller,
  ) async {
    // controller.formKey.currentState?.reset();
    return Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Builder(
          builder: (context) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Form(
                key: controller.forgotPasswordFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.mark_email_unread_rounded,
                        color: AppColors.primary,
                        size: 32,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "82".tr,
                      //   'استعادة كلمة المرور'
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "81".tr,
                      // 'أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة تعيين كلمة المرور.'
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),

                    buildField(
                      controller,
                      controller.emailController,
                      TextInputType.emailAddress,
                      const Icon(Icons.email, size: 20),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Obx(
                            () => ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () {
                                      controller.resetPassword(
                                        controller.emailController.text.trim(),
                                      );
                                      // }
                                    },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.white,
                                disabledBackgroundColor: AppColors.primary
                                    .withValues(alpha: 0.5),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                              child: controller.isLoading.value
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: AppLoader(
                                        size: 20,
                                        showBrand: false,
                                        strokeWidth: 3,
                                        showLabel: false,
                                      ),
                                    )
                                  : Text(
                                      "79".tr, //'إرسال الرابط
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          flex: 2,
                          child: TextButton(
                            onPressed: () {
                              Get.back();
                              controller.formKey.currentState?.reset();
                              controller.formKey.currentState?.reset();
                            },
                            child: Text("80".tr), //'إلغاء'
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      barrierDismissible: false,
    );
  }
}
