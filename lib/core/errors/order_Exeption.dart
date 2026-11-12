import 'package:wassalni/core/enum/orderstatus.dart';

class OrderNotFoundException extends AppException {
  const OrderNotFoundException()
    : super('الطلب غير موجود', code: 'order-not-found');
}

class OrderAlreadyTakenException extends AppException {
  const OrderAlreadyTakenException()
    : super('تم قبول هذا الطلب من سائق آخر', code: 'order-already-taken');
}

class InvalidStatusTransitionException extends AppException {
  InvalidStatusTransitionException(OrderStatus from, OrderStatus to)
    : super(
        'لا يمكن تغيير الحالة من ${from.name} إلى ${to.name}',
        code: 'invalid-status-transition',
      );
}

abstract class AppException implements Exception {
  final String message; // رسالة للمستخدم
  final String code; // كود ثابت للتعرّف على الخطأ

  const AppException(this.message, {required this.code});

  @override
  String toString() => '$runtimeType($code): $message';
}

class NotOrderOwnerException extends AppException {
  const NotOrderOwnerException()
    : super('لا تملك صلاحية تعديل هذا الطلب', code: 'not-order-owner');
}
// try {
//   await _repo.acceptOrder(orderUid, driverId);
//   Get.snackbar('تم', 'تم قبول الطلب');
// } on OrderAlreadyTakenException {
//   Get.snackbar('عذراً', 'تم قبول هذا الطلب من سائق آخر');
// } on OrderNotFoundException {
//   Get.snackbar('خطأ', 'الطلب غير موجود');
// }
// Future<void> cancel(String orderUid) async {
//   try {
//     await _repo.cancelOrder(orderUid, authController.currentUser.id);
//     Get.snackbar('تم', 'تم إلغاء الطلب');
//   } on AppException catch (e) {
//     Get.snackbar('تنبيه', e.message);
//   }
// }
