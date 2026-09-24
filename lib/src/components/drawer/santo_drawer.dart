import 'dart:math' as math;

import 'package:santo_ui/src/theme/santo_theme.dart';
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
/// 安全区处理与 [SantoBottomDrawer] 一致,固定生效、不可配置:内容区的
/// MediaQuery 安全区按方向改写后交给内容消费——顶部抽屉只保留顶部安全区,
/// 底部抽屉只保留底部安全区,左右抽屉(整屏高)上下都保留。安全区放在
/// 内容中,而不是在内容外额外加一块空白区域:可滚动内容(如 [ListView])
/// 不传 padding 时自动把安全区消费为滚动内边距,滚动区铺满整个抽屉,
/// 滚到底时最后一项停在安全区之上;带固定头尾的内容读取
/// `MediaQuery.of(context).padding` 把安全区算进自身 padding。
///
/// 左右方向的宽度上限为屏幕宽度的 95%,超出时收敛到上限。
///
/// @changed v1.2.0 内容区按方向避让顶部/底部安全区域(安全区由内容自身消费,不加空白块);左右方向宽度上限收敛为屏幕宽度的 95%
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

  /// 抽屉宽度(左右方向生效),上限为屏幕宽度的 95%
  ///
  /// @changed v1.2.0 超出屏幕宽度 95% 时收敛到上限
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
  /// * [width] 抽屉宽度(左右方向)，默认 300，上限为屏幕宽度的 95%
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
        barrierColor: maskColor ??
            SantoThemeConfigurator.instance.getConfig().commonConfig.fillMask,
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
    final mediaQuery = MediaQuery.of(context);
    final isLeft =
        widget.direction == SantoDrawerDirection.left;
    final isTop = widget.direction == SantoDrawerDirection.top;
    final isBottom = widget.direction == SantoDrawerDirection.bottom;
    final isVertical = isTop || isBottom;

    Alignment alignment = Alignment.centerRight;
    if (isLeft) alignment = Alignment.centerLeft;
    if (isTop) alignment = Alignment.topCenter;
    if (isBottom) alignment = Alignment.bottomCenter;

    // 安全区按方向保留:顶部抽屉避让状态栏、底部抽屉避让手势条、
    // 左右抽屉(整屏高)上下都避让。改写内容的 MediaQuery 后交给内容
    // 消费,背景仍由 child 铺满整个抽屉,不产生透明带
    final EdgeInsets safePadding;
    switch (widget.direction) {
      case SantoDrawerDirection.left:
      case SantoDrawerDirection.right:
        safePadding = EdgeInsets.only(
          top: mediaQuery.padding.top,
          bottom: mediaQuery.padding.bottom,
        );
        break;
      case SantoDrawerDirection.top:
        safePadding = EdgeInsets.only(top: mediaQuery.padding.top);
        break;
      case SantoDrawerDirection.bottom:
        safePadding = EdgeInsets.only(bottom: mediaQuery.padding.bottom);
        break;
    }

    // 左右抽屉宽度上限为屏幕宽度的 95%
    final double effectiveWidth = isVertical
        ? double.infinity
        : math.min(widget.width, mediaQuery.size.width * 0.95);

    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: _close,
        child: Container(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {}, // 阻止事件穿透
            child: SizedBox(
              width: effectiveWidth,
              height: isVertical
                  ? widget.height
                  : mediaQuery.size.height,
              child: Material(
                color: Colors.transparent,
                child: MediaQuery(
                  data: mediaQuery.copyWith(padding: safePadding),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
