import 'package:example/sample/components/avatar/avatar_example.dart';
import 'package:example/sample/components/loading/loading_widget_example.dart';
import 'package:example/sample/components/masonry/masonry_example.dart';
import 'package:example/sample/components/rate/rate_example.dart';
import 'package:example/sample/components/safe_area/safe_area_example.dart';
import 'package:example/sample/components/sidebar/sidebar_example.dart';
import 'package:example/sample/components/statistic/statistic_example.dart';
import 'package:example/sample/components/table/table_example.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

/// 各种 body 结构的代表页:原结构 -> 转换方式
final _pages = <String, Widget>{
  'Center 根(新增滚动容器)': LoadingExample(),
  'Column 根(新增滚动容器)': AvatarExample(),
  'Padding>ListView(不滚动)': RateExample(),
  'SCSV 解包(保持滚动)': SidebarExample(),
  'Row+Expanded': StatisticExample(),
  '嵌套 SCSV': MasonryExample(),
  'SafeArea 根': SafeAreaExample(),
  'Table': TableExample(),
};

void main() {
  for (final entry in _pages.entries) {
    testWidgets('${entry.key} 渲染无异常', (tester) async {
      tester.view.physicalSize = const Size(750, 1334);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFF5F6FA)),
        home: entry.value,
      ));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.takeException(), isNull);
      expect(find.byType(SantoPageLayout), findsOneWidget);

      // 页面可滚到底部(有滚动容器时)
      final scrollables = find.byType(Scrollable);
      if (scrollables.evaluate().isNotEmpty) {
        await tester.drag(scrollables.first, const Offset(0, -600));
        await tester.pump(const Duration(milliseconds: 300));
        expect(tester.takeException(), isNull);
      }
    });
  }
}
