import 'dart:convert';

import 'package:example/sample/components/selection/filter_entity.dart';
import 'package:example/sample/components/selection/selection_flat_entry_page.dart';
import 'package:example/sample/components/selection/selectionview_custom_floating_layer_example.dart';
import 'package:example/sample/components/selection/selectionview_customhandle_filter_example_page.dart';
import 'package:example/sample/components/selection/selectionview_customview_example_page.dart';
import 'package:example/sample/components/selection/selectionview_date_filter_example_page.dart';
import 'package:example/sample/components/selection/selectionview_date_range_example_page.dart';
import 'package:example/sample/components/selection/selectionview_interceptor_example.dart';
import 'package:example/sample/components/selection/selectionview_limit_max_selected_count_example.dart';
import 'package:example/sample/components/selection/selectionview_more_filter_example_page.dart';
import 'package:example/sample/components/selection/selectionview_multi_list_example_page.dart';
import 'package:example/sample/components/selection/selectionview_multi_range_example_page.dart';
import 'package:example/sample/components/selection/selectionview_simple_multi_check_example_page.dart';
import 'package:example/sample/components/selection/selectionview_simple_single_list_example_page.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:example/sample/home/list_item.dart';
import 'package:flutter/material.dart' hide DropdownMenu;
import 'package:flutter/services.dart';
import 'package:santo_ui/santo_ui.dart';

class SelectionEntryPage extends StatelessWidget {
  const SelectionEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'Selection 复杂筛选示例',
      children: [
        ExampleIntro('selection'),
        SantoSection(
          title: '基础筛选',
          description: '单列、组合条件及日期筛选',
          child: Column(
            children: [
              ListItem(
                title: '单列单选',
                onPressed: () => _openSimpleFilter(
                  context,
                  (filter) =>
                      SelectionViewSimpleSingleListExamplePage('单列单选', filter),
                ),
              ),
              ListItem(
                title: '单列多选',
                onPressed: () => _openSimpleFilter(
                  context,
                  (filter) =>
                      SelectionViewSimpleMultiCheckExamplePage('单列多选', filter),
                ),
              ),
              ListItem(
                title: '多列筛选',
                describe: '一列、两列及三列筛选菜单',
                onPressed: () => _openFilterList(
                  context,
                  'assets/multi_list_filter.json',
                  (filters) =>
                      SelectionViewMultiListExamplePage('多列筛选', filters),
                ),
              ),
              ListItem(
                title: '范围筛选',
                describe: '一个或两个 Range 的标签样式展示',
                onPressed: () => _openFilterList(
                  context,
                  'assets/multi_range_filter.json',
                  (filters) =>
                      SelectionViewMultiRangeExamplePage('范围筛选', filters),
                ),
              ),
              ListItem(
                title: '日期筛选',
                describe: '日期与日期范围选择',
                onPressed: () => _openFilterList(
                  context,
                  'assets/date_range_filter.json',
                  (filters) =>
                      SelectionViewDateRangeExamplePage('日期筛选', filters),
                ),
              ),
              ListItem(
                title: '日期自定义筛选',
                describe: '自定义日期筛选参数',
                onPressed: () => _openFilterList(
                  context,
                  'assets/date_range_filter.json',
                  (filters) =>
                      SelectionViewDateFilterExamplePage('日期自定义筛选', filters),
                ),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '更多与自定义筛选',
          description: '更多面板、拦截回调及自定义内容',
          child: Column(
            children: [
              ListItem(
                title: '更多筛选',
                onPressed: () => _openFilterList(
                  context,
                  'assets/more_filter.json',
                  (filters) =>
                      SelectionViewMoreFilterExamplePage('更多筛选', filters),
                ),
              ),
              ListItem(
                title: 'customHandle 筛选',
                describe: '拦截回调并设置参数',
                onPressed: () => _openFilterList(
                  context,
                  'assets/customhandle_filter.json',
                  (filters) => SelectionViewCustomHandleFilterExamplePage(
                    'customHandle 筛选',
                    filters,
                  ),
                ),
              ),
              ListItem(
                title: '自定义筛选弹层',
                onPressed: () => _openFilterList(
                  context,
                  'assets/customview_filter.json',
                  (filters) =>
                      SelectionViewCustomViewExamplePage('自定义筛选弹层', filters),
                ),
              ),
              ListItem(
                title: '弹层关闭与点击拦截',
                onPressed: () => _openFilterList(
                  context,
                  'assets/multi_list_filter.json',
                  (filters) => SelectionViewCloseOrInterceptorExamplePage(
                    '弹层关闭与点击拦截',
                    filters,
                  ),
                ),
              ),
              ListItem(
                title: '更多筛选跳转二级页面',
                onPressed: () => _openFilterList(
                  context,
                  'assets/more_custom_floating_layer_filter.json',
                  (filters) => SelectionViewMoreCustomFloatLayerExamplePage(
                    '更多筛选跳转二级页面',
                    filters,
                  ),
                ),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '选择限制与布局',
          description: '最大选择数量及平铺标签布局',
          child: Column(
            children: [
              ListItem(
                title: '限制最大选择数量',
                describe: '最多选择 5 项',
                onPressed: () => _openFilterList(
                  context,
                  'assets/list_filter_maxcount_test.json',
                  (filters) {
                    filters.removeAt(0);
                    filters.removeAt(1);
                    _configureMaxSelectedCount(filters.first, 5);
                    return SelectionViewLimitMaxSelectedCountExamplePage(
                      '限制最大选择数量',
                      filters,
                    );
                  },
                ),
              ),
              ListItem(
                title: '平铺筛选',
                describe: '每行展示 3、4 或 5 个标签',
                onPressed: () =>
                    _openPage(context, const FlatSelectionEntryPage()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _openSimpleFilter(
    BuildContext context,
    Widget Function(SantoFilterEntity filter) pageBuilder,
  ) {
    rootBundle.loadString('assets/multi_list_filter.json').then((data) {
      final filter = SantoFilterEntity.fromJson(
        (jsonDecode(data) as Map<String, dynamic>)['data']['list'][0],
      );
      _openPage(context, pageBuilder(filter));
    });
  }

  void _openFilterList(
    BuildContext context,
    String asset,
    Widget Function(List<SantoSelectionEntity> filters) pageBuilder,
  ) {
    rootBundle.loadString(asset).then((data) {
      final filters = SantoSelectionEntityListBean.fromJson(
        (jsonDecode(data) as Map<String, dynamic>)['data'],
      )!.list!;
      _openPage(context, pageBuilder(filters));
    });
  }

  void _openPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  void _configureMaxSelectedCount(SantoSelectionEntity entity, int maxCount) {
    entity.maxSelectedCount = maxCount;
    for (final child in entity.children) {
      _configureMaxSelectedCount(child, maxCount);
    }
  }
}
