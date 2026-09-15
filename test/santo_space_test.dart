import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

void main() {
  testWidgets('SantoSpace horizontal inserts gaps between children',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SantoSpace(
          direction: SantoSpaceDirection.horizontal,
          size: SantoSpaceSize.middle,
          children: [
            const Text('A'),
            const Text('B'),
          ],
        ),
      ),
    ));

    final aBottomRight = tester.getBottomRight(find.text('A'));
    final bTopLeft = tester.getTopLeft(find.text('B'));
    // 两个文本之间应有 16px 间距
    expect(bTopLeft.dx - aBottomRight.dx, 16);
  });

  testWidgets('SantoSpace vertical uses height gap', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SantoSpace(
          direction: SantoSpaceDirection.vertical,
          customSize: 32,
          children: [
            const Text('A'),
            const Text('B'),
          ],
        ),
      ),
    ));

    final aBottom = tester.getBottomRight(find.text('A')).dy;
    final bTop = tester.getTopLeft(find.text('B')).dy;
    expect(bTop - aBottom, 32);
  });

  testWidgets('SantoSpace.gap renders fixed spacer', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            const Text('A'),
            const SantoSpace.gap(24, direction: SantoSpaceDirection.vertical),
            const Text('B'),
          ],
        ),
      ),
    ));

    final aBottom = tester.getBottomRight(find.text('A')).dy;
    final bTop = tester.getTopLeft(find.text('B')).dy;
    expect(bTop - aBottom, 24);
  });

  testWidgets('SantoSpace wrap lays out overflowing children', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 200,
          child: SantoSpace(
            wrap: true,
            customSize: 10,
            children: List.generate(
                6, (i) => Container(width: 60, height: 20, color: Colors.blue)),
          ),
        ),
      ),
    ));

    // 200 宽度一行只能放 3 个(60*3 + 10*2),应有 2 行
    expect(tester.getSize(find.byType(Wrap)).height, greaterThan(20));
  });
}
