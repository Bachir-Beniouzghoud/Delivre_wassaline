import 'package:flutter/material.dart';
import 'package:wassalni/core/Extenstion/context_x.dart';
import 'package:wassalni/modules/shared/widgets/empty_state.dart';
import 'package:wassalni/modules/shared/widgets/loading_button.dart';
import 'package:wassalni/modules/shared/widgets/order_card.dart';
import 'package:get/get.dart';
import 'package:wassalni/core/enum/orderstatus.dart';
import 'package:wassalni/core/enum/user_role.dart';
import 'package:wassalni/data/models/order/ordermodel.dart';
import 'package:wassalni/modules/orders/controllers/OrdersControler.dart';

/// ⚠️ نقطة الربط الوحيدة بين OrderModel وبطاقة العرض.
/// عدّل أسماء الحقول هنا فقط لتطابق نموذجك، ولا تلمس بقية الشاشات.
OrderCardData orderToCard(OrderModel o) => OrderCardData(
  id: o.uid!,
  status: o.status,
  pickupAddress: o.pickup.address, // TODO
  dropoffAddress: o.dropoff.address, // TODO
  price: o.price == null ? null : '${o.price} د.ج', // TODO
);

/// شاشة الطلبات: تبويبات فلترة بالحالة + قائمة بطاقات
/// تصلح للزبون وللسائق (الـ Controller يجلب حسب الدور)
class OrdersView extends GetView<OrderController> {
  const OrdersView({super.key, required this.role});

  /// الدور يحدد الأزرار الظاهرة على كل بطاقة
  final UserRole role;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StatusFilterBar(controller: controller),
        Expanded(
          child: _OrdersList(controller: controller, role: role),
        ),
      ],
    );
  }
}

/// شريط شرائح الفلترة: الكل + كل حالة
class _StatusFilterBar extends StatelessWidget {
  const _StatusFilterBar({required this.controller});

  final OrderController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Obx(() {
        final selected = controller.selectedStatus.value;
        return ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          children: [
            _chip(
              context,
              'filter_all'.tr,
              selected == null,
              () => controller.filterByStatus(null),
            ),
            for (final s in OrderStatus.values)
              _chip(
                context,
                s.label,
                selected == s,
                () => controller.filterByStatus(s),
                color: s.color,
              ),
          ],
        );
      }),
    );
  }

  /// شريحة واحدة (دالة مساعدة لتفادي التكرار)
  Widget _chip(
    BuildContext context,
    String label,
    bool selected,
    VoidCallback onTap, {
    Color? color,
  }) {
    final c = color ?? context.cs.primary;
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: c.withValues(alpha: 0.18),
        labelStyle: TextStyle(
          color: selected ? c : context.mutedColor,
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide(color: selected ? c : context.borderColor),
        showCheckmark: false,
      ),
    );
  }
}

/// قائمة الطلبات مع سحب للتحديث وحالة الفراغ
class _OrdersList extends StatelessWidget {
  const _OrdersList({required this.controller, required this.role});

  final OrderController controller;
  final UserRole role;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final orders = controller.myOrders;
      if (controller.isLoading.value && orders.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (orders.isEmpty) {
        return EmptyState(
          icon: Icons.inventory_2_outlined,
          message: 'no_orders'.tr,
        );
      }
      return RefreshIndicator(
        onRefresh: controller.loadMyOrders,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          itemCount: orders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) {
            final o = orders[i];
            final card = orderToCard(o);
            return OrderCard(
              data: card,
              actions: orderActions(controller, role, card),
            );
          },
        ),
      );
    });
  }
}

/// الأزرار المناسبة لكل بطاقة حسب الدور والحالة
/// دالة عامة: تُستعمل أيضاً في شاشات الرئيسية لتفادي التكرار
List<Widget> orderActions(OrderController c, UserRole role, OrderCardData d) {
  // الحالة المنتهية: لا أزرار
  if (!d.status.isActive) return const [];

  if (role == UserRole.customer) {
    // الزبون يلغي فقط، وفق قواعد canChangeTo
    return [
      LoadingButton(
        label: 'cancel_order'.tr,
        outlined: true,
        isLoading: c.isLoading.value,
        onPressed: () => c.cancel(d.id),
      ),
    ];
  }

  // السائق: بدء التوصيل ثم التسليم
  return switch (d.status) {
    OrderStatus.confirmed => [
      LoadingButton(
        label: 'start_delivery'.tr,
        icon: Icons.play_arrow_rounded,
        isLoading: c.isLoading.value,
        onPressed: () => c.startDelivery(d.id),
      ),
    ],
    OrderStatus.delivering => [
      LoadingButton(
        label: 'complete'.tr,
        icon: Icons.task_alt_rounded,
        isLoading: c.isLoading.value,
        onPressed: () => c.complete(d.id),
      ),
    ],
    _ => const [],
  };
}
