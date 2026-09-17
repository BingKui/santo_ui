import 'package:example/main.dart';
import 'package:example/sample/home/card_data_config.dart';
import 'package:example/sample/home/group_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

void main() {
  testWidgets('全部组件示例页逐个打开无异常', (tester) async {
    tester.view.physicalSize = const Size(860, 1334);
    tester.view.devicePixelRatio = 2.0;
    tester.view.padding = const FakeViewPadding(top: 47, bottom: 34);
    tester.view.viewPadding = const FakeViewPadding(top: 47, bottom: 34);
    addTearDown(tester.view.reset);

    SantoThemeConfigurator.instance.register(
      SantoAllThemeConfig(appBarConfig: SantoAppBarConfig.dark()),
    );

    await tester.pumpWidget(MyApp());
    await tester.pump(const Duration(milliseconds: 300));

    final groups = CardDataConfig.getAllGroup();
    final failures = <String>[];
    var opened = 0;

    for (final group in groups) {
      final barLabel = group.shortName ?? group.groupName;
      if (find.text(barLabel).evaluate().isNotEmpty) {
        await tester.tap(find
            .descendant(
                of: find.byType(SantoMenuBar), matching: find.text(barLabel))
            .first);
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));
      }

      for (final child in group.children ?? <GroupInfo>[]) {
        final ctx = tester.element(find.byType(GroupListPage).first);
        try {
          child.navigatorPage?.call(ctx);
        } catch (e) {
          failures.add('[${group.groupName}] ${child.groupName} 跳转抛出: $e');
          continue;
        }
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));
        opened++;
        final err = tester.takeException();
        if (err != null) {
          failures.add('[${group.groupName}] ${child.groupName} -> '
              '${err.toString().split('\n').first}');
        }
        final nav = tester.state<NavigatorState>(find.byType(Navigator).first);
        nav.pop();
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));
        tester.takeException();
      }
    }

    debugPrint('=== 已打开 $opened 个页面,异常 ${failures.length} 个 ===');
    for (final f in failures) {
      debugPrint('!!! $f');
    }
    expect(failures, isEmpty);
  });
}
