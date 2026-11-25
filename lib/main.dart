import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:wassalni/app.dart';
import 'package:wassalni/core/bootstrap/app_initializer.dart';
import 'package:wassalni/core/services/Networksirvises.dart';

/// نقطة الدخول: تهيئة ثم تشغيل (لا منطق آخر هنا)
Future<void> main() async {
  final config = await AppInitializer.init();
  await Get.putAsync(() => NetworkService().init(), permanent: true);
  runApp(MyApp(config: config));
}
