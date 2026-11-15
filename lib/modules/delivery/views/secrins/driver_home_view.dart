import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wassalni/core/Extenstion/context_x.dart';
import 'package:wassalni/core/enum/orderstatus.dart';
import 'package:wassalni/core/enum/user_role.dart';
import 'package:wassalni/core/theme/Appcolors.dart';
import 'package:wassalni/modules/orders/controllers/OrdersControler.dart';
import 'package:wassalni/modules/orders/views/secrins/orders_view.dart';
import 'package:wassalni/modules/shared/common_widgets.dart';
import 'package:wassalni/modules/shared/widgets/empty_state.dart';
import 'package:wassalni/modules/shared/widgets/loading_button.dart';
import 'package:wassalni/modules/shared/widgets/order_card.dart';
import 'package:wassalni/modules/shared/widgets/section_title.dart';

/// الرئيسية في وضع السائق: حالة الاتصال + التوصيل الحالي + الطلبات المتاحة
class DriverHomeView extends GetView<OrderController> {
  const DriverHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const _OnlineToggleCard(),
        const SizedBox(height: 16),
        _CurrentDeliverySection(controller: controller),
        _AvailableOrdersSection(controller: controller),
      ],
    );
  }
}

/// بطاقة تبديل "متصل / غير متصل"
/// (الطلبات المتاحة تظهر فقط عندما يكون السائق متصلاً)
final RxBool driverOnline = true.obs;

class _OnlineToggleCard extends StatelessWidget {
  const _OnlineToggleCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Obx(() {
        final on = driverOnline.value;
        return Row(
          children: [
            CircleAvatar(
              radius: 6,
              backgroundColor: on ? AppColors.success : context.mutedColor,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                on ? 'online'.tr : 'offline'.tr,
                style: context.text.titleMedium,
              ),
            ),
            Switch(value: on, onChanged: (v) => driverOnline.value = v),
          ],
        );
      }),
    );
  }
}

/// التوصيل الحالي للسائق: أول طلب مقبول أو قيد التوصيل
class _CurrentDeliverySection extends StatelessWidget {
  const _CurrentDeliverySection({required this.controller});

  final OrderController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final current = controller.myOrders
          .map(orderToCard)
          .where((d) =>
              d.status == OrderStatus.confirmed ||
              d.status == OrderStatus.delivering)
          .toList();
      if (current.isEmpty) return const SizedBox.shrink();

      final d = current.first;
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle('current_delivery'.tr, icon: Icons.route_outlined),
            const SizedBox(height: 10),
            OrderCard(
              data: d,
              actions: orderActions(controller, UserRole.delivery, d),
            ),
          ],
        ),
      );
    });
  }
}

/// قائمة الطلبات المتاحة (Stream لحظي) مع زر القبول
class _AvailableOrdersSection extends StatelessWidget {
  const _AvailableOrdersSection({required this.controller});

  final OrderController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!driverOnline.value) return const SizedBox.shrink();
      final orders = controller.availableOrders;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            'available_orders'.tr,
            icon: Icons.inbox_outlined,
            trailing: Text('${orders.length}', style: context.text.titleMedium),
          ),
          const SizedBox(height: 10),
          if (orders.isEmpty)
            SizedBox(
              height: 160,
              child: EmptyState(
                icon: Icons.hourglass_empty_rounded,
                message: 'no_orders'.tr,
              ),
            )
          else
            for (final o in orders) ...[
              _availableCard(orderToCard(o)),
              const SizedBox(height: 12),
            ],
        ],
      );
    });
  }

  /// بطاقة طلب متاح مع زر "قبول"
  Widget _availableCard(OrderCardData d) {
    return OrderCard(
      data: d,
      actions: [
        LoadingButton(
          label: 'accept'.tr,
          icon: Icons.check_rounded,
          isLoading: controller.isLoading.value,
          onPressed: () => controller.accept(d.id),
        ),
      ],
    );
  }
}
