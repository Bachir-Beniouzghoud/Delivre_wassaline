import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:wassalni/core/Extenstion/generaitordercode.dart';
import 'package:wassalni/core/Extenstion/snakbar.dart';
import 'package:wassalni/core/enum/statusLocation.dart';
import 'package:wassalni/core/services/LocationService.dart';
import 'package:wassalni/core/theme/Appcolors.dart';
import 'package:wassalni/data/models/order/orderLocation.dart';
import 'package:wassalni/data/models/order/ordermodel.dart';
import 'package:wassalni/modules/auth/controllers/AuthController.dart';
import 'package:wassalni/modules/orders/controllers/OrdersControler.dart';

class Customercontroller extends GetxController {
  final OrderController _orders;
  final Authcontroller _user;
  final pickupLocation = Rxn<OrderLocation>(); // من زر GPS فقط
  final isLocating = false.obs;
  final isSubmitting = false.obs;
  final _service = Locationservice();

  Customercontroller(this._orders, this._user);
  final FormKey = GlobalKey<FormState>();
  final pickupCtrl = TextEditingController(); //موقع الانطلاق
  final dropoffCtrl = TextEditingController(); //موقع الوصول
  final noteCtrl = TextEditingController();

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
    _service.getLocation();
    if (!FormKey.currentState!.validate()) return;
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
        pickup.lat,
        pickup.lng,
        dropoff.lat,
        dropoff.lng,
      );
      print(meters);
      print("meters****************");
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
          customerId: _user.currentUser.value!.userModel.id,
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
    //   if (r == null) {
    //     Snakbar.showMassge('address_not_found'.tr, label, AppColors.error);
    //     return null;
    //   }
    //   if (r.approximate) {
    //     final ok = await Get.dialog<bool>(
    //       AlertDialog(
    //         title: Text(label),
    //         content: Text('approx_confirm'.tr), // "لم نجد العنوان بدقة، سنستعمل أقرب منطقة. متابعة؟"
    //         actions: [
    //           TextButton(
    //               onPressed: () => Get.back(result: false),
    //               child: Text('cancel'.tr)),
    //           FilledButton(
    //               onPressed: () => Get.back(result: true),
    //               child: Text('continue'.tr)),
    //         ],
    //       ),
    //     );
    //     if (ok != true) return null;
    //   }
    //   return r.location;
    // }

    // Future<void> submit() async {
    //   if (!FormKey.currentState!.validate()) return;
    //   isSubmitting.value = true;

    //   final note = noteCtrl.text.trim();
    //   final location = await Locationservice().getLocation();
    //   if (location.status == LocationStatus.success) {
    //     final orderlocation =
    //         location.location; //يستعمل في حالة اراد المستخدم تحديد الموقع تلقائيا
    //     final pickup = await Locationservice().locationFromText(pickupCtrl.text);
    //     final dropoff = await Locationservice().locationFromText(
    //       dropoffCtrl.text,
    //     );
    //     if (pickup != null && dropoff != null && pickup != dropoff) {
    //       await _orders.createOrder(
    //         OrderModel(
    //           code: OrderCode.generate(),
    //           customerId: _user.currentUser.value!.userModel.id,
    //           pickup: pickup.location,
    //           dropoff: dropoff.location,
    //           price: 100,
    //           createdAt: DateTime.now(),
    //         ),
    //       );
    //     } else {}
    //   }

    // else {
    //   switch (location.status) {
    //     case LocationStatus.serviceDisabled:
    //       Snakbar.showMassge('94'.tr, 'location_error'.tr, AppColors.error);
    //       break;

    //     case LocationStatus.denied:
    //       Snakbar.showMassge('95'.tr, 'location_error'.tr, AppColors.error);
    //       break;

    //     case LocationStatus.deniedForever:
    //       Snakbar.showMassge('96'.tr, 'location_error'.tr, AppColors.error);
    //       break;

    //     case LocationStatus.timeout:
    //       Snakbar.showMassge('97'.tr, 'location_error'.tr, AppColors.error);
    //       break;

    //     case LocationStatus.success:
    //       Snakbar.showMassge('98'.tr, 'location_success'.tr, AppColors.error);
    //       break;

    //     case LocationStatus.unknown:
    //       Snakbar.showMassge('99'.tr, 'location_error'.tr, AppColors.error);
    //       break;
    //   }
    // }
    //
  }

  @override
  void onClose() {
    pickupCtrl.dispose();
    dropoffCtrl.dispose();
    noteCtrl.dispose();
    super.onClose();
  }
}
