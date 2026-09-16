import 'dart:math' as math;
import 'dart:ui' show PathMetric;

import 'package:santo_ui/src/components/button/santo_press_feedback.dart';
import 'package:santo_ui/src/constants/santo_constants.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/utils/santo_multi_click_util.dart';
import 'package:flutter/material.dart';

const double _BFontSize = 16;
const Color _BTextColor = Colors.white;
const Color _BBackgroundColor = Color(0xFF1677FF);
const Color _BDisableBackgroundColor = Color(0xFFCCCCCC);
const FontWeight _BFontWeight = FontWeight.bold;
const double _BRadius = 12;
const Color _BOutlineLineColor = Color(0xFFDCDEE2);
const Color _BOutlineDisableLineColor = Color(0xFFCCCCCC);

/// 图标与文案之间的间距
const double _kIconGap = 8;

/// 按钮类型,对标 antd Button 的 type
enum SantoButtonType {
  /// 主按钮:品牌色实心,一个操作区最多一个
  primary,

  /// 默认按钮:白底 + 实线边框(对应 antd 的 default)
  normal,

  /// 虚线按钮:白底 + 虚线边框
  dashed,

  /// 文本按钮:无底色无边框
  text,

  /// 链接按钮:无底色无边框,文字使用主题色
  link,
}

/// 图标相对文案的位置
enum SantoButtonIconPlacement {
  /// 图标在文案前
  start,

  /// 图标在文案后
  end,
}

/// 通用按钮，支持用户设置背景色、是否可用等属性
/// 若[SantoBigMainButton]、[SantoSmallMainButton]、[SantoBigOutlineButton]不能满足用户需要
/// 可以直接使用该按钮
///
/// [isEnable]如果设置为false，那么按钮呈现灰色态，点击事件不响应
///
/// 默认使用[Text]文本组件，如果用户想要显示其他组件。比如图片等，可以设置[child]属性
///
/// 文本组件需要的样式属性，可以通过[textStyle]设置，也可以通过[fontSize]等单独设置
///
/// 该组件的布局规则参考[Container]的布局规则
/// 该组件的[alignment]的属性默认为null,即使父布局给的约束是无边界(最大宽度或者最大高度是double.infinity.)
/// 组件的尺寸也会和child一样大。
/// 那就是说：不给[alignment]属性设置值，即使把[SantoNormalButton],放到[column]、[ListView]中，
/// 他也会尽可能的小。如果设置了[constraints]属性，那么就会按着[constraints]布局。
///
/// 案例一
/// ```dart
/// SantoNormalButton(
///    text: '主案特别长',
///    onTap: () {
///         SantoToast.show('点击了主按钮', context);
///    },
/// )
/// ```
/// 按钮的大小就是text的大小+内边距的大小
///
/// 案例二
/// ```dart
/// SantoNormalButton(
///    constraints: BoxConstraints.expand(height: 60),
///    text: '主案特别长',
///    onTap: () {
///         SantoToast.show('点击了主按钮', context);
///    },
/// )
/// ```
/// 按钮的大小：宽度充满父布局、高度是60
///
/// 如果给该组件的[alignment]赋值了，父布局的约束是有边界。
/// 该组件的尺寸就是父布局的约束， 并且会按着[alignment]属性来摆放[text]或者[child],比如居中摆放等.
///
/// 案例一
/// ```dart
/// SantoNormalButton(
///    alignment: Alignment.center,
///    text: '主案特别长',
///    onTap: () {
///         SantoToast.show('点击了主按钮', context);
///    },
/// )
/// ```
/// 按钮的大小：宽度充满父布局  文字居中摆放
///
/// 设置[type]后可对标 antd 的五种按钮:
/// ```dart
/// SantoNormalButton(text: '主按钮', type: SantoButtonType.primary, onTap: () {});
/// SantoNormalButton(text: '默认按钮', type: SantoButtonType.normal, onTap: () {});
/// SantoNormalButton(text: '虚线按钮', type: SantoButtonType.dashed, onTap: () {});
/// SantoNormalButton(text: '文本按钮', type: SantoButtonType.text, onTap: () {});
/// SantoNormalButton(text: '链接按钮', type: SantoButtonType.link, onTap: () {});
/// ```
///
/// * [SantoBigMainButton], 大主色调按钮
/// * [SantoBigOutlineButton], 大边框按钮
/// * [SantoSmallMainButton], 小主色调按钮
/// * [SantoSmallOutlineButton], 小边框按钮
///
class SantoNormalButton extends StatelessWidget {
  /// 按钮是否可用 默认是true
  final bool isEnable;

  /// 按钮点击的回调
  final VoidCallback? onTap;

  /// 按钮显示的文案,与 [child] 至少提供一个
  final String? text;

  /// 按钮的文字颜色;未设置时由[type]决定,未设置[type]时使用默认白色[_BTextColor]
  final Color? textColor;

  /// 按钮的文字大小 默认[_BFontSize]
  final double fontSize;

