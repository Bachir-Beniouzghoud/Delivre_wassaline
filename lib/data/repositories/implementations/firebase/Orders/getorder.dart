import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wassalni/core/enum/orderstatus.dart';
import 'package:wassalni/core/enum/user_role.dart';
import 'package:wassalni/core/errors/firebase_exception_handler.dart';
import 'package:wassalni/core/errors/order_Exeption.dart';
import 'package:wassalni/data/models/order/ordermodel.dart';
import 'package:wassalni/data/repositories/abstractInterface/ordeds/getorder.dart';

class GetorderFirbase implements OrderRepository {
  final FirebaseFirestore _firestore;
  GetorderFirbase({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _orders =>
      _firestore.collection('orders');

  @override
  Future<void> createOrder(OrderModel orderData) async {
    try {
      final ref = _orders.doc(); // معرّف جديد، بلا كتابة بعد

      await ref
          .set({
            ...orderData.toMap(),
            'id': ref.id,
            'status': OrderStatus.pending.name,
            'driverId': null,
            'createdAt': FieldValue.serverTimestamp(),
          })
          .timeout(const Duration(seconds: 45));
    } on FirebaseException catch (e) {
      throw FirebaseErrorHandler.handle(e);
    }
  }

  @override
  Future<List<OrderModel>> getOrderBystatus({
    required String userUid,
    required UserRole role,
    required OrderStatus statusorder,
  }) async {
    try {
      final String field = switch (role) {
        UserRole.customer => 'customerId',
        UserRole.delivery => 'driverId',
        _ => throw ArgumentError('Role $role cannot have orders'),
      };
      Query<Map<String, dynamic>> query = _orders.where(
        field,
        isEqualTo: userUid,
      );
      query = query.where('status', isEqualTo: statusorder.name);
      final result = await query.orderBy('createdAt', descending: true).get();
      return result.docs
          .map((e) => OrderModel.fromMap(e.id, e.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw FirebaseErrorHandler.handle(e);
    }
  }

  //**************Accepet order  */
  @override
  Future<void> acceptOrder(String orderUid, String driverUid) async {
    final docRef = _orders.doc(orderUid);

    try {
      await _firestore.runTransaction((tx) async {
        final snap = await tx.get(docRef);
        if (!snap.exists) throw const OrderNotFoundException();

        final data = snap.data()!;

        // الطلب لم يعد متاحاً: قبله سائق آخر أو أُلغي
        if (data['status'] != OrderStatus.pending.name ||
            data['driverId'] != null) {
          throw const OrderAlreadyTakenException();
        }

        tx.update(docRef, {
          'driverId': driverUid,
          'status': OrderStatus.confirmed.name,
          'acceptedAt': FieldValue.serverTimestamp(),
        });
      });
    } on FirebaseException catch (e) {
      throw FirebaseErrorHandler.handle(e);
    }
  }

  //******************‘update order  */
  @override
  Future<void> updateOrderStatus({
    required String orderUid,
    required String userUid,
    required UserRole role,
    required OrderStatus next,
  }) async {
    final docRef = _orders.doc(orderUid);

    try {
      await _firestore.runTransaction((tx) async {
        final snap = await tx.get(docRef);
        if (!snap.exists) throw const OrderNotFoundException();

        final data = snap.data()!;

        // 1) الملكية: الحقل يتغير حسب الدور
        final ownerField = role == UserRole.customer
            ? 'customerId'
            : 'driverId';
        if (data[ownerField] != userUid) throw const NotOrderOwnerException();

        // 2) الانتقال والصلاحية
        final current = OrderStatus.values.byName(data['status']);
        if (!current.canChangeTo(next, role)) {
          throw InvalidStatusTransitionException(current, next);
        }

        tx.update(docRef, {
          'status': next.name,
          if (next == OrderStatus.cancelled)
            'cancelledAt': FieldValue.serverTimestamp(),
          if (next == OrderStatus.delivered)
            'deliveredAt': FieldValue.serverTimestamp(),
        });
      });
    } on FirebaseException catch (e) {
      throw FirebaseErrorHandler.handle(e);
    }
  }

  ///جلب الطلبات المتاحة
  @override
  Stream<List<OrderModel>> watchAvailableOrders({
    required String city,
    required double driverLat,
    required double driverLng,
    double radiusKm = 5,
  }) {
    return _orders
        .where('status', isEqualTo: OrderStatus.pending.name)
        .where('city', isEqualTo: city)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) {
          final orders = snap.docs
              .map((d) => OrderModel.fromMap(d.id, d.data()))
              .toList();

          ///حساب المسافة
          double distanceKm(OrderModel o) =>
              Geolocator.distanceBetween(
                driverLat,
                driverLng,
                o.pickup.lat,
                o.pickup.lng,
              ) /
              1000;
          // احذف الطلبات البعيدة = ابقِ القريبة

          // return orders.where((o) => distanceKm(o) <= radiusKm).toList()
          //   ..sort((a, b) => distanceKm(a).compareTo(distanceKm(b)));
          // 1) نبقي فقط الطلبات التي مسافتها ضمن نصف القطر
          final nearbyOrders = orders
              .where((o) => distanceKm(o) <= radiusKm)
              .toList();

          // نرتّبها من الأقرب إلى الأبعد
          nearbyOrders.sort((a, b) {
            final distanceA = distanceKm(a);
            final distanceB = distanceKm(b);
            return distanceA.compareTo(distanceB);
          });

          // ارجاع القائمة النهائية
          return nearbyOrders;
        });
  }
}
