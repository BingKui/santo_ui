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

  testWidgets('all fixed columns wider than the table scroll horizontally',
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

    // 列宽和 600 > 容器 390,进入横向滚动模式,列按定宽渲染
    expect(tester.getSize(_cells.at(0)).width, 300);
    expect(tester.getSize(_cells.at(1)).width, 300);
    expect(tester.takeException(), isNull);
  });

  testWidgets('height pins the header and scrolls the body vertically',
      (tester) async {
    await tester.pumpWidget(_wrap(
      SantoTable(
        height: 120,
        columns: [
          SantoTableColumn(title: '姓名', width: 100),
          SantoTableColumn(title: '年龄', width: 100),
        ],
        data: List<List<dynamic>>.generate(
            20, (int i) => <dynamic>['用户$i', '$i']),
      ),
    ));
    await tester.pumpAndSettle();

    // 表头仍在,内容区按 height 限高滚动
    expect(find.text('姓名'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('用户0'), findsOneWidget);

    // 一路向下滚直到最后一行可见,表头始终固定
    for (int i = 0;
        i < 10 && find.text('用户19').evaluate().isEmpty;
        i++) {
      await tester.drag(find.byType(SantoTable), const Offset(0, -200));
      await tester.pumpAndSettle();
    }
    expect(find.text('用户19'), findsOneWidget);
    expect(find.text('姓名'), findsOneWidget);
  });

  testWidgets('fixed columns stay outside the scrollable middle area',
      (tester) async {
    await tester.pumpWidget(_wrap(
      SantoTable(
        columns: [
          SantoTableColumn(title: '姓名', width: 100,
              fixed: SantoTableColumnFixed.left),
          SantoTableColumn(title: '年龄', width: 90),
          SantoTableColumn(title: '城市', width: 120),
          SantoTableColumn(title: '操作', width: 100,
              fixed: SantoTableColumnFixed.right),
        ],
        data: [
          ['张三', '25', '北京', '详情'],
        ],
      ),
    ));
    await tester.pumpAndSettle();

    // 单元格取带内边距的 Container 矩形,表头与数据行逐列对齐
    Rect headerCell(String title) => tester.getRect(find
        .ancestor(of: find.text(title), matching: _cells)
        .first);
    Rect dataCell(String text) => tester.getRect(find
        .ancestor(of: find.text(text).first, matching: _cells)
        .first);

    expect(headerCell('姓名').left, moreOrLessEquals(dataCell('张三').left, epsilon: 0.5));
    expect(headerCell('姓名').width, moreOrLessEquals(dataCell('张三').width, epsilon: 0.5));
    expect(headerCell('年龄').left, moreOrLessEquals(dataCell('25').left, epsilon: 0.5));
    expect(headerCell('年龄').width, moreOrLessEquals(dataCell('25').width, epsilon: 0.5));
    expect(headerCell('城市').left, moreOrLessEquals(dataCell('北京').left, epsilon: 0.5));

    // 姓名固定在表格左缘,操作固定在表格右缘
    final Rect tableRect = tester.getRect(find.byType(SantoTable));
    expect(headerCell('姓名').left, moreOrLessEquals(tableRect.left, epsilon: 0.5));
    expect(headerCell('操作').right, moreOrLessEquals(tableRect.right, epsilon: 0.5));
    expect(dataCell('详情').right, moreOrLessEquals(tableRect.right, epsilon: 0.5));
  });

  testWidgets('auto columns fall back to the default width in scroll mode',
      (tester) async {
    await tester.pumpWidget(_wrap(
      SantoTable(
        columns: [
          SantoTableColumn(title: '姓名', width: 100,
              fixed: SantoTableColumnFixed.left),
          SantoTableColumn(title: '备注'),
        ],
        data: [
          ['张三', '备注内容'],
        ],
      ),
    ));
    await tester.pumpAndSettle();

    // 未定宽列在横向滚动模式下取默认宽 120
    final Rect cell = tester.getRect(find
        .ancestor(
            of: find.text('备注内容'),
            matching: find.byWidgetPredicate((Widget w) => w is Container))
        .first);
    expect(cell.width, 120);
    expect(tester.takeException(), isNull);
  });
}
