import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

void main() {
  testWidgets('SantoStepper 只有外圈一个描边、内部无描边无底色', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: SantoStepper(value: 5, onChanged: (_) {})),
    ));

    // 唯一一处 border 是外框
    final Finder bordered = find.byWidgetPredicate((w) =>
        w is Container &&
        w.decoration is BoxDecoration &&
        (w.decoration! as BoxDecoration).border != null);
    expect(bordered, findsOneWidget);

    // 内部不再有底色(数值区无背景)
    final Color fillBody = SantoThemeConfigurator.instance
        .getConfig()
        .commonConfig
        .fillBody;
    expect(
      find.byWidgetPredicate((w) => w is Container && w.color == fillBody),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('SantoStepper 两侧按钮可点击且带水波纹载体', (tester) async {
    int? changed;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SantoStepper(
          value: 5,
          max: 10,
          onChanged: (v) => changed = v,
        ),
      ),
    ));

    // 两个按钮各有一个 InkWell
    expect(find.byType(InkWell), findsNWidgets(2));

    await tester.tap(find.byIcon(Icons.add));
    expect(changed, 6);

    await tester.tap(find.byIcon(Icons.remove));
    expect(changed, 4);
  });

  testWidgets('SantoStepper 到达边界后按钮不响应', (tester) async {
    int? changed;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SantoStepper(
          value: 0,
          min: 0,
          max: 10,
          onChanged: (v) => changed = v,
        ),
      ),
    ));

    await tester.tap(find.byIcon(Icons.remove));
    expect(changed, isNull);
  });
}
