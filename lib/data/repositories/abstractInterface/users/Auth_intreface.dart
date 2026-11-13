abstract interface class Authuser {
  /// معرّف المستخدم المسجّل حالياً (null إن لم توجد جلسة)
  String? get currentUid;
  Future<String?> signUp(String email, String password);
  Future<void> signIn(String email, String password);
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<void> updatePassword(
    String email,
    String oldPassword,
    String newPassword,
  );
}
