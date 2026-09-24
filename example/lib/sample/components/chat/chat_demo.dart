import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 示例用的网络图片
const String kChatDemoImage =
    'https://zos.alipayobjects.com/rmsportal/ODdgcjrvb81sCyJ.png';

/// 会话演示面板:各示例区块与整屏会话页共用同一份状态与交互
///
/// 覆盖消息状态、长按菜单(含自定义项)、引用回复、表情回应、编辑、多选与扩展菜单。
class ChatDemo extends StatefulWidget {
  const ChatDemo({Key? key}) : super(key: key);

  @override
  State<ChatDemo> createState() => _ChatDemoState();
}

class _ChatDemoState extends State<ChatDemo> {
  final SantoChatAuthor _me = const SantoChatAuthor(id: 'me', name: '我');
  final SantoChatAuthor _zhang = const SantoChatAuthor(id: 'u1', name: '张三');
  final SantoChatAuthor _li = const SantoChatAuthor(id: 'u2', name: '李四');

  /// 可被 @ 的成员
  final List<SantoChatMention> _members = <SantoChatMention>[
    const SantoChatMention(id: 'u1', display: '张三'),
    const SantoChatMention(id: 'u2', display: '李四'),
    const SantoChatMention(id: 'all', display: '所有人'),
  ];

  /// 长按菜单里的自定义项
  static const SantoChatMenuItem _favoriteItem = SantoChatMenuItem(
    key: 'favorite',
    label: '收藏',
    icon: SantoIcons.star,
  );

  late List<SantoChatMessage> _messages = _initialMessages();

  /// 表情回应,按消息 id 存放
  final Map<String, List<SantoChatReaction>> _reactions =
      <String, List<SantoChatReaction>>{};

  SantoChatQuote? _replyTo;
  SantoChatTextMessage? _editing;
  bool _typing = false;
  String? _playingVoiceId;
  bool _hasMore = true;
  bool _loadingMore = false;
  bool _selectionMode = false;
  final Set<String> _selectedIds = <String>{};

  @override
  void initState() {
    super.initState();
    SantoChatEmojiRegistry.register('赞', kChatDemoImage);
  }

  @override
  void dispose() {
    SantoChatEmojiRegistry.clear();
    super.dispose();
  }

