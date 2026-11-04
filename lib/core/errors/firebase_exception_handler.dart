// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/services.dart';

// class FirebaseErrorHandler {
//   String massegEror;
//   FirebaseErrorHandler({required this.massegEror});

//   static String handle(Object error) {
//     // Firebase Authentication
//     if (error is FirebaseAuthException) {
//       return _handleAuth(error.code);
//     }

//     // Firestore and other Firebase services
//     if (error is FirebaseException) {
//       return _handleFirebase(error.code);
//     }

//     // Native Flutter platform errors
//     if (error is PlatformException) {
//       return _handlePlatform(error.code);
//     }

//     // General Dart errors
//     return 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى';
//   }

//   // ==========================================
//   // AUTHENTICATION ERRORS
//   // ==========================================

//   static String _handleAuth(String code) {
//     switch (code) {
//       // Email
//       case 'quota-exceeded':
//         return 'تم تجاوز الحد المسموح لرسائل التحقق';
//       case 'invalid-email':
//         return 'البريد الإلكتروني غير صالح';

//       case 'email-already-in-use':
//         return 'هذا البريد الإلكتروني مستخدم بالفعل';

//       case 'missing-email':
//         return 'يرجى إدخال البريد الإلكتروني';

//       case 'user-not-found':
//         return 'لا يوجد حساب بهذا البريد الإلكتروني';

//       // Password
//       case 'wrong-password':
//       case 'invalid-credential':
//       case 'invalid-login-credentials':
//         return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';

//       case 'weak-password':
//         return 'كلمة المرور ضعيفة، يرجى اختيار كلمة أقوى';

//       case 'missing-password':
//         return 'يرجى إدخال كلمة المرور';

//       case 'password-does-not-meet-requirements':
//         return 'كلمة المرور لا تستوفي شروط الأمان';

//       case 'invalid-password':
//         return 'كلمة المرور غير صالحة';

//       // Account
//       case 'user-disabled':
//         return 'تم تعطيل هذا الحساب';

//       case 'user-token-expired':
//       case 'invalid-user-token':
//         return 'انتهت صلاحية الجلسة، يرجى تسجيل الدخول مجدداً';

//       case 'no-current-user':
//       case 'no-signed-in-user':
//         return 'لا يوجد مستخدم مسجل الدخول';

//       case 'account-exists-with-different-credential':
//       case 'account-exists-with-different-credentials':
//         return 'هذا البريد مرتبط بطريقة تسجيل دخول أخرى';

//       case 'credential-already-in-use':
//         return 'بيانات الاعتماد مستخدمة من حساب آخر';

//       case 'provider-already-linked':
//         return 'طريقة تسجيل الدخول مرتبطة بالحساب بالفعل';

//       case 'requires-recent-login':
//         return 'يرجى تسجيل الدخول مجدداً لإتمام هذه العملية';

//       case 'user-mismatch':
//         return 'بيانات الحساب لا تتطابق مع المستخدم الحالي';

//       // Network and security
//       case 'network-request-failed':
//         return 'فشل الاتصال بالإنترنت';

//       case 'too-many-requests':
//         return 'عدد المحاولات كبير، يرجى الانتظار قليلاً';

//       // case 'quota-exceeded':
//       //   return 'تم تجاوز الحد المسموح من الطلبات';

//       case 'operation-not-allowed':
//         return 'طريقة تسجيل الدخول غير مفعلة في Firebase';

//       case 'admin-restricted-operation':
//         return 'هذه العملية غير مسموح بها';

//       case 'app-not-authorized':
//         return 'التطبيق غير مصرح له باستخدام Firebase';

//       case 'invalid-api-key':
//         return 'مفتاح Firebase API غير صالح';

//       case 'timeout':
//         return 'انتهت مهلة الاتصال';

//       case 'internal-error':
//       case 'unknown':
//       case 'unknown-error':
//         return 'حدث خطأ داخلي في خدمة المصادقة';

//       case 'unsupported-platform':
//       case 'unsupported-platform-operation':
//       case 'unimplemented':
//         return 'هذه العملية غير مدعومة على هذا الجهاز';

//       // Multi-factor authentication

//       case 'second-factor-required':
//       case 'multi-factor-auth-required':
//         return 'يتطلب الحساب التحقق بخطوة إضافية';

//       case 'invalid-verification-code':
//         return 'رمز التحقق غير صحيح';

//       case 'invalid-verification-id':
//         return 'معرف التحقق غير صالح';

//       case 'session-expired':
//         return 'انتهت صلاحية جلسة التحقق';

//       case 'missing-verification-code':
//         return 'يرجى إدخال رمز التحقق';

//       case 'missing-verification-id':
//         return 'معلومات التحقق غير مكتملة';

//       case 'invalid-phone-number':
//         return 'رقم الهاتف غير صالح';

//       default:
//         return 'تعذر تنفيذ عملية المصادقة، يرجى المحاولة مجدداً';
//     }
//   }

//   // ==========================================
//   // FIREBASE / FIRESTORE ERRORS
//   // ==========================================

//   static String _handleFirebase(String code) {
//     switch (code) {
//       case 'permission-denied':
//         return 'ليس لديك صلاحية للوصول إلى هذه البيانات';

//       case 'unauthenticated':
//         return 'يرجى تسجيل الدخول أولاً';

//       case 'not-found':
//         return 'البيانات المطلوبة غير موجودة';

//       case 'already-exists':
//         return 'هذه البيانات موجودة بالفعل';

//       case 'unavailable':
//         return 'خدمة Firebase غير متاحة حالياً';

//       case 'deadline-exceeded':
//         return 'انتهت مهلة تنفيذ الطلب';

