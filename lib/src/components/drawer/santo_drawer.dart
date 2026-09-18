import 'package:flutter/material.dart';

/// 抽屉方向
enum SantoDrawerDirection {
  /// 左侧
  left,

  /// 右侧
  right,

  /// 顶部
  top,

  /// 底部
  bottom,
}

/// 侧边滑出面板
///
/// 支持左/右/上/下方向滑出，支持自定义宽度和内容，支持遮罩层。
/// 通过 [SantoDrawer.show] 静态方法打开。
///
/// 使用示例：
/// ```dart
/// SantoDrawer.show(
///   context: context,
///   direction: SantoDrawerDirection.right,
///   width: 300,
///   child: Container(
///     color: Colors.white,
///     child: Center(child: Text('抽屉内容')),
///   ),
/// );
/// ```
class SantoDrawer extends StatefulWidget {
  /// 抽屉方向
  final SantoDrawerDirection direction;

  /// 抽屉宽度(左右方向生效)
  final double width;

  /// 抽屉高度(上下方向生效)
  final double height;

  /// 遮罩层颜色
  final Color? maskColor;

  /// 抽屉内容
  final Widget child;

  const SantoDrawer({
    Key? key,
    this.direction = SantoDrawerDirection.right,
    this.width = 300,
    this.height = 300,
    this.maskColor,
    required this.child,
  }) : super(key: key);

  /// 显示抽屉的静态方法
  ///
  /// * [context] 上下文
  /// * [direction] 抽屉方向，默认右侧
  /// * [width] 抽屉宽度(左右方向)，默认 300
  /// * [height] 抽屉高度(上下方向)，默认 300
  /// * [maskColor] 遮罩层颜色，默认半透明黑色
  /// * [child] 抽屉内容
  /// * [barrierDismissible] 点击遮罩是否可关闭，默认 true
  static Future<T?> show<T>({
    required BuildContext context,
    SantoDrawerDirection direction = SantoDrawerDirection.right,
    double width = 300,
    double height = 300,
    Color? maskColor,
    required Widget child,
    bool barrierDismissible = true,
  }) {
    // final isVertical = direction == SantoDrawerDirection.top ||
    //     direction == SantoDrawerDirection.bottom;
    Offset beginOffset;
    switch (direction) {
      case SantoDrawerDirection.left:
        beginOffset = const Offset(-1, 0);
        break;
      case SantoDrawerDirection.right:
        beginOffset = const Offset(1, 0);
        break;
      case SantoDrawerDirection.top:
        beginOffset = const Offset(0, -1);
        break;
      case SantoDrawerDirection.bottom:
        beginOffset = const Offset(0, 1);
        break;
    }
    return Navigator.of(context).push<T>(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: barrierDismissible,
        barrierColor: maskColor ?? Colors.black.withAlpha(0x66),
        pageBuilder: (context, animation, secondaryAnimation) {
          return SantoDrawer(
            direction: direction,
            width: width,
            height: height,
            maskColor: maskColor,
            child: child,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: beginOffset,
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
      ),
    );
  }

  @override
  State<SantoDrawer> createState() => _SantoDrawerState();
}

class _SantoDrawerState extends State<SantoDrawer> {
  void _close() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isLeft =
        widget.direction == SantoDrawerDirection.left;
    // final isRight =
    //     widget.direction == SantoDrawerDirection.right;
    final isTop = widget.direction == SantoDrawerDirection.top;
    final isBottom = widget.direction == SantoDrawerDirection.bottom;
    final isVertical = isTop || isBottom;

    Alignment alignment = Alignment.centerRight;
    if (isLeft) alignment = Alignment.centerLeft;
    if (isTop) alignment = Alignment.topCenter;
    if (isBottom) alignment = Alignment.bottomCenter;

    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: _close,
        child: Container(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {}, // 阻止事件穿透
            child: SizedBox(
              width: isVertical ? double.infinity : widget.width,
              height: isVertical
                  ? widget.height
                  : MediaQuery.of(context).size.height,
              child: Material(
                color: Colors.transparent,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