  List<SantoChatMessage> _initialMessages() {
    final DateTime now = DateTime.now();
    final DateTime yesterday = now.subtract(const Duration(days: 1));
    return <SantoChatMessage>[
      SantoChatSystemMessage(
        id: 's1',
        text: '张三邀请李四加入了群聊',
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      SantoChatTextMessage(
        id: 'm1',
        author: _zhang,
        text: '昨天的方案我看过了,整体没问题',
        createdAt: yesterday.subtract(const Duration(hours: 3)),
      ),
      SantoChatTextMessage(
        id: 'm2',
        author: _zhang,
        text: '只有第三页的数据要再确认一下',
        createdAt: yesterday
            .subtract(const Duration(hours: 3))
            .add(const Duration(minutes: 1)),
      ),
      SantoChatTextMessage(
        id: 'm3',
        author: _me,
        text: '好的,我今天更新一版 [赞]',
        status: SantoChatMessageStatus.read,
        readReceipt: const SantoChatReadReceipt(readCount: 1),
        createdAt: yesterday.subtract(const Duration(hours: 2)),
      ),
      SantoChatImageMessage(
        id: 'm4',
        author: _me,
        url: kChatDemoImage,
        originalWidth: 300,
        originalHeight: 200,
        status: SantoChatMessageStatus.read,
        createdAt: now.subtract(const Duration(minutes: 40)),
      ),
      SantoChatTextMessage(
        id: 'm5',
        author: _li,
        text: '@张三 第三页的引用数据我重新拉了一份 https://example.com/report',
        mentions: <SantoChatMention>[
          const SantoChatMention(id: 'u1', display: '张三'),
        ],
        createdAt: now.subtract(const Duration(minutes: 20)),
      ),
      SantoChatTextMessage(
        id: 'm6',
        author: _zhang,
        text: '收到,辛苦了',
        quote: const SantoChatQuote(
          messageId: 'm5',
          title: '李四',
          preview: '@张三 第三页的引用数据我重新拉了一份',
        ),
        createdAt: now.subtract(const Duration(minutes: 18)),
      ),
      SantoChatTextMessage(
        id: 'm7',
        author: _me,
        text: '这条改过一遍',
        isEdited: true,
        status: SantoChatMessageStatus.delivered,
        readReceipt: const SantoChatReadReceipt(
          readCount: 2,
          unreadCount: 1,
          readMembers: <SantoChatAuthor>[
            SantoChatAuthor(id: 'u1', name: '张三'),
            SantoChatAuthor(id: 'u2', name: '李四'),
          ],
          unreadMembers: <SantoChatAuthor>[SantoChatAuthor(id: 'u3', name: '王五')],
        ),
        createdAt: now.subtract(const Duration(minutes: 10)),
      ),
      SantoChatTextMessage(
        id: 'm8',
        author: _me,
        text: '这条发送失败了,点左侧图标重试',
        status: SantoChatMessageStatus.failed,
        createdAt: now.subtract(const Duration(minutes: 5)),
      ),
      SantoChatDocMessage(
        id: 'm9',
        author: _me,
        title: '双十一大促容量评估文档',
        docId: 'doc_10086',
        spaceId: 'space_1',
        content: '这是评估结论,记得看一下',
        status: SantoChatMessageStatus.read,
        createdAt: now.subtract(const Duration(minutes: 2)),
      ),
      SantoChatCustomMessage(
        id: 'm10',
        author: _li,
        status: SantoChatMessageStatus.read,
        createdAt: now.subtract(const Duration(seconds: 30)),
        builder: (BuildContext context) => const DemoApprovalCard(),
      ),
      SantoChatApprovalMessage(
        id: 'm11',
        author: _zhang,
        taskId: 'task_1001',
        taskNo: 'SP20260924001',
        title: '双十一大促扩容申请',
        flowName: '资源申请审批流',
        applicatorName: '张三',
        currentNodeName: '技术负责人审批',
        canApprove: true,
        createdAt: now,
      ),
      SantoChatNoticeMessage(
        id: 'm12',
        author: _li,
        title: '你被 @ 了',
        content: '李四在「产品讨论组」提到了你',
        noticeType: SantoChatNoticeType.mention,
        createdAt: now.add(const Duration(seconds: 20)),
      ),
    ];
  }

  /// 会话消息(合并表情回应等本地状态)
  List<SantoChatMessage> get _chatMessages => <SantoChatMessage>[
        for (final SantoChatMessage message in _messages)
          _copyMessage(
            message,
            reactions: _reactions[message.id] ?? message.reactions,
          ),
      ];

  /// 演示用:替换消息上的可编辑字段,演示不可变消息模型下的状态更新
  SantoChatMessage _copyMessage(
    SantoChatMessage message, {
    List<SantoChatReaction>? reactions,
    SantoChatMessageStatus? status,
    String? text,
    bool? isEdited,
  }) {
    final List<SantoChatReaction> nextReactions =
        reactions ?? message.reactions;
    final SantoChatMessageStatus nextStatus = status ?? message.status;
    final bool nextEdited = isEdited ?? message.isEdited;

    if (message is SantoChatTextMessage) {
      return SantoChatTextMessage(
        id: message.id,
        author: message.author!,
        text: text ?? message.text,
        mentions: message.mentions,
        createdAt: message.createdAt,
        status: nextStatus,
        quote: message.quote,
        reactions: nextReactions,
        isEdited: nextEdited,
        readReceipt: message.readReceipt,
      );
    }
    if (message is SantoChatImageMessage) {
      return SantoChatImageMessage(
        id: message.id,
        author: message.author!,
        url: message.url,
        width: message.width,
        height: message.height,
        originalWidth: message.originalWidth,
        originalHeight: message.originalHeight,
        createdAt: message.createdAt,
        status: nextStatus,
        quote: message.quote,
        reactions: nextReactions,
        isEdited: nextEdited,
      );
    }
    if (message is SantoChatVoiceMessage) {
      return SantoChatVoiceMessage(
        id: message.id,
        author: message.author!,
        url: message.url,
        duration: message.duration,
        waveform: message.waveform,
        createdAt: message.createdAt,
        status: nextStatus,
        quote: message.quote,
        reactions: nextReactions,
        isEdited: nextEdited,
      );
    }
    if (message is SantoChatVideoMessage) {
      return SantoChatVideoMessage(
        id: message.id,
        author: message.author!,
        url: message.url,
        coverUrl: message.coverUrl,
        duration: message.duration,
        width: message.width,
        height: message.height,
        createdAt: message.createdAt,
        status: nextStatus,
        quote: message.quote,
        reactions: nextReactions,
        isEdited: nextEdited,
      );
    }
    if (message is SantoChatFileMessage) {
      return SantoChatFileMessage(
        id: message.id,
        author: message.author!,
        url: message.url,
        name: message.name,
        size: message.size,
        createdAt: message.createdAt,
        status: nextStatus,
        quote: message.quote,
        reactions: nextReactions,
        isEdited: nextEdited,
      );
    }
    if (message is SantoChatDocMessage) {
      return SantoChatDocMessage(
        id: message.id,
        author: message.author!,
        title: message.title,
        docId: message.docId,
        spaceId: message.spaceId,
        url: message.url,
        content: message.content,
        createdAt: message.createdAt,
        status: nextStatus,
        quote: message.quote,
        reactions: nextReactions,
        isEdited: nextEdited,
      );
    }
    if (message is SantoChatApprovalMessage) {
      return SantoChatApprovalMessage(
        id: message.id,
        author: message.author!,
        taskId: message.taskId,
        title: message.title,
        approvalStatus: message.approvalStatus,
        taskNo: message.taskNo,
        flowName: message.flowName,
        applicatorName: message.applicatorName,
        currentNodeName: message.currentNodeName,
        canApprove: message.canApprove,
        createdAt: message.createdAt,
        status: nextStatus,
        quote: message.quote,
        reactions: nextReactions,
        isEdited: nextEdited,
      );
    }
    if (message is SantoChatNoticeMessage) {
      return SantoChatNoticeMessage(
        id: message.id,
        author: message.author!,
        title: message.title,
        content: message.content,
        noticeType: message.noticeType,
        read: message.read,
        targetId: message.targetId,
        createdAt: message.createdAt,
        status: nextStatus,
        quote: message.quote,
        reactions: nextReactions,
        isEdited: nextEdited,
      );
    }
    if (message is SantoChatEmojiMessage) {
      return SantoChatEmojiMessage(
        id: message.id,
        author: message.author!,
        symbol: message.symbol,
        createdAt: message.createdAt,
        status: nextStatus,
        quote: message.quote,
        reactions: nextReactions,
        isEdited: nextEdited,
      );
    }
    if (message is SantoChatCustomMessage) {
      return SantoChatCustomMessage(
        id: message.id,
        author: message.author!,
        builder: message.builder,
        createdAt: message.createdAt,
        status: nextStatus,
        quote: message.quote,
        reactions: nextReactions,
        isEdited: nextEdited,
      );
    }
    return message;
  }

  void _replaceMessage(
    String id, {
    SantoChatMessageStatus? status,
    String? text,
    bool? isEdited,
  }) {
    final int index = _messages.indexWhere((SantoChatMessage m) => m.id == id);
    if (index < 0) return;
    _messages[index] = _copyMessage(
      _messages[index],
      status: status,
      text: text,
      isEdited: isEdited,
    );
  }

  /// 消息摘要,用于引用条与编辑条
  String _previewOf(SantoChatMessage message) {
    if (message is SantoChatTextMessage) return message.text;
    if (message is SantoChatImageMessage) return '[图片]';
    if (message is SantoChatVideoMessage) return '[视频]';
    if (message is SantoChatVoiceMessage) return '[语音]';
    if (message is SantoChatFileMessage) return '[文件] ${message.name}';
    if (message is SantoChatDocMessage) return '[文档] ${message.title}';
    if (message is SantoChatApprovalMessage) return '[审批] ${message.title}';
    if (message is SantoChatNoticeMessage) return '[通知] ${message.title}';
    if (message is SantoChatEmojiMessage) return message.symbol;
    if (message is SantoChatCustomMessage) return '[自定义消息]';
    return '';
  }

  void _handleReact(SantoChatMessage message, String emoji) {
    final List<SantoChatReaction> reactions =
        List<SantoChatReaction>.of(_reactions[message.id] ?? message.reactions);
    final int index = reactions.indexWhere(
      (SantoChatReaction reaction) => reaction.emoji == emoji,
    );
    setState(() {
      if (index < 0) {
        reactions.add(SantoChatReaction(emoji: emoji, reactedByMe: true));
      } else {
        final SantoChatReaction current = reactions[index];
        if (current.reactedByMe) {
          if (current.count <= 1) {
            reactions.removeAt(index);
          } else {
            reactions[index] =
                SantoChatReaction(emoji: emoji, count: current.count - 1);
          }
        } else {
          reactions[index] = SantoChatReaction(
            emoji: emoji,
            count: current.count + 1,
            reactedByMe: true,
          );
        }
      }
      _reactions[message.id] = reactions;
    });
  }

  void _handleReply(SantoChatMessage message) {
    setState(() {
      _editing = null;
      _replyTo = SantoChatQuote(
        messageId: message.id,
        title: message.author?.name ?? '系统',
        preview: _previewOf(message),
      );
    });
  }

  /// 长按菜单操作:复制/转发/删除/编辑/多选/转文字/自定义收藏
  void _handleMenuAction(SantoChatMessage message, SantoChatMenuItem item) {
    switch (item.key) {
      case 'copy':
        final String text = _previewOf(message);
        Clipboard.setData(ClipboardData(text: text));
        SantoToast.show('已复制:$text', context);
        break;
      case 'forward':
        SantoToast.show('转发 ${message.id}', context);
        break;
      case 'delete':
        setState(() {
          _messages.removeWhere((SantoChatMessage m) => m.id == message.id);
          _selectedIds.remove(message.id);
        });
        break;
      case 'edit':
        if (message is SantoChatTextMessage) {
          setState(() {
            _replyTo = null;
            _editing = message;
          });
        }
        break;
      case 'multiSelect':
        setState(() {
          _selectionMode = true;
          _selectedIds
            ..clear()
            ..add(message.id);
        });
        break;
      case 'voiceToText':
        SantoToast.show('语音转文字:今天下午三点开会', context);
        break;
      case 'favorite':
        SantoToast.show('已收藏 ${message.id}', context);
        break;
      default:
        SantoToast.show('点击了 ${item.label}', context);
    }
  }

  void _handleSelectionToggle(SantoChatMessage message) {
    setState(() {
      if (!_selectedIds.remove(message.id)) {
        _selectedIds.add(message.id);
      }
    });
  }

  void _exitSelection() {
    setState(() {
      _selectionMode = false;
      _selectedIds.clear();
    });
  }

  void _handleSelectionAction(SantoChatMenuItem item) {
    final int count = _selectedIds.length;
    if (item.key == 'delete') {
      setState(() {
        _messages.removeWhere(
          (SantoChatMessage m) => _selectedIds.contains(m.id),
        );
      });
    } else {
      SantoToast.show('${item.label} $count 条', context);
    }
    _exitSelection();
  }

  void _handleSend(String text) {
    final SantoChatTextMessage? editing = _editing;
    if (editing != null) {
      setState(() {
        _replaceMessage(editing.id, text: text, isEdited: true);
        _editing = null;
      });
      return;
    }

    final String id = 'me_${DateTime.now().microsecondsSinceEpoch}';
    setState(() {
      _messages.add(SantoChatTextMessage(
        id: id,
        author: _me,
        text: text,
        mentions: SantoChatMention.parse(text, _members),
        status: SantoChatMessageStatus.sending,
        createdAt: DateTime.now(),
      ));
      _replyTo = null;
      _typing = true;
    });

    // 模拟送达与已读:依次把状态推进到已送达、已读
    Future<void>.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _replaceMessage(id, status: SantoChatMessageStatus.sent));
    });
    Future<void>.delayed(const Duration(milliseconds: 1600), () {
      if (!mounted) return;
      setState(
        () => _replaceMessage(id, status: SantoChatMessageStatus.delivered),
      );
    });
    Future<void>.delayed(const Duration(milliseconds: 2600), () {
      if (!mounted) return;
      setState(() {
        _replaceMessage(id, status: SantoChatMessageStatus.read);
        _typing = false;
        _messages.add(SantoChatTextMessage(
          id: 'reply_${DateTime.now().microsecondsSinceEpoch}',
          author: _zhang,
          text: '收到,晚点给你答复',
          createdAt: DateTime.now(),
        ));
      });
    });
  }

  void _handleLoadMore() {
    if (_loadingMore || !_hasMore) return;
    setState(() => _loadingMore = true);
    Future<void>.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _loadingMore = false;
        _hasMore = false;
        _messages.insert(
          0,
          SantoChatTextMessage(
            id: 'history_${DateTime.now().microsecondsSinceEpoch}',
            author: _li,
            text: '这是更早的历史消息',
            createdAt: DateTime.now().subtract(const Duration(days: 2)),
          ),
        );
      });
    });
  }

  /// 长按菜单项:默认项 + 自定义「收藏」
  List<SantoChatMenuItem> _menuItems(SantoChatMessage message, bool isMine) {
    return <SantoChatMenuItem>[
      ...SantoChatMenuItem.defaults(message, isMine: isMine),
      if (message is SantoChatTextMessage) _favoriteItem,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SantoChat(
      messages: _chatMessages,
      currentUserId: 'me',
      showName: true,
      typingAuthor: _typing ? _zhang : null,
      playingMessageId: _playingVoiceId,
      replyTo: _replyTo,
      editingText: _editing?.text,
      // 群公告直接复用通知条组件,不手写容器
      header: SantoNotice(
        content: '群公告:周五前完成第三页数据核对',
        noticeStyle: NoticeStyles.normalNoticeWithArrow,
        onNoticeTap: () => SantoToast.show('查看群公告', context),
      ),
      hasMore: _hasMore,
      loadingMore: _loadingMore,
      selectionMode: _selectionMode,
      selectedIds: _selectedIds,
      onSelectionToggle: _handleSelectionToggle,
      onSelectionAction: _handleSelectionAction,
      onCancelSelection: _exitSelection,
      onSend: _handleSend,
      onCancelReply: () => setState(() => _replyTo = null),
      onCancelEdit: () => setState(() => _editing = null),
      onReply: _handleReply,
      onReaction: _handleReact,
      onMessageMenuSelected: _handleMenuAction,
      messageMenuItems: _menuItems,
      onExtensionTap: (SantoChatExtension extension) =>
          SantoToast.show('选择${extension.label}', context),
      onLoadMore: _handleLoadMore,
      onQuoteTap: (SantoChatQuote quote) =>
          SantoToast.show('跳转到原消息 ${quote.messageId}', context),
      onMessageTap: (SantoChatMessage message) {
        if (message is SantoChatVoiceMessage) {
          setState(() {
            _playingVoiceId = _playingVoiceId == message.id ? null : message.id;
          });
          return;
        }
        SantoToast.show('点击了 ${message.id}', context);
      },
      onMentionTap: (SantoChatMention mention) =>
          SantoToast.show('@了 ${mention.display}', context),
      onLinkTap: (String link) => SantoToast.show('打开 $link', context),
      onRetry: (SantoChatMessage message) =>
          SantoToast.show('重发 ${message.id}', context),
      onDocTap: (SantoChatDocMessage message) =>
          SantoToast.show('打开文档 ${message.title}', context),
      onApprovalTap: (SantoChatApprovalMessage message) =>
          SantoToast.show('打开审批 ${message.taskNo}', context),
      onApprove: (SantoChatApprovalMessage message) =>
          SantoToast.show('通过 ${message.taskId}', context),
      onReject: (SantoChatApprovalMessage message) =>
          SantoToast.show('驳回 ${message.taskId}', context),
      onNoticeTap: (SantoChatNoticeMessage message) =>
          SantoToast.show('打开通知 ${message.title}', context),
      // 点气泡下方的「已读/未读」打开人员列表
      onReadReceiptTap: (SantoChatMessage message) =>
          SantoChatReadReceiptSheet.show(
        context: context,
        receipt: message.readReceipt ?? const SantoChatReadReceipt(),
      ),
    );
  }
}

/// 自定义消息的演示内容:一张审批卡片(自带白底与描边,所以不套气泡)
class DemoApprovalCard extends StatelessWidget {
  const DemoApprovalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 240),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'AP-20260924-001',
                  style: TextStyle(color: Colors.black45, fontSize: 11),
                ),
              ),
              SantoTag(text: '审批中', state: SantoTagState.running),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '大促容量扩容申请',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            '申请人:李四',
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: SantoButton(
                  text: '通过',
                  type: SantoButtonType.primary,
                  size: SantoButtonSize.small,
                  autoInsertSpace: false,
                  block: true,
                  onTap: () => SantoToast.show('已通过', context),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SantoButton(
                  text: '驳回',
                  type: SantoButtonType.primary,
                  danger: true,
                  size: SantoButtonSize.small,
                  autoInsertSpace: false,
                  block: true,
                  onTap: () => SantoToast.show('已驳回', context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