//       case 'resource-exhausted':
//         return 'تم تجاوز الحد المسموح من استخدام الخدمة';

//       case 'cancelled':
//         return 'تم إلغاء العملية';

//       case 'aborted':
//         return 'تم إيقاف العملية، يرجى المحاولة مجدداً';

//       case 'failed-precondition':
//         return 'لا يمكن تنفيذ العملية بسبب حالة البيانات الحالية';

//       case 'invalid-argument':
//         return 'البيانات المرسلة غير صحيحة';

//       case 'out-of-range':
//         return 'القيمة المدخلة خارج النطاق المسموح';

//       case 'internal':
//         return 'حدث خطأ داخلي في خادم Firebase';

//       case 'data-loss':
//         return 'حدث خطأ في سلامة البيانات';

//       case 'unimplemented':
//         return 'هذه العملية غير مدعومة';

//       case 'unknown':
//         return 'حدث خطأ غير معروف في Firebase';

//       default:
//         return 'حدث خطأ أثناء التعامل مع قاعدة البيانات';
//     }
//   }

//   // ==========================================
//   // PLATFORM ERRORS
//   // ==========================================

//   static String _handlePlatform(String code) {
//     switch (code) {
//       case 'channel-error':
//         return 'حدث خطأ في الاتصال بين Flutter وخدمة Firebase';

//       case 'network_error':
//         return 'تعذر الاتصال بالإنترنت';

//       case 'not-implemented':
//         return 'هذه العملية غير مدعومة على المنصة الحالية';

//       default:
//         return 'حدث خطأ في تشغيل إحدى خدمات التطبيق';
//     }
//   }
// }

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class FirebaseErrorHandler {
  FirebaseErrorHandler._();

  static String handle(Object error) {
    if (error is FirebaseAuthException) {
      return _handleAuth(error.code);
    }

    if (error is FirebaseException) {
      return _handleFirebase(error.code);
    }

    if (error is PlatformException) {
      return _handlePlatform(error.code);
    }
    if (error is TimeoutException) {
      return '55'.tr;
    }
    return '1'.tr;
  }

  // AUTH ERRORS
  static String _handleAuth(String code) {
    switch (code) {
      case 'invalid-email':
        return '2'.tr;
      case 'email-already-in-use':
        return '3'.tr;

      case 'missing-email':
        return '4'.tr;

      case 'user-not-found':
        return '5'.tr;

      case 'wrong-password':
      case 'invalid-credential':
      case 'invalid-login-credentials':
        return '6'.tr;

      case 'weak-password':
        return '7'.tr;

      case 'missing-password':
        return '8'.tr;

      case 'password-does-not-meet-requirements':
        return '9'.tr;

      case 'user-disabled':
        return '10'.tr;

      case 'user-token-expired':
      case 'invalid-user-token':
        return '11'.tr;

      case 'account-exists-with-different-credential':
      case 'account-exists-with-different-credentials':
        return '12'.tr;

      case 'credential-already-in-use':
        return '13'.tr;

      case 'provider-already-linked':
        return '14'.tr;

      case 'requires-recent-login':
        return '15'.tr;

      case 'user-mismatch':
        return '16'.tr;

      case 'network-request-failed':
        return '17'.tr;

      case 'too-many-requests':
        return '18'.tr;

      case 'quota-exceeded':
        return '19'.tr;

      case 'operation-not-allowed':
        return '20'.tr;

      case 'admin-restricted-operation':
        return '21'.tr;

      case 'app-not-authorized':
        return '22'.tr;

      case 'invalid-api-key':
        return '23'.tr;

      case 'timeout':
        return '24'.tr;

      case 'internal-error':
      case 'unknown':
      case 'unknown-error':
        return '25'.tr;

      case 'unsupported-platform':
      case 'unsupported-platform-operation':
      case 'unimplemented':
        return '26'.tr;

      case 'second-factor-required':
      case 'multi-factor-auth-required':
        return '27'.tr;

      case 'invalid-verification-code':
        return '28'.tr;

      case 'invalid-verification-id':
        return '29'.tr;

      case 'session-expired':
        return '30'.tr;

      case 'missing-verification-code':
        return '31'.tr;

      case 'missing-verification-id':
        return '32'.tr;

      case 'invalid-phone-number':
        return '33'.tr;

      default:
        return '34'.tr;
    }
  }

  // FIREBASE / FIRESTORE ERRORS
  static String _handleFirebase(String code) {
    switch (code) {
      case 'permission-denied':
        return '35'.tr;

      case 'unauthenticated':
        return '36'.tr;

      case 'not-found':
        return '37'.tr;

      case 'already-exists':
        return '38'.tr;

      case 'unavailable':
        return '39'.tr;

      case 'deadline-exceeded':
        return '40'.tr;

      case 'resource-exhausted':
        return '41'.tr;

      case 'cancelled':
        return '42'.tr;

      case 'aborted':
        return '43'.tr;

      case 'failed-precondition':
        return '44'.tr;

      case 'invalid-argument':
        return '45'.tr;

      case 'out-of-range':
        return '46'.tr;

      case 'internal':
        return '47'.tr;

      case 'data-loss':
        return '48'.tr;

      case 'unimplemented':
        return '49'.tr;

      case 'unknown':
        return '50'.tr;

      default:
        return '51'.tr;
    }
  }

  // PLATFORM ERRORS
  static String _handlePlatform(String code) {
    switch (code) {
      case 'channel-error':
        return '52'.tr;

      case 'network_error':
        return '17'.tr;

      case 'not-implemented':
        return '26'.tr;

      default:
        return '53'.tr;
    }
  }
}
