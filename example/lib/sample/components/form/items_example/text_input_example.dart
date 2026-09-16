

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class TextInputExamplePage extends StatelessWidget {

  TextInputExamplePage();

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
            SantoTextInputFormItem(
              controller: TextEditingController()..text = "300",
              title: "房屋总价",
              unit: "万",
              hint: "请输入",
              onTip: () {
                SantoToast.show("点击触发onTip回调", context);
              },
              onAddTap: () {
                SantoToast.show("点击触发onAddTap回调", context);
              },
              onRemoveTap: () {
                SantoToast.show("点击触发onRemoveTap回调", context);
              },
              onChanged: (newValue) {
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
            SantoTextInputFormItem(
              controller: TextEditingController()..text = "300",
              prefixIconType: SantoPrefixIconType.add,
              isRequire: true,
              isEdit: true,
              error: "必填项不能为空",
              title: "房屋总价",
              subTitle: "以建筑面积计算",
              tipLabel: "贷款计算",
              unit: "万",
              hint: "请输入",
              onTip: () {
                SantoToast.show("点击触发onTip回调", context);
              },
              onAddTap: () {
                SantoToast.show("点击触发onAddTap回调", context);
              },
              onRemoveTap: () {
                SantoToast.show("点击触发onRemoveTap回调", context);
              },
              onChanged: (newValue) {
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
            SantoTextInputFormItem(
              controller: TextEditingController()..text = "300",
              prefixIconType: SantoPrefixIconType.add,
              isRequire: true,
              isEdit: true,
              title: "房屋总价",
              subTitle: "以建筑面积计算",
              tipLabel: "贷款计算",
              unit: "万",
              hint: "请输入",
              onTip: () {
                SantoToast.show("点击触发onTip回调", context);
              },
              onAddTap: () {
                SantoToast.show("点击触发onAddTap回调", context);
              },
              onRemoveTap: () {
                SantoToast.show("点击触发onRemoveTap回调", context);
              },
              onChanged: (newValue) {
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
            SantoTextInputFormItem(
              controller: TextEditingController()..text = "300",
              prefixIconType: SantoPrefixIconType.add,
              isRequire: true,
              isEdit: false,
              isPrefixIconEnabled: true,
              title: "房屋总价",
              subTitle: "以建筑面积计算",
              tipLabel: "贷款计算",
              unit: "万",
              hint: "请输入",
              onTip: () {
                SantoToast.show("点击触发onTip回调", context);
              },
              onAddTap: () {
                SantoToast.show("点击触发onAddTap回调", context);
              },
              onRemoveTap: () {
                SantoToast.show("点击触发onRemoveTap回调", context);
              },
              onChanged: (newValue) {
                SantoToast.show("点击触发回调_${newValue}_onChanged", context);
              },
            ),
          ],
    );
  }
}
