import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

Widget _host(Widget child) => MaterialApp(
      home: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [child],
        ),
      ),
    );

double _dividerHeight(WidgetTester tester) =>
    tester.getSize(find.byType(SantoDivider)).height;

void main() {
  testWidgets('默认水平分割线上下间距为 vSpacingMd', (tester) async {
    final vSpacingMd =
        SantoThemeConfigurator.instance.getConfig().commonConfig.vSpacingMd;
    await tester.pumpWidget(_host(const SantoDivider()));
    expect(_dividerHeight(tester), 1 + vSpacingMd * 2);
  });

  testWidgets('spacing 优先于 size', (tester) async {
    await tester.pumpWidget(_host(const SantoDivider(spacing: 4)));
    expect(_dividerHeight(tester), 1 + 4 * 2);
  });

  testWidgets('spacing 为 0 时完全去掉上下留白', (tester) async {
    await tester.pumpWidget(_host(const SantoDivider(spacing: 0)));
    expect(_dividerHeight(tester), 1);
  });

  testWidgets('spacing 为 0 时带标题分割线同样去掉上下留白', (tester) async {
    await tester.pumpWidget(_host(const SantoDivider(
      spacing: 0,
      child: Text('标题'),
    )));
    expect(_dividerHeight(tester), SantoThemeConfigurator.instance
        .getConfig()
        .commonConfig
        .vSpacingLg);
  });
}
