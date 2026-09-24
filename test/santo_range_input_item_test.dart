import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

/// 左右两侧内容撑满时,右侧范围输入区需要让位收缩,不能出现溢出条纹
Widget _wrap({required double width, bool filled = true}) => MaterialApp(
  home: Scaffold(
    body: Center(
      child: SizedBox(
        width: width,
        child: SantoRangeInputFormItem(
          minController: TextEditingController()..text = filled ? '10' : '',
          maxController: TextEditingController()..text = filled ? '100' : '',
          prefixIconType: SantoPrefixIconType.add,
          isRequire: true,
          title: '保护期',
          subTitle: '这里是副标题',
          tipLabel: '标签',
          minUnit: '天',
          maxUnit: '天',
          leftMaxCount: 1,
          rightMaxCount: 3,
          inputType: SantoInputType.number,
        ),
      ),
    ),
  ),
);

List<double> _inputWidths(WidgetTester tester) {
  final finder = find.byType(TextField);
  return List<double>.generate(
    finder.evaluate().length,
    (i) => tester.getSize(finder.at(i)).width,
  );
}

void main() {
  // 行宽 = 传入宽度 - 录入项左右各 10 的内边距
  testWidgets('空间充足时输入框保持 50 上限', (tester) async {
    await tester.pumpWidget(_wrap(width: 375));

    expect(tester.takeException(), isNull);
    expect(_inputWidths(tester), const <double>[50, 50]);
  });

  testWidgets('行宽 331(示例页实际宽度)时收缩右侧输入区不溢出', (tester) async {
    await tester.pumpWidget(_wrap(width: 351));

    expect(tester.takeException(), isNull);
    final widths = _inputWidths(tester);
    expect(widths.every((w) => w > 40), isTrue, reason: '$widths');
  });

  testWidgets('行宽 264 窄屏且为空态时收缩右侧输入区不溢出', (tester) async {
    await tester.pumpWidget(_wrap(width: 284, filled: false));

    expect(tester.takeException(), isNull);
    expect(_inputWidths(tester).length, 2);
  });
}
