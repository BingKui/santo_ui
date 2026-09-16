import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';
import 'package:example/sample/home/rule_panel.dart';

class SantoSmallOutlineButtonExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(
        title: '小边框按钮',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
RulePanel(
            '按钮的最小宽度为84，按钮的高度为32，按钮的背景色白色，按钮的圆角为2。左右边距8\n'
                  '按钮的文案最多居中显示一行，字号14号，文字颜色为222222。',
            maxLines: 3),
SantoPanel(
            title: '正常案例',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: SantoSmallOutlineButton(
                      title: '提交',
                      onTap: () {
                        SantoToast.show('点击了按钮', context);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Expanded(
                    child: SantoSmallOutlineButton(
                      title: '提交',
                      onTap: () {
                        SantoToast.show('点击了按钮', context);
                      },
                    ),
                  )
                ],
              ),
            ),
            SantoSmallOutlineButton(
              title: '提交',
              onTap: () {
                SantoToast.show('点击了按钮', context);
              },
            )],
            ),
          ),
SantoPanel(
            title: '正常案例',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoSmallOutlineButton(
              title: '提交提交',
              onTap: () {
                SantoToast.show('点击了按钮', context);
              },
            )],
            ),
          ),
SantoPanel(
            title: '正常案例',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoSmallOutlineButton(
              lineColor: Colors.red,
              textColor: Colors.red,
              title: '驳回',
              onTap: () {
                SantoToast.show('点击了按钮', context);
              },
            )],
            ),
          ),
SantoPanel(
            title: '正常案例',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoSmallOutlineButton(
              title: '提交提交提交',
              onTap: () {
                SantoToast.show('点击了按钮', context);
              },
            )],
            ),
          ),
SantoPanel(
            title: '置灰案例',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoSmallOutlineButton(
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
            SantoSmallOutlineButton(
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
