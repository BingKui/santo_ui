

import 'package:santo_ui/src/components/button/santo_normal_button.dart';
import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:santo_ui/src/theme/santo_theme.dart';
import 'package:flutter/material.dart';

/// 页面中和主题色相关的幽灵按钮 可以支持自定义背景颜色、文字颜色等
///
/// 和[SantoBigMainButton]相比，该按钮的背景色仅仅是其背景色的withOpacity(0.1)
/// 并且该按钮不支持不可用状态
///
/// 按钮是圆角矩形的形状，不支持改变形状。
///
/// SantoBigGhostButtonWidget(
///    title: '提交',
/// )
///
/// 其他按钮如下：
///  * [SantoBigMainButton], 大主色调按钮
///  * [SantoBigOutlineButton], 大边框按钮

class SantoBigGhostButton extends StatelessWidget {
  /// 按钮文案，默认'确认'
  final String? title;

  /// 文案颜色
  final Color? titleColor;

  /// 按钮背景颜色
  final Color? bgColor;

  /// 点击回调
  final VoidCallback? onTap;

  /// 默认父布局可用空间
  final double? width;

  /// button theme config
  final SantoButtonConfig? themeData;

  /// create SantoBigGhostButton
  const SantoBigGhostButton({
    Key? key,
    this.title,
    this.titleColor,
    this.bgColor,
    this.onTap,
    this.width,
    this.themeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SantoButtonConfig defaultThemeConfig = themeData ?? SantoButtonConfig();
    defaultThemeConfig = SantoThemeConfigurator.instance
        .getConfig(configId: defaultThemeConfig.configId)
        .buttonConfig.merge(defaultThemeConfig);

    return SantoNormalButton(
      borderRadius: BorderRadius.circular(defaultThemeConfig.bigButtonRadius),
      constraints: BoxConstraints.tightFor(
          width: width ?? double.infinity,
          height: defaultThemeConfig.bigButtonHeight),
      backgroundColor: bgColor ??
          defaultThemeConfig.commonConfig.brandPrimary.withOpacity(0.05),
      onTap: onTap,
      alignment: Alignment.center,
      text: title ?? SantoIntl.of(context).localizedResource.confirm,
      textColor: titleColor ?? defaultThemeConfig.commonConfig.brandPrimary,
      fontSize: defaultThemeConfig.bigButtonFontSize,
    );
  }
}
