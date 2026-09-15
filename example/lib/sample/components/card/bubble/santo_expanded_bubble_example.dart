

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class SantoBubbleExample2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(
        title: '气泡信息',
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
              text: '支持指定行数的展开收起，背景边框的圆角是4，左上角是特殊的形状，\n '
                  '文本的字号是14，颜色为深色',
            )],
            ),
          ),
SantoPanel(
            title: '正常案例',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoBubbleText(
              maxLines: 2,
              text: '推荐理由：“满五唯一”“临近地铁”“首付低”，多出折行显示，文字展开的样式文式文文字展开的样式文式文。问我',
              onExpanded: (isExpanded) {
                String str = isExpanded ? "展开了" : "收起了";
                SantoToast.show("我$str", context);
              },
            )],
            ),
          ),
SantoPanel(
            title: '异常案例文案过长',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoBubbleText(
              maxLines: 2,
              text:
                  '推荐理由：“满五唯一”“临近地铁”“首付低”，多出折行显示，文字展开的样式文。按钮的文案特别长按钮的文案特别长按钮的文案特别长按钮的文案特别长',
            )],
            ),
          ),
SantoPanel(
            title: '异常案例文案过少',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoBubbleText(
              text: '推荐理由',
            )],
            ),
          ),
SantoPanel(
            title: '异常案例文案长度为0',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoBubbleText(
              maxLines: 2,
              text: '',
            )],
            ),
          ),
],
        ),
      ),
    );
  }
}
