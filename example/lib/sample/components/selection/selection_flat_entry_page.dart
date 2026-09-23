import 'dart:convert';

import 'package:example/sample/components/selection/flat_selection_five_tags_example.dart';
import 'package:example/sample/components/selection/flat_selection_four_tags_example.dart';
import 'package:example/sample/components/selection/flat_selection_three_tags_example.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:example/sample/home/list_item.dart';
import 'package:flutter/material.dart' hide DropdownMenu;
import 'package:flutter/services.dart';
import 'package:santo_ui/santo_ui.dart';

class FlatSelectionEntryPage extends StatelessWidget {
  const FlatSelectionEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: '平铺筛选示例',
      children: [
        ExampleIntro('selection'),
        SantoSection(
          title: '标签布局',
          description: '将更多筛选中的条件平铺展示，并控制每行标签数量',
          child: Column(
            children: [
              ListItem(
                title: '每行 3 个标签',
                onPressed: () => _openExample(
                  context,
                  (filters) =>
                      FlatSelectionThreeTagsExample('每行 3 个标签', filters),
                ),
              ),
              ListItem(
                title: '每行 4 个标签',
                onPressed: () => _openExample(
                  context,
                  (filters) =>
                      FlatSelectionFourTagsExample('每行 4 个标签', filters),
                ),
              ),
              ListItem(
                title: '每行 5 个标签',
                onPressed: () => _openExample(
                  context,
                  (filters) =>
                      FlatSelectionFiveTagsExample('每行 5 个标签', filters),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _openExample(
    BuildContext context,
    Widget Function(List<SantoSelectionEntity> filters) pageBuilder,
  ) {
    rootBundle.loadString('assets/flat_selection_filter.json').then((data) {
      final filters = SantoSelectionEntityListBean.fromJson(
        (jsonDecode(data) as Map<String, dynamic>)['data'],
      )!.list!;
      _configureMaxSelectedCount(filters[0].children[1], 5);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => pageBuilder(filters)),
      );
    });
  }

  void _configureMaxSelectedCount(SantoSelectionEntity entity, int maxCount) {
    entity.maxSelectedCount = maxCount;
    for (final child in entity.children) {
      _configureMaxSelectedCount(child, maxCount);
    }
  }
}
