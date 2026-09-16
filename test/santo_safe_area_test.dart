import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

void main() {
  const EdgeInsets insets = EdgeInsets.only(top: 24, bottom: 16);

  Widget wrap(Widget child) {
    return MaterialApp(
      home: MediaQuery(
        data: const MediaQueryData(padding: insets),
        child: Scaffold(body: child),
      ),
    );
  }

  testWidgets('SantoSafeArea applies top and bottom insets', (tester) async {
    await tester.pumpWidget(wrap(
      const SantoSafeArea(child: SizedBox.expand(key: Key('content'))),
    ));

    final rect = tester.getRect(find.byKey(const Key('content')));
    expect(rect.top, insets.top);
    expect(rect.height, 600 - insets.top - insets.bottom);
  });

  testWidgets('SantoSafeArea respects top/bottom flags', (tester) async {
    await tester.pumpWidget(wrap(
      const SantoSafeArea(
        top: false,
        bottom: true,
        child: SizedBox.expand(key: Key('content')),
      ),
    ));

    final rect = tester.getRect(find.byKey(const Key('content')));
    expect(rect.top, 0);
    expect(rect.height, 600 - insets.bottom);
  });
}
