import 'package:flutter/material.dart';

import 'package:santo_ui/src/components/badge/santo_badge.dart';
import 'package:santo_ui/src/components/button/santo_press_feedback.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 操作栏图标尺寸
const double kSantoActionBarIconSize = 18;

/// 操作栏图标区宽度
const double kSantoActionBarIconWidth = 48;

/// 操作栏图标文案字号
const double kSantoActionBarIconFontSize = 10;

/// 操作栏图标按钮
///
/// 对标 Vant ActionBarIcon:图标在上、文案在下,支持红点与数字角标、禁用态。
/// 宽度固定 [kSantoActionBarIconWidth],文案超出以省略号收尾。
///
/// 示例:
/// ```dart
/// SantoActionBarIcon(icon: Icon(Icons.chat), text: '客服')
/// SantoActionBarIcon(icon: Icon(Icons.cart), text: '购物车', badgeCount: 5)
/// ```
class SantoActionBarIcon extends StatelessWidget {
  /// 图标控件,颜色与尺寸由 [color] 与 [kSantoActionBarIconSize] 决定,
  /// 图标自带颜色/尺寸时以图标自身的设置为准
  final Widget icon;

  /// 图标下方的文案
  final String? text;

  /// 自定义文案控件,优先级高于 [text]
  final Widget? child;

  /// 图标颜色,默认基础文字色
  final Color? color;

  /// 是否展示红点
  final bool dot;

  /// 角标数字,大于 0 时展示
  final int? badgeCount;

  /// 是否禁用,禁用后降低透明度且不响应点击
  final bool disabled;

  /// 点击回调
  final VoidCallback? onTap;

  const SantoActionBarIcon({
    Key? key,
    required this.icon,
    this.text,
    this.child,
    this.color,
    this.dot = false,
    this.badgeCount,
    this.disabled = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SantoCommonConfig common =
        SantoThemeConfigurator.instance.getConfig().commonConfig;

    Widget iconWidget = IconTheme.merge(
      data: IconThemeData(
        color: color ?? common.colorTextBase,
        size: kSantoActionBarIconSize,
      ),
      child: icon,
    );
    iconWidget = SantoBadge(count: badgeCount, isDot: dot, child: iconWidget);

    final Widget label = child ??
        SizedBox(
          width: kSantoActionBarIconWidth,
          child: Text(
            text ?? '',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: kSantoActionBarIconFontSize,
              height: 1,
              color: common.colorTextBase,
            ),
          ),
        );

    return SantoPressFeedback(
      enabled: !disabled,
      onTap: onTap,
      child: Opacity(
        opacity: disabled ? 0.4 : 1,
        child: Container(
          constraints: const BoxConstraints(minWidth: kSantoActionBarIconWidth),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              iconWidget,
              const SizedBox(height: 4),
              label,
            ],
          ),
        ),
      ),
    );
  }
}
