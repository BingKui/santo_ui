import 'package:santo_ui/src/components/chat/model/santo_chat_message.dart';
import 'package:santo_ui/src/components/icon/santo_icon.dart';
import 'package:santo_ui/src/components/icon/santo_icons.dart';
import 'package:santo_ui/src/theme/configs/santo_chat_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 文档卡片的展示宽度
const double kSantoChatDocWidth = 220;

/// 会话文档消息:一张文档卡片(标题 + 附言 + 「点击查看文档」)
///
/// 卡片自带白底与描边,不套气泡;点击后回调 [onTap],由业务方校验权限并打开文档。
///
/// @since v1.5.0
class SantoChatDocCard extends StatelessWidget {
  /// 文档消息
  final SantoChatDocMessage message;

  /// 点击回调
  final ValueChanged<SantoChatDocMessage>? onTap;

  const SantoChatDocCard({
    Key? key,
    required this.message,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SantoChatConfig config =
        SantoThemeConfigurator.instance.getConfig().chatConfig;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap == null ? null : () => onTap!(message),
      child: Container(
        constraints: const BoxConstraints(maxWidth: kSantoChatDocWidth),
        padding: EdgeInsets.all(config.commonConfig.hSpacingSm),
        decoration: BoxDecoration(
          color: config.otherBubbleColor,
          border: Border.all(
            color: config.commonConfig.dividerColorBase,
            width: config.commonConfig.borderWidthSm,
          ),
          borderRadius: BorderRadius.circular(config.commonConfig.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SantoIcon(
                  SantoIcons.page,
                  size: config.commonConfig.iconSizeMd,
                  color: config.commonConfig.brandPrimary,
                ),
                SizedBox(width: config.commonConfig.hSpacingSm),
                Expanded(
                  child: Text(
                    message.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: config.otherTextStyle.generateTextStyle(),
                  ),
                ),
                SizedBox(width: config.commonConfig.hSpacingXs),
                SantoIcon(
                  SantoIcons.navArrowRight,
                  size: config.commonConfig.iconSizeSm,
                  color: config.commonConfig.colorTextHint,
                ),
              ],
            ),
            if (message.content != null && message.content!.isNotEmpty) ...<Widget>[
              SizedBox(height: config.commonConfig.vSpacingXs),
              Text(
                message.content!,
                style: config.timeTextStyle
                    .generateTextStyle()
                    .copyWith(color: config.commonConfig.colorTextSecondary),
              ),
            ],
            SizedBox(height: config.commonConfig.vSpacingXs),
            Text(
              '点击查看文档',
              style: TextStyle(
                fontSize: config.commonConfig.fontSizeCaptionSm,
                color: config.commonConfig.brandPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
