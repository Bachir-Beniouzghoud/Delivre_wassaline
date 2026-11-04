
import 'user_model.dart';

class CustomerModel {
  UserModel userModel;
  String? activeOrderId;
  String? defaultAddressId;
  CustomerModel({
    required this.userModel,
    this.activeOrderId,
    this.defaultAddressId,
  });

  Map<String, dynamic> toMap() {
    return {
      'userModel': userModel.toMap(),
      'activeOrderId': activeOrderId,
      'defaultAddressId': defaultAddressId,
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> json) {
    return CustomerModel(
      userModel: UserModel.fromMap(
        Map<String, dynamic>.from(json['userModel'] ?? {}),
      ),
      activeOrderId: json['activeOrderId'] as String?,
      defaultAddressId: json['defaultAddressId'] as String?,
    );
  }
}
