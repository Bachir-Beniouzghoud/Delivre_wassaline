import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:wassalni/core/enum/orderstatus.dart';

class Functionstatic {
  static String? validteEmail(String? email) {
    if (!email!.isEmail) {
      return "67".tr;
      // "67": "بريد الاالكنروني غير صحيح",
    }
    if (email.isEmpty) {
      return "66".tr; //    "65": 'يرجى إدخال البريد الإلكتروني أو رقم الهاتف',
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "66".tr; //'Password is required'
    }

    if (value.length < 8) {
      return "68".tr; //'Password must be at least 8 characters'
    }

    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return "69".tr; //'Password is too weak';
    }

    return null; // Password is valid
  }

  static String? validateAlgerianPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '73'.tr; //phone required
    }

    final phone = value.trim();

    // Algerian phone: 05, 06, 07 + 8 digits
    final regex = RegExp(r'^0[567][0-9]{8}$');

    if (!regex.hasMatch(phone)) {
      return '74'.tr; //phone invalid
    }

    return null;
  }

  static String? validateusername(String? username) {
    // "77": "Username is required",
    //     "78": "Username must be at least 4 characters long",
    if (username!.trim().isEmpty) {
      return "77".tr;
    }
    if (username.trim().length < 4) {
      return "78".tr;
    }
    return null;
  }
   
}
