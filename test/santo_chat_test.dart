import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

const SantoChatAuthor _me = SantoChatAuthor(id: 'me', name: '我');
const SantoChatAuthor _other = SantoChatAuthor(id: 'u1', name: '张三');

Widget _host(Widget child, {double height = 400}) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox(height: height, child: child),
    ),
  );
}

SantoChatMessageList _list(
  List<SantoChatMessage> messages, {
  bool showName = false,
  bool hasMore = false,
  bool loadingMore = false,
  ScrollController? controller,
  ValueChanged<SantoChatMessage>? onReply,
  ValueChanged<SantoChatMessage>? onRetry,
  VoidCallback? onLoadMore,
  ValueChanged<SantoChatMention>? onMentionTap,
  ValueChanged<String>? onLinkTap,
  void Function(SantoChatMessage, String)? onReaction,
}) {
  return SantoChatMessageList(
    messages: messages,
    currentUserId: 'me',
    showName: showName,
    hasMore: hasMore,
    loadingMore: loadingMore,
    controller: controller,
    onReply: onReply,
    onRetry: onRetry,
    onLoadMore: onLoadMore,
    onMentionTap: onMentionTap,
    onLinkTap: onLinkTap,
    onReaction: onReaction,
  );
}

/// 气泡自己的容器:带圆角背景且开启了裁切
Finder get _bubbleContainer => find.byWidgetPredicate((Widget widget) =>
    widget is Container &&
    widget.clipBehavior == Clip.antiAlias &&
    widget.decoration is BoxDecoration);

Color _bubbleColor(WidgetTester tester) => _bubbleDecoration(tester).color!;

BoxDecoration _bubbleDecoration(WidgetTester tester) =>
    tester.widget<Container>(_bubbleContainer.first).decoration!
        as BoxDecoration;

Finder _iconNamed(String name) => find.byWidgetPredicate(
    (Widget widget) => widget is SantoIcon && widget.name == name);

/// 实心风格图标
Finder _solidIconNamed(String name) => find.byWidgetPredicate((Widget widget) =>
    widget is SantoIcon && widget.name == name && widget.solid);

/// 输入区面板的分页指示点
const Key _panelIndicator = ValueKey<String>('santoChatPanelIndicator');

List<SantoChatMessage> _manyMessages(int count) => <SantoChatMessage>[
      for (int i = 0; i < count; i++)
        SantoChatTextMessage(
          id: 'm$i',
          author: _other,
          text: '第 $i 条消息',
          createdAt: DateTime(2026, 9, 23, 10).add(Duration(minutes: i * 10)),
        ),
    ];

