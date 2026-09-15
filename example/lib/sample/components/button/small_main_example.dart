import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class SantoSmallMainButtonExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(
        title: '小主按钮',
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
              text: '按钮的最小宽度为84，按钮的高度为32，按钮的背景色主题色，按钮的圆角为2。左右边距8\n'
                  '按钮的文案最多居中显示一行，字号14号，文字颜色为白色。',
            )],
            ),
          ),
SantoPanel(
            title: '正常案例',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoSmallMainButton(
              title: '提交',
              onTap: () {
                SantoToast.show('点击了按钮', context);
              },
            )],
            ),
          ),
SantoPanel(
            title: '正常案例 自定义颜色和点击',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoSmallMainButton(
              title: '提交',
              bgColor: Colors.amber,
            )],
            ),
          ),
SantoPanel(
            title: '正常案例',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoSmallMainButton(
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
            SantoSmallMainButton(
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
            SantoSmallMainButton(
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
            SantoSmallMainButton(
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
