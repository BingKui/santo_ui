import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('SantoSwipeCell opens right panel on left drag', (tester) async {
    await tester.pumpWidget(_wrap(SantoSwipeCell(
      right: SantoSwipeCellPanel(
        extentRatio: 0.3,
        actions: [
          SantoSwipeCellAction(
            label: '删除',
            backgroundColor: Colors.red,
            onPressed: () {},
          ),
        ],
      ),
      cell: const Text('列表项'),
    )));

    await tester.drag(find.text('列表项'), const Offset(-200, 0));
    await tester.pumpAndSettle();

    // 操作按钮可见
    expect(find.text('删除'), findsOneWidget);
    // 内容左移 0.3 * 宽度
    final offset = tester.getTopLeft(find.text('列表项')).dx;
    expect(offset, lessThan(-40));
  });

  testWidgets('SantoSwipeCell action onPressed works', (tester) async {
    var pressed = false;
    await tester.pumpWidget(_wrap(SantoSwipeCell(
      right: SantoSwipeCellPanel(
        extentRatio: 0.4,
        actions: [
          SantoSwipeCellAction(
            label: '删除',
            backgroundColor: Colors.red,
            onPressed: () => pressed = true,
          ),
        ],
      ),
      cell: const Text('列表项'),
    )));

    await tester.drag(find.text('列表项'), const Offset(-300, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除'));
    expect(pressed, isTrue);
  });

  testWidgets('SantoSwipeCell group closes others when one opens',
      (tester) async {
    await tester.pumpWidget(_wrap(Column(
      children: [
        SantoSwipeCell(
          groupTag: 'g1',
          right: SantoSwipeCellPanel(
            extentRatio: 0.3,
            actions: [SantoSwipeCellAction(label: 'A1', onPressed: () {})],
          ),
          cell: const Text('第一行'),
        ),
        SantoSwipeCell(
          groupTag: 'g1',
          right: SantoSwipeCellPanel(
            extentRatio: 0.3,
            actions: [SantoSwipeCellAction(label: 'A2', onPressed: () {})],
          ),
          cell: const Text('第二行'),
        ),
      ],
    )));

    await tester.drag(find.text('第一行'), const Offset(-200, 0));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.text('第一行')).dx, lessThan(0));

    // 打开第二行,第一行应自动关闭
    await tester.drag(find.text('第二行'), const Offset(-200, 0));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.text('第一行')).dx, 0);
    expect(tester.getTopLeft(find.text('第二行')).dx, lessThan(0));
  });

  testWidgets('SantoSwipeCell disabled ignores drag', (tester) async {
    await tester.pumpWidget(_wrap(SantoSwipeCell(
      disabled: true,
      right: SantoSwipeCellPanel(
        extentRatio: 0.3,
        actions: [SantoSwipeCellAction(label: '删除', onPressed: () {})],
      ),
      cell: const Text('列表项'),
    )));

    await tester.drag(find.text('列表项'), const Offset(-200, 0));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.text('列表项')).dx, 0);
  });
}
