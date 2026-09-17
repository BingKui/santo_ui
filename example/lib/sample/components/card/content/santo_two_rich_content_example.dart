

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';
import 'package:example/sample/home/rule_panel.dart';

class SantoTwoRichContentExample extends StatefulWidget {
  @override
  _SantoTwoRichContentExampleState createState() =>
      _SantoTwoRichContentExampleState();
}

class _SantoTwoRichContentExampleState extends State<SantoTwoRichContentExample> {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(      title: '两列复杂文本',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
RulePanel(
          '两组key-value内容平分屏幕，每一组key-value都是一行展示，'
                'value紧挨着key，不考虑对齐',
          maxLines: 4),
SantoSection(
          title: '正常案例',
          description: 'SantoRichInfoGrid 两列展示，valueLastClickInfo 支持问号与可点击文案',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          SantoRichInfoGrid(
            pairInfoList: <SantoRichGridInfo>[
              SantoRichGridInfo("名称：", '内容内容内容内容'),
              SantoRichGridInfo("名称：", '内容内容内容'),
              SantoRichGridInfo("名称：", '内容内容'),
              SantoRichGridInfo.valueLastClickInfo(context,'名称', '内容内容',
                  keyQuestionCallback: (value) {
                SantoToast.show(value, context);
              }),
              SantoRichGridInfo.valueLastClickInfo(context,'名称', '内容内容',
                  valueQuestionCallback: (value) {
                SantoToast.show(value, context);
              }),
              SantoRichGridInfo.valueLastClickInfo(context,'名称', '内容内容',
                  valueQuestionCallback: (value) {
                    SantoToast.show(value, context);
                  },
                  clickTitle: "可点击内容",
                  clickCallback: (value) {
                    SantoToast.show(value, context);
                  }),
              SantoRichGridInfo.valueLastClickInfo(context,'名称', '内容内容',
                  clickTitle: "可点击内容", clickCallback: (value) {
                SantoToast.show(value, context);
              }),
            ],
          )],
          ),
        ),
SantoSection(
          title: '异常案例：key过长',
          description: 'key 超长时省略号截断，key 上的问号图标仍完整可见',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          SantoRichInfoGrid(
            pairInfoList: <SantoRichGridInfo>[
              SantoRichGridInfo.valueLastClickInfo(context,'名称名称名称名称名称名称名称', '内容内容',
                  keyQuestionCallback: (value) {
                SantoToast.show(value, context);
              }),
              SantoRichGridInfo("名称：", '内容内容内容'),
              SantoRichGridInfo("名称：", '内容内容'),
              SantoRichGridInfo("名称：", '内容'),
            ],
          )],
          ),
        ),
SantoSection(
          title: '异常案例：内容过长',
          description: 'value 超长时单行省略，key 上的问号提示不受影响',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          SantoRichInfoGrid(
            pairInfoList: <SantoRichGridInfo>[
              SantoRichGridInfo.valueLastClickInfo(context,
                  '名称名称', '内容内容内容内容内容内容内容内容内容内容内容',
                  keyQuestionCallback: (value) {
                SantoToast.show(value, context);
              }),
              SantoRichGridInfo("名称：", '内容内容内容内容内容内容内容内容内容内容内容'),
              SantoRichGridInfo("名称：", '内容内容'),
              SantoRichGridInfo("名称：", '内容'),
            ],
          )],
          ),
        ),
SantoSection(
          title: '异常案例：Key和Value过长',
          description: 'key 与 value 同时超长时各自省略，两列布局保持不变',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          SantoRichInfoGrid(
            pairInfoList: <SantoRichGridInfo>[
              SantoRichGridInfo("名称名称：", '内容内容内容内容'),
              SantoRichGridInfo.valueLastClickInfo(context,
                  "名称名称名称名称名称名称名称名称名称：", '内容内容内容内容内容内容内容内容内容内容内容'),
              SantoRichGridInfo("名称：", '内容内容'),
              SantoRichGridInfo("名称：", '内容'),
            ],
          )],
          ),
        ),
SantoSection(
          title: '异常案例：可点击内容过长',
          description: 'clickTitle 限宽 56 并省略号截断，问号提示仍可点击',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          SantoRichInfoGrid(
            pairInfoList: <SantoRichGridInfo>[
              SantoRichGridInfo("名称名称：", '内容内容内容内容'),
              SantoRichGridInfo.valueLastClickInfo(context,"名称名称名", '内容内容内容',
                  clickTitle: '可点击内容可点击内容可点击内容',
                  valueQuestionCallback: (value) {
                SantoToast.show(value, context);
              }),
              SantoRichGridInfo("名称：", '内容内容'),
              SantoRichGridInfo("名称：", '内容'),
            ],
          )
        ],
          ),
        ),
],
      ),
    );
  }
}
