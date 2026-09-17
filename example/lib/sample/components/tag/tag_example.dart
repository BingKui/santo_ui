

import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/components/tag/border_tag_example.dart';
import 'package:example/sample/components/tag/custom_tag_example.dart';
import 'package:example/sample/components/tag/delete_tag_example.dart';
import 'package:example/sample/components/tag/select_tag_example.dart';
import 'package:example/sample/components/tag/state_tag_example.dart';
import 'package:example/sample/components/tag/tag_row_example.dart';
import 'package:example/sample/home/list_item.dart';
import 'package:flutter/material.dart';

class TagExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: "标签示例",
        children: <Widget>[
          ListItem(
            title: "选择标签",
            isShowLine: false,
            describe: '可单选、多选标签',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return SelectTagExamplePage();
                },
              ));
            },
          ),
          ListItem(
            title: "删除标签",
            describe: '可删除的标签',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return DeleteTagExamplePage();
                },
              ));
            },
          ),
          ListItem(
            title: "自定义标签",
            describe: 'key宽度最多92,value是左对齐',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return CustomTagExample();
                },
              ));
            },
          ),
          ListItem(
            title: "状态标签",
            describe: '默认黄色，支持设置其他颜色',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return StateTagExample();
                },
              ));
            },
          ),
          ListItem(
            title: "带边框颜色",
            describe: '默认主题色，支持设置其他颜色',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return BorderTagExample();
                },
              ));
            },
          ),
          ListItem(
            title: "标签组",
            describe: '多个标签组合在一起标签',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return RowTagExample();
                },
              ));
            },
          ),
        ],
    );
  }
}
