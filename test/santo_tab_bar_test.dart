import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

Widget _host(Widget child, {double? width}) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: width == null
            ? child
            : SizedBox(width: width, child: child),
      ),
    ),
  );
}

List<BadgeTab> _tabs(int count) =>
    List<BadgeTab>.generate(count, (i) => BadgeTab(text: '业务${i + 1}'));

/// tab 项的圆角底色层
Finder tabBackground() => find.byWidgetPredicate((w) =>
    w is DecoratedBox &&
    w.decoration is BoxDecoration &&
    (w.decoration as BoxDecoration).borderRadius ==
        BorderRadius.circular(12));

void main() {
  testWidgets('SantoTabBar 在窄容器内按可用宽度均分 tab，不溢出',
      (tester) async {
    const double width = 320;
    await tester.pumpWidget(_host(
      SantoTabBar(
        controller: TabController(length: 4, vsync: const TestVSync()),
        tabs: _tabs(4),
      ),
      width: width,
    ));

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(TabBar)).width, width);
  });

  testWidgets('SantoTabBar showMore 在窄容器内不溢出', (tester) async {
    await tester.pumpWidget(_host(
      SantoTabBar(
        controller: TabController(length: 5, vsync: const TestVSync()),
        tabs: _tabs(5),
        showMore: true,
        moreWindowText: 'Tabs描述',
      ),
      width: 320,
    ));

    expect(tester.takeException(), isNull);
  });

  testWidgets('SantoTabBar 未选中项无底色，选中项圆角底色铺满整个 tab 单元格',
      (tester) async {
    final controller = TabController(length: 3, vsync: const TestVSync());
    await tester.pumpWidget(_host(
      SantoTabBar(controller: controller, tabs: _tabs(3)),
      width: 320,
    ));

    final Color brand = SantoThemeConfigurator.instance
        .getConfig()
        .commonConfig
        .brandPrimary;
    final Color selectedBg = brand.withAlpha(0x14);
    final Color transparentBg = brand.withAlpha(0);

    Color cellColorOf(int index) =>
        ((tester.widget<DecoratedBox>(tabBackground().at(index)).decoration)
                as BoxDecoration)
            .color!;

    expect(cellColorOf(0), selectedBg);
    expect(cellColorOf(1), transparentBg);
    expect(cellColorOf(2), transparentBg);

    final Size cellSize = tester.getSize(tabBackground().first);
    expect(cellSize.width, closeTo(320 / 3, 1));
    expect(cellSize.height, 47);

    // 内容垂直居中
    expect(tester.getCenter(find.text('业务2')).dy,
        closeTo(tester.getCenter(tabBackground().at(1)).dy, 1));

    // 点击波纹同样按 12px 圆角裁切
    expect(tester.widget<TabBar>(find.byType(TabBar)).splashBorderRadius,
        BorderRadius.circular(12));

    controller.index = 1;
    await tester.pumpAndSettle();

    expect(cellColorOf(0), transparentBg);
    expect(cellColorOf(1), selectedBg);
  });

  testWidgets('SantoTabBar 点击区域与圆角底色区域一致', (tester) async {
    await tester.pumpWidget(_host(
      SantoTabBar(
        controller: TabController(length: 3, vsync: const TestVSync()),
        tabs: _tabs(3),
        mode: SantoTabBarBadgeMode.origin,
        labelPadding: const EdgeInsets.only(left: 20, right: 12),
      ),
      width: 320,
    ));

    // labelPadding 交给 tab 项承担,不再由 TabBar 加在 tab 外面
    expect(tester.widget<TabBar>(find.byType(TabBar)).labelPadding,
        EdgeInsets.zero);

    final Size cellSize = tester.getSize(tabBackground().first);
    final Size inkSize = tester.getSize(find
        .descendant(of: find.byType(TabBar), matching: find.byType(InkWell))
        .first);
    // 宽度完全一致,高度只多出底部指示器那一线
    expect(inkSize.width, cellSize.width);
    expect(inkSize.height - cellSize.height, 2);
  });

  testWidgets('SantoTabBar 徽标固定在 tab 项右上角，不压到相邻 tab', (tester) async {
    await tester.pumpWidget(_host(
      SantoTabBar(
        controller: TabController(length: 2, vsync: const TestVSync()),
        tabs: [
          BadgeTab(text: '特殊业务详情一', badgeText: '新'),
          BadgeTab(text: '业务二', badgeNum: 22),
        ],
        mode: SantoTabBarBadgeMode.origin,
        labelPadding: const EdgeInsets.only(left: 20, right: 12),
      ),
      width: 320,
    ));

    final Rect firstCell = tester.getRect(tabBackground().at(0));
    final Rect firstBadge = tester.getRect(find.text('新'));
    expect(firstBadge.right, lessThanOrEqualTo(firstCell.right));
    expect(firstBadge.top, greaterThanOrEqualTo(firstCell.top));

    // 第二个 tab 的徽标同样留在自己的 tab 内
    final Rect secondCell = tester.getRect(tabBackground().at(1));
    expect(tester.getRect(find.text('22')).right,
        lessThanOrEqualTo(secondCell.right));
  });
}
