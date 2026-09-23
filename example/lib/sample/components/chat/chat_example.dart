import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

/// 示例用的网络图片
const String _kDemoImage = 'https://zos.alipayobjects.com/rmsportal/ODdgcjrvb81sCyJ.png';

/// Chat 会话示例页面
class ChatExample extends StatefulWidget {
  @override
  _ChatExampleState createState() => _ChatExampleState();
}

class _ChatExampleState extends State<ChatExample> {
  final SantoChatAuthor _me = const SantoChatAuthor(id: 'me', name: '我');
  final SantoChatAuthor _zhang = const SantoChatAuthor(id: 'u1', name: '张三');
  final SantoChatAuthor _li = const SantoChatAuthor(id: 'u2', name: '李四');

  /// 可被 @ 的成员
  final List<SantoChatMention> _members = <SantoChatMention>[
    const SantoChatMention(id: 'u1', display: '张三'),
    const SantoChatMention(id: 'u2', display: '李四'),
    const SantoChatMention(id: 'all', display: '所有人'),
  ];

  /// 完整会话的消息
  late final List<SantoChatMessage> _messages = _initialMessages();

  /// 表情回应,按消息 id 存放,演示不可变消息模型下的状态更新
  final Map<String, List<SantoChatReaction>> _reactions =
      <String, List<SantoChatReaction>>{};

  /// 当前回复的消息
  SantoChatQuote? _replyTo;

  /// 对方是否正在输入
  bool _typing = false;

  /// 正在播放的语音
  String? _playingVoiceId;

  /// 是否还有更早的消息
  bool _hasMore = true;

  /// 是否正在加载更早的消息
  bool _loadingMore = false;

