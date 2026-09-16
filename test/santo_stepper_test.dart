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

  testWidgets('SantoStepper 支持三档尺寸', (tester) async {
    Finder outerBox() => find.byWidgetPredicate((w) =>
        w is Container &&
        w.decoration is BoxDecoration &&
        (w.decoration! as BoxDecoration).border != null);

    Future<Rect> pumpSize(SantoStepperSize size) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Center(
            child: SantoStepper(value: 3, size: size, onChanged: (_) {}),
          ),
        ),
      ));
      return tester.getRect(outerBox());
    }

    final Rect small = await pumpSize(SantoStepperSize.small);
    expect(small.height, 24);

    final Rect normal = await pumpSize(SantoStepperSize.normal);
    expect(normal.height, 32);

    final Rect large = await pumpSize(SantoStepperSize.large);
    expect(large.height, 40);

    // 高度递增,宽度随之变宽
    expect(large.width, greaterThan(normal.width));
    expect(normal.width, greaterThan(small.width));
  });

  testWidgets('SantoStepper inputHeight/inputWidth 可覆盖档位预设', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: SantoStepper(
            value: 3,
            size: SantoStepperSize.small,
            inputHeight: 36,
            inputWidth: 80,
            onChanged: (_) {},
          ),
        ),
      ),
    ));

    final Rect outer = tester.getRect(find.byWidgetPredicate((w) =>
        w is Container &&
        w.decoration is BoxDecoration &&
        (w.decoration! as BoxDecoration).border != null));
    expect(outer.height, 36);
    // 36(减号) + 0.5 + 80(数值区) + 0.5 + 36(加号) + 外框左右各 0.5
    expect(outer.width, closeTo(154, 1));
  });
}
