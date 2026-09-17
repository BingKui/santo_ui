import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 气泡弹出框方向
enum SantoPopoverDirection {
  /// 上方
  top,

  /// 下方
  bottom,

  /// 左侧
  left,

  /// 右侧
  right,
}

/// 气泡弹出框关闭回调
typedef SantoPopoverDismissCallback = void Function();

/// 气泡弹出框组件
///
/// 从锚点位置弹出的气泡内容框，支持多个方向弹出，支持自定义内容和三角箭头。
///
/// 使用示例：
/// ```dart
/// // 1. 定义 GlobalKey
/// GlobalKey _targetKey = GlobalKey();
///
/// // 2. 绑定到目标组件
/// GestureDetector(
///   key: _targetKey,
///   onTap: () {
///     SantoPopover.show(
///       context: context,
///       target: _targetKey,
///       content: Text('气泡内容'),
///       direction: SantoPopoverDirection.bottom,
///     );
///   },
///   child: Text('点击弹出'),
/// )
/// ```
class SantoPopover {
  /// 显示气泡弹出框
  ///
  /// [context] 上下文
  /// [target] 锚点组件的 GlobalKey
  /// [content] 气泡内容
  /// [direction] 弹出方向，默认 [SantoPopoverDirection.bottom]
  /// [showArrow] 是否显示三角箭头，默认 true
  /// [backgroundColor] 气泡背景颜色
  /// [radius] 气泡圆角
  /// [arrowSize] 箭头大小
  /// [offset] 与锚点的偏移距离
  /// [onDismiss] 关闭回调
  /// [barrierColor] 遮罩颜色
  /// [contentPadding] 内容区域内边距，默认 EdgeInsets.symmetric(horizontal: 12, vertical: 8)
  static void show({
    required BuildContext context,
    required GlobalKey target,
    required Widget content,
    SantoPopoverDirection direction = SantoPopoverDirection.bottom,
    bool showArrow = true,
    Color? backgroundColor,
    double radius = 12,
    double arrowSize = 8,
    double offset = 4,
    SantoPopoverDismissCallback? onDismiss,
    Color barrierColor = Colors.transparent,
    EdgeInsets? contentPadding,
  }) {
    // 获取目标组件的位置
    final renderObject = target.currentContext?.findRenderObject();
    if (renderObject == null || renderObject is! RenderBox) {
      return;
    }

    final targetBox = renderObject;
    final targetOffset = targetBox.localToGlobal(Offset.zero);
    final targetSize = targetBox.size;

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: barrierColor,
        pageBuilder: (context, animation, secondaryAnimation) {
          return _SantoPopoverOverlay(
            targetOffset: targetOffset,
            targetSize: targetSize,
            content: content,
            direction: direction,
            showArrow: showArrow,
            backgroundColor: backgroundColor,
            radius: radius,
            arrowSize: arrowSize,
            offset: offset,
            onDismiss: onDismiss,
            contentPadding: contentPadding ??
                EdgeInsets.symmetric(
                    horizontal: SantoThemeConfigurator.instance
                        .getConfig()
                        .commonConfig
                        .pageGap,
                    vertical: SantoThemeConfigurator.instance
                        .getConfig()
                        .commonConfig
                        .vSpacingSm),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 150),
      ),
    );
  }
}

/// 气泡弹出框覆盖层
class _SantoPopoverOverlay extends StatefulWidget {
  final Offset targetOffset;
  final Size targetSize;
  final Widget content;
  final SantoPopoverDirection direction;
  final bool showArrow;
  final Color? backgroundColor;
  final double radius;
  final double arrowSize;
  final double offset;
  final SantoPopoverDismissCallback? onDismiss;
  final EdgeInsets contentPadding;

  const _SantoPopoverOverlay({
    required this.targetOffset,
    required this.targetSize,
    required this.content,
    required this.direction,
    required this.showArrow,
    required this.backgroundColor,
    required this.radius,
    required this.arrowSize,
    required this.offset,
    required this.onDismiss,
    required this.contentPadding,
  });

  @override
  State<_SantoPopoverOverlay> createState() => _SantoPopoverOverlayState();
}

