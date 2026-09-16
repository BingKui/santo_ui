import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

const Key _switchKey = ValueKey<String>('switch');

/// 开关本体(轨道)所在的容器,尺寸即开关尺寸
Finder get _track => find.byType(AnimatedContainer);

/// 模拟撑满宽度的父级(如 SantoSection 的内容列)
Widget _wrap(Widget child, {double width = 300}) => MaterialApp(
  home: Scaffold(
    body: SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [child],
      ),
    ),
  ),
);

Size _trackSize(WidgetTester tester) => tester.getSize(_track);

BoxDecoration _trackDecoration(WidgetTester tester) =>
    tester.widget<AnimatedContainer>(_track).decoration as BoxDecoration;

/// 点击开关本体(撑满宽度的父级下,开关外的空白区域不响应点击)
Future<void> _tapSwitch(WidgetTester tester) async {
  await tester.tap(_track);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('SantoSwitchButton 在撑满宽度的父级下保持自身尺寸', (tester) async {
    await tester.pumpWidget(
      _wrap(SantoSwitchButton(key: _switchKey, value: true, onChanged: (_) {})),
    );

    expect(_trackSize(tester), const Size(42, 26));
  });

  testWidgets('SantoSwitchButton 自定义尺寸在撑满宽度的父级下仍生效', (tester) async {
    await tester.pumpWidget(
      _wrap(
        SantoSwitchButton(
          key: _switchKey,
          size: const Size(80, 40),
          value: true,
          onChanged: (_) {},
        ),
      ),
    );

    expect(_trackSize(tester), const Size(80, 40));
  });

  testWidgets('SantoSwitchButton 未传文案时不展示开关文案', (tester) async {
    await tester.pumpWidget(
      _wrap(SantoSwitchButton(key: _switchKey, value: true, onChanged: (_) {})),
    );

    expect(find.text('开'), findsNothing);
    expect(find.text('关'), findsNothing);
  });

  testWidgets('SantoSwitchButton 展示开/关文案并加宽轨道,切换后宽度不变', (tester) async {
    var value = true;
    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder: (context, setState) => SantoSwitchButton(
            key: _switchKey,
            value: value,
            openText: '启用',
            closeText: '停用',
            onChanged: (v) => setState(() => value = v),
          ),
        ),
      ),
    );

    expect(find.text('启用'), findsOneWidget);
    expect(find.text('停用'), findsOneWidget);

    final width = _trackSize(tester).width;
    expect(width, greaterThan(42));

    await _tapSwitch(tester);
    expect(value, isFalse);
    expect(_trackSize(tester).width, width);
  });

  testWidgets('SantoSwitchButton 文案与主题色均自动适配自定义尺寸', (tester) async {
    await tester.pumpWidget(
      _wrap(
        SantoSwitchButton(
          key: _switchKey,
          size: const Size(80, 40),
          value: true,
          openText: '开',
          closeText: '关',
          onChanged: (_) {},
        ),
      ),
    );

    final size = _trackSize(tester);
    expect(size.height, 40);
    expect(size.width, greaterThanOrEqualTo(80));
  });

  testWidgets('SantoSwitchButton 支持自定义轨道与滑块颜色', (tester) async {
    var value = true;
    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder: (context, setState) => SantoSwitchButton(
            key: _switchKey,
            value: value,
            activeColor: const Color(0xFFFF4D4F),
            inactiveColor: const Color(0xFF52C41A),
            thumbColor: const Color(0xFF17233D),
            onChanged: (v) => setState(() => value = v),
          ),
        ),
      ),
    );

    expect(_trackDecoration(tester).color, const Color(0xFFFF4D4F));

    await _tapSwitch(tester);
    expect(_trackDecoration(tester).color, const Color(0xFF52C41A));
  });

  testWidgets('SantoSwitchButton 跟随外部修改的 value', (tester) async {
    var value = false;
    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder: (context, setState) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoSwitchButton(
                key: _switchKey,
                value: value,
                activeColor: const Color(0xFFFF4D4F),
                inactiveColor: const Color(0xFF52C41A),
                onChanged: (_) {},
              ),
              TextButton(
                onPressed: () => setState(() => value = true),
                child: const Text('外部开启'),
              ),
            ],
          ),
        ),
      ),
    );

    expect(_trackDecoration(tester).color, const Color(0xFF52C41A));

    // 开关自身 onChanged 为空实现,状态完全由外部驱动
    await tester.tap(find.text('外部开启'));
    await tester.pumpAndSettle();
    expect(_trackDecoration(tester).color, const Color(0xFFFF4D4F));
  });

  testWidgets('SantoSwitchButton 点击回传反向状态', (tester) async {
    bool? changed;
    await tester.pumpWidget(
      _wrap(
        SantoSwitchButton(
          key: _switchKey,
          value: false,
          onChanged: (v) => changed = v,
        ),
      ),
    );

    await _tapSwitch(tester);
    expect(changed, isTrue);
  });

  testWidgets('SantoSwitchButton 禁用与加载态不接受点击', (tester) async {
    var enabledTap = 0;
    await tester.pumpWidget(
      _wrap(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SantoSwitchButton(
              value: true,
              enabled: false,
              onChanged: (_) => enabledTap++,
            ),
            SantoSwitchButton(
              value: true,
              loading: true,
              onChanged: (_) => enabledTap++,
            ),
          ],
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // 加载态含无限动画,不能用 pumpAndSettle
    for (final element in find.byType(AnimatedContainer).evaluate()) {
      await tester.tap(find.byWidget(element.widget), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(enabledTap, 0);
  });
}