  /// 按钮不可用的文字颜色
  final Color? disableTextColor;

  /// 按钮背景色 默认[_BBackgroundColor];设置[type]后由类型决定
  final Color backgroundColor;

  /// 按钮不可用背景色 默认[_BDisableBackgroundColor]
  final Color disableBackgroundColor;

  /// 按钮内边距 默认水平[_BHorizontalPadding] 垂直[_BVerticalPadding]
  final EdgeInsetsGeometry insertPadding;

  /// 按钮的修饰 默认实色背景,设置后优先级最高
  final Decoration? decoration;

  /// 按钮的显示子节点 优先级高于[text]
  final Widget? child;

  /// 按钮的文本显示样式 优先级高于[textColor]等属性
  final TextStyle? textStyle;

  /// 按钮的文本Weight 默认是[FontWeight.bold]
  final FontWeight fontWeight;

  /// 按钮的布局约束 默认是自适应大小
  final BoxConstraints constraints;

  /// 按钮的内部对齐 默认为null
  final Alignment? alignment;

  /// 按钮圆角大小
  final BorderRadiusGeometry borderRadius;

  /// 按钮类型,对标 antd Button type;为 null 时使用[backgroundColor]/[decoration]的旧逻辑
  final SantoButtonType? type;

  /// 危险按钮,用于删除/授权等风险操作;与[type]组合使用
  final bool danger;

  /// 是否展示加载中,加载中不可点击
  final bool loading;

  /// 是否占满父布局宽度
  final bool block;

  /// 文案前的图标
  final Widget? icon;

  /// 图标相对文案的位置,默认[SantoButtonIconPlacement.start]
  final SantoButtonIconPlacement iconPlacement;

  /// 中文文案为两个汉字时,是否自动在中间加空格(对标 antd autoInsertSpace),默认 true
  final bool autoInsertSpace;

  /// create SantoNormalButton
  SantoNormalButton({
    Key? key,
    this.text,
    this.backgroundColor = _BBackgroundColor,
    this.isEnable = true,
    this.onTap,
    this.insertPadding = const EdgeInsets.symmetric(
        vertical: SantoButtonConstant.verticalPadding,
        horizontal: SantoButtonConstant.horizontalPadding),
    this.decoration,
    this.child,
    this.textStyle,
    this.fontWeight = _BFontWeight,
    this.fontSize = _BFontSize,
    this.textColor,
    this.disableTextColor,
    this.disableBackgroundColor = _BDisableBackgroundColor,
    this.constraints = const BoxConstraints.tightFor(),
    this.borderRadius = const BorderRadius.all(Radius.circular(_BRadius)),
    this.alignment,
    this.type,
    this.danger = false,
    this.loading = false,
    this.block = false,
    this.icon,
    this.iconPlacement = SantoButtonIconPlacement.start,
    this.autoInsertSpace = true,
  })  : assert(text != null || child != null),
        super(key: key);

  SantoNormalButton.outline({
    Key? key,
    Color? disableLineColor,
    Color? lineColor,
    double radius = 12,
    double borderWith = 1.0,
    this.text,
    this.isEnable = true,
    this.backgroundColor = _BBackgroundColor,
    this.disableBackgroundColor = _BDisableBackgroundColor,
    this.alignment,
    this.child,
    this.onTap,
    this.textColor,
    this.fontWeight = _BFontWeight,
    this.fontSize = _BFontSize,
    this.disableTextColor,
    this.insertPadding = const EdgeInsets.symmetric(
        vertical: SantoButtonConstant.verticalPadding,
        horizontal: SantoButtonConstant.horizontalPadding),
    this.textStyle,
    this.constraints = const BoxConstraints.tightFor(),
    this.borderRadius = const BorderRadius.all(Radius.circular(_BRadius)),
    this.type,
    this.danger = false,
    this.loading = false,
    this.block = false,
    this.icon,
    this.iconPlacement = SantoButtonIconPlacement.start,
    this.autoInsertSpace = true,
  })  : assert(text != null || child != null),
        decoration = _OutlineBoxDecorationCreator.createOutlineBoxDecoration(
            isEnable: isEnable,
            disableBackgroundColor: disableBackgroundColor,
            disableLineColor: disableLineColor,
            lineColor: lineColor,
            backgroundColor: backgroundColor,
            radius: radius,
            borderWith: borderWith),
        super(key: key);

  SantoCommonConfig get _commonConfig =>
      SantoThemeConfigurator.instance.getConfig().commonConfig;

  /// 加载中或不可用时不可点击
  bool get _clickable => isEnable && !loading && onTap != null;

