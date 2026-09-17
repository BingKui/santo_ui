import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/card_data_config.dart';
import 'package:example/sample/home/list_item.dart';
import 'package:flutter/material.dart';

import 'setting.dart';

/// 组件分组页:展示分组下的所有组件入口,由 AppLayout 的底部菜单切换
class GroupListPage extends StatelessWidget {
  /// 分组数据
  final GroupInfo group;

  const GroupListPage({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = group.children ?? <GroupInfo>[];
    return SantoPageLayout(
      // 列表项自带左右边距,页面不再叠加内边距
      padding: EdgeInsets.zero,
      appBar: SantoAppBar(
        title: group.groupName,
        automaticallyImplyLeading: false,
        actions: [
          SantoIconAction(
            iconPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return Setting();
                },
              ));
            },
            child: Image.asset(
              'assets/image/setting.png',
              scale: 3.0,
              height: 20,
              width: 20,
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 8),
          for (final child in children)
            Container(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: ListItem(
                isShowLine: false,
                title: child.groupName,
                describe: child.desc,
                onPressed: () {
                  if (child.navigatorPage != null) {
                    child.navigatorPage!(context);
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
