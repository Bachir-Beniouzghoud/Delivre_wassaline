import 'package:wassalni/core/enum/orderstatus.dart';
import 'package:wassalni/core/enum/user_role.dart';
import 'package:wassalni/data/models/order/ordermodel.dart';

abstract interface class OrderRepository {
  // Future<Map<String, dynamic>> myorder(String uid);
  Future<void> createOrder(OrderModel data); // Craite order in coustomer

  Future<List<OrderModel>> getOrderBystatus({
    required String userUid,
    required UserRole role,
    required OrderStatus statusorder,
  });
  Future<void> acceptOrder(String orderUid, String driverUid);
  // دالة عامة (للاستعمال الداخلي فقط)
  Future<void> updateOrderStatus({
    required String orderUid,
    required String userUid,
    required UserRole role,
    required OrderStatus next,
  });

  Stream<List<OrderModel>> watchAvailableOrders({
    required String city,
    required double driverLat,
    required double driverLng,
    double radiusKm = 5,
  });
}
