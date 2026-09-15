

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class SantoActionTitleExample extends StatefulWidget {
  @override
  _SantoActionTitleExampleState createState() => _SantoActionTitleExampleState();
}

class _SantoActionTitleExampleState extends State<SantoActionTitleExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SantoAppBar(
        title: '箭头标题',
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
              maxLines: 4,
              text: '标题不可以折行，当辅助widget和subwidget过多时，标题...截断\n'
                  '展示出sub和ac\n'
                  '标题字体为18',
            )],
            ),
          ),
SantoPanel(
            title: '正常案例',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoActionCardTitle(
              title: '表头',
              onTap: () {
                SantoToast.show('SantoActionCardTitle is clicked', context);
              },
            ),
            SantoLine(
              height: 2,
              color: Colors.black12,
            )],
            ),
          ),
SantoPanel(
            title: '正常案例（自定义副标题Widget）',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoActionCardTitle(
              title: '非箭头',
              //标题右侧widget
              subTitleWidget: Row(
                textBaseline: TextBaseline.ideographic,
                children: <Widget>[
                  Text(
                    '副标题',
                    style: TextStyle(color: Colors.red),
                  ),
                  SantoStateTag(tagText: '状态标签'),
                ],
              ),
              //整个widget的点击
              onTap: () {
                SantoToast.show('SantoPlainCardTitle is clicked', context);
              },
            ),
            SantoLine(
              height: 2,
              color: Colors.black12,
            )],
            ),
          ),
SantoPanel(
            title: '正常案例',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoActionCardTitle(
              title: '非箭头',
              //标题右侧widget
              subTitle: "副标题",
              //整个widget的点击
              accessoryText: "点击标题",
              onTap: () {
                SantoToast.show('SantoPlainCardTitle is clicked', context);
              },
            ),
            SantoLine(
              height: 2,
              color: Colors.black12,
            )],
            ),
          ),
SantoPanel(
            title: '正常案例',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoActionCardTitle(
              title: '标题特别长特别长特别长特别长特别长特别长特别长特别长',
              //标题右侧widget
              subTitle: "副标题",
              //整个widget的点击
              accessoryText: "点击标题",
              onTap: () {
                SantoToast.show('SantoPlainCardTitle is clicked', context);
              },
            ),
            SantoLine(
              height: 2,
              color: Colors.black12,
            )],
            ),
          ),
SantoPanel(
            title: '异常案例：title特别长',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoActionCardTitle(
              title: '标题特别长特别长特别长特别长特别长特别长特别长特别长',
              //标题右侧widget
//              subTitle: "副标题",
              //整个widget的点击
              accessoryText: "点击标题",
              onTap: () {
                SantoToast.show('SantoActionCardTitle is clicked', context);
              },
            ),
            SantoLine(
              height: 2,
              color: Colors.black12,
            )],
            ),
          ),
SantoPanel(
            title: '异常案例：副标题特别长',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoActionCardTitle(
              title: '标题特别',
              //标题右侧widget
              subTitle: "副标题也特别长特别长长特别长特别长特别长特别长",
              //整个widget的点击
              accessoryText: "点击标题",
              onTap: () {
                SantoToast.show('SantoActionCardTitle is clicked', context);
              },
            ),
            SantoLine(
              height: 2,
              color: Colors.black12,
            )],
            ),
          ),
SantoPanel(
            title: '异常案例：跳转标题特别长',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoActionCardTitle(
              title: '标题特别',
              //标题右侧widget
              subTitle: "副标题",
              //整个widget的点击
              accessoryText: "点击标题特别长特别长特别长特别长特别长特别长",
              onTap: () {
                SantoToast.show('SantoActionCardTitle is clicked', context);
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
