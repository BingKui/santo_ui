import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

Widget _host(Widget child, {double height = 400, bool bouncing = false}) =>
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          height: height,
          child: bouncing
              ? ScrollConfiguration(
                  behavior: const _BouncingBehavior(),
                  child: child,
                )
              : child,
        ),
      ),
    );

/// 强制 Bouncing 物理,复现 iOS 松手回弹路径
class _BouncingBehavior extends ScrollBehavior {
  const _BouncingBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics();
}

List<Widget> _items(int count) => List.generate(
      count,
      (index) => SizedBox(height: 48, child: Text('item $index')),
    );

/// 下拉到指定距离并松手
Future<void> _pullDown(WidgetTester tester, double distance) async {
  final gesture =
      await tester.startGesture(tester.getCenter(find.byType(ListView)));
  await gesture.moveBy(Offset(0, distance));
  await tester.pump();
  await gesture.up();
  await tester.pump();
}

/// 头部覆盖层高度:0 表示头部已收起(未构建)
double? _refreshHeaderHeight(WidgetTester tester) {
  for (final Positioned positioned in tester.widgetList<Positioned>(
    find.descendant(
      of: find.byType(SantoRefresh),
      matching: find.byType(Positioned),
    ),
  )) {
    if (positioned.height != null) {
      return positioned.height;
    }
  }
  return null;
}

