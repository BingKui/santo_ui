import 'dart:math' as math;

import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 分割线方向
enum SantoDividerOrientation {
  /// 水平分割线
  horizontal,

  /// 垂直分割线
  vertical,
}

/// 带标题文本时，标题相对分割线的位置（参考 antd titlePlacement）
enum SantoDividerTitlePlacement {
  /// 文本靠左，分割线在右侧
  start,

  /// 文本居中，分割线在两侧
  center,

  /// 文本靠右，分割线在左侧
  end,
}

/// 水平分割线的上下间距（参考 antd size）
///
/// 三档分别取主题 `vSpacingSm / vSpacingMd / vSpacingLg`(默认 10/15/20)。
enum SantoDividerSize {
  /// 上下间距取主题 vSpacingSm
  small,

  /// 上下间距取主题 vSpacingMd(默认)
  medium,

  /// 上下间距取主题 vSpacingLg
  large,
}

/// 分割线组件（参考 antd Divider）
///
/// 区隔内容的分割线，支持水平/垂直方向、实线/虚线、带标题文本（标题位置可配）。
///
/// 使用示例：
/// ```dart
/// SantoDivider(),
/// SantoDivider(child: Text('标题文本')),
/// SantoDivider(dashed: true, titlePlacement: SantoDividerTitlePlacement.start),
/// SantoDivider(orientation: SantoDividerOrientation.vertical),
/// ```
class SantoDivider extends StatelessWidget {
  /// 分割线方向，默认水平
  final SantoDividerOrientation orientation;

  /// 是否为虚线，默认 false
  final bool dashed;

  /// 标题内容，为 null 时渲染整条分割线
  final Widget? child;

  /// 标题位置，默认居中
  final SantoDividerTitlePlacement titlePlacement;

  /// 标题是否使用弱化样式（参考 antd plain），默认 false
  final bool plain;

  /// start/end 位置时，标题与最近边缘的距离，默认 12
  final double? titleMargin;

  /// 水平分割线的上下间距，默认[SantoDividerSize.medium]
  final SantoDividerSize size;

  /// 分割线颜色，默认使用主题分割线颜色
  final Color? color;

  /// 分割线粗细，默认 1
  final double thickness;

  /// 垂直分割线的高度，默认 16
  final double verticalHeight;

  /// 垂直分割线的左右间距，默认 8
  final double verticalMargin;

  const SantoDivider({
    Key? key,
    this.orientation = SantoDividerOrientation.horizontal,
    this.dashed = false,
    this.child,
    this.titlePlacement = SantoDividerTitlePlacement.center,
    this.plain = false,
    this.titleMargin,
    this.size = SantoDividerSize.medium,
    this.color,
    this.thickness = 1,
    this.verticalHeight = 16,
    this.verticalMargin = 8,
  }) : super(key: key);

  static const double _titleHorizontalPadding = 12;

  double get _verticalSpacing {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    switch (size) {
      case SantoDividerSize.small:
        return commonConfig.vSpacingSm;
      case SantoDividerSize.medium:
        return commonConfig.vSpacingMd;
      case SantoDividerSize.large:
        return commonConfig.vSpacingLg;
    }
  }

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final lineColor = color ?? commonConfig.dividerColorBase;

    if (orientation == SantoDividerOrientation.vertical) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: verticalMargin),
        child: SizedBox(
          height: verticalHeight,
          width: thickness,
          child: dashed
              ? CustomPaint(
                  painter: _DashedLinePainter(
                    color: lineColor,
                    thickness: thickness,
                    axis: Axis.vertical,
                  ),
                )
              : ColoredBox(color: lineColor),
        ),
      );
    }

    if (child == null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: _verticalSpacing),
        child: SizedBox(
          height: thickness,
          width: double.infinity,
          child: _buildLine(lineColor),
        ),
      );
    }

    final margin = titleMargin ?? _titleHorizontalPadding;
    final title = DefaultTextStyle.merge(
      style: TextStyle(
        fontSize: commonConfig.fontSizeBase,
        fontWeight: plain ? FontWeight.w400 : FontWeight.w500,
        color: plain
            ? commonConfig.colorTextSecondary
            : commonConfig.colorTextBase,
      ),
      child: child!,
    );

    Widget result;
    switch (titlePlacement) {
      case SantoDividerTitlePlacement.start:
        result = Row(
          children: [
            SizedBox(width: margin),
            title,
            SizedBox(width: _titleHorizontalPadding),
            Expanded(
              child: SizedBox(height: thickness, child: _buildLine(lineColor)),
            ),
          ],
        );
        break;
      case SantoDividerTitlePlacement.end:
        result = Row(
          children: [
            Expanded(
              child: SizedBox(height: thickness, child: _buildLine(lineColor)),
            ),
            SizedBox(width: _titleHorizontalPadding),
            title,
            SizedBox(width: margin),
          ],
        );
        break;
      case SantoDividerTitlePlacement.center:
        result = Row(
          children: [
            Expanded(
              child: SizedBox(height: thickness, child: _buildLine(lineColor)),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: _titleHorizontalPadding),
              child: title,
            ),
            Expanded(
              child: SizedBox(height: thickness, child: _buildLine(lineColor)),
            ),
          ],
        );
        break;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: _verticalSpacing),
      child: SizedBox(height: commonConfig.vSpacingLg, child: result),
    );
  }

  Widget _buildLine(Color lineColor) {
    if (dashed) {
      return CustomPaint(
        painter: _DashedLinePainter(
          color: lineColor,
          thickness: thickness,
          axis: Axis.horizontal,
        ),
      );
    }
    return ColoredBox(color: lineColor);
  }
}

/// 虚线绘制
class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double thickness;
  final Axis axis;

  static const double _dashLength = 5;
  static const double _dashGap = 4;

  _DashedLinePainter({
    required this.color,
    required this.thickness,
    required this.axis,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    final double total = axis == Axis.horizontal ? size.width : size.height;
    double start = 0;
    while (start < total) {
      final double end = math.min(start + _dashLength, total);
      canvas.drawLine(
        axis == Axis.horizontal
            ? Offset(start, size.height / 2)
            : Offset(size.width / 2, start),
        axis == Axis.horizontal
            ? Offset(end, size.height / 2)
            : Offset(size.width / 2, end),
        paint,
      );
      start = end + _dashGap;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) {
    return color != oldDelegate.color ||
        thickness != oldDelegate.thickness ||
        axis != oldDelegate.axis;
  }
}
