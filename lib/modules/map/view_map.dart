import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:wassalni/modules/map/map_controller.dart';

class MapTalivo extends GetView<mapController> {
  double height;
  MapTalivo({super.key, required this.height});
  final _mapController = MapController();
  // ifVX5aqYvb9crbAdMbrU
  /// مصفوفة تقلب الألوان وتخفف السطوع حتى لا تبهر العين
  final _darkFilter = ColorFilter.matrix(<double>[
    -0.85,
    0,
    0,
    0,
    235,
    0,
    -0.85,
    0,
    0,
    235,
    0,
    0,
    -0.85,
    0,
    245,
    0,
    0,
    0,
    1,
    0,
  ]);
  @override
  Widget build(BuildContext context) {
    debugPrint('MapTiler active: ${MapConfig.hasKey}');

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // للتحكم في الخريطة برمجياً (تحريكها، تغيير الزوم...).
    /*
   _c.results.clear();                          // إخفاء قائمة النتائج
    mapController.move(place.posetion, 17);     // تحريك الخريطة مع زوم 17
  */
    return SizedBox(
      height: height,
      width: 200,
      // ===== الطبقة الأولى: الخريطة =====
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FlutterMap(
          mapController: _mapController,
          options: const MapOptions(
            initialCenter: LatLng(33.7848927, 3.1427),
            initialZoom: 13,

            // الخريطة تأخذ حركات اللمس ولا تحركها القائمة
            interactionOptions: InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: MapConfig.tileUrl(dark: isDark),
              tileDimension: MapConfig.tileDimension,
              zoomOffset: MapConfig.zoomOffset,
              userAgentPackageName: 'com.example.wassalni',
              tileBuilder: MapConfig.needsDarkFilter(dark: isDark)
                  ? (context, tileWidget, tile) => ColorFiltered(
                      colorFilter: _darkFilter,
                      child: tileWidget,
                    )
                  : null,
            ),

            // MapTiler تشترط بقاء الشعار والإشارة للمصدر في الخطة المجانية
            const RichAttributionWidget(
              attributions: [TextSourceAttribution(MapConfig.attribution)],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(33.7848927, 3.1427),
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
            // Obx(() {
            //   final point = controller.selected.value;
            //   if (point == null) return const SizedBox.shrink();
            //   return MarkerLayer(
            //     markers: [
            //       Marker(
            //         point: point,
            //         width: 40,
            //         height: 40,
            //         child: const Icon(
            //           Icons.location_pin,
            //           color: Colors.red,
            //           size: 40,
            //         ),
            //       ),
            //     ],
            //   );
            // }),
            const RichAttributionWidget(
              attributions: [
                TextSourceAttribution('OpenStreetMap contributors'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// إعدادات الخريطة في مكان واحد. تغيير المزود لاحقاً يتم هنا فقط.
class MapConfig {
  // يُقرأ وقت البناء من --dart-define. إن لم يُمرَّر يكون نصاً فارغاً.
  static const _key = String.fromEnvironment("P9Qz2W8PPjnQVpV8ZQj3");

  /// هل المفتاح موجود؟ وإلا نستخدم OSM كاحتياطي.
  static bool get hasKey => _key.isNotEmpty;

  static String tileUrl({required bool dark}) {
    print("*********_key.length**${_key}");
    // if (!hasKey)
    // return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
    final style = dark
        ? 'dataviz-dark'
        : 'streets-v2'; // تحقق من الأسماء في لوحتك
    return 'https://api.maptiler.com/maps/$style/{z}/{x}/{y}@2x.png?key=$_key';
  }
  // tiles الـ @2x أبعادها 512 بدل 256
  static int get tileDimension => hasKey ? 512 : 256;
  static double get zoomOffset => hasKey ? -1 : 0;

  /// الفلتر اللوني فقط مع OSM الاحتياطي (MapTiler لها style داكن جاهز)
  static bool needsDarkFilter({required bool dark}) => dark && !hasKey;

  static const attribution = '© MapTiler © OpenStreetMap contributors';
}
