import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class SwitchInputExamplePage extends StatefulWidget {

  SwitchInputExamplePage();

  @override
  State<StatefulWidget> createState() {
    return SwitchInputExampleState();
  }
}

class SwitchInputExampleState extends State<SwitchInputExamplePage>{

  bool _isFirstSwitchOn = true;
  bool _isSecondSwitchOn = true;
  bool _isThirdSwitchOn = true;

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
            SantoSwitchFormItem(
              title: "自然到访保护期",
              value: _isFirstSwitchOn,
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
                setState(() {
                  _isFirstSwitchOn = newValue;
                });
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
            SantoSwitchFormItem(
              prefixIconType: SantoPrefixIconType.add,
              isRequire: true,
              isEdit: true,
              error: "必填项不能为空",
              title: "自然到访保护期",
              subTitle: "这里是副标题",
              tipLabel: "标签",
              value: _isSecondSwitchOn,
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
                setState(() {
                  _isSecondSwitchOn = newValue;
                });
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
            SantoSwitchFormItem(
              prefixIconType: SantoPrefixIconType.add,
              isRequire: true,
              isEdit: false,
              title: "自然到访保护期",
              subTitle: "这里是副标题",
              tipLabel: "标签",
              value: _isThirdSwitchOn,
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
                setState(() {
                  _isThirdSwitchOn = newValue;
                });
                SantoToast.show(
                    "点击触发回调${oldValue}_${newValue}_onChanged", context);
              },
            ),
          ],
    );
  }

}
