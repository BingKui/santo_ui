

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';
import 'package:example/sample/home/rule_panel.dart';

class SantoActionTitleExample extends StatefulWidget {
  @override
  _SantoActionTitleExampleState createState() => _SantoActionTitleExampleState();
}

class _SantoActionTitleExampleState extends State<SantoActionTitleExample> {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
RulePanel(
          '标题不可以折行，当辅助widget和subwidget过多时，标题...截断\n'
                '展示出sub和ac\n'
                '标题字体为18',
          maxLines: 4),
SantoSection(
          title: '正常案例',
          description: 'onTap 使整块区域可点击，右侧固定展示跳转箭头',
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
SantoSection(
          title: '正常案例（自定义副标题Widget）',
          description: 'subTitleWidget 支持自定义副标题，可组合 SantoStateTag 等组件',
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
SantoSection(
          title: '正常案例',
          description: 'subTitle 展示副标题，accessoryText 在右侧展示跳转文案',
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
SantoSection(
          title: '正常案例',
          description: '标题过长时省略号截断，副标题与跳转文案保持完整',
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
SantoSection(
          title: '异常案例：title特别长',
          description: '省略 subTitle 时标题过长，只保留右侧跳转文案',
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
SantoSection(
          title: '异常案例：副标题特别长',
          description: 'subTitle 超过 84 限宽后省略，标题不受挤压',
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
SantoSection(
          title: '异常案例：跳转标题特别长',
          description: 'accessoryText 超长时按 84 限宽省略，箭头仍完整展示',
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
    );
  }
}
