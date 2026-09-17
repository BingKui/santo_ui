import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/card_data_config.dart';
import 'package:example/sample/home/group_list_page.dart';
import 'package:flutter/material.dart';

/// 主页面:AppLayout 承载底部悬浮菜单栏,每个菜单对应一个组件分组页
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groups = CardDataConfig.getAllGroup();
    return SantoAppLayout(
      items: [
        for (final group in groups) _buildItem(group),
      ],
    );
  }

  SantoAppLayoutItem _buildItem(GroupInfo group) {
    final icon = group.icon;
    final unselectedIcon = group.unselectedIcon ?? icon;
    return SantoAppLayoutItem(
      text: group.shortName ?? group.groupName,
      selectedIcon: icon == null ? null : Icon(icon),
      unselectedIcon: unselectedIcon == null ? null : Icon(unselectedIcon),
      page: GroupListPage(key: ValueKey(group.groupName), group: group),
    );
  }
}
