import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

void main() {
  testWidgets('SantoSkeleton text theme renders three lines', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: SantoSkeleton(theme: SantoSkeletonTheme.text)),
    ));
    await tester.pump();

    // text 主题:3 行文本条
    final containers = tester.widgetList<Container>(find.byType(Container));
    expect(containers.length, 3);
  });

  testWidgets('SantoSkeleton avatar theme contains circle block',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: SantoSkeleton(theme: SantoSkeletonTheme.avatar)),
    ));
    await tester.pump();

    // 头像块:48x48 的圆形 Container
    final circle = tester.widgetList<Container>(find.byType(Container)).where(
        (c) => (c.decoration as BoxDecoration?)?.borderRadius ==
            BorderRadius.circular(999));
    expect(circle, isNotEmpty);
  });

  testWidgets('SantoSkeleton delay hides content initially', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: SantoSkeleton(theme: SantoSkeletonTheme.text, delay: 500),
      ),
    ));
    await tester.pump();

    // 延迟期内不渲染骨架
    expect(tester.widgetList<Container>(find.byType(Container)), isEmpty);

    // 500ms 后显示
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.widgetList<Container>(find.byType(Container)), isNotEmpty);
  });

  testWidgets('SantoSkeleton fromRowCol renders custom structure',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SantoSkeleton.fromRowCol(
          rowCol: SantoSkeletonRowCol(objects: const [
            [SantoSkeletonRowColObj.rect(width: 48, height: 48)],
          ]),
        ),
      ),
    ));
    await tester.pump();

    expect(find.byType(Container), findsOneWidget);
  });
}
