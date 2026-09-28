import 'package:santo_ui/src/components/chat/model/santo_chat_emoji_item.dart';
import 'package:santo_ui/src/components/chat/model/santo_chat_extension.dart';
import 'package:santo_ui/src/components/chat/model/santo_chat_menu_item.dart';
import 'package:santo_ui/src/components/chat/model/santo_chat_message.dart';
import 'package:santo_ui/src/components/chat/santo_chat_input.dart';
import 'package:santo_ui/src/components/chat/santo_chat_message_list.dart';
import 'package:santo_ui/src/components/chat/santo_chat_reaction.dart';
import 'package:santo_ui/src/components/chat/santo_chat_selection_bar.dart';
import 'package:santo_ui/src/components/popup/santo_measure_size.dart';
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

  /// 输入框文本控制器,透传给输入区;不传时由输入区内部创建
  ///
  /// 业务侧需要感知输入内容(如自行实现 @ 提及、选人后改写输入框)时传入
  ///
  /// @since v2.2.1
  final TextEditingController? controller;

  /// 输入框焦点控制器,透传给输入区
  ///
  /// @since v2.2.1
  final FocusNode? focusNode;

  /// 扩展菜单项,默认照片、拍摄、文件;传空数组则不展示 `+` 入口
  final List<SantoChatExtension> extensions;

  /// 点选扩展菜单项回调
  final ValueChanged<SantoChatExtension>? onExtensionTap;

  /// 表情面板里的表情,默认内置 32 个;传空数组则不展示表情入口
  final List<SantoChatEmoji> emojis;

  /// 可 @ 的成员候选,透传给输入区;非空时输入 `@` 唤起候选面板
  ///
  /// @since v2.2.1
  final List<SantoChatMention> mentions;

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

  /// 点击审批卡片(打开审批详情)
  ///
  /// @since v1.5.1
  final ValueChanged<SantoChatApprovalMessage>? onApprovalTap;

  /// 点击审批卡片的「通过」
  ///
  /// @since v1.5.1
  final ValueChanged<SantoChatApprovalMessage>? onApprove;

  /// 点击审批卡片的「驳回」
  ///
  /// @since v1.5.1
  final ValueChanged<SantoChatApprovalMessage>? onReject;

  /// 点击通知卡片
  ///
  /// @since v1.5.1
  final ValueChanged<SantoChatNoticeMessage>? onNoticeTap;

  /// 点击已读回执(我方消息气泡下方的「已读/未读」)
  ///
  /// @since v1.5.1
  final ValueChanged<SantoChatMessage>? onReadReceiptTap;

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
    this.controller,
    this.focusNode,
    this.extensions = SantoChatExtension.defaults,
    this.onExtensionTap,
    this.emojis = kSantoChatDefaultEmojis,
    this.mentions = const <SantoChatMention>[],
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
    this.onApprovalTap,
    this.onApprove,
    this.onReject,
    this.onNoticeTap,
    this.onReadReceiptTap,
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
          if (header != null)
            Padding(
              padding: EdgeInsets.fromLTRB(
                config.commonConfig.vSpacingXs,
                config.commonConfig.vSpacingXs,
                config.commonConfig.vSpacingXs,
                0,
              ),
              child: header!,
            ),
          Expanded(
            child: _SantoChatBodyOverlay(
              barBuilder: (ValueNotifier<SantoChatPanel> panelNotifier) =>
                  selectionMode
                      ? SantoChatSelectionBar(
                          selectedCount: selectedIds.length,
                          actions: selectionActions,
                          onCancel: onCancelSelection,
                          onAction: onSelectionAction,
                        )
                      : SantoChatInput(
                          controller: controller,
                          focusNode: focusNode,
                          onSend: onSend,
                          hintText: inputHintText,
                          enabled: inputEnabled,
                          leading: inputLeading,
                          trailing: inputTrailing,
                          extensions: extensions,
                          onExtensionTap: onExtensionTap,
                          emojis: emojis,
                          mentions: mentions,
                          replyTo: replyTo,
                          onCancelReply: onCancelReply,
                          editingText: editingText,
                          onCancelEdit: onCancelEdit,
                          panelNotifier: panelNotifier,
                        ),
              messageListBuilder:
                  (double barHeight, ScrollController? controller) =>
                      SantoChatMessageList(
                messages: messages,
                currentUserId: currentUserId,
                showAvatar: showAvatar,
                showName: showName,
                empty: empty,
                typingAuthor: typingAuthor,
                playingMessageId: playingMessageId,
                padding: listPadding,
                controller: controller,
                bottomOverlayHeight: barHeight,
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
                onApprovalTap: onApprovalTap,
                onApprove: onApprove,
                onReject: onReject,
                onNoticeTap: onNoticeTap,
                onReadReceiptTap: onReadReceiptTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 发送栏浮层:消息列表垫底延伸到发送栏下方,发送栏毛玻璃叠在上面;
/// 动态量发送栏高度(面板展开/多选栏会变),给列表做底部避让。
/// 面板开合经 [SantoChatPanel] 通知器同步:更多菜单展开时聊天区滚到最新,
/// 面板开着时点击聊天列表立即收起
class _SantoChatBodyOverlay extends StatefulWidget {
  final Widget Function(ValueNotifier<SantoChatPanel> panelNotifier) barBuilder;
  final Widget Function(double barHeight, ScrollController? controller)
      messageListBuilder;

  const _SantoChatBodyOverlay({
    Key? key,
    required this.barBuilder,
    required this.messageListBuilder,
  }) : super(key: key);

  @override
  State<_SantoChatBodyOverlay> createState() => _SantoChatBodyOverlayState();
}

class _SantoChatBodyOverlayState extends State<_SantoChatBodyOverlay> {
  double _barHeight = 0;

  // 可空懒加载而非 late final:热重载不会重跑 initState,late final 会炸
  ScrollController? _listController;
  ValueNotifier<SantoChatPanel>? _panelNotifier;

  ScrollController get _listControllerRef =>
      _listController ??= ScrollController();

  ValueNotifier<SantoChatPanel> get _panelNotifierRef =>
      _panelNotifier ??= ValueNotifier<SantoChatPanel>(SantoChatPanel.none);

  @override
  void initState() {
    super.initState();
    _panelNotifierRef.addListener(_handlePanelChanged);
  }

  @override
  void dispose() {
    _panelNotifierRef.removeListener(_handlePanelChanged);
    _panelNotifier?.dispose();
    _listController?.dispose();
    super.dispose();
  }

  /// 更多菜单展开时,把聊天区滚到最新一侧(reverse 列表的底部即 offset 0)
  void _handlePanelChanged() {
    if (_panelNotifier!.value != SantoChatPanel.extension) return;
    if (!(_listController?.hasClients ?? false)) return;
    _listController!.animateTo(
      0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  void _onBarMeasured(Size size) {
    if ((size.height - _barHeight).abs() > 0.5) {
      setState(() => _barHeight = size.height);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Listener(
            onPointerDown: (_) {
              // 面板开着时点击聊天列表,立即收起面板
              if (_panelNotifierRef.value != SantoChatPanel.none) {
                _panelNotifierRef.value = SantoChatPanel.none;
              }
            },
            child: widget.messageListBuilder(_barHeight, _listControllerRef),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: MeasureSize(
            onChanged: _onBarMeasured,
            child: widget.barBuilder(_panelNotifierRef),
          ),
        ),
      ],
    );
  }
}
