import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:wassalni/core/errors/firebase_exception_handler.dart';
import 'package:wassalni/data/models/Users/dilevre_model.dart';
import 'package:wassalni/data/models/Users/user_model.dart';
import 'package:wassalni/data/repositories/abstractInterface/users/user_intreface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataFirbase implements UserRepository {
  final FirebaseFirestore firestore;
  UserDataFirbase({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;
  // Collection reference
  CollectionReference<Map<String, dynamic>> get _users =>
      firestore.collection('users');
  //Create a new user document in Firestore with the provided user data
  @override
  Future<void> createUser(Map<String, dynamic> userData) async {
    try {
      final userId = userData['userModel']['id'];
      if (userId == null) {
        throw ArgumentError("54".tr);
      }
      await _users
          .doc(userId.toString())
          .set(userData)
          .timeout(Duration(seconds: 30));
    } on FirebaseException catch (e) {
      throw FirebaseErrorHandler.handle(e);
    }
  }

  //Romove Acount
  //Romove Acount
  //Romove Acount
  // Retrieve a user document from firestore based on the provided user ID and return the user data as a map
  @override
  Future<dynamic> deleteUser(String userId) async {
    try {
      await _users.doc(userId).delete().timeout(Duration(seconds: 30));
    } on FirebaseException catch (e) {
      throw FirebaseErrorHandler.handle(e);
    }
  }

  // Retrieve auser document from Firestore base on the provided user ID and retuen the user data as a map
  @override
  Future<DilevreModel?> getUser(String userId) async {
    try {
      final doc = await _users
          .doc(userId)
          .get(const GetOptions(source: Source.serverAndCache))
          .timeout(Duration(seconds: 30));
      if (doc.exists) {
        // doc.
        final user = DilevreModel.fromMap(doc.data()!);
        return user;
      }
      return null;
    } on FirebaseException catch (e) {
      throw FirebaseErrorHandler.handle(e);
    }
  }

  // update a user document in Firbase based on the provided user ID and data map
  @override
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await _users.doc(userId).update(data);
    } on FirebaseException catch (e) {
      throw FirebaseErrorHandler.handle(e);
    }
  }
}
