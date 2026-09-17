import 'package:flutter/widgets.dart';

/// [SantoAppLayout] 注入给各页面的底部菜单栏占位
///
/// 悬浮菜单栏浮在页面内容之上,内容需要预留出菜单栏(含悬浮间距)的高度,
/// 否则滚动到底部时最后一段内容会被菜单栏遮住。[SantoPageLayout] 会自动读取
/// 该占位,页面无需自己计算;独立使用 [SantoPageLayout] 时读到的占位为 0。
class SantoAppLayoutScope extends InheritedWidget {
  /// 底部菜单栏占位高度(栏高 + 悬浮间距),不含底部安全区域
  final double bottomBarInset;

  const SantoAppLayoutScope({
    Key? key,
    required this.bottomBarInset,
    required Widget child,
  }) : super(key: key, child: child);

  /// 读取底部菜单栏占位高度,未处于 [SantoAppLayout] 中时返回 0
  static double bottomBarInsetOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<SantoAppLayoutScope>()
          ?.bottomBarInset ??
      0;

  @override
  bool updateShouldNotify(SantoAppLayoutScope oldWidget) =>
      bottomBarInset != oldWidget.bottomBarInset;
}