void main() {
  testWidgets('下拉刷新头部背景透明', (tester) async {
    await tester.pumpWidget(_host(SantoRefresh(
      onRefresh: () async {},
      child: ListView(children: _items(10)),
    )));

    // 下拉但不松手,让头部保持展示
    final gesture =
        await tester.startGesture(tester.getCenter(find.byType(ListView)));
    await gesture.moveBy(const Offset(0, 40));
    await tester.pump();

    final Container header = tester
        .widgetList<Container>(find.byType(Container))
        .firstWhere((Container container) =>
            container.constraints?.maxHeight == 40);
    expect(header.decoration, isNull, reason: '刷新区域不应有背景色,保持透明');

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('拖拽过程中头部高度跟随下拉距离', (tester) async {
    await tester.pumpWidget(_host(SantoRefresh(
      onRefresh: () async {},
      child: ListView(children: _items(10)),
    )));

    final gesture =
        await tester.startGesture(tester.getCenter(find.byType(ListView)));
    await gesture.moveBy(const Offset(0, 40));
    await tester.pump();

    // 头部高度 = 下拉距离(40 未达触发阈值,仍是拉动态)
    final List<double> heights = tester
        .widgetList<Container>(find.byType(Container))
        .map((Container container) => container.constraints?.maxHeight)
        .whereType<double>()
        .toList();
    expect(heights, contains(40));

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('下拉松手触发刷新并走完四态', (tester) async {
    final List<SantoRefreshState> states = <SantoRefreshState>[];
    int refreshCount = 0;

    await tester.pumpWidget(_host(SantoRefresh(
      onRefresh: () async {
        refreshCount++;
        await Future<void>.delayed(const Duration(milliseconds: 50));
      },
      successDuration: const Duration(milliseconds: 50),
      onStateChanged: states.add,
      child: ListView(children: _items(30)),
    )));

    await _pullDown(tester, 90);
    await tester.pump(const Duration(milliseconds: 10));
    expect(refreshCount, 1);
    expect(states, contains(SantoRefreshState.ready));
    expect(states, contains(SantoRefreshState.refreshing));

    // 回调(50ms)结束后进入完成态,展示成功图标(完成态窗口 successDuration 50ms)
    await tester.pump(const Duration(milliseconds: 60));
    expect(states, contains(SantoRefreshState.done));
    final SantoIcon doneIcon = tester.widget<SantoIcon>(
      find.descendant(
        of: find.byType(SantoRefresh),
        matching: find.byType(SantoIcon),
      ),
    );
    expect(doneIcon.name, SantoIcons.checkCircle,
        reason: '刷新完成态应展示成功图标');

    await tester.pumpAndSettle();
    expect(states.last, SantoRefreshState.inactive);
  });

  testWidgets('下拉距离不足时不触发刷新', (tester) async {
    int refreshCount = 0;
    await tester.pumpWidget(_host(SantoRefresh(
      onRefresh: () async {
        refreshCount++;
      },
      child: ListView(children: _items(30)),
    )));

    await _pullDown(tester, 20);
    await tester.pumpAndSettle();
    expect(refreshCount, 0);
  });

  testWidgets('Bouncing 回弹:松手后收缩到刷新高度并保持,完成后归零', (tester) async {
    final Completer<void> refresh = Completer<void>();
    await tester.pumpWidget(_host(
      SantoRefresh(
        onRefresh: () => refresh.future,
        successDuration: const Duration(milliseconds: 50),
        child: ListView(children: _items(30)),
      ),
      bouncing: true,
    ));

    final gesture =
        await tester.startGesture(tester.getCenter(find.byType(ListView)));
    await gesture.moveBy(const Offset(0, 90));
    await tester.pump(const Duration(milliseconds: 50));
    expect(_refreshHeaderHeight(tester), 80,
        reason: '下拉距离被钳制在 maxBarHeight');

    await gesture.up();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(
      _refreshHeaderHeight(tester),
      allOf(greaterThanOrEqualTo(50), lessThanOrEqualTo(80)),
      reason: '松手后高度应收缩到刷新高度(50)停下,不能先全部收完再弹出 Loading 区',
    );

    // 回弹与收缩动画结束后,刷新期间头部稳定停在刷新高度
    await tester.pump(const Duration(milliseconds: 400));
    expect(_refreshHeaderHeight(tester), 50);

    refresh.complete();
    await tester.pump();
    // successDuration(50ms)到点,收起动画(200ms)启动
    await tester.pump(const Duration(milliseconds: 50));
    // 收起动画进行中:头部尚未关完,成功态必须保持
    await tester.pump(const Duration(milliseconds: 60));
    final SantoIcon collapsingIcon = tester.widget<SantoIcon>(
      find.descendant(
        of: find.byType(SantoRefresh),
        matching: find.byType(SantoIcon),
      ),
    );
    expect(collapsingIcon.name, SantoIcons.checkCircle,
        reason: '成功图标/文案应保持到头部完全关闭');
    expect(_refreshHeaderHeight(tester), allOf(greaterThan(0), lessThan(50)));

    await tester.pumpAndSettle();
    expect(_refreshHeaderHeight(tester), isNull, reason: '刷新完成后高度收到 0');
  });

  testWidgets('Bouncing 回弹:未达阈值松手跟随回弹收起,不触发刷新', (tester) async {
    int refreshCount = 0;
    await tester.pumpWidget(_host(
      SantoRefresh(
        onRefresh: () async {
          refreshCount++;
        },
        child: ListView(children: _items(30)),
      ),
      bouncing: true,
    ));

    await _pullDown(tester, 20);
    await tester.pumpAndSettle();
    expect(refreshCount, 0);
    expect(_refreshHeaderHeight(tester), isNull);
  });

  testWidgets('controller.refresh() 可从外部触发刷新', (tester) async {
    final controller = SantoRefreshController();
    int refreshCount = 0;

    await tester.pumpWidget(_host(SantoRefresh(
      controller: controller,
      onRefresh: () async {
        refreshCount++;
        await Future<void>.delayed(const Duration(milliseconds: 50));
      },
      child: ListView(children: _items(30)),
    )));

    unawaited(controller.refresh());
    await tester.pump(const Duration(milliseconds: 10));
    expect(refreshCount, 1);
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));
  });

  testWidgets('刷新超时上报 timeout 并自动复位', (tester) async {
    final controller = SantoRefreshController();
    final List<SantoRefreshState> states = <SantoRefreshState>[];

    await tester.pumpWidget(_host(SantoRefresh(
      controller: controller,
      refreshTimeout: const Duration(milliseconds: 80),
      successDuration: const Duration(milliseconds: 20),
      onRefresh: () async {
        await Future<void>.delayed(const Duration(milliseconds: 300));
      },
      onStateChanged: states.add,
      child: ListView(children: _items(30)),
    )));

    unawaited(controller.refresh());
    await tester.pump();
    expect(states, contains(SantoRefreshState.refreshing));

    // 超过 80ms 仍未完成 → 上报 timeout
    await tester.pump(const Duration(milliseconds: 100));
    expect(states, contains(SantoRefreshState.timeout));

    // 完成态与复位
    await tester.pump(const Duration(milliseconds: 40));
    expect(states, contains(SantoRefreshState.done));
    await tester.pump(const Duration(milliseconds: 300));
    expect(states.last, SantoRefreshState.inactive);
    await tester.pump(const Duration(milliseconds: 300));
  });

  testWidgets('滚动到底触发 onLoadMore,没有更多时不再触发', (tester) async {
    int loadMoreCount = 0;
    bool hasMore = true;

    await tester.pumpWidget(_host(SantoRefresh(
      hasMore: hasMore,
      onLoadMore: () async {
        loadMoreCount++;
      },
      child: ListView(children: _items(60)),
    )));

    await tester.drag(find.byType(ListView), const Offset(0, -5000));
    await tester.pumpAndSettle();
    expect(loadMoreCount, 1);

    hasMore = false;
    await tester.pumpWidget(_host(SantoRefresh(
      hasMore: hasMore,
      onLoadMore: () async {
        loadMoreCount++;
      },
      child: ListView(children: _items(60)),
    )));
    await tester.drag(find.byType(ListView), const Offset(0, -5000));
    await tester.pumpAndSettle();
    expect(loadMoreCount, 1);
    expect(find.text('没有更多数据了'), findsOneWidget);
  });
}
