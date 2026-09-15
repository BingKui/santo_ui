import 'package:flutter/material.dart';

import 'package:santo_ui/santo_ui.dart';

class GeneralFormExamplePage extends StatelessWidget {
  final String _title;

  GeneralFormExamplePage(this._title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SantoAppBar(
          title: _title,
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Text(
                "基本样式：",
                  style: TextStyle(
                    color: Color(0xFF222222),
                    fontSize: 22,
                  )),
            ),
            SantoGeneralFormItem(
              title: "自然到访保护期",
              subTitle: "这里是副标题",
              onTip: () {
                SantoToast.show("点击触发onTip回调", context);
              },
              onAddTap: () {
                SantoToast.show("点击触发onAddTap回调", context);
              },
              onRemoveTap: () {
                SantoToast.show("点击触发onRemoveTap回调", context);
              },
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
              child: Text(
                "全功能样式：",
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 22,
                ),
              ),
            ),
            SantoGeneralFormItem(
              prefixIconType: SantoPrefixIconType.add,
              isRequire: true,
              isEdit: true,
              error: "必填项不能为空",
              titleWidget: Text("自然到访保护期"),
              subTitleWidget: Text("这里是副标题"),
              tipLabel: "标签",
              operateWidget: Text("右侧操作区"),
              onTip: () {
                SantoToast.show("点击触发onTip回调", context);
              },
              onAddTap: () {
                SantoToast.show("点击触发onAddTap回调", context);
              },
              onRemoveTap: () {
                SantoToast.show("点击触发onRemoveTap回调", context);
              },
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
              child: Text(
                "no error：",
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 22,
                ),
              ),
            ),
            SantoGeneralFormItem(
              prefixIconType: SantoPrefixIconType.add,
              isRequire: true,
              isEdit: true,
              titleWidget: Text("自然到访保护期"),
//              subTitleWidget: Text("这里是副标题"),
              tipLabel: "标签",
              operateWidget: Text("右侧操作区"),

              onTip: () {
                SantoToast.show("点击触发onTip回调", context);
              },
              onAddTap: () {
                SantoToast.show("点击触发onAddTap回调", context);
              },
              onRemoveTap: () {
                SantoToast.show("点击触发onRemoveTap回调", context);
              },
            ),
          ],
        ));
  }
}
