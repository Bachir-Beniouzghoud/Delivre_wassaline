// import 'package:get/state_manager.dart';

// class Ordersoller extends GetxController {
//   final isLoading = false.obs;
//   final errorMessage = ''.obs;

// }
import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:wassalni/core/Extenstion/snakbar.dart';
import 'package:wassalni/core/enum/orderstatus.dart';
import 'package:wassalni/core/enum/user_role.dart';
import 'package:wassalni/core/errors/firebase_exception_handler.dart';
import 'package:wassalni/data/models/order/ordermodel.dart';
import 'package:wassalni/data/repositories/abstractInterface/ordeds/getorder.dart';
import 'package:wassalni/modules/auth/controllers/AuthController.dart';

class OrderController extends GetxController {  
  OrderController(this._repo, this._auth);

  final OrderRepository _repo;
  final Authcontroller _auth; // يوفّر المستخدم الحالي: id و role و city
  // ───────── الحالة (State) ─────────
  final myOrders = <OrderModel>[].obs; // طلباتي (زبون) أو التي قبلتها (سائق)
  final availableOrders = <OrderModel>[].obs; // الطلبات المتاحة (للسائق فقط)
  final selectedStatus = Rxn<OrderStatus>(); // null = كل الحالات
  final isLoading = false.obs;

  StreamSubscription<List<OrderModel>>? _availableSub;

  // ───────── اختصارات ─────────
  String get _uid => _auth.currentUser.value!.id;
  UserRole get _role => _auth.currentUser.value!.role;

  // ───────── دورة الحياة ─────────
  @override
  void onInit() {
    super.onInit();
    loadMyOrders();
    if (_role == UserRole.delivery) watchAvailableOrders();
  }

  @override
  void onClose() {
    _availableSub?.cancel(); // مهم: لا تترك الـ Stream مفتوحاً
    super.onClose();
  }

  // ───────── القراءة ─────────
  Future<void> loadMyOrders() async {
    await _run(() async {
      final orders = await _repo.getOrderBystatus(
        userUid: _uid,
        role: _role,
        statusorder: selectedStatus.value!,
      );
      myOrders.assignAll(orders);
    });
  }

  void filterByStatus(OrderStatus? status) {
    selectedStatus.value = status;
    loadMyOrders();
  }

  Future<void> watchAvailableOrders() async {
    final position = await Geolocator.getCurrentPosition();

    await _availableSub?.cancel(); // نلغي الاشتراك القديم قبل فتح جديد
    _availableSub = _repo
        .watchAvailableOrders(
          city: _auth.currentUser.value!.city.toString(),
          driverLat: position.latitude,
          driverLng: position.longitude,
        )
        .listen(
          availableOrders.assignAll,
          onError: (_) =>
              _showError("90".tr), //    "90":"تعذر تحميل الطلبات المتاحة"
        );
  }

  // ───────── الكتابة: الزبون ─────────
  Future<void> createOrder(OrderModel order) async {
    await _run(() async {
      await _repo.createOrder(order);
      await loadMyOrders();
      Snakbar.showMassge("91".tr, order.status.label, order.status.color);
      // Get.snackbar('92'.tr, "91".tr); //91 :'تم إرسال طلبك' 92
    });
  }

  Future<void> cancel(String orderUid) => _changeStatus(
    orderUid,
    OrderStatus.cancelled,
    OrderStatus.cancelled.label,
  );

  // ───────── الكتابة: السائق ─────────
  Future<void> accept(String orderUid) async {
    await _run(() async {
      await _repo.acceptOrder(orderUid, _uid);
      await loadMyOrders();
      Snakbar.showMassge(
        "91".tr,
        OrderStatus.confirmed.label,
        OrderStatus.confirmed.color,
      );
    });
  }

  Future<void> startDelivery(String orderUid) => _changeStatus(
    orderUid,
    OrderStatus.delivering,
    OrderStatus.delivering.label,
  );

  Future<void> complete(String orderUid) => _changeStatus(
    orderUid,
    OrderStatus.delivered,
    OrderStatus.delivered.label,
  );

  // ───────── دوال مساعدة داخلية ─────────
  Future<void> _changeStatus(
    String orderUid,
    OrderStatus next,
    String successMessage,
  ) async {
    await _run(() async {
      await _repo.updateOrderStatus(
        orderUid: orderUid,
        userUid: _uid,
        role: _role,
        next: next,
      );

      await loadMyOrders();
      Get.snackbar('تم', successMessage);
    });
  }

  /// تغلّف أي عملية بحالة التحميل ومعالجة الأخطاء في مكان واحد
  Future<void> _run(Future<void> Function() action) async {
    isLoading.value = true;
    try {
      await action();
    } on FirebaseErrorHandler catch (e) {
      // _showError(e.message);
      FirebaseErrorHandler.handle(e);
    } catch (_) {
      _showError('حدث خطأ غير متوقع');
    } finally {
      isLoading.value = false;
    }
  }

  void _showError(String message) => Get.snackbar('تنبيه', message);
}
