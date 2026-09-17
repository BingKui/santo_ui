import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/components/action_bar/action_bar_basic_example.dart';
import 'package:example/sample/components/action_bar/action_bar_bottom_example.dart';
import 'package:example/sample/home/list_item.dart';
import 'package:flutter/material.dart';

/// ActionBar 底部操作栏示例入口
class ActionBarExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'ActionBar 操作栏',
        children: <Widget>[
          ListItem(
            title: '基础用法',
            isShowLine: false,
            describe: '图标按钮与按钮混排、角标、类型与状态',
            onPressed: () => _push(context, ActionBarBasicExample()),
          ),
          ListItem(
            title: '吸底用法',
            describe: '作为 Scaffold.bottomNavigationBar 贴在页面底部',
            onPressed: () => _push(context, ActionBarBottomExample()),
          ),
        ],
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
