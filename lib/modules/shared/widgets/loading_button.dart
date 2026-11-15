import 'package:flutter/material.dart';

/// زر أساسي يعرض مؤشر تحميل ويتعطل أثناء العملية
class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.outlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  /// true = زر ثانوي بحدود (مثل الإلغاء)
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
              Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
            ],
          );
    final action = isLoading ? null : onPressed;
    return outlined
        ? OutlinedButton(onPressed: action, child: child)
        : FilledButton(onPressed: action, child: child);
  }
}
