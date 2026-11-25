import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:wassalni/modules/map/map_controller.dart';

// ignore: must_be_immutable
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
      child: Stack(
        children: [
          //filde serche

          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: FlutterMap(
                mapController: _mapController,
                options: const MapOptions(
                  initialCenter: LatLng(33.7848927, 3.1427),
                  initialZoom: 13,

                  // الخريطة تأخذ حركات اللمس ولا تحركها القائمة
                  interactionOptions: InteractionOptions(
                    flags: InteractiveFlag.all & InteractiveFlag.rotate,
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
                    attributions: [
                      TextSourceAttribution(MapConfig.attribution),
                    ],
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

                  Obx(() {
                    final point = controller.selected.value;
                    if (point == null) return const SizedBox.shrink();
                    return MarkerLayer(
                      markers: [
                        Marker(
                          point: point,
                          width: 40,
                          height: 40,
                          child: IconButton(
                            onPressed: () async {
                              // await controller.search("قصر الحيران");
                              // print('***************');
                              // await controller.search("قصر الحيران حي ");
                              // print('*********;;;;;;;;kkkkkl******');
                            },
                            icon: const Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  const RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution('OpenStreetMap contributors'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ///Text filled sersh in map
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12),
                  child: TextField(
                    controller: controller.textController,
                    onChanged: (value) => controller.query.value = value,
                    decoration: InputDecoration(
                      hintText: 'ابحث عن مكان...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: Obx(
                        () => controller.isLoading.value
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  controller.textController.clear();
                                  controller.query.value = '';
                                  controller.results.clear();
                                },
                              ),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(14),
                    ),
                  ),
                ),

                Obx(() {
                  if (controller.results.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(12),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 240),
                      child:  controller.results.isEmpty ? SizedBox.shrink():ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: controller.results.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final p = controller.results[i];
  
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
            ),
          ),
        ],
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
    if (!hasKey) {
      return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
    }
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
