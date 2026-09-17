import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

/// 主题默认的页面间距 commonConfig.pageGap
const double kPageGap = 12;

void main() {
  testWidgets('PageLayout 用 title 构建导航栏', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: SantoPageLayout(title: '页面标题', child: Text('页面内容')),
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
        child: const Text('页面内容'),
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
          child: const SantoPageLayout(child: Text('页面内容')),
        ),
      ),
    ));

    final scroll = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView));
    expect((scroll.padding as EdgeInsets).top, kPageGap + 47);
  });

  testWidgets('PageLayout 内容可滚动并应用默认 padding', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: SantoPageLayout(child: Text('页面内容')),
    ));

    final scroll = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView));
    expect(scroll.padding, const EdgeInsets.all(kPageGap));
  });

  testWidgets('PageLayout 预留底部安全区域与 bottomInset', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(padding: const EdgeInsets.only(bottom: 34)),
          child: const SantoPageLayout(bottomInset: 8, child: Text('页面内容')),
        ),
      ),
    ));

    final scroll = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView));
    expect((scroll.padding as EdgeInsets).bottom, kPageGap + 34 + 8);
  });

  testWidgets('PageLayout bottomSafeArea 为 false 时不预留安全区域', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(padding: const EdgeInsets.only(bottom: 34)),
          child: const SantoPageLayout(
            bottomSafeArea: false,
            child: Text('页面内容'),
          ),
        ),
      ),
    ));

    final scroll = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView));
    expect((scroll.padding as EdgeInsets).bottom, kPageGap);
  });

  testWidgets('PageLayout scrollable 为 false 时不产生滚动容器', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: SantoPageLayout(scrollable: false, child: Text('页面内容')),
    ));

    expect(find.byType(SingleChildScrollView), findsNothing);
  });

  testWidgets('PageLayout 在 AppLayout 中自动预留悬浮菜单栏占位', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SantoAppLayout(
        items: <SantoAppLayoutItem>[
          SantoAppLayoutItem(
            text: '首页',
            page: const SantoPageLayout(child: Text('页面内容')),
          ),
        ],
      ),
    ));

    final scroll = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView));
    // 悬浮栏默认 64 高、gap 12
    expect((scroll.padding as EdgeInsets).bottom, kPageGap + 64 + 12);
  });
}
