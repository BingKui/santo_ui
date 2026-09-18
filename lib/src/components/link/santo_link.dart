import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 链接状态枚举
enum SantoLinkState {
  /// 正常状态
  normal,

  /// 激活/按下状态
  active,

  /// 禁用状态
  disabled,

  /// 已访问状态
  visited,
}

/// 链接尺寸枚举
enum SantoLinkSize {
  /// 小尺寸
  small,

  /// 中等尺寸（默认）
  medium,

  /// 大尺寸
  large,
}

/// 文字链接组件
///
/// 支持不同状态（正常、激活、禁用、已访问）、下划线显示/隐藏、
/// 前置/后置图标、多种尺寸
///
/// 示例：
/// ```dart
/// SantoLink(text: '点击查看详情', onTap: () {})
/// SantoLink(text: '禁用链接', state: SantoLinkState.disabled)
/// SantoLink(text: '带图标', prefixIcon: Icons.link, underline: true)
/// ```
///
class SantoLink extends StatefulWidget {
  /// 链接文字
  final String text;

  /// 链接地址（仅用于语义，实际点击行为由 [onTap] 控制）
  final String? href;

  /// 链接状态
  final SantoLinkState state;

  /// 是否显示下划线
  final bool underline;

  /// 前置图标
  final IconData? prefixIcon;

  /// 后置图标
  final IconData? suffixIcon;

  /// 链接尺寸
  final SantoLinkSize size;

  /// 链接颜色，默认使用主题色
  final Color? color;

  /// 点击回调
  final VoidCallback? onTap;

  /// 文字样式
  final TextStyle? textStyle;

  /// 文字链接组件构造函数
  const SantoLink({
    Key? key,
    required this.text,
    this.href,
    this.state = SantoLinkState.normal,
    this.underline = false,
    this.prefixIcon,
    this.suffixIcon,
    this.size = SantoLinkSize.medium,
    this.color,
    this.onTap,
    this.textStyle,
  }) : super(key: key);

  @override
  State<SantoLink> createState() => _SantoLinkState();
}

class _SantoLinkState extends State<SantoLink> {
  bool _isPressed = false;

  /// 根据尺寸获取字体大小
  double get _fontSize {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    switch (widget.size) {
      case SantoLinkSize.small:
        return commonConfig.fontSizeCaption;
      case SantoLinkSize.medium:
        return commonConfig.fontSizeBase;
      case SantoLinkSize.large:
        return commonConfig.fontSizeSubHead;
    }
  }

  /// 根据尺寸获取图标大小
  double get _iconSize {
    switch (widget.size) {
      case SantoLinkSize.small:
        return 14;
      case SantoLinkSize.medium:
        return 16;
      case SantoLinkSize.large:
        return 18;
    }
  }

  /// 获取当前状态对应的颜色
  Color _getColor() {
    if (widget.color != null) return widget.color!;

    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;

    switch (widget.state) {
      case SantoLinkState.disabled:
        return commonConfig.colorTextDisabled;
      case SantoLinkState.visited:
        return commonConfig.colorTextSecondary;
      case SantoLinkState.active:
        return commonConfig.brandPrimaryTap;
      case SantoLinkState.normal:
        return commonConfig.colorLink;
    }
  }

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final Color currentColor = _getColor();
    final bool isDisabled = widget.state == SantoLinkState.disabled;

    final TextStyle style = widget.textStyle ??
        TextStyle(
          fontSize: _fontSize,
          color: currentColor,
          decoration: widget.underline
              ? TextDecoration.underline
              : TextDecoration.none,
          decorationColor: currentColor,
        );

    return GestureDetector(
      onTapDown: isDisabled
          ? null
          : (_) {
              setState(() => _isPressed = true);
            },
      onTapUp: isDisabled
          ? null
          : (_) {
              setState(() => _isPressed = false);
            },
      onTapCancel: isDisabled
          ? null
          : () {
              setState(() => _isPressed = false);
            },
      onTap: isDisabled ? null : widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.prefixIcon != null) ...[
            Icon(
              widget.prefixIcon,
              size: _iconSize,
              color: _isPressed
                  ? currentColor.withOpacity(0.7)
                  : currentColor,
            ),
            SizedBox(width: commonConfig.hSpacingXs),
          ],
          Text(
            widget.text,
            style: _isPressed
                ? style.copyWith(color: currentColor.withOpacity(0.7))
                : style,
          ),
          if (widget.suffixIcon != null) ...[
            SizedBox(width: commonConfig.hSpacingXs),
            Icon(
              widget.suffixIcon,
              size: _iconSize,
              color: _isPressed
                  ? currentColor.withOpacity(0.7)
                  : currentColor,
            ),
          ],
        ],
      ),
    );
  }
}
