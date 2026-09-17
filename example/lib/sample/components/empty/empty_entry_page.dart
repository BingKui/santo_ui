

import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/components/empty/empty_example.dart';
import 'package:example/sample/home/list_item.dart';
import 'package:flutter/material.dart';

class EmptyEntryPage extends StatelessWidget {
  final _title;

  EmptyEntryPage(this._title);

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      appBar: SantoAppBar(
          title: _title,
        ),
        children: <Widget>[
          ListItem(
            title: "异常信息+操作",
            isShowLine: false,
            describe: '异常信息+操作',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return EmptyExample(
                    caseIndex: 0,
                  );
                },
              ));
            },
          ),
          ListItem(
            title: "异常信息居中展示",
            describe: '异常信息居中展示',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return EmptyExample(
                    caseIndex: 1,
                  );
                },
              ));
            },
          ),
          ListItem(
            title: "异常信息默认展示",
            describe: '异常信息默认展示',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return EmptyExample(
                    caseIndex: 2,
                  );
                },
              ));
            },
          ),
          ListItem(
            title: "大模块空态",
            describe: '大模块空态',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return EmptyExample(
                    caseIndex: 3,
                  );
                },
              ));
            },
          ),
          ListItem(
            title: "单按钮效果",
            describe: '单按钮效果',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return EmptyExample(
                    caseIndex: 4,
                  );
                },
              ));
            },
          ),
          ListItem(
            title: "双按钮效果",
            describe: '双按钮效果',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return EmptyExample(
                    caseIndex: 5,
                  );
                },
              ));
            },
          ),
          ListItem(
            title: "小模块空态",
            describe: '小模块空态',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return EmptyExample(
                    caseIndex: 6,
                  );
                },
              ));
            },
          ),
        ],
    );
  }
}
