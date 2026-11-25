import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:wassalni/core/Extenstion/generaitordercode.dart';
import 'package:wassalni/core/Extenstion/snakbar.dart';
import 'package:wassalni/core/enum/statusLocation.dart';
import 'package:wassalni/core/services/LocationService.dart';
import 'package:wassalni/core/services/network_guard.dart';
import 'package:wassalni/core/theme/Appcolors.dart';
import 'package:wassalni/data/map/MapServices.dart';
import 'package:wassalni/data/models/map/PlaceResoult.dart';
import 'package:wassalni/data/models/order/orderLocation.dart';
import 'package:wassalni/data/models/order/ordermodel.dart';
import 'package:wassalni/modules/auth/controllers/AuthController.dart';
import 'package:wassalni/modules/orders/controllers/OrdersControler.dart';

class Customercontroller extends GetxController {
  final OrderController _orders;
  final Authcontroller _user;

  final _mapService = MapServices();
  final _locationService = Locationservice();

  // UI state
  // final query = ''.obs;
  // final results = <PlaceResult>[].obs;
  final isLoading = false.obs;
  final error = RxnString();
  // Controllers
  final pickupCtrl = TextEditingController(); //موقع الانطلاق
  final dropoffCtrl = TextEditingController(); //موقع الوصول
  final noteCtrl = TextEditingController();
  final Rx<LatLng?> selected = Rx<LatLng?>(null); // نوعه Rx<LatLng?>
  final focusNode = FocusNode();
  // ignore: prefer_typing_uninitialized_variables
  PositionResult? locaton;
  // رقم يزداد مع كل بحث؛ نتجاهل أي نتيجة لا تخص آخر بحث
  // int _searchId = 0;
  final pickupLocation = Rxn<OrderLocation>(); // من زر GPS فقط
  final isLocating = false.obs;
  final isSubmitting = false.obs;
  final _service = Locationservice();
  final formKey = GlobalKey<FormState>();

  final pickup = PlaceSearchField(); //موقع الانطلاق
  final dropoff = PlaceSearchField(); //موقع الووصل
  //constractour
  Customercontroller(this._orders, this._user);
  //
  @override
  void onInit() async {
    locaton = await _locationService.getLocation();

    super.onInit();
    debounce(
      pickup.query,
      (q) => _search(pickup, q),
      time: const Duration(milliseconds: 500),
    );
    debounce(
      dropoff.query,
      (q) => _search(dropoff, q),
      time: const Duration(milliseconds: 500),
    );
    // debounce(query, search, time: const Duration(milliseconds: 500));
  }

  @override
  void onClose() {
    pickupCtrl.dispose();
    dropoffCtrl.dispose();
    noteCtrl.dispose();
    focusNode.dispose();
    super.onClose();
  }

  /// عدّل المستخدم النص يدوياً: نلغي إحداثيات GPS القديمة
  void onPickupEdited(String _) => pickupLocation.value = null;
  //*************  */
  String? required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'required_field'.tr : null;
  // ───── زر «موقعي الحالي» ─────
  Future<void> useCurrentLocation() async {
    isLocating.value = true;
    try {
      final r = await _service.getLocation();
      if (r.status != LocationStatus.success) {
        _showLocationError(r.status);
        return;
      }
      pickupLocation.value = r.location;
      pickupCtrl.text = r.location!.address;
    } finally {
      isLocating.value = false;
    }
  }

