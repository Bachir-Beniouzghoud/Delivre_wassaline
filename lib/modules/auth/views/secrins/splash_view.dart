import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wassalni/core/Extenstion/context_x.dart';
import 'package:wassalni/modules/auth/controllers/AuthController.dart';

/// شاشة البداية: تعرض الشعار وتفحص الجلسة مرة واحدة
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    // بعد أول إطار: التنقل أثناء البناء يسبب خطأ
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<Authcontroller>().checkSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'TALIVO',
              style: context.text.displayMedium?.copyWith(
                color: context.cs.primary,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
