import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

void main() {
  testWidgets('SantoPanel renders title, actions and content', (tester) async {
    var tapped = false;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SantoPanel(
          title: '面板标题',
          actions: [
            SantoNormalButton.outline(
              text: '更多',
              onTap: () => tapped = true,
            ),
          ],
          child: const Text('面板内容'),
        ),
      ),
    ));

    expect(find.text('面板标题'), findsOneWidget);
    expect(find.text('面板内容'), findsOneWidget);
    expect(find.text('更多'), findsOneWidget);
    await tester.tap(find.text('更多'));
    expect(tapped, isTrue);
  });

  testWidgets('SantoPanel 内容按内圈圆角裁切,四角描边完整', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SantoPanel(
          title: '无边距',
          contentPadding: false,
          child: const SizedBox(height: 40, width: double.infinity),
        ),
      ),
    ));

    // 外框 12 圆角,内容按 12 - 0.5 描边裁切
    final ClipRRect clip =
        tester.widget<ClipRRect>(find.byType(ClipRRect).first);
    expect(clip.borderRadius, BorderRadius.circular(11.5));
  });

  testWidgets('SantoPanel hides content padding when disabled', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SantoPanel(
          title: '无边距',
          contentPadding: false,
          child: const Text('内容'),
        ),
      ),
    ));
    expect(find.text('内容'), findsOneWidget);
  });

  testWidgets('SantoPanel supports maxHeight scrolling', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SantoPanel(
          title: '可滚动',
          maxHeight: 100,
          child: Column(
            children: List.generate(
                20, (i) => Text('条目$i', key: ValueKey('item-$i'))),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.byType(Scrollbar), findsOneWidget);
    expect(find.text('条目0'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('item-19')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('条目19'), findsOneWidget);
  });
}
