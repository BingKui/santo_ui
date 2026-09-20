import 'package:flutter/material.dart';

import 'package:santo_ui/src/components/action_bar/santo_action_bar_button.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 操作栏高度
const double kSantoActionBarHeight = 50;

/// 底部操作栏
///
/// 对标 Vant ActionBar:一行承载若干 [SantoActionBarIcon] 与
/// [SantoActionBarButton],为页面底部的常用操作提供入口。
///
/// [SantoActionBarButton] 会平分剩余宽度,并按在栏中的位置自动处理首尾圆角与外边距;
/// [SantoActionBarIcon] 保持固定宽度,不参与平分。
///
/// 使用方式:放入 [Scaffold] 的 bottomNavigationBar,或作为 [Column] 的最后一个子节点。
///
/// 示例:
/// ```dart
/// Scaffold(
///   bottomNavigationBar: SantoActionBar(
///     children: [
///       SantoActionBarIcon(icon: SantoIcons.headset, text: '客服'),
///       SantoActionBarButton(text: '加入购物车'),
///       SantoActionBarButton(text: '立即购买', type: SantoActionBarButtonType.danger),
///     ],
///   ),
/// )
/// ```
class SantoActionBar extends StatelessWidget {
  /// 操作栏内容,通常为 [SantoActionBarIcon] 与 [SantoActionBarButton]
  final List<Widget> children;

  /// 是否适配底部安全区,默认 true
  final bool safeAreaInsetBottom;

  /// 背景色,默认使用主题 fillBase
  final Color? backgroundColor;

  const SantoActionBar({
    Key? key,
    required this.children,
    this.safeAreaInsetBottom = true,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SantoCommonConfig common =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final double safeAreaBottom =
        safeAreaInsetBottom ? MediaQuery.paddingOf(context).bottom : 0;

    return Container(
      color: backgroundColor ?? common.fillBase,
      padding: EdgeInsets.only(bottom: safeAreaBottom),
      child: SizedBox(
        height: kSantoActionBarHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildChildren(),
        ),
      ),
    );
  }

  /// 按钮平分剩余宽度,并计算其在整组按钮中的首尾位置
  List<Widget> _buildChildren() {
    final List<Widget> rowChildren = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      final Widget child = children[i];
      if (child is! SantoActionBarButton) {
        rowChildren.add(child);
        continue;
      }
      final bool first = i == 0 || children[i - 1] is! SantoActionBarButton;
      final bool last =
          i == children.length - 1 || children[i + 1] is! SantoActionBarButton;
      rowChildren.add(
        Expanded(child: child.withPosition(first: first, last: last)),
      );
    }
    return rowChildren;
  }
}
