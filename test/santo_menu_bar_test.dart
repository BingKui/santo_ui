import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

Widget _wrap(Widget child) =>
    MaterialApp(home: Scaffold(body: Center(child: child)));

void main() {
  testWidgets('SantoMenuBar docked renders items and switches',
      (tester) async {
    var changed = -1;
    await tester.pumpWidget(_wrap(SantoMenuBar(
      onChange: (i) => changed = i,
      items: const [
        SantoMenuBarItem(text: '首页'),
        SantoMenuBarItem(text: '我的'),
      ],
    )));

    expect(find.text('首页'), findsOneWidget);
    expect(find.text('我的'), findsOneWidget);

    await tester.tap(find.text('我的'));
    await tester.pumpAndSettle();
    expect(changed, 1);
  });

  testWidgets('SantoMenuBar docked has top rounded corners',
      (tester) async {
    await tester.pumpWidget(_wrap(SantoMenuBar(
      items: const [SantoMenuBarItem(text: '首页')],
    )));

    final container = tester.widget<Container>(
        find.ancestor(of: find.text('首页'), matching: find.byType(Container)));
    final decoration = container.decoration as BoxDecoration;
    final radius = decoration.borderRadius as BorderRadius;
    expect(radius.topLeft.x, 12);
    expect(radius.topRight.x, 12);
    expect(radius.bottomLeft.x, 0);
  });

  testWidgets('SantoMenuBar floating uses frosted container with gap',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SantoMenuBar(
                style: SantoMenuBarStyle.floating,
                gap: 12,
                items: const [
                  SantoMenuBarItem(text: '首页'),
                  SantoMenuBarItem(text: '我的'),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
    await tester.pumpAndSettle();

    // 毛玻璃
    expect(find.byType(BackdropFilter), findsOneWidget);

    // 与屏幕左右边缘保持 gap=12
    final barRight = tester.getTopRight(find.byType(ClipRRect)).dx;
    expect(800 - barRight, 12);
  });

  testWidgets('SantoMenuBar badge shows red dot', (tester) async {
    await tester.pumpWidget(_wrap(SantoMenuBar(
      items: const [
        SantoMenuBarItem(text: '消息', showBadge: true),
      ],
    )));

    expect(find.text('消息'), findsOneWidget);
  });
}
