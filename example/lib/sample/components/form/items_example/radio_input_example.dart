

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class RadioInputExamplePage extends StatelessWidget {
  final String _title;

  RadioInputExamplePage(this._title);

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
                ),
              ),
            ),
            SantoRadioInputFormItem(
              title: "自然到访保护期",
              options: [
                "固定",
                "永久",
              ],
              value: "永久",
              onTip: () {
                SantoToast.show("点击触发onTip回调", context);
              },
              onAddTap: () {
                SantoToast.show("点击触发onAddTap回调", context);
              },
              onRemoveTap: () {
                SantoToast.show("点击触发onRemoveTap回调", context);
              },
              onChanged: (oldValue, newValue) {
                SantoToast.show(
                    "点击触发回调${oldValue}_${newValue}_onChanged", context);
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
            SantoRadioInputFormItem(
              prefixIconType: SantoPrefixIconType.add,
              isRequire: true,
              error: "必填项不能为空",
              title: "自然到访保护期",
              subTitle: "这里是副标题",
              options: [
                "固定",
                "永久",
              ],
              value: "永久",
              enableList: [true, false],
              onTip: () {
                SantoToast.show("点击触发onTip回调", context);
              },
              onAddTap: () {
                SantoToast.show("点击触发onAddTap回调", context);
              },
              onRemoveTap: () {
                SantoToast.show("点击触发onRemoveTap回调", context);
              },
              onChanged: (oldValue, newValue) {
                SantoToast.show(
                    "点击触发回调${oldValue}_${newValue}_onChanged", context);
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
            SantoRadioInputFormItem(
              prefixIconType: SantoPrefixIconType.remove,
              isRequire: true,
              title: "自然到访保护期",
              subTitle: "这里是副标题",
              options: [
                "固定",
                "永久",
              ],
              value: "永久",
              enableList: [true, true],
              onTip: () {
                SantoToast.show("点击触发onTip回调", context);
              },
              onAddTap: () {
                SantoToast.show("点击触发onAddTap回调", context);
              },
              onRemoveTap: () {
                SantoToast.show("点击触发onRemoveTap回调", context);
              },
              onChanged: (oldValue, newValue) {
                SantoToast.show(
                    "点击触发回调${oldValue}_${newValue}_onChanged", context);
              },
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
              child: Text(
                "autoLayout：",
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 22,
                ),
              ),
            ),
            SantoRadioInputFormItem.autoLayout(
              prefixIconType: SantoPrefixIconType.remove,
              isRequire: true,
              error: "必填项不能为空",
              title: "autoLayout",
              layoutRatio: 0.25,
              titleMaxLines: 3,
              subTitle: "这里是副标题",
              options: [
                "固定",
                "永久",
              ],
            ),
          ],
        ));
  }
}
