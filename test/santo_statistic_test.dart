import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

Widget _host(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Center(child: child),
    ),
  );
}

void main() {
  testWidgets('groups thousands by default', (tester) async {
    await tester.pumpWidget(_host(
      const SantoStatistic(title: '活跃用户', value: 112893),
    ));

    expect(find.text('活跃用户'), findsOneWidget);
    expect(find.text('112,893'), findsOneWidget);
  });

  testWidgets('precision pads and truncates without rounding', (tester) async {
    await tester.pumpWidget(_host(
      const SantoStatistic(value: 112893, precision: 2),
    ));
    expect(find.text('112,893.00'), findsOneWidget);

    await tester.pumpWidget(_host(
      const SantoStatistic(value: 11.2, precision: 3),
    ));
    expect(find.text('11.200'), findsOneWidget);

    await tester.pumpWidget(_host(
      const SantoStatistic(value: 11.2856, precision: 2),
    ));
    expect(find.text('11.28'), findsOneWidget);

    await tester.pumpWidget(_host(
      const SantoStatistic(value: 11.9, precision: 0),
    ));
    expect(find.text('11'), findsOneWidget);
  });

  testWidgets('supports custom separators', (tester) async {
    await tester.pumpWidget(_host(
      const SantoStatistic(
        value: 1234567.891,
        precision: 2,
        groupSeparator: '.',
        decimalSeparator: ',',
      ),
    ));

    expect(find.text('1.234.567,89'), findsOneWidget);
  });

  testWidgets('negative and non numeric values render as input', (tester) async {
    await tester.pumpWidget(_host(const SantoStatistic(value: -1234)));
    expect(find.text('-1,234'), findsOneWidget);

    await tester.pumpWidget(_host(const SantoStatistic(value: '12.5万')));
    expect(find.text('12.5万'), findsOneWidget);

    await tester.pumpWidget(_host(const SantoStatistic(value: '—')));
    expect(find.text('—'), findsOneWidget);
  });

  testWidgets('renders prefix and suffix around the value', (tester) async {
    await tester.pumpWidget(_host(
      const SantoStatistic(
        title: '未合并请求',
        value: 93,
        prefix: Icon(Icons.thumb_up_alt_outlined),
        suffix: Text('/ 100'),
      ),
    ));

    expect(find.byIcon(Icons.thumb_up_alt_outlined), findsOneWidget);
    expect(find.text('/ 100'), findsOneWidget);
    // 前缀在数值左侧、后缀在数值右侧
    final prefixRight = tester.getRect(find.byIcon(Icons.thumb_up_alt_outlined)).right;
    final valueLeft = tester.getRect(find.text('93')).left;
    final valueRight = tester.getRect(find.text('93')).right;
    final suffixLeft = tester.getRect(find.text('/ 100')).left;
    expect(prefixRight, lessThanOrEqualTo(valueLeft));
    expect(suffixLeft, greaterThanOrEqualTo(valueRight));
  });

  testWidgets('formatter takes over the value area', (tester) async {
    await tester.pumpWidget(_host(
      SantoStatistic(
        value: 0.86,
        formatter: (value) => Text('${((value as num) * 100).toStringAsFixed(1)}%'),
      ),
    ));

    expect(find.text('86.0%'), findsOneWidget);
    expect(find.text('0.86'), findsNothing);
  });

  testWidgets('loading shows a skeleton instead of the value', (tester) async {
    await tester.pumpWidget(_host(
      const SantoStatistic(title: '加载中', value: 112893, loading: true),
    ));

    expect(find.byType(SantoSkeleton), findsOneWidget);
    expect(find.text('112,893'), findsNothing);
    expect(find.text('加载中'), findsOneWidget);
  });

  testWidgets('title is optional', (tester) async {
    await tester.pumpWidget(_host(const SantoStatistic(value: 520)));
    expect(find.text('520'), findsOneWidget);
  });

  testWidgets('value inherits the value style', (tester) async {
    await tester.pumpWidget(_host(
      const SantoStatistic(
        title: '上涨',
        value: 11.28,
        precision: 2,
        valueStyle: TextStyle(color: Color(0xFF3F8600), fontSize: 22),
      ),
    ));

    final valueText = tester.widget<Text>(find.text('11.28'));
    final style = valueText.style ??
        DefaultTextStyle.of(tester.element(find.text('11.28'))).style;
    expect(style.color, const Color(0xFF3F8600));
    expect(style.fontSize, 22);
  });
}
