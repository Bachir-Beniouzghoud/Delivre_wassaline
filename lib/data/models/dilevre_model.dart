// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:wassalni/data/models/user_model.dart';

class DilevreModel {
  UserModel? userModel;
  bool? isAvailable;
  String? vehicleType, vehicleNumber, activeOrderId, currentLocation, fcmToken;
  DilevreModel({
    this.userModel,
    this.vehicleType,
    this.vehicleNumber,
    this.activeOrderId,
    this.currentLocation,
    this.fcmToken,
    this.isAvailable,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userModel': userModel!.toMap(),
      'isAvailable': isAvailable,
      'fcmToken': fcmToken,
    };
  }

  factory DilevreModel.fromMap(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return DilevreModel();
    } else {
      return DilevreModel(
        userModel: UserModel.fromMap(json['userModel'] as Map<String, dynamic>),
        isAvailable: json['isAvailable'] as bool?,
        fcmToken: json['fcmToken'] as String?,
      );
    }
  }

  String toJson() => json.encode(toMap());

  factory DilevreModel.fromJson(String source) =>
      DilevreModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
