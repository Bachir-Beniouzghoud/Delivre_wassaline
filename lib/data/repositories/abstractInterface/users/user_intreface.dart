abstract interface class UserRepository {
  Future<void> createUser(Map<String, dynamic> userData);
  Future<Map<String, dynamic>?> getUser(String userId);
  Future<void> updateUser(String userId, Map<String, dynamic> data);
  Future<void> deleteUser(String userId); 
}