  // ───── الإرسال ─────
  Future<void> submit() async {
    // _service.getLocation();
    // final controller = mapController();
    if (!formKey.currentState!.validate()) return;
    if (!ensureOnline()) return; // الإرسال يحتاج إنترنت
    isSubmitting.value = true;
    try {
      // 1) نقطة الانطلاق: GPS إن وُجد، وإلا من النص
      final pickup =
          pickupLocation.value ??
          await _resolveText(pickupCtrl.text, 'pickup'.tr);
      if (pickup == null) return;

      final dropoff = await _resolveText(dropoffCtrl.text, 'dropoff'.tr);
      if (dropoff == null) return;

      // 2) فحص المسافة (بدل pickup != dropoff الذي لا يعمل)
      final meters = Geolocator.distanceBetween(
        pickup.loction.latitude,
        pickup.loction.longitude,
        dropoff.loction.latitude,
        dropoff.loction.longitude,
      );

      if (meters < 100 || meters > 1000000) {
        Snakbar.showMassge(
          'invalid_distance'.tr,
          'dropoff'.tr,
          AppColors.error,
        );
        return;
      }

      // 3) الحفظ، ولا نفرّغ الحقول إلا عند النجاح
      final note = noteCtrl.text.trim();
      final ok = await _orders.createOrder(
        OrderModel(
          code: OrderCode.generate(),
          customerId: _user.currentUser.value!.id,
          pickup: pickup,
          dropoff: dropoff,
          note: note.isEmpty ? null : note,
          price: 100,
          createdAt: DateTime.now(),
        ),
      );
      if (ok) {
        pickupCtrl.clear();
        dropoffCtrl.clear();
        noteCtrl.clear();
        pickupLocation.value = null;
      }
    } finally {
      isSubmitting.value = false;
    }
  }

  void _showLocationError(LocationStatus s) {
    final key = switch (s) {
      LocationStatus.serviceDisabled => '94',
      LocationStatus.denied => '95',
      LocationStatus.deniedForever => '96',
      LocationStatus.timeout => '97',
      _ => '99',
    };
    Snakbar.showMassge(key.tr, 'location_error'.tr, AppColors.error);
  }

  /// نص → موقع، مع رسالة خطأ وتأكيد إن كانت النتيجة تقريبية
  Future<OrderLocation?> _resolveText(String text, String label) async {
    final r = await _service.locationFromText(text);
    if (r == null) {
      Snakbar.showMassge('address_not_found'.tr, label, AppColors.error);
      return null;
    }
    if (r.approximate) {
      final ok = await Get.dialog<bool>(
        AlertDialog(
          title: Text(label),
          content: Text(
            'approx_confirm'.tr,
          ), // "لم نجد العنوان بدقة، سنستعمل أقرب منطقة. متابعة؟"
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text('cancel'.tr),
            ),
            FilledButton(
              onPressed: () => Get.back(result: true),
              child: Text('continue'.tr),
            ),
          ],
        ),
      );
      if (ok != true) return null;
    }
    return r.location;
  }

  Future<void> _search(PlaceSearchField f, String q) async {
    final text = q.trim();
    final id = ++f.searchId;
    if (text.length < 3) {
     f.results.clear();
      error.value = null;
      f.isLoading.value = false;

      return;
    }

    // بدون إنترنت: لا نبحث (الشريط العلوي يوضح السبب، فلا رسالة لكل حرف)
    if (!ensureOnline(showMessage: false)) {
      f.results.clear();
      f.isLoading.value = false;
      return;
    }

    f.isLoading.value = true;
    error.value = null;

    try {
      final found = await _mapService.search(
        text,
        near: locaton?.location?.loction,
      ); // List<PlaceResult>
      if (id != f.searchId) return;
      f.results.assignAll(found ?? []);
    } catch (e) {
      if (id != f.searchId) return;
      f.results.clear();
      error.value = 'تعذّر البحث، حاول مرة أخرى';
    } finally {
      // أوقف المؤشر فقط إذا كان هذا آخر بحث
      if (id == f.searchId) f.isLoading.value = false;
    }
  }

  void onSelected(PlaceResult p) {}
}

class PlaceSearchField {
  final TextEditingController text = TextEditingController();
  final FocusNode focus = FocusNode();
  final query = ''.obs;
  final results = <PlaceResult>[].obs;
  final isLoading = false.obs;
  final selected = Rxn<PlaceResult>();
  int searchId = 0; // لكل حقل عدّاده الخاص

  void dispose() {
    text.dispose();
    focus.dispose();
  }
}
