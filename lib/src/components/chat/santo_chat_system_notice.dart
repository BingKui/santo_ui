import 'package:santo_ui/src/theme/configs/santo_chat_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 会话系统消息:居中展示的弱化提示,如「张三加入了群聊」
///
/// @since v1.5.0
class SantoChatSystemNotice extends StatelessWidget {
  /// 提示文案
  final String text;

  /// 外边距,不传取主题间距
  final EdgeInsetsGeometry? margin;

  /// 内边距,不传取主题 [SantoChatConfig.systemPadding]
  final EdgeInsetsGeometry? padding;

  const SantoChatSystemNotice(
    this.text, {
    Key? key,
    this.margin,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SantoChatConfig config =
        SantoThemeConfigurator.instance.getConfig().chatConfig;

    return Container(
      margin: margin ??
          EdgeInsets.symmetric(
            horizontal: config.commonConfig.hSpacingMd,
            vertical: config.commonConfig.vSpacingSm,
          ),
      alignment: Alignment.center,
      child: Container(
        padding: padding ?? config.systemPadding,
        decoration: BoxDecoration(
          color: config.systemBackgroundColor,
          borderRadius: BorderRadius.circular(config.commonConfig.radiusXs),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: config.systemTextStyle.generateTextStyle(),
        ),
      ),
    );
  }
}
