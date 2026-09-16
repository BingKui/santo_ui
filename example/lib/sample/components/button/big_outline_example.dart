import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';
import 'package:example/sample/home/rule_panel.dart';

class BigOutlineButtonExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(
        title: '大边框按钮',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
RulePanel(
            '按钮宽度为屏幕宽度，按钮的高度为48，按钮的背景色主题色，按钮的圆角为4。按钮的边框线为0xffD7D7D7\n'
                  '按钮的文案最多居中显示一行，字号16号，字体w500，文字颜色为0xff222222。',
            maxLines: 3),
SantoPanel(
            title: '正常案例',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Container(
              width: 100,
              child: SantoBigOutlineButton(
                title: '提交',
                onTap: () {
                  SantoToast.show('点击了按钮', context);
                },
              ),
            )],
            ),
          ),
SantoPanel(
            title: '正常案例 无点击事件',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoBigOutlineButton(
              title: '提交',
            )],
            ),
          ),
SantoPanel(
            title: '置灰案例',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoBigOutlineButton(
              title: '提交',
              isEnable: false,
              onTap: () {
                SantoToast.show('点击了按钮', context);
              },
            )],
            ),
          ),
SantoPanel(
            title: '文案过长',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoBigOutlineButton(
              title: '按钮的文案特别长按钮的文案特别长按钮的文案特别长按钮的文案特别长',
              onTap: () {
                SantoToast.show('点击了按钮', context);
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
