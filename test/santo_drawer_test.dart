import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

void main() {
  Future<EdgeInsets> openDrawerAndReadPadding(
    WidgetTester tester,
    SantoDrawerDirection direction,
  ) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(400, 800);
    tester.view.padding =
        const FakeViewPadding(left: 0, top: 44, right: 0, bottom: 34);
    addTearDown(tester.view.reset);

    EdgeInsets? seen;
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => Center(
          child: TextButton(
            onPressed: () => SantoDrawer.show<void>(
              context: context,
              direction: direction,
              child: Builder(
                builder: (context) {
                  seen = MediaQuery.of(context).padding;
                  return const SizedBox(width: 10, height: 10);
                },
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return seen!;
  }

  testWidgets('左右抽屉内容区上下安全区都保留', (tester) async {
    expect(
      await openDrawerAndReadPadding(tester, SantoDrawerDirection.right),
      const EdgeInsets.only(top: 44, bottom: 34),
    );
  });

  testWidgets('顶部抽屉内容区只保留顶部安全区', (tester) async {
    expect(
      await openDrawerAndReadPadding(tester, SantoDrawerDirection.top),
      const EdgeInsets.only(top: 44),
    );
  });

  testWidgets('底部抽屉内容区只保留底部安全区', (tester) async {
    expect(
      await openDrawerAndReadPadding(tester, SantoDrawerDirection.bottom),
      const EdgeInsets.only(bottom: 34),
    );
  });

  Future<double> openDrawerAndReadWidth(
    WidgetTester tester,
    double width,
  ) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(400, 800);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => Center(
          child: TextButton(
            onPressed: () => SantoDrawer.show<void>(
              context: context,
              direction: SantoDrawerDirection.right,
              width: width,
              child: const SizedBox.expand(
                key: ValueKey<String>('drawer-body'),
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return tester
        .getSize(find.byKey(const ValueKey<String>('drawer-body')))
        .width;
  }

  testWidgets('宽度超过屏幕 95% 时收敛到上限', (tester) async {
    // 屏幕宽 400,上限 380
    expect(await openDrawerAndReadWidth(tester, 500), 380);
  });

  testWidgets('宽度未超上限时保持原值', (tester) async {
    expect(await openDrawerAndReadWidth(tester, 200), 200);
  });

  testWidgets('底部抽屉内 ListView 自动消费安全区,不额外加空白块', (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(400, 800);
    tester.view.padding =
        const FakeViewPadding(left: 0, top: 44, right: 0, bottom: 34);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => Center(
          child: TextButton(
            onPressed: () => SantoDrawer.show<void>(
              context: context,
              direction: SantoDrawerDirection.bottom,
              height: 400,
              child: Container(
                color: Colors.white,
                // 不传 padding:列表把抽屉改写后的底部安全区
                // 消费为自身滚动内边距
                child: ListView(
                  children: [for (int i = 1; i <= 40; i++) Text('item $i')],
                ),
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // 滚动区铺满到屏幕底部:安全区内是列表滚动区,不是额外空白块
    expect(tester.getRect(find.byType(Scrollable)).bottom, 800);

    // 滚到底,最后一项停在底部安全区之上(800 - 34)
    final ScrollableState scrollable =
        tester.state<ScrollableState>(find.byType(Scrollable));
    scrollable.position.jumpTo(scrollable.position.maxScrollExtent);
    await tester.pump();
    expect(tester.getRect(find.text('item 40')).bottom, 766);
  });
}
