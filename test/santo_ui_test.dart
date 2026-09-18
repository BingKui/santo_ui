import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

void main() {
  test('theme configurator falls back to default config', () {
    final config = SantoThemeConfigurator.instance
        .getConfig(configId: 'not-registered');
    expect(config, isNotNull);
  });

  test('theme configurator supports multiple configIds', () {
    final custom = SantoAllThemeConfig();
    SantoThemeConfigurator.instance
        .register(custom, configId: 'test-theme');
    final config =
        SantoThemeConfigurator.instance.getConfig(configId: 'test-theme');
    expect(config, same(custom));
  });

  testWidgets('SantoButton renders and handles tap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SantoButton(
          text: '主操作',
          type: SantoButtonType.primary,
          size: SantoButtonSize.large,
          block: true,
          onTap: () => tapped = true,
        ),
      ),
    ));
    expect(find.text('主操作'), findsOneWidget);
    await tester.tap(find.byType(SantoButton));
    expect(tapped, isTrue);
  });

  testWidgets('SantoButton renders text', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: SantoButton(
            text: '普通按钮',
            onTap: () {},
          ),
        ),
      ),
    ));
    expect(find.text('普通按钮'), findsOneWidget);
  });
}
