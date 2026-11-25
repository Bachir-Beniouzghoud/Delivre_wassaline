import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:wassalni/core/enum/app_mode.dart';
import 'package:wassalni/core/errors/firebase_exception_handler.dart';
import 'package:wassalni/data/models/Users/dilevre_model.dart';
import 'package:wassalni/data/models/Users/user_model.dart';
import 'package:wassalni/data/repositories/abstractInterface/users/user_intreface.dart';

class UserDataFirbase implements UserRepository {
  final FirebaseFirestore firestore;
  UserDataFirbase({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  static const _timeout = Duration(seconds: 30);

  CollectionReference<Map<String, dynamic>> get _users =>
      firestore.collection('users');

  @override
  Future<void> createUser(UserModel user) async {
    try {
      await _users.doc(user.id).set(user.toMap()).timeout(_timeout);
    } catch (e) {
      throw FirebaseErrorHandler.handle(e);
    }
  }

  @override
  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _users.doc(userId).get().timeout(_timeout);
      final data = doc.data();
      return data == null ? null : UserModel.fromMap(data);
    } catch (e, st) {
      debugPrint('getUser error: $e\n$st');
      throw FirebaseErrorHandler.handle(e);
    }
  }
  
// Jxs6qs58@32
  /// قراءة واحدة؛ يرجع null إن لم يكن سائقًا ولا طلب انضمام
  @override
  Future<DilevreModel?> getDriver(String userId) async {
    try {
      final doc = await _users.doc(userId).get().timeout(_timeout);
      final data = doc.data();
      if (data == null || data['driverStatus'] == null) return null;
      return DilevreModel.fromMap(data);
    } catch (e) {
      throw FirebaseErrorHandler.handle(e);
    }
  }

  @override
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await _users.doc(userId).update(data).timeout(_timeout);
    } catch (e) {
      throw FirebaseErrorHandler.handle(e);
    }
  }

  /// نُلحق حقول السائق بنفس المستند؛ update لا يمسح الحقول الأخرى
  @override
  Future<void> requestDriverAccess(DilevreModel data) async {
    try {
      await _users
          .doc(data.userId)
          .update({
            ...data.toDriverMap(),
            // 'driverStatus': DriverStatus.pending.name, // يفرضه الـ Repository
            // 'isAvailable': false,
            'requestedAt': FieldValue.serverTimestamp(),
          })
          .timeout(_timeout);
    } catch (e) {
      throw FirebaseErrorHandler.handle(e);
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await _users.doc(userId).delete().timeout(_timeout);
    } catch (e) {
      throw FirebaseErrorHandler.handle(e);
    }
  }

  @override
  Stream<DriverStatus> watchDriverStatus(String uid) {
    return _users.doc(uid).snapshots().map((doc) {
      final row = doc.data()?['driverStatus'] as String;
      final name = row.split(".").last;
      return DriverStatus.values.asNameMap()[name] ?? DriverStatus.none;
    });
  }
}
