import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

Widget _wrap(Widget child, {double width = 337}) => MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [child],
          ),
        ),
      ),
    );

RenderParagraph _buttonParagraph(WidgetTester tester) =>
    tester.renderObject<RenderParagraph>(find.descendant(
        of: find.byType(SantoNormalButton), matching: find.byType(RichText)));

void main() {
  final common = SantoThemeConfigurator.instance.getConfig().commonConfig;

  testWidgets('输入框右侧按钮:显式 textColor 生效且不省略', (tester) async {
    await tester.pumpWidget(_wrap(SantoInputText(
      label: '验证码',
      labelWidth: 80,
      hintText: '请输入验证码',
      suffixButton: SantoSmallOutlineButton(
        title: '获取',
        width: 56,
        fontSize: 12,
        lineColor: common.brandPrimary,
        textColor: common.brandPrimary,
        insertPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        onTap: () {},
      ),
    )));

    expect(tester.takeException(), isNull);
    final paragraph = _buttonParagraph(tester);
    expect(paragraph.text.style?.color, common.brandPrimary);
    expect(paragraph.didExceedMaxLines, isFalse);
    expect(tester.getSize(find.byType(SantoInputText)).height,
        greaterThanOrEqualTo(44));
  });

  testWidgets('显式 textColor 优先于 type 默认色', (tester) async {
    await tester.pumpWidget(_wrap(SantoNormalButton(
      text: '获取',
      type: SantoButtonType.normal,
      textColor: common.brandPrimary,
      onTap: () {},
    )));

    expect(tester.takeException(), isNull);
    expect(_buttonParagraph(tester).text.style?.color, common.brandPrimary);
  });

  testWidgets('未指定 textColor 时由 type 决定文字色', (tester) async {
    await tester.pumpWidget(_wrap(SantoNormalButton(
      text: '获取',
      type: SantoButtonType.normal,
      onTap: () {},
    )));

    expect(tester.takeException(), isNull);
    expect(
        _buttonParagraph(tester).text.style?.color, common.colorTextBase);
  });
}
