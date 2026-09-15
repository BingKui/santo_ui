import 'package:flutter/material.dart';

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
  /// [borderRadius] 气泡圆角
  /// [arrowSize] 箭头大小
  /// [offset] 与锚点的偏移距离
  /// [onDismiss] 关闭回调
  /// [barrierColor] 遮罩颜色
  static void show({
    required BuildContext context,
    required GlobalKey target,
    required Widget content,
    SantoPopoverDirection direction = SantoPopoverDirection.bottom,
    bool showArrow = true,
    Color? backgroundColor,
    double borderRadius = 12,
    double arrowSize = 8,
    double offset = 4,
    SantoPopoverDismissCallback? onDismiss,
    Color barrierColor = Colors.transparent,
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
            borderRadius: borderRadius,
            arrowSize: arrowSize,
            offset: offset,
            onDismiss: onDismiss,
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
  final double borderRadius;
  final double arrowSize;
  final double offset;
  final SantoPopoverDismissCallback? onDismiss;

  const _SantoPopoverOverlay({
    required this.targetOffset,
    required this.targetSize,
    required this.content,
    required this.direction,
    required this.showArrow,
    required this.backgroundColor,
    required this.borderRadius,
    required this.arrowSize,
    required this.offset,
    required this.onDismiss,
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
    final arrowExtra = widget.showArrow ? widget.arrowSize : 0;
    double dx, dy;

    switch (widget.direction) {
      case SantoPopoverDirection.top:
        dx = widget.targetOffset.dx +
            widget.targetSize.width / 2 -
            popoverSize.width / 2;
        dy = widget.targetOffset.dy - popoverSize.height - arrowExtra - widget.offset;
        break;
      case SantoPopoverDirection.bottom:
        dx = widget.targetOffset.dx +
            widget.targetSize.width / 2 -
            popoverSize.width / 2;
        dy = widget.targetOffset.dy +
            widget.targetSize.height +
            arrowExtra +
            widget.offset;
        break;
      case SantoPopoverDirection.left:
        dx = widget.targetOffset.dx - popoverSize.width - arrowExtra - widget.offset;
        dy = widget.targetOffset.dy +
            widget.targetSize.height / 2 -
            popoverSize.height / 2;
        break;
      case SantoPopoverDirection.right:
        dx = widget.targetOffset.dx +
            widget.targetSize.width +
            arrowExtra +
            widget.offset;
        dy = widget.targetOffset.dy +
            widget.targetSize.height / 2 -
            popoverSize.height / 2;
        break;
    }

    // 边界约束
    dx = dx.clamp(8.0, screenSize.width - popoverSize.width - 8.0);
    dy = dy.clamp(8.0, screenSize.height - popoverSize.height - 8.0);

    return Offset(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onDismiss?.call();
        Navigator.of(context).pop();
      },
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            if (_popoverPosition != null)
              Positioned(
                left: _popoverPosition!.dx,
                top: _popoverPosition!.dy,
                child: GestureDetector(
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

    return CustomPaint(
      key: _popoverKey,
      painter: _PopoverArrowPainter(
        direction: widget.direction,
        showArrow: widget.showArrow,
        arrowSize: widget.arrowSize,
        backgroundColor: _backgroundColor,
        borderRadius: widget.borderRadius,
        targetOffset: widget.targetOffset,
        targetSize: widget.targetSize,
        popoverPosition: _popoverPosition ?? Offset.zero,
      ),
      child: Padding(
        padding: EdgeInsets.all(
          widget.showArrow ? widget.arrowSize + 4 : 0,
        ),
        child: widget.content,
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
  final double borderRadius;
  final Offset targetOffset;
  final Size targetSize;
  final Offset popoverPosition;

  _PopoverArrowPainter({
    required this.direction,
    required this.showArrow,
    required this.arrowSize,
    required this.backgroundColor,
    required this.borderRadius,
    required this.targetOffset,
    required this.targetSize,
    required this.popoverPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    canvas.drawRRect(rect, paint);

    if (!showArrow) return;

    // 计算箭头位置
    final arrowPath = Path();
    final targetCenterX =
        targetOffset.dx + targetSize.width / 2 - popoverPosition.dx;
    final targetCenterY =
        targetOffset.dy + targetSize.height / 2 - popoverPosition.dy;

    switch (direction) {
      case SantoPopoverDirection.bottom:
        // 箭头朝上
        final ax = targetCenterX.clamp(arrowSize + borderRadius, size.width - arrowSize - borderRadius);
        arrowPath.moveTo(ax - arrowSize, arrowSize);
        arrowPath.lineTo(ax, 0);
        arrowPath.lineTo(ax + arrowSize, arrowSize);
        arrowPath.close();
        break;
      case SantoPopoverDirection.top:
        // 箭头朝下
        final ax = targetCenterX.clamp(arrowSize + borderRadius, size.width - arrowSize - borderRadius);
        arrowPath.moveTo(ax - arrowSize, size.height - arrowSize);
        arrowPath.lineTo(ax, size.height);
        arrowPath.lineTo(ax + arrowSize, size.height - arrowSize);
        arrowPath.close();
        break;
      case SantoPopoverDirection.right:
        // 箭头朝左
        final ay = targetCenterY.clamp(arrowSize + borderRadius, size.height - arrowSize - borderRadius);
        arrowPath.moveTo(arrowSize, ay - arrowSize);
        arrowPath.lineTo(0, ay);
        arrowPath.lineTo(arrowSize, ay + arrowSize);
        arrowPath.close();
        break;
      case SantoPopoverDirection.left:
        // 箭头朝右
        final ay = targetCenterY.clamp(arrowSize + borderRadius, size.height - arrowSize - borderRadius);
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
        oldDelegate.backgroundColor != backgroundColor;
  }
}
