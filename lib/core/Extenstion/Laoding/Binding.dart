import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:wassalni/core/Extenstion/Laoding/contrllerLoding.dart';

class LoadingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppLoaderController>(() => AppLoaderController());
  }
}
