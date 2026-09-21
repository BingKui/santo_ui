import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

/// 主题默认的内容区间距 commonConfig.gapMd(规范 iGapAllMiddle)
const double kContentGap = 15;

void main() {
  testWidgets('PageLayout 用 title 构建导航栏', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: SantoPageLayout(title: '页面标题',
        children: <Widget>[
          Text('页面内容'),
        ]),
    ));

    expect(find.byType(SantoAppBar), findsOneWidget);
    expect(find.text('页面标题'), findsOneWidget);
    expect(find.text('页面内容'), findsOneWidget);
  });

  testWidgets('PageLayout 传入 appBar 时优先于 title', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SantoPageLayout(
        title: '简写标题',
        appBar: SantoAppBar(title: '自定义标题'),
        children: <Widget>[
          const Text('页面内容'),
        ],
      ),
    ));

    expect(find.text('自定义标题'), findsOneWidget);
    expect(find.text('简写标题'), findsNothing);
  });

  testWidgets('PageLayout 不传导航栏时内容避开状态栏', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(padding: const EdgeInsets.only(top: 47)),
          child: const SantoPageLayout(
            children: <Widget>[
              Text('页面内容'),
            ]),
        ),
      ),
    ));

    final scroll = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView));
    expect((scroll.padding as EdgeInsets).top, kContentGap + 47);
  });

  testWidgets('PageLayout 内容可滚动并应用默认 padding', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: SantoPageLayout(
        children: <Widget>[
          Text('页面内容'),
        ]),
    ));

    final scroll = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView));
    expect(scroll.padding, iGapAllMiddle);
  });

  testWidgets('PageLayout 预留底部安全区域与 bottomInset', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(padding: const EdgeInsets.only(bottom: 34)),
          child: const SantoPageLayout(bottomInset: 8,
            children: <Widget>[
              Text('页面内容'),
            ]),
        ),
      ),
    ));

    final scroll = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView));
    // 底部安全区域不再算进滚动 padding,而由内容尾部的 SantoBottomSafeArea 承担
    expect((scroll.padding as EdgeInsets).bottom, kContentGap);
    expect(tester.getSize(find.byType(SantoBottomSafeArea)).height, 34 + 8);
  });

  testWidgets('PageLayout bottomSafeArea 为 false 时不预留安全区域', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(padding: const EdgeInsets.only(bottom: 34)),
          child: const SantoPageLayout(
            bottomSafeArea: false,
            children: <Widget>[
              Text('页面内容'),
            ],
          ),
        ),
      ),
    ));

    final scroll = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView));
    expect((scroll.padding as EdgeInsets).bottom, kContentGap);
    expect(tester.getSize(find.byType(SantoBottomSafeArea)).height, 0);
  });

  testWidgets('PageLayout scrollable 为 false 时不产生滚动容器', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: SantoPageLayout(scrollable: false,
        children: <Widget>[
          Text('页面内容'),
        ]),
    ));

    expect(find.byType(SingleChildScrollView), findsNothing);
  });

  testWidgets('PageLayout 非滚动态:底部安全区并入内容的 MediaQuery', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            padding: const EdgeInsets.only(top: 47, bottom: 34),
          ),
          child: SantoPageLayout(
            title: '测试',
            scrollable: false,
            children: <Widget>[
              Builder(
                builder: (innerContext) => Text(
                  '${MediaQuery.of(innerContext).padding.bottom}',
                ),
              ),
            ],
          ),
        ),
      ),
    ));

    // 内容拿到的底部安全区 = 系统安全区(34) + bottomInset
    expect(find.text('34.0'), findsOneWidget);
    expect(find.byType(SantoBottomSafeArea), findsNothing);
  });

  testWidgets('PageLayout 非滚动态:滚动内容滚到底避让底部安全区', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            size: const Size(400, 600),
            padding: const EdgeInsets.only(bottom: 34),
          ),
          child: SantoPageLayout(
            scrollable: false,
            children: <Widget>[
              ListView(
                children: List.generate(
                    30, (i) => SizedBox(height: 40, child: Text('item $i'))),
              ),
            ],
          ),
        ),
      ),
    ));

    // 视口铺满页面(不再在底部切出空白占位),仅保留内容区固定的 iGapAllMiddle 内边距
    final screen = tester.getRect(find.byType(Scaffold));
    expect(tester.getRect(find.byType(ListView)).bottom,
        screen.bottom - kContentGap);

    await tester.drag(find.byType(ListView), const Offset(0, -5000));
    await tester.pump();
    expect(tester.getRect(find.text('item 29')).bottom,
        lessThanOrEqualTo(screen.bottom - kContentGap - 34));
  });

  testWidgets('PageLayout 在 AppLayout 中自动预留悬浮菜单栏占位', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SantoAppLayout(
        items: <SantoAppLayoutItem>[
          SantoAppLayoutItem(
            text: '首页',
            page: const SantoPageLayout(
              children: <Widget>[
                Text('页面内容'),
              ]),
          ),
        ],
      ),
    ));

    final scroll = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView));
    // 悬浮栏默认 64 高、AppLayout.gap 12,由尾部安全区组件预留
    expect((scroll.padding as EdgeInsets).bottom, kContentGap);
    expect(tester.getSize(find.byType(SantoBottomSafeArea)).height, 64 + 12);
  });

  testWidgets('PageLayout enableRefresh:内容不满一屏也能下拉触发刷新', (tester) async {
    bool refreshed = false;
    await tester.pumpWidget(MaterialApp(
      home: SantoPageLayout(
        title: '下拉刷新',
        enableRefresh: true,
        onRefresh: () async {
          refreshed = true;
          await Future<void>.delayed(const Duration(milliseconds: 100));
        },
        children: <Widget>[
          SantoSection(
            title: '区块',
            description: '内容不足一屏',
            child: const SizedBox(height: 100, child: Text('内容')),
          ),
        ],
      ),
    ));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, 150));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(refreshed, true, reason: '内容不满一屏时也应能下拉触发刷新');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
  });

  testWidgets('PageLayout enableRefresh:刷新完成后滚动位置归零,二次下拉不抖动', (tester) async {
    int refreshCount = 0;
    await tester.pumpWidget(MaterialApp(
      home: SantoPageLayout(
        title: '下拉刷新',
        enableRefresh: true,
        onRefresh: () async {
          refreshCount++;
          await Future<void>.delayed(const Duration(milliseconds: 100));
        },
        children: <Widget>[
          SantoSection(
            title: '区块',
            description: '内容不足一屏',
            child: const SizedBox(height: 100, child: Text('内容')),
          ),
        ],
      ),
    ));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, 150));
    // 显式推进时钟:刷新回调(100ms) → 完成态(500ms) → 回弹动画
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    final position =
        tester.state<ScrollableState>(find.byType(Scrollable)).position;
    expect(position.pixels, 0,
        reason: '松手回弹后滚动位置必须归零;若残留负值,刷新头会反复弹出(页面一直抖)');
  });

  testWidgets('PageLayout enableRefresh:下拉过程不改变滚动视口高度', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SantoPageLayout(
        title: '下拉刷新',
        enableRefresh: true,
        onRefresh: () async {},
        children: <Widget>[
          SantoSection(
            title: '区块',
            child: const SizedBox(height: 300, child: Text('内容')),
          ),
        ],
      ),
    ));
    await tester.pumpAndSettle();

    final before = tester.getSize(find.byType(Scrollable)).height;
    final gesture = await tester.startGesture(
        tester.getCenter(find.byType(Scrollable)));
    await gesture.moveBy(const Offset(0, 60));
    await tester.pump();
    final during = tester.getSize(find.byType(Scrollable)).height;
    await gesture.up();
    await tester.pumpAndSettle();

    expect(during, before,
        reason: '刷新头应为覆盖式(平移内容),不能每帧挤压列表视口(抖动/内容被压缩的根源)');
  });
}