  @override
  void initState() {
    super.initState();
    // 表情图片由业务方注册,`[赞]` 会被渲染成图片,未注册的表情名保留原文
    SantoChatEmojiRegistry.register('赞', _kDemoImage);
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
        createdAt: yesterday.subtract(const Duration(hours: 3))
            .add(const Duration(minutes: 1)),
      ),
      SantoChatTextMessage(
        id: 'm3',
        author: _me,
        text: '好的,我今天更新一版 [赞]',
        createdAt: yesterday.subtract(const Duration(hours: 2)),
      ),
      SantoChatImageMessage(
        id: 'm4',
        author: _me,
        url: _kDemoImage,
        originalWidth: 300,
        originalHeight: 200,
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
    ];
  }

  /// 会话消息(把当前的表态回应合并进模型)
  List<SantoChatMessage> get _chatMessages => <SantoChatMessage>[
        for (final SantoChatMessage message in _messages)
          _withReactions(message, _reactions[message.id] ?? message.reactions),
      ];

  /// 演示用:替换消息上的表情回应
  SantoChatMessage _withReactions(
    SantoChatMessage message,
    List<SantoChatReaction> reactions,
  ) {
    if (message is SantoChatTextMessage) {
      return SantoChatTextMessage(
        id: message.id,
        author: message.author!,
        text: message.text,
        mentions: message.mentions,
        createdAt: message.createdAt,
        status: message.status,
        quote: message.quote,
        reactions: reactions,
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
        status: message.status,
        quote: message.quote,
        reactions: reactions,
      );
    }
    return message;
  }

  /// 消息摘要,用于回复条与引用块
  String _previewOf(SantoChatMessage message) {
    if (message is SantoChatTextMessage) return message.text;
    if (message is SantoChatImageMessage) return '[图片]';
    if (message is SantoChatVideoMessage) return '[视频]';
    if (message is SantoChatVoiceMessage) return '[语音]';
    if (message is SantoChatFileMessage) return '[文件] ${message.name}';
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
            reactions[index] = SantoChatReaction(
              emoji: emoji,
              count: current.count - 1,
            );
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
      _replyTo = SantoChatQuote(
        messageId: message.id,
        title: message.author?.name ?? '系统',
        preview: _previewOf(message),
      );
    });
  }

  void _handleSend(String text) {
    setState(() {
      _messages.add(SantoChatTextMessage(
        id: 'me_${DateTime.now().microsecondsSinceEpoch}',
        author: _me,
        text: text,
        mentions: SantoChatMention.parse(text, _members),
        createdAt: DateTime.now(),
      ));
      _replyTo = null;
      _typing = true;
    });
    // 模拟对方回复:先显示「正在输入」,再补一条消息
    Future<void>.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      setState(() {
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

  /// 会话窗口的公共配置
  Widget _buildChat({required double height, bool withHeader = false}) {
    return _framed(
      height: height,
      child: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: SantoChat(
          messages: _chatMessages,
          currentUserId: 'me',
          showName: true,
          typingAuthor: _typing ? _zhang : null,
          playingMessageId: _playingVoiceId,
          replyTo: _replyTo,
          header: withHeader
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  color: const Color(0xFFFFF7E6),
                  child: Text(
                    '群公告:周五前完成第三页数据核对',
                    style: TextStyle(fontSize: 12, color: Colors.orange[800]),
                  ),
                )
              : null,
          onSend: _handleSend,
          onCancelReply: () => setState(() => _replyTo = null),
          onReply: _handleReply,
          onReaction: _handleReact,
          onQuoteTap: (SantoChatQuote quote) =>
              SantoToast.show('跳转到原消息 ${quote.messageId}', context),
          onMessageTap: (SantoChatMessage message) =>
              SantoToast.show('点击了 ${message.id}', context),
          onMessageLongPress: (SantoChatMessage message) =>
              SantoToast.show('长按了 ${message.id}', context),
          onMentionTap: (SantoChatMention mention) =>
              SantoToast.show('@了 ${mention.display}', context),
          onLinkTap: (String link) => SantoToast.show('打开 $link', context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'Chat 聊天',
      children: <Widget>[
        ExampleIntro('chat'),
        SantoSection(
          title: '完整会话',
          description:
              'SantoChat 是消息列表与底部输入区的总装:支持滑动气泡引用回复、长按弹表情回应、发送后展示对方「正在输入」',
          child: _buildChat(height: 460, withHeader: true),
        ),
        SantoSection(
          title: '双方消息·@与表情',
          description:
              'text 里的 @展示名 命中 mentions 时高亮可点,http(s) 链接自动变色可点,[赞] 走业务注册的表情图,失败态气泡左侧有重试图标',
          child: _buildStaticList(
            height: 300,
            messages: <SantoChatMessage>[
              SantoChatTextMessage(
                id: 'p1',
                author: _zhang,
                text: '周五的方案确认了吗?',
                createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
              ),
              SantoChatTextMessage(
                id: 'p2',
                author: _me,
                text: '确认了 @李四 记得同步一下 😀 [赞]',
                mentions: <SantoChatMention>[
                  const SantoChatMention(id: 'u2', display: '李四'),
                ],
                createdAt: DateTime.now().subtract(const Duration(minutes: 28)),
              ),
              SantoChatTextMessage(
                id: 'p3',
                author: _me,
                text: '详细数据见 https://example.com/detail',
                status: SantoChatMessageStatus.sending,
                createdAt: DateTime.now().subtract(const Duration(minutes: 27)),
              ),
              SantoChatTextMessage(
                id: 'p4',
                author: _me,
                text: '这条发送失败了,点左侧图标可以重试',
                status: SantoChatMessageStatus.failed,
                createdAt: DateTime.now().subtract(const Duration(minutes: 26)),
              ),
            ],
            onRetry: (SantoChatMessage message) =>
                SantoToast.show('重发 ${message.id}', context),
          ),
        ),
        SantoSection(
          title: '系统消息',
          description:
              'SantoChatMessageList 里的 SantoChatSystemMessage 自动渲染成居中弱化提示,不带头像与气泡',
          child: _buildStaticList(
            height: 180,
            messages: <SantoChatMessage>[
              SantoChatSystemMessage(
                id: 's2',
                text: '张三邀请李四加入了群聊',
                createdAt: DateTime.now(),
              ),
              SantoChatTextMessage(
                id: 's3',
                author: _zhang,
                text: '大家好',
                createdAt: DateTime.now(),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '引用消息',
          description:
              '消息带 quote 时气泡内先渲染引用块,点击引用块回调 onQuoteTap,可用 messageId 跳到原消息',
          child: _buildStaticList(
            height: 260,
            messages: <SantoChatMessage>[
              SantoChatTextMessage(
                id: 'q1',
                author: _li,
                text: '这是被引用的原消息',
                createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
              ),
              SantoChatTextMessage(
                id: 'q2',
                author: _me,
                text: '引用一下你的消息',
                quote: const SantoChatQuote(
                  messageId: 'q1',
                  title: '李四',
                  preview: '这是被引用的原消息',
                ),
                createdAt: DateTime.now().subtract(const Duration(minutes: 9)),
              ),
            ],
            onQuoteTap: (SantoChatQuote quote) =>
                SantoToast.show('跳转到 ${quote.messageId}', context),
          ),
        ),
        SantoSection(
          title: '图片与视频消息',
          description:
              '图片消息按 width/height 或原图宽高比取展示尺寸,视频消息展示封面、时长与播放按钮,点击都通过 onMessageTap 回调',
          child: _buildStaticList(
            height: 320,
            messages: <SantoChatMessage>[
              SantoChatImageMessage(
                id: 'i1',
                author: _zhang,
                url: _kDemoImage,
                originalWidth: 300,
                originalHeight: 200,
                createdAt: DateTime.now(),
              ),
              SantoChatVideoMessage(
                id: 'v1',
                author: _li,
                coverUrl: _kDemoImage,
                url: 'https://example.com/video.mp4',
                duration: const Duration(seconds: 95),
                createdAt: DateTime.now(),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '语音与文件消息',
          description:
              '语音消息展示波形与时长,播放态由 playingMessageId 控制;文件消息展示文件名与大小',
          child: _buildStaticList(
            height: 240,
            messages: <SantoChatMessage>[
              SantoChatVoiceMessage(
                id: 'a1',
                author: _zhang,
                url: 'https://example.com/voice.m4a',
                duration: const Duration(seconds: 12),
                createdAt: DateTime.now(),
              ),
              SantoChatVoiceMessage(
                id: 'a2',
                author: _me,
                url: 'https://example.com/voice.m4a',
                duration: const Duration(seconds: 48),
                createdAt: DateTime.now(),
              ),
              SantoChatFileMessage(
                id: 'f1',
                author: _zhang,
                url: 'https://example.com/report.pdf',
                name: '第三季度数据核对报告.pdf',
                size: 2465792,
                createdAt: DateTime.now(),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '日期分隔与分组',
          description:
              '相邻消息间隔超过 5 分钟或跨天时插入时间,文案是「今天/昨天/月-日」+ 时分;同一发送者的连续消息只在该组第一条展示头像与昵称',
          child: _buildStaticList(
            height: 320,
            messages: <SantoChatMessage>[
              SantoChatTextMessage(
                id: 'd1',
                author: _zhang,
                text: '这是前天的消息',
                createdAt: DateTime.now().subtract(const Duration(days: 2)),
              ),
              SantoChatTextMessage(
                id: 'd2',
                author: _zhang,
                text: '同一个人的连续消息不重复展示头像',
                createdAt: DateTime.now().subtract(const Duration(days: 2))
                    .add(const Duration(seconds: 30)),
              ),
              SantoChatTextMessage(
                id: 'd3',
                author: _zhang,
                text: '换到我已经是昨天了',
                createdAt: DateTime.now().subtract(const Duration(days: 1)),
              ),
              SantoChatTextMessage(
                id: 'd4',
                author: _me,
                text: '头像与昵称会重新出现',
                createdAt: DateTime.now().subtract(const Duration(days: 1)),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '上拉加载与回到底部',
          description:
              'hasMore 为 true 时滚到顶部触发 onLoadMore 并在顶部展示加载中;不在底部时右下角出现「回到底部」按钮',
          child: _framed(
            height: 320,
            child: SantoChatMessageList(
              messages: _chatMessages,
              currentUserId: 'me',
              hasMore: _hasMore,
              loadingMore: _loadingMore,
              onLoadMore: _handleLoadMore,
            ),
          ),
        ),
        SantoSection(
          title: '输入区',
          description:
              'leading/trailing 是业务插槽(语音、表情),回复态在输入框上方展示引用条,底部安全区固定预留不可配置',
          child: MediaQuery.removePadding(
            context: context,
            removeBottom: true,
            child: Column(
              children: <Widget>[
                SantoChatInput(
                  hintText: '带插槽的输入区',
                  replyTo: const SantoChatQuote(
                    messageId: 'm1',
                    title: '张三',
                    preview: '昨天的方案我看过了',
                  ),
                  leading: _buildInputSlot(SantoIcons.microphone),
                  trailing: _buildInputSlot(SantoIcons.emoji),
                  onSend: (String text) => SantoToast.show('发送:$text', context),
                  onCancelReply: () => SantoToast.show('取消回复', context),
                ),
                SantoChatInput(
                  hintText: '禁用态',
                  enabled: false,
                  onSend: (String text) => SantoToast.show('发送:$text', context),
                ),
              ],
            ),
          ),
        ),
        SantoSection(
          title: '会话列表',
          description:
              'SantoChatList 展示会话行:未读角标、置顶标记,免打扰会话在头像右下角显示静音角标且未读只显示红点',
          child: SizedBox(
            height: 340,
            child: SantoChatList(
              conversations: <SantoChatConversation>[
                SantoChatConversation(
                  id: 'c1',
                  title: '产品需求群',
                  preview: '张三:周五前完成第三页数据核对',
                  updatedAt: DateTime.now(),
                  unreadCount: 3,
                  pinned: true,
                ),
                SantoChatConversation(
                  id: 'c2',
                  title: '李四',
                  preview: '文件已发你邮箱',
                  updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
                  unreadCount: 1,
                ),
                SantoChatConversation(
                  id: 'c3',
                  title: '项目通知',
                  preview: '版本 1.5.0 已发布',
                  updatedAt: DateTime.now().subtract(const Duration(days: 1)),
                  unreadCount: 12,
                  muted: true,
                ),
                SantoChatConversation(
                  id: 'c4',
                  title: '王五',
                  preview: '好的,明天见',
                  updatedAt: DateTime.now().subtract(const Duration(days: 3)),
                ),
              ],
              onTap: (SantoChatConversation conversation) =>
                  SantoToast.show('打开 ${conversation.title}', context),
              onLongPress: (SantoChatConversation conversation) =>
                  SantoToast.show('长按 ${conversation.title}', context),
            ),
          ),
        ),
      ],
    );
  }

  /// 演示用的会话画布:列表自带灰底,这里裁成与 Section 一致的圆角
  Widget _framed({required double height, required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        SantoThemeConfigurator.instance.getConfig().commonConfig.radiusXs,
      ),
      child: SizedBox(height: height, child: child),
    );
  }

  /// 只需要展示、不需要交互的消息列表
  Widget _buildStaticList({
    required double height,
    required List<SantoChatMessage> messages,
    ValueChanged<SantoChatMessage>? onRetry,
    ValueChanged<SantoChatQuote>? onQuoteTap,
  }) {
    return _framed(
      height: height,
      child: SantoChatMessageList(
        messages: messages,
        currentUserId: 'me',
        showName: true,
        onRetry: onRetry,
        onQuoteTap: onQuoteTap,
        onMessageTap: (SantoChatMessage message) =>
            SantoToast.show('点击了 ${message.id}', context),
        onMentionTap: (SantoChatMention mention) =>
            SantoToast.show('@了 ${mention.display}', context),
        onLinkTap: (String link) => SantoToast.show('打开 $link', context),
      ),
    );
  }

  Widget _buildInputSlot(String icon) {
    return SantoIcon(icon, size: 22, color: const Color(0xFF808695));
  }
}
