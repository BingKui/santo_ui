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

  testWidgets('SantoSection draws divider on both sides of title',
      (tester) async {
    Finder dividerFinder() => find.byWidgetPredicate((w) =>
        w is Container && w.color == const Color(0xFFE8EAEC));

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SantoSection(
          title: '标题',
          child: const Text('演示内容'),
        ),
      ),
    ));
    // 标题两侧各一条延伸线
    expect(dividerFinder(), findsNWidgets(2));
    expect(find.text('标题'), findsOneWidget);
  });

  testWidgets('SantoSection draws full width divider without title',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SantoSection(
          description: '只有描述',
          child: const Text('演示内容'),
        ),
      ),
    ));

    final divider = find.byWidgetPredicate(
        (w) => w is Container && w.color == const Color(0xFFE8EAEC));
    expect(divider, findsOneWidget);
    expect(find.text('只有描述'), findsOneWidget);
  });

  testWidgets('SantoSection supports description only', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SantoSection(
          description: '只有描述',
        ),
      ),
    ));

    expect(find.text('只有描述'), findsOneWidget);
  });
}
