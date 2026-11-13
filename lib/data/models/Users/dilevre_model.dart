import 'dart:convert';

import 'package:wassalni/data/models/Users/user_model.dart';

class DilevreModel {
  final UserModel userModel;

  final bool isAvailable; //true يعني ان السائق متاح لاستقبال الطلبات

  final String vehicleType;
  final String vehicleNumber;

  final String? currentLocation;
  final String? fcmToken;
  final String? activeOrderId; //true يعني ان السائق غير متاح لاستقبال الطلبات

  DilevreModel({
    required this.userModel,
    required this.vehicleType,
    required this.vehicleNumber,
    this.isAvailable = false,
    this.currentLocation,
    this.fcmToken,
    this.activeOrderId,
  });

  // تحويل Model إلى Map
  Map<String, dynamic> toMap() {
    return {
      'userModel': userModel.toMap(),
      'isAvailable': isAvailable,
      'vehicleType': vehicleType,
      'vehicleNumber': vehicleNumber,
      'currentLocation': currentLocation,
      'fcmToken': fcmToken,
      'activeOrderId': activeOrderId,
    };
  }

  // تحويل Map إلى Model
  factory DilevreModel.fromMap(Map<String, dynamic> map) {
    return DilevreModel(
      userModel: UserModel.fromMap(
        Map<String, dynamic>.from(map['userModel'] ?? {}),
      ),
      isAvailable: map['isAvailable'] as bool? ?? false,
      vehicleType: map['vehicleType'] as String? ?? '',
      vehicleNumber: map['vehicleNumber'] as String? ?? '',
      currentLocation: map['currentLocation'] as String?,
      fcmToken: map['fcmToken'] as String?,
      activeOrderId: map['activeOrderId'] as String?,
    );
  }

  // تحويل Model إلى JSON
  String toJson() => json.encode(toMap());

  // تحويل JSON إلى Model
  factory DilevreModel.fromJson(String source) {
    return DilevreModel.fromMap(json.decode(source) as Map<String, dynamic>);
  }
}
