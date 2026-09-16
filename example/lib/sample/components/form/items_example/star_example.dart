

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class StarInputExamplePage extends StatelessWidget {

  StarInputExamplePage();

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Text(
                "基本样式：",
                style: TextStyle(
                  color: Color(0xFF17233D),
                  fontSize: 22,
                ),
              ),
            ),
            SantoStarsFormItem(
              title: "自然到访保护期",
              sumStar: 5,
              value: 2,
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
                  color: Color(0xFF17233D),
                  fontSize: 22,
                ),
              ),
            ),
            SantoStarsFormItem(
              prefixIconType: SantoPrefixIconType.add,
              isRequire: true,
              isEdit: true,
              error: "必填项不能为空",
              title: "自然到访保护期",
              subTitle: "这里是副标题",
              tipLabel: "",
              sumStar: 4,
              value: 2,
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
                  color: Color(0xFF17233D),
                  fontSize: 22,
                ),
              ),
            ),
            SantoStarsFormItem(
              prefixIconType: SantoPrefixIconType.remove,
              isRequire: true,
              isEdit: true,
              title: "自然到访保护期",
              subTitle: "这里是副标题",
              tipLabel: "",
              sumStar: 4,
              value: 2,
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
          ],
    );
  }
}
