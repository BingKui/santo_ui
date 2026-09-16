import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  Color? bgOf(WidgetTester tester) {
    final Container container = tester.widget<Container>(find
        .descendant(
            of: find.byType(SantoNormalButton),
            matching: find.byType(Container))
        .first);
    final Decoration? decoration = container.decoration;
    return decoration is BoxDecoration ? decoration.color : null;
  }

  testWidgets('SantoNormalButton type renders antd styles', (tester) async {
    await tester.pumpWidget(wrap(Column(children: [
      SantoNormalButton(text: '主按钮', type: SantoButtonType.primary),
      SantoNormalButton(text: '默认按钮', type: SantoButtonType.normal),
      SantoNormalButton(text: '文本按钮', type: SantoButtonType.text),
      SantoNormalButton(text: '链接按钮', type: SantoButtonType.link),
    ])));

    // 主按钮为主题色实心
    expect(bgOf(tester), const Color(0xFF1677FF));

    // 链接按钮文字用主题色
    final Text linkText = tester.widget<Text>(find.text('链接按钮'));
    expect(linkText.style?.color, const Color(0xFF1677FF));

    // 默认按钮白底带描边
    final Container normalContainer = tester.widget<Container>(find
        .ancestor(
            of: find.text('默认按钮'), matching: find.byType(Container))
        .first);
    final BoxDecoration normalDecoration =
        normalContainer.decoration as BoxDecoration;
    expect(normalDecoration.color, Colors.white);
    expect(normalDecoration.border, isNotNull);
  });

  testWidgets('SantoNormalButton danger uses error color', (tester) async {
    await tester.pumpWidget(wrap(
      SantoNormalButton(
        text: '删除',
        type: SantoButtonType.primary,
        danger: true,
      ),
    ));

    expect(bgOf(tester), const Color(0xFFFF4D4F));
  });

  testWidgets('SantoNormalButton dashed draws dashed border', (tester) async {
    await tester.pumpWidget(wrap(
      SantoNormalButton(text: '虚线按钮', type: SantoButtonType.dashed),
    ));

    expect(
      find.descendant(
          of: find.byType(SantoNormalButton),
          matching: find.byType(CustomPaint)),
      findsWidgets,
    );
  });

  testWidgets('SantoNormalButton loading blocks tap and shows indicator',
      (tester) async {
    var tapped = false;
    await tester.pumpWidget(wrap(
      SantoNormalButton(
        text: '提交',
        type: SantoButtonType.primary,
        loading: true,
        onTap: () => tapped = true,
      ),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.byType(SantoNormalButton));
    expect(tapped, isFalse);
  });

  testWidgets('SantoNormalButton block fills parent width', (tester) async {
    await tester.pumpWidget(wrap(SizedBox(
      width: 300,
      child: SantoNormalButton(
        text: '确定',
        type: SantoButtonType.primary,
        block: true,
      ),
    )));

    expect(tester.getSize(find.byType(SantoNormalButton)).width, 300);
  });

  testWidgets('SantoNormalButton inserts space between two chinese chars',
      (tester) async {
    await tester.pumpWidget(wrap(Column(children: [
      SantoNormalButton(text: '确定', type: SantoButtonType.primary),
      SantoNormalButton(
        text: '取消',
        type: SantoButtonType.primary,
        autoInsertSpace: false,
      ),
    ])));

    expect(find.text('确 定'), findsOneWidget);
    expect(find.text('取消'), findsOneWidget);
  });

  testWidgets('SantoNormalButton icon placement works', (tester) async {
    await tester.pumpWidget(wrap(Column(children: [
      SantoNormalButton(
        text: '搜索',
        type: SantoButtonType.primary,
        icon: const Icon(Icons.search),
      ),
      SantoNormalButton(
        text: '下一步',
        type: SantoButtonType.primary,
        iconPlacement: SantoButtonIconPlacement.end,
        icon: const Icon(Icons.arrow_forward),
      ),
    ])));

    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
  });
}
