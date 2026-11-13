import 'package:wassalni/data/models/Users/dilevre_model.dart';

abstract interface class UserRepository {
  Future<void> createUser(Map<String, dynamic> userData);
  Future<DilevreModel?> getUser(String userId);
  Future<void> updateUser(String userId, Map<String, dynamic> data);
  Future<void> deleteUser(String userId);
}
