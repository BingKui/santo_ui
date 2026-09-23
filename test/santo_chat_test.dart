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

    testWidgets('我方气泡是浅色底深色字,对方是白底', (tester) async {
      final SantoChatConfig chatConfig =
          SantoThemeConfigurator.instance.getConfig().chatConfig;
      // 对齐 DevOpsMobile:我方浅品牌底(主题色 10% 透明)+ 深色文字,不再用品牌色实心
      expect(
        chatConfig.myBubbleColor,
        commonConfig.brandPrimary.withOpacity(kSantoChatMyBubbleOpacity),
      );
      expect(chatConfig.myTextStyle.color, commonConfig.colorTextBase);

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

  group('输入区', () {
    testWidgets('空内容时发送按钮不可用', (tester) async {
      final List<String> sent = <String>[];
      await tester.pumpWidget(_host(
        SantoChatInput(onSend: sent.add),
        height: 120,
      ));

      expect(tester.widget<SantoButton>(find.byType(SantoButton)).isEnable,
          isFalse);
      expect(sent, isEmpty);
    });

    testWidgets('输入后可发送,回调后清空输入框', (tester) async {
      final List<String> sent = <String>[];
      await tester.pumpWidget(_host(
        SantoChatInput(onSend: sent.add),
        height: 120,
      ));

      await tester.enterText(find.byType(TextField), '你好');
      await tester.pump();
      expect(tester.widget<SantoButton>(find.byType(SantoButton)).isEnable,
          isTrue);

      await tester.tap(find.byType(SantoButton));
      await tester.pump();
      expect(sent, <String>['你好']);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller?.text,
        isEmpty,
      );
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

      await tester.tap(_iconNamed(SantoIcons.xmark));
      await tester.pump();
      expect(cancelled, isTrue);
    });

    testWidgets('禁用态发送按钮不可用且输入框不可编辑', (tester) async {
      final List<String> sent = <String>[];
      await tester.pumpWidget(_host(
        SantoChatInput(onSend: sent.add, enabled: false),
        height: 120,
      ));

      expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
      expect(tester.widget<SantoButton>(find.byType(SantoButton)).isEnable,
          isFalse);
      expect(sent, isEmpty);
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

      await tester.enterText(find.byType(TextField), '收到');
      await tester.pump();
      await tester.tap(find.byType(SantoButton));
      await tester.pump();
      expect(sent, <String>['收到']);
    });
  });
}
