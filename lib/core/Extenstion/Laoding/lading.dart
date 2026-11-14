// import 'dart:math' as math;

// import 'package:flutter/material.dart';

// import 'package:get/get.dart';
// import 'package:wassalni/core/Extenstion/Laoding/contrllerLoding.dart';
// import 'package:wassalni/core/theme/Appcolors.dart';

// // class AppLoader extends StatefulWidget {
// // // حجم مؤشر التحميل
// // final double size;

// // // سماكة الحلقة
// // final double strokeWidth;

// // // إظهار اسم التطبيق
// // final bool showBrand;

// // // إظهار رسالة التحميل
// // final bool showLabel;

// // // نص مخصص
// // final String? label;

// // // Controller اختياري للتحكم في التقدم
// // final AppLoaderController? controller;

// // const AppLoader({
// //   super.key,
// //   this.size = 76,
// //   this.strokeWidth = 4,
// //   this.showBrand = true,
// //   this.showLabel = true,
// //   this.label,
// //   this.controller,
// // });

// //   @override
// //   State<AppLoader> createState() => _AppLoaderState();
// // }

// class AppLoader extends GetView<AppLoaderController> {
//   // حجم مؤشر التحميل
//   final double size;

//   // سماكة الحلقة
//   final double strokeWidth;

//   // إظهار اسم التطبيق
//   final bool showBrand;

//   // إظهار رسالة التحميل
//   final bool showLabel;

//   // نص مخصص
//   final String? label;

//   // Controller اختياري للتحكم في التقدم
//   // AppLoaderController? get controller => null;

//   const AppLoader({
//     super.key,
//     this.size = 76,
//     this.strokeWidth = 4,
//     this.showBrand = true,
//     this.showLabel = true,
//     this.label,
//     // this.controller,
//   });

//   // @override
//   // void initState() {
//   //   super.initState();

//   // }

//   // @override
//   // void dispose() {
//   //   // التخلص من Animation عند إزالة Widget
//   //   _animationController.dispose();

//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;

//     final trackColor = isDark
//         ? Colors.white.withValues(alpha: 0.12)
//         : AppColors.border;

//     final primaryColor = theme.colorScheme.primary;
//     final accentColor = AppColors.brandAccent;

//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // مؤشر التحميل
//         SizedBox(
//           width: size,
//           height: size,

//           child: Obx(() {
//             final c = controller;

//             final isIndeterminate = c?.isIndeterminate.value ?? true;

//             final progress = c?.progress.value ?? 0.0;

//             return AnimatedBuilder(
//               animation: controller.animationController,

//               builder: (context, child) {
//                 return Transform.rotate(
//                   angle: isIndeterminate
//                       ? controller.animationController.value * 2 * math.pi
//                       : 0,

//                   child: CustomPaint(
//                     size: Size(size, size),

//                     painter: AppLoaderPainter(
//                       strokeWidth: strokeWidth,

//                       progress: progress,

//                       isIndeterminate: isIndeterminate,

//                       colors: [accentColor, primaryColor, accentColor],

//                       trackColor: trackColor,
//                     ),
//                   ),
//                 );
//               },
//             );
//           }),
//         ),

//         const SizedBox(height: 10),

//         // شعار التطبيق
//         Container(
//           width: size * 0.40,
//           height: size * 0.40,

//           decoration: BoxDecoration(
//             color: primaryColor.withValues(alpha: 0.10),
//             shape: BoxShape.circle,

//             border: Border.all(
//               color: accentColor.withValues(alpha: 0.45),
//               width: 1,
//             ),
//           ),

//           child: Center(
//             child: Text(
//               'T',
//               style: theme.textTheme.titleLarge?.copyWith(
//                 color: primaryColor,
//                 fontWeight: FontWeight.w900,
//                 fontSize: size * 0.19,
//               ),
//             ),
//           ),
//         ),

//         // اسم TALIVO
//         if (showBrand) ...[
//           const SizedBox(height: 14),

//           Text(
//             'TALIVO',
//             style: theme.textTheme.titleMedium?.copyWith(
//               fontWeight: FontWeight.w900,
//               letterSpacing: 3,
//               color: theme.colorScheme.onSurface,
//             ),
//           ),
//         ],

//         // رسالة التحميل
//         if (showLabel) ...[
//           const SizedBox(height: 8),

//           Obx(() {
//             final message =
//                 label ??
//                 controller?.statusMessage.value ??
//                 "70".tr;

//             return AnimatedSwitcher(
//               duration: const Duration(milliseconds: 250),

//               child: Text(
//                 message,
//                 key: ValueKey(message),

//                 textAlign: TextAlign.center,

//                 style: theme.textTheme.bodySmall?.copyWith(
//                   color: theme.colorScheme.onSurface.withValues(alpha: 0.65),

//                   fontWeight: FontWeight.w600,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//             );
//           }),
//         ],

//         // عرض نسبة التقدم عند وجود تحميل محدد
//         if (controller != null) ...[
//           const SizedBox(height: 8),

//           Obx(() {
//             final c = controller!;

//             if (c.isIndeterminate.value) {
//               return const SizedBox.shrink();
//             }

//             return Text(
//               '${c.progress.value.toInt()}%',
//               style: theme.textTheme.bodySmall?.copyWith(
//                 color: primaryColor,
//                 fontWeight: FontWeight.bold,
//               ),
//             );
//           }),
//         ],
//       ],
//     );
//   }
// }

