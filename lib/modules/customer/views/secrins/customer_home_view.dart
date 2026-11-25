import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wassalni/core/enum/orderstatus.dart';
import 'package:wassalni/core/enum/user_role.dart';
import 'package:wassalni/modules/customer/controllers/customerController.dart';
import 'package:wassalni/modules/map/view_map.dart';
import 'package:wassalni/modules/orders/controllers/OrdersControler.dart';
import 'package:wassalni/modules/orders/views/secrins/orders_view.dart';
import 'package:wassalni/modules/shared/common_widgets.dart';
import 'package:wassalni/modules/shared/widgets/loading_button.dart';
import 'package:wassalni/modules/shared/widgets/order_card.dart';
import 'package:wassalni/modules/shared/widgets/section_title.dart';

/// الرئيسية في وضع الزبون: الطلب الجاري (إن وُجد) + نموذج طلب جديد
class CustomerHomeView extends GetView<OrderController> {
  const CustomerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        MapTalivo(height: 300),
        _ActiveOrderSection(controller: controller),
        const SizedBox(height: 20),
        const _NewOrderForm(),
      ],
    );
  }
}

/// بطاقة الطلب الجاري: أول طلب غير منتهٍ في قائمة الزبون
class _ActiveOrderSection extends StatelessWidget {
  const _ActiveOrderSection({required this.controller});

  final OrderController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // نأخذ أول طلب ما زال جارياً
      final active = controller.myOrders
          .map(orderToCard)
          .where((d) => d.status.isActive)
          .toList();
      if (active.isEmpty) return const SizedBox.shrink();

      final d = active.first;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle('active_order'.tr, icon: Icons.local_shipping_outlined),
          const SizedBox(height: 10),
          OrderCard(
            data: d,
            actions: orderActions(controller, UserRole.customer, d),
          ),
        ],
      );
    });
  }
}

class _NewOrderForm extends GetView<Customercontroller> {
  const _NewOrderForm();

  @override
  Widget build(BuildContext context) {
    final orders = Get.find<OrderController>();
    return AppCard(
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle('new_order'.tr, icon: Icons.add_box_outlined),
            const SizedBox(height: 16),
            //نقطة الانطلاق
            _field(
              controller.pickupCtrl,
              'pickup'.tr,
              Icons.my_location,
              validator: controller.required, f: controller.pickup,
            ),
            const SizedBox(height: 12),
            // نقطة الوصول
            _field(
              controller.dropoffCtrl,
              'dropoff'.tr,
              Icons.location_on_outlined,
              validator: controller.required, f: controller.dropoff,
            ),
            //الملاحظة
            const SizedBox(height: 12),
            TextField(
              controller: controller.noteCtrl,
              maxLines: 2,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.noteCtrl.clear();
                  },
                ),
                labelText: 'note'.tr,
                prefixIcon: Icon(Icons.notes_rounded),
              ),
            ),
   
            const SizedBox(height: 16),
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: LoadingButton(
                  label: 'send_order'.tr,
                  icon: Icons.send_rounded,
                  isLoading: orders.isLoading.value,
                  onPressed: controller.submit,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    String? Function(String?)? validator,
    int lines = 1,
    required PlaceSearchField f,
  }) {
    return Column(
      children: [
        Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(12),
          child: TextFormField(
            controller: ctrl,
            validator: validator,
            maxLines: lines,
            onEditingComplete: () {
              // isLoading.value = false;
              // FocusScope.of(context).nextFocus(); // الانتقال للحقل التالي
            },
            onChanged: (value) {
              f.query.value = value;
            },
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              labelText: label,
              suffixIcon: Obx(
                () => f.isLoading.value
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          ctrl.clear();
                          f.query.value = '';
                          f.results.clear();
                        },
                      ),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
        ),

        Obx(() {
          if (f.results.isEmpty) {
            return const SizedBox.shrink();
          }
          return Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 240),
              child: f.results.isEmpty
                  ? SizedBox.shrink()
                  : ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: f.results.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final p = f.results[i];

                        return ListTile(
                          leading: const Icon(Icons.location_on_outlined),
                          title: Text(
                            p.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(p.address),
                          onTap: () => controller.onSelected(p),
                        );
                      },
                    ),
            ),
          );
        }),
      ],
    );
  }
}
