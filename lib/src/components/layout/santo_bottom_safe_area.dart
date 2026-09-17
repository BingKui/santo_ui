import 'package:flutter/material.dart';

/// 底部安全区域占位:放在内容区的最底部,预留系统底部安全区域与额外留白,
/// 保证最后一段内容能完整展示在安全区域(如 iPhone 的 Home 横条)之上
///
/// 与把安全区域算进滚动容器 padding 不同,它作为内容的一部分参与滚动/占位,
/// 因此内容自带滚动(如 ListView、Refresh)时也能在末尾留出空间
///
/// 示例:
/// ```dart
/// ListView(
///   children: [
///     列表项...,
///     const SantoBottomSafeArea(),
///   ],
/// )
/// ```
class SantoBottomSafeArea extends StatelessWidget {
  /// 是否预留系统底部安全区域,默认 true
  final bool safeArea;

  /// 在安全区域之上叠加的额外留白(如悬浮菜单栏占位),默认 0
  final double extra;

  const SantoBottomSafeArea({
    Key? key,
    this.safeArea = true,
    this.extra = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height =
        (safeArea ? MediaQuery.paddingOf(context).bottom : 0) + extra;
    return SizedBox(height: height);
  }
}
