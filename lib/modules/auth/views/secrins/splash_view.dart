import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wassalni/core/Extenstion/context_x.dart';
import 'package:wassalni/modules/auth/controllers/splashcontroler.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'TALIVO ',
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
