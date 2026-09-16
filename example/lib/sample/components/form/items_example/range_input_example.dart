

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class RangeInputExamplePage extends StatelessWidget {

  RangeInputExamplePage();

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
                  color: Color(0xFF222222),
                  fontSize: 22,
                ),
              ),
            ),
            SantoRangeInputFormItem(
              minController: TextEditingController()..text = "10",
              maxController: TextEditingController()..text = "100",
              title: "保护期",
              hintMin: "最小范围",
              hintMax: "最大范围",
              minUnit: "天",
              maxUnit: "天",
              leftMaxCount: 1,
              rightMaxCount: 3,
              inputType: SantoInputType.number,
              onTip: () {
                SantoToast.show("点击触发onTip回调", context);
              },
              onAddTap: () {
                SantoToast.show("点击触发onAddTap回调", context);
              },
              onRemoveTap: () {
                SantoToast.show("点击触发onRemoveTap回调", context);
              },
              onMinChanged: (newValue) {
                SantoToast.show("点击触发回调_${newValue}_onChanged", context);
              },
              onMaxChanged: (newValue) {
                SantoToast.show("点击触发回调_${newValue}_onChanged", context);
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
            SantoRangeInputFormItem(
              minController: TextEditingController()..text = "10",
              maxController: TextEditingController()..text = "100",
              prefixIconType: SantoPrefixIconType.add,
              isRequire: true,
              error: "必填项不能为空",
              title: "保护期",
              subTitle: "这里是副标题",
              tipLabel: "标签",
              isEdit: true,
              hintMin: "最小范围",
              hintMax: "最大范围",
              minUnit: "天",
              maxUnit: "天",
              leftMaxCount: 1,
              rightMaxCount: 3,
              inputType: SantoInputType.number,
              onTip: () {
                SantoToast.show("点击触发onTip回调", context);
              },
              onAddTap: () {
                SantoToast.show("点击触发onAddTap回调", context);
              },
              onRemoveTap: () {
                SantoToast.show("点击触发onRemoveTap回调", context);
              },
              onMinChanged: (newValue) {
                SantoToast.show("点击触发回调_${newValue}_onChanged", context);
              },
              onMaxChanged: (newValue) {
                SantoToast.show("点击触发回调_${newValue}_onChanged", context);
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
            SantoRangeInputFormItem(
              minController: TextEditingController()..text = "10",
              maxController: TextEditingController()..text = "100",
              prefixIconType: SantoPrefixIconType.add,
              isRequire: true,
              title: "保护期",
              subTitle: "这里是副标题",
              tipLabel: "标签",
              isEdit: true,
              hintMin: "最小范围",
              hintMax: "最大范围",
              minUnit: "天",
              maxUnit: "天",
              leftMaxCount: 2,
              rightMaxCount: 3,
              inputType: SantoInputType.number,
              onTip: () {
                SantoToast.show("点击触发onTip回调", context);
              },
              onAddTap: () {
                SantoToast.show("点击触发onAddTap回调", context);
              },
              onRemoveTap: () {
                SantoToast.show("点击触发onRemoveTap回调", context);
              },
              onMinChanged: (newValue) {
                SantoToast.show("点击触发回调_${newValue}_onChanged", context);
              },
              onMaxChanged: (newValue) {
                SantoToast.show("点击触发回调_${newValue}_onChanged", context);
              },
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
              child: Text(
                "禁用态下可添加删除：",
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 22,
                ),
              ),
            ),
            SantoRangeInputFormItem(
              minController: TextEditingController()..text = "10",
              maxController: TextEditingController()..text = "100",
              prefixIconType: SantoPrefixIconType.add,
              isRequire: true,
              title: "保护期",
              subTitle: "这里是副标题",
              tipLabel: "标签",
              isEdit: false,
              isPrefixIconEnabled: true,
              hintMin: "最小范围",
              hintMax: "最大范围",
              minUnit: "天",
              maxUnit: "天",
              leftMaxCount: 2,
              rightMaxCount: 3,
              inputType: SantoInputType.number,
              onTip: () {
                SantoToast.show("点击触发onTip回调", context);
              },
              onAddTap: () {
                SantoToast.show("点击触发onAddTap回调", context);
              },
              onRemoveTap: () {
                SantoToast.show("点击触发onRemoveTap回调", context);
              },
              onMinChanged: (newValue) {
                SantoToast.show("点击触发回调_${newValue}_onChanged", context);
              },
              onMaxChanged: (newValue) {
                SantoToast.show("点击触发回调_${newValue}_onChanged", context);
              },
            ),
          ],
    );
  }
}
