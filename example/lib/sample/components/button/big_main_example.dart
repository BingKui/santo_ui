import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';
import 'package:example/sample/home/rule_panel.dart';

class BigMainButtonExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(
        title: '大主按钮',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            SantoBigMainButton(title: "登录", bgColor: Colors.red, themeData: SantoButtonConfig(
              bigButtonRadius: 255,
              bigButtonHeight: 50,
              bigButtonFontSize: 20,),),
RulePanel(
            '按钮宽度为屏幕宽度，按钮的高度为48，按钮的背景色主题色，按钮的圆角为4。\n'
                  '按钮的文案最多居中显示一行，字号16号，文字颜色为白色。',
            maxLines: 3),
SantoPanel(
            title: '正常案例',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoBigMainButton(
              title: '提交',
              onTap: () {
                SantoToast.show('点击了主按钮', context);
              },
            )],
            ),
          ),
SantoPanel(
            title: '正常案例 不响应点击事件',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoBigMainButton(
              title: '提交',
            )],
            ),
          ),
SantoPanel(
            title: '置灰案例',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoBigMainButton(
              title: '提交',
              isEnable: false,
              onTap: () {
                SantoToast.show('点击了主按钮', context);
              },
            )],
            ),
          ),
SantoPanel(
            title: '文案过长',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoBigMainButton(
              title: '主按钮的文案特别长主按钮的文案特别长主按钮的文案特别长主按钮的文案特别长',
              onTap: () {
                SantoToast.show('点击了主按钮', context);
              },
            ),
            SantoNormalButton(
              isEnable: false,
              alignment: Alignment.center,
              text: '主案特别长',
              onTap: () {
                SantoToast.show('点击了主按钮', context);
              },
            )],
            ),
          ),
],
        ),
      ),
    );
  }
}
