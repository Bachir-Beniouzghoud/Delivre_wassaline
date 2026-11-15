import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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
        key: controller.FormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle('new_order'.tr, icon: Icons.add_box_outlined),
            const SizedBox(height: 16),
            _field(
              controller.pickupCtrl,
              'pickup'.tr,
              Icons.my_location,
              validator: controller.required,
            ),
            const SizedBox(height: 12),
            _field(
              controller.dropoffCtrl,
              'dropoff'.tr,
              Icons.location_on_outlined,
              validator: controller.required,
            ),
            const SizedBox(height: 12),
            _field(
              controller.noteCtrl,
              'note'.tr,
              Icons.notes_rounded,
              lines: 2,
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
  }) {
    return TextFormField(
      controller: ctrl,
      validator: validator,
      maxLines: lines,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
    );
  }
}

/// نموذج طلب توصيل جديد
// class _NewOrderForm extends StatefulWidget {
//   const _NewOrderForm();

//   @override
//   State<_NewOrderForm> createState() => _NewOrderFormState();
// }

// class _NewOrderFormState extends State<_NewOrderForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _pickup = TextEditingController();
//   final _dropoff = TextEditingController();
//   final _note = TextEditingController();

//   @override
//   void dispose() {
//     // تحرير المتحكمات لتفادي تسرب الذاكرة
//     _pickup.dispose();
//     _dropoff.dispose();
//     _note.dispose();
//     super.dispose();
//   }

//   /// تحقق مشترك لحقول العنوان
//   String? _required(String? v) =>
//       (v == null || v.trim().isEmpty) ? 'required_field'.tr : null;

//   /// إرسال الطلب
//   void _submit() {
//     if (!_formKey.currentState!.validate()) return;
//     // TODO: ابنِ OrderModel من الحقول ثم استدع:
//     // Get.find<OrderController>().createOrder(order);
//     // (يجب أن يأتي customerId من المستخدم المسجل لا من الواجهة)
//     Get.snackbar('', 'soon'.tr);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final c = Get.find<OrderController>();
//     return AppCard(
//       child: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SectionTitle('new_order'.tr, icon: Icons.add_box_outlined),
//             const SizedBox(height: 16),
//             _field(
//               _pickup,
//               'pickup'.tr,
//               Icons.my_location,
//               validator: _required,
//             ),
//             const SizedBox(height: 12),
//             _field(
//               _dropoff,
//               'dropoff'.tr,
//               Icons.location_on_outlined,
//               validator: _required,
//             ),
//             const SizedBox(height: 12),
//             _field(_note, 'note'.tr, Icons.notes_rounded, lines: 2),
//             const SizedBox(height: 16),
//             // زر الإرسال يتعطل أثناء أي عملية جارية
//             Obx(
//               () => SizedBox(
//                 width: double.infinity,
//                 child: LoadingButton(
//                   label: 'send_order'.tr,
//                   icon: Icons.send_rounded,
//                   isLoading: c.isLoading.value,
//                   onPressed: _submit,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// حقل إدخال موحّد (الثيم يتولى الألوان والحدود)
//   Widget _field(
//     TextEditingController ctrl,
//     String label,
//     IconData icon, {
//     String? Function(String?)? validator,
//     int lines = 1,
//   }) {
//     return TextFormField(
//       controller: ctrl,
//       validator: validator,
//       maxLines: lines,
//       decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
//     );
//   }
// }
