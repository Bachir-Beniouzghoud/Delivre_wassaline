import 'package:flutter/material.dart';
import 'package:wassalni/modules/shared/widgets/empty_state.dart';

/// شاشة مؤقتة لما لم يُبنَ بعد (التتبع المباشر، الإحصائيات)
class ComingSoonView extends StatelessWidget {
  const ComingSoonView({super.key, required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return EmptyState(icon: icon, message: title);
  }
}
