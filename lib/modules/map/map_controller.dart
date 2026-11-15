import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:wassalni/data/map/MapServices.dart';
import 'package:wassalni/data/models/map/PlaceResoult.dart';

class mapController extends GetxController {
  final _service = MapServices();
  final query = ''.obs; // النص الذي يكتبه المستخدم
  final results = <Placeresoult>[].obs; // نتائج البحث
  final isLoading = false.obs; // هل البحث جارٍ؟
  final error = RxnString();

  final Controller = MapController();
  void goTo(LatLng point, {double zoom = 17}) {
    selected.value = point;
    Controller.move(point, zoom);
  }

  final Rx<LatLng?> selected = Rx<LatLng?>(null);

  /// تُستدعى عند اختيار المستخدم نتيجة من القائمة.
  void selectPlace(Placeresoult place, BuildContext context) {
    FocusScope.of(context).unfocus(); // إخفاء لوحة المفاتيح
    selected.value = place.posetion; // حفظ الموقع لعرض العلامة
    // _c.results.clear(); // إخفاء قائمة النتائج
    Controller.move(place.posetion, 17); // تحريك الخريطة مع زوم 17
  }

  Future<void> search(String text) async {
    // نتجاهل النصوص القصيرة جداً لأن نتائجها غير مفيدة.
    if (text.trim().length < 3) {
      results.clear();
      return;
    }
    isLoading.value = true;
    error.value = null;
    try {
      results.assignAll(await _service.search(text.trim()));
    } catch (e) {
      // نعرض رسالة مفهومة للمستخدم، وليس الخطأ التقني.
      error.value = 'تعذر البحث، تحقق من الإنترنت';
    } finally {
      // finally ينفذ دائماً، سواء نجح البحث أو فشل،
      // فلا تبقى الواجهة في حالة تحميل للأبد.
      isLoading.value = false;
    }
  }
}
