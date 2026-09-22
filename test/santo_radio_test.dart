import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

Widget _wrap(Widget child) =>
    MaterialApp(home: Scaffold(body: Center(child: child)));

/// 模拟真机点击:按下与抬起之间会渲染一帧
/// (结构不稳定的组件会在此卸载手势识别器,导致本次点击作废)
Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.pump(const Duration(milliseconds: 600));
  final gesture = await tester.startGesture(tester.getCenter(finder));
  await tester.pump(const Duration(milliseconds: 50));
  await gesture.up();
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('SantoRadioGroup 组内互斥', (tester) async {
    String? selected;
    await tester.pumpWidget(_wrap(SantoRadioGroup(
      selectId: '0',
      onRadioGroupChange: (id) => selected = id,
      child: const Column(children: [
        SantoRadio(id: '0', title: '选项一'),
        SantoRadio(id: '1', title: '选项二'),
      ]),
    )));

    expect(find.byIcon(Icons.check_circle), findsOneWidget);

    await _tap(tester, find.text('选项二'));
    expect(selected, '1');
    // 仍然只有一个选中项
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });

  testWidgets('SantoRadioGroup 严格模式单击即选中且无异常', (tester) async {
    var selected = '0';
    await tester.pumpWidget(_wrap(SantoRadioGroup(
      selectId: selected,
      direction: Axis.horizontal,
      onRadioGroupChange: (id) => selected = id ?? selected,
      directionalRadios: const [
        SantoRadio(id: '0', title: '选项一', showDivider: false),
        SantoRadio(id: '1', title: '选项二', showDivider: false),
      ],
    )));

    await _tap(tester, find.text('选项二'));
    // 一次点击即切换,且不出现树锁定期间 setState 的异常
    expect(selected, '1');
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SantoRadioGroup 严格模式不可取消勾选', (tester) async {
    await tester.pumpWidget(_wrap(SantoRadioGroup(
      selectId: '0',
      child: const Column(children: [
        SantoRadio(id: '0', title: '选项一'),
      ]),
    )));

    await _tap(tester, find.text('选项一'));
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });

  testWidgets('SantoRadio 禁用时不可切换', (tester) async {
    await tester.pumpWidget(_wrap(SantoRadioGroup(
      selectId: '0',
      child: const Column(children: [
        SantoRadio(id: '0', title: '选项一'),
        SantoRadio(id: '1', title: '选项二', enable: false),
      ]),
    )));

    await _tap(tester, find.text('选项二'));
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    // 选中项仍是第一项
    expect(
      tester.getCenter(find.byIcon(Icons.check_circle)).dy,
      closeTo(tester.getCenter(find.text('选项一')).dy, 2),
    );
  });

  testWidgets('SantoRadio 四种勾选样式', (tester) async {
    await tester.pumpWidget(_wrap(SantoRadioGroup(
      selectId: '0',
      child: const Column(children: [
        SantoRadio(id: '0', title: '方形', radioStyle: SantoRadioStyle.square),
        SantoRadio(
            id: '1',
            title: '镂空圆点',
            radioStyle: SantoRadioStyle.hollowCircle),
      ]),
    )));

    expect(find.byIcon(Icons.check_box), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
    expect(find.byIcon(Icons.check), findsNothing);
  });

  testWidgets('SantoRadio 卡片模式选中显示边框与角标', (tester) async {
    await tester.pumpWidget(_wrap(SantoRadioGroup(
      selectId: '0',
      child: const Column(children: [
        SantoRadio(id: '0', title: '选项一', cardMode: true),
        SantoRadio(id: '1', title: '选项二', cardMode: true),
      ]),
    )));

    // 卡片模式不显示指示器,选中卡片右侧显示选中背景图标
    final badge = tester.widget<SantoIcon>(find.byType(SantoIcon));
    expect(badge.name, SantoSolidIcons.checkCircle);
    expect(badge.solid, true);
    expect(find.byIcon(Icons.radio_button_unchecked), findsNothing);
  });

  testWidgets('SantoRadioGroup 横向排列与下划线', (tester) async {
    await tester.pumpWidget(_wrap(SantoRadioGroup(
      selectId: '0',
      direction: Axis.horizontal,
      showDivider: true,
      directionalRadios: const [
        SantoRadio(id: '0', title: '选项一', showDivider: false),
        SantoRadio(id: '1', title: '选项二', showDivider: false),
      ],
    )));

    expect(tester.getTopLeft(find.text('选项一')).dy,
        tester.getTopLeft(find.text('选项二')).dy);
    expect(find.byType(SantoLine), findsOneWidget);
  });

  testWidgets('SantoRadioGroup 控制器可外部操作勾选', (tester) async {
    final controller = SantoCheckboxGroupController();
    await tester.pumpWidget(_wrap(SantoRadioGroup(
      controller: controller,
      child: const Column(children: [
        SantoRadio(id: '0', title: '选项一'),
        SantoRadio(id: '1', title: '选项二'),
      ]),
    )));

    controller.toggle('1', true);
    await tester.pumpAndSettle();

    expect(controller.checked('1'), true);
    expect(controller.checked('0'), false);
  });
}