// class AppLoaderPainter extends CustomPainter {
//   final double strokeWidth;
//   final double progress;
//   final bool isIndeterminate;
//   final List<Color> colors;
//   final Color trackColor;

//   AppLoaderPainter({
//     required this.strokeWidth,
//     required this.progress,
//     required this.isIndeterminate,
//     required this.colors,
//     required this.trackColor,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);

//     final radius = (size.width - strokeWidth) / 2;

//     final rect = Rect.fromCircle(center: center, radius: radius);

//     // رسم المسار الخلفي للحلقة
//     final trackPaint = Paint()
//       ..color = trackColor
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth;

//     canvas.drawCircle(center, radius, trackPaint);

//     // تدرج ألوان TALIVO
//     final gradientPaint = Paint()
//       ..shader = SweepGradient(
//         colors: colors,
//         stops: const [0.0, 0.55, 1.0],
//       ).createShader(rect)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth
//       ..strokeCap = StrokeCap.round;

//     // تحديد طول القوس
//     final sweepAngle = isIndeterminate
//         ? math.pi * 1.55
//         : (progress / 100) * 2 * math.pi;

//     // رسم الحلقة المتدرجة
//     canvas.drawArc(rect, -math.pi / 2, sweepAngle, false, gradientPaint);
//   }

//   @override
//   bool shouldRepaint(covariant AppLoaderPainter oldDelegate) {
//     return oldDelegate.progress != progress ||
//         oldDelegate.isIndeterminate != isIndeterminate ||
//         oldDelegate.strokeWidth != strokeWidth ||
//         oldDelegate.colors != colors ||
//         oldDelegate.trackColor != trackColor;
//   }
// }

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wassalni/core/theme/Appcolors.dart';
import 'package:wassalni/core/Extenstion/Laoding/contrllerLoding.dart';

class AppLoader extends GetView<AppLoaderController> {

  final double size;
  final double strokeWidth;
  final bool showBrand;
  final bool showLabel;
  final String? label;

  const AppLoader({
    super.key,
    this.size = 76,
    this.strokeWidth = 4,
    this.showBrand = true,
    this.showLabel = true,
    this.label, 
   AppLoaderController ? controller,
  });

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final trackColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : AppColors.border;

    final primaryColor = theme.colorScheme.primary;
    final accentColor = AppColors.brandAccent;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        // Loading Indicator
        SizedBox(
          width: size,
          height: size,

          child: Obx(() {

            final isIndeterminate =
                controller.isIndeterminate.value;

            final progress = controller.progress.value;

            return AnimatedBuilder(
              animation: controller.animationController,

              builder: (context, child) {

                return Transform.rotate(
                  angle: isIndeterminate
                      ? controller.animationController.value *
                          2 * math.pi
                      : 0,

                  child: CustomPaint(
                    size: Size(size, size),

                    painter: AppLoaderPainter(
                      strokeWidth: strokeWidth,
                      progress: progress,
                      isIndeterminate: isIndeterminate,
                      colors: [
                        accentColor,
                        primaryColor,
                        accentColor,
                      ],
                      trackColor: trackColor,
                    ),
                  ),
                );
              },
            );
          }),
        ),

        const SizedBox(height: 10),

        // App Logo
        if (showBrand)
          Container(
            width: size * 0.40,
            height: size * 0.40,

            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.10),
              shape: BoxShape.circle,

              border: Border.all(
                color: accentColor.withValues(alpha: 0.45),
                width: 1,
              ),
            ),

            child: Center(
              child: Text(
                'T',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.w900,
                  fontSize: size * 0.19,
                ),
              ),
            ),
          ),

        // Brand Name
        if (showBrand) ...[
          const SizedBox(height: 14),

          Text(
            'TALIVO',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],

        // Loading Message
        if (showLabel) ...[
          const SizedBox(height: 8),

          Obx(() {

            final message =
                label ?? controller.statusMessage.value;

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),

              child: Text(
                message,
                key: ValueKey(message),
                textAlign: TextAlign.center,

                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.65),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            );
          }),
        ],

        // Progress Percentage
        Obx(() {
        
          if (controller.isIndeterminate.value) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.only(top: 8),

            child: Text(
              '${controller.progress.value.toInt()}%',

              style: theme.textTheme.bodySmall?.copyWith(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }),
      ],
    );
  }
}

// Custom Painter
class AppLoaderPainter extends CustomPainter {

  final double strokeWidth;
  final double progress;
  final bool isIndeterminate;
  final List<Color> colors;
  final Color trackColor;

  AppLoaderPainter({
    required this.strokeWidth,
    required this.progress,
    required this.isIndeterminate,
    required this.colors,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {

    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = (size.width - strokeWidth) / 2;

    final rect = Rect.fromCircle(
      center: center,
      radius: radius,
    );

    // Background Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    // Gradient
    final gradientPaint = Paint()
      ..shader = SweepGradient(
        colors: colors,
        stops: const [0.0, 0.55, 1.0],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = isIndeterminate
        ? math.pi * 1.55
        : (progress.clamp(0.0, 100.0) / 100) *
            2 * math.pi;

    canvas.drawArc(
      rect,
      -math.pi / 2,
      sweepAngle,
      false,
      gradientPaint,
    );
  }

  @override
  bool shouldRepaint(covariant AppLoaderPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isIndeterminate != isIndeterminate ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.colors != colors ||
        oldDelegate.trackColor != trackColor;
  }
}

