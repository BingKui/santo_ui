import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

void main() {
  // 按钮有 500ms 防重复点击,静态状态会跨用例残留
  setUp(() => SantoMultiClickUtils.reset());

  testWidgets('关闭图标跟随气泡文字色,深色气泡上取白色', (tester) async {
    final GlobalKey targetKey = GlobalKey();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SantoButton(
          key: targetKey,
          text: '提示',
          onTap: () => SantoTooltip.show(
              targetKey.currentContext!, '提示内容', targetKey,
              hasCloseIcon: true),
        ),
      ),
    ));

    await tester.tap(find.byType(SantoButton));
    await tester.pump(const Duration(milliseconds: 400));

    expect(_closeIcon(tester).color, const Color(0xFFFFFFFF));
  });

  testWidgets('关闭图标在白底弹层上取文字色(深色)', (tester) async {
    final GlobalKey targetKey = GlobalKey();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SantoButton(
          key: targetKey,
          text: '提示',
          onTap: () => SantoTooltip.show(
              targetKey.currentContext!, '提示内容', targetKey,
              hasCloseIcon: true,
              backgroundColor: Colors.white,
              textStyle:
                  const TextStyle(fontSize: 16, color: Color(0xFF17233D))),
        ),
      ),
    ));

    await tester.tap(find.byType(SantoButton));
    await tester.pump(const Duration(milliseconds: 400));

    expect(_closeIcon(tester).color, const Color(0xFF17233D));
  });
}

SantoIcon _closeIcon(WidgetTester tester) =>
    tester.widgetList<SantoIcon>(find.byType(SantoIcon)).firstWhere(
        (SantoIcon icon) => icon.name == SantoIcons.xmark,
        orElse: () => throw StateError('气泡里没有渲染关闭图标'));
