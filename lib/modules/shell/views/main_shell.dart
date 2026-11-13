import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:wassalni/core/enum/app_mode.dart';
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

/// تبويبات وضع الزبون
List<_ShellTapNavigation> _customerTabs() => [
  _ShellTapNavigation(
    labelKey: 'nav_home',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded,
    page: Container(child: Text("nav_home")),

    ///CustomerHomeView(),
  ),
  _ShellTapNavigation(
    labelKey: 'nav_tracking',
    icon: Icons.location_on_outlined,
    selectedIcon: Icons.location_on,
    page: Container(child: Text("nav_tracking")),

    ///ComingSoonView(icon: Icons.map_outlined, title: 'soon'.tr),
  ),
  _ShellTapNavigation(
    labelKey: 'nav_orders',
    icon: Icons.inventory_2_outlined,
    selectedIcon: Icons.inventory_2,
    page: Container(
      child: Text("nav_orders"),
    ), // OrdersView(role: UserRole.customer),
  ),
  _ShellTapNavigation(
    labelKey: 'nav_profile',
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
    page: Container(child: Text("nav_profile")),

    /// ComingSoonView(icon: Icons.person_outline, title: 'soon'.tr),
  ),
  _ShellTapNavigation(
    labelKey: 'nav_settings',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
    page: Container(child: Text("nav_settings")), //SettingsView(),
  ),
];
//******************************************************* */
//******************************************************* */
//******************************************************* */
/// تبويبات وضع السائق
List<_ShellTapNavigation> _driverTabs() => [
  _ShellTapNavigation(
    labelKey: 'nav_driver_home',
    icon: Icons.explore_outlined,
    selectedIcon: Icons.explore,
    page: Container(child: Text("nav_driver_home")), //DriverHomeView(),
  ),
  _ShellTapNavigation(
    labelKey: 'nav_tracking',
    icon: Icons.location_on_outlined,
    selectedIcon: Icons.location_on,
    page: Container(child: Text("nav_tracking")),

    ///ComingSoonView(icon: Icons.map_outlined, title: 'soon'.tr),
  ),
  _ShellTapNavigation(
    labelKey: 'nav_orders',
    icon: Icons.inventory_2_outlined,
    selectedIcon: Icons.inventory_2,
    page: Container(child: Text("nav_orders")),

    ///OrdersView(role: UserRole.delivery),
  ),
  _ShellTapNavigation(
    labelKey: 'nav_stats',
    icon: Icons.trending_up_outlined,
    selectedIcon: Icons.trending_up,
    page: Container(child: Text("nav_stats")),

    /// ComingSoonView(icon: Icons.bar_chart_rounded, title: 'soon'.tr),
  ),
  _ShellTapNavigation(
    labelKey: 'nav_settings',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
    page: Container(child: Text("nav_settings")), //SettingsView(),
  ),
];

/// الهيكل الرئيسي: شريط علوي + محتوى التبويب + شريط تنقل سفلي
/// يتغير المحتوى والتبويبات حسب الوضع (زبون/سائق)
class MainShell extends GetView<ModeController> {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final mode = controller.mode.value;
      final tab = mode == AppMode.driver ? _driverTabs() : _customerTabs();
      final index = controller.tabIndex.value.clamp(0, tab.length - 1);
      return Scaffold(
        body: IndexedStack(
          key: ValueKey(mode),
          children: [
            for (final t in tab) t.page,

            //ارجاع الصفحات الموجود في كل حالة
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: controller.selectTab,
          destinations: [
            for (final t in tab)
              NavigationDestination(icon: Icon(t.icon), label: t.labelKey.tr),
          ],
        ),
      );
    });
  }
}
