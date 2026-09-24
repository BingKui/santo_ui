import 'package:example/sample/components/chat/chat_demo.dart';
import 'package:example/sample/components/chat/chat_room_example.dart';
import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

/// 示例用的网络图片
const String _kDemoImage = kChatDemoImage;

/// 超过两排(15 项)的扩展菜单:面板一页放 10 项,余下的左右滑动翻页
const List<SantoChatExtension> _manyExtensions = <SantoChatExtension>[
  SantoChatExtension.photo,
  SantoChatExtension.camera,
  SantoChatExtension.file,
  SantoChatExtension(key: 'location', label: '位置', icon: SantoIcons.pin),
  SantoChatExtension(key: 'card', label: '名片', icon: SantoIcons.user),
  SantoChatExtension(key: 'collect', label: '收藏', icon: SantoIcons.star),
  SantoChatExtension(key: 'voice', label: '语音', icon: SantoIcons.microphone),
  SantoChatExtension(key: 'video', label: '视频', icon: SantoIcons.mediaImage),
  SantoChatExtension(key: 'phone', label: '电话', icon: SantoIcons.phone),
  SantoChatExtension(key: 'calendar', label: '日程', icon: SantoIcons.calendar),
  SantoChatExtension(key: 'remind', label: '提醒', icon: SantoIcons.bell),
  SantoChatExtension(key: 'folder', label: '文件夹', icon: SantoIcons.folder),
  SantoChatExtension(key: 'gift', label: '礼物', icon: SantoIcons.gift),
  SantoChatExtension(key: 'packet', label: '红包', icon: SantoIcons.wallet),
  SantoChatExtension(key: 'mail', label: '邮件', icon: SantoIcons.mail),
];

/// Chat 会话示例页面
class ChatExample extends StatefulWidget {
  @override
  _ChatExampleState createState() => _ChatExampleState();
}

class _ChatExampleState extends State<ChatExample> {
  final SantoChatAuthor _me = const SantoChatAuthor(id: 'me', name: '我');
  final SantoChatAuthor _zhang = const SantoChatAuthor(id: 'u1', name: '张三');
  final SantoChatAuthor _li = const SantoChatAuthor(id: 'u2', name: '李四');

  /// 长按菜单里的自定义项
  static const SantoChatMenuItem _favoriteItem = SantoChatMenuItem(
    key: 'favorite',
    label: '收藏',
    icon: SantoIcons.star,
  );

  /// 多选演示的选中集合
  final Set<String> _selectedIds = <String>{};