class _SantoPopoverOverlayState extends State<_SantoPopoverOverlay> {
  final GlobalKey _popoverKey = GlobalKey();
  Offset? _popoverPosition;

  Color get _backgroundColor =>
      widget.backgroundColor ?? const Color(0xFF1A1A1A);

  @override
  void initState() {
    super.initState();
    // 延迟计算位置，等内容渲染完成
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculatePosition();
    });
  }

  /// 计算气泡位置
  void _calculatePosition() {
    final renderObject = _popoverKey.currentContext?.findRenderObject();
    if (renderObject == null || renderObject is! RenderBox) return;

    final popoverSize = renderObject.size;
    setState(() {
      _popoverPosition = _computePosition(popoverSize);
    });
  }

  /// 根据方向计算气泡位置
  Offset _computePosition(Size popoverSize) {
    final screenSize = MediaQuery.of(context).size;
    double dx, dy;

    switch (widget.direction) {
      case SantoPopoverDirection.top:
        dx = widget.targetOffset.dx +
            widget.targetSize.width / 2 -
            popoverSize.width / 2;
        dy = widget.targetOffset.dy - popoverSize.height - widget.offset;
        break;
      case SantoPopoverDirection.bottom:
        dx = widget.targetOffset.dx +
            widget.targetSize.width / 2 -
            popoverSize.width / 2;
        dy = widget.targetOffset.dy +
            widget.targetSize.height +
            widget.offset;
        break;
      case SantoPopoverDirection.left:
        dx = widget.targetOffset.dx - popoverSize.width - widget.offset;
        dy = widget.targetOffset.dy +
            widget.targetSize.height / 2 -
            popoverSize.height / 2;
        break;
      case SantoPopoverDirection.right:
        dx = widget.targetOffset.dx +
            widget.targetSize.width +
            widget.offset;
        dy = widget.targetOffset.dy +
            widget.targetSize.height / 2 -
            popoverSize.height / 2;
        break;
    }

    // 边界检测，确保不超出屏幕
    final maxDx = (screenSize.width - popoverSize.width - 8.0).clamp(8.0, double.infinity);
    final maxDy = (screenSize.height - popoverSize.height - 8.0).clamp(8.0, double.infinity);
    dx = dx.clamp(8.0, maxDx);
    dy = dy.clamp(8.0, maxDy);

    return Offset(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context).pop();
          widget.onDismiss?.call();
        },
        child: Stack(
          children: [
            Positioned(
              left: _popoverPosition?.dx,
              top: _popoverPosition?.dy,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {}, // 阻止冒泡
                child: _buildPopoverContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建气泡内容（含箭头）
  Widget _buildPopoverContent() {
    // 计算箭头方向需要的额外空间
    final arrowExtra = widget.showArrow ? widget.arrowSize : 0.0;
    
    // 根据箭头方向计算 padding，只在箭头方向留出空间
    EdgeInsets arrowPadding;
    switch (widget.direction) {
      case SantoPopoverDirection.top:
        arrowPadding = EdgeInsets.only(bottom: arrowExtra);
        break;
      case SantoPopoverDirection.bottom:
        arrowPadding = EdgeInsets.only(top: arrowExtra);
        break;
      case SantoPopoverDirection.left:
        arrowPadding = EdgeInsets.only(right: arrowExtra);
        break;
      case SantoPopoverDirection.right:
        arrowPadding = EdgeInsets.only(left: arrowExtra);
        break;
    }

    return CustomPaint(
      key: _popoverKey,
      painter: _PopoverArrowPainter(
        direction: widget.direction,
        showArrow: widget.showArrow,
        arrowSize: widget.arrowSize,
        backgroundColor: _backgroundColor,
        radius: widget.radius,
        targetOffset: widget.targetOffset,
        targetSize: widget.targetSize,
        popoverPosition: _popoverPosition ?? Offset.zero,
      ),
      child: Padding(
        padding: arrowPadding,
        child: Padding(
          padding: widget.contentPadding,
          child: widget.content,
        ),
      ),
    );
  }
}

/// 气泡箭头绘制器
class _PopoverArrowPainter extends CustomPainter {
  final SantoPopoverDirection direction;
  final bool showArrow;
  final double arrowSize;
  final Color backgroundColor;
  final double radius;
  final Offset targetOffset;
  final Size targetSize;
  final Offset popoverPosition;

  _PopoverArrowPainter({
    required this.direction,
    required this.showArrow,
    required this.arrowSize,
    required this.backgroundColor,
    required this.radius,
    required this.targetOffset,
    required this.targetSize,
    required this.popoverPosition,
  });

  /// 箭头锚点钳制：气泡尺寸不足以留出 arrowSize + radius 时，
  /// 退化为在整个范围内钳制，避免 clamp 下限大于上限抛异常
  double _clampArrowCenter(double value, double total) {
    final double min = arrowSize + radius;
    final double max = total - min;
    if (max < min) {
      return value.clamp(0.0, math.max(0.0, total));
    }
    return value.clamp(min, max);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    // 矩形沿箭头方向收进 arrowSize，让箭头露在气泡外部
    final Rect rect;
    switch (direction) {
      case SantoPopoverDirection.bottom:
        rect = Rect.fromLTWH(0, showArrow ? arrowSize : 0, size.width,
            size.height - (showArrow ? arrowSize : 0));
        break;
      case SantoPopoverDirection.top:
        rect = Rect.fromLTWH(0, 0, size.width,
            size.height - (showArrow ? arrowSize : 0));
        break;
      case SantoPopoverDirection.right:
        rect = Rect.fromLTWH(showArrow ? arrowSize : 0, 0,
            size.width - (showArrow ? arrowSize : 0), size.height);
        break;
      case SantoPopoverDirection.left:
        rect = Rect.fromLTWH(0, 0,
            size.width - (showArrow ? arrowSize : 0), size.height);
        break;
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      paint,
    );

    if (!showArrow) return;

    // 计算箭头位置
    final arrowPath = Path();
    final targetCenterX =
        targetOffset.dx + targetSize.width / 2 - popoverPosition.dx;
    final targetCenterY =
        targetOffset.dy + targetSize.height / 2 - popoverPosition.dy;

    switch (direction) {
      case SantoPopoverDirection.bottom:
        // 箭头朝上，tip 在 y=0
        final ax = _clampArrowCenter(targetCenterX, size.width);
        arrowPath.moveTo(ax - arrowSize, arrowSize);
        arrowPath.lineTo(ax, 0);
        arrowPath.lineTo(ax + arrowSize, arrowSize);
        arrowPath.close();
        break;
      case SantoPopoverDirection.top:
        // 箭头朝下，tip 在 y=size.height
        final ax = _clampArrowCenter(targetCenterX, size.width);
        arrowPath.moveTo(ax - arrowSize, size.height - arrowSize);
        arrowPath.lineTo(ax, size.height);
        arrowPath.lineTo(ax + arrowSize, size.height - arrowSize);
        arrowPath.close();
        break;
      case SantoPopoverDirection.right:
        // 箭头朝左，tip 在 x=0
        final ay = _clampArrowCenter(targetCenterY, size.height);
        arrowPath.moveTo(arrowSize, ay - arrowSize);
        arrowPath.lineTo(0, ay);
        arrowPath.lineTo(arrowSize, ay + arrowSize);
        arrowPath.close();
        break;
      case SantoPopoverDirection.left:
        // 箭头朝右，tip 在 x=size.width
        final ay = _clampArrowCenter(targetCenterY, size.height);
        arrowPath.moveTo(size.width - arrowSize, ay - arrowSize);
        arrowPath.lineTo(size.width, ay);
        arrowPath.lineTo(size.width - arrowSize, ay + arrowSize);
        arrowPath.close();
        break;
    }

    canvas.drawPath(arrowPath, paint);
  }

  @override
  bool shouldRepaint(covariant _PopoverArrowPainter oldDelegate) {
    return oldDelegate.direction != direction ||
        oldDelegate.showArrow != showArrow ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.arrowSize != arrowSize ||
        oldDelegate.radius != radius ||
        oldDelegate.targetOffset != targetOffset ||
        oldDelegate.targetSize != targetSize ||
        oldDelegate.popoverPosition != popoverPosition;
  }
}
