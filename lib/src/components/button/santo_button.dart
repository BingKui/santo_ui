import 'dart:math' as math;
import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';
import 'package:santo_ui/src/components/button/santo_press_feedback.dart';
import 'package:santo_ui/src/theme/configs/santo_button_config.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/utils/santo_multi_click_util.dart';

/// 按钮类型,对标 antd Button 的 type 语法糖,等价于 [SantoButtonColor] + [SantoButtonVariant]
enum SantoButtonType {
  /// 主按钮:品牌色实心,一个操作区最多一个
  primary,

  /// 默认按钮:白底 + 实线边框
  normal,

  /// 虚线按钮:白底 + 虚线边框
  dashed,

  /// 文本按钮:无底色无边框
  text,

  /// 链接按钮:无底色无边框,文字使用主题色
  link,
}

/// 按钮颜色,对标 antd Button 的 color;取主题里的语义色令牌
enum SantoButtonColor {
  /// 中性色:文字/边框使用常规文字色,对标 antd 的 color="default"
  neutral,

  /// 主题色
  primary,

  /// 失败色,用于删除、授权等风险操作
  danger,

  /// 成功色
  success,

  /// 警告色
  warning,

  /// 信息色(取主题的辅助色 brandAuxiliary)
  info,
}

/// 按钮变体,对标 antd Button 的 variant
enum SantoButtonVariant {
  /// 描边:白底 + 实线边框
  outlined,

  /// 虚线:白底 + 虚线边框
  dashed,

  /// 实心:纯色底 + 反色文字
  solid,

  /// 浅色填充:颜色 10% 透明度底 + 同色文字
  filled,

  /// 文本:无底无边框
  text,

  /// 链接:无底无边框,文字使用颜色色值
  link,
}

/// 按钮尺寸,对标 antd Button 的 size
enum SantoButtonSize {
  /// 大:高 48、字号 16
  large,

  /// 中:高 32、字号 14、最小宽 84
  middle,

  /// 小:高 24、字号 12
  small,
}

/// 按钮形状,对标 antd Button 的 shape
enum SantoButtonShape {
  /// 圆角矩形
  normal,

  /// 两端半圆
  round,

  /// 圆形(仅图标)
  circle,
}

/// 图标相对文案的位置
enum SantoButtonIconPlacement {
  /// 图标在文案前
  start,

  /// 图标在文案后
  end,

  /// 图标在文案上方
  top,

  /// 图标在文案下方
  bottom,
}

/// 按钮内边距
const EdgeInsets _kLargePadding = EdgeInsets.symmetric(
  horizontal: 15,
  vertical: 10,
);
const EdgeInsets _kMiddlePadding = EdgeInsets.symmetric(
  horizontal: 10,
  vertical: 5,
);
const EdgeInsets _kSmallPadding = EdgeInsets.symmetric(horizontal: 5);

/// 中号按钮的最小宽度
const double _kMiddleMinWidth = 84;

/// 实心按钮的默认置灰底色
const Color _kDisableBackgroundColor = Color(0xFFCCCCCC);

/// 通用按钮,库内唯一的按钮入口
///
/// 类型、大小、颜色、形状、图标等差异全部通过参数配置,对标 antd Button:
///
/// * 类型 [SantoButtonType]:primary / normal / dashed / text / link
/// * 颜色 [SantoButtonColor] 与变体 [SantoButtonVariant]:可组合出更多样式
/// * 尺寸 [SantoButtonSize]:large / middle / small
/// * 形状 [SantoButtonShape]:normal / round / circle
/// * 状态 [danger] / [ghost] / [loading] / [block] / [isEnable]
/// * 图标 [icon]、[iconPlacement](start / end / top / bottom)、[iconSize]
///
/// 使用 [type] 时可对标 antd 的五种按钮:
/// ```dart
/// SantoButton(text: '主按钮', type: SantoButtonType.primary, onTap: () {});
/// SantoButton(text: '默认按钮', type: SantoButtonType.normal, onTap: () {});
/// SantoButton(text: '虚线按钮', type: SantoButtonType.dashed, onTap: () {});
/// SantoButton(text: '文本按钮', type: SantoButtonType.text, onTap: () {});
/// SantoButton(text: '链接按钮', type: SantoButtonType.link, onTap: () {});
/// ```
///
/// [text] 与 [child] 至少提供一个;[child] 存在时优先展示 [child]。
/// 文本样式优先取 [textStyle],其次取 [textColor]/[fontSize]/[fontWeight]。
///
/// 该组件的布局规则参考 [Container]:不给 [alignment] 赋值时,按钮尺寸贴合内容;
/// 给了 [alignment] 或 [block] 为 true 时,按钮按父布局约束撑开。
class SantoButton extends StatelessWidget {
  /// 按钮显示的文案,与 [child] 至少提供一个
  final String? text;

