// import 'user_model.dart';

// class CustomerModel {
//   final UserModel userModel;
//   final String? activeOrderId;
//   final String? defaultAddressId;

//   const CustomerModel({
//     required this.userModel,
//     this.activeOrderId,
//     this.defaultAddressId,
//   });

//   String get userId => userModel.id;

//   /// يُخزَّن في customers/{userId}
//   Map<String, dynamic> toMap() => {
//     'userId': userId,
//     'activeOrderId': activeOrderId,
//     'defaultAddressId': defaultAddressId,
//   };

//   factory CustomerModel.fromMap(Map<String, dynamic> map, UserModel user) {
//     return CustomerModel(
//       userModel: user,
//       activeOrderId: map['activeOrderId'] as String?,
//       defaultAddressId: map['defaultAddressId'] as String?,
//     );
//   }

//   CustomerModel copyWith({String? activeOrderId, String? defaultAddressId}) {
//     return CustomerModel(
//       userModel: userModel,
//       activeOrderId: activeOrderId ?? this.activeOrderId,
//       defaultAddressId: defaultAddressId ?? this.defaultAddressId,
//     );
//   }
// }
