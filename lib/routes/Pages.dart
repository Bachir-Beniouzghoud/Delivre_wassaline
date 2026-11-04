import 'package:get/get_navigation/get_navigation.dart';
import 'package:wassalni/HomeTastePage.dart';
import 'package:wassalni/modules/auth/bindings/binding.dart';

class PagesRout {
  static const homeTest = "/HomeTest";
  static final pages = [
    GetPage(
      name: homeTest,
      page: () => Hometastepage(),
      binding: AuthBinding(),
    ),
  ];
}
