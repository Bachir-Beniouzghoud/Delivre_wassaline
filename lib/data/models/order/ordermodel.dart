import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wassalni/core/enum/orderstatus.dart';
import 'package:wassalni/data/models/order/orderLocation.dart';

class OrderModel {
  final String uid; // معرّف المستند في Firestore
  final String code; // مثل TLV-84920
  final String customerId;
  final String? driverId; // null حتى يقبل سائق الطلب
  final OrderLocation pickup; // موقع الانطلاق 
  final OrderLocation dropoff;//موقع الوصل 
  final double price; // بالدينار الجزائري
  final OrderStatus status;
  // final OrderSource source;
  final DateTime createdAt;

  const OrderModel({
    required this.uid,
    required this.code,
    required this.customerId,
    this.driverId,
    required this.pickup,
    required this.dropoff,
    required this.price,
    this.status = OrderStatus.pending,
    // this.source = OrderSource.app,
    required this.createdAt,
  });

  factory OrderModel.fromMap(String uid, Map<String, dynamic> map) {
    return OrderModel(
      uid: uid,
      code: map['code'] as String,
      customerId: map['customerId'] as String,
      driverId: map['driverId'] as String?,
      pickup: OrderLocation.fromMap(map['pickup']),
      dropoff: OrderLocation.fromMap(map['dropoff']),
      price: (map['price'] as num).toDouble(),
      status: OrderStatus.values.byName(map['status']),
      // source: OrderSource.values.byName(map['source'] ?? 'app'),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    'code': code,
    'customerId': customerId,
    'driverId': driverId,
    'pickup': pickup.toMap(),
    'dropoff': dropoff.toMap(),
    'price': price,
    'status': status.name,
    // 'source': source.name,
    'createdAt': Timestamp.fromDate(createdAt),
  };
  OrderModel copyWith({String? driverId, OrderStatus? status, double? price}) {
    return OrderModel(
      uid: uid,
      code: code,
      customerId: customerId,
      driverId: driverId ?? this.driverId,
      pickup: pickup,
      dropoff: dropoff,
      price: price ?? this.price,
      status: status ?? this.status,
      // source: source,
      createdAt: createdAt,
    );
  }
}
