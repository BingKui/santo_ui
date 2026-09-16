import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

Widget _wrap(Widget child) =>
    MaterialApp(home: Scaffold(body: Center(child: child)));

void main() {
  _dockedTests();
  _floatingTests();
  _moreMenuTests();
  _badgeTests();
}

void _dockedTests() {
  testWidgets('SantoBottomTabBar docked renders items and switches',
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

  testWidgets('SantoMenuBar docked has top rounded corners', (tester) async {
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
}

void _floatingTests() {
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

    // 毛玻璃:外层 dock + 内层容器 共两层
    expect(find.byType(BackdropFilter), findsNWidgets(2));

    final barRight = tester.getTopRight(find.byType(ClipRRect)).dx;
    expect(800 - barRight, 12);
  });
}

void _moreMenuTests() {
  testWidgets('SantoMenuBar showMoreMenu appends more tab and opens panel',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: const Center(child: Text('页面内容')),
        bottomNavigationBar: SantoMenuBar(
          showMoreMenu: true,
          moreMenu: SantoMenuBarMoreMenu(
            title: '更多',
            actionText: '编辑',
            items: const [
              SantoMenuBarMoreMenuItem(
                  label: '文档', icon: Icons.description_outlined),
              SantoMenuBarMoreMenuItem(
                  label: '会议', icon: Icons.videocam_outlined),
            ],
          ),
          items: const [
            SantoMenuBarItem(text: '首页'),
            SantoMenuBarItem(text: '我的'),
          ],
        ),
      ),
    ));
    await tester.pump();

    expect(find.text('更多'), findsOneWidget);

    await tester.tap(find.text('更多'));
    await tester.pumpAndSettle();
    expect(find.text('文档'), findsOneWidget);
    expect(find.text('会议'), findsOneWidget);

    await tester.tap(find.text('文档'));
    await tester.pumpAndSettle();
    expect(find.text('文档'), findsNothing);
  });

  testWidgets('SantoMenuBar hides more tab when showMoreMenu is false',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        bottomNavigationBar: SantoMenuBar(
          moreMenu: SantoMenuBarMoreMenu(
            title: '更多',
            items: const [
              SantoMenuBarMoreMenuItem(
                  label: '文档', icon: Icons.description_outlined),
            ],
          ),
          items: const [
            SantoMenuBarItem(text: '首页'),
          ],
        ),
      ),
    ));
    await tester.pump();

    expect(find.text('更多'), findsNothing);
  });
}

void _badgeTests() {
  testWidgets('SantoMenuBar badge shows red dot', (tester) async {
    await tester.pumpWidget(_wrap(SantoMenuBar(
      items: const [
        SantoMenuBarItem(text: '消息', showBadge: true),
      ],
    )));

    expect(find.text('消息'), findsOneWidget);
  });
}
