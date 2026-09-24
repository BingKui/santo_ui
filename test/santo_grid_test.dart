import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

Widget _wrap(Widget child, {double width = 480}) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: SizedBox(width: width, child: child),
      ),
    ),
  );
}

// 480 宽 / 24 栅格 = 每格 20
void main() {
  testWidgets('span 12 两列等分,内容宽度各 240 减列间距', (tester) async {
    await tester.pumpWidget(_wrap(SantoRow(
      gutter: 15,
      children: const [
        SantoCol(span: 12, child: SizedBox(key: Key('a'))),
        SantoCol(span: 12, child: SizedBox(key: Key('b'))),
      ],
    )));

    final Rect row = tester.getRect(find.byType(SantoRow));
    final Rect a = tester.getRect(find.byKey(const Key('a')));
    final Rect b = tester.getRect(find.byKey(const Key('b')));
    // 首列无左内边距、末列无右内边距,中间列间距 = gutter
    expect(a.left, row.left);
    expect(b.right, row.right);
    expect(b.left - a.right, 15);
    expect(a.width, 240 - 7.5);
  });

  testWidgets('span 超出 24 自动换行,verticalGutter 控制行间距', (tester) async {
    await tester.pumpWidget(_wrap(SantoRow(
      gutter: 10,
      verticalGutter: 20,
      children: const [
        SantoCol(span: 12, child: SizedBox(key: Key('a'), height: 30)),
        SantoCol(span: 12, child: SizedBox(key: Key('b'), height: 30)),
        SantoCol(span: 8, child: SizedBox(key: Key('c'), height: 30)),
      ],
    )));

    final Rect a = tester.getRect(find.byKey(const Key('a')));
    final Rect b = tester.getRect(find.byKey(const Key('b')));
    final Rect c = tester.getRect(find.byKey(const Key('c')));
    expect(a.top, b.top);
    expect(c.top, greaterThan(b.top));
    // a、b 高 30,行间距 20
    expect(c.top - a.bottom, 20);
  });

  testWidgets('offset 右移对应栅格数', (tester) async {
    await tester.pumpWidget(_wrap(SantoRow(
      children: const [
        SantoCol(span: 8, offset: 8, child: SizedBox(key: Key('a'))),
      ],
    )));

    // offset 8 格 = 160
    final Rect row = tester.getRect(find.byType(SantoRow));
    expect(tester.getRect(find.byKey(const Key('a'))).left - row.left, 160);
  });

  testWidgets('order 改变渲染顺序,相同 order 保持声明顺序', (tester) async {
    await tester.pumpWidget(_wrap(SantoRow(
      children: const [
        SantoCol(span: 8, order: 3, child: SizedBox(key: Key('a'), height: 30)),
        SantoCol(span: 8, order: 1, child: SizedBox(key: Key('b'), height: 30)),
        SantoCol(span: 8, order: 2, child: SizedBox(key: Key('c'), height: 30)),
      ],
    )));

    final double left = tester.getRect(find.byType(SantoRow)).left;
    expect(tester.getRect(find.byKey(const Key('b'))).left - left, 0);
    expect(tester.getRect(find.byKey(const Key('c'))).left - left, 160);
    expect(tester.getRect(find.byKey(const Key('a'))).left - left, 320);
  });

  testWidgets('span 0 不渲染', (tester) async {
    await tester.pumpWidget(_wrap(SantoRow(
      children: const [
        SantoCol(span: 8, child: SizedBox(key: Key('a'))),
        SantoCol(span: 0, child: SizedBox(key: Key('b'))),
        SantoCol(span: 8, child: SizedBox(key: Key('c'))),
      ],
    )));

    expect(find.byKey(const Key('b')), findsNothing);
    final Rect row = tester.getRect(find.byType(SantoRow));
    expect(tester.getRect(find.byKey(const Key('c'))).left - row.left, 160);
  });

  testWidgets('flex 列按 Expanded 分配,与固定 span 列混排', (tester) async {
    await tester.pumpWidget(_wrap(SantoRow(
      children: const [
        SantoCol(flex: 1, child: SizedBox(key: Key('a'))),
        SantoCol(span: 8, child: SizedBox(key: Key('b'))),
      ],
    )));

    // 固定列 160,剩余 320 给 flex 列
    expect(tester.getRect(find.byKey(const Key('a'))).width, 320);
    expect(tester.getRect(find.byKey(const Key('b'))).width, 160);
  });

  testWidgets('push/pull 产生视觉位移', (tester) async {
    await tester.pumpWidget(_wrap(SantoRow(
      children: const [
        SantoCol(span: 12, push: 2, child: SizedBox(key: Key('a'), height: 30)),
      ],
    )));

    final Transform transform =
        tester.widget<Transform>(find.byType(Transform).first);
    expect(transform.transform.getTranslation().x, 40); // 2 格 = 40
  });

  testWidgets('justify spaceBetween 两端对齐', (tester) async {
    await tester.pumpWidget(_wrap(SantoRow(
      justify: MainAxisAlignment.spaceBetween,
      children: const [
        SantoCol(span: 6, child: SizedBox(key: Key('a'), height: 30)),
        SantoCol(span: 6, child: SizedBox(key: Key('b'), height: 30)),
      ],
    )));

    final Rect row = tester.getRect(find.byType(SantoRow));
    expect(tester.getRect(find.byKey(const Key('a'))).left, row.left);
    expect(tester.getRect(find.byKey(const Key('b'))).right, row.right);
  });

  testWidgets('align middle 垂直居中', (tester) async {
    await tester.pumpWidget(_wrap(SantoRow(
      align: CrossAxisAlignment.center,
      children: const [
        SantoCol(span: 12, child: SizedBox(key: Key('a'), height: 60)),
        SantoCol(span: 12, child: SizedBox(key: Key('b'), height: 30)),
      ],
    )));

    final Rect a = tester.getRect(find.byKey(const Key('a')));
    final Rect b = tester.getRect(find.byKey(const Key('b')));
    expect(b.center.dy, a.center.dy);
  });
}
