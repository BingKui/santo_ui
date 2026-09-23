import 'package:santo_ui/src/components/chat/model/santo_chat_message.dart';
import 'package:santo_ui/src/components/chat/santo_chat_input.dart';
import 'package:santo_ui/src/components/chat/santo_chat_message_list.dart';
import 'package:santo_ui/src/components/chat/santo_chat_reaction.dart';
import 'package:santo_ui/src/theme/configs/santo_chat_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 会话窗口:消息列表 + 底部输入区
///
/// 一站式用法,把消息与回调交给它即可;需要更细粒度拼装时可直接组合
/// [SantoChatMessageList]、[SantoChatInput] 等原子组件。
///
/// ```dart
/// SantoChat(
///   messages: messages,
///   currentUserId: 'me',
///   onSend: (String text) => setState(() => messages.add(...)),
/// )
/// ```
///
/// @since v1.5.0
class SantoChat extends StatelessWidget {
  /// 消息列表,按时间正序传入
  final List<SantoChatMessage> messages;

  /// 当前登录用户 id
  final String currentUserId;

  /// 点击发送回调,回调后输入框自动清空
  final ValueChanged<String>? onSend;

  /// 是否展示头像
  final bool showAvatar;

  /// 是否展示对方昵称
  final bool showName;

  /// 空状态
  final Widget? empty;

  /// 列表上方的固定区域,如群公告、@我 提示
  final Widget? header;

  /// 输入区左侧插槽
  final Widget? inputLeading;

  /// 输入区右侧插槽
  final Widget? inputTrailing;

  /// 自定义发送按钮
  final Widget? sendButton;

  /// 输入框提示文案
  final String inputHintText;

  /// 输入区是否可输入
  final bool inputEnabled;

  /// 当前回复的消息
  final SantoChatQuote? replyTo;

  /// 取消回复回调
  final VoidCallback? onCancelReply;

  /// 正在输入的对方
  final SantoChatAuthor? typingAuthor;

  /// 正在播放的语音消息 id
  final String? playingMessageId;

  /// 长按可选的表情回应
  final List<String> reactions;

  /// 是否还有更早的消息
  final bool hasMore;

  /// 是否正在加载更早的消息
  final bool loadingMore;

  /// 是否展示「回到底部」悬浮按钮
  final bool showScrollToBottom;

  /// 列表内边距
  final EdgeInsetsGeometry? listPadding;

  /// 滚动到顶部加载更多
  final VoidCallback? onLoadMore;

  /// 滑动气泡引用回复
  final ValueChanged<SantoChatMessage>? onReply;

  /// 点击消息
  final ValueChanged<SantoChatMessage>? onMessageTap;

  /// 长按消息
  final ValueChanged<SantoChatMessage>? onMessageLongPress;

  /// 双击消息
  final ValueChanged<SantoChatMessage>? onMessageDoubleTap;

  /// 选择表情回应
  final void Function(SantoChatMessage message, String emoji)? onReaction;

  /// 点击 @提及
  final ValueChanged<SantoChatMention>? onMentionTap;

  /// 点击链接
  final ValueChanged<String>? onLinkTap;

  /// 点击引用块
  final ValueChanged<SantoChatQuote>? onQuoteTap;

  /// 点击发送失败的重试图标
  final ValueChanged<SantoChatMessage>? onRetry;

  const SantoChat({
    Key? key,
    required this.messages,
    required this.currentUserId,
    this.onSend,
    this.showAvatar = true,
    this.showName = false,
    this.empty,
    this.header,
    this.inputLeading,
    this.inputTrailing,
    this.sendButton,
    this.inputHintText = '请输入内容',
    this.inputEnabled = true,
    this.replyTo,
    this.onCancelReply,
    this.typingAuthor,
    this.playingMessageId,
    this.reactions = kSantoChatDefaultReactions,
    this.hasMore = false,
    this.loadingMore = false,
    this.showScrollToBottom = true,
    this.listPadding,
    this.onLoadMore,
    this.onReply,
    this.onMessageTap,
    this.onMessageLongPress,
    this.onMessageDoubleTap,
    this.onReaction,
    this.onMentionTap,
    this.onLinkTap,
    this.onQuoteTap,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SantoChatConfig config =
        SantoThemeConfigurator.instance.getConfig().chatConfig;

    return Container(
      color: config.backgroundColor,
      child: Column(
        children: <Widget>[
          ?header,
          Expanded(
            child: SantoChatMessageList(
              messages: messages,
              currentUserId: currentUserId,
              showAvatar: showAvatar,
              showName: showName,
              empty: empty,
              typingAuthor: typingAuthor,
              playingMessageId: playingMessageId,
              padding: listPadding,
              reactions: reactions,
              hasMore: hasMore,
              loadingMore: loadingMore,
              showScrollToBottom: showScrollToBottom,
              onLoadMore: onLoadMore,
              onReply: onReply,
              onMessageTap: onMessageTap,
              onMessageLongPress: onMessageLongPress,
              onMessageDoubleTap: onMessageDoubleTap,
              onReaction: onReaction,
              onMentionTap: onMentionTap,
              onLinkTap: onLinkTap,
              onQuoteTap: onQuoteTap,
              onRetry: onRetry,
            ),
          ),
          SantoChatInput(
            onSend: onSend,
            hintText: inputHintText,
            enabled: inputEnabled,
            leading: inputLeading,
            trailing: inputTrailing,
            sendButton: sendButton,
            replyTo: replyTo,
            onCancelReply: onCancelReply,
          ),
        ],
      ),
    );
  }
}
