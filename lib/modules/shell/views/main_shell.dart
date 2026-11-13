import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:wassalni/modules/shell/controllers/mode_controller.dart';

class _ShellTapNavigation {
  /// مفتاح الترجمة للعنوان
  final String labelKey;
  final IconData icon;
  final IconData selectedIcon;
  final Widget page;
  _ShellTapNavigation({
    required this.labelKey,
    required this.icon,
    required this.selectedIcon,
    required this.page,
  });

  /// تبويبات وضع الزبون
}

/// الهيكل الرئيسي: شريط علوي + محتوى التبويب + شريط تنقل سفلي
/// يتغير المحتوى والتبويبات حسب الوضع (زبون/سائق)
class MainShell extends GetView<ModeController> {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Center();
  }
}
