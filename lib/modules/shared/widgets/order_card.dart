import 'package:flutter/material.dart';
import 'package:wassalni/core/Extenstion/context_x.dart';
import 'package:wassalni/core/enum/orderstatus.dart';
import 'package:wassalni/core/theme/Appcolors.dart';
import 'package:get/get.dart';
import 'package:wassalni/modules/shared/common_widgets.dart';
import 'package:wassalni/modules/shared/widgets/address_row.dart';
import 'package:wassalni/modules/shared/widgets/status_badge.dart';

/// بيانات العرض فقط (بدون أي اعتماد على Firestore أو OrderModel)
/// عند ربط الشاشات حوّل OrderModel إلى هذا الكائن في مكان واحد فقط
class OrderCardData {
  const OrderCardData({
    required this.id,
    required this.status,
    required this.pickupAddress,
    required this.dropoffAddress,
    this.price,
  });

  final String id;
  final OrderStatus status;
  final String pickupAddress;
  final String dropoffAddress;

  /// السعر نصاً جاهزاً للعرض، مثل: 650 د.ج
  final String? price;
}

/// بطاقة طلب واحدة: الحالة + نقطتا الاستلام والتسليم + أزرار الإجراءات
/// الأزرار تُمرَّر من الخارج، فتصلح للزبون وللسائق معاً
class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.data,
    this.actions = const [],
    this.onTap,
  });

  final OrderCardData data;

  /// أزرار أسفل البطاقة (قبول، إلغاء، بدء التوصيل...)
  final List<Widget> actions;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الصف العلوي: السعر والحالة
          Row(
            children: [
              if (data.price != null)
                Text(
                  data.price!,
                  style: context.text.titleLarge?.copyWith(
                    color: context.cs.primary,
                  ),
                ),
              const Spacer(),
              StatusBadge(data.status),
            ],
          ),
          const SizedBox(height: 14),
          AddressRow(
            label: 'pickup'.tr,
            address: data.pickupAddress,
            dotColor: AppColors.success,
          ),
          const SizedBox(height: 12),
          AddressRow(
            label: 'dropoff'.tr,
            address: data.dropoffAddress,
            dotColor: AppColors.info,
          ),
          if (actions.isNotEmpty) ...[
            const SizedBox(height: 14),
            Divider(color: context.borderColor),
            const SizedBox(height: 10),
            Row(
              children: [
                for (var i = 0; i < actions.length; i++) ...[
                  if (i > 0) const SizedBox(width: 10),
                  Expanded(child: actions[i]),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
