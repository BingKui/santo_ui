import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

void main() {
  testWidgets('键盘弹起时弹窗整体上移到键盘上方', (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(400, 800);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: TextButton(
              onPressed: () {
                SantoBottomDrawer.show<void>(
                  context: context,
                  child: const SizedBox(
                    key: ValueKey<String>('sheet-content'),
                    height: 120,
                    child: TextField(),
                  ),
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    final double beforeBottom =
        tester.getRect(find.byKey(const ValueKey<String>('sheet-content'))).bottom;
    // 弹窗默认 contentPadding 20
    expect(beforeBottom, 780);

    // 模拟键盘弹起
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pumpAndSettle();

    final double afterBottom =
        tester.getRect(find.byKey(const ValueKey<String>('sheet-content'))).bottom;
    debugPrint('弹窗内容底 $beforeBottom -> 键盘弹起后 $afterBottom');
    expect(afterBottom, closeTo(780 - 300, 0.5));

    tester.view.resetViewInsets();
  });

  testWidgets('评价弹窗键盘弹起后不被遮挡', (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(400, 800);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: TextButton(
              onPressed: () {
                SantoAppraiseBottomPicker.show<void>(
                  context: context,
                  title: '评价',
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pumpAndSettle();

    final Rect input = tester.getRect(find.byType(SantoInputText));
    debugPrint('评价弹窗内输入框底部 ${input.bottom}');
    expect(input.bottom, lessThanOrEqualTo(500));
    expect(tester.takeException(), isNull);

    tester.view.resetViewInsets();
  });
}
