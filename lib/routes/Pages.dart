import 'package:get/get_navigation/get_navigation.dart';
import 'package:wassalni/modules/auth/views/secrins/AuthSecrin.dart';
import 'package:wassalni/modules/bindings/AuthBinding.dart';

class PagesRout {
  static const authsecrin = "/Authsecrin";
  static final pages = [
    
    GetPage(name: authsecrin, page: () => Authsecrin(), binding: AuthBinding()),
  ];
}
