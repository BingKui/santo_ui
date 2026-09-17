import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

Widget _host(Widget child, {double height = 400}) => MaterialApp(
      home: Scaffold(
        body: SizedBox(height: height, child: child),
      ),
    );

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

void main() {
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

    await tester.pumpAndSettle();
    expect(states, contains(SantoRefreshState.done));
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
