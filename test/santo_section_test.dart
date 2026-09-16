import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

void main() {
  testWidgets('SantoSection renders content, title and description',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SantoSection(
          title: '语法糖',
          description: '通过 type 语法糖使用预设的按钮样式',
          child: const Text('演示内容'),
        ),
      ),
    ));

    expect(find.text('演示内容'), findsOneWidget);
    expect(find.text('语法糖'), findsOneWidget);
    expect(find.text('通过 type 语法糖使用预设的按钮样式'), findsOneWidget);
  });

  testWidgets('SantoSection hides divider when disabled', (tester) async {
    Finder dividerFinder() => find.byWidgetPredicate((w) =>
        w is Container && w.color == const Color(0xFFE8EAEC));

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SantoSection(
          title: '有分割线',
          child: const Text('演示内容'),
        ),
      ),
    ));
    expect(dividerFinder(), findsOneWidget);
    expect(find.text('有分割线'), findsOneWidget);

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SantoSection(
          title: '无分割线',
          showDivider: false,
          child: const Text('演示内容'),
        ),
      ),
    ));
    expect(dividerFinder(), findsNothing);
    expect(find.text('无分割线'), findsOneWidget);
  });

  testWidgets('SantoSection supports description only and custom radius',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SantoSection(
          description: '只有描述',
          radius: 24,
        ),
      ),
    ));

    expect(find.text('只有描述'), findsOneWidget);

    final container = tester.widget<Container>(find.byType(Container).first);
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.borderRadius, BorderRadius.circular(24));
  });
}
