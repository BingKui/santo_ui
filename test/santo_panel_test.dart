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

testWidgets('SantoPanel 标题后置控件紧跟标题且让位正确', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SantoPanel(
          title: '标题',
          titleExtra: const SizedBox(
            key: ValueKey('extra'),
            width: 120,
            height: 24,
          ),
          actions: const [
            SizedBox(key: ValueKey('action'), width: 60, height: 24),
          ],
          child: const Text('内容'),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    final titleRect = tester.getRect(find.text('标题'));
    final extraRect = tester.getRect(find.byKey(const ValueKey('extra')));
    final actionRect = tester.getRect(find.byKey(const ValueKey('action')));

    // 后置控件在标题右侧、且保留完整宽度
    expect(extraRect.left, greaterThan(titleRect.right));
    expect(extraRect.width, 120);
    // 操作区在后置控件右侧,并贴齐面板右侧(15 内边距 + 0.5 描边)
    expect(actionRect.left, greaterThan(extraRect.right));
    final panelRect = tester.getRect(find.byType(SantoPanel));
    expect(panelRect.right - actionRect.right, closeTo(15.5, 0.5));
  });

  testWidgets('SantoPanel 标题过长时后置控件保持完整宽度', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SantoPanel(
          title: '这是一个特别特别特别特别特别特别特别特别长的面板标题' * 3,
          titleExtra: const SizedBox(
            key: ValueKey('extra'),
            width: 120,
            height: 24,
          ),
          child: const Text('内容'),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    // 标题收缩让位,后置控件仍为完整 120 宽
    expect(tester.getSize(find.byKey(const ValueKey('extra'))).width, 120);
  });
}
