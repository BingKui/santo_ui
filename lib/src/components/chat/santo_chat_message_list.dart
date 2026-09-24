import 'package:santo_ui/src/components/chat/model/santo_chat_menu_item.dart';
import 'package:santo_ui/src/components/chat/model/santo_chat_message.dart';
import 'package:santo_ui/src/components/chat/santo_chat_approval.dart';
import 'package:santo_ui/src/components/chat/santo_chat_bubble.dart';
import 'package:santo_ui/src/components/chat/santo_chat_doc.dart';
import 'package:santo_ui/src/components/chat/santo_chat_emoji_view.dart';
import 'package:santo_ui/src/components/chat/santo_chat_file.dart';
import 'package:santo_ui/src/components/chat/santo_chat_image.dart';
import 'package:santo_ui/src/components/chat/santo_chat_message_menu.dart';
import 'package:santo_ui/src/components/chat/santo_chat_notice.dart';
import 'package:santo_ui/src/components/chat/santo_chat_reaction.dart';
import 'package:santo_ui/src/components/chat/santo_chat_system_notice.dart';
import 'package:santo_ui/src/components/chat/santo_chat_text.dart';
import 'package:santo_ui/src/components/chat/santo_chat_typing_indicator.dart';
import 'package:santo_ui/src/components/chat/santo_chat_video.dart';
import 'package:santo_ui/src/components/chat/santo_chat_voice.dart';
import 'package:santo_ui/src/components/empty/santo_empty.dart';
import 'package:santo_ui/src/components/icon/santo_icon.dart';
import 'package:santo_ui/src/components/icon/santo_icons.dart';
import 'package:santo_ui/src/theme/configs/santo_chat_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 距底部多少像素内算「在底部」
const double kSantoChatScrollBottomOffset = 60;

/// 距头部多少像素内触发加载更多
const double kSantoChatLoadMoreThreshold = 80;

/// 滑动回复的触发距离
const double kSantoChatSwipeReplyDistance = 48;

/// 滑动回复最多能拖多远
const double kSantoChatSwipeReplyMaxOffset = 72;

/// 会话消息列表
///
/// [messages] 按**时间正序**(旧 → 新)传入,列表内部按 [reverse] 决定排布,
/// 默认 `reverse: true` 让最新消息贴在底部,新消息自动可见。
///
/// 列表能力:
/// - 时间分隔:相邻消息间隔超过 [timeGroupWindow] 或跨天时插入时间,跨天文案为
///   「今天/昨天/月-日/年-月-日」+ 时分
/// - 头像与昵称按同一发送者的连续消息分组,只在该组第一条出现
/// - [onReply] 不为空时气泡支持左右滑动引用回复
/// - [onReaction] 不为空且 [reactions] 不为空时,长按弹表情回应条、双击快捷回应;
///   需要自定义长按菜单时把 [reactions] 传空数组即可
/// - [typingAuthor] 不为空时在底部展示「正在输入」
/// - [hasMore] 为 true 时滚动到顶部触发 [onLoadMore],并在顶部展示加载中
///
/// @since v1.5.0
class SantoChatMessageList extends StatefulWidget {
  /// 消息列表,按时间正序传入
  final List<SantoChatMessage> messages;

  /// 当前登录用户 id,用于判断消息归属哪一侧
  final String currentUserId;

  /// 是否展示头像
  final bool showAvatar;

  /// 是否展示对方昵称(群聊场景)
  final bool showName;

  /// 是否倒序(最新消息在底部)
  final bool reverse;

  /// 相邻消息超过该间隔就插入时间分割
  final Duration timeGroupWindow;

  /// 空状态,不传展示内置空状态
  final Widget? empty;

  /// 正在输入的对方,不为空时在底部展示输入中
  final SantoChatAuthor? typingAuthor;

  /// 正在播放的语音消息 id,用于把播放图标切成暂停
  final String? playingMessageId;

  /// 外部滚动控制器
  final ScrollController? controller;

  /// 列表内边距
  final EdgeInsetsGeometry? padding;

  /// 长按可选的表情回应
  final List<String> reactions;