  /// 按钮的显示子节点 优先级高于 [text]
  final Widget? child;

  /// 按钮类型,对标 antd Button type;与 [color]/[variant] 同时设置时以 [color]/[variant] 为准
  final SantoButtonType? type;

  /// 按钮颜色,对标 antd Button color;为 null 时由 [type]/[danger] 决定
  final SantoButtonColor? color;

  /// 按钮变体,对标 antd Button variant;为 null 时由 [type] 决定,默认 [SantoButtonVariant.outlined]
  final SantoButtonVariant? variant;

  /// 危险按钮,用于删除/授权等风险操作;开启后颜色固定为 [SantoButtonColor.danger]
  final bool danger;

  /// 幽灵按钮:背景透明,用于深色/彩色背景之上
  final bool ghost;

  /// 按钮尺寸,默认 [SantoButtonSize.middle]
  final SantoButtonSize size;

  /// 按钮形状,默认 [SantoButtonShape.normal]
  final SantoButtonShape shape;

  /// 是否占满父布局宽度
  final bool block;

  /// 是否展示加载中,加载中不可点击
  final bool loading;

  /// 按钮是否可用,false 时置灰且不响应点击
  final bool isEnable;

  /// 文案前的图标
  final Widget? icon;

  /// 图标相对文案的位置,默认 [SantoButtonIconPlacement.start]
  final SantoButtonIconPlacement iconPlacement;

  /// 图标的边长;设置后图标会被约束为方形,为 null 时图标保持自身大小
  final double? iconSize;

  /// 中文文案为两个汉字时,是否自动在中间加空格(对标 antd autoInsertSpace),默认 true
  final bool autoInsertSpace;

  /// 按钮点击的回调
  final VoidCallback? onTap;

  /// 按钮的文字颜色,优先级高于类型默认色,低于禁用态配色
  final Color? textColor;

  /// 按钮背景色,优先级高于类型默认色,低于禁用态配色
  final Color? backgroundColor;

  /// 按钮不可用的文字颜色
  final Color? disableTextColor;

  /// 按钮不可用的背景色,默认实心按钮为 [_kDisableBackgroundColor],
  /// 描边/虚线按钮为该色的 10% 透明度
  final Color? disableBackgroundColor;

  /// 描边/虚线按钮的边框颜色,优先级高于类型默认色
  final Color? lineColor;

  /// 按钮内边距,默认按 [size] 取主题间距
  final EdgeInsetsGeometry? insertPadding;

  /// 按钮的文字大小,默认按 [size] 取主题配置
  final double? fontSize;

  /// 按钮的文本Weight,默认 [FontWeight.w500]
  final FontWeight fontWeight;

  /// 按钮的文本显示样式 优先级高于 [textColor] 等属性
  final TextStyle? textStyle;

  /// 按钮圆角大小,默认按 [size] 取主题配置;[shape] 为 round/circle 时为高度的一半
  final BorderRadiusGeometry? borderRadius;

  /// 按钮的布局约束,默认按 [size] 自适应;设置后优先级最高(block 除外)
  final BoxConstraints? constraints;

  /// 按钮宽度,等价于把最小/最大宽度同时固定为该值
  final double? width;

  /// 按钮的内部对齐 默认为null
  final Alignment? alignment;

  /// 按钮的修饰 默认按类型生成,设置后优先级最高
  final Decoration? decoration;

