import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

void main() {
  testWidgets('SantoMasonry lays out items in shortest column', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 216,
          child: SantoMasonry(
            columns: 2,
            gutter: 16,
            verticalGutter: 16,
            items: [
              Container(key: const ValueKey('a'), height: 100),
              Container(key: const ValueKey('b'), height: 50),
              Container(key: const ValueKey('c'), height: 10),
            ],
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    final a = tester.getTopLeft(find.byKey(const ValueKey('a')));
    final b = tester.getTopLeft(find.byKey(const ValueKey('b')));
    final c = tester.getTopLeft(find.byKey(const ValueKey('c')));

    // item a 进第一列, item b 进第二列, item c 进最短的第二列(b 高 50)
    expect(a, Offset.zero);
    expect(b.dx, greaterThan(a.dx)); // 第二列
    expect(c.dx, b.dx); // 跟 b 同列
    expect(c.dy, 50 + 16); // 在 b 下方,间隔垂直 gutter
  });

  testWidgets('SantoMasonry sizes to max column height', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 216,
          child: SantoMasonry(
            columns: 2,
            gutter: 16,
            verticalGutter: 16,
            items: [
              Container(height: 100),
              Container(height: 50),
            ],
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    // 高度应为最高列 100(尾部不包含 gutter)
    expect(tester.getSize(find.byType(SantoMasonry)).height, 100);
  });
}
