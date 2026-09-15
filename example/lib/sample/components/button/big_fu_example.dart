import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class BigFuButtonExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SantoAppBar(
        title: '大辅助按钮',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
SantoPanel(
            title: '规则',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoBubbleText(
              maxLines: 3,
              text: '按钮宽度为屏幕宽度，按钮的高度为48，按钮的背景色主题色的5%透明度，按钮的圆角为4。\n'
                  '按钮的文案最多居中显示一行，字号16号，字体w500，文字颜色为主题色。',
            )],
            ),
          ),
SantoPanel(
            title: '正常案例',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoBigGhostButton(
              title: '提交',
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
            SantoBigGhostButton(
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
