import 'package:wassalni/core/enum/app_mode.dart';
import 'package:wassalni/data/models/Users/dilevre_model.dart';
import 'package:wassalni/data/models/Users/user_model.dart';

abstract interface class UserRepository {
  Future<void> createUser(UserModel userData);
  Future<UserModel?> getUser(String userId);
  Future<void> updateUser(String userId, Map<String, dynamic> data);
  Future<void> deleteUser(String userId);
  Future<void> requestDriverAccess(DilevreModel data); //طلب كا سائق
  Stream<DriverStatus> watchDriverStatus(
    String uid,
  ); //الاستماع لتغير الحالة في حالة تم الغاء او قبول له كاسئق في النظام

  Future<DilevreModel?> getDriver(String userId);
}
