import 'dart:ui';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wassalni/core/constounts/varaible.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'ar': ar, "en": en};

  Map<String, String> ar = {
    "1": "حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى",
    "2": "البريد الإلكتروني غير صالح",
    "3": "هذا البريد الإلكتروني مستخدم بالفعل",
    "4": "يرجى إدخال البريد الإلكتروني",
    "5": "لا يوجد حساب بهذا البريد الإلكتروني",
    "6": "البريد الإلكتروني أو كلمة المرور غير صحيحة",
    "7": "كلمة المرور ضعيفة",
    "8": "يرجى إدخال كلمة المرور",
    "9": "كلمة المرور لا تستوفي شروط الأمان",
    "10": "تم تعطيل هذا الحساب",
    "11": "انتهت صلاحية الجلسة، يرجى تسجيل الدخول مجدداً",
    "12": "هذا البريد مرتبط بطريقة تسجيل دخول أخرى",
    "13": "بيانات الاعتماد مستخدمة من حساب آخر",
    "14": "طريقة تسجيل الدخول مرتبطة بالحساب بالفعل",
    "15": "يرجى تسجيل الدخول مجدداً لإتمام هذه العملية",
    "16": "بيانات الحساب لا تتطابق مع المستخدم الحالي",
    "17": "فشل الاتصال بالإنترنت",
    "18": "عدد المحاولات كبير، يرجى الانتظار قليلاً",
    "19": "تم تجاوز الحد المسموح من الطلبات",
    "20": "طريقة تسجيل الدخول غير مفعلة في Firebase",
    "21": "هذه العملية غير مسموح بها",
    "22": "التطبيق غير مصرح له باستخدام Firebase",
    "23": "مفتاح Firebase API غير صالح",
    "24": "انتهت مهلة الاتصال",
    "25": "حدث خطأ داخلي في خدمة المصادقة",
    "26": "هذه العملية غير مدعومة على هذا الجهاز",
    "27": "يتطلب الحساب التحقق بخطوة إضافية",
    "28": "رمز التحقق غير صحيح",
    "29": "معرف التحقق غير صالح",
    "30": "انتهت صلاحية جلسة التحقق",
    "31": "يرجى إدخال رمز التحقق",
    "32": "معلومات التحقق غير مكتملة",
    "33": "رقم الهاتف غير صالح",
    "34": "تعذر تنفيذ عملية المصادقة",
    "35": "ليس لديك صلاحية للوصول إلى هذه البيانات",
    "36": "يرجى تسجيل الدخول أولاً",
    "37": "البيانات المطلوبة غير موجودة",
    "38": "هذه البيانات موجودة بالفعل",
    "39": "خدمة  غير متاحة حالياً",
    "40": "انتهت مهلة تنفيذ الطلب",
    "41": "تم تجاوز الحد المسموح من استخدام الخدمة",
    "42": "تم إلغاء العملية",
    "43": "تم إيقاف العملية، يرجى المحاولة مجدداً",
    "44": "لا يمكن تنفيذ العملية بسبب حالة البيانات الحالية",
    "45": "البيانات المرسلة غير صحيحة",
    "46": "القيمة المدخلة خارج النطاق المسموح",
    "47": "حدث خطأ داخلي في خادم ",
    "48": "حدث خطأ في سلامة البيانات",
    "49": "هذه العملية غير مدعومة",
    "50": "حدث خطأ غير معروف في ",
    "51": "حدث خطأ أثناء التعامل مع قاعدة البيانات",
    "52": "حدث خطأ في الاتصال    ",
    "53": "حدث خطأ في تشغيل إحدى خدمات التطبيق",
    "54": "معرف المستخدم مطلوب",
    "55": "انتهت مهلة الاتصال بالخادم، حاول مرة أخرى",
    '56': 'خطأ  ',
    "57": 'سجّل الدخول لمتابعة عمليات التوصيل وإدارة شحناتك.',
    "58": 'مرحباً بعودتك',
    "59": "ادخل البريد الالكتروني  ",
    "60": "English",
    // ****
    "61": "انشاء حساب ",
    "62": "تسجيل الدخول ",
    // ******
    "63": "كلمة المرور",
    "64": "نسيت كلمة المرور؟",
    "65": 'يرجى إدخال البريد الإلكتروني أو رقم الهاتف',
    "66": "يرجى ادخال كلمة المرور ",
    "67": "بريد الاالكنروني غير صحيح",
    "68": 'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل',
    "69": 'كلمة المرور ضعيفة',
    // "70": "تسجيل الدخول",
    "70": '...جاري التحميل',
    "71": 'إنشاء حساب جديد ',
    "72": "انضم إلى شبكتنا الاحترافية من العملاء والسائقين",
    "73": "رقم الهاتف مطلوب",
    "74": "رقم الهاتف غير صالح",
    "75": "رقم الهاتف",
    "76": "اسم المستخدم ",
    "77": "اسم المستخدم مطلوب ",
    "78": "يجب ان يكون اسم المستخدم يتكون 4 حروف على الاقل ",
    //
    "79": "'إرسال الرابط",
    "80": 'إلغاء',
    '81': 'أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة تعيين كلمة المرور.',
    "82": 'استعادة كلمة المرور',
    //
    "83": "تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني. يُرجى التحقق من صندوق الوارد.",
    "84": "تم بنجاح",
    //حالة الطلب
    "85": 'بانتظار سائق',
    "86": 'تم القبول',
    "87": '("بدأت رحلة التوصيل")قيد التوصيل',
    "88": "'تم التسليم'",
    "89": "ملغي",
    //
    "90": "تعذر تحميل الطلبات المتاحة",
    "91": 'تم إرسال طلبك',
  };

  Map<String, String> en = {
    "1": "An unexpected error occurred. Please try again.",
    "2": "Invalid email address",
    "3": "This email is already in use",
    "4": "Please enter your email address",
    "5": "No account found with this email",
    "6": "Incorrect email or password",
    "7": "Password is too weak",
    "8": "Please enter your password",
    "9": "Password does not meet security requirements",
    "10": "This account has been disabled",
    "11": "Session expired. Please sign in again",
    "12": "This email is linked to another sign-in method",
    "13": "This credential is already used by another account",
    "14": "This sign-in method is already linked",
    "15": "Please sign in again to complete this operation",
    "16": "Account information does not match the current user",
    "17": "Network connection failed",
    "18": "Too many attempts. Please wait",
    "19": "Request quota exceeded",
    "20": "This sign-in method is not enabled in Firebase",
    "21": "This operation is not allowed",
    "22": "This app is not authorized to use Firebase",
    "23": "Invalid  API key",
    "24": "Connection timed out",
    "25": "An internal authentication error occurred",
    "26": "This operation is not supported on this device",
    "27": "Additional authentication is required",
    "28": "Invalid verification code",
    "29": "Invalid verification ID",
    "30": "Verification session expired",
    "31": "Please enter the verification code",
    "32": "Verification information is incomplete",
    "33": "Invalid phone number",
    "34": "Authentication operation failed",
    "35": "You do not have permission to access this data",
    "36": "Please sign in first",
    "37": "Requested data was not found",
    "38": "This data already exists",
    "39": " service is currently unavailable",
    "40": "Request deadline exceeded",
    "41": "Service usage limit exceeded",
    "42": "Operation cancelled",
    "43": "Operation aborted. Please try again",
    "44": "Operation cannot be performed in the current state",
    "45": "Invalid data provided",
    "46": "Value is out of the allowed range",
    "47": "Internal Firebase server error",
    "48": "Data integrity error",
    "49": "This operation is not implemented",
    "50": "Unknown Firebase error",
    "51": "Database operation failed",
    "52": "Error communicating between Flutter and Firebase",
    "53": "An error occurred while running an app service",
    "54": "'User ID is required'",
    "55": "Connection timed out. Please try again",
    '56': ' error',
    "57": 'Sign in to continue your deliveries and manage shipments.',
    "58": 'Welcome back',
    "59": "Enter your Email ",
    "60": "العربية",
    // ****
    "61": "SignUp",
    "62": "SingIn",
    //
    '63': "Password",
    "64": "Forgot Password?",
    "65": "Please enter your email address or phone number",
    "66": "Password is required",
    "67": "Invalid email address",
    //
    // "68": "'Password is required'",
    "68": 'Password must be at least 8 characters',
    "69": 'Password is too weak',
    "70": 'Loading...',
    "71": 'Create a New Account',
    "72": 'Join our professional network of customers and drivers',
    "73": "phone required",
    "74": "phone invalid",
    "75": "phone number",
    "76": "Username",
    "77": "Username is required",
    "78": "Username must be at least 4 characters long",
    "79": "Send Reset Link",
    "80": "Cancel",
    "81": "Enter your email address and we'll send you a password reset link.",
    "82": "Reset Password",
    "83": "A password reset link has been sent to your email address. Please check your inbox.",
    "84": "Success",
    // Order Status
    "85": "Waiting for a driver",
    "86": "Accepted",
    "87": "Delivery started",
    "88": "Delivered",
    "89": "Cancelled",
    //
    "90": "Unable to load available orders",
    "91": "Your order has been sent",
  };
}

class LanguageController extends GetxController {
  Future<void> changeLanguage(String langCode) async {
    Locale? locale;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (langCode == "ar") {
      locale = const Locale("ar");
    } else if (langCode == 'en') {
      locale = const Locale("en");
    } else {
      await prefs.remove(Varaible.codelangouge);
      Get.updateLocale(Get.deviceLocale ?? const Locale('en'));
      return;
    }
    Get.updateLocale(locale);
    await prefs.setString(Varaible.codelangouge, langCode);
  }
}
