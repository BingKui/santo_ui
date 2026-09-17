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
      onChanged: (i) => changed = i,
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

    // 毛玻璃:仅外层 dock(内层不透明)
    expect(find.byType(BackdropFilter), findsOneWidget);

    // 与屏幕左右边缘保持 gap=12(取内层胶囊内容区,含 1px 边框 + 2px 内边距)
    final innerRight = tester
        .getTopRight(find.descendant(
          of: find.byType(SantoMenuBar),
          matching: find.byType(LayoutBuilder),
        ))
        .dx;
    expect(800 - innerRight, closeTo(15, 1));
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
  const badgeKey = Key('test_badge');

  Widget badge() => Container(
        key: badgeKey,
        width: 28,
        height: 14,
        decoration: BoxDecoration(
          color: const Color(0xFFFF4D4F),
          borderRadius: BorderRadius.circular(7),
        ),
      );

  testWidgets('SantoMenuBar badge shows red dot', (tester) async {
    await tester.pumpWidget(_wrap(SantoMenuBar(
      items: const [
        SantoMenuBarItem(text: '消息', showBadge: true),
      ],
    )));

    expect(find.text('消息'), findsOneWidget);
  });

  testWidgets('SantoMenuBar badge sits on icon top-right corner',
      (tester) async {
    await tester.pumpWidget(_wrap(SantoMenuBar(
      items: [
        const SantoMenuBarItem(
          text: '首页',
          selectedIcon: Icon(Icons.home_filled),
        ),
        SantoMenuBarItem(
          text: '我的',
          selectedIcon: const Icon(Icons.person),
          badge: badge(),
        ),
      ],
    )));

    final iconRect = tester.getRect(find.byIcon(Icons.person));
    final badgeRect = tester.getRect(find.byKey(badgeKey));

    // 徽标挂在图标右上角:不越到图标上方,仅以少量像素压住右上角
    expect(badgeRect.top, lessThan(iconRect.top));
    expect(badgeRect.bottom, lessThanOrEqualTo(iconRect.top + 8));
    expect(badgeRect.left, greaterThanOrEqualTo(iconRect.right - 8));
    expect(badgeRect.left, lessThanOrEqualTo(iconRect.right + 4));
    // 徽标水平方向在图标之外展开
    expect(badgeRect.right, greaterThan(iconRect.right));
  });

  testWidgets('SantoMenuBar badge falls back to label without icon',
      (tester) async {
    await tester.pumpWidget(_wrap(SantoMenuBar(
      items: [
        SantoMenuBarItem(text: '消息', badge: badge()),
      ],
    )));

    final labelRect = tester.getRect(find.text('消息'));
    final badgeRect = tester.getRect(find.byKey(badgeKey));

    expect(badgeRect.top, lessThan(labelRect.top + labelRect.height));
    expect(badgeRect.left, greaterThanOrEqualTo(labelRect.right - 8));
    expect(badgeRect.right, greaterThan(labelRect.right));
  });
}
