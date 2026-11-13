import 'package:firebase_auth/firebase_auth.dart';
import 'package:wassalni/core/errors/firebase_exception_handler.dart';
import 'package:wassalni/data/repositories/abstractInterface/users/Auth_intreface.dart';

class AuthFirebase implements Authuser {
  final FirebaseAuth auth;
  AuthFirebase({FirebaseAuth? auth}) : auth = auth ?? FirebaseAuth.instance;
  @override
  String? get currentUid => auth.currentUser?.uid;
  // reset password by sending a password reset email to the provided email address using Firebase authentication
  @override
  Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorHandler.handle(e);
    }
  }

  //sign in a user with the provided email and password using Firebase aurhentcation
  @override
  Future<void> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorHandler.handle(e);
    }
  }

  // sign out the current user using Firebase authentication
  @override
  Future<void> signOut() async {
    try {
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorHandler.handle(e);
    }
  }

  // get the current user from Firebase authentication
  @override
  Future<String?> signUp(String email, String password) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user!.uid.toString();
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorHandler.handle(e);
    }
  }

  // update Password
  @override
  Future<void> updatePassword(
    String email,
    String oldPassword,
    String newPassword,
  ) async {
    try {
      final u = auth.currentUser;
      if (u != null) {
        final credential = EmailAuthProvider.credential(
          email: email,
          password: oldPassword,
        );
        //  Verify old password
        await u.reauthenticateWithCredential(credential);
        // Update password
        await u.updatePassword(newPassword);
      }
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorHandler.handle(e);
    }
  }
}
