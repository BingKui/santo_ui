import 'dart:math';

import 'package:santo_ui/src/components/button/santo_normal_button.dart';
import 'package:santo_ui/src/constants/santo_constants.dart';
import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:santo_ui/src/theme/santo_theme.dart';
import 'package:flutter/material.dart';

/// 默认最小宽度
const double _BMinWidth = 84;

/// 小号的幽灵按钮，背景为主题色 5% 透明度、文字为主题色
///
/// 和 [SantoSmallOutlineButton] 相比，该按钮没有边框，背景为浅主题色
///
/// 该按钮有一个最小的宽度84，在此基础上，宽度随着文本内容的多少变更；
/// 自定义 [insertPadding] 后按钮宽高完全由内容决定
///
/// 其他按钮如下：
///  * [SantoBigGhostButton], 大幽灵按钮
///  * [SantoSmallMainButton], 小主色调按钮
///  * [SantoSmallOutlineButton], 小边框按钮
class SantoSmallGhostButton extends StatelessWidget {
  /// 按钮显示文案，默认'确认'
  final String? title;

  /// 文案颜色，默认主题色
  final Color? titleColor;

  /// 按钮背景颜色，默认主题色的 5% 透明度
  final Color? backgroundColor;

  /// 点击的回调
  final VoidCallback? onTap;

  /// 圆角
  final double? radius;

  /// 宽度
  final double? width;

  /// 字体weight
  final FontWeight fontWeight;

  /// 字体大小
  final double fontSize;

  /// 按钮内边距，默认水平6、垂直8；
  /// 自定义后按钮宽高完全由内容决定（不再套用最小宽84、最小高 smallButtonHeight），
  /// 传更小的值即可得到更小的按钮
  final EdgeInsetsGeometry? insertPadding;

  /// 配置样式
  final SantoButtonConfig? themeData;

  /// create SantoSmallGhostButton
  const SantoSmallGhostButton({
    Key? key,
    this.title,
    this.onTap,
    this.titleColor,
    this.backgroundColor,
    this.radius,
    this.width,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w600,
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
        .buttonConfig
        .merge(defaultThemeConfig);

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
        // 与实际渲染一致：Text 会合并环境 DefaultTextStyle，测量也必须合并
        textPainter.text = TextSpan(
            text: title ?? SantoIntl.of(context).localizedResource.confirm,
            style: DefaultTextStyle.of(context).style.merge(style));
        textPainter.layout(maxWidth: con.maxWidth);
        double textWidth = textPainter.width;
        double _maxWidth =
            (textWidth + effectivePadding.horizontal).ceilToDouble();

        double _minWidth =
            insertPadding == null ? min(_BMinWidth, con.maxWidth) : 0;
        if (_maxWidth <= _minWidth) {
          _maxWidth = _minWidth;
        }
        if (_maxWidth > con.maxWidth) {
          _maxWidth = con.maxWidth;
        }

        return SantoNormalButton(
          constraints: BoxConstraints(
            minWidth: this.width ?? _minWidth,
            maxWidth: this.width ?? _maxWidth,
            minHeight: insertPadding == null
                ? defaultThemeConfig.smallButtonHeight
                : 0.0,
          ),
          borderRadius: BorderRadius.all(
              Radius.circular(defaultThemeConfig.smallButtonRadius)),
          text: title ?? SantoIntl.of(context).localizedResource.confirm,
          backgroundColor: backgroundColor ??
              defaultThemeConfig.commonConfig.brandPrimary.withOpacity(0.05),
          onTap: onTap,
          alignment: Alignment.center,
          fontWeight: fontWeight,
          fontSize: defaultThemeConfig.smallButtonFontSize,
          insertPadding: effectivePadding,
          textColor:
              titleColor ?? defaultThemeConfig.commonConfig.brandPrimary,
        );
      },
    );
  }
}
