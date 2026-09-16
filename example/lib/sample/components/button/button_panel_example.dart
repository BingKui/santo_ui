import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';
import 'package:example/sample/home/rule_panel.dart';

class ButtonPanelExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(
        title: '小按钮集合',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RulePanel(
            '靠右的横排展示，每个按钮的间距是8，按钮的组的间距是16'
                  '，次按钮数目不超过两个时，优先展示主按钮，次按钮平分剩余空间，'
                  '次按钮超过两个时，显示更多，剩下的空间主次按钮平分',
            maxLines: 3),
            Text(
              '正常案例',
              style: TextStyle(
                color: Color(0xFF17233D),
                fontSize: 18,
              ),
            ),
            SantoButtonPanel(
              mainButtonName: '主按钮',
              mainButtonOnTap: () {
                SantoToast.show('主按钮点击', context);
              },
              secondaryButtonOnTap: (index) {
                SantoToast.show('第$index个次按钮点击了', context);
              },
            ),
            Text(
              '正常案例,主按钮disable',
              style: TextStyle(
                color: Color(0xFF17233D),
                fontSize: 18,
              ),
            ),
            SantoButtonPanel(
              mainButtonName: '主按钮',
              mainButtonOnTap: () {
                SantoToast.show('主按钮点击', context);
              },
              isMainBtnEnable: false,
              secondaryButtonNameList: ['次按钮1'],
              secondaryButtonOnTap: (index) {
                SantoToast.show('第$index个次按钮点击了', context);
              },
            ),
            Text(
              '正常案例',
              style: TextStyle(
                color: Color(0xFF17233D),
                fontSize: 18,
              ),
            ),
            SantoButtonPanel(
              mainButtonName: '主按钮',
              mainButtonOnTap: () {
                SantoToast.show('主按钮点击', context);
              },
              secondaryButtonNameList: ['次按钮1', '次按钮2'],
              secondaryButtonOnTap: (index) {
                SantoToast.show('第$index个次按钮点击了', context);
              },
            ),
            Text(
              '正常案例，配置次按钮1 disable',
              style: TextStyle(
                color: Color(0xFF17233D),
                fontSize: 18,
              ),
            ),
            SantoButtonPanel(
              mainButtonName: '主按钮',
              mainButtonOnTap: () {
                SantoToast.show('主按钮点击', context);
              },
              secondaryButtonList: [
                SantoButtonPanelConfig(name: '次按钮1', isEnable: false),
                SantoButtonPanelConfig(name: '次按钮2', isEnable: true)
              ],
              secondaryButtonOnTap: (index) {
                SantoToast.show('第$index个次按钮点击了', context);
              },
            ),
            Text(
              '异常案例：主按钮文字长',
              style: TextStyle(
                color: Color(0xFF17233D),
                fontSize: 18,
              ),
            ),
            SantoButtonPanel(
              mainButtonName: '主按钮主按钮主按钮主按钮主按钮主按钮主按钮',
              mainButtonOnTap: () {
                SantoToast.show('主按钮点击', context);
              },
              secondaryButtonNameList: ['次按钮1', '次按钮2'],
              secondaryButtonOnTap: (index) {
                SantoToast.show('第$index个次按钮点击了', context);
              },
            ),
            Text(
              '异常案例：次按钮文字长',
              style: TextStyle(
                color: Color(0xFF17233D),
                fontSize: 18,
              ),
            ),
            SantoButtonPanel(
              mainButtonName: '主按钮',
              mainButtonOnTap: () {
                SantoToast.show('主按钮点击', context);
              },
              secondaryButtonNameList: ['次按钮1', '次按钮次按钮次按钮次按钮次按钮次按钮次按钮'],
              secondaryButtonOnTap: (index) {
                SantoToast.show('第$index个次按钮点击了', context);
              },
            ),
            Text(
              '异常案例：次按钮多',
              style: TextStyle(
                color: Color(0xFF17233D),
                fontSize: 18,
              ),
            ),
            SantoButtonPanel(
              mainButtonName: '主按钮',
              mainButtonOnTap: () {
                SantoToast.show('主按钮点击', context);
              },
              secondaryButtonList: [
                SantoButtonPanelConfig(name: '次按钮1', isEnable: false),
                SantoButtonPanelConfig(name: '次按钮2', isEnable: true),
                SantoButtonPanelConfig(name: '次按钮3', isEnable: true),
                SantoButtonPanelConfig(name: '次按钮4', isEnable: false),
                SantoButtonPanelConfig(name: '次按钮5', isEnable: true),
              ],
              secondaryButtonOnTap: (index) {
                SantoToast.show('第$index个次按钮点击了', context);
              },
            ),
            Text(
              '异常案例：主按钮文字长',
              style: TextStyle(
                color: Color(0xFF17233D),
                fontSize: 18,
              ),
            ),
            SantoButtonPanel(
              mainButtonName: '主按钮主按钮主按钮主按钮主按钮主按钮主按钮主按钮主按钮主按钮',
              mainButtonOnTap: () {
                SantoToast.show('主按钮点击', context);
              },
              secondaryButtonNameList: [
                '次按钮1',
                '次按钮2',
                '次按钮3',
              ],
              secondaryButtonOnTap: (index) {
                SantoToast.show('第$index个次按钮点击了', context);
              },
            ),
            Text(
              '异常案例：次按钮文字长',
              style: TextStyle(
                color: Color(0xFF17233D),
                fontSize: 18,
              ),
            ),
            SantoButtonPanel(
              mainButtonName: '主按钮',
              mainButtonOnTap: () {
                SantoToast.show('主按钮点击', context);
              },
              popDirection: SantoPopupDirection.top,
              secondaryButtonNameList: [
                '次按钮次按钮次按钮次按钮次按钮次按钮次按钮次按钮',
                '次按钮2',
                '次按钮3',
                '次按钮4',
                '次按钮5',
                '次按钮6',
              ],
              secondaryButtonOnTap: (index) {
                SantoToast.show('第$index个次按钮点击了', context);
              },
            ),
            Text(
              '异常案例：字符串长度为0',
              style: TextStyle(
                color: Color(0xFF17233D),
                fontSize: 18,
              ),
            ),
            SantoButtonPanel(
              mainButtonName: '',
              mainButtonOnTap: () {
                SantoToast.show('主按钮点击', context);
              },
              secondaryButtonNameList: [
                '',
                '',
                '',
              ],
              secondaryButtonOnTap: (index) {
                SantoToast.show('第$index个次按钮点击了', context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
