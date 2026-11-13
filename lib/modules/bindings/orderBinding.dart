import 'package:get/get.dart';

import 'package:wassalni/data/repositories/implementations/firebase/Orders/getorder.dart';
import 'package:wassalni/modules/auth/controllers/AuthController.dart';
import 'package:wassalni/modules/orders/controllers/OrdersControler.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    Get.lazyPut<GetorderFirbase>(() => GetorderFirbase(), fenix: true);
    // Order Controller
    Get.lazyPut<OrderController>(
      () => OrderController(
        Get.find<GetorderFirbase>(),
        Get.find<Authcontroller>(),
      ),
    );
  }
}
