

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';
import 'package:example/sample/home/rule_panel.dart';

class SantoCommonTitleExample extends StatefulWidget {
  @override
  _SantoCommonTitleExampleState createState() => _SantoCommonTitleExampleState();
}

class _SantoCommonTitleExampleState extends State<SantoCommonTitleExample> {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(      title: '普通标题',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
RulePanel(
          '标题可以折行展示，标题最右侧的widget 需要展示出来\n'
              '标题底部的detail 信息展示的长度是 折行的长度，只显示2行\n'
              '标题的文案和sub需要流式布局\n'
              'accessoryWidget的高度就是25，如果传入的widget过大会显示不全\n'
              '上下的间距是16',
          maxLines: 4),
SantoSection(
          title: '正常案例',
          description: 'title 搭配 accessoryText 展示辅助文案，onTap 响应整块点击',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          SantoCommonCardTitle(
            title: '标题',
            accessoryText: '辅助文本',
            onTap: () {
              SantoToast.show('SantoPlainCardTitle is clicked', context);
            },
          ),
          SizedBox(height: 50,)],
          ),
        ),
SantoSection(
          title: '正常案例',
          description: '副标题与最右侧支持自定义组件，detailTextString 展示详情文案',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          SantoCommonCardTitle(
            title: '非箭头Title',
            subTitleWidget: SantoRate(
              count: 2,
              selectedCount: 2,
            ),
            accessoryWidget: SantoStateTag(tagText: '状态标签'),
            detailTextString: '副标题副标题副标题',
            onTap: () {
              SantoToast.show('SantoPlainCardTitle is clicked', context);
            },
          ),
          SizedBox(height: 50,)],
          ),
        ),
SantoSection(
          title: '正常案例',
          description: 'accessoryText 与 accessoryWidget 同时传入，右侧组合展示效果',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          SantoCommonCardTitle(
            title: '非箭头Title',
            //标题右侧widget
            subTitleWidget: Icon(
              Icons.content_copy,
              size: 16,
              color: Colors.blue,
            ),
            accessoryText: '辅助功能',
            accessoryWidget: Icon(
              Icons.radio_button_checked,
              size: 16,
              color: Colors.blue,
            ),
            detailTextString: '字房产证地址与楼盘字房产证地址与楼盘字',
            //整个widget的点击
            onTap: () {
              SantoToast.show('SantoCommonCardTitle is clicked', context);
            },
          )],
          ),
        ),
],
      ),
    );
  }
}
