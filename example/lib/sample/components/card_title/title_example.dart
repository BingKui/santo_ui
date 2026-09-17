

import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/components/card_title/santo_action_title_example.dart';
import 'package:example/sample/components/card_title/santo_common_title_example.dart';
import 'package:example/sample/components/tabbar/santo_switch_title_example.dart';
import 'package:example/sample/components/tabbar/sub_switch_title_example.dart';
import 'package:example/sample/home/list_item.dart';
import 'package:flutter/material.dart';

class TitleExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: "标题示例",
      padding: EdgeInsets.zero,
      scrollable: false,
      child: ListView(
        children: [
          ListItem(
            title: "普通标题",
            isShowLine: false,
            describe: '标题+辅助widget+底部详细信息',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return SantoCommonTitleExample();
                },
              ));
            },
          ),
          ListItem(
            title: "箭头标题",
            describe: '带有箭头的标题',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return SantoActionTitleExample();
                },
              ));
            },
          ),
          ListItem(
            title: "一级标题",
            describe: '标题下方可切换',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return SantoSwitchTitleExample();
                },
              ));
            },
          ),
          ListItem(
            title: "二级标题",
            describe: '标题下方可切换',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return SubSwitchTitleExample();
                },
              ));
            },
          ),
        ],
      ),
    );
  }
}
