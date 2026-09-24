import 'package:santo_ui/src/components/chat/model/santo_chat_message.dart';
import 'package:santo_ui/src/components/icon/santo_icon.dart';
import 'package:santo_ui/src/components/icon/santo_icons.dart';
import 'package:santo_ui/src/theme/configs/santo_chat_config.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 通知卡片展示宽度
const double kSantoChatNoticeWidth = 280;

/// 通知类型对应的图标名称
const Map<SantoChatNoticeType, String> kSantoChatNoticeIcons =
    <SantoChatNoticeType, String>{
  SantoChatNoticeType.approval: SantoIcons.checkCircle,
  SantoChatNoticeType.message: SantoIcons.chatBubble,
  SantoChatNoticeType.mention: SantoIcons.userPlus,
  SantoChatNoticeType.task: SantoIcons.server,
  SantoChatNoticeType.other: SantoIcons.bell,
};

/// 通知类型对应的取色
Color santoChatNoticeColor(
  SantoCommonConfig commonConfig,
  SantoChatNoticeType type,
) {
  switch (type) {
    case SantoChatNoticeType.approval:
      return commonConfig.brandPrimary;
    case SantoChatNoticeType.message:
      return commonConfig.brandSuccess;
    case SantoChatNoticeType.mention:
      return commonConfig.brandWarning;
    case SantoChatNoticeType.task:
      return commonConfig.colorLink;
    case SantoChatNoticeType.other:
      return commonConfig.colorTextSecondary;
  }
}

/// 通知卡片:类型图标 + 标题(未读红点)+ 时间 + 正文
///
/// 既是 [SantoChatNoticeMessage] 的消息体(自带容器,不套气泡),
/// 也可以直接当通知中心的列表项使用,时间文案由 [timeText] 传入。
///
/// @since v1.5.1
class SantoChatNoticeCard extends StatelessWidget {
  /// 通知消息
  final SantoChatNoticeMessage message;

  /// 右上角的时间文案,为空时不展示
  final String? timeText;

  /// 点击回调(打开通知详情)
  final ValueChanged<SantoChatNoticeMessage>? onTap;

  const SantoChatNoticeCard({
    Key? key,
    required this.message,
    this.timeText,
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
        constraints: const BoxConstraints(maxWidth: kSantoChatNoticeWidth),
        padding: EdgeInsets.symmetric(
          horizontal: config.commonConfig.hSpacingSm,
          vertical: config.commonConfig.vSpacingSm,
        ),
        decoration: BoxDecoration(
          color: config.otherBubbleColor,
          border: Border.all(
            color: config.commonConfig.dividerColorBase,
            width: config.commonConfig.borderWidthSm,
          ),
          borderRadius: BorderRadius.circular(config.commonConfig.radiusMd),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SantoIcon(
              kSantoChatNoticeIcons[message.noticeType]!,
              size: config.commonConfig.iconSizeLg,
              color: santoChatNoticeColor(
                config.commonConfig,
                message.noticeType,
              ),
            ),
            SizedBox(width: config.commonConfig.hSpacingSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      if (!message.read) ...<Widget>[
                        Container(
                          width: config.commonConfig.gapXs + 2,
                          height: config.commonConfig.gapXs + 2,
                          decoration: BoxDecoration(
                            color: config.commonConfig.brandError,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: config.commonConfig.hSpacingXs),
                      ],
                      Expanded(
                        child: Text(
                          message.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: config.otherTextStyle
                              .generateTextStyle()
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (timeText != null && timeText!.isNotEmpty) ...[
                        SizedBox(width: config.commonConfig.hSpacingXs),
                        Text(
                          timeText!,
                          style: TextStyle(
                            color: config.commonConfig.colorTextHint,
                            fontSize: config.commonConfig.fontSizeCaptionSm,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: config.commonConfig.vSpacingXs),
                  Text(
                    message.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: config.timeTextStyle
                        .generateTextStyle()
                        .copyWith(
                          color: config.commonConfig.colorTextSecondary,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
