import 'package:get/get.dart';
import 'package:wassalni/core/bootstrap/app_config.dart';
import 'package:wassalni/core/localization/Translations.dart';
import 'package:wassalni/data/repositories/abstractInterface/ordeds/getorder.dart';
import 'package:wassalni/data/repositories/abstractInterface/users/Auth_intreface.dart';
import 'package:wassalni/data/repositories/abstractInterface/users/user_intreface.dart';
import 'package:wassalni/data/repositories/implementations/firebase/Orders/getorder.dart';
import 'package:wassalni/data/repositories/implementations/firebase/users/auth_firebase.dart';
import 'package:wassalni/data/repositories/implementations/firebase/users/user_Data_firbase.dart';
import 'package:wassalni/modules/auth/controllers/AuthController.dart';
import 'package:wassalni/modules/shell/controllers/App_Settings.dart';

// /// ما يجب أن يبقى حياً طوال عمر التطبيق (قبل أي صفحة وقبل الحراس)
// ///
// /// permanent: true ضروري: أي كنترولر lazy ينشأ أثناء /splash يرتبط بهذا المسار
// /// ويُحذف عند offAllNamed، فيفقد AuthMiddleware قيمة currentUser.
class InitialBinding extends Bindings {
  InitialBinding(this.config);

  final AppConfig config;

@override
void dependencies() {
  // احذف async: لا يوجد await، وdependencies لا تنتظر async
  Get.lazyPut(() => LanguageController());

  // الـ Repositories (بنوع الواجهة)
  Get.put<Authuser>(AuthFirebase(), permanent: true);
  Get.put<UserRepository>(UserDataFirbase(), permanent: true);
  Get.put<OrderRepository>(GetorderFirbase(), permanent: true);

  Get.put(
    Authcontroller(
      auth: Get.find<Authuser>(),
      userContract: Get.find<UserRepository>(),
    ),
    permanent: true,
  );

  Get.put(
    AppSettingsController(
      initialLanguage: config.langCode,
      initialThemeMode: config.themeMode,
    ),
    permanent: true,
  );
}
}