  /// 演示用的消息
  List<SantoChatMessage> get _messages => <SantoChatMessage>[
        SantoChatTextMessage(
          id: 'd1',
          author: _zhang,
          text: '这条是昨天的消息',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        SantoChatTextMessage(
          id: 'd2',
          author: _zhang,
          text: '同一个人的连续消息不重复展示头像',
          createdAt: DateTime.now()
              .subtract(const Duration(days: 1))
              .add(const Duration(seconds: 30)),
        ),
        SantoChatTextMessage(
          id: 'd3',
          author: _me,
          text: '头像与昵称会重新出现',
          status: SantoChatMessageStatus.read,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        SantoChatTextMessage(
          id: 'd4',
          author: _li,
          text: '长按这条消息可以看到菜单',
          createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
      ];

  /// 会话画布:列表自带灰底,这里裁成与 Section 一致的圆角
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
    ValueChanged<SantoChatDocMessage>? onDocTap,
    ValueChanged<SantoChatApprovalMessage>? onApprovalTap,
    ValueChanged<SantoChatApprovalMessage>? onApprove,
    ValueChanged<SantoChatApprovalMessage>? onReject,
    ValueChanged<SantoChatNoticeMessage>? onNoticeTap,
    ValueChanged<SantoChatMessage>? onReadReceiptTap,
    bool withMenu = false,
    bool withManyMenu = false,
    bool withSelection = false,
  }) {
    return _framed(
      height: height,
      child: SantoChatMessageList(
        messages: messages,
        currentUserId: 'me',
        showName: true,
        onRetry: onRetry,
        onQuoteTap: onQuoteTap,
        onDocTap: onDocTap,
        onApprovalTap: onApprovalTap,
        onApprove: onApprove,
        onReject: onReject,
        onNoticeTap: onNoticeTap,
        onReadReceiptTap: onReadReceiptTap,
        selectionMode: withSelection && _selectedIds.isNotEmpty,
        selectedIds: _selectedIds,
        onSelectionToggle: withSelection ? _toggleSelection : null,
        messageMenuItems: withManyMenu
            ? _manyMenuItems
            : (withMenu ? _menuItems : null),
        onMessageMenuSelected: withMenu || withManyMenu
            ? _handleMenuAction
            : null,
        onReply: withMenu || withManyMenu
            ? (SantoChatMessage message) =>
                SantoToast.show('引用 ${message.id}', context)
            : null,
        onReaction: withMenu || withManyMenu
            ? (SantoChatMessage message, String emoji) =>
                SantoToast.show('回应 $emoji', context)
            : null,
        onMessageTap: (SantoChatMessage message) =>
            SantoToast.show('点击了 ${message.id}', context),
        onMentionTap: (SantoChatMention mention) =>
            SantoToast.show('@了 ${mention.display}', context),
        onLinkTap: (String link) => SantoToast.show('打开 $link', context),
      ),
    );
  }

  /// 长按菜单项:默认项 + 自定义「收藏」
  List<SantoChatMenuItem> _menuItems(SantoChatMessage message, bool isMine) {
    return <SantoChatMenuItem>[
      ...SantoChatMenuItem.defaults(message, isMine: isMine),
      if (message is SantoChatTextMessage) _favoriteItem,
    ];
  }

  /// 超过 10 个的长按菜单项:一排 5 个,多出的换到第三排
  List<SantoChatMenuItem> _manyMenuItems(
    SantoChatMessage message,
    bool isMine,
  ) {
    return <SantoChatMenuItem>[
      ...SantoChatMenuItem.defaults(message, isMine: isMine),
      _favoriteItem,
      const SantoChatMenuItem(
        key: 'pin',
        label: '置顶',
        icon: SantoIcons.pin,
      ),
      const SantoChatMenuItem(
        key: 'remind',
        label: '提醒',
        icon: SantoIcons.bell,
      ),
      const SantoChatMenuItem(
        key: 'schedule',
        label: '日程',
        icon: SantoIcons.calendar,
      ),
      const SantoChatMenuItem(
        key: 'translate',
        label: '翻译',
        icon: SantoIcons.page,
      ),
      const SantoChatMenuItem(
        key: 'save',
        label: '保存',
        icon: SantoIcons.bookmark,
      ),
    ];
  }

  void _handleMenuAction(SantoChatMessage message, SantoChatMenuItem item) {
    if (item.key == 'multiSelect') {
      setState(() {
        _selectedIds
          ..clear()
          ..add(message.id);
      });
      return;
    }
    SantoToast.show('${item.label} ${message.id}', context);
  }

  void _toggleSelection(SantoChatMessage message) {
    setState(() {
      if (!_selectedIds.remove(message.id)) {
        _selectedIds.add(message.id);
      }
    });
  }

  Widget _buildInputSlot(String icon) {
    return SizedBox.square(
      dimension: 32,
      child: Center(
        child: SantoIcon(icon, size: 22, color: const Color(0xFF808695)),
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
              'SantoChat 总装:消息状态(发送中/已发送/已送达/已读/失败)、长按菜单(表情回应+操作,可按类型自定义)、滑动引用、编辑、多选、扩展菜单与上拉加载都在这一份状态里;发送没有按钮,走输入法发送键。'
              '顶部群公告直接复用 SantoNotice,不手写容器',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _framed(
                height: 460,
                child: MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  child: const ChatDemo(),
                ),
              ),
              SizedBox(
                height: SantoThemeConfigurator.instance
                    .getConfig()
                    .commonConfig
                    .vSpacingSm,
              ),
              SantoButton(
                text: '整屏会话(验证输入法上移)',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => ChatRoomExample(),
                  ),
                ),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '双方消息·@与表情',
          description:
              'text 里的 @展示名 命中 mentions 时高亮可点,http(s) 链接自动变色可点,[赞] 走业务注册的表情图;isEdited 为 true 时气泡底部展示「已编辑」',
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
                status: SantoChatMessageStatus.read,
                isEdited: true,
                createdAt: DateTime.now().subtract(const Duration(minutes: 28)),
              ),
              SantoChatTextMessage(
                id: 'p3',
                author: _me,
                text: '详细数据见 https://example.com/detail',
                status: SantoChatMessageStatus.sending,
                createdAt: DateTime.now().subtract(const Duration(minutes: 27)),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '消息状态',
          description:
              '我方消息气泡下方展示状态文案:发送中/已发送/未读/已读;failed 在非头像一侧展示可点击的实心警示图标',
          child: _buildStaticList(
            height: 340,
            messages: <SantoChatMessage>[
              for (final MapEntry<String, SantoChatMessageStatus> entry
                  in <String, SantoChatMessageStatus>{
                '发送中': SantoChatMessageStatus.sending,
                '已发送': SantoChatMessageStatus.sent,
                '已送达': SantoChatMessageStatus.delivered,
                '已读': SantoChatMessageStatus.read,
              }.entries)
                SantoChatTextMessage(
                  id: entry.key,
                  author: _me,
                  text: entry.key,
                  status: entry.value,
                  createdAt: DateTime.now()
                      .subtract(Duration(minutes: 20 - entry.value.index)),
                ),
              SantoChatTextMessage(
                id: '失败',
                author: _me,
                text: '发送失败,点左侧图标重试',
                status: SantoChatMessageStatus.failed,
                createdAt: DateTime.now(),
              ),
            ],
            onRetry: (SantoChatMessage message) =>
                SantoToast.show('重发 ${message.id}', context),
          ),
        ),
        SantoSection(
          title: '已读回执',
          description:
              '只有自己发出的消息才有回执,展示在气泡下方、贴头像一侧:单聊是「已读/未读」,'
              '群聊是「N人未读/全部已读」(对标钉钉);点击回执打开已读/未读人员列表',
          child: _buildStaticList(
            height: 320,
            onReadReceiptTap: (SantoChatMessage message) =>
                SantoChatReadReceiptSheet.show(
              context: context,
              receipt: message.readReceipt ?? const SantoChatReadReceipt(),
            ),
            messages: <SantoChatMessage>[
              SantoChatTextMessage(
                id: 'r1',
                author: _me,
                text: '单聊:对方已读',
                status: SantoChatMessageStatus.read,
                readReceipt: const SantoChatReadReceipt(readCount: 1),
                createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
              ),
              SantoChatTextMessage(
                id: 'r2',
                author: _me,
                text: '单聊:对方还没读',
                status: SantoChatMessageStatus.delivered,
                readReceipt: const SantoChatReadReceipt(unreadCount: 1),
                createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
              ),
              SantoChatTextMessage(
                id: 'r3',
                author: _me,
                text: '群聊:还有 2 个人没读,点下方看看是谁',
                status: SantoChatMessageStatus.delivered,
                readReceipt: const SantoChatReadReceipt(
                  readCount: 3,
                  unreadCount: 2,
                  readMembers: <SantoChatAuthor>[
                    SantoChatAuthor(id: 'u1', name: '张三'),
                    SantoChatAuthor(id: 'u2', name: '李四'),
                    SantoChatAuthor(id: 'u4', name: '赵六'),
                  ],
                  unreadMembers: <SantoChatAuthor>[
                    SantoChatAuthor(id: 'u3', name: '王五'),
                    SantoChatAuthor(id: 'u5', name: '钱七'),
                  ],
                ),
                createdAt: DateTime.now().subtract(const Duration(minutes: 4)),
              ),
              SantoChatTextMessage(
                id: 'r4',
                author: _me,
                text: '群聊:所有人都读完了',
                status: SantoChatMessageStatus.read,
                readReceipt: const SantoChatReadReceipt(readCount: 6),
                createdAt: DateTime.now(),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '系统消息',
          description:
              'SantoChatMessageList 里的 SantoChatSystemMessage 自动渲染成居中弱化提示,不带头像与气泡,也不参与长按菜单',
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
              '消息带 quote 时气泡内先渲染引用块,我方与对方的引用块样式一致,点击回调 onQuoteTap 并按 messageId 跳回原消息',
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
                status: SantoChatMessageStatus.read,
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
                author: _me,
                coverUrl: _kDemoImage,
                url: 'https://example.com/video.mp4',
                duration: const Duration(seconds: 95),
                status: SantoChatMessageStatus.read,
                createdAt: DateTime.now(),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '语音与文件消息',
          description:
              '语音消息展示波形与时长,播放态由 playingMessageId 控制,长按菜单里会多出「转文字」;文件消息展示文件名与大小',
          child: _buildStaticList(
            height: 240,
            withMenu: true,
            messages: <SantoChatMessage>[
              SantoChatVoiceMessage(
                id: 'a1',
                author: _zhang,
                url: 'https://example.com/voice.m4a',
                duration: const Duration(seconds: 12),
                createdAt: DateTime.now(),
              ),
              SantoChatFileMessage(
                id: 'f1',
                author: _me,
                url: 'https://example.com/report.pdf',
                name: '第三季度数据核对报告.pdf',
                size: 2465792,
                status: SantoChatMessageStatus.read,
                createdAt: DateTime.now(),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '文档消息',
          description:
              '文档卡片自带白底与描边、不套气泡,展示文档标题、附言与「点击查看文档」;点击走 onDocTap,由业务方校验权限后打开',
          child: _buildStaticList(
            height: 260,
            onDocTap: (SantoChatDocMessage message) =>
                SantoToast.show('打开文档 ${message.title}', context),
            messages: <SantoChatMessage>[
              SantoChatDocMessage(
                id: 'd1',
                author: _zhang,
                title: '双十一大促容量评估文档',
                docId: 'doc_10086',
                spaceId: 'space_1',
                content: '这是评估结论,记得看一下',
                createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
              ),
              SantoChatDocMessage(
                id: 'd2',
                author: _me,
                title: '第三季度数据核对报告(定稿)',
                docId: 'doc_10087',
                spaceId: 'space_1',
                status: SantoChatMessageStatus.read,
                createdAt: DateTime.now(),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '审批消息',
          description:
              '审批卡片自带容器、不套气泡:单号 + 状态标签 + 标题 + 审批流信息;'
              '状态为审批中且 canApprove 为 true 时才展示「通过/驳回」,点击回调 onApprove / onReject',
          child: _buildStaticList(
            height: 340,
            onApprovalTap: (SantoChatApprovalMessage message) =>
                SantoToast.show('打开审批 ${message.taskNo}', context),
            onApprove: (SantoChatApprovalMessage message) =>
                SantoToast.show('通过 ${message.taskId}', context),
            onReject: (SantoChatApprovalMessage message) =>
                SantoToast.show('驳回 ${message.taskId}', context),
            messages: <SantoChatMessage>[
              SantoChatApprovalMessage(
                id: 'a1',
                author: _zhang,
                taskId: 'task_1001',
                taskNo: 'SP20260924001',
                title: '双十一大促扩容申请',
                flowName: '资源申请审批流',
                applicatorName: '张三',
                currentNodeName: '技术负责人审批',
                canApprove: true,
                createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
              ),
              SantoChatApprovalMessage(
                id: 'a2',
                author: _me,
                taskId: 'task_1002',
                taskNo: 'SP20260924002',
                title: '测试环境数据库权限申请',
                approvalStatus: SantoChatApprovalStatus.approved,
                flowName: '权限申请审批流',
                applicatorName: '我',
                status: SantoChatMessageStatus.read,
                createdAt: DateTime.now(),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '通知消息',
          description:
              '通知卡片:类型图标 + 未读红点 + 标题 + 正文 + 时间,点击回调 onNoticeTap;'
              '同一张卡片也能直接当通知中心的列表项用',
          child: _buildStaticList(
            height: 300,
            onNoticeTap: (SantoChatNoticeMessage message) =>
                SantoToast.show('打开通知 ${message.title}', context),
            messages: <SantoChatMessage>[
              SantoChatNoticeMessage(
                id: 'n1',
                author: _zhang,
                title: '你被 @ 了',
                content: '张三在「产品需求群」提到了你:记得看下双十一方案',
                noticeType: SantoChatNoticeType.mention,
                targetId: 'conversation_1',
                createdAt: DateTime.now().subtract(const Duration(minutes: 6)),
              ),
              SantoChatNoticeMessage(
                id: 'n2',
                author: _zhang,
                title: '审批已通过',
                content: '你提交的「双十一大促扩容申请」已通过技术负责人审批',
                noticeType: SantoChatNoticeType.approval,
                read: true,
                status: SantoChatMessageStatus.read,
                createdAt: DateTime.now().subtract(const Duration(hours: 2)),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '表情消息与撤回',
          description:
              '表情消息展示单个大表情([表情名] 命中图片时渲染图片,否则用 Unicode 字符);'
              'recalled 为 true 的消息本体不再渲染,撤回提示由服务端下发的系统消息展示',
          child: _buildStaticList(
            height: 260,
            messages: <SantoChatMessage>[
              SantoChatEmojiMessage(
                id: 'e1',
                author: _me,
                symbol: '[赞]',
                status: SantoChatMessageStatus.read,
                createdAt: DateTime.now().subtract(const Duration(minutes: 4)),
              ),
              SantoChatEmojiMessage(
                id: 'e2',
                author: _zhang,
                symbol: '🎉',
                createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
              ),
              SantoChatTextMessage(
                id: 'e3',
                author: _zhang,
                text: '这条消息已撤回',
                recalled: true,
                createdAt: DateTime.now(),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '自定义消息',
          description:
              '业务卡片(如审批单)通过 SantoChatCustomMessage 传入 builder,组件只负责分栏、头像、昵称与状态;内容自带容器,同样不套气泡',
          child: _buildStaticList(
            height: 260,
            messages: <SantoChatMessage>[
              SantoChatCustomMessage(
                id: 'c1',
                author: _zhang,
                createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
                builder: (BuildContext context) => const DemoApprovalCard(),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '日期分隔与分组',
          description:
              '相邻消息间隔超过 5 分钟或跨天时插入时间,文案是「今天/昨天/月-日」+ 时分;同一发送者的连续消息只在该组第一条展示头像与昵称',
          child: _buildStaticList(height: 320, messages: _messages),
        ),
        SantoSection(
          title: '长按菜单',
          description:
              '长按气泡弹出浮层:顶部表情回应、下面是操作列表;默认按消息类型给项(文本有复制/编辑,语音有转文字),这里再加了一个自定义的「收藏」',
          child: _buildStaticList(
            height: 260,
            withMenu: true,
            messages: <SantoChatMessage>[
              SantoChatTextMessage(
                id: 'menu1',
                author: _me,
                text: '长按我看默认项 + 收藏',
                status: SantoChatMessageStatus.read,
                createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
              ),
              SantoChatTextMessage(
                id: 'menu2',
                author: _zhang,
                text: '长按对方的消息,没有编辑与删除',
                createdAt: DateTime.now(),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '长按菜单·超过 10 项',
          description:
              '菜单项按块级排列、一排 5 个:这条消息有 12 项(默认 6 项 + 自定义 6 项),多出的会换到第三排',
          child: _buildStaticList(
            height: 260,
            withManyMenu: true,
            messages: <SantoChatMessage>[
              SantoChatTextMessage(
                id: 'menu3',
                author: _me,
                text: '长按我,菜单有 12 项',
                status: SantoChatMessageStatus.read,
                createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '多选',
          description:
              '多选态下每条消息前出现勾选框、点整行即勾选;SantoChat 会把底部输入区换成多选操作栏(已选条数 + 转发/删除 + 取消)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _framed(
                height: 340,
                child: SantoChat(
                  messages: _messages,
                  currentUserId: 'me',
                  showName: true,
                  selectionMode: _selectedIds.isNotEmpty,
                  selectedIds: _selectedIds,
                  onSelectionToggle: _toggleSelection,
                  onSelectionAction: (SantoChatMenuItem item) {
                    SantoToast.show(
                      '${item.label} ${_selectedIds.length} 条',
                      context,
                    );
                    setState(_selectedIds.clear);
                  },
                  onCancelSelection: () => setState(_selectedIds.clear),
                  inputHintText: '进入多选后这里会换成操作栏',
                  onSend: (String text) {},
                  onMessageMenuSelected: _handleMenuAction,
                  messageMenuItems: _menuItems,
                  onReaction: (SantoChatMessage message, String emoji) =>
                      SantoToast.show('回应 $emoji', context),
                  onReply: (SantoChatMessage message) =>
                      SantoToast.show('引用 ${message.id}', context),
                ),
              ),
              SizedBox(
                height: SantoThemeConfigurator.instance
                    .getConfig()
                    .commonConfig
                    .vSpacingSm,
              ),
              SantoButton(
                text: '进入多选',
                isEnable: _selectedIds.isEmpty,
                onTap: () => setState(() => _selectedIds.add('d2')),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '输入区',
          description:
              '没有发送按钮,发送走输入法发送键;点 + 收起输入法并在输入框下方展开扩展菜单(默认照片/拍摄/文件,可自定义),点输入框又收起面板唤起输入法。'
              '面板高度固定(扩展菜单两排、表情四排),内容按网格布局、左上角起排、空位保留,一页放不下的左右滑动翻页(见最后一条)',
          child: MediaQuery.removePadding(
            context: context,
            removeBottom: true,
            child: Column(
              children: <Widget>[
                SantoChatInput(
                  hintText: '带表情与扩展菜单的输入区',
                  leading: _buildInputSlot(SantoIcons.microphone),
                  extensions: const <SantoChatExtension>[
                    SantoChatExtension.photo,
                    SantoChatExtension.camera,
                    SantoChatExtension.file,
                    SantoChatExtension(
                      key: 'location',
                      label: '位置',
                      icon: SantoIcons.pin,
                    ),
                    SantoChatExtension(
                      key: 'card',
                      label: '名片',
                      icon: SantoIcons.user,
                    ),
                    SantoChatExtension(
                      key: 'collect',
                      label: '收藏',
                      icon: SantoIcons.star,
                    ),
                  ],
                  onSend: (String text) => SantoToast.show('发送:$text', context),
                  onExtensionTap: (SantoChatExtension extension) =>
                      SantoToast.show('选择${extension.label}', context),
                ),
                SantoChatInput(
                  hintText: '扩展菜单超过 10 项(左右滑动翻页)',
                  leading: _buildInputSlot(SantoIcons.microphone),
                  extensions: _manyExtensions,
                  onSend: (String text) => SantoToast.show('发送:$text', context),
                  onExtensionTap: (SantoChatExtension extension) =>
                      SantoToast.show('选择${extension.label}', context),
                ),
                SantoChatInput(
                  hintText: '编辑态',
                  editingText: '这条消息正在编辑',
                  onSend: (String text) => SantoToast.show('提交编辑:$text', context),
                  onCancelEdit: () => SantoToast.show('取消编辑', context),
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
}
