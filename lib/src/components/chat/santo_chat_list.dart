import 'package:santo_ui/src/components/avatar/santo_avatar.dart';
import 'package:santo_ui/src/components/chat/model/santo_chat_conversation.dart';
import 'package:santo_ui/src/components/empty/santo_empty.dart';
import 'package:santo_ui/src/components/icon/santo_icon.dart';
import 'package:santo_ui/src/components/icon/santo_icons.dart';
import 'package:santo_ui/src/theme/configs/santo_chat_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 会话列表头像边长
const double kSantoChatListAvatarSize = 48;

/// 会话列表
///
/// 按传入顺序展示会话行(排序由调用方决定),每行是头像 + 标题 + 最后一条消息摘要 +
/// 时间 + 未读标记。免打扰的会话在头像右下角显示静音角标,未读时只显示红点。
///
/// 是整屏列表组件,需要父级给出确定高度。
///
/// @since v1.5.0
class SantoChatList extends StatelessWidget {
  /// 会话列表
  final List<SantoChatConversation> conversations;

  /// 点击会话回调
  final ValueChanged<SantoChatConversation>? onTap;

  /// 长按会话回调,可用于置顶、免打扰、删除
  final ValueChanged<SantoChatConversation>? onLongPress;

  /// 空状态,不传展示内置空状态
  final Widget? empty;

  /// 列表内边距
  final EdgeInsetsGeometry? padding;

  const SantoChatList({
    Key? key,
    required this.conversations,
    this.onTap,
    this.onLongPress,
    this.empty,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SantoChatConfig config =
        SantoThemeConfigurator.instance.getConfig().chatConfig;

    if (conversations.isEmpty) {
      return empty ??
          Center(
            child: SantoEmpty(
              imageType: SantoEmptyImageType.contentEmpty,
              content: '暂无会话',
              backgroundColor: Colors.transparent,
            ),
          );
    }

    return ListView.separated(
      padding: padding ?? EdgeInsets.zero,
      itemCount: conversations.length,
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          height: config.commonConfig.borderWidthSm,
          margin: EdgeInsets.only(
            left: config.commonConfig.hSpacingMd +
                kSantoChatListAvatarSize +
                config.commonConfig.hSpacingSm,
          ),
          color: config.commonConfig.dividerColorBase,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        return _buildItem(config, conversations[index]);
      },
    );
  }

  Widget _buildItem(SantoChatConfig config, SantoChatConversation conversation) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap == null ? null : () => onTap!(conversation),
      onLongPress:
          onLongPress == null ? null : () => onLongPress!(conversation),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: config.commonConfig.hSpacingMd,
          vertical: config.commonConfig.vSpacingSm,
        ),
        child: Row(
          children: <Widget>[
            _buildAvatar(config, conversation),
            SizedBox(width: config.commonConfig.hSpacingSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          conversation.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: config.otherTextStyle
                              .generateTextStyle()
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      if (conversation.updatedAt != null) ...<Widget>[
                        SizedBox(width: config.commonConfig.hSpacingSm),
                        Text(
                          formatChatListTime(conversation.updatedAt!),
                          style: config.timeTextStyle.generateTextStyle(),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: config.commonConfig.vSpacingXs),
                  Row(
                    children: <Widget>[
                      if (conversation.pinned) ...<Widget>[
                        _buildPinnedTag(config),
                        SizedBox(width: config.commonConfig.hSpacingXs),
                      ],
                      Expanded(
                        child: Text(
                          conversation.preview,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: config.systemTextStyle.generateTextStyle(),
                        ),
                      ),
                      if (conversation.unreadCount > 0) ...<Widget>[
                        SizedBox(width: config.commonConfig.hSpacingSm),
                        _buildUnread(config, conversation),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(SantoChatConfig config, SantoChatConversation conversation) {
    final Widget avatar = SantoAvatar(
      imageUrl: conversation.avatarUrl,
      text: conversation.title.isEmpty ? null : conversation.title.substring(0, 1),
      size: kSantoChatListAvatarSize,
    );
    if (!conversation.muted) return avatar;

    return Stack(
      children: <Widget>[
        avatar,
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: config.commonConfig.iconSizeMd,
            height: config.commonConfig.iconSizeMd,
            decoration: BoxDecoration(
              color: config.commonConfig.colorTextDisabled,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SantoIcon(
                SantoIcons.soundOff,
                size: config.commonConfig.iconSizeXs,
                color: config.commonConfig.colorTextBaseInverse,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPinnedTag(SantoChatConfig config) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: config.commonConfig.hSpacingXs,
      ),
      decoration: BoxDecoration(
        color: config.commonConfig.fillBody,
        borderRadius: BorderRadius.circular(config.commonConfig.radiusXs / 2),
      ),
      child: Text(
        '置顶',
        style: config.timeTextStyle.generateTextStyle(),
      ),
    );
  }

  Widget _buildUnread(SantoChatConfig config, SantoChatConversation conversation) {
    if (conversation.muted) {
      return Container(
        width: config.commonConfig.iconSizeXs / 1.5,
        height: config.commonConfig.iconSizeXs / 1.5,
        decoration: BoxDecoration(
          color: config.commonConfig.brandImportant,
          shape: BoxShape.circle,
        ),
      );
    }
    return Container(
      constraints: BoxConstraints(
        minWidth: config.commonConfig.fontSizeSubHead,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: config.commonConfig.hSpacingXs / 1.5,
      ),
      decoration: BoxDecoration(
        color: config.commonConfig.brandImportant,
        borderRadius: BorderRadius.circular(config.commonConfig.fontSizeSubHead),
      ),
      child: Text(
        conversation.unreadText,
        textAlign: TextAlign.center,
        style: config.timeTextStyle
            .generateTextStyle()
            .copyWith(color: config.commonConfig.colorTextBaseInverse),
      ),
    );
  }
}

/// 会话列表的时间文案:当天显示时分,昨天显示「昨天」,同年显示月日,跨年显示年月日
String formatChatListTime(DateTime time, {DateTime? now}) {
  final DateTime current = now ?? DateTime.now();
  final DateTime day = DateTime(time.year, time.month, time.day);
  final DateTime today = DateTime(current.year, current.month, current.day);
  final int diffDays = today.difference(day).inDays;
  if (diffDays == 0) {
    return '${_two(time.hour)}:${_two(time.minute)}';
  }
  if (diffDays == 1) {
    return '昨天';
  }
  if (diffDays < 7) {
    return '星期${const <String>['一', '二', '三', '四', '五', '六', '日'][day.weekday - 1]}';
  }
  if (time.year == current.year) {
    return '${_two(time.month)}-${_two(time.day)}';
  }
  return '${time.year}-${_two(time.month)}-${_two(time.day)}';
}

String _two(int value) => value.toString().padLeft(2, '0');
