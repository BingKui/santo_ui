import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

Widget _wrap(Widget child, {double width = 600}) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: SizedBox(width: width, child: child),
      ),
    ),
  );
}

void main() {
  testWidgets('默认水平排列,gapSize middle 间距为 15', (tester) async {
    await tester.pumpWidget(_wrap(
      SantoFlex(
        gapSize: SantoSpaceSize.middle,
        children: const [
          SizedBox(key: Key('a'), width: 100, height: 40),
          SizedBox(key: Key('b'), width: 100, height: 40),
        ],
      ),
    ));

    final Rect a = tester.getRect(find.byKey(const Key('a')));
    final Rect b = tester.getRect(find.byKey(const Key('b')));
    expect(a.top, b.top);
    expect(b.left - a.right, 15);
  });

  testWidgets('gap 自定义值优先于 gapSize', (tester) async {
    await tester.pumpWidget(_wrap(
      SantoFlex(
        gapSize: SantoSpaceSize.middle,
        gap: 30,
        children: const [
          SizedBox(key: Key('a'), width: 100, height: 40),
          SizedBox(key: Key('b'), width: 100, height: 40),
        ],
      ),
    ));

    final Rect a = tester.getRect(find.byKey(const Key('a')));
    final Rect b = tester.getRect(find.byKey(const Key('b')));
    expect(b.left - a.right, 30);
  });

  testWidgets('垂直方向默认 stretch,子元素宽度拉满', (tester) async {
    await tester.pumpWidget(_wrap(
      SantoFlex(
        orientation: SantoFlexOrientation.vertical,
        gapSize: SantoSpaceSize.small,
        children: const [
          SizedBox(key: Key('a'), height: 40),
          SizedBox(key: Key('b'), height: 40),
        ],
      ),
    ));

    final Rect a = tester.getRect(find.byKey(const Key('a')));
    final Rect b = tester.getRect(find.byKey(const Key('b')));
    expect(a.width, tester.getRect(find.byType(SantoFlex)).width);
    expect(b.width, a.width);
    expect(b.top - a.bottom, 10);
  });

  testWidgets('水平方向默认向上对齐(start)', (tester) async {
    await tester.pumpWidget(_wrap(
      SizedBox(
        height: 120,
        child: SantoFlex(
          children: const [
            SizedBox(key: Key('a'), width: 100, height: 40),
            SizedBox(key: Key('b'), width: 100, height: 80),
          ],
        ),
      ),
    ));

    expect(tester.getRect(find.byKey(const Key('a'))).top,
        tester.getRect(find.byKey(const Key('b'))).top);
  });

  testWidgets('justify spaceBetween 两端对齐', (tester) async {
    await tester.pumpWidget(_wrap(
      SantoFlex(
        justify: MainAxisAlignment.spaceBetween,
        children: const [
          SizedBox(key: Key('a'), width: 100, height: 40),
          SizedBox(key: Key('b'), width: 100, height: 40),
        ],
      ),
    ));

    final Rect flex = tester.getRect(find.byType(SantoFlex));
    final Rect a = tester.getRect(find.byKey(const Key('a')));
    final Rect b = tester.getRect(find.byKey(const Key('b')));
    expect(a.left, flex.left);
    expect(b.right, flex.right);
  });

  testWidgets('wrap 时渲染 Wrap,间距作用于横纵两个方向', (tester) async {
    await tester.pumpWidget(_wrap(
      SantoFlex(
        wrap: true,
        gap: 12,
        children: List.generate(
          8,
          (i) => SizedBox(key: Key('c$i'), width: 100, height: 40),
        ),
      ),
    ));

    expect(find.byType(Wrap), findsOneWidget);
    // 600 宽、100 宽子项 + 12 间距,每行 5 个
    final Rect c0 = tester.getRect(find.byKey(const Key('c0')));
    final Rect c5 = tester.getRect(find.byKey(const Key('c5')));
    expect(c5.top - c0.bottom, 12);
  });

  testWidgets('flex 为每个子元素包 Expanded 等分', (tester) async {
    await tester.pumpWidget(_wrap(
      SantoFlex(
        flex: 1,
        gap: 10,
        children: const [
          SizedBox(key: Key('a'), height: 40),
          SizedBox(key: Key('b'), height: 40),
        ],
      ),
    ));

    final Rect a = tester.getRect(find.byKey(const Key('a')));
    final Rect b = tester.getRect(find.byKey(const Key('b')));
    expect(a.width, b.width);
    expect(a.width, (600 - 10) / 2);
  });
}
