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
}
