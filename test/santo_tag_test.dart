import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  const Color brandPrimary = Color(0xFF1677FF);

  /// 标签内部带装饰的 Container
  Container chipOf(WidgetTester tester, {Finder? of}) {
    return tester.widget<Container>(find
        .descendant(
            of: of ?? find.byType(SantoTag), matching: find.byType(Container))
        .first);
  }

  Color? chipColor(WidgetTester tester, {Finder? of}) {
    final Decoration? decoration = chipOf(tester, of: of).decoration;
    return decoration is BoxDecoration ? decoration.color : null;
  }

  testWidgets('单标签默认高 32、字号 12、主题色底反白文字', (tester) async {
    await tester.pumpWidget(wrap(SantoTag(text: '标签')));

    expect(tester.getSize(find.byType(SantoTag)).height, 32);
    expect(tester.widget<Text>(find.text('标签')).style?.fontSize, 12);
    expect(chipColor(tester), brandPrimary);
  });

  testWidgets('单标签高度与字号可自定义', (tester) async {
    await tester.pumpWidget(
        wrap(SantoTag(text: '标签', height: 48, fontSize: 20)));

    expect(tester.getSize(find.byType(SantoTag)).height, 48);
    expect(tester.widget<Text>(find.text('标签')).style?.fontSize, 20);
  });

  testWidgets('单标签可选中:点击切换选中态并回调', (tester) async {
    final List<bool> reported = <bool>[];
    await tester.pumpWidget(wrap(SantoTag(
      text: '可选中',
      selectable: true,
      onSelectedChange: reported.add,
    )));

    // 未选中:浅色底
    expect(chipColor(tester), isNot(brandPrimary.withOpacity(0.12)));

    await tester.tap(find.byType(SantoTag));
    await tester.pump();
    expect(reported, <bool>[true]);
    expect(chipColor(tester), brandPrimary.withOpacity(0.12));

    // 再点一次取消选中
    await tester.tap(find.byType(SantoTag));
    await tester.pump();
    expect(reported, <bool>[true, false]);
  });

  testWidgets('单标签可删除:展示删除图标并回调', (tester) async {
    int deleted = 0;
    await tester.pumpWidget(wrap(SantoTag(
      text: '可删除',
      deletable: true,
      onDelete: () => deleted++,
    )));

    expect(find.byType(SantoIcon), findsOneWidget);
    await tester.tap(find.byType(SantoIcon));
    await tester.pump();
    expect(deleted, 1);
  });

  testWidgets('标签组按 tags 渲染,组内标签与单标签同高', (tester) async {
    await tester.pumpWidget(wrap(const SantoTag(
      tags: <String>['标签', '标签1', '标签2'],
    )));

    expect(find.text('标签'), findsOneWidget);
    expect(find.text('标签1'), findsOneWidget);
    expect(find.text('标签2'), findsOneWidget);
    expect(tester.getSize(find.byType(Container).first).height, 32);
  });

  testWidgets('标签组单选:点选切换,重复点已选中项不再回调', (tester) async {
    final List<List<int>> reported = <List<int>>[];
    await tester.pumpWidget(wrap(SantoTag(
      selectable: true,
      tags: const <String>['标签', '标签1', '标签2'],
      onChanged: reported.add,
    )));

    await tester.tap(find.text('标签1'));
    await tester.pump();
    expect(reported, <List<int>>[
      <int>[1]
    ]);

    await tester.tap(find.text('标签1'));
    await tester.pump();
    expect(reported.length, 1);

    await tester.tap(find.text('标签2'));
    await tester.pump();
    expect(reported.last, <int>[2]);
  });

  testWidgets('标签组多选:可同时选中多项', (tester) async {
    final List<List<int>> reported = <List<int>>[];
    await tester.pumpWidget(wrap(SantoTag(
      selectable: true,
      isSingleSelect: false,
      tags: const <String>['标签', '标签1', '标签2'],
      initTagState: const <bool>[true, false, false],
      onChanged: reported.add,
    )));

    await tester.tap(find.text('标签1'));
    await tester.pump();
    expect(reported.last, <int>[0, 1]);

    await tester.tap(find.text('标签'));
    await tester.pump();
    expect(reported.last, <int>[1]);
  });

  testWidgets('标签组可删除:未传 controller 也能移除标签', (tester) async {
    final List<String> removed = <String>[];
    await tester.pumpWidget(wrap(SantoTag(
      deletable: true,
      tags: const <String>['标签', '标签1'],
      onTagDelete: (List<String> tags, String? tag, int index) =>
          removed.add('$index-$tag'),
    )));

    expect(find.text('标签1'), findsOneWidget);
    await tester.tap(find.byType(SantoIcon).first);
    await tester.pumpAndSettle();

    expect(find.text('标签'), findsNothing);
    expect(find.text('标签1'), findsOneWidget);
    expect(removed, <String>['0-标签']);
  });

  testWidgets('标签组配 controller:删除同步到控制器,外部增删也生效', (tester) async {
    final SantoTagController controller =
        SantoTagController(initTags: <String>['标签', '标签1']);
    final List<String> reported = <String>[];

    await tester.pumpWidget(wrap(SantoTag(
      controller: controller,
      deletable: true,
      onTagDelete: (List<String> tags, String? tag, int index) =>
          reported.add('${tags.length}-$tag'),
    )));

    await tester.tap(find.byType(SantoIcon).at(1));
    await tester.pumpAndSettle();
    expect(controller.tags, <String>['标签']);
    expect(reported, <String>['1-标签1']);
    expect(find.text('标签1'), findsNothing);

    controller.addTag('新增标签');
    await tester.pumpAndSettle();
    expect(find.text('新增标签'), findsOneWidget);

    controller.deleteForIndex(0);
    await tester.pumpAndSettle();
    expect(find.text('标签'), findsNothing);
  });

  testWidgets('标签组内长文案固定单行省略', (tester) async {
    await tester.pumpWidget(wrap(SantoTag(
      tagWidth: 80,
      tags: const <String>['这是一条很长很长很长很长很长的标签'],
    )));

    final Text label = tester.widget<Text>(find.text('这是一条很长很长很长很长很长的标签'));
    expect(label.maxLines, 1);
    expect(label.overflow, TextOverflow.ellipsis);
    expect(tester.getSize(find.byType(Container).first).width, 80);
  });

  testWidgets('可删除的标签组按内容自适应宽度,文案不被挤成省略号', (tester) async {
    await tester.pumpWidget(wrap(const SantoTag(
      deletable: true,
      tags: <String>['标签信息'],
    )));

    final Size label = tester.getSize(find.text('标签信息'));
    final Size chip = tester.getSize(find.byType(Container).first);

    // 12 号字四个汉字不省略
    expect(label.width, greaterThan(40));
    // 标签宽度放得下文案 + 删除图标 + 左右内边距
    expect(chip.width, greaterThan(label.width + 20));
  });

  testWidgets('可删除的标签组显式传 tagWidth 时仍定宽', (tester) async {
    await tester.pumpWidget(wrap(const SantoTag(
      deletable: true,
      tagWidth: 120,
      tags: <String>['标签信息'],
    )));

    expect(tester.getSize(find.byType(Container).first).width, 120);
  });
}
