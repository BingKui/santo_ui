import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

///
/// 用于展示的通用标签
/// 默认是圆角为2的矩形边框，如果不满足需要可以通过[tagBorderRadius]来单独设置
///
/// 该标签的每一部分都支持用户自定义，文本颜色、背景色等等
///
/// 是对Container的封装，减少边框，颜色等模版代码的开发
///
/// ```dart
/// SantoTagCustom(tagText: '标签',)
///
/// SantoTagCustom(tagText: '标签',backgroundColor:Colors.red)
/// ```
///
class SantoTagCustom extends StatelessWidget {
  /// 标签的文字
  final String tagText;

  /// 标签的背景颜色 默认主题色
  final Color? backgroundColor;

  /// 标签的文本颜色 默认F4的反白颜色
  final Color? textColor;

  /// 标签的圆角 默认为2
  /// 如果同时设置了borderRadius、tagBorderRadius字段，优先使用tagBorderRadius字段设置圆角
  final BorderRadius tagBorderRadius;

  /// 标签的padding  默认为3
  final EdgeInsets textPadding;

  /// 文字大小
  final double fontSize;

  /// 文字粗细
  final FontWeight fontWeight;

  /// 最大宽度
  final double? maxWidth;

  /// 标签边框
  final Border? border;

  SantoTagCustom({
    Key? key,
    required this.tagText,
    this.textColor,
    this.backgroundColor,
    this.tagBorderRadius = const BorderRadius.all(Radius.circular(12)),
    this.textPadding =
        const EdgeInsets.only(bottom: 0.5, left: 4, right: 4, top: 0),
    this.border,
    this.fontSize = 11,
    this.fontWeight = FontWeight.normal,
    this.maxWidth,
  }) : super(key: key);

  ///快捷方式生成边框标签
  SantoTagCustom.buildBorderTag({
    Key? key,
    required this.tagText,
    this.backgroundColor = Colors.transparent,
    this.textPadding =
        const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
    this.fontSize = 11,
    this.fontWeight = FontWeight.normal,
    this.tagBorderRadius = const BorderRadius.all(Radius.circular(12)),
    Color? textColor,
    Color? borderColor,
    double borderWidth = 1,
  })  : this.maxWidth = null,
        this.border = Border.all(
          color: borderColor ??
              SantoThemeConfigurator.instance
                  .getConfig()
                  .commonConfig
                  .brandPrimary,
          width: borderWidth,
        ),
        this.textColor = textColor ??
            SantoThemeConfigurator.instance.getConfig().commonConfig.brandPrimary,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // 不设置 alignment:标签默认按内容自适应宽度;
    // 设置 alignment 会让 Container 在有界约束下撑满可用宽度
    return Container(
        constraints: maxWidth != null ? BoxConstraints(maxWidth: maxWidth!) : null,
        decoration: BoxDecoration(
            color: backgroundColor ??
                SantoThemeConfigurator.instance
                    .getConfig()
                    .commonConfig
                    .brandPrimary,
            shape: BoxShape.rectangle,
            borderRadius: tagBorderRadius,
            border: border),
        padding: textPadding,
        child: Text(
          tagText,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: fontSize,
            color: textColor ??
                SantoThemeConfigurator.instance
                    .getConfig()
                    .commonConfig
                    .colorTextBaseInverse,
            fontWeight: fontWeight,
          ),
        ));
  }
}
