

import 'dart:math';

import 'package:santo_ui/src/components/button/santo_normal_button.dart';
import 'package:santo_ui/src/constants/santo_constants.dart';
import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:santo_ui/src/theme/santo_theme.dart';
import 'package:flutter/material.dart';



/// 默认最小宽度
const double _BMinWidth = 84;

/// 默认线宽
const double _BBorderWith = 1;

/// 边框 小、次按钮，小灰框，默认按钮确认,支持自定义边框、文字颜色

/// 小的边框按钮
/// 该按钮有一个最小的宽度84，在此基础上，宽度随着文本内容的多少变更
///
/// 按钮是圆角矩形的形状，只支持设置圆角大小[radius],不支持改变形状。
///
/// 按钮也存在可用和不可用两种状态，[isEnable]如果设置为false，那么按钮呈现灰色态，点击事件不响应
///
/// 其他按钮如下：
///  * [SantoSmallMainButton], 小主色调按钮
class SantoSmallOutlineButton extends StatelessWidget {
  /// 按钮显示文案,默认'确认
  final String? title;

  /// 点击的回调
  final VoidCallback? onTap;

  /// 是否可用，默认为true。false为不可用：置灰、不可点击。
  final bool isEnable;

  /// 边框的颜色，边框颜色，
  final Color? lineColor;

  /// 文字颜色
  final Color? textColor;

  /// 圆角
  final double? radius;

  /// 宽度
  final double? width;

  /// 字体weigh
  final FontWeight fontWeight;

  /// 字体大小
  final double fontSize;

  /// 按钮内边距，默认水平6、垂直8；
  /// 自定义后按钮宽高完全由内容决定（不再套用最小宽84、最小高[santo smallButtonHeight]），
  /// 传更小的值即可得到更小的按钮
  final EdgeInsetsGeometry? insertPadding;

  /// 配置样式
  final SantoButtonConfig? themeData;

  /// 传入属性优先级最高，未传入的走默认配置，更多请看[SantoSmallSecondaryOutlineButtonConfig.defaultConfig]
  const SantoSmallOutlineButton({
    Key? key,
    this.title,
    this.onTap,
    this.isEnable = true,
    this.lineColor,
    this.textColor,
    this.radius,
    this.width,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w500,
    this.insertPadding,
    this.themeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SantoButtonConfig defaultThemeConfig = themeData ?? SantoButtonConfig();

    defaultThemeConfig = defaultThemeConfig.merge(SantoButtonConfig(
      smallButtonFontSize: fontSize,
      smallButtonRadius: radius,
    ));
    defaultThemeConfig = SantoThemeConfigurator.instance
        .getConfig(configId: defaultThemeConfig.configId)
        .buttonConfig.merge(defaultThemeConfig);

    TextPainter textPainter =
        TextPainter(textScaler: MediaQuery.textScalerOf(context));

    final EdgeInsetsGeometry effectivePadding = insertPadding ??
        const EdgeInsets.symmetric(
            vertical: SantoButtonConstant.verticalPadding,
            horizontal: SantoButtonConstant.horizontalPadding);

    return LayoutBuilder(
      builder: (_, con) {
        TextStyle style = TextStyle(
          fontSize: defaultThemeConfig.smallButtonFontSize,
          fontWeight: fontWeight,
        );

        textPainter.textDirection = TextDirection.ltr;
        // 与实际渲染一致：Text 会合并环境 DefaultTextStyle，测量也必须合并，
        // 否则字体族/行高不同会让测出的宽度偏小，文字被省略
        textPainter.text = TextSpan(
            text: title ?? SantoIntl.of(context).localizedResource.confirm,
            style: DefaultTextStyle.of(context).style.merge(style));
        textPainter.layout(maxWidth: con.maxWidth);
        double textWidth = textPainter.width;
        double _maxWidth =
            (textWidth + effectivePadding.horizontal + 2 * _BBorderWith)
                .ceilToDouble();

        double _minWidth = insertPadding == null ? min(_BMinWidth, con.maxWidth) : 0;
        if (_maxWidth <= _minWidth) {
          _maxWidth = _minWidth;
        }
        if (_maxWidth > con.maxWidth) {
          _maxWidth = con.maxWidth;
        }

        return SantoNormalButton.outline(
          constraints: BoxConstraints(
            minWidth: this.width ?? _minWidth,
            maxWidth: this.width ?? _maxWidth,
            minHeight: insertPadding == null
                ? defaultThemeConfig.smallButtonHeight
                : 0.0,
          ),
          borderWith: _BBorderWith,
          radius: defaultThemeConfig.smallButtonRadius,
          text: title ?? SantoIntl.of(context).localizedResource.confirm,
          disableLineColor: defaultThemeConfig.commonConfig.borderColorBase,
          lineColor: lineColor ?? defaultThemeConfig.commonConfig.borderColorBase,
          textColor: textColor ?? defaultThemeConfig.commonConfig.colorTextBase,
          disableTextColor: Color(0xFFCCCCCC),
          isEnable: isEnable,
          alignment: Alignment.center,
          fontWeight: fontWeight,
          fontSize: defaultThemeConfig.smallButtonFontSize,
          insertPadding: effectivePadding,
          onTap: onTap,
          backgroundColor: Colors.white,
          disableBackgroundColor: Color(0xffcccccc).withOpacity(0.1),
        );
      },
    );
  }
}
