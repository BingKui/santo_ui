import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

Widget _wrap(Widget child, {double width = 390}) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: SizedBox(width: width, child: child),
      ),
    ),
  );
}

/// 表头和数据行的单元格都是带 cellPadding 的 Container
/// (cellPadding 默认水平取 gapMd = iDefaultGap * 3)
final Finder _cells = find.byWidgetPredicate(
  (widget) =>
      widget is Container &&
      widget.padding ==
          const EdgeInsets.symmetric(horizontal: iDefaultGap * 3),
);

void main() {
  testWidgets('fixed columns keep width, auto column takes the rest',
      (tester) async {
    await tester.pumpWidget(_wrap(SantoTable(
      columns: [
        SantoTableColumn(
            title: '排名', width: 60, align: SantoTableAlign.center),
        SantoTableColumn(title: '产品名称', align: SantoTableAlign.left),
        SantoTableColumn(
            title: '价格', width: 80, align: SantoTableAlign.right),
        SantoTableColumn(
            title: '销量', width: 80, align: SantoTableAlign.right),
      ],
      data: [
        ['1', 'iPhone 15 Pro', '¥8999', '12,580'],
      ],
    )));

    // 表头四列：60 / 170 / 80 / 80
    expect(tester.getSize(_cells.at(0)).width, 60);
    expect(tester.getSize(_cells.at(1)).width, moreOrLessEquals(170, epsilon: 1));
    expect(tester.getSize(_cells.at(2)).width, 80);
    expect(tester.getSize(_cells.at(3)).width, 80);
    // 数据行同宽
    expect(tester.getSize(_cells.at(4)).width, 60);
    expect(tester.getSize(_cells.at(5)).width, moreOrLessEquals(170, epsilon: 1));

    // 自动列的表头与内容不被挤压成空列
    expect(tester.getSize(find.text('产品名称')).width, greaterThan(40));
    expect(tester.getSize(find.text('iPhone 15 Pro')).width, greaterThan(60));
  });

  testWidgets('columns without width split space evenly', (tester) async {
    await tester.pumpWidget(_wrap(
      SantoTable(
        columns: [
          SantoTableColumn(title: '姓名'),
          SantoTableColumn(title: '年龄'),
          SantoTableColumn(title: '城市'),
        ],
        data: [
          ['张三', '25', '北京'],
        ],
      ),
      width: 300,
    ));

    expect(tester.getSize(_cells.at(0)).width, moreOrLessEquals(100, epsilon: 1));
    expect(tester.getSize(_cells.at(1)).width, moreOrLessEquals(100, epsilon: 1));
    expect(tester.getSize(_cells.at(2)).width, moreOrLessEquals(100, epsilon: 1));
  });

  testWidgets('all fixed columns share the table width proportionally',
      (tester) async {
    await tester.pumpWidget(_wrap(
      SantoTable(
        columns: [
          SantoTableColumn(title: 'A', width: 100),
          SantoTableColumn(title: 'B', width: 100),
        ],
        data: [
          ['a1', 'b1'],
        ],
      ),
      width: 350,
    ));

    expect(tester.getSize(_cells.at(0)).width, moreOrLessEquals(175, epsilon: 1));
    expect(tester.getSize(_cells.at(1)).width, moreOrLessEquals(175, epsilon: 1));
  });

  testWidgets('all fixed columns wider than the table shrink proportionally',
      (tester) async {
    await tester.pumpWidget(_wrap(
      SantoTable(
        columns: [
          SantoTableColumn(title: 'A', width: 300),
          SantoTableColumn(title: 'B', width: 300),
        ],
        data: [
          ['a1', 'b1'],
        ],
      ),
    ));

    expect(tester.getSize(_cells.at(0)).width, moreOrLessEquals(195, epsilon: 1));
    expect(tester.getSize(_cells.at(1)).width, moreOrLessEquals(195, epsilon: 1));
    expect(tester.takeException(), isNull);
  });
}
