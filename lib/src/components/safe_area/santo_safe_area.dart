import 'package:flutter/material.dart';

/// 安全区域组件:统一处理顶部与底部的安全区域
///
/// 顶部为状态栏/刘海区域,底部为 Home Indicator 区域;
/// 左右两侧不处理,由页面自身的水平间距控制。
///
/// 示例:
/// ```dart
/// SantoSafeArea(
///   child: Column(children: [...]),
/// )
///
/// // 只处理顶部
/// SantoSafeArea(top: true, bottom: false, child: ...)
/// ```
class SantoSafeArea extends StatelessWidget {
  /// 子控件
  final Widget child;

  /// 是否处理顶部安全区域,默认 true
  final bool top;

  /// 是否处理底部安全区域,默认 true
  final bool bottom;

  /// 安全区域最小高度,默认 [EdgeInsets.zero]
  final EdgeInsets minimum;

  /// 键盘弹出时是否保持底部安全区域,默认 false
  final bool maintainBottomViewPadding;

  const SantoSafeArea({
    Key? key,
    required this.child,
    this.top = true,
    this.bottom = true,
    this.minimum = EdgeInsets.zero,
    this.maintainBottomViewPadding = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: top,
      bottom: bottom,
      left: false,
      right: false,
      minimum: minimum,
      maintainBottomViewPadding: maintainBottomViewPadding,
      child: child,
    );
  }
}
