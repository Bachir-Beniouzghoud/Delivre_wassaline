import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:wassalni/core/enum/statusLocation.dart';
import 'package:wassalni/data/models/order/orderLocation.dart';

/// نتيجة القراءة: الموقع (عند النجاح فقط) + الحالة دائماً
typedef PositionResult = ({OrderLocation? location, LocationStatus status});
// أعلى الملف
/// نتيجة تحويل النص: الموقع + هل هو تقريبي (حُذف جزء من الجملة)
typedef ResolvedLocation = ({OrderLocation location, bool approximate});

class Locationservice {
  // bool isAlgerai( ){

  // }
  Future<LocationStatus> _statusLocation() async {
    bool serviceEnable;
    LocationPermission permission;
    serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      return LocationStatus.serviceDisabled; //خدمة الموقع مغلقة
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      //التحقق من اذن الموقع
      permission =
          await Geolocator.requestPermission(); //اعادة طلب اذن من الموقع

      if (permission == LocationPermission.denied) {
        return LocationStatus.denied; //تم رفض إذن الوصول إلى الموقع
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationStatus.deniedForever; //تم رفض إذن الموقع ائم
    }
    return LocationStatus.success; //حالة لا توجد مشكلة في الموقع
  }

  //********************************************************** */
  //************** ******************************************** */
  //********************************************************** */
  //جلب الموقع  الحالي
  Future<PositionResult> getLocation() async {
    LocationStatus stauslocation = await _statusLocation();
    if (stauslocation != LocationStatus.success) {
      return (location: null, status: stauslocation); //ترجع سبب
    }
    try {
      // إزالة الإعدادات القديمة وإضافة Timeout لمنع تعليق التطبيق
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20), // مهلة أقصاها 8 ثوانٍ
        ),
      );
   
      final LatLng location = LatLng(position.latitude, position.longitude);
      OrderLocation hasLocation = OrderLocation(
        address: "address",
        // lat: position.latitude,
        // lng: position.longitude,
        loction: location
      );
      return (location: hasLocation, status: stauslocation);
    } on TimeoutException {
      return (location: null, status: LocationStatus.timeout);
      //انتهت مهلة البحث عن الموقع
      // return "27".tr; // في حال حدث Timeout أو خطأ في الـ GPS
    } on LocationServiceDisabledException {
      return (location: null, status: LocationStatus.serviceDisabled);
    } on PermissionDeniedException {
      return (location: null, status: LocationStatus.denied);
    } catch (e) {
      return (location: null, status: LocationStatus.unknown);
    }
  }

  Future<String> addressFromPosition(LatLng p) async {
    // await ('ar'); // نتائج بالعربية
    try {
      // نتائج بالعربية placemarkFromCoordinates
      final marks = await Geocoding().placemarkFromCoordinates(
        p.latitude,
        p.longitude,
      );
      if (marks.isNotEmpty) {
        final m = marks.first;
        final parts = <String>[];
        for (final s in [
          m.street,
          m.subLocality,
          m.locality,
          m.administrativeArea,
        ]) {
          final t = s?.trim() ?? '';
          if (t.isEmpty || t.contains('+')) {
            continue; // تجاهل الفارغ وأكواد الموقع
          }
          if (!parts.contains(t)) parts.add(t); // منع التكرار
        }
        if (parts.isNotEmpty) return parts.join('، ');
      }
    } catch (_) {
      // لا إنترنت أو الخدمة غير متاحة: ننتقل إلى الاحتياط أدناه
    }
    // احتياط: الإحداثيات كنص حتى لا يبقى العنوان فارغاً
    return '${p.latitude.toStringAsFixed(5)}, ${p.longitude.toStringAsFixed(5)}';
  }

  //************************************* */
  //************************************* */
  //************************************* */
  //************************************* */
  //************************************* */
  //************************************* */
  // حدود الجزائر التقريبية: ترفض أي نتيجة خاطئة خارج البلد
  static bool _inAlgeria(double lat, double lng) =>
      lat >= 18.9 && lat <= 37.2 && lng >= -8.7 && lng <= 12.0;
  // مركز الجزائر الجغرافي: يرجعه geocoder حين لا يفهم النص
  static const _algeriaCenter = (lat: 28.033886, lng: 1.659626);

  static bool _isCountryCenter(double lat, double lng) =>
      Geolocator.distanceBetween(
        lat,
        lng,
        _algeriaCenter.lat,
        _algeriaCenter.lng,
      ) <
      20000; // 20 كم حول المركز
  //************************************* */
  //************************************* */
  //************************************* */
  //************************************* */
  //************************************* */
  //************************************* */
  // تحويل النص المدخل الى احدثيات موقع
  Future<ResolvedLocation?> locationFromText(String text) async {
    // تنظيف النص: إزالة المسافات الزائدة
    final clean = text.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (clean.length < 3) return null;

    final words = clean.split(' ');
    // نبقي كلمتين على الأقل، إلا إن كتب المستخدم كلمة واحدة فقط
    final minWords = words.length < 2 ? 1 : 2;
    final geocoding = Geocoding();

    // أقصى 4 محاولات حتى لا ينتظر المستخدم طويلاً
    var attempts = 0;
    for (
      var i = 0;
      i <= words.length - minWords && attempts < 4;
      i++, attempts++
    ) {
      // في كل دورة نحذف كلمة من بداية الجملة (الحي أولاً)
      final query = '${words.sublist(i).join(' ')}، الجزائر';
      try {
        final results = await geocoding
            .locationFromAddress(query)
            .timeout(const Duration(seconds: 5));
        if (results.isEmpty) continue;

        final p = results.first;
        if (!_inAlgeria(p.latitude, p.longitude)) continue;
        if (_isCountryCenter(p.latitude, p.longitude)) continue; // نتيجة عامة
        return (
          // نحفظ النص الأصلي كما كتبه الزبون ليقرأه السائق
          location: OrderLocation(
            address: clean,
            loction: LatLng(p.latitude, p.longitude)
          ),
          approximate: i > 0, // أي حذف يعني دقة أقل
        );
      } catch (_) {
        continue; // لا نتيجة أو خطأ شبكة: نجرّب النص الأقصر
      }
    }
    return null; // فشلت كل المحاولات
  }
}