  @override
  Widget build(BuildContext context) {
    final Widget content = _buildContent();

    Widget result = Container(
      alignment: alignment,
      decoration: decoration ?? _resolveDecoration(),
      constraints: block
          ? const BoxConstraints.tightFor(width: double.infinity)
          : constraints,
      padding: insertPadding,
      child: content,
    );

    // 虚线按钮:BoxDecoration 不支持虚线,用前景画笔描边
    if (type == SantoButtonType.dashed && decoration == null) {
      result = CustomPaint(
        foregroundPainter: _DashedBorderPainter(
          color: _resolveLineColor(),
          radius: _resolveRadiusValue(),
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

  /// 文案/图标组合,支持图标位置与加载中
  Widget _buildContent() {
    final Widget? leading = loading
        ? _buildLoadingIndicator()
        : (iconPlacement == SantoButtonIconPlacement.start ? icon : null);
    final Widget? trailing = loading
        ? null
        : (iconPlacement == SantoButtonIconPlacement.end ? icon : null);

    if (child != null && leading == null && trailing == null) {
      return child!;
    }

    Widget textWidget = child ??
        (text == null
            ? const SizedBox.shrink()
            : Text(
                _resolveText(),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: _getTextStyle(),
              ));

    if (leading == null && trailing == null) {
      return textWidget;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ?leading,
        if (leading != null) const SizedBox(width: _kIconGap),
        Flexible(child: textWidget),
        if (trailing != null) const SizedBox(width: _kIconGap),
        ?trailing,
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: fontSize,
      height: fontSize,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(_resolveTextColor()),
      ),
    );
  }

  /// 中文两字之间自动补空格
  String _resolveText() {
    final String content = text ?? '';
    if (!autoInsertSpace ||
        type == null ||
        textStyle != null ||
        child != null ||
        content.characters.length != 2) {
      return content;
    }
    final bool isChinese = content.runes.every((rune) =>
        rune >= 0x4E00 && rune <= 0x9FFF);
    if (!isChinese) {
      return content;
    }
    return '${content.characters.first} ${content.characters.last}';
  }

  double _resolveRadiusValue() {
    if (borderRadius is BorderRadius) {
      final Radius? radius = (borderRadius as BorderRadius).topLeft;
      if (radius != null) return radius.x;
    }
    return _BRadius;
  }

  Color _resolveLineColor() {
    if (!isEnable) return _BOutlineDisableLineColor;
    if (danger) return _commonConfig.brandError;
    return _commonConfig.borderColorBase;
  }

  Color _resolveTextColor() {
    if (textStyle != null) return _BTextColor;
    if (!isEnable) {
      return disableTextColor ?? _commonConfig.colorTextDisabled;
    }
    // 显式指定的文字颜色优先于按钮类型的默认色
    if (textColor != null) return textColor!;
    if (type == null) return _BTextColor;
    if (danger) return _commonConfig.brandError;
    switch (type!) {
      case SantoButtonType.primary:
        return _BTextColor;
      case SantoButtonType.link:
        return _commonConfig.brandPrimary;
      case SantoButtonType.normal:
      case SantoButtonType.dashed:
      case SantoButtonType.text:
        return _commonConfig.colorTextBase;
    }
  }

  /// 按类型解析底色/边框
  BoxDecoration _resolveDecoration() {
    if (type == null) {
      return _getBoxDecoration(_getBackgroundColor());
    }

    final bool filled = type == SantoButtonType.primary;
    final bool bordered =
        type == SantoButtonType.normal || type == SantoButtonType.dashed;
    final Color background = filled
        ? (danger ? _commonConfig.brandError : _commonConfig.brandPrimary)
        : (bordered ? _commonConfig.fillBase : Colors.transparent);

    return BoxDecoration(
      color: isEnable ? background : _disabledBackground(filled, bordered),
      borderRadius: borderRadius,
      border: bordered
          ? Border.all(
              color: isEnable
                  ? _resolveLineColor()
                  : _commonConfig.borderColorBase,
              width: 1,
            )
          : null,
    );
  }

  Color _disabledBackground(bool filled, bool bordered) {
    if (filled) return disableBackgroundColor;
    return bordered ? _commonConfig.fillBase : Colors.transparent;
  }

  TextStyle _getTextStyle() {
    if (textStyle != null) {
      return textStyle!;
    }
    return TextStyle(
      fontSize: fontSize,
      color: _resolveTextColor(),
      fontWeight: fontWeight,
    );
  }

  Color _getBackgroundColor() {
    return isEnable ? backgroundColor : disableBackgroundColor;
  }

  BoxDecoration _getBoxDecoration(Color? bgColor) {
    return BoxDecoration(
      color: bgColor,
      borderRadius: borderRadius,
    );
  }
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

class _OutlineBoxDecorationCreator {
  static BoxDecoration createOutlineBoxDecoration({
    required bool isEnable,
    Color? disableLineColor,
    Color? lineColor,
    required Color backgroundColor,
    required Color disableBackgroundColor,
    double radius = 12,
    double borderWith = 1.0,
  }) {
    Color _lineColor = isEnable
        ? (lineColor ?? _BOutlineLineColor)
        : (disableLineColor ?? _BOutlineDisableLineColor);
    Color _bgColor = isEnable ? backgroundColor : disableBackgroundColor;

    return BoxDecoration(
        border: Border.all(color: _lineColor, width: borderWith),
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        color: _bgColor);
  }
}