  const SantoButton({
    Key? key,
    this.text,
    this.child,
    this.type,
    this.color,
    this.variant,
    this.danger = false,
    this.ghost = false,
    this.size = SantoButtonSize.middle,
    this.shape = SantoButtonShape.normal,
    this.block = false,
    this.loading = false,
    this.isEnable = true,
    this.icon,
    this.iconPlacement = SantoButtonIconPlacement.start,
    this.iconSize,
    this.autoInsertSpace = true,
    this.onTap,
    this.textColor,
    this.backgroundColor,
    this.disableTextColor,
    this.disableBackgroundColor,
    this.lineColor,
    this.insertPadding,
    this.fontSize,
    this.fontWeight = FontWeight.w500,
    this.textStyle,
    this.borderRadius,
    this.constraints,
    this.width,
    this.alignment,
    this.decoration,
  })  : assert(text != null || child != null || icon != null),
        super(key: key);

  SantoCommonConfig get _commonConfig =>
      SantoThemeConfigurator.instance.getConfig().commonConfig;

  SantoButtonConfig get _buttonConfig =>
      SantoThemeConfigurator.instance.getConfig().buttonConfig;

  /// 加载中或不可用时不可点击
  bool get _clickable => isEnable && !loading && onTap != null;

  /// 显式传入的颜色/变体优先,其次由 [type] 语法糖推导
  SantoButtonColor get _resolvedColor {
    if (danger) return SantoButtonColor.danger;
    if (color != null) return color!;
    if (type == SantoButtonType.primary || type == SantoButtonType.link) {
      return SantoButtonColor.primary;
    }
    return SantoButtonColor.neutral;
  }

  SantoButtonVariant get _resolvedVariant {
    if (variant != null) return variant!;
    switch (type) {
      case SantoButtonType.primary:
        return SantoButtonVariant.solid;
      case SantoButtonType.normal:
        return SantoButtonVariant.outlined;
      case SantoButtonType.dashed:
        return SantoButtonVariant.dashed;
      case SantoButtonType.text:
        return SantoButtonVariant.text;
      case SantoButtonType.link:
        return SantoButtonVariant.link;
      case null:
        return SantoButtonVariant.outlined;
    }
  }

  double get _resolvedHeight {
    switch (size) {
      case SantoButtonSize.large:
        return _buttonConfig.largeButtonHeight;
      case SantoButtonSize.middle:
        return _buttonConfig.middleButtonHeight;
      case SantoButtonSize.small:
        return _buttonConfig.smallButtonHeight;
    }
  }

  double get _resolvedFontSize {
    if (fontSize != null) return fontSize!;
    switch (size) {
      case SantoButtonSize.large:
        return _buttonConfig.largeButtonFontSize;
      case SantoButtonSize.middle:
        return _buttonConfig.middleButtonFontSize;
      case SantoButtonSize.small:
        return _buttonConfig.smallButtonFontSize;
    }
  }

  double get _sizeRadius {
    switch (size) {
      case SantoButtonSize.large:
        return _buttonConfig.largeButtonRadius;
      case SantoButtonSize.middle:
        return _buttonConfig.middleButtonRadius;
      case SantoButtonSize.small:
        return _buttonConfig.smallButtonRadius;
    }
  }

  EdgeInsetsGeometry get _defaultPadding {
    switch (size) {
      case SantoButtonSize.large:
        return _kLargePadding;
      case SantoButtonSize.middle:
        return _kMiddlePadding;
      case SantoButtonSize.small:
        return _kSmallPadding;
    }
  }

  BorderRadiusGeometry get _effectiveBorderRadius {
    if (borderRadius != null) return borderRadius!;
    if (shape == SantoButtonShape.round || shape == SantoButtonShape.circle) {
      return BorderRadius.all(Radius.circular(_resolvedHeight / 2));
    }
    return BorderRadius.all(Radius.circular(_sizeRadius));
  }

  double get _radiusValue {
    if (borderRadius is BorderRadius) {
      final Radius? radius = (borderRadius as BorderRadius).topLeft;
      if (radius != null) return radius.x;
    }
    if (shape == SantoButtonShape.round || shape == SantoButtonShape.circle) {
      return _resolvedHeight / 2;
    }
    return _sizeRadius;
  }

