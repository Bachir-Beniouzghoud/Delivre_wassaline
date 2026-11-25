import 'package:wassalni/core/enum/app_mode.dart';
import 'package:wassalni/data/models/Users/user_model.dart';

class DilevreModel {
  final UserModel userModel;
  final DriverStatus driverStatus;
  final String? vehicleType;
  final String? vehicleNumber;
  final bool isAvailable;
  final String? currentLocation;
  final String? fcmToken;
  final String? activeOrderId;

  const DilevreModel({
    required this.userModel,
    required this.driverStatus,
    this.vehicleType,
    this.vehicleNumber,
    this.isAvailable = false,
    this.currentLocation,
    this.fcmToken,
    this.activeOrderId,
  });

  String get userId => userModel.id;

  /// حقول السائق فقط (تُلحق بمستند المستخدم)
  Map<String, dynamic> toDriverMap() => {
    'driverStatus': driverStatus.name,
    'vehicleType': vehicleType,
    'vehicleNumber': vehicleNumber,
    'isAvailable': isAvailable,
    'currentLocation': currentLocation,
    'fcmToken': fcmToken,
    'activeOrderId': activeOrderId,
  };

  /// نفس المستند يحمل الهوية وحقول السائق
  factory DilevreModel.fromMap(Map<String, dynamic> map) {
    return DilevreModel(
      userModel: UserModel.fromMap(map),
      driverStatus: _parseStatus(map['driverStatus'] as String?),
      vehicleType: map['vehicleType'] as String?,
      vehicleNumber: map['vehicleNumber'] as String?,
      isAvailable: map['isAvailable'] as bool? ?? false,
      currentLocation: map['currentLocation'] as String?,
      fcmToken: map['fcmToken'] as String?,
      activeOrderId: map['activeOrderId'] as String?,
    );
  }

  static DriverStatus _parseStatus(String? raw) {
    final name = raw?.split('.').last;
    return DriverStatus.values.asNameMap()[name] ?? DriverStatus.none;
  }
}
