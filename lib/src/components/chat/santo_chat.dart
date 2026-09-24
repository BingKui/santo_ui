import 'package:santo_ui/src/components/chat/model/santo_chat_emoji_item.dart';
import 'package:santo_ui/src/components/chat/model/santo_chat_extension.dart';
import 'package:santo_ui/src/components/chat/model/santo_chat_menu_item.dart';
import 'package:santo_ui/src/components/chat/model/santo_chat_message.dart';
import 'package:santo_ui/src/components/chat/santo_chat_input.dart';
import 'package:santo_ui/src/components/chat/santo_chat_message_list.dart';
import 'package:santo_ui/src/components/chat/santo_chat_reaction.dart';
import 'package:santo_ui/src/components/chat/santo_chat_selection_bar.dart';
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

  /// 输入框提示文案
  final String inputHintText;

  /// 输入区是否可输入
  final bool inputEnabled;

  /// 扩展菜单项,默认照片、拍摄、文件;传空数组则不展示 `+` 入口
  final List<SantoChatExtension> extensions;

  /// 点选扩展菜单项回调
  final ValueChanged<SantoChatExtension>? onExtensionTap;

  /// 表情面板里的表情,默认内置 32 个;传空数组则不展示表情入口
  final List<SantoChatEmoji> emojis;

  /// 当前回复的消息
  final SantoChatQuote? replyTo;

  /// 取消回复回调
  final VoidCallback? onCancelReply;

  /// 正在编辑的消息内容,不为空时输入区进入编辑态
  final String? editingText;

  /// 取消编辑回调
  final VoidCallback? onCancelEdit;

  /// 是否处于多选态,多选态下底部输入区换成多选操作栏
  final bool selectionMode;

  /// 多选态下已选中的消息 id
  final Set<String> selectedIds;

  /// 多选态下切换某条消息的选中状态
  final ValueChanged<SantoChatMessage>? onSelectionToggle;

  /// 多选操作栏的操作项,默认转发、删除
  final List<SantoChatMenuItem> selectionActions;

  /// 多选操作栏的操作回调
  final ValueChanged<SantoChatMenuItem>? onSelectionAction;

  /// 退出多选
  final VoidCallback? onCancelSelection;

  /// 正在输入的对方
  final SantoChatAuthor? typingAuthor;

  /// 正在播放的语音消息 id
  final String? playingMessageId;

  /// 长按可选的表情回应
  final List<String> reactions;

  /// 自定义长按菜单项,不传按消息类型取 [SantoChatMenuItem.defaults]
  final List<SantoChatMenuItem> Function(
    SantoChatMessage message,
    bool isMine,
  )? messageMenuItems;

  /// 选择长按菜单里的操作项
  final void Function(SantoChatMessage message, SantoChatMenuItem item)?
      onMessageMenuSelected;

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

  /// 点击文档卡片,由业务方校验权限后打开文档
  final ValueChanged<SantoChatDocMessage>? onDocTap;

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
    this.inputHintText = '请输入内容',
    this.inputEnabled = true,
    this.extensions = SantoChatExtension.defaults,
    this.onExtensionTap,
    this.emojis = kSantoChatDefaultEmojis,
    this.replyTo,
    this.onCancelReply,
    this.editingText,
    this.onCancelEdit,
    this.selectionMode = false,
    this.selectedIds = const <String>{},
    this.onSelectionToggle,
    this.selectionActions = kSantoChatDefaultSelectionActions,
    this.onSelectionAction,
    this.onCancelSelection,
    this.typingAuthor,
    this.playingMessageId,
    this.reactions = kSantoChatDefaultReactions,
    this.messageMenuItems,
    this.onMessageMenuSelected,
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
    this.onDocTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SantoChatConfig config =
        SantoThemeConfigurator.instance.getConfig().chatConfig;

    return Container(
      color: config.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
              messageMenuItems: messageMenuItems,
              selectionMode: selectionMode,
              selectedIds: selectedIds,
              onSelectionToggle: onSelectionToggle,
              hasMore: hasMore,
              loadingMore: loadingMore,
              showScrollToBottom: showScrollToBottom,
              onLoadMore: onLoadMore,
              onReply: onReply,
              onMessageTap: onMessageTap,
              onMessageLongPress: onMessageLongPress,
              onMessageDoubleTap: onMessageDoubleTap,
              onReaction: onReaction,
              onMessageMenuSelected: onMessageMenuSelected,
              onMentionTap: onMentionTap,
              onLinkTap: onLinkTap,
              onQuoteTap: onQuoteTap,
              onRetry: onRetry,
              onDocTap: onDocTap,
            ),
          ),
          if (selectionMode)
            SantoChatSelectionBar(
              selectedCount: selectedIds.length,
              actions: selectionActions,
              onCancel: onCancelSelection,
              onAction: onSelectionAction,
            )
          else
            SantoChatInput(
              onSend: onSend,
              hintText: inputHintText,
              enabled: inputEnabled,
              leading: inputLeading,
              trailing: inputTrailing,
              extensions: extensions,
              onExtensionTap: onExtensionTap,
              emojis: emojis,
              replyTo: replyTo,
              onCancelReply: onCancelReply,
              editingText: editingText,
              onCancelEdit: onCancelEdit,
            ),
        ],
      ),
    );
  }
}