  @override
  Widget build(BuildContext context) {
    final _ButtonPalette palette = _resolvePalette();

    Widget result = Container(
      alignment: alignment,
      decoration: decoration ?? _buildDecoration(palette),
      constraints: _buildConstraints(),
      padding: insertPadding ?? _defaultPadding,
      // widthFactor/heightFactor 为 1:宽度贴合内容(不撑满父布局),同时在
      // 高度被 minHeight/block 拉高时把内容垂直居中
      child: Center(
        widthFactor: 1,
        heightFactor: 1,
        child: _buildContent(palette),
      ),
    );

    // 虚线按钮:BoxDecoration 不支持虚线,用前景画笔描边
    if (_resolvedVariant == SantoButtonVariant.dashed && decoration == null) {
      result = CustomPaint(
        foregroundPainter: _DashedBorderPainter(
          color: palette.borderColor ?? _commonConfig.borderColorBase,
          radius: _radiusValue,
        ),
        child: result,
      );
    }

    return SantoPressFeedback(
      onTap: _clickable
          ? () {
              if (SantoMultiClickUtils.isMultiClick()) {
                return;
              }
              onTap!();
            }
          : null,
      child: result,
    );
  }

  BoxConstraints _buildConstraints() {
    final double height = _resolvedHeight;
    if (shape == SantoButtonShape.circle) {
      return BoxConstraints.tightFor(width: height, height: height);
    }
    if (block) {
      return BoxConstraints.tightFor(width: double.infinity, height: height);
    }
    if (constraints != null) return constraints!;
    if (width != null) {
      return BoxConstraints.tightFor(width: width, height: height);
    }
    return BoxConstraints(
      minWidth: size == SantoButtonSize.middle ? _kMiddleMinWidth : 0,
      minHeight: height,
    );
  }

  BoxDecoration _buildDecoration(_ButtonPalette palette) {
    // 虚线变体的描边由 _DashedBorderPainter 画,这里再画实线会把它盖成实线
    final bool drawSolidBorder = palette.borderColor != null &&
        _resolvedVariant != SantoButtonVariant.dashed;
    return BoxDecoration(
      color: palette.background,
      borderRadius: _effectiveBorderRadius,
      border: drawSolidBorder
          ? Border.all(color: palette.borderColor!, width: 1)
          : null,
    );
  }

  /// 解析底色/文字色/边框色:类型默认色 -> 显式颜色 -> 禁用态
  _ButtonPalette _resolvePalette() {
    final SantoCommonConfig cfg = _commonConfig;
    final SantoButtonColor buttonColor = _resolvedColor;
    final SantoButtonVariant buttonVariant = _resolvedVariant;

    final Color accent = switch (buttonColor) {
      SantoButtonColor.primary => cfg.brandPrimary,
      SantoButtonColor.danger => cfg.brandError,
      SantoButtonColor.success => cfg.brandSuccess,
      SantoButtonColor.warning => cfg.brandWarning,
      SantoButtonColor.info => cfg.brandAuxiliary,
      SantoButtonColor.neutral => cfg.colorTextBase,
    };

    Color background;
    Color? borderColor;
    switch (buttonVariant) {
      case SantoButtonVariant.solid:
        background = accent;
      case SantoButtonVariant.outlined:
      case SantoButtonVariant.dashed:
        background = cfg.fillBase;
        borderColor = buttonColor == SantoButtonColor.neutral
            ? cfg.borderColorBase
            : accent;
      case SantoButtonVariant.filled:
        background = accent.withOpacity(0.1);
      case SantoButtonVariant.text:
      case SantoButtonVariant.link:
        background = Colors.transparent;
    }
    Color foreground = buttonVariant == SantoButtonVariant.solid
        ? cfg.colorTextBaseInverse
        : accent;
    if (ghost) {
      // 幽灵按钮铺在彩色背景上:背景透明,文字取该颜色的主色(默认色用反色白),
      // 实心/描边/虚线变体带同色描边,对齐 antd 的 background-ghost
      background = Colors.transparent;
      foreground = buttonColor == SantoButtonColor.neutral
          ? cfg.colorTextBaseInverse
          : accent;
      switch (buttonVariant) {
        case SantoButtonVariant.solid:
        case SantoButtonVariant.outlined:
        case SantoButtonVariant.dashed:
          borderColor = foreground;
        case SantoButtonVariant.filled:
        case SantoButtonVariant.text:
        case SantoButtonVariant.link:
          break;
      }
    }

    // 显式颜色其次
    if (backgroundColor != null) background = backgroundColor!;
    if (lineColor != null) borderColor = lineColor!;
    if (textColor != null) foreground = textColor!;

    if (!isEnable) {
      final bool filled = buttonVariant == SantoButtonVariant.solid;
      if (filled) {
        background =
            disableBackgroundColor ?? _kDisableBackgroundColor;
        foreground =
            disableTextColor ?? cfg.colorTextBaseInverse.withOpacity(0.7);
      } else {
        background = buttonVariant == SantoButtonVariant.outlined ||
                buttonVariant == SantoButtonVariant.dashed
            ? (disableBackgroundColor ?? _kDisableBackgroundColor)
                .withOpacity(0.1)
            : Colors.transparent;
        if (borderColor != null) borderColor = cfg.borderColorBase;
        foreground = disableTextColor ?? cfg.colorTextDisabled;
      }
    }

    return _ButtonPalette(
      background: background,
      foreground: foreground,
      borderColor: borderColor,
    );
  }

