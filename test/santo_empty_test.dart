import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

void main() {
  testWidgets('SantoEmpty 设置 height 后在指定高度内垂直居中', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SantoPanel(
            title: '空状态',
            child: SantoEmpty(
              height: 200,
              topOffset: 80,
              img: const SizedBox(
                key: ValueKey('empty-image'),
                width: 40,
                height: 40,
              ),
            ),
          ),
        ),
      ),
    );

    final emptyRect = tester.getRect(find.byType(SantoEmpty));
    final imageRect = tester.getRect(find.byKey(const ValueKey('empty-image')));

    expect(emptyRect.height, 200);
    expect(imageRect.center.dy, closeTo(emptyRect.center.dy, 0.01));
  });
}
