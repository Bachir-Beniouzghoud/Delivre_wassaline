import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wassalni/autheControlerTest.dart';
import 'package:wassalni/core/theme/Appcolors.dart';

class AuthScreen extends GetView<AuthScreenController> {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: _buildAuthCard(context),
          ),
        ),
      ),
    );
  }

  // =====================================================
  // Main Authentication Card
  // =====================================================

  Widget _buildAuthCard(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 390),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Form(
        key: controller.formKey,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildModeSelector(context),
            const SizedBox(height: 26),

            _buildHeader(context),

            const SizedBox(height: 26),

            _buildEmailField(context),

            const SizedBox(height: 18),

            _buildPasswordLabel(context),

            const SizedBox(height: 8),

            _buildPasswordField(context),

            const SizedBox(height: 24),

            _buildSubmitButton(context),

            const SizedBox(height: 24),

            _buildDivider(context),

            const SizedBox(height: 24),

            _buildQuickLoginTitle(context),

            const SizedBox(height: 12),

            _buildRoleButtons(context),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // Login / Register Selector
  // =====================================================

  Widget _buildModeSelector(BuildContext context) {
    return Obx(() {
      return Container(
        height: 46,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            _buildModeButton(
              context,
              title: 'auth.register'.tr,
              isActive: !controller.isLogin.value,
              onTap: () => controller.changeAuthMode(false),
            ),
            _buildModeButton(
              context,
              title: 'auth.login'.tr,
              isActive: controller.isLogin.value,
              onTap: () => controller.changeAuthMode(true),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildModeButton(
    BuildContext context, {
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: isActive
            ? Theme.of(context).scaffoldBackgroundColor
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =====================================================
  // Header
  // =====================================================

  Widget _buildHeader(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          Text(
            controller.isLogin.value
                ? 'auth.welcome'.tr
                : 'auth.create_account'.tr,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            controller.isLogin.value
                ? 'auth.login_description'.tr
                : 'auth.register_description'.tr,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(fontSize: 12),
          ),
        ],
      );
    });
  }

  // =====================================================
  // Email Field
  // =====================================================

  Widget _buildEmailField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel(context, 'auth.email'.tr),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.right,
          autofillHints: const [AutofillHints.email],
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13),
          decoration: InputDecoration(
            hintText: 'amine.customer@talivo.com',
            suffixIcon: const Icon(Icons.mail_outline_rounded),
          ),
          validator: controller.validateEmail,
        ),
      ],
    );
  }

  // =====================================================
  // Password Label
  // =====================================================

  Widget _buildPasswordLabel(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() {
          if (!controller.isLogin.value) {
            return const SizedBox.shrink();
          }

          return InkWell(
            onTap: controller.forgotPassword,
            child: Text(
              'auth.forgot_password'.tr,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12,
              ),
            ),
          );
        }),
        _buildFieldLabel(context, 'auth.password'.tr),
      ],
    );
  }

  // =====================================================
  // Password Field
  // =====================================================

  Widget _buildPasswordField(BuildContext context) {
    return Obx(() {
      return TextFormField(
        controller: controller.passwordController,
        obscureText: controller.obscurePassword.value,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.right,
        autofillHints: const [AutofillHints.password],
        style: Theme.of(context).textTheme.bodyMedium
            ?.copyWith(letterSpacing: 2),
        decoration: InputDecoration(
          hintText: '••••••••',
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
        ),
        validator: controller.validatePassword,
      );
    });
  }

  // =====================================================
  // Reusable Field Label
  // =====================================================

  Widget _buildFieldLabel(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 12),
    );
  }
  // =====================================================
  // Submit Button
  // =====================================================

  Widget _buildSubmitButton(BuildContext context) {
    return Obx(() {
      return SizedBox(
        height: 48,
        child: FilledButton(
          onPressed: controller.isLoading.value ? null : controller.submit,
          child: controller.isLoading.value
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.isLogin.value
                          ? 'auth.login'.tr
                          : 'auth.register'.tr,
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.arrow_back_rounded, size: 19),
                  ],
                ),
        ),
      );
    });
  }

  // =====================================================
  // Divider
  // =====================================================

  Widget _buildDivider(BuildContext context) {
    return Divider(
      color: Theme.of(context).dividerColor,
      thickness: 0.8,
      height: 1,
    );
  }

  // =====================================================
  // Quick Login Title
  // =====================================================

  Widget _buildQuickLoginTitle(BuildContext context) {
    return Text(
      'auth.demo_login'.tr,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium
          ?.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
    );
  }

  // =====================================================
  // Role Buttons
  // =====================================================

  Widget _buildRoleButtons(BuildContext context) {
    return Obx(() {
      return Row(
        children: [
          _buildRoleButton(context, title: 'Admin', role: 'admin'),
          const SizedBox(width: 8),
          _buildRoleButton(
            context,
            title: 'Livreur',
            role: 'driver',
            isBlue: true,
          ),
          const SizedBox(width: 8),
          _buildRoleButton(context, title: 'Client', role: 'customer'),
        ],
      );
    });
  }

  Widget _buildRoleButton(
    BuildContext context, {
    required String title,
    required String role,
    bool isBlue = false,
  }) {
    final isSelected = controller.selectedRole.value == role;

    return Expanded(
      child: SizedBox(
        height: 44,
        child: Material(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.18)
              : Theme.of(context).inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(13),
          child: InkWell(
            borderRadius: BorderRadius.circular(13),
            onTap: () => controller.selectRole(role),
            child: Center(
              child: Text(
                title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 11,
                  color: isBlue || isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