  /// 自定义长按菜单项,不传按消息类型取 [SantoChatMenuItem.defaults]
  ///
  /// 项里的 `quote` 会自动接到 [onReply],其余 item 通过
  /// [onMessageMenuSelected] 回调出去
  final List<SantoChatMenuItem> Function(
    SantoChatMessage message,
    bool isMine,
  )? messageMenuItems;

  /// 是否处于多选态:每条消息前展示勾选框,点整行切换选中
  final bool selectionMode;

  /// 多选态下已选中的消息 id
  final Set<String> selectedIds;

  /// 多选态下切换某条消息的选中状态
  final ValueChanged<SantoChatMessage>? onSelectionToggle;

  /// 后端是否还有更早的消息
  final bool hasMore;

  /// 是否正在加载更早的消息
  final bool loadingMore;

  /// 是否展示「回到底部」悬浮按钮
  final bool showScrollToBottom;

  /// 滚动到顶部时回调,用于加载更早的消息
  final VoidCallback? onLoadMore;

  /// 左滑/右滑气泡,用于引用回复
  final ValueChanged<SantoChatMessage>? onReply;

  /// 点击消息(文本/图片/视频/语音/文件都会回调,按类型自行分发)
  final ValueChanged<SantoChatMessage>? onMessageTap;

  /// 长按消息
  final ValueChanged<SantoChatMessage>? onMessageLongPress;

  /// 双击消息
  final ValueChanged<SantoChatMessage>? onMessageDoubleTap;

  /// 选择表情回应
  final void Function(SantoChatMessage message, String emoji)? onReaction;

  /// 选择长按菜单里的操作项
  final void Function(SantoChatMessage message, SantoChatMenuItem item)?
      onMessageMenuSelected;

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

  /// 点击已读回执(我方消息气泡下方的「已读/未读」),业务方在这里拉人员列表
  ///
  /// @since v1.5.1
  final ValueChanged<SantoChatMessage>? onReadReceiptTap;

  const SantoChatMessageList({
    Key? key,
    required this.messages,
    required this.currentUserId,
    this.showAvatar = true,
    this.showName = false,
    this.reverse = true,
    this.timeGroupWindow = const Duration(minutes: 5),
    this.empty,
    this.typingAuthor,
    this.playingMessageId,
    this.controller,
    this.padding,
    this.reactions = kSantoChatDefaultReactions,
    this.messageMenuItems,
    this.selectionMode = false,
    this.selectedIds = const <String>{},
    this.onSelectionToggle,
    this.hasMore = false,
    this.loadingMore = false,
    this.showScrollToBottom = true,
    this.onLoadMore,
    this.onReply,
    this.onMessageTap,
    this.onMessageLongPress,
    this.onMessageDoubleTap,
    this.onReaction,
    this.onMessageMenuSelected,
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
  State<SantoChatMessageList> createState() => _SantoChatMessageListState();
}

class _SantoChatMessageListState extends State<SantoChatMessageList> {
  ScrollController? _internalController;
  bool _showScrollToBottom = false;
  bool _loadMoreRequested = false;

  ScrollController get _controller =>
      widget.controller ?? (_internalController ??= ScrollController());

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleScroll);
  }

