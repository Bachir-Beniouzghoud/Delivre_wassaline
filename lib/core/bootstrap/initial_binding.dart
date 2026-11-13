import 'package:get/get.dart';
import 'package:wassalni/core/bootstrap/app_config.dart';
import 'package:wassalni/modules/bindings/AuthBinding.dart';
import 'package:wassalni/modules/shell/controllers/App_Settings.dart';

/// ما يجب أن يكون جاهزاً قبل أي صفحة وقبل الحراس (Middleware)
class InitialBinding extends Bindings {
  InitialBinding(this.config);

  final AppConfig config;

  @override
  void dependencies() {
    // الإعدادات (لغة وثيم) تبقى طوال عمر التطبيق
    Get.lazyPut(
      () => AppSettingsController(
        initialLanguage: config.langCode,
        initialThemeMode: config.themeMode,
      ),
    );
    // المصادقة: الحارس وشاشة البداية يحتاجانها
    AuthBinding().dependencies();
  }
}
