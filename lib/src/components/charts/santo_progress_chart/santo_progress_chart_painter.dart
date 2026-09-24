

import 'package:santo_ui/src/theme/santo_theme.dart';
import 'package:flutter/material.dart';

/// 轨道淡底透明度(品牌色淡底)
const double _kTrackOpacity = 0.12;

/// 绘制 SantoProgressChart 进度条
class SantoProgressChartPainter extends CustomPainter {
  /// 进度值
  final double value;

  /// 动画
  final Animation<double>? animation;

  /// 背景色,不传取主题 brandPrimary 淡色
  final Color? backgroundColor;

  /// 进度条颜色数组(多色时按渐变绘制),不传取主题 brandPrimary
  final List<Color>? colors;

  /// 圆角大小
  final double radius;

  /// 是否在进度值为最大的时候也展示圆角
  final bool alwaysShowRadius;

  SantoProgressChartPainter(
      {this.value = 0.2,
      this.animation,
      this.colors,
      this.backgroundColor,
      this.radius = 4,
      this.alwaysShowRadius = true})
      : super(repaint: animation){
    assert(colors == null || colors!.isNotEmpty, 'colors must not be empty');
  }

  @override
  void paint(Canvas canvas, Size size) {
    final SantoCommonConfig commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final List<Color> resolvedColors =
        colors ?? <Color>[commonConfig.brandPrimary, commonConfig.brandPrimary];
    final Color resolvedBackgroundColor =
        backgroundColor ?? commonConfig.brandPrimary.withOpacity(_kTrackOpacity);

    final double curValue = animation?.value ?? this.value;
    Paint backgroundPaint = Paint()
      ..color = resolvedBackgroundColor
      ..style = PaintingStyle.fill;

    Rect backgroundRect = Rect.fromLTWH(0, 0, size.width, size.height);
    if (this.alwaysShowRadius) {
      RRect backgroundRRect = RRect.fromRectAndCorners(backgroundRect,
          bottomRight: Radius.circular(curValue < 1 ? 0 : this.radius),
          topRight: Radius.circular(curValue < 1 ? 0 : this.radius));
      canvas.drawRRect(backgroundRRect, backgroundPaint);
    } else {
      canvas.drawRect(backgroundRect, backgroundPaint);
    }

    Rect progressBarRect = Rect.fromLTWH(0, 0, size.width * curValue, size.height);

    RRect progressBarRRect = RRect.fromRectAndCorners(progressBarRect,
        bottomRight: Radius.circular(
            1 == curValue && false == this.alwaysShowRadius ? 0 : this.radius),
        topRight: Radius.circular(
            1 == curValue && false == this.alwaysShowRadius ? 0 : this.radius));
    final bool isNotSingleColor = resolvedColors.length > 1;
    Paint progressBarPaint = Paint();
    if (isNotSingleColor) {
      progressBarPaint.shader = LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              tileMode: TileMode.clamp,
              colors: resolvedColors)
          .createShader(progressBarRect);
    } else {
      progressBarPaint.color = resolvedColors[0];
    }

    canvas.drawRRect(progressBarRRect, progressBarPaint);
  }

  @override
  bool shouldRepaint(SantoProgressChartPainter oldDelegate) {
    return false;
  }
}
