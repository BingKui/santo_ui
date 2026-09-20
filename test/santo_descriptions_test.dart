import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

Widget _host(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Padding(padding: const EdgeInsets.all(15), child: child),
    ),
  );
}

const List<SantoDescriptionsItem> _twoItems = [
  SantoDescriptionsItem(label: '姓名', child: Text('张三')),
  SantoDescriptionsItem(label: '电话', child: Text('1810000000')),
];

void main() {
  final commonConfig =
      SantoThemeConfigurator.instance.getConfig().commonConfig;

  testWidgets('默认单列,每项各占一行', (tester) async {
    await tester.pumpWidget(_host(const SantoDescriptions(items: _twoItems)));

    expect(find.text('姓名:'), findsOneWidget);
    expect(find.text('张三'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('电话:')).dy,
      greaterThan(tester.getTopLeft(find.text('姓名:')).dy),
    );
  });

  testWidgets('column 控制每行项数', (tester) async {
    await tester.pumpWidget(
      _host(const SantoDescriptions(items: _twoItems, column: 2)),
    );

    expect(
      tester.getTopLeft(find.text('电话:')).dy,
      tester.getTopLeft(find.text('姓名:')).dy,
    );
    expect(
      tester.getTopLeft(find.text('电话:')).dx,
      greaterThan(tester.getTopLeft(find.text('姓名:')).dx),
    );
  });

  testWidgets('labelWidth 让多行内容左对齐', (tester) async {
    await tester.pumpWidget(
      _host(const SantoDescriptions(items: _twoItems, labelWidth: 60)),
    );

    expect(
      tester.getTopLeft(find.text('张三')).dx,
      tester.getTopLeft(find.text('1810000000')).dx,
    );
  });

  testWidgets('vertical 布局标签在内容上方', (tester) async {
    await tester.pumpWidget(
      _host(const SantoDescriptions(
        items: _twoItems,
        layout: SantoDescriptionsLayout.vertical,
      )),
    );

    expect(
      tester.getTopLeft(find.text('姓名:')).dy,
      lessThan(tester.getTopLeft(find.text('张三')).dy),
    );
    expect(
      tester.getTopLeft(find.text('姓名:')).dx,
      tester.getTopLeft(find.text('张三')).dx,
    );
  });

  testWidgets('colon 可关闭冒号', (tester) async {
    await tester.pumpWidget(
      _host(const SantoDescriptions(items: _twoItems, colon: false)),
    );

    expect(find.text('姓名'), findsOneWidget);
    expect(find.text('姓名:'), findsNothing);
  });

  testWidgets('span 会占满整行并把后续项折到下一行', (tester) async {
    await tester.pumpWidget(_host(
      const SantoDescriptions(
        column: 2,
        items: [
          SantoDescriptionsItem(label: '地址', child: Text('杭州市'), span: 2),
          SantoDescriptionsItem(label: '备注', child: Text('无')),
        ],
      ),
    ));

    expect(
      tester.getTopLeft(find.text('备注:')).dy,
      greaterThan(tester.getTopLeft(find.text('地址:')).dy),
    );
  });

  testWidgets('bordered 给单元格加边框', (tester) async {
    await tester.pumpWidget(_host(
      const SantoDescriptions(items: _twoItems, bordered: true),
    ));

    final Border border = tester
        .widgetList<Container>(find.descendant(
          of: find.byType(SantoDescriptions),
          matching: find.byType(Container),
        ))
        .map((Container c) => c.decoration)
        .whereType<BoxDecoration>()
        .map((BoxDecoration d) => d.border)
        .whereType<Border>()
        .first;
    expect(border.top.width, commonConfig.borderWidthSm);
  });

  testWidgets('非边框模式行间用最小间距,不叠加单元格上下内边距', (tester) async {
    await tester.pumpWidget(_host(const SantoDescriptions(items: _twoItems)));

    // 行间插的是 gapXs 的空隙
    final List<double> heights = tester
        .widgetList<SizedBox>(find.descendant(
          of: find.byType(SantoDescriptions),
          matching: find.byType(SizedBox),
        ))
        .map((SizedBox box) => box.height)
        .whereType<double>()
        .toList();
    expect(heights, contains(commonConfig.gapXs));

    // 两行间距明显小于「上下各一份单元格内边距」的旧量级
    final double gap = tester.getTopLeft(find.text('电话:')).dy -
        tester.getBottomLeft(find.text('张三')).dy;
    expect(gap, lessThan(commonConfig.gapMd * 2));
  });

  testWidgets('title 与 extra 渲染在列表上方', (tester) async {
    await tester.pumpWidget(_host(
      const SantoDescriptions(
        title: '用户信息',
        extra: Text('编辑'),
        items: _twoItems,
      ),
    ));

    expect(find.text('用户信息'), findsOneWidget);
    expect(find.text('编辑'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('用户信息')).dy,
      lessThan(tester.getTopLeft(find.text('姓名:')).dy),
    );
  });

  testWidgets('labelWidget 可替代 label 文案', (tester) async {
    await tester.pumpWidget(_host(
      const SantoDescriptions(
        items: [
          SantoDescriptionsItem(
            labelWidget: Text('自定义标签'),
            child: Text('内容'),
          ),
        ],
      ),
    ));

    expect(find.text('自定义标签'), findsOneWidget);
    expect(find.text('内容'), findsOneWidget);
  });
}
