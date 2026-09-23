import 'package:santo_ui/src/components/avatar/santo_avatar.dart';
import 'package:santo_ui/src/components/chat/model/santo_chat_message.dart';
import 'package:santo_ui/src/components/chat/santo_chat_quote_view.dart';
import 'package:santo_ui/src/components/chat/santo_chat_reaction.dart';
import 'package:santo_ui/src/components/icon/santo_icon.dart';
import 'package:santo_ui/src/components/icon/santo_icons.dart';
import 'package:santo_ui/src/theme/configs/santo_chat_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 会话消息气泡
///
/// 负责左右分栏、头像、昵称、时间、发送状态与引用块,内容由 [child] 决定:
/// 文本传 [SantoChatText],图片传 [SantoChatImage],视频传 [SantoChatVideo]。
/// 图片/视频这类贴边内容把 [contentPadding] 传 `EdgeInsets.zero` 即可铺满气泡。
///
/// @since v1.5.0
class SantoChatBubble extends StatelessWidget {
  /// 气泡内容
  final Widget child;

  /// 发送者,用于渲染头像与昵称
  final SantoChatAuthor? author;

  /// 是否为我方消息,决定左右排布与配色
  final bool isMine;

  /// 是否展示头像,不传取主题无默认时按 true
  final bool showAvatar;

  /// 是否展示昵称(仅对方消息生效)
  final bool showName;

  /// 是否在气泡上方展示时间
  final bool showTime;

  /// 展示的时间
  final DateTime? time;

  /// 引用(回复)的消息
  final SantoChatQuote? quote;

  /// 发送状态,仅 [SantoChatMessageStatus.failed]/[sending] 会展示状态图标
  final SantoChatMessageStatus status;

  /// 表情回应,展示在气泡下方
  final List<SantoChatReaction> reactions;

  /// 点击某个回应回调
  final ValueChanged<SantoChatReaction>? onReactionTap;

  /// 双击气泡回调
  final VoidCallback? onDoubleTap;

  /// 内容区内边距,图片/视频消息传 `EdgeInsets.zero`
  final EdgeInsetsGeometry? contentPadding;

  /// 气泡背景色,不传按 [isMine] 取主题色
  final Color? backgroundColor;

  /// 气泡文字颜色覆盖
  final Color? textColor;

  /// 自定义头像,不传按 [author] 生成
  final Widget? avatar;

  /// 点击气泡回调
  final VoidCallback? onTap;

  /// 长按气泡回调
  final VoidCallback? onLongPress;

  /// 发送失败后点击重试回调
  final VoidCallback? onRetry;

  /// 点击引用块回调
  final VoidCallback? onQuoteTap;

