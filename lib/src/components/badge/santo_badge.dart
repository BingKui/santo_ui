import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 徽标组件
///
/// 支持两种模式：
/// - 红点模式（[isDot] = true）：仅显示一个小圆点
/// - 数字模式（[isDot] = false）：显示数字或自定义文本
///
/// 可通过 [child] 包裹子组件，徽标会以 Stack 方式叠加在子组件右上角
///
/// 示例：
/// ```dart
/// SantoBadge(count: 5, child: Icon(Icons.notifications))
/// SantoBadge(isDot: true, child: Icon(Icons.mail))
/// SantoBadge(count: 100, maxCount: 99)
/// ```
///
class SantoBadge extends StatelessWidget {
  /// 显示的数字，当为 0 且非红点模式时不显示徽标
  final int? count;

  /// 是否为红点模式
  final bool isDot;

  /// 徽标背景颜色，默认使用主题错误色
  final Color? color;

  /// 文字颜色，默认白色
  final Color? textColor;

  /// 最大数字，超过后显示 "maxCount+"，默认 99
  final int maxCount;

  /// 徽标尺寸（红点模式下为圆点直径，数字模式下为最小高度）
  final double badgeSize;

  /// 徽标偏移量，用于微调位置
  final Offset? offset;

  /// 被包裹的子组件，徽标叠加在其右上角
  final Widget? child;

  /// 自定义徽标内容，优先级高于 [count] 和 [isDot]；内容会放在徽标底色内
  final Widget? badgeContent;

  /// 是否始终显示，即使 count 为 0
  final bool showZero;

  /// 徽标组件构造函数
  const SantoBadge({
    Key? key,
    this.count,
    this.isDot = false,
    this.color,
    this.textColor,
    this.maxCount = 99,
    this.badgeSize = 18,
    this.offset,
    this.child,
    this.badgeContent,
    this.showZero = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (child == null) {
      return _buildBadge();
    }
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child!,
        Positioned(
          right: offset?.dx ?? -4,
          top: offset?.dy ?? -4,
          child: _buildBadge(),
        ),
      ],
    );
  }

  /// 构建徽标内容
  Widget _buildBadge() {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final bgColor = color ??
        SantoThemeConfigurator.instance.getConfig().commonConfig.brandError;
    final txtColor = textColor ??
        SantoThemeConfigurator.instance.getConfig().commonConfig.colorTextBaseInverse;

    // 红点模式
    if (isDot && badgeContent == null) {
      return Container(
        width: badgeSize * 0.5,
        height: badgeSize * 0.5,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
      );
    }

    // 数字模式:count 为 0 且未开启 showZero 时不展示
    final int displayCount = count ?? 0;
    if (badgeContent == null && displayCount == 0 && !showZero) {
      return const SizedBox.shrink();
    }

    // 自定义内容优先,与数字一样放在徽标底色内
    final Widget content = badgeContent ??
        Text(
          displayCount > maxCount ? '$maxCount+' : '$displayCount',
          style: TextStyle(
            color: txtColor,
            fontSize: commonConfig.fontSizeCaptionSm,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        );

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: commonConfig.hSpacingXs, vertical: 1),
      constraints: BoxConstraints(
        minWidth: badgeSize,
        minHeight: badgeSize,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(badgeSize / 2),
      ),
      alignment: Alignment.center,
      child: content,
    );
  }
}
