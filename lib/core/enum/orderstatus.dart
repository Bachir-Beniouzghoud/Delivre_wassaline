import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:wassalni/core/enum/user_role.dart';

enum OrderStatus { pending, confirmed, delivering, delivered, cancelled }

extension OrderStatusRules on OrderStatus {
  /// الحالات التي يمكن الانتقال إليها من الحالة الحالية
  /// (لمنع التنقل العشوائي بين حالات الطلب)
  List<OrderStatus> get nextStatuses => switch (this) {
    OrderStatus.pending => [OrderStatus.confirmed, OrderStatus.cancelled],
    OrderStatus.confirmed => [OrderStatus.delivering, OrderStatus.cancelled],
    OrderStatus.delivering => [OrderStatus.delivered],
    OrderStatus.delivered || OrderStatus.cancelled => [],
  };

  /// هل يحق لهذا الدور الانتقال إلى الحالة [next] من الحالة الحالية؟
  bool canChangeTo(OrderStatus next, UserRole role) =>
      nextStatuses.contains(next) &&
      switch (role) {
        UserRole.customer => next == OrderStatus.cancelled,
        UserRole.delivery =>
          next == OrderStatus.delivering || next == OrderStatus.delivered,
        _ => false,
      };
}

extension OrderStatusUi on OrderStatus {
  String get label => switch (this) {
    OrderStatus.pending => '85'.tr, // 'بانتظار سائق'
    OrderStatus.confirmed => "86".tr, //'تم القبول'
    OrderStatus.delivering => "87".tr, //'قيد التوصيل'
    OrderStatus.delivered => "88".tr, //'تم التسليم'
    OrderStatus.cancelled => '89'.tr, //ملغي
  };
}

extension OrderStatusColor on OrderStatus {
  /// لون الحالة (للشارة والنص)
  Color get color => switch (this) {
    OrderStatus.pending => Colors.orange,
    OrderStatus.confirmed => Colors.blue,
    OrderStatus.delivering => Colors.purple,
    OrderStatus.delivered => Colors.green,
    OrderStatus.cancelled => Colors.red,
  };

  /// أيقونة الحالة
  IconData get icon => switch (this) {
    OrderStatus.pending => Icons.hourglass_top,
    OrderStatus.confirmed => Icons.check_circle_outline,
    OrderStatus.delivering => Icons.delivery_dining,
    OrderStatus.delivered => Icons.task_alt,
    OrderStatus.cancelled => Icons.cancel_outlined,
  };
}
