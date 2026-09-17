import 'package:santo_ui/src/components/tag/santo_tag_custom.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

///
/// 状态标签是反应状态的形式，根据不同的[tagState]呈现不同的背景色和文字颜色
///
/// [TagState]内置了五种状态，如果内置的状态不满足显示需要，可以根据[backgroundColor]和[textColor]灵活组合
///
/// 状态标签是在自定义标签的基础上[SantoTagCustom],进行具体化实现：圆角固定为2，构造参数减少等
///
/// 如果有其他更多自定义的诉求 请参考[SantoTagCustom]
///
/// 其他标签的实现
/// * [SantoTagCustom], 高度自定义的通用标签
///
class SantoStateTag extends StatelessWidget {
  final String tagText;
  final TagState tagState;
  final Color? backgroundColor;
  final Color? textColor;

  /// 状态标签是反应状态的形式，根据不同的[tagState]呈现不同的背景色和文字颜色
  /// 默认为等待状态, 黄色
  const SantoStateTag({
    Key? key,
    required this.tagText,
    this.tagState = TagState.waiting,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return SantoTagCustom(
      tagText: tagText,
      textPadding: EdgeInsets.only(
          bottom: 0,
          left: commonConfig.hSpacingXs,
          right: commonConfig.hSpacingXs,
          top: 0),
      textColor: textColor ?? getTagColor(tagState),
      backgroundColor:
          backgroundColor ?? getTagColor(tagState).withOpacity(0.1),
    );
  }

  /// 根据状态获取背景色
  /// [state] 状态, 默认为 waiting
  Color getTagColor(TagState state) {
    switch (state) {
      case TagState.invalidate:
        return Color(0xFF808695);
      case TagState.running:
        return Color(0xFF1677FF);
      case TagState.failed:
        return Color(0xFFFF4D4F);
      case TagState.succeed:
        return Color(0xFF52C41A);
      case TagState.waiting:
        return Color(0xFFFAAD14);
    }
  }
}

enum TagState {
  ///等待
  waiting,

  ///失效
  invalidate,

  ///运行
  running,

  ///失败
  failed,

  ///成功
  succeed
}
