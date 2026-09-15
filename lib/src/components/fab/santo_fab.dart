import 'package:flutter/material.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 悬浮按钮位置枚举
enum SantoFabPosition {
  /// 右下角
  bottomRight,

  /// 左下角
  bottomLeft,

  /// 右上角
  topRight,

  /// 左上角
  topLeft,
}

/// 悬浮按钮形状枚举
enum SantoFabShape {
  /// 圆形
  circle,

  /// 扩展形（带文字）
  extended,
}

/// Fab 悬浮按钮组件
///
/// 页面悬浮操作按钮，支持圆形和扩展形（带文字）两种形态。
/// 支持自定义图标、颜色、位置和大小。
///
/// 通常在 [Stack] 中配合使用，也可以直接作为普通按钮使用。
///
/// 使用示例：
/// ```dart
/// // 圆形按钮（普通用法）
/// SantoFab(
///   icon: Icons.add,
///   onPressed: () {},
/// )
///
/// // 在 Stack 中使用并指定位置
/// Stack(
///   children: [
///     pageContent,
///     SantoFab.positioned(
///       icon: Icons.add,
///       text: '新建',
///       onPressed: () {},
///       position: SantoFabPosition.bottomRight,
///     ),
///   ],
/// )
/// ```
class SantoFab extends StatelessWidget {
  /// 按钮图标
  final IconData? icon;

  /// 按钮文字，设置后默认形状为扩展形
  final String? text;

  /// 点击回调
  final VoidCallback? onPressed;

  /// 按钮背景色，默认使用主题品牌色
  final Color? backgroundColor;

  /// 图标颜色，默认白色
  final Color? iconColor;

  /// 文字颜色，默认白色
  final Color? textColor;

  /// 按钮大小（圆形时为直径），默认56
  final double size;

  /// 按钮形状，默认圆形（有text时自动变为扩展形）
  final SantoFabShape? shape;

  /// 自定义子组件，设置后忽略icon和text
  final Widget? child;

  /// 阴影高度，默认6
  final double elevation;

  /// 创建 Fab 悬浮按钮
  const SantoFab({
    Key? key,
    this.icon,
    this.text,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
    this.size = 56,
    this.shape,
    this.child,
    this.elevation = 6,
  }) : super(key: key);

  /// 创建带定位的 Fab 悬浮按钮，用于 [Stack] 中
  ///
  /// [position] 按钮位置，默认右下角
  /// [edgeOffset] 距离边缘的偏移量，默认16
  static Widget positioned({
    Key? key,
    IconData? icon,
    String? text,
    VoidCallback? onPressed,
    Color? backgroundColor,
    Color? iconColor,
    Color? textColor,
    double size = 56,
    SantoFabPosition position = SantoFabPosition.bottomRight,
    SantoFabShape? shape,
    Widget? child,
    double elevation = 6,
    double edgeOffset = 16,
  }) {
    return Positioned(
      left: (position == SantoFabPosition.bottomLeft ||
              position == SantoFabPosition.topLeft)
          ? edgeOffset
          : null,
      right: (position == SantoFabPosition.bottomRight ||
              position == SantoFabPosition.topRight)
          ? edgeOffset
          : null,
      top: (position == SantoFabPosition.topRight ||
              position == SantoFabPosition.topLeft)
          ? edgeOffset
          : null,
      bottom: (position == SantoFabPosition.bottomRight ||
              position == SantoFabPosition.bottomLeft)
          ? edgeOffset
          : null,
      child: SantoFab(
        key: key,
        icon: icon,
        text: text,
        onPressed: onPressed,
        backgroundColor: backgroundColor,
        iconColor: iconColor,
        textColor: textColor,
        size: size,
        shape: shape,
        child: child,
        elevation: elevation,
      ),
    );
  }

  /// 获取主题通用配置中的颜色
  Color get _brandPrimary =>
      SantoThemeConfigurator.instance.getConfig().commonConfig.brandPrimary;

  Color get _colorTextBaseInverse => SantoThemeConfigurator.instance
      .getConfig()
      .commonConfig
      .colorTextBaseInverse;

  /// 判断是否为扩展形
  bool get _isExtended =>
      shape == SantoFabShape.extended || (shape == null && text != null);

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? _brandPrimary;
    final iColor = iconColor ?? _colorTextBaseInverse;
    final tColor = textColor ?? _colorTextBaseInverse;

    if (child != null) {
      return Material(
        elevation: elevation,
        borderRadius: BorderRadius.circular(size / 2),
        color: bgColor,
        child: InkWell(
          customBorder:
              _isExtended ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(size / 2)) : const CircleBorder(),
          onTap: onPressed,
          child: child,
        ),
      );
    }

    if (_isExtended) {
      return _buildExtended(bgColor, iColor, tColor);
    }
    return _buildCircle(bgColor, iColor);
  }

  /// 构建圆形按钮
  Widget _buildCircle(Color bgColor, Color iColor) {
    return Material(
      elevation: elevation,
      shape: CircleBorder(),
      color: bgColor,
      child: InkWell(
        customBorder: CircleBorder(),
        onTap: onPressed,
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          child: icon != null
              ? Icon(icon, color: iColor, size: size * 0.45)
              : const SizedBox.shrink(),
        ),
      ),
    );
  }

  /// 构建扩展形按钮
  Widget _buildExtended(Color bgColor, Color iColor, Color tColor) {
    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(size / 2),
      color: bgColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(size / 2),
        onTap: onPressed,
        child: Container(
          height: size,
          padding: EdgeInsets.symmetric(horizontal: size * 0.4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Padding(
                  padding: EdgeInsets.only(right: text != null ? 8 : 0),
                  child: Icon(icon, color: iColor, size: size * 0.4),
                ),
              if (text != null)
                Text(
                  text!,
                  style: TextStyle(
                    color: tColor,
                    fontSize: size * 0.28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