  @override
  void didUpdateWidget(covariant SantoChatMessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _internalController)?.removeListener(_handleScroll);
      _controller.addListener(_handleScroll);
    }
    if (!widget.loadingMore) {
      _loadMoreRequested = false;
    }
  }

  @override
  void dispose() {
    // 列表被移除时关掉还挂着的长按菜单,避免浮层残留在页面上
    SantoChatMessageMenu.dismiss();
    (widget.controller ?? _internalController)?.removeListener(_handleScroll);
    _internalController?.dispose();
    super.dispose();
  }

  /// 是否已滚到最新消息一侧
  bool get _atBottom {
    if (!_controller.hasClients) return true;
    final ScrollPosition position = _controller.position;
    if (!position.hasContentDimensions) return true;
    return widget.reverse
        ? position.pixels <= kSantoChatScrollBottomOffset
        : position.pixels >=
            position.maxScrollExtent - kSantoChatScrollBottomOffset;
  }

  void _handleScroll() {
    final bool atBottom = _atBottom;
    if (atBottom == _showScrollToBottom) {
      setState(() => _showScrollToBottom = !atBottom);
    }
    if (!widget.hasMore ||
        widget.loadingMore ||
        _loadMoreRequested ||
        widget.onLoadMore == null ||
        !_controller.hasClients) {
      return;
    }
    final ScrollPosition position = _controller.position;
    if (!position.hasContentDimensions) return;
    final double distanceToStart = widget.reverse
        ? position.maxScrollExtent - position.pixels
        : position.pixels;
    if (distanceToStart <= kSantoChatLoadMoreThreshold) {
      _loadMoreRequested = true;
      widget.onLoadMore!();
    }
  }

  void _scrollToBottom() {
    if (!_controller.hasClients) return;
    _controller.animateTo(
      widget.reverse ? 0 : _controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final SantoChatConfig config =
        SantoThemeConfigurator.instance.getConfig().chatConfig;

    if (widget.messages.isEmpty && widget.typingAuthor == null) {
      return ColoredBox(
        color: config.backgroundColor,
        child: widget.empty ?? _buildEmptyState(),
      );
    }

    final List<Widget> items = _buildItems(config);
    final List<Widget> children =
        widget.reverse ? items.reversed.toList() : items;

    return ColoredBox(
      // 列表自带会话底色(默认 fillBody),否则对面的白气泡在白底页面上会看不见。
      // 需要透明时把主题里的 SantoChatConfig.backgroundColor 配成透明即可。
      color: config.backgroundColor,
      child: Stack(
        children: <Widget>[
          ListView(
            controller: _controller,
            reverse: widget.reverse,
            padding: widget.padding ??
                EdgeInsets.symmetric(
                  vertical: config.commonConfig.vSpacingMd,
                ),
            children: children,
          ),
          if (widget.showScrollToBottom && _showScrollToBottom)
            Positioned(
              right: config.commonConfig.hSpacingMd,
              bottom: config.commonConfig.vSpacingMd,
              child: _buildScrollToBottomButton(config),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SantoEmpty(
        imageType: SantoEmptyImageType.contentEmpty,
        content: '暂无消息',
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget _buildScrollToBottomButton(SantoChatConfig config) {
    return GestureDetector(
      onTap: _scrollToBottom,
      child: Container(
        width: config.avatarSize,
        height: config.avatarSize,
        decoration: BoxDecoration(
          color: config.otherBubbleColor,
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: SantoThemeConfigurator.instance
                  .getConfig()
                  .commonConfig
                  .shadowColor,
              blurRadius: config.commonConfig.gapSm,
              offset: Offset(0, config.commonConfig.vSpacingXs / 2),
            ),
          ],
        ),
        child: Center(
          child: SantoIcon(
            SantoIcons.arrowDown,
            size: config.commonConfig.iconSizeMd,
            color: config.commonConfig.colorTextSecondary,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildItems(SantoChatConfig config) {
    final List<SantoChatMessage> messages = widget.messages;
    final List<Widget> items = <Widget>[];

    if (widget.loadingMore) {
      items.add(_buildLoadMoreIndicator(config));
    }

    for (int i = 0; i < messages.length; i++) {
      final SantoChatMessage message = messages[i];
      if (message is SantoChatSystemMessage) {
        items.add(SantoChatSystemNotice(
          message.text,
          key: ValueKey<String>(message.id),
        ));
        continue;
      }

      final SantoChatMessage? previous = i == 0 ? null : messages[i - 1];
      final bool showTime = _shouldShowTime(previous, message);
      final bool runStart = showTime ||
          previous == null ||
          previous is SantoChatSystemMessage ||
          previous.author?.id != message.author?.id;

      items.add(_buildMessage(
        config,
        message,
        showTime: showTime,
        runStart: runStart,
      ));
    }

    if (widget.typingAuthor != null) {
      items.add(SantoChatTypingIndicator(
        author: widget.typingAuthor,
        showAvatar: widget.showAvatar,
        showName: widget.showName,
      ));
    }

    return items;
  }

  bool _shouldShowTime(SantoChatMessage? previous, SantoChatMessage message) {
    if (message.createdAt == null) return false;
    if (previous == null || previous.createdAt == null) return true;
    if (isDifferentDay(previous.createdAt, message.createdAt)) return true;
    return message.createdAt!.difference(previous.createdAt!) >
        widget.timeGroupWindow;
  }

  Widget _buildLoadMoreIndicator(SantoChatConfig config) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: config.commonConfig.vSpacingSm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: config.commonConfig.iconSizeMd,
            height: config.commonConfig.iconSizeMd,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: config.commonConfig.colorTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(
    SantoChatConfig config,
    SantoChatMessage message, {
    required bool showTime,
    required bool runStart,
  }) {
    final bool isMine = message.isMine(widget.currentUserId);
    // 已撤回:本体不再渲染,撤回提示由服务端下发的系统消息展示
    if (message.recalled) return const SizedBox.shrink();
    final bool isMedia = message is SantoChatImageMessage ||
        message is SantoChatVideoMessage;
    // 文档、审批、通知卡片与自定义内容自带容器,不再套气泡
    final bool bare = message is SantoChatDocMessage ||
        message is SantoChatCustomMessage ||
        message is SantoChatApprovalMessage ||
        message is SantoChatNoticeMessage;
    final String? playingId = widget.playingMessageId;
    final bool selecting = widget.selectionMode;
    final bool selected = widget.selectedIds.contains(message.id);
    final List<String> menuReactions =
        widget.onReaction == null ? const <String>[] : widget.reactions;
    final List<SantoChatMenuItem> menuItems = _menuItemsFor(message, isMine);
    final bool hasMenu =
        !selecting && (menuReactions.isNotEmpty || menuItems.isNotEmpty);

    final Widget bubble = SantoChatBubble(
      author: message.author,
      isMine: isMine,
      showAvatar: widget.showAvatar && runStart,
      showName: widget.showName && !isMine && runStart,
      showTime: showTime,
      time: message.createdAt,
      quote: message.quote,
      status: message.status,
      isEdited: message.isEdited,
      readReceipt: message.readReceipt,
      onReadReceiptTap: widget.onReadReceiptTap == null
          ? null
          : () => widget.onReadReceiptTap!(message),
      reactions: message.reactions,
      onReactionTap: widget.onReaction == null
          ? null
          : (SantoChatReaction reaction) =>
              widget.onReaction!(message, reaction.emoji),
      contentPadding: isMedia ? EdgeInsets.zero : null,
      bare: bare,
      onTap: selecting || widget.onMessageTap == null
          ? null
          : () => widget.onMessageTap!(message),
      onLongPress: hasMenu || widget.onMessageLongPress == null
          ? null
          : () => widget.onMessageLongPress!(message),
      onDoubleTap: selecting ||
              (widget.onMessageDoubleTap == null && menuReactions.isEmpty)
          ? null
          : () => _handleDoubleTap(message, menuReactions),
      onRetry: widget.onRetry == null ? null : () => widget.onRetry!(message),
      onQuoteTap: message.quote == null || widget.onQuoteTap == null
          ? null
          : () => widget.onQuoteTap!(message.quote!),
      child: _buildContent(config, message, isMine, playingId),
    );

    Widget content = bubble;
    if (hasMenu) {
      // 整行的矩形当锚点,菜单始终贴在这条消息正上方。
      // 注意先取一份快照:Builder 的闭包是延迟执行的,直接引用 content
      // 会拿到赋值后的 Builder 自己,导致无限递归构建。
      final Widget rowContent = content;
      content = Builder(
        builder: (BuildContext rowContext) => GestureDetector(
          onLongPressStart: (LongPressStartDetails details) => _showMenu(
            rowContext,
            message,
            isMine,
            menuReactions: menuReactions,
            menuItems: menuItems,
          ),
          child: rowContent,
        ),
      );
    }

    if (selecting) {
      content = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onSelectionToggle == null
            ? null
            : () => widget.onSelectionToggle!(message),
        child: content,
      );
      content = Row(
        // 勾选框相对整行上下居中
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _SelectionIndicator(
            selected: selected,
            config: config,
            onTap: widget.onSelectionToggle == null
                ? null
                : () => widget.onSelectionToggle!(message),
          ),
          SizedBox(width: config.commonConfig.hSpacingSm),
          Expanded(child: content),
        ],
      );
    } else if (widget.onReply != null) {
      content = _SwipeToReply(
        onReply: () => widget.onReply!(message),
        child: content,
      );
    }

    return Padding(
      key: ValueKey<String>(message.id),
      padding: EdgeInsets.only(
        top: showTime ? 0 : config.commonConfig.vSpacingSm,
      ),
      child: content,
    );
  }

  bool get _canReact =>
      widget.onReaction != null && widget.reactions.isNotEmpty;

  /// 按消息类型给出长按菜单项,再按是否有对应回调过滤
  List<SantoChatMenuItem> _menuItemsFor(
    SantoChatMessage message,
    bool isMine,
  ) {
    final List<SantoChatMenuItem> Function(SantoChatMessage, bool)? custom =
        widget.messageMenuItems;
    final List<SantoChatMenuItem> items = custom != null
        ? custom(message, isMine)
        : SantoChatMenuItem.defaults(message, isMine: isMine);
    return <SantoChatMenuItem>[
      for (final SantoChatMenuItem item in items)
        if (item.key == SantoChatMenuItem.quote.key
            ? widget.onReply != null
            : widget.onMessageMenuSelected != null)
          item,
    ];
  }

  void _handleDoubleTap(
    SantoChatMessage message,
    List<String> menuReactions,
  ) {
    widget.onMessageDoubleTap?.call(message);
    if (menuReactions.isNotEmpty) {
      widget.onReaction!(message, menuReactions.first);
    }
  }

  void _showMenu(
    BuildContext rowContext,
    SantoChatMessage message,
    bool isMine, {
    required List<String> menuReactions,
    required List<SantoChatMenuItem> menuItems,
  }) {
    widget.onMessageLongPress?.call(message);
    final RenderObject? renderObject = rowContext.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return;
    final Rect anchor =
        renderObject.localToGlobal(Offset.zero) & renderObject.size;

    SantoChatMessageMenu.show(
      context: context,
      anchor: anchor,
      reactions: menuReactions,
      onReaction: menuReactions.isEmpty
          ? null
          : (String emoji) => widget.onReaction!(message, emoji),
      items: menuItems,
      onItemSelected: (SantoChatMenuItem item) {
        widget.onMessageMenuSelected?.call(message, item);
        // 引用项直接接到滑动引用同一个回调,业务不用重复实现
        if (item.key == SantoChatMenuItem.quote.key) {
          widget.onReply?.call(message);
        }
      },
    );
  }

  Widget _buildContent(
    SantoChatConfig config,
    SantoChatMessage message,
    bool isMine,
    String? playingId,
  ) {
    final TextStyle textStyle = isMine
        ? config.myTextStyle.generateTextStyle()
        : config.otherTextStyle.generateTextStyle();
    final Color accentColor =
        isMine ? config.myAccentColor : config.otherAccentColor;
    final ValueChanged<SantoChatMessage>? onTap = widget.onMessageTap;

    if (message is SantoChatTextMessage) {
      return SantoChatText(
        message.text,
        mentions: message.mentions,
        style: textStyle,
        accentColor: accentColor,
        onMentionTap: widget.onMentionTap,
        onLinkTap: widget.onLinkTap,
      );
    }
    if (message is SantoChatImageMessage) {
      return SantoChatImage(
        message: message,
        onTap: onTap == null ? null : (SantoChatImageMessage m) => onTap(m),
      );
    }
    if (message is SantoChatVideoMessage) {
      return SantoChatVideo(
        message: message,
        onTap: onTap == null ? null : (SantoChatVideoMessage m) => onTap(m),
      );
    }
    if (message is SantoChatVoiceMessage) {
      return SantoChatVoice(
        message: message,
        isMine: isMine,
        isPlaying: playingId == message.id,
        onTap: onTap == null ? null : (SantoChatVoiceMessage m) => onTap(m),
      );
    }
    if (message is SantoChatFileMessage) {
      return SantoChatFile(
        message: message,
        isMine: isMine,
        onTap: onTap == null ? null : (SantoChatFileMessage m) => onTap(m),
      );
    }
    if (message is SantoChatDocMessage) {
      final ValueChanged<SantoChatDocMessage>? onDocTap = widget.onDocTap;
      return SantoChatDocCard(
        message: message,
        onTap: onDocTap == null ? null : (SantoChatDocMessage m) => onDocTap(m),
      );
    }
    if (message is SantoChatCustomMessage) {
      return message.builder(context);
    }
    if (message is SantoChatApprovalMessage) {
      final ValueChanged<SantoChatApprovalMessage>? onApprovalTap =
          widget.onApprovalTap;
      final ValueChanged<SantoChatApprovalMessage>? onApprove = widget.onApprove;
      final ValueChanged<SantoChatApprovalMessage>? onReject = widget.onReject;
      return SantoChatApprovalCard(
        message: message,
        onTap: onApprovalTap == null
            ? null
            : (SantoChatApprovalMessage m) => onApprovalTap(m),
        onApprove: onApprove == null
            ? null
            : (SantoChatApprovalMessage m) => onApprove(m),
        onReject:
            onReject == null ? null : (SantoChatApprovalMessage m) => onReject(m),
      );
    }
    if (message is SantoChatNoticeMessage) {
      final ValueChanged<SantoChatNoticeMessage>? onNoticeTap =
          widget.onNoticeTap;
      return SantoChatNoticeCard(
        message: message,
        timeText: message.createdAt == null
            ? null
            : formatChatTime(message.createdAt!),
        onTap: onNoticeTap == null
            ? null
            : (SantoChatNoticeMessage m) => onNoticeTap(m),
      );
    }
    if (message is SantoChatEmojiMessage) {
      return SantoChatEmojiView(symbol: message.symbol);
    }
    return const SizedBox.shrink();
  }
}

/// 多选态下的圆形勾选框
class _SelectionIndicator extends StatelessWidget {
  final bool selected;
  final SantoChatConfig config;
  final VoidCallback? onTap;

  const _SelectionIndicator({
    required this.selected,
    required this.config,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double size = config.avatarSize / 2 + config.commonConfig.gapXs / 2;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox.square(
        dimension: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected ? config.myBubbleColor : null,
            border: Border.all(
              color: selected
                  ? config.myBubbleColor
                  : config.commonConfig.borderColorBase,
              width: config.commonConfig.borderWidthMd,
            ),
          ),
          child: selected
              ? Center(
                  child: SantoIcon(
                    SantoIcons.check,
                    size: config.commonConfig.iconSizeXs,
                    color: config.commonConfig.colorTextBaseInverse,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

/// 滑动引用回复:左右滑动气泡,超过阈值松手即触发回复
class _SwipeToReply extends StatefulWidget {
  final Widget child;
  final VoidCallback onReply;

  const _SwipeToReply({required this.child, required this.onReply});

  @override
  State<_SwipeToReply> createState() => _SwipeToReplyState();
}

class _SwipeToReplyState extends State<_SwipeToReply> {
  double _offset = 0;
  bool _dragging = false;

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragging = true;
      _offset = (_offset + details.delta.dx)
          .clamp(-kSantoChatSwipeReplyMaxOffset, kSantoChatSwipeReplyMaxOffset);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    final bool triggered = _offset.abs() >= kSantoChatSwipeReplyDistance;
    setState(() {
      _dragging = false;
      _offset = 0;
    });
    if (triggered) {
      widget.onReply();
    }
  }

  @override
  Widget build(BuildContext context) {
    final SantoChatConfig config =
        SantoThemeConfigurator.instance.getConfig().chatConfig;
    final double progress =
        (_offset.abs() / kSantoChatSwipeReplyDistance).clamp(0.0, 1.0);

    return GestureDetector(
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: Stack(
        children: <Widget>[
          if (progress > 0)
            Positioned.fill(
              child: Align(
                alignment: _offset < 0
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: config.commonConfig.hSpacingSm,
                  ),
                  child: Opacity(
                    opacity: progress,
                    child: SantoIcon(
                      SantoIcons.reply,
                      size: config.commonConfig.iconSizeMd,
                      color: config.commonConfig.colorTextSecondary,
                    ),
                  ),
                ),
              ),
            ),
          AnimatedContainer(
            duration: _dragging
                ? Duration.zero
                : const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(_offset, 0, 0),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
