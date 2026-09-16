import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

Widget _wrap(Widget child) =>
    MaterialApp(home: Scaffold(body: Center(child: child)));

/// 两次点击间隔需大于全局防连点时间
Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.pump(const Duration(milliseconds: 600));
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('SantoCheckbox 点击切换勾选状态', (tester) async {
    final changed = <bool>[];
    await tester.pumpWidget(_wrap(SantoCheckbox(
      title: '多选',
      onChanged: changed.add,
    )));

    expect(find.byIcon(Icons.radio_button_unchecked), findsOneWidget);
    await _tap(tester, find.text('多选'));
    expect(changed, [true]);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);

    await _tap(tester, find.text('多选'));
    expect(changed, [true, false]);
    expect(find.byIcon(Icons.radio_button_unchecked), findsOneWidget);
  });

  testWidgets('SantoCheckbox 禁用时不可点击', (tester) async {
    var changed = false;
    await tester.pumpWidget(_wrap(SantoCheckbox(
      title: '多选',
      enable: false,
      onChanged: (value) => changed = value,
    )));

    await _tap(tester, find.text('多选'));
    expect(changed, false);
  });

  testWidgets('SantoCheckbox 勾选样式与尺寸', (tester) async {
    await tester.pumpWidget(_wrap(SantoCheckbox(
      title: '多选',
      style: SantoCheckboxStyle.square,
      size: SantoCheckBoxSize.large,
    )));

    expect(find.byIcon(Icons.check_box_outline_blank), findsOneWidget);
    expect(tester.getSize(find.byType(SantoCheckbox)).height, 56);

    await tester.pumpWidget(_wrap(SantoCheckbox(
      title: '多选',
      style: SantoCheckboxStyle.check,
    )));
    expect(tester.getSize(find.byType(SantoCheckbox)).height, 48);
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('SantoCheckbox 内容方位与副标题', (tester) async {
    await tester.pumpWidget(_wrap(SantoCheckbox(
      title: '多选',
      subTitle: '描述信息',
      contentDirection: SantoContentDirection.left,
    )));

    final contentLeft = tester.getTopLeft(find.text('多选')).dx;
    final iconLeft =
        tester.getTopLeft(find.byIcon(Icons.radio_button_unchecked)).dx;
    expect(contentLeft, lessThan(iconLeft));
    expect(find.text('描述信息'), findsOneWidget);
  });

  testWidgets('SantoCheckbox 分割线与卡片模式', (tester) async {
    await tester.pumpWidget(_wrap(SantoCheckbox(title: '多选')));
    expect(find.byType(SantoLine), findsOneWidget);

    await tester.pumpWidget(_wrap(SantoCheckbox(title: '多选', showDivider: false)));
    expect(find.byType(SantoLine), findsNothing);

    await tester.pumpWidget(_wrap(SantoCheckbox(
      title: '多选',
      cardMode: true,
      checked: true,
    )));
    // 卡片模式:无指示器、无分割线,左上角显示勾选角标
    expect(find.byType(SantoLine), findsNothing);
    expect(find.byIcon(Icons.radio_button_unchecked), findsNothing);
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('SantoCheckbox 支持自定义指示器与内容', (tester) async {
    await tester.pumpWidget(_wrap(SantoCheckbox(
      title: '多选',
      customIconBuilder: (context, checked) =>
          Icon(Icons.star, size: 20, color: Colors.amber),
      customContentBuilder: (context, checked, content) =>
          Text(checked ? '已选' : '未选'),
    )));

    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(find.text('未选'), findsOneWidget);
    await _tap(tester, find.text('未选'));
    expect(find.text('已选'), findsOneWidget);
  });

  testWidgets('SantoCheckboxGroup 管理组内勾选状态', (tester) async {
    var checkedIds = <String>[];
    await tester.pumpWidget(_wrap(SantoCheckboxGroup(
      checkedIds: const ['0'],
      onChangeGroup: (ids) => checkedIds = ids,
      child: const Column(children: [
        SantoCheckbox(id: '0', title: '选项一'),
        SantoCheckbox(id: '1', title: '选项二'),
      ]),
    )));

    expect(find.byIcon(Icons.check_circle), findsOneWidget);

    await _tap(tester, find.text('选项二'));
    expect(checkedIds, contains('1'));
    expect(find.byIcon(Icons.check_circle), findsNWidgets(2));
  });

  testWidgets('SantoCheckboxGroup maxChecked 超出时回调且不勾选', (tester) async {
    var overload = false;
    await tester.pumpWidget(_wrap(SantoCheckboxGroup(
      maxChecked: 1,
      onOverloadChecked: () => overload = true,
      child: const Column(children: [
        SantoCheckbox(id: '0', title: '选项一'),
        SantoCheckbox(id: '1', title: '选项二'),
      ]),
    )));

    await _tap(tester, find.text('选项一'));
    await _tap(tester, find.text('选项二'));

    expect(overload, true);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });

  testWidgets('SantoCheckboxGroupController 全选与反选', (tester) async {
    final controller = SantoCheckboxGroupController();
    await tester.pumpWidget(_wrap(SantoCheckboxGroup(
      controller: controller,
      checkedIds: const ['0', '1'],
      child: const Column(children: [
        SantoCheckbox(id: '0', title: '选项一'),
        SantoCheckbox(id: '1', title: '选项二'),
      ]),
    )));

    expect(controller.allChecked(), ['0', '1']);
    expect(controller.checked('0'), true);

    controller.toggleAll(false);
    await tester.pumpAndSettle();
    expect(controller.allChecked(), isEmpty);
    expect(find.byIcon(Icons.check_circle), findsNothing);

    controller.toggleAll(true);
    await tester.pumpAndSettle();
    expect(controller.allChecked().length, 2);
  });

  testWidgets('SantoCheckboxGroupContainer 横向与换行布局', (tester) async {
    await tester.pumpWidget(_wrap(SantoCheckboxGroupContainer(
      direction: Axis.horizontal,
      selectIds: const ['0'],
      directionalCheckboxes: const [
        SantoCheckbox(id: '0', title: '选项一', showDivider: false),
        SantoCheckbox(id: '1', title: '选项二', showDivider: false),
      ],
    )));

    final first = tester.getRect(find.text('选项一'));
    final second = tester.getRect(find.text('选项二'));
    expect(first.top, second.top);
    expect(second.left, greaterThan(first.left));

    await tester.pumpWidget(_wrap(SantoCheckboxGroupContainer(
      direction: Axis.horizontal,
      rowCount: 2,
      directionalCheckboxes: const [
        SantoCheckbox(id: '0', title: '选项一', showDivider: false),
        SantoCheckbox(id: '1', title: '选项二', showDivider: false),
        SantoCheckbox(id: '2', title: '选项三', showDivider: false),
      ],
    )));

    // rowCount 为 2 时第三项换到第二行
    expect(tester.getRect(find.text('选项三')).top,
        greaterThan(tester.getRect(find.text('选项一')).top));
  });
}