void main() {
  setUp(SantoMultiClickUtils.reset);

  final SantoCommonConfig commonConfig =
      SantoThemeConfigurator.instance.getConfig().commonConfig;

  group('数据模型', () {
    test('SantoChatMention.parse 按长名优先匹配', () {
      const List<SantoChatMention> candidates = <SantoChatMention>[
        SantoChatMention(id: 'u1', display: '张'),
        SantoChatMention(id: 'u2', display: '张三'),
      ];
      final List<SantoChatMention> hits =
          SantoChatMention.parse('@张三 看下这个', candidates);
      expect(hits.map((SantoChatMention m) => m.id), <String>['u2']);
    });

    test('SantoChatMention.parse 未命中返回空,空候选不报错', () {
      expect(
        SantoChatMention.parse('没有提及任何人', const <SantoChatMention>[
          SantoChatMention(id: 'u1', display: '张三'),
        ]),
        isEmpty,
      );
      expect(SantoChatMention.parse('随便', const <SantoChatMention>[]), isEmpty);
    });

    test('formatChatTime 覆盖今天、昨天、同月与跨年', () {
      final DateTime now = DateTime(2026, 9, 23, 15, 30);
      expect(formatChatTime(DateTime(2026, 9, 23, 9, 5), now: now), '09:05');
      expect(formatChatTime(DateTime(2026, 9, 22, 9, 5), now: now), '昨天 09:05');
      expect(formatChatTime(DateTime(2026, 9, 1, 9, 5), now: now), '09-01 09:05');
      expect(
        formatChatTime(DateTime(2025, 12, 1, 9, 5), now: now),
        '2025-12-01 09:05',
      );
    });

    test('formatChatListTime 覆盖时分、昨天、星期与日期', () {
      final DateTime now = DateTime(2026, 9, 23, 15, 30);
      expect(formatChatListTime(DateTime(2026, 9, 23, 8), now: now), '08:00');
      expect(formatChatListTime(DateTime(2026, 9, 22, 8), now: now), '昨天');
      expect(formatChatListTime(DateTime(2026, 9, 20, 8), now: now), '星期日');
      expect(formatChatListTime(DateTime(2026, 8, 1, 8), now: now), '08-01');
      expect(
        formatChatListTime(DateTime(2025, 8, 1, 8), now: now),
        '2025-08-01',
      );
    });

    test('文件大小与视频时长格式化', () {
      expect(formatFileSize(512), '512 B');
      expect(formatFileSize(2048), '2.0 KB');
      expect(formatFileSize(2465792), '2.4 MB');
      expect(formatFileSize(null), isNull);
      expect(SantoChatVideo.formatDuration(const Duration(seconds: 95)), '01:35');
      expect(
        SantoChatVideo.formatDuration(const Duration(seconds: 3725)),
        '1:02:05',
      );
    });

    test('isMine 按用户 id 判断', () {
      const SantoChatTextMessage mine = SantoChatTextMessage(
        id: 'm1',
        author: _me,
        text: 'hi',
      );
      expect(mine.isMine('me'), isTrue);
      expect(mine.isMine('u1'), isFalse);
      expect(mine.isMine(null), isFalse);
    });
  });

  group('消息列表', () {
    testWidgets('按 currentUserId 分列左右', (tester) async {
      await tester.pumpWidget(_host(_list(<SantoChatMessage>[
        SantoChatTextMessage(
          id: 'm1',
          author: _other,
          text: '对方消息',
          createdAt: DateTime(2026, 9, 23, 10),
        ),
        SantoChatTextMessage(
          id: 'm2',
          author: _me,
          text: '我的消息',
          createdAt: DateTime(2026, 9, 23, 10, 1),
        ),
      ])));

      expect(find.text('对方消息', findRichText: true), findsOneWidget);
      expect(find.text('我的消息', findRichText: true), findsOneWidget);
      final List<SantoChatBubble> bubbles = tester
          .widgetList<SantoChatBubble>(find.byType(SantoChatBubble))
          .toList();
      expect(bubbles.length, 2);
      // 列表默认倒序,先构建的是最新的消息
      expect(bubbles.first.isMine, isTrue);
      expect(bubbles.last.isMine, isFalse);
    });

    testWidgets('换自定义主题色后气泡底色跟着变', (tester) async {
      // 先铺基座,再叠加只带主题色的配置(与示例 App / 业务 App 的注册方式一致)
      addTearDown(
        () => SantoThemeConfigurator.instance
            .register(SantoDefaultConfigUtils.defaultAllConfig),
      );
      SantoThemeConfigurator.instance
          .register(SantoDefaultConfigUtils.defaultAllConfig);
      const Color pink = Color(0xFFEB2F96);
      SantoThemeConfigurator.instance.register(SantoAllThemeConfig(
        commonConfig: SantoCommonConfig(
          brandPrimary: pink,
          brandPrimaryTap: Color(0x19EB2F96),
          colorLink: pink,
        ),
      ));

      final SantoChatConfig chatConfig =
          SantoThemeConfigurator.instance.getConfig().chatConfig;
      expect(chatConfig.myBubbleColor, pink.withOpacity(kSantoChatMyBubbleOpacity));
      expect(chatConfig.myAccentColor, pink);
    });

    testWidgets('我方气泡是主题色的透明底、对方是白底', (tester) async {
      final SantoChatConfig chatConfig =
          SantoThemeConfigurator.instance.getConfig().chatConfig;
      // 主题色 + 透明度派生,深色文字
      expect(
        chatConfig.myBubbleColor,
        commonConfig.brandPrimary.withOpacity(kSantoChatMyBubbleOpacity),
      );
      expect(chatConfig.myTextStyle.color, commonConfig.colorTextBase);
      expect(chatConfig.otherBubbleColor, commonConfig.fillBase);

      await tester.pumpWidget(_host(_list(<SantoChatMessage>[
        SantoChatTextMessage(
          id: 'm1',
          author: _other,
          text: '对方',
          createdAt: DateTime(2026, 9, 23, 10),
        ),
      ])));
      expect(_bubbleColor(tester), chatConfig.otherBubbleColor);

      await tester.pumpWidget(_host(_list(<SantoChatMessage>[
        SantoChatTextMessage(
          id: 'm2',
          author: _me,
          text: '我',
          createdAt: DateTime(2026, 9, 23, 10),
        ),
      ])));
      expect(_bubbleColor(tester), chatConfig.myBubbleColor);
      expect(_bubbleDecoration(tester).border, isNull);
    });

    testWidgets('同一发送者的连续消息只在第一条展示头像与昵称', (tester) async {
      await tester.pumpWidget(_host(_list(
        <SantoChatMessage>[
          SantoChatTextMessage(
            id: 'm1',
            author: _other,
            text: '第一条',
            createdAt: DateTime(2026, 9, 23, 10),
          ),
          SantoChatTextMessage(
            id: 'm2',
            author: _other,
            text: '第二条',
            createdAt: DateTime(2026, 9, 23, 10, 1),
          ),
        ],
        showName: true,
      )));

      final List<SantoChatBubble> bubbles = tester
          .widgetList<SantoChatBubble>(find.byType(SantoChatBubble))
          .toList();
      // 倒序构建:first 是最新的第二条,只有它没有头像与昵称
      expect(bubbles.first.showName, isFalse);
      expect(bubbles.first.showAvatar, isFalse);
      expect(bubbles.last.showName, isTrue);
      expect(bubbles.last.showAvatar, isTrue);
      expect(find.text('张三'), findsOneWidget);
    });

    testWidgets('跨天插入「昨天」时间分隔', (tester) async {
      final DateTime now = DateTime.now();
      await tester.pumpWidget(_host(_list(<SantoChatMessage>[
        SantoChatTextMessage(
          id: 'm1',
          author: _other,
          text: '前天的消息',
          createdAt: now.subtract(const Duration(days: 2)),
        ),
        SantoChatTextMessage(
          id: 'm2',
          author: _other,
          text: '昨天的消息',
          createdAt: now.subtract(const Duration(days: 1)),
        ),
      ])));

      expect(find.textContaining('昨天'), findsWidgets);
    });

    testWidgets('系统消息居中展示且不渲染气泡与头像', (tester) async {
      await tester.pumpWidget(_host(_list(<SantoChatMessage>[
        SantoChatSystemMessage(
          id: 's1',
          text: '张三加入了群聊',
          createdAt: DateTime(2026, 9, 23, 10),
        ),
      ])));

      expect(find.byType(SantoChatSystemNotice), findsOneWidget);
      expect(find.text('张三加入了群聊'), findsOneWidget);
      expect(find.byType(SantoChatBubble), findsNothing);
      expect(find.byType(SantoAvatar), findsNothing);
    });

    testWidgets('引用块渲染并可点击回调', (tester) async {
      SantoChatQuote? tapped;
      await tester.pumpWidget(_host(SantoChatMessageList(
        messages: <SantoChatMessage>[
          SantoChatTextMessage(
            id: 'm1',
            author: _me,
            text: '回复内容',
            quote: const SantoChatQuote(
              messageId: 'origin',
              title: '李四',
              preview: '被引用的话',
            ),
            createdAt: DateTime(2026, 9, 23, 10),
          ),
        ],
        currentUserId: 'me',
        onQuoteTap: (SantoChatQuote quote) => tapped = quote,
      )));

      expect(find.text('李四'), findsOneWidget);
      expect(find.text('被引用的话'), findsOneWidget);
      await tester.tap(find.byType(SantoChatQuoteView));
      expect(tapped?.messageId, 'origin');
    });

    testWidgets('我方与对方的引用块样式一致', (tester) async {
      final SantoChatConfig chatConfig =
          SantoThemeConfigurator.instance.getConfig().chatConfig;
      const SantoChatQuote quote = SantoChatQuote(
        messageId: 'origin',
        title: '李四',
        preview: '被引用的话',
      );

      BoxDecoration quoteDecoration() {
        final Container container = tester.widget<Container>(find
            .descendant(
              of: find.byType(SantoChatQuoteView),
              matching: find.byType(Container),
            )
            .first);
        return container.decoration! as BoxDecoration;
      }

      await tester.pumpWidget(_host(_list(<SantoChatMessage>[
        SantoChatTextMessage(
          id: 'm1',
          author: _other,
          text: '对方引用',
          quote: quote,
          createdAt: DateTime(2026, 9, 23, 10),
        ),
      ])));
      final BoxDecoration other = quoteDecoration();

      await tester.pumpWidget(_host(_list(<SantoChatMessage>[
        SantoChatTextMessage(
          id: 'm2',
          author: _me,
          text: '我方引用',
          quote: quote,
          createdAt: DateTime(2026, 9, 23, 10),
        ),
      ])));
      final BoxDecoration mine = quoteDecoration();

      expect(mine.color, other.color);
      expect(mine.color, chatConfig.quoteBackgroundColor);
      expect(
        (mine.border! as Border).left.color,
        (other.border! as Border).left.color,
      );
    });

    testWidgets('@ 提及与链接各自渲染成可点击片段', (tester) async {
      await tester.pumpWidget(_host(_list(<SantoChatMessage>[
        SantoChatTextMessage(
          id: 'm1',
          author: _other,
          text: '@张三 看下 https://example.com/a',
          mentions: const <SantoChatMention>[
            SantoChatMention(id: 'u1', display: '张三'),
          ],
          createdAt: DateTime(2026, 9, 23, 10),
        ),
      ])));

      final RichText richText = tester.widget<RichText>(find.descendant(
        of: find.byType(SantoChatText),
        matching: find.byType(RichText),
      ));
      final List<TextSpan> clickable = <TextSpan>[];
      richText.text.visitChildren((InlineSpan span) {
        if (span is TextSpan && span.recognizer != null) clickable.add(span);
        return true;
      });
      expect(clickable.length, 2);
      expect(clickable.first.text, '@张三');
      expect(clickable.last.text, 'https://example.com/a');
    });

    testWidgets('注册的表情名渲染成图片,未注册的保留原文', (tester) async {
      SantoChatEmojiRegistry.register('赞', 'assets/icons/grey_place_holder.png');
      addTearDown(SantoChatEmojiRegistry.clear);

      await tester.pumpWidget(_host(_list(<SantoChatMessage>[
        SantoChatTextMessage(
          id: 'm1',
          author: _other,
          text: '[赞][未注册]',
          createdAt: DateTime(2026, 9, 23, 10),
        ),
      ])));

      expect(find.byType(SantoImage), findsOneWidget);
      final RichText richText = tester.widget<RichText>(find.descendant(
        of: find.byType(SantoChatText),
        matching: find.byType(RichText),
      ));
      expect(richText.text.toPlainText(), contains('[未注册]'));
    });

    testWidgets('空列表展示空状态', (tester) async {
      await tester.pumpWidget(_host(_list(<SantoChatMessage>[])));
      expect(find.byType(SantoEmpty), findsOneWidget);
      expect(find.text('暂无消息'), findsOneWidget);
    });

    testWidgets('列表自带会话底色,对面的白气泡在白底页面上也能看清', (tester) async {
      final SantoChatConfig chatConfig =
          SantoThemeConfigurator.instance.getConfig().chatConfig;
      expect(chatConfig.backgroundColor, commonConfig.fillBody);

      await tester.pumpWidget(_host(_list(<SantoChatMessage>[
        SantoChatTextMessage(
          id: 'm1',
          author: _other,
          text: '白气泡',
          createdAt: DateTime(2026, 9, 23, 10),
        ),
      ])));

      final ColoredBox canvas = tester.widget<ColoredBox>(find
          .descendant(
            of: find.byType(SantoChatMessageList),
            matching: find.byType(ColoredBox),
          )
          .first);
      expect(canvas.color, chatConfig.backgroundColor);
    });

    testWidgets('正在输入展示三点占位', (tester) async {
      await tester.pumpWidget(_host(SantoChatMessageList(
        messages: <SantoChatMessage>[
          SantoChatTextMessage(
            id: 'm1',
            author: _me,
            text: '在吗',
            createdAt: DateTime(2026, 9, 23, 10),
          ),
        ],
        currentUserId: 'me',
        typingAuthor: _other,
      )));
      expect(find.byType(SantoChatTypingIndicator), findsOneWidget);
      // 卸载以结束循环动画
      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('加载更多中在顶部展示进度', (tester) async {
      await tester.pumpWidget(_host(_list(
        _manyMessages(3),
        hasMore: true,
        loadingMore: true,
      )));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('滚到顶部触发加载更多并出现回到底部按钮', (tester) async {
      int loaded = 0;
      final ScrollController controller = ScrollController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(_host(_list(
        _manyMessages(30),
        controller: controller,
        hasMore: true,
        onLoadMore: () => loaded++,
      )));
      expect(loaded, 0);

      controller.jumpTo(controller.position.maxScrollExtent);
      await tester.pump();
      expect(loaded, 1);
      expect(_iconNamed(SantoIcons.arrowDown), findsOneWidget);

      await tester.tap(_iconNamed(SantoIcons.arrowDown));
      await tester.pumpAndSettle();
      expect(controller.position.pixels, 0);
    });

    testWidgets('滑动气泡触发引用回复', (tester) async {
      SantoChatMessage? replied;
      await tester.pumpWidget(_host(_list(
        <SantoChatMessage>[
          SantoChatTextMessage(
            id: 'm1',
            author: _other,
            text: '滑我',
            createdAt: DateTime(2026, 9, 23, 10),
          ),
        ],
        onReply: (SantoChatMessage message) => replied = message,
      )));

      // 气泡外层 Column 是 stretch,中心落在气泡外的空白处,手势要在气泡内容上做
      await tester.drag(find.byType(SantoChatText), const Offset(120, 0));
      await tester.pumpAndSettle();
      expect(replied?.id, 'm1');
    });

    testWidgets('滑动距离不足不触发引用回复', (tester) async {
      SantoChatMessage? replied;
      await tester.pumpWidget(_host(_list(
        <SantoChatMessage>[
          SantoChatTextMessage(
            id: 'm1',
            author: _other,
            text: '滑我',
            createdAt: DateTime(2026, 9, 23, 10),
          ),
        ],
        onReply: (SantoChatMessage message) => replied = message,
      )));

      await tester.drag(find.byType(SantoChatText), const Offset(20, 0));
      await tester.pumpAndSettle();
      expect(replied, isNull);
    });

    testWidgets('长按弹出回应条,选择后回调表情', (tester) async {
      String? selected;
      SantoChatMessage? target;
      await tester.pumpWidget(_host(_list(
        <SantoChatMessage>[
          SantoChatTextMessage(
            id: 'm1',
            author: _other,
            text: '长按我',
            createdAt: DateTime(2026, 9, 23, 10),
          ),
        ],
        onReaction: (SantoChatMessage message, String emoji) {
          target = message;
          selected = emoji;
        },
      )));

      await tester.longPress(find.byType(SantoChatText));
      await tester.pumpAndSettle();

      final Finder emoji = find.text('👍', findRichText: true);
      expect(emoji, findsOneWidget);
      await tester.tap(emoji);
      await tester.pumpAndSettle();

      expect(selected, '👍');
      expect(target?.id, 'm1');
    });

    testWidgets('reactions 传空数组时不弹回应条', (tester) async {
      await tester.pumpWidget(_host(SantoChatMessageList(
        messages: <SantoChatMessage>[
          SantoChatTextMessage(
            id: 'm1',
            author: _other,
            text: '长按我',
            createdAt: DateTime(2026, 9, 23, 10),
          ),
        ],
        currentUserId: 'me',
        reactions: const <String>[],
        onReaction: (SantoChatMessage message, String emoji) {},
      )));

      await tester.longPress(find.byType(SantoChatText));
      await tester.pumpAndSettle();
      expect(find.text('👍', findRichText: true), findsNothing);
    });

    testWidgets('表情回应展示在气泡下方', (tester) async {
      await tester.pumpWidget(_host(_list(<SantoChatMessage>[
        SantoChatTextMessage(
          id: 'm1',
          author: _other,
          text: '带回应',
          createdAt: DateTime(2026, 9, 23, 10),
          reactions: const <SantoChatReaction>[
            SantoChatReaction(emoji: '👍', count: 3, reactedByMe: true),
          ],
        ),
      ])));

      expect(find.byType(SantoChatReactionView), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('文档消息展示卡片、不套气泡且点击回调', (tester) async {
      SantoChatDocMessage? opened;
      await tester.pumpWidget(_host(SantoChatMessageList(
        messages: <SantoChatMessage>[
          SantoChatDocMessage(
            id: 'd1',
            author: _other,
            title: '双十一大促容量评估文档',
            docId: 'doc_10086',
            spaceId: 'space_1',
            content: '这是评估结论',
            createdAt: DateTime(2026, 9, 23, 10),
          ),
        ],
        currentUserId: 'me',
        onDocTap: (SantoChatDocMessage message) => opened = message,
      )));

      expect(find.byType(SantoChatDocCard), findsOneWidget);
      expect(find.text('双十一大促容量评估文档'), findsOneWidget);
      expect(find.text('这是评估结论'), findsOneWidget);
      expect(find.text('点击查看文档'), findsOneWidget);
      // 卡片自带容器,不再套气泡
      expect(_bubbleContainer, findsNothing);

      await tester.tap(find.byType(SantoChatDocCard));
      expect(opened?.docId, 'doc_10086');
    });

    testWidgets('没有附言的文档消息不展示附言行', (tester) async {
      await tester.pumpWidget(_host(_list(<SantoChatMessage>[
        SantoChatDocMessage(
          id: 'd1',
          author: _me,
          title: '只有标题的文档',
          docId: 'doc_1',
          createdAt: DateTime(2026, 9, 23, 10),
        ),
      ])));

      expect(find.text('只有标题的文档'), findsOneWidget);
      expect(find.text('点击查看文档'), findsOneWidget);
    });

    testWidgets('自定义消息渲染业务内容、不套气泡且回调可用', (tester) async {
      int approved = 0;
      await tester.pumpWidget(_host(SantoChatMessageList(
        messages: <SantoChatMessage>[
          SantoChatCustomMessage(
            id: 'c1',
            author: _other,
            createdAt: DateTime(2026, 9, 23, 10),
            builder: (BuildContext context) => Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('审批单 A-1'),
                  SantoButton(
                    text: '通过',
                    type: SantoButtonType.primary,
                    autoInsertSpace: false,
                    onTap: () => approved++,
                  ),
                ],
              ),
            ),
          ),
        ],
        currentUserId: 'me',
      )));

      expect(find.text('审批单 A-1'), findsOneWidget);
      // 内容自带容器,不再套气泡
      expect(_bubbleContainer, findsNothing);

      await tester.tap(find.text('通过'));
      expect(approved, 1);
    });

    testWidgets('审批消息展示卡片、操作按钮与回调', (tester) async {
      final List<String> approved = <String>[];
      final List<String> rejected = <String>[];
      SantoChatApprovalMessage? opened;
      await tester.pumpWidget(_host(SantoChatMessageList(
        messages: <SantoChatMessage>[
          SantoChatApprovalMessage(
            id: 'a1',
            author: _other,
            taskId: 'task_1001',
            taskNo: 'SP20260924001',
            title: '双十一大促扩容申请',
            flowName: '资源申请审批流',
            applicatorName: '张三',
            currentNodeName: '技术负责人审批',
            canApprove: true,
            createdAt: DateTime(2026, 9, 23, 10),
          ),
        ],
        currentUserId: 'me',
        onApprovalTap: (SantoChatApprovalMessage m) => opened = m,
        onApprove: (SantoChatApprovalMessage m) => approved.add(m.taskId),
        onReject: (SantoChatApprovalMessage m) => rejected.add(m.taskId),
      )));

      expect(find.byType(SantoChatApprovalCard), findsOneWidget);
      expect(find.text('SP20260924001'), findsOneWidget);
      expect(find.text('双十一大促扩容申请'), findsOneWidget);
      expect(find.text('审批中'), findsOneWidget);
      expect(find.text('资源申请审批流'), findsOneWidget);
      expect(find.text('张三'), findsOneWidget);
      expect(find.text('技术负责人审批'), findsOneWidget);
      // 卡片自带容器,不再套气泡
      expect(_bubbleContainer, findsNothing);

      // SantoButton 全局防连点,连续点击前要重置
      SantoMultiClickUtils.reset();
      await tester.tap(find.text('通过'));
      expect(approved, <String>['task_1001']);
      SantoMultiClickUtils.reset();
      await tester.tap(find.text('驳回'));
      expect(rejected, <String>['task_1001']);

      await tester.tap(find.byType(SantoChatApprovalCard));
      expect(opened?.taskId, 'task_1001');
    });

    testWidgets('审批已通过或不可审批时不展示操作按钮', (tester) async {
      await tester.pumpWidget(_host(_list(<SantoChatMessage>[
        SantoChatApprovalMessage(
          id: 'a1',
          author: _me,
          taskId: 'task_1',
          title: '已通过的审批',
          approvalStatus: SantoChatApprovalStatus.approved,
          canApprove: true,
          createdAt: DateTime(2026, 9, 23, 10),
        ),
        SantoChatApprovalMessage(
          id: 'a2',
          author: _me,
          taskId: 'task_2',
          title: '无权审批的审批',
          canApprove: false,
          createdAt: DateTime(2026, 9, 23, 10, 1),
        ),
      ])));

      expect(find.text('已通过'), findsOneWidget);
      expect(find.text('通过'), findsNothing);
      expect(find.text('驳回'), findsNothing);
    });

    testWidgets('通知消息展示类型图标、未读红点与时间,点击回调', (tester) async {
      SantoChatNoticeMessage? opened;
      await tester.pumpWidget(_host(SantoChatMessageList(
        messages: <SantoChatMessage>[
          SantoChatNoticeMessage(
            id: 'n1',
            author: _other,
            title: '你被 @ 了',
            content: '张三在群里提到了你',
            noticeType: SantoChatNoticeType.mention,
            createdAt: DateTime(2026, 9, 23, 10),
          ),
        ],
        currentUserId: 'me',
        onNoticeTap: (SantoChatNoticeMessage m) => opened = m,
      )));

      expect(find.byType(SantoChatNoticeCard), findsOneWidget);
      expect(find.text('你被 @ 了'), findsOneWidget);
      expect(find.text('张三在群里提到了你'), findsOneWidget);
      expect(_iconNamed(SantoIcons.userPlus), findsOneWidget);
      // 时间取消息的 createdAt(与列表上方的时间分隔同名文案,这里查组件参数)
      final SantoChatNoticeCard notice =
          tester.widget<SantoChatNoticeCard>(find.byType(SantoChatNoticeCard));
      expect(notice.timeText, formatChatTime(DateTime(2026, 9, 23, 10)));
      expect(notice.message.read, isFalse);
      expect(_bubbleContainer, findsNothing);

      await tester.tap(find.byType(SantoChatNoticeCard));
      expect(opened?.id, 'n1');
    });

    testWidgets('通知已读时不展示红点,图标按类型取', (tester) async {
      await tester.pumpWidget(_host(_list(<SantoChatMessage>[
        SantoChatNoticeMessage(
          id: 'n1',
          author: _other,
          title: '审批已通过',
          content: '你的申请已通过',
          noticeType: SantoChatNoticeType.approval,
          read: true,
          createdAt: DateTime(2026, 9, 23, 10),
        ),
      ])));

      expect(_iconNamed(SantoIcons.checkCircle), findsOneWidget);
      final SantoChatNoticeCard card =
          tester.widget<SantoChatNoticeCard>(find.byType(SantoChatNoticeCard));
      expect(card.message.read, isTrue);
    });

    testWidgets('表情消息展示单个大表情,token 命中内置表时取字符', (tester) async {
      await tester.pumpWidget(_host(_list(<SantoChatMessage>[
        SantoChatEmojiMessage(
          id: 'e1',
          author: _other,
          symbol: '[赞]',
          createdAt: DateTime(2026, 9, 23, 10),
        ),
        SantoChatEmojiMessage(
          id: 'e2',
          author: _other,
          symbol: '🎉',
          createdAt: DateTime(2026, 9, 23, 10, 1),
        ),
      ])));

      expect(find.text('👍'), findsOneWidget);
      expect(find.text('🎉'), findsOneWidget);
    });

    testWidgets('撤回的消息不渲染本体', (tester) async {
      await tester.pumpWidget(_host(_list(<SantoChatMessage>[
        SantoChatTextMessage(
          id: 'm1',
          author: _me,
          text: '这条已经撤回了',
          recalled: true,
          createdAt: DateTime(2026, 9, 23, 10),
        ),
      ])));

      expect(find.byType(SantoChatBubble), findsNothing);
      expect(find.text('这条已经撤回了'), findsNothing);
    });

    testWidgets('发送失败展示重试图标并回调', (tester) async {
      SantoChatMessage? retried;
      await tester.pumpWidget(_host(_list(
        <SantoChatMessage>[
          SantoChatTextMessage(
            id: 'm1',
            author: _me,
            text: '失败的消息',
            status: SantoChatMessageStatus.failed,
            createdAt: DateTime(2026, 9, 23, 10),
          ),
        ],
        onRetry: (SantoChatMessage message) => retried = message,
      )));

      final Finder icon = find.descendant(
        of: find.byType(SantoChatBubble),
        matching: find.byType(SantoIcon),
      );
      expect(icon, findsOneWidget);
      await tester.tap(icon);
      expect(retried?.id, 'm1');
    });

    testWidgets('图片按原图宽高比取展示尺寸', (tester) async {
      await tester.pumpWidget(_host(_list(<SantoChatMessage>[
        SantoChatImageMessage(
          id: 'i1',
          author: _other,
          url: 'https://example.com/a.png',
          originalWidth: 300,
          originalHeight: 150,
          createdAt: DateTime(2026, 9, 23, 10),
        ),
      ])));

      final SantoImage image = tester.widget<SantoImage>(find.descendant(
        of: find.byType(SantoChatImage),
        matching: find.byType(SantoImage),
      ));
      expect(image.width, 160);
      expect(image.height, 80);
    });

    testWidgets('视频消息展示时长', (tester) async {
      await tester.pumpWidget(_host(_list(<SantoChatMessage>[
        SantoChatVideoMessage(
          id: 'v1',
          author: _other,
          coverUrl: 'https://example.com/cover.png',
          duration: const Duration(seconds: 65),
          createdAt: DateTime(2026, 9, 23, 10),
        ),
      ])));

      expect(find.byType(SantoChatVideo), findsOneWidget);
      expect(find.text('01:05'), findsOneWidget);
    });

    testWidgets('语音与文件消息渲染时长、大小', (tester) async {
      await tester.pumpWidget(_host(_list(<SantoChatMessage>[
        SantoChatVoiceMessage(
          id: 'a1',
          author: _other,
          url: 'https://example.com/a.m4a',
          duration: const Duration(seconds: 12),
          createdAt: DateTime(2026, 9, 23, 10),
        ),
        SantoChatFileMessage(
          id: 'f1',
          author: _other,
          url: 'https://example.com/a.pdf',
          name: '报告.pdf',
          size: 2048,
          createdAt: DateTime(2026, 9, 23, 10, 1),
        ),
      ])));

      expect(find.byType(SantoChatVoice), findsOneWidget);
      expect(find.text('12"'), findsOneWidget);
      expect(find.text('报告.pdf'), findsOneWidget);
      expect(find.text('2.0 KB'), findsOneWidget);
    });
  });

  group('消息状态与已编辑', () {
    Future<void> pumpMine(
      WidgetTester tester,
      SantoChatMessageStatus status, {
      bool isEdited = false,
    }) {
      return tester.pumpWidget(_host(_list(<SantoChatMessage>[
        SantoChatTextMessage(
          id: 'm1',
          author: _me,
          text: '我的消息',
          status: status,
          isEdited: isEdited,
          createdAt: DateTime(2026, 9, 23, 10),
        ),
      ])));
    }

    testWidgets('我方消息在气泡下方展示发送状态文案', (tester) async {
      await pumpMine(tester, SantoChatMessageStatus.sending);
      expect(find.text('发送中'), findsOneWidget);

      await pumpMine(tester, SantoChatMessageStatus.sent);
      expect(find.text('已发送'), findsOneWidget);

      // 已送达(对方未读)取主题色
      await pumpMine(tester, SantoChatMessageStatus.delivered);
      final Text delivered = tester.widget<Text>(find.text('未读'));
      expect(
        delivered.style?.color,
        SantoThemeConfigurator.instance.getConfig().commonConfig.brandPrimary,
      );

      await pumpMine(tester, SantoChatMessageStatus.read);
      expect(find.text('已读'), findsOneWidget);
    });

    testWidgets('状态文案在气泡下方、贴头像一侧(我方靠右)', (tester) async {
      await tester.pumpWidget(_host(SantoChatMessageList(
        messages: <SantoChatMessage>[
          SantoChatTextMessage(
            id: 'm1',
            author: _me,
            text: '我的消息',
            status: SantoChatMessageStatus.read,
            createdAt: DateTime(2026, 9, 23, 10),
          ),
        ],
        currentUserId: 'me',
      )));

      final Rect label = tester.getRect(find.text('已读'));
      final Rect bubble = tester.getRect(_bubbleContainer.first);
      expect(label.top, greaterThanOrEqualTo(bubble.bottom));
      expect(label.right, closeTo(bubble.right, 0.01));
    });

    testWidgets('对方消息不展示状态文案与回执', (tester) async {
      await tester.pumpWidget(_host(_list(<SantoChatMessage>[
        SantoChatTextMessage(
          id: 'm1',
          author: _other,
          text: '对方消息',
          status: SantoChatMessageStatus.read,
          readReceipt: const SantoChatReadReceipt(readCount: 1),
          createdAt: DateTime(2026, 9, 23, 10),
        ),
      ])));

      expect(find.text('已读'), findsNothing);
      expect(find.text('未读'), findsNothing);
    });

    testWidgets('失败展示可点击的实心警示图标', (tester) async {
      SantoChatMessage? retried;
      await tester.pumpWidget(_host(_list(
        <SantoChatMessage>[
          SantoChatTextMessage(
            id: 'm1',
            author: _me,
            text: '失败的消息',
            status: SantoChatMessageStatus.failed,
            createdAt: DateTime(2026, 9, 23, 10),
          ),
        ],
        onRetry: (SantoChatMessage message) => retried = message,
      )));
      final Finder icon = _solidIconNamed(SantoSolidIcons.warningCircle);
      expect(icon, findsOneWidget);
      // 失败不再展示文案
      expect(find.text('发送中'), findsNothing);
      await tester.tap(icon);
      expect(retried?.id, 'm1');
    });

    testWidgets('已读回执:单聊展示已读/未读,群聊展示 N 人未读/全部已读', (tester) async {
      Future<void> pumpReceipt(SantoChatReadReceipt receipt) => tester.pumpWidget(
            _host(_list(<SantoChatMessage>[
              SantoChatTextMessage(
                id: 'm1',
                author: _me,
                text: '带回执的消息',
                status: SantoChatMessageStatus.delivered,
                readReceipt: receipt,
                createdAt: DateTime(2026, 9, 23, 10),
              ),
            ])),
          );

      await pumpReceipt(const SantoChatReadReceipt(readCount: 1));
      expect(find.text('已读'), findsOneWidget);

      await pumpReceipt(const SantoChatReadReceipt(unreadCount: 1));
      expect(find.text('未读'), findsOneWidget);

      await pumpReceipt(
        const SantoChatReadReceipt(readCount: 3, unreadCount: 2),
      );
      final Text group = tester.widget<Text>(find.text('2人未读'));
      expect(
        group.style?.color,
        SantoThemeConfigurator.instance.getConfig().commonConfig.brandPrimary,
      );

      await pumpReceipt(const SantoChatReadReceipt(readCount: 6));
      expect(find.text('全部已读'), findsOneWidget);
    });

    testWidgets('同组连续消息的气泡与回执右边缘对齐', (tester) async {
      await tester.pumpWidget(_host(SantoChatMessageList(
        messages: <SantoChatMessage>[
          SantoChatTextMessage(
            id: 'm1',
            author: _me,
            text: '第一条',
            status: SantoChatMessageStatus.read,
            readReceipt: const SantoChatReadReceipt(readCount: 1),
            createdAt: DateTime(2026, 9, 23, 10),
          ),
          SantoChatTextMessage(
            id: 'm2',
            author: _me,
            text: '第二条比第一条长很多很多很多',
            status: SantoChatMessageStatus.delivered,
            readReceipt: const SantoChatReadReceipt(unreadCount: 1),
            createdAt: DateTime(2026, 9, 23, 10, 1),
          ),
        ],
        currentUserId: 'me',
        showAvatar: true,
      )));

      // 第二条不带头像,但气泡与回执的右边缘都要和第一条对齐
      final List<Rect> bubbles = <Rect>[
        for (int i = 0; i < 2; i++) tester.getRect(_bubbleContainer.at(i)),
      ];
      expect(bubbles[1].right, closeTo(bubbles[0].right, 0.01));
      expect(
        tester.getRect(find.text('未读')).right,
        closeTo(tester.getRect(find.text('已读')).right, 0.01),
      );
    });

    testWidgets('已读回执面板按已读/未读分组列出人员', (tester) async {
      await tester.pumpWidget(_host(SantoChatReadReceiptSheet(
        receipt: const SantoChatReadReceipt(
          readCount: 2,
          unreadCount: 1,
          readMembers: <SantoChatAuthor>[
            SantoChatAuthor(id: 'u1', name: '张三'),
            SantoChatAuthor(id: 'u2', name: '李四'),
          ],
          unreadMembers: <SantoChatAuthor>[SantoChatAuthor(id: 'u3', name: '王五')],
        ),
      )));

      expect(find.text('消息已读'), findsOneWidget);
      expect(find.text('已读 2'), findsOneWidget);
      expect(find.text('未读 1'), findsOneWidget);
      expect(find.text('张三'), findsOneWidget);
      expect(find.text('李四'), findsOneWidget);
      expect(find.text('王五'), findsOneWidget);
      expect(find.byType(SantoAvatar), findsNWidgets(3));
    });

    testWidgets('已读回执面板没有人员信息时展示空状态', (tester) async {
      await tester.pumpWidget(_host(SantoChatReadReceiptSheet(
        receipt: const SantoChatReadReceipt(),
      )));

      expect(find.text('暂无人员信息'), findsOneWidget);
    });

    testWidgets('点已读回执回调,业务可打开人员列表', (tester) async {
      SantoChatMessage? tapped;
      await tester.pumpWidget(_host(SantoChatMessageList(
        messages: <SantoChatMessage>[
          SantoChatTextMessage(
            id: 'm1',
            author: _me,
            text: '带回执的消息',
            status: SantoChatMessageStatus.read,
            readReceipt: const SantoChatReadReceipt(readCount: 1),
            createdAt: DateTime(2026, 9, 23, 10),
          ),
        ],
        currentUserId: 'me',
        onReadReceiptTap: (SantoChatMessage message) => tapped = message,
      )));

      await tester.tap(find.text('已读'));
      expect(tapped?.id, 'm1');
    });

    testWidgets('失败警示在非头像一侧,点击重发', (tester) async {
      SantoChatMessage? retried;
      await tester.pumpWidget(_host(SantoChatMessageList(
        messages: <SantoChatMessage>[
          SantoChatTextMessage(
            id: 'm1',
            author: _me,
            text: '失败的消息',
            status: SantoChatMessageStatus.failed,
            createdAt: DateTime(2026, 9, 23, 10),
          ),
        ],
        currentUserId: 'me',
        showAvatar: true,
        onRetry: (SantoChatMessage message) => retried = message,
      )));

      final Finder icon = _solidIconNamed(SantoSolidIcons.warningCircle);
      expect(icon, findsOneWidget);

      // 我方消息头像在右侧,警示图标要落在气泡左侧,并相对气泡上下居中
      final Rect warned = tester.getRect(icon);
      final Rect bubble = tester.getRect(_bubbleContainer.first);
      final Rect avatar = tester.getRect(find.byType(SantoAvatar).first);
      expect(warned.right, lessThanOrEqualTo(bubble.left));
      expect(warned.left, lessThan(avatar.left));
      expect(warned.center.dy, closeTo(bubble.center.dy, 0.01));

      await tester.tap(icon);
      expect(retried?.id, 'm1');
    });

    testWidgets('对方消息不展示状态图标', (tester) async {
      await tester.pumpWidget(_host(_list(<SantoChatMessage>[
        SantoChatTextMessage(
          id: 'm1',
          author: _other,
          text: '对方消息',
          status: SantoChatMessageStatus.read,
          createdAt: DateTime(2026, 9, 23, 10),
        ),
      ])));
      expect(_iconNamed(SantoIcons.doubleCheck), findsNothing);
      expect(_iconNamed(SantoIcons.check), findsNothing);
    });

    testWidgets('isEdited 展示已编辑标记', (tester) async {
      await pumpMine(tester, SantoChatMessageStatus.sent, isEdited: true);
      expect(find.text('已编辑'), findsOneWidget);

      await pumpMine(tester, SantoChatMessageStatus.sent);
      expect(find.text('已编辑'), findsNothing);
    });
  });

  group('长按菜单', () {
    SantoChatMessageList menuList(
      List<SantoChatMessage> messages, {
      List<SantoChatMenuItem> Function(SantoChatMessage, bool)? items,
      void Function(SantoChatMessage, SantoChatMenuItem)? onSelected,
      ValueChanged<SantoChatMessage>? onReply,
      void Function(SantoChatMessage, String)? onReaction,
    }) {
      return SantoChatMessageList(
        messages: messages,
        currentUserId: 'me',
        messageMenuItems: items,
        onMessageMenuSelected:
            onSelected ?? (SantoChatMessage m, SantoChatMenuItem i) {},
        onReply: onReply ?? (SantoChatMessage m) {},
        onReaction:
            onReaction ?? (SantoChatMessage m, String emoji) {},
      );
    }

    SantoChatMessage mineText({bool isEdited = false}) =>
        SantoChatTextMessage(
          id: 'm1',
          author: _me,
          text: '我的文本',
          isEdited: isEdited,
          createdAt: DateTime(2026, 9, 23, 10),
        );

    testWidgets('文本消息默认展示复制/引用/转发/编辑/删除/多选', (tester) async {
      await tester.pumpWidget(_host(menuList(<SantoChatMessage>[mineText()])));

      await tester.longPress(find.byType(SantoChatText));
      await tester.pumpAndSettle();

      for (final String label in <String>['复制', '引用', '转发', '编辑', '删除', '多选']) {
        expect(find.text(label), findsOneWidget, reason: label);
      }
      expect(find.text('👍', findRichText: true), findsOneWidget);
    });

    testWidgets('对方的文本消息没有编辑与删除', (tester) async {
      await tester.pumpWidget(_host(menuList(<SantoChatMessage>[
        SantoChatTextMessage(
          id: 'm1',
          author: _other,
          text: '对方的文本',
          createdAt: DateTime(2026, 9, 23, 10),
        ),
      ])));

      await tester.longPress(find.byType(SantoChatText));
      await tester.pumpAndSettle();

      expect(find.text('复制'), findsOneWidget);
      expect(find.text('编辑'), findsNothing);
      expect(find.text('删除'), findsNothing);
      expect(find.text('多选'), findsOneWidget);
    });

    testWidgets('语音消息额外提供转文字', (tester) async {
      await tester.pumpWidget(_host(menuList(<SantoChatMessage>[
        SantoChatVoiceMessage(
          id: 'm1',
          author: _other,
          url: 'https://example.com/a.m4a',
          duration: const Duration(seconds: 5),
          createdAt: DateTime(2026, 9, 23, 10),
        ),
      ])));

      await tester.tap(find.byType(SantoChatVoice));
      await tester.longPress(find.byType(SantoChatVoice));
      await tester.pumpAndSettle();

      expect(find.text('转文字'), findsOneWidget);
      expect(find.text('复制'), findsNothing);
      expect(find.text('转发'), findsOneWidget);
    });

    testWidgets('点选菜单项回调 key,点引用同时走 onReply', (tester) async {
      final List<String> keys = <String>[];
      SantoChatMessage? replied;
      await tester.pumpWidget(_host(menuList(
        <SantoChatMessage>[mineText()],
        onSelected: (SantoChatMessage m, SantoChatMenuItem item) =>
            keys.add(item.key),
        onReply: (SantoChatMessage message) => replied = message,
      )));

      await tester.longPress(find.byType(SantoChatText));
      await tester.pumpAndSettle();
      await tester.tap(find.text('复制'));
      await tester.pumpAndSettle();
      expect(keys, <String>['copy']);

      await tester.longPress(find.byType(SantoChatText));
      await tester.pumpAndSettle();
      await tester.tap(find.text('引用'));
      await tester.pumpAndSettle();
      expect(keys, <String>['copy', 'quote']);
      expect(replied?.id, 'm1');
    });

        testWidgets('菜单项可自定义,系统消息不弹菜单', (tester) async {
      await tester.pumpWidget(_host(menuList(
        <SantoChatMessage>[mineText()],
        items: (SantoChatMessage message, bool isMine) => const <SantoChatMenuItem>[
          SantoChatMenuItem(key: 'favorite', label: '收藏', icon: SantoIcons.star),
        ],
      )));

      await tester.longPress(find.byType(SantoChatText));
      await tester.pumpAndSettle();
      expect(find.text('收藏'), findsOneWidget);
      expect(find.text('复制'), findsNothing);

      await tester.pumpWidget(_host(menuList(<SantoChatMessage>[
        SantoChatSystemMessage(
          id: 's1',
          text: '系统提示',
          createdAt: DateTime(2026, 9, 23, 10),
        ),
      ])));
      await tester.longPress(find.byType(SantoChatSystemNotice));
      await tester.pumpAndSettle();
      expect(find.text('引用'), findsNothing);
      expect(find.text('转发'), findsNothing);
    });

    testWidgets('菜单项超过 10 个时一排 5 个换到第三排', (tester) async {
      await tester.pumpWidget(_host(menuList(
        <SantoChatMessage>[mineText()],
        items: (SantoChatMessage message, bool isMine) => <SantoChatMenuItem>[
          for (int i = 0; i < 12; i++)
            SantoChatMenuItem(
              key: 'item$i',
              label: '菜单$i',
              icon: SantoIcons.star,
            ),
        ],
      )));

      await tester.longPress(find.byType(SantoChatText));
      await tester.pumpAndSettle();

      expect(find.text('菜单11'), findsOneWidget);
      // 用图标定位格子(文案居中,同一行不同字数的左边缘会差一点)
      Finder iconAt(int index) => find
          .byWidgetPredicate((Widget widget) =>
              widget is SantoIcon && widget.name == SantoIcons.star)
          .at(index);
      final Rect first = tester.getRect(iconAt(0));
      final Rect sixth = tester.getRect(iconAt(5));
      final Rect eleventh = tester.getRect(iconAt(10));
      // 一排 5 个:第 6、11 个换行,且每排第一个都贴同一列
      expect(sixth.top, greaterThan(first.top));
      expect(eleventh.top, greaterThan(sixth.top));
      expect(sixth.left, first.left);
      expect(eleventh.left, first.left);
    });

    testWidgets('不同落点位置一致,且同时只保留一个菜单', (tester) async {
      await tester.pumpWidget(_host(SantoChatMessageList(
        messages: <SantoChatMessage>[
          mineText(),
          SantoChatTextMessage(
            id: 'm2',
            author: _me,
            text: '第二条我的消息',
            createdAt: DateTime(2026, 9, 23, 10, 1),
          ),
        ],
        currentUserId: 'me',
        onMessageMenuSelected:
            (SantoChatMessage m, SantoChatMenuItem i) {},
        onReply: (SantoChatMessage m) {},
        onReaction: (SantoChatMessage m, String emoji) {},
      )));

      final Finder first = find.byType(SantoChatText).last;
      final Finder second = find.byType(SantoChatText).first;
      final Rect firstRect = tester.getRect(first);

      // 同一条消息的两个不同落点,菜单位置应完全一致
      await tester.longPressAt(Offset(firstRect.left + 5, firstRect.center.dy));
      await tester.pumpAndSettle();
      final Rect byLeftEdge = tester.getRect(find.text('复制'));

      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(find.text('复制'), findsNothing);

      await tester.longPressAt(
        Offset(firstRect.right - 5, firstRect.center.dy + 3),
      );
      await tester.pumpAndSettle();
      expect(tester.getRect(find.text('复制')), byLeftEdge);

      // 换一条消息:菜单不叠加,水平位置不变,垂直贴到新消息上方
      await tester.longPressAt(tester.getCenter(second));
      await tester.pumpAndSettle();
      expect(find.text('复制'), findsOneWidget);
      final Rect other = tester.getRect(find.text('复制'));
      expect(other.left, byLeftEdge.left);
      expect(other.top, greaterThan(byLeftEdge.top));
    });
  });

  group('输入区', () {
    testWidgets('不带发送按钮', (tester) async {
      await tester.pumpWidget(_host(
        SantoChatInput(onSend: (String text) {}),
        height: 120,
      ));
      expect(find.byType(SantoButton), findsNothing);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('内容为空时输入法发送键不触发回调', (tester) async {
      final List<String> sent = <String>[];
      await tester.pumpWidget(_host(
        SantoChatInput(onSend: sent.add),
        height: 120,
      ));

      await tester.tap(find.byType(TextField));
      await tester.pump();
      await tester.testTextInput.receiveAction(TextInputAction.send);
      await tester.pump();
      expect(sent, isEmpty);
    });

    testWidgets('输入法发送键发送后清空输入框', (tester) async {
      final List<String> sent = <String>[];
      await tester.pumpWidget(_host(
        SantoChatInput(onSend: sent.add),
        height: 120,
      ));

      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '你好');
      await tester.pump();
      await tester.testTextInput.receiveAction(TextInputAction.send);
      await tester.pump();

      expect(sent, <String>['你好']);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller?.text,
        isEmpty,
      );
    });

    testWidgets('提示文案不换行,超出省略且输入框仍是一行高', (tester) async {
      const String longHint = '这是一条特别长的提示文案,长到足以撑满整个输入框的可用宽度并且还会继续超出';
      await tester.pumpWidget(_host(
        SantoChatInput(hintText: longHint, onSend: (String text) {}),
        height: 200,
      ));

      final Text hint = tester.widget<Text>(find.text(longHint));
      expect(hint.maxLines, 1);
      expect(hint.overflow, TextOverflow.ellipsis);
      // 一行输入框的高度,没有因为长文案被撑成两行
      expect(tester.getSize(find.byType(TextField)).height, lessThan(40));
    });

    testWidgets('回复态展示引用条并回调取消', (tester) async {
      bool cancelled = false;
      await tester.pumpWidget(_host(
        SantoChatInput(
          onSend: (String text) {},
          replyTo: const SantoChatQuote(
            messageId: 'm1',
            title: '张三',
            preview: '被回复的内容',
          ),
          onCancelReply: () => cancelled = true,
        ),
        height: 160,
      ));

      expect(find.byType(SantoChatQuoteView), findsOneWidget);
      expect(find.text('被回复的内容'), findsOneWidget);
      // 关闭按钮是实心 xmark-circle、取失败色,尺寸 20
      final SantoIcon closeIcon =
          tester.widget<SantoIcon>(_solidIconNamed(SantoSolidIcons.xmarkCircle));
      expect(closeIcon.color,
          SantoThemeConfigurator.instance.getConfig().commonConfig.brandError);

      await tester.tap(_solidIconNamed(SantoSolidIcons.xmarkCircle));
      await tester.pump();
      expect(cancelled, isTrue);
    });

    testWidgets('禁用态输入框不可编辑', (tester) async {
      final List<String> sent = <String>[];
      await tester.pumpWidget(_host(
        SantoChatInput(onSend: sent.add, enabled: false),
        height: 120,
      ));

      expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
      expect(_iconNamed(SantoIcons.plus), findsNothing);
      expect(sent, isEmpty);
    });

    testWidgets('扩展面板默认三项,点 + 展开、再点收起', (tester) async {
      await tester.pumpWidget(_host(
        SantoChatInput(onSend: (String text) {}),
        height: 320,
      ));

      expect(find.text('照片'), findsNothing);

      await tester.tap(_iconNamed(SantoIcons.plus));
      await tester.pumpAndSettle();
      expect(find.text('照片'), findsOneWidget);
      expect(find.text('拍摄'), findsOneWidget);
      expect(find.text('文件'), findsOneWidget);

      await tester.tap(_iconNamed(SantoIcons.plus));
      await tester.pumpAndSettle();
      expect(find.text('照片'), findsNothing);
    });

    testWidgets('点选扩展项回调,扩展项可自定义', (tester) async {
      SantoChatExtension? picked;
      await tester.pumpWidget(_host(
        SantoChatInput(
          onSend: (String text) {},
          extensions: const <SantoChatExtension>[
            SantoChatExtension(
              key: 'location',
              label: '位置',
              icon: SantoIcons.pin,
            ),
          ],
          onExtensionTap: (SantoChatExtension extension) =>
              picked = extension,
        ),
        height: 320,
      ));

      await tester.tap(_iconNamed(SantoIcons.plus));
      await tester.pumpAndSettle();
      expect(find.text('位置'), findsOneWidget);

      await tester.tap(find.text('位置'));
      await tester.pumpAndSettle();
      expect(picked?.key, 'location');
    });

    testWidgets('点击输入框收起已展开的扩展面板', (tester) async {
      await tester.pumpWidget(_host(
        SantoChatInput(onSend: (String text) {}),
        height: 320,
      ));

      await tester.tap(_iconNamed(SantoIcons.plus));
      await tester.pumpAndSettle();
      expect(find.text('照片'), findsOneWidget);

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(find.text('照片'), findsNothing);
    });

    testWidgets('扩展项传空数组时不展示 + 入口', (tester) async {
      await tester.pumpWidget(_host(
        SantoChatInput(
          onSend: (String text) {},
          extensions: const <SantoChatExtension>[],
        ),
        height: 120,
      ));
      expect(_iconNamed(SantoIcons.plus), findsNothing);
    });

    testWidgets('扩展面板高度固定,入口平铺一排 5 个且超出换行左对齐', (tester) async {
      const List<SantoChatExtension> extensions = <SantoChatExtension>[
        SantoChatExtension.photo,
        SantoChatExtension.camera,
        SantoChatExtension.file,
        SantoChatExtension(key: 'location', label: '位置', icon: SantoIcons.pin),
        SantoChatExtension(key: 'card', label: '名片', icon: SantoIcons.user),
        SantoChatExtension(key: 'redPacket', label: '红包', icon: SantoIcons.plus),
        SantoChatExtension(key: 'vote', label: '投票', icon: SantoIcons.check),
      ];
      await tester.pumpWidget(_host(
        SantoChatInput(
          onSend: (String text) {},
          extensions: extensions,
          onExtensionTap: (SantoChatExtension extension) {},
        ),
        height: 400,
      ));

      await tester.tap(_iconNamed(SantoIcons.plus));
      await tester.pumpAndSettle();

      final Finder panel = find.byWidgetPredicate((Widget widget) =>
          widget is SizedBox &&
          widget.height == kSantoChatPanelHeight);
      expect(panel, findsOneWidget);
      expect(tester.getSize(panel).height, kSantoChatPanelHeight);

      // 前 5 个同一行,第 6 个换行且与第一个左对齐
      final List<Rect> rects = <Rect>[
        for (final String label in <String>['照片', '拍摄', '文件', '位置', '名片', '红包'])
          tester.getRect(find.text(label)),
      ];
      for (int i = 1; i < 5; i++) {
        expect(rects[i].top, rects.first.top, reason: '第 ${i + 1} 个应在第一行');
      }
      expect(rects[5].top, greaterThan(rects.first.top));
      expect(rects[5].left, rects.first.left);
      // 只有一页时不展示分页指示点
      expect(find.byKey(_panelIndicator), findsNothing);
    });

    testWidgets('扩展菜单超过两排时左右滑动翻页', (tester) async {
      final List<SantoChatExtension> extensions = <SantoChatExtension>[
        SantoChatExtension.photo,
        SantoChatExtension.camera,
        SantoChatExtension.file,
        for (int i = 0; i < 9; i++)
          SantoChatExtension(
            key: 'extra$i',
            label: '扩展$i',
            icon: SantoIcons.star,
          ),
      ];
      await tester.pumpWidget(_host(
        SantoChatInput(
          onSend: (String text) {},
          extensions: extensions,
          onExtensionTap: (SantoChatExtension extension) {},
        ),
        height: 400,
      ));

      await tester.tap(_iconNamed(SantoIcons.plus));
      await tester.pumpAndSettle();

      // 一排 5 个、两排一页:12 项分两页,第 11 项(扩展7)才翻到第二页
      expect(find.text('扩展0'), findsOneWidget);
      expect(find.text('扩展6'), findsOneWidget);
      expect(find.text('扩展7'), findsNothing);
      expect(find.byKey(_panelIndicator), findsOneWidget);

      await tester.drag(find.byType(PageView), const Offset(-600, 0));
      await tester.pumpAndSettle();

      expect(find.text('扩展0'), findsNothing);
      expect(find.text('扩展7'), findsOneWidget);
      expect(find.text('扩展8'), findsOneWidget);
      // 翻页不改变面板高度
      final Finder panel = find.byWidgetPredicate((Widget widget) =>
          widget is SizedBox && widget.height == kSantoChatPanelHeight);
      expect(tester.getSize(panel).height, kSantoChatPanelHeight);
    });

    testWidgets('表情面板超过四排时左右滑动翻页', (tester) async {
      final List<SantoChatEmoji> emojis = <SantoChatEmoji>[
        ...kSantoChatDefaultEmojis,
        for (int i = 0; i < 8; i++)
          SantoChatEmoji(name: 'extra$i', symbol: '🆕'),
      ];
      await tester.pumpWidget(_host(
        SantoChatInput(
          onSend: (String text) {},
          emojis: emojis,
          onExtensionTap: (SantoChatExtension extension) {},
        ),
        height: 400,
      ));

      await tester.tap(_iconNamed(SantoIcons.emoji));
      await tester.pumpAndSettle();

      // 8 列四排 = 32 个一页:内置 32 个正好一页,多出 8 个翻到第二页
      expect(find.text('😊'), findsOneWidget);
      expect(find.text('🆕'), findsNothing);
      expect(find.byKey(_panelIndicator), findsOneWidget);

      await tester.drag(find.byType(PageView), const Offset(-600, 0));
      await tester.pumpAndSettle();

      expect(find.text('😊'), findsNothing);
      expect(find.text('🆕'), findsNWidgets(8));
    });

    testWidgets('扩展菜单入口贴左对齐', (tester) async {
      await tester.pumpWidget(_host(
        SantoChatInput(
          onSend: (String text) {},
          onExtensionTap: (SantoChatExtension extension) {},
        ),
        height: 400,
      ));

      await tester.tap(_iconNamed(SantoIcons.plus));
      await tester.pumpAndSettle();

      // 首项仍然贴住面板内边距(文案在图标宽度内居中,整体不居中)
      expect(
        tester.getRect(find.text('照片')).left,
        commonConfig.hSpacingMd,
      );
      // 三个默认项排在左边,不铺满整行
      final List<Rect> rects = <Rect>[
        for (final String label in <String>['照片', '拍摄', '文件'])
          tester.getRect(find.text(label)),
      ];
      for (final Rect rect in rects) {
        expect(rect.left, lessThan(tester.view.physicalSize.width / 2));
      }
      // 文案在入口图标等宽区域内居中
      expect(
        tester.widget<Text>(find.text('照片')).textAlign,
        TextAlign.center,
      );
      expect(
        tester.getRect(find.text('照片')).width,
        kSantoChatExtensionItemSize,
      );
    });

    testWidgets('扩展菜单按固定网格排布,空位保留不回填', (tester) async {
      final List<SantoChatExtension> extensions = <SantoChatExtension>[
        SantoChatExtension.photo,
        SantoChatExtension.camera,
        SantoChatExtension.file,
        SantoChatExtension(key: 'location', label: '位置', icon: SantoIcons.pin),
        SantoChatExtension(key: 'card', label: '名片', icon: SantoIcons.user),
        SantoChatExtension(
          key: 'voice',
          label: '语音',
          icon: SantoIcons.microphone,
        ),
      ];
      await tester.pumpWidget(_host(
        SantoChatInput(
          onSend: (String text) {},
          extensions: extensions,
          onExtensionTap: (SantoChatExtension extension) {},
        ),
        height: 400,
      ));

      await tester.tap(_iconNamed(SantoIcons.plus));
      await tester.pumpAndSettle();

      final Finder panel = find.byWidgetPredicate((Widget widget) =>
          widget is SizedBox && widget.height == kSantoChatPanelHeight);
      // 5 列等宽:列宽固定为面板内容宽的 1/5,条目依次占格,不满也整体贴左
      final double cellWidth =
          (tester.getSize(panel).width - commonConfig.hSpacingMd * 2) / 5;
      final Rect first = tester.getRect(find.text('照片'));
      final Rect second = tester.getRect(find.text('拍摄'));
      final Rect third = tester.getRect(find.text('文件'));
      expect(first.left, commonConfig.hSpacingMd);
      expect(second.left, closeTo(first.left + cellWidth, 0.01));
      expect(third.left, closeTo(first.left + cellWidth * 2, 0.01));
      // 第 6 项落到第二行第一列,中间空出的第 4、5 格不回填
      final Rect sixth = tester.getRect(find.text('语音'));
      expect(sixth.left, first.left);
      expect(sixth.top, greaterThan(first.top));
      // 第一行从面板左上角起排
      expect(tester.getRect(find.text('位置')).top, first.top);
    });

    testWidgets('表情面板与扩展面板同高且互相切换', (tester) async {
      Finder panel() => find.byWidgetPredicate((Widget widget) =>
          widget is SizedBox && widget.height == kSantoChatPanelHeight);

      await tester.pumpWidget(_host(
        SantoChatInput(
          onSend: (String text) {},
          onExtensionTap: (SantoChatExtension extension) {},
        ),
        height: 400,
      ));
      expect(find.text('😊'), findsNothing);

      await tester.tap(_iconNamed(SantoIcons.emoji));
      await tester.pumpAndSettle();
      expect(find.text('😊'), findsOneWidget);
      expect(tester.getSize(panel()).height, kSantoChatPanelHeight);

      // 切到扩展面板:表情面板收起,高度不变
      await tester.tap(_iconNamed(SantoIcons.plus));
      await tester.pumpAndSettle();
      expect(find.text('😊'), findsNothing);
      expect(find.text('照片'), findsOneWidget);
      expect(tester.getSize(panel()).height, kSantoChatPanelHeight);

      // 再点同一个按钮收起
      await tester.tap(_iconNamed(SantoIcons.plus));
      await tester.pumpAndSettle();
      expect(find.text('照片'), findsNothing);
    });

    testWidgets('点表情把 token 插到光标处', (tester) async {
      final List<String> changed = <String>[];
      final TextEditingController controller =
          TextEditingController(text: '看这个');
      addTearDown(controller.dispose);

      await tester.pumpWidget(_host(
        SantoChatInput(
          controller: controller,
          onSend: (String text) {},
          onChanged: changed.add,
        ),
        height: 400,
      ));

      await tester.tap(_iconNamed(SantoIcons.emoji));
      await tester.pumpAndSettle();
      await tester.tap(find.text('😊'));
      await tester.pumpAndSettle();

      expect(controller.text, '看这个[微笑]');
      expect(changed, <String>['看这个[微笑]']);
    });

    testWidgets('表情项传空数组时不展示表情入口', (tester) async {
      await tester.pumpWidget(_host(
        SantoChatInput(
          onSend: (String text) {},
          emojis: const <SantoChatEmoji>[],
        ),
        height: 120,
      ));
      expect(_iconNamed(SantoIcons.emoji), findsNothing);
    });

    testWidgets('编辑态展示编辑条并预填内容,提交走 onSend', (tester) async {
      final List<String> sent = <String>[];
      await tester.pumpWidget(_host(
        SantoChatInput(onSend: sent.add, editingText: '原来的内容'),
        height: 160,
      ));

      expect(find.text('编辑消息'), findsOneWidget);
      // 编辑条摘要与输入框各一次
      expect(find.text('原来的内容'), findsNWidgets(2));
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller?.text,
        '原来的内容',
      );

      await tester.tap(find.byType(TextField));
      await tester.pump();
      await tester.testTextInput.receiveAction(TextInputAction.send);
      await tester.pump();
      expect(sent, <String>['原来的内容']);
    });

    testWidgets('编辑条关闭回调', (tester) async {
      bool cancelled = false;
      await tester.pumpWidget(_host(
        SantoChatInput(
          onSend: (String text) {},
          editingText: '内容',
          onCancelEdit: () => cancelled = true,
        ),
        height: 160,
      ));

      await tester.tap(_solidIconNamed(SantoSolidIcons.xmarkCircle));
      await tester.pump();
      expect(cancelled, isTrue);
    });

    testWidgets('外部状态切入编辑态时预填内容', (tester) async {
      Widget build(String? editingText) {
        return _host(
          SantoChatInput(
            onSend: (String text) {},
            editingText: editingText,
          ),
          height: 160,
        );
      }

      await tester.pumpWidget(build(null));
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller?.text,
        isEmpty,
      );

      await tester.pumpWidget(build('待编辑内容'));
      await tester.pump();
      expect(find.text('编辑消息'), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller?.text,
        '待编辑内容',
      );
    });
  });

  group('多选', () {
    testWidgets('多选态展示勾选框,点整行切换选中', (tester) async {
      SantoChatMessage? toggled;
      await tester.pumpWidget(_host(SantoChatMessageList(
        messages: _manyMessages(3),
        currentUserId: 'me',
        selectionMode: true,
        selectedIds: const <String>{'m1'},
        onSelectionToggle: (SantoChatMessage message) => toggled = message,
      )));

      expect(find.byType(SantoIcon), findsOneWidget);
      expect(find.byType(SantoChatText), findsNWidgets(3));

      await tester.tap(find.byType(SantoChatText).first);
      await tester.pump();
      expect(toggled, isNotNull);
    });

    testWidgets('多选态不触发点击消息与滑动引用', (tester) async {
      SantoChatMessage? tapped;
      SantoChatMessage? replied;
      await tester.pumpWidget(_host(SantoChatMessageList(
        messages: _manyMessages(1),
        currentUserId: 'me',
        selectionMode: true,
        onMessageTap: (SantoChatMessage message) => tapped = message,
        onReply: (SantoChatMessage message) => replied = message,
      )));

      await tester.tap(find.byType(SantoChatText));
      await tester.drag(find.byType(SantoChatText), const Offset(120, 0));
      await tester.pumpAndSettle();
      expect(tapped, isNull);
      expect(replied, isNull);
    });

    testWidgets('多选勾选框相对整行上下居中', (tester) async {
      await tester.pumpWidget(_host(SantoChatMessageList(
        messages: _manyMessages(1),
        currentUserId: 'me',
        selectionMode: true,
        selectedIds: const <String>{'m0'},
        onSelectionToggle: (SantoChatMessage message) {},
      )));

      final Rect indicator = tester.getRect(find.descendant(
        of: find.byType(SantoChatMessageList),
        matching: find.byType(SantoIcon),
      ));
      final Rect row = tester.getRect(find.byType(SantoChatBubble));
      expect(indicator.center.dy, closeTo(row.center.dy, 0.5));
    });

    testWidgets('操作栏展示已选条数,0 条时置灰', (tester) async {
      SantoChatMenuItem? action;
      await tester.pumpWidget(_host(
        SantoChatSelectionBar(
          selectedCount: 2,
          onAction: (SantoChatMenuItem item) => action = item,
        ),
        height: 120,
      ));

      expect(find.text('已选 2 条'), findsOneWidget);
      expect(find.text('转发'), findsOneWidget);

      await tester.tap(find.text('删除'));
      expect(action?.key, 'delete');

      await tester.pumpWidget(_host(
        SantoChatSelectionBar(
          selectedCount: 0,
          onAction: (SantoChatMenuItem item) => action = item,
        ),
        height: 120,
      ));
      await tester.tap(find.text('删除'));
      expect(action?.key, 'delete');
    });

    testWidgets('SantoChat 多选态用操作栏替换输入区', (tester) async {
      await tester.pumpWidget(_host(
        SantoChat(
          messages: _manyMessages(2),
          currentUserId: 'me',
          selectionMode: true,
          selectedIds: const <String>{'m0', 'm1'},
          onSend: (String text) {},
        ),
        height: 400,
      ));

      expect(find.byType(SantoChatSelectionBar), findsOneWidget);
      expect(find.byType(SantoChatInput), findsNothing);
      expect(find.text('已选 2 条'), findsOneWidget);
    });
  });

  group('会话列表', () {
    testWidgets('展示未读数、置顶标记与免打扰角标', (tester) async {
      await tester.pumpWidget(_host(
        SantoChatList(
          conversations: <SantoChatConversation>[
            SantoChatConversation(
              id: 'c1',
              title: '产品群',
              preview: '最后一条消息',
              updatedAt: DateTime.now(),
              unreadCount: 3,
              pinned: true,
            ),
            SantoChatConversation(
              id: 'c2',
              title: '通知',
              preview: '版本已发布',
              updatedAt: DateTime.now(),
              unreadCount: 120,
              muted: true,
            ),
            SantoChatConversation(
              id: 'c3',
              title: '李四',
              preview: '在吗',
              updatedAt: DateTime.now(),
              unreadCount: 120,
            ),
          ],
        ),
        height: 200,
      ));

      expect(find.text('置顶'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('99+'), findsOneWidget);
      expect(find.text('产品群'), findsOneWidget);
      // 免打扰会话只显示静音角标,不显示未读数字
      expect(_iconNamed(SantoIcons.soundOff), findsOneWidget);
    });

    testWidgets('空列表展示空状态', (tester) async {
      await tester.pumpWidget(_host(
        SantoChatList(conversations: const <SantoChatConversation>[]),
      ));
      expect(find.text('暂无会话'), findsOneWidget);
    });

    testWidgets('点击与长按回调', (tester) async {
      SantoChatConversation? tapped;
      SantoChatConversation? longPressed;
      await tester.pumpWidget(_host(
        SantoChatList(
          conversations: <SantoChatConversation>[
            const SantoChatConversation(id: 'c1', title: '张三', preview: '你好'),
          ],
          onTap: (SantoChatConversation c) => tapped = c,
          onLongPress: (SantoChatConversation c) => longPressed = c,
        ),
        height: 120,
      ));

      await tester.tap(find.text('张三'));
      expect(tapped?.id, 'c1');

      await tester.longPress(find.text('张三'));
      expect(longPressed?.id, 'c1');
    });
  });

  group('总装组件', () {
    testWidgets('SantoChat 组合头部、列表与输入区', (tester) async {
      final List<String> sent = <String>[];
      await tester.pumpWidget(_host(
        SantoChat(
          messages: <SantoChatMessage>[
            SantoChatTextMessage(
              id: 'm1',
              author: _me,
              text: '你好',
              createdAt: DateTime(2026, 9, 23, 10),
            ),
          ],
          currentUserId: 'me',
          header: const Text('群公告'),
          onSend: sent.add,
        ),
        height: 400,
      ));

      expect(find.text('群公告'), findsOneWidget);
      expect(find.text('你好', findRichText: true), findsOneWidget);
      expect(find.byType(SantoChatMessageList), findsOneWidget);
      expect(find.byType(SantoChatInput), findsOneWidget);

      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '收到');
      await tester.pump();
      await tester.testTextInput.receiveAction(TextInputAction.send);
      await tester.pump();
      expect(sent, <String>['收到']);
    });
  });
}
