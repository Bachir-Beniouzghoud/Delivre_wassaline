import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:wassalni/core/services/LocationService.dart';
import 'package:wassalni/data/models/map/PlaceResoult.dart';

// ignore: camel_case_types
class mapController extends GetxController {
  final _locationService = Locationservice();

  // UI state
  final query = ''.obs;
  final results = <PlaceResult>[].obs;
  final isLoading = false.obs;
  final error = RxnString();
  final Rx<LatLng?> selected = Rx<LatLng?>(null); // نوعه Rx<LatLng?>
  // Controllers
  final textController = TextEditingController();
  final focusNode = FocusNode();
  final mapCtrl = MapController();
  // ignore: prefer_typing_uninitialized_variables
  // رقم يزداد مع كل بحث؛ نتجاهل أي نتيجة لا تخص آخر بحث

  

  /// اختيار نتيجة من القائمة
  Future<void> selectPlace(PlaceResult place) async {
    focusNode.unfocus();
    textController.text = place.name; // لا يستدعي onChanged، فلا بحث جديد
    results.clear();
    goTo(place.position);
  }

  /// اختيار نقطة بالضغط على الخريطة: نجلب عنوانها عند الحاجة فقط
  Future<String?> addressOf(LatLng point) async {
    try {
      return await _locationService.addressFromPosition(point);
    } catch (e) {
      debugPrint('Reverse geocoding failed: $e');
      return null;
    }
  }

  void goTo(LatLng point, {double zoom = 17}) {
    selected.value = point;
    mapCtrl.move(point, zoom);
  }

  void onSelected(PlaceResult p){}
}
