import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

Widget _host(Widget child, {double? width}) => MaterialApp(
      home: Scaffold(
        body: Center(
          child: width == null ? child : SizedBox(width: width, child: child),
        ),
      ),
    );

List<String> _texts(WidgetTester tester) => tester
    .widgetList<Text>(find.byType(Text))
    .map((t) => t.data ?? '')
    .toList();

void main() {
  testWidgets('SantoPagination 按 totalItems/itemsPerPage 展示页码', (tester) async {
    await tester.pumpWidget(_host(
      const SantoPagination(current: 3, totalItems: 50, itemsPerPage: 10),
    ));

    // 5 页全部展示,当前页 3
    expect(find.text('上一页'), findsOneWidget);
    expect(find.text('下一页'), findsOneWidget);
    for (int page = 1; page <= 5; page++) {
      expect(find.text('$page'), findsOneWidget);
    }
    expect(find.text('...'), findsNothing);
  });

  testWidgets('SantoPagination 点击页码回传页码与越界边界', (tester) async {
    int? tapped;
    await tester.pumpWidget(_host(
      SantoPagination(
        current: 3,
        totalItems: 50,
        itemsPerPage: 10,
        onChange: (page) => tapped = page,
      ),
    ));

    await tester.tap(find.text('4'));
    expect(tapped, 4);

    // 上一页/下一页
    tapped = null;
    await tester.tap(find.text('上一页'));
    expect(tapped, 2);
    tapped = null;
    await tester.tap(find.text('下一页'));
    expect(tapped, 4);

    // 当前页不变时不回调
    tapped = null;
    await tester.tap(find.text('3'));
    expect(tapped, isNull);

    // 首/尾页时上一页、下一页不可点
    await tester.pumpWidget(_host(
      SantoPagination(
        current: 1,
        totalItems: 50,
        itemsPerPage: 10,
        onChange: (page) => tapped = page,
      ),
    ));
    await tester.tap(find.text('上一页'));
    expect(tapped, isNull);

    await tester.pumpWidget(_host(
      SantoPagination(
        current: 5,
        totalItems: 50,
        itemsPerPage: 10,
        onChange: (page) => tapped = page,
      ),
    ));
    await tester.tap(find.text('下一页'));
    expect(tapped, isNull);
  });

  testWidgets('SantoPagination 简单模式只展示当前页/总页数', (tester) async {
    await tester.pumpWidget(_host(
      const SantoPagination(
        mode: SantoPaginationMode.simple,
        current: 2,
        totalItems: 50,
        itemsPerPage: 10,
      ),
    ));

    expect(find.text('2/5'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });

  testWidgets('SantoPagination forceEllipses 补省略号且点击跳到相邻页', (tester) async {
    int? tapped;
    await tester.pumpWidget(_host(
      SantoPagination(
        current: 10,
        totalItems: 200,
        itemsPerPage: 10,
        forceEllipses: true,
        onChange: (page) => tapped = page,
      ),
    ));

    // 总 20 页,当前 10:展示 8~12 两侧各一个省略号
    expect(_texts(tester), containsAll(<String>['8', '9', '10', '11', '12']));
    expect(find.text('...'), findsNWidgets(2));
    expect(find.text('1'), findsNothing);

    await tester.tap(find.text('...').first);
    expect(tapped, 7);
  });

  testWidgets('SantoPagination showPageSize 控制页码数量', (tester) async {
    await tester.pumpWidget(_host(
      const SantoPagination(
        current: 6,
        totalItems: 200,
        itemsPerPage: 10,
        showPageSize: 3,
      ),
    ));

    expect(_texts(tester), containsAll(<String>['5', '6', '7']));
    expect(find.text('4'), findsNothing);
    expect(find.text('8'), findsNothing);
  });

  testWidgets('SantoPagination pageCount 优先于 totalItems', (tester) async {
    await tester.pumpWidget(_host(
      const SantoPagination(current: 8, pageCount: 8, totalItems: 500),
    ));

    // 按 8 页算:末页 8 可见,9 及 totalItems 算出的 50 页不存在
    expect(_texts(tester), containsAll(<String>['4', '5', '6', '7', '8']));
    expect(find.text('9'), findsNothing);
    expect(find.text('50'), findsNothing);
  });

  testWidgets('SantoPagination 支持隐藏前后按钮', (tester) async {
    await tester.pumpWidget(_host(
      const SantoPagination(
        current: 2,
        totalItems: 50,
        itemsPerPage: 10,
        showPrevButton: false,
        showNextButton: false,
      ),
    ));

    expect(find.text('上一页'), findsNothing);
    expect(find.text('下一页'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('SantoPagination 支持自定义按钮文案', (tester) async {
    await tester.pumpWidget(_host(
      const SantoPagination(
        current: 2,
        totalItems: 50,
        itemsPerPage: 10,
        prevText: '上一步',
        nextText: '下一步',
      ),
    ));

    expect(find.text('上一步'), findsOneWidget);
    expect(find.text('下一步'), findsOneWidget);
    expect(find.text('上一页'), findsNothing);
    expect(find.text('下一页'), findsNothing);
  });

  testWidgets('SantoPagination 上一页/下一页与页码区同属一条并各自带点击反馈',
      (tester) async {
    await tester.pumpWidget(_host(
      const SantoPagination(current: 2, totalItems: 50, itemsPerPage: 10),
    ));

    // 只有整条一个 12px 圆角外框,上一页/下一页都在其中
    final Finder rounded = find.byWidgetPredicate((w) =>
        w is Container &&
        w.decoration is BoxDecoration &&
        (w.decoration! as BoxDecoration).borderRadius ==
            BorderRadius.circular(12));
    expect(rounded, findsOneWidget);
    final Rect bar = tester.getRect(rounded);
    expect(bar.contains(tester.getCenter(find.text('上一页'))), isTrue);
    expect(bar.contains(tester.getCenter(find.text('下一页'))), isTrue);

    // 上一页/下一页可点击并有水波纹载体(Material + InkWell)
    expect(
      find.ancestor(
        of: find.text('上一页'),
        matching: find.byType(InkWell),
      ),
      findsOneWidget,
    );
    expect(
      find.ancestor(
        of: find.text('下一页'),
        matching: find.byType(InkWell),
      ),
      findsOneWidget,
    );
    // 上一页取左圆角、下一页取右圆角;外框不裁切子节点,否则四角 border 会被盖住
    final Material prevMaterial = tester.widget<Material>(
      find
          .ancestor(of: find.text('上一页'), matching: find.byType(Material))
          .first,
    );
    expect(
      prevMaterial.borderRadius,
      const BorderRadius.only(
        topLeft: Radius.circular(12),
        bottomLeft: Radius.circular(12),
      ),
    );

    final Material nextMaterial = tester.widget<Material>(
      find
          .ancestor(of: find.text('下一页'), matching: find.byType(Material))
          .first,
    );
    expect(
      nextMaterial.borderRadius,
      const BorderRadius.only(
        topRight: Radius.circular(12),
        bottomRight: Radius.circular(12),
      ),
    );

    expect(tester.widget<Container>(rounded).clipBehavior, Clip.none);
  });

  testWidgets('SantoPagination 隐藏按钮时由页码项承担外框圆角', (tester) async {
    await tester.pumpWidget(_host(
      const SantoPagination(
        current: 2,
        totalItems: 50,
        itemsPerPage: 10,
        showPrevButton: false,
        showNextButton: false,
      ),
    ));

    BorderRadius? radiusOf(String page) => tester
        .widget<Material>(
          find
              .ancestor(of: find.text(page), matching: find.byType(Material))
              .first,
        )
        .borderRadius as BorderRadius?;

    // 第一项贴左、最后一项贴右
    expect(
      radiusOf('1'),
      const BorderRadius.only(
        topLeft: Radius.circular(12),
        bottomLeft: Radius.circular(12),
      ),
    );
    expect(
      radiusOf('5'),
      const BorderRadius.only(
        topRight: Radius.circular(12),
        bottomRight: Radius.circular(12),
      ),
    );
    expect(radiusOf('3'), isNull);
  });

  testWidgets('SantoPagination 上一页/下一页固定宽度，页码项随内容', (tester) async {
    await tester.pumpWidget(_host(
      const SantoPagination(current: 2, totalItems: 50, itemsPerPage: 10),
    ));

    // 上一页/下一页固定宽度
    expect(tester.getSize(find.text('上一页').first).width,
        lessThan(kSantoPaginationButtonWidth));
    expect(
      tester.getRect(find.text('上一页')).width,
      lessThan(kSantoPaginationButtonWidth),
    );

    // 整条宽度由内容决定,不铺满可用宽度
    final Finder bar = find.byWidgetPredicate((w) =>
        w is Container &&
        w.decoration is BoxDecoration &&
        (w.decoration! as BoxDecoration).borderRadius ==
            BorderRadius.circular(12));
    final double barWidth = tester.getSize(bar).width;
    expect(barWidth, lessThan(320));
    expect(barWidth, greaterThan(kSantoPaginationButtonWidth * 2));

    // 自定义短文案不改变按钮宽度
    await tester.pumpWidget(_host(
      const SantoPagination(
        current: 2,
        totalItems: 50,
        itemsPerPage: 10,
        prevText: '上',
        nextText: '下',
      ),
    ));
    expect(tester.getSize(bar).width, barWidth);
  });

  testWidgets('SantoPagination 页码过多时收窄不溢出', (tester) async {
    await tester.pumpWidget(_host(
      const SantoPagination(
        current: 10,
        totalItems: 200,
        itemsPerPage: 10,
        forceEllipses: true,
      ),
      // 与 Section 卡片内的可用宽度一致
      width: 356,
    ));

    expect(tester.takeException(), isNull);
    final Finder bar = find.byWidgetPredicate((w) =>
        w is Container &&
        w.decoration is BoxDecoration &&
        (w.decoration! as BoxDecoration).borderRadius ==
            BorderRadius.circular(12));
    expect(tester.getSize(bar).width, lessThanOrEqualTo(356));
  });

  testWidgets('SantoPagination 越界页码按边界展示', (tester) async {
    await tester.pumpWidget(_host(
      const SantoPagination(current: 99, totalItems: 50, itemsPerPage: 10),
    ));

    // 5 页时展示 1~5,当前页超出时按末页展示,下一页不可点
    expect(find.text('5'), findsOneWidget);
    expect(find.text('6'), findsNothing);
  });
}
