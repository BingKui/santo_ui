import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

List<SantoSegmentedOption<String>> _options({
  bool secondDisabled = false,
}) =>
    [
      const SantoSegmentedOption(value: 'a', label: '选项A'),
      SantoSegmentedOption(
          value: 'b', label: '选项B', disabled: secondDisabled),
      const SantoSegmentedOption(value: 'c', label: '选项C'),
    ];

Widget _host(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Center(child: child),
    ),
  );
}

/// 滑块是选中项背后那个白色圆角矩形
Finder get _thumb => find.byWidgetPredicate((widget) {
      if (widget is! DecoratedBox) {
        return false;
      }
      final decoration = widget.decoration;
      return decoration is BoxDecoration &&
          decoration.boxShadow != null &&
          decoration.color == Colors.white;
    });

Finder _item(String label) => find.ancestor(
      of: find.text(label),
      matching: find.byType(InkWell),
    );

void main() {
  testWidgets('uncontrolled mode selects the first option by default',
      (tester) async {
    await tester.pumpWidget(_host(
      const SantoSegmented<String>(options: [
        SantoSegmentedOption(value: 'a', label: '选项A'),
        SantoSegmentedOption(value: 'b', label: '选项B'),
      ]),
    ));
    await tester.pumpAndSettle();

    expect(_thumb, findsOneWidget);
    // 默认选中第一项,滑块与第一项同宽同位置
    expect(
      tester.getRect(_thumb),
      tester.getRect(_item('选项A')),
    );
  });

  testWidgets('tapping an item emits the new value and moves the thumb',
      (tester) async {
    String? changed;
    await tester.pumpWidget(_host(
      SantoSegmented<String>(
        options: _options(),
        onChanged: (value) => changed = value,
      ),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('选项B'));
    await tester.pumpAndSettle();

    expect(changed, 'b');
    expect(tester.getRect(_thumb), tester.getRect(_item('选项B')));
  });

  testWidgets('controlled mode follows the external value', (tester) async {
    await tester.pumpWidget(_host(
      SantoSegmented<String>(
        value: 'a',
        options: _options(),
        onChanged: (_) {},
      ),
    ));
    await tester.pumpAndSettle();
    expect(tester.getRect(_thumb), tester.getRect(_item('选项A')));

    await tester.pumpWidget(_host(
      SantoSegmented<String>(
        value: 'c',
        options: _options(),
        onChanged: (_) {},
      ),
    ));
    await tester.pumpAndSettle();
    expect(tester.getRect(_thumb), tester.getRect(_item('选项C')));
  });

  testWidgets('disabled option does not emit and cannot be selected',
      (tester) async {
    String? changed;
    await tester.pumpWidget(_host(
      SantoSegmented<String>(
        options: _options(secondDisabled: true),
        onChanged: (value) => changed = value,
      ),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('选项B'));
    await tester.pumpAndSettle();

    expect(changed, isNull);
    expect(tester.getRect(_thumb), tester.getRect(_item('选项A')));
  });

  testWidgets('disabled component ignores taps', (tester) async {
    var called = false;
    await tester.pumpWidget(_host(
      SantoSegmented<String>(
        disabled: true,
        options: _options(),
        onChanged: (_) => called = true,
      ),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('选项C'));
    await tester.pumpAndSettle();

    expect(called, isFalse);
    expect(tester.getRect(_thumb), tester.getRect(_item('选项A')));
  });

  testWidgets('block mode makes items share the parent width', (tester) async {
    await tester.pumpWidget(_host(SizedBox(
      width: 300,
      child: SantoSegmented<String>(
        block: true,
        defaultValue: 'a',
        options: _options(),
      ),
    )));
    await tester.pumpAndSettle();

    final first = tester.getSize(_item('选项A'));
    final second = tester.getSize(_item('选项B'));
    expect(first.width, moreOrLessEquals(second.width, epsilon: 1));
    // 300 - 轨道左右内边距 2*2 = 296,三等分
    expect(first.width, moreOrLessEquals(296 / 3, epsilon: 1));
  });

  testWidgets('sizes map to the antd track heights', (tester) async {
    const boundaryKey = Key('segmented');
    for (final entry in const {
      SantoSegmentedSize.large: 40.0,
      SantoSegmentedSize.medium: 32.0,
      SantoSegmentedSize.small: 24.0,
    }.entries) {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Center(
            child: RepaintBoundary(
              key: boundaryKey,
              child: SantoSegmented<String>(
                size: entry.key,
                options: _options(),
              ),
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(
        tester.getSize(find.byKey(boundaryKey)).height,
        entry.value,
        reason: '${entry.key} 轨道高度',
      );
    }
  });

  testWidgets('vertical orientation stacks items', (tester) async {
    await tester.pumpWidget(_host(
      const SantoSegmented<String>(
        orientation: SantoSegmentedOrientation.vertical,
        options: [
          SantoSegmentedOption(value: 'a', label: '选项A'),
          SantoSegmentedOption(value: 'b', label: '选项B'),
        ],
      ),
    ));
    await tester.pumpAndSettle();

    final first = tester.getRect(_item('选项A'));
    final second = tester.getRect(_item('选项B'));
    expect(second.top, greaterThanOrEqualTo(first.bottom));
    expect(second.left, first.left);
  });

  testWidgets('options change keeps a still-valid selection', (tester) async {
    await tester.pumpWidget(_host(
      SantoSegmented<String>(
        options: _options(),
        onChanged: (_) {},
      ),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('选项C'));
    await tester.pumpAndSettle();
    expect(tester.getRect(_thumb), tester.getRect(_item('选项C')));

    // 选项 C 仍在列表里,选中态保留
    await tester.pumpWidget(_host(
      SantoSegmented<String>(
        options: const [
          SantoSegmentedOption(value: 'a', label: '选项A'),
          SantoSegmentedOption(value: 'c', label: '选项C'),
        ],
        onChanged: (_) {},
      ),
    ));
    await tester.pumpAndSettle();
    expect(tester.getRect(_thumb), tester.getRect(_item('选项C')));

    // 选项 C 被移除,回退到第一个选项
    await tester.pumpWidget(_host(
      SantoSegmented<String>(
        options: const [
          SantoSegmentedOption(value: 'a', label: '选项A'),
        ],
        onChanged: (_) {},
      ),
    ));
    await tester.pumpAndSettle();
    expect(tester.getRect(_thumb), tester.getRect(_item('选项A')));
  });
}