  /// 文案/图标组合,支持图标位置与加载中
  Widget _buildContent(_ButtonPalette palette) {
    final Widget? media = _buildMedia(palette);
    final bool hasText = text != null || child != null;
    final Widget textWidget = child ??
        Text(
          _resolveText(),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: _getTextStyle(palette),
        );

    if (media == null) {
      return hasText ? textWidget : const SizedBox.shrink();
    }
    if (!hasText) return media;

    switch (iconPlacement) {
      case SantoButtonIconPlacement.start:
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            media,
            SizedBox(width: _commonConfig.hSpacingSm),
            Flexible(child: textWidget),
          ],
        );
      case SantoButtonIconPlacement.end:
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(child: textWidget),
            SizedBox(width: _commonConfig.hSpacingSm),
            media,
          ],
        );
      case SantoButtonIconPlacement.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            media,
            SizedBox(height: _commonConfig.vSpacingXs),
            textWidget,
          ],
        );
      case SantoButtonIconPlacement.bottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            textWidget,
            SizedBox(height: _commonConfig.vSpacingXs),
            media,
          ],
        );
    }
  }

  /// 加载中展示 loading,否则展示 [icon]
  Widget? _buildMedia(_ButtonPalette palette) {
    if (loading) {
      final double dimension = _resolvedFontSize;
      return SizedBox(
        width: dimension,
        height: dimension,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(palette.foreground),
        ),
      );
    }
    if (icon == null) return null;
    if (iconSize == null) return icon;
    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: FittedBox(fit: BoxFit.contain, child: icon),
    );
  }

  /// 中文两字之间自动补空格,对标 antd 的 autoInsertSpace
  String _resolveText() {
    final String content = text ?? '';
    if (!autoInsertSpace ||
        textStyle != null ||
        child != null ||
        content.characters.length != 2) {
      return content;
    }
    final bool isChinese =
        content.runes.every((rune) => rune >= 0x4E00 && rune <= 0x9FFF);
    if (!isChinese) {
      return content;
    }
    return '${content.characters.first} ${content.characters.last}';
  }

  TextStyle _getTextStyle(_ButtonPalette palette) {
    if (textStyle != null) return textStyle!;
    return TextStyle(
      fontSize: _resolvedFontSize,
      color: palette.foreground,
      fontWeight: fontWeight,
    );
  }
}

/// 按钮解析后的配色
class _ButtonPalette {
  final Color background;
  final Color foreground;
  final Color? borderColor;

  const _ButtonPalette({
    required this.background,
    required this.foreground,
    required this.borderColor,
  });
}

/// 虚线描边画笔
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  static const double _dashLength = 4;
  static const double _dashGap = 3;
  static const double _strokeWidth = 1;

  _DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;

    final Rect rect = Rect.fromLTWH(
      _strokeWidth / 2,
      _strokeWidth / 2,
      size.width - _strokeWidth,
      size.height - _strokeWidth,
    );
    final Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final double next = math.min(distance + _dashLength, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + _dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