  const SantoChatBubble({
    Key? key,
    required this.child,
    this.author,
    this.isMine = false,
    this.showAvatar = true,
    this.showName = false,
    this.showTime = false,
    this.time,
    this.quote,
    this.status = SantoChatMessageStatus.sent,
    this.reactions = const <SantoChatReaction>[],
    this.onReactionTap,
    this.onDoubleTap,
    this.contentPadding,
    this.backgroundColor,
    this.textColor,
    this.avatar,
    this.onTap,
    this.onLongPress,
    this.onRetry,
    this.onQuoteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SantoChatConfig config =
        SantoThemeConfigurator.instance.getConfig().chatConfig;
    final double avatarSize = config.avatarSize;
    final EdgeInsets bubblePadding = config.bubblePadding;

    final Widget? avatarWidget = _buildAvatar(avatarSize);
    final bool hasAvatar = avatarWidget != null;

    final EdgeInsetsGeometry contentInsets = contentPadding ??
        (quote != null
            ? EdgeInsets.fromLTRB(
                bubblePadding.left,
                bubblePadding.top / 2,
                bubblePadding.right,
                bubblePadding.bottom,
              )
            : bubblePadding);

    Widget bubble = Container(
      decoration: BoxDecoration(
        color: backgroundColor ??
            (isMine ? config.myBubbleColor : config.otherBubbleColor),
        borderRadius: BorderRadius.circular(config.bubbleRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (quote != null)
            Padding(
              padding: bubblePadding,
              child: SantoChatQuoteView(
                quote: quote!,
                onTap: onQuoteTap,
              ),
            ),
          Padding(padding: contentInsets, child: child),
        ],
      ),
    );

    if (onTap != null || onLongPress != null || onDoubleTap != null) {
      bubble = GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        onDoubleTap: onDoubleTap,
        child: bubble,
      );
    }

    final Widget body = Column(
      crossAxisAlignment:
          isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (showName && !isMine && author != null)
          Padding(
            padding: EdgeInsets.only(bottom: config.commonConfig.vSpacingXs / 2),
            child: Text(
              author!.name,
              style: config.nameTextStyle.generateTextStyle(),
            ),
          ),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth * config.bubbleMaxWidthRatio,
              ),
              child: bubble,
            );
          },
        ),
        if (reactions.isNotEmpty)
          Align(
            alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
            child: SantoChatReactionView(
              reactions: reactions,
              isMine: isMine,
              onTap: onReactionTap,
            ),
          ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (showTime && time != null) _buildTimeLine(config, time!),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            if (!isMine) ...<Widget>[
              if (hasAvatar)
                avatarWidget
              else
                SizedBox(width: avatarSize),
              SizedBox(width: config.commonConfig.hSpacingSm),
            ],
            Flexible(child: body),
            if (isMine) ...<Widget>[
              SizedBox(width: config.commonConfig.hSpacingSm),
              _buildStatus(config),
              if (hasAvatar) avatarWidget,
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildTimeLine(SantoChatConfig config, DateTime time) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: config.commonConfig.vSpacingSm,
      ),
      child: Center(
        child: Text(
          formatChatTime(time),
          style: config.timeTextStyle.generateTextStyle(),
        ),
      ),
    );
  }

  Widget _buildStatus(SantoChatConfig config) {
    if (status == SantoChatMessageStatus.failed) {
      final Widget icon = SantoIcon(
        SantoIcons.warningTriangle,
        size: config.commonConfig.iconSizeSm,
        color: config.commonConfig.brandError,
      );
      if (onRetry == null) return icon;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onRetry,
        child: icon,
      );
    }
    if (status == SantoChatMessageStatus.sending) {
      return SantoIcon(
        SantoIcons.clock,
        size: config.commonConfig.iconSizeSm,
        color: config.commonConfig.colorTextHint,
      );
    }
    return const SizedBox.shrink();
  }

  Widget? _buildAvatar(double avatarSize) {
    if (!showAvatar) return null;
    if (avatar != null) return avatar;
    final SantoChatAuthor? author = this.author;
    if (author == null) return null;
    return SantoAvatar(
      imageUrl: author.avatarUrl,
      text: author.name.isEmpty ? null : author.name.substring(0, 1),
      size: avatarSize,
    );
  }
}

/// 会话里的时间文案
///
/// 当天只显示时分,昨天加「昨天」前缀,同一年带月日,跨年带年份。
String formatChatTime(DateTime time, {DateTime? now}) {
  final DateTime current = now ?? DateTime.now();
  final String hm = '${_two(time.hour)}:${_two(time.minute)}';
  final DateTime day = DateTime(time.year, time.month, time.day);
  final DateTime today = DateTime(current.year, current.month, current.day);
  final int diffDays = today.difference(day).inDays;
  if (diffDays == 0) {
    return hm;
  }
  if (diffDays == 1) {
    return '昨天 $hm';
  }
  if (time.year == current.year) {
    return '${_two(time.month)}-${_two(time.day)} $hm';
  }
  return '${time.year}-${_two(time.month)}-${_two(time.day)} $hm';
}

/// 两个时间是否不在同一天
bool isDifferentDay(DateTime? a, DateTime? b) {
  if (a == null || b == null) return true;
  return a.year != b.year || a.month != b.month || a.day != b.day;
}

String _two(int value) => value.toString().padLeft(2, '0');
