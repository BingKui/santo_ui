import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/src/components/backtop/santo_backtop.dart';
import 'package:santo_ui/src/components/icon/santo_icon.dart';
import 'package:santo_ui/src/theme/base/santo_default_config_utils.dart';

void main() {
  Future<ScrollController> pumpBackTop(WidgetTester tester,
      {Widget? child}) async {
    final ScrollController controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            ListView.builder(
              controller: controller,
              itemCount: 50,
              itemBuilder: (BuildContext context, int index) =>
                  SizedBox(height: 100, child: Text('$index')),
            ),
            SantoBackTop(scrollController: controller, child: child),
          ],
        ),
      ),
    ));
    controller.jumpTo(500);
    await tester.pumpAndSettle();
    return controller;
  }

  testWidgets('默认按钮:48 圆底 + 20 图标 + 品牌色', (WidgetTester tester) async {
    await pumpBackTop(tester);

    final Finder button = find.descendant(
      of: find.byType(SantoBackTop),
      matching: find.byType(Container),
    );
    expect(tester.getSize(button.first), const Size(48, 48));

    final Finder icon = find.byType(SantoIcon);
    expect(tester.getSize(icon), const Size(20, 20), reason: '图标应为 20');
    expect(tester.widget<SantoIcon>(icon).color,
        SantoDefaultConfigUtils.defaultCommonConfig.brandPrimary);
  });

  testWidgets('传 child 时用自定义按钮', (WidgetTester tester) async {
    await pumpBackTop(tester, child: const SizedBox(key: Key('custom'), width: 30, height: 30));

    expect(find.byKey(const Key('custom')), findsOneWidget);
    expect(find.byType(SantoIcon), findsNothing);
  });
}
