import 'package:flutter/material.dart';
import 'package:wassalni/core/Extenstion/context_x.dart';

/// عنوان قسم مع أيقونة اختيارية وعنصر في الطرف الآخر
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.icon, this.trailing});

  final String title;
  final IconData? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: context.cs.primary),
          const SizedBox(width: 8),
        ],
        Expanded(child: Text(title, style: context.text.titleLarge)),
        ?trailing,
      ],
    );
  }
}
