import 'package:flutter/material.dart';
import 'package:wassalni/core/Extenstion/context_x.dart';

/// سطر عنوان (نقطة ملوّنة + اسم النقطة + العنوان) لنقطتي الاستلام والتسليم
class AddressRow extends StatelessWidget {
  const AddressRow({
    super.key,
    required this.label,
    required this.address,
    required this.dotColor,
  });

  final String label;
  final String address;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: CircleAvatar(radius: 5, backgroundColor: dotColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: context.text.bodySmall),
              const SizedBox(height: 2),
              Text(
                address,
                style: context.text.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
