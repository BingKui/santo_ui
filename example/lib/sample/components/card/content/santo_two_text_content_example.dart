

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';
import 'package:example/sample/home/rule_panel.dart';

class SantoTextRIchContentExample extends StatefulWidget {
  @override
  _SantoTextRIchContentExampleState createState() =>
      _SantoTextRIchContentExampleState();
}

class _SantoTextRIchContentExampleState extends State<SantoTextRIchContentExample> {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(      title: '两列纯文本',
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
          description: 'SantoRichInfoGrid 两列平分宽度，key 与 value 紧挨同行展示',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          SantoRichInfoGrid(
            pairInfoList: <SantoRichGridInfo>[
              SantoRichGridInfo("名称名称：", '内容内容内容内容'),
              SantoRichGridInfo("名称：", '内容内容内容'),
              SantoRichGridInfo("名称：", '内容内容'),
              SantoRichGridInfo("名称：", '内容'),
            ],
          )],
          ),
        ),
SantoSection(
          title: '异常案例：key过长',
          description: 'key 超过四分之一列宽后省略号截断，避免挤压 value',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          SantoRichInfoGrid(
            pairInfoList: <SantoRichGridInfo>[
              SantoRichGridInfo("名称名称名称名称名称名称名称名称：", '内容内容内容内容'),
              SantoRichGridInfo("名称：", '内容内容内容'),
              SantoRichGridInfo("名称：", '内容内容'),
              SantoRichGridInfo("名称：", '内容'),
            ],
          )],
          ),
        ),
SantoSection(
          title: '异常案例：内容过长',
          description: 'value 超长时单行省略号截断，不会撑高或挤压相邻项',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          SantoRichInfoGrid(
            pairInfoList: <SantoRichGridInfo>[
              SantoRichGridInfo("名称名称：", '内容内容内容内容'),
              SantoRichGridInfo("名称：", '内容内容内容内容内容内容内容内容内容内容内容'),
              SantoRichGridInfo("名称：", '内容内容'),
              SantoRichGridInfo("名称：", '内容'),
            ],
          )],
          ),
        ),
SantoSection(
          title: '异常案例：Key和Value过长',
          description: 'value 为 null 或空串时显示 -- 占位，rowSpace 调整行间距',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          SantoRichInfoGrid(
            rowSpace: 10,
            pairInfoList: <SantoRichGridInfo>[
              SantoRichGridInfo("名称名称：", null),
              SantoRichGridInfo(
                  "名称名称名称名称名称名称名称名称名称：", '内容内容内容内容内容内容内容内容内容内容内容'),
              SantoRichGridInfo("名称：", '内容内容'),
              SantoRichGridInfo("名称：", ''),
            ],
          )],
          ),
        ),
SantoSection(
          title: '特殊案例：Padding中',
          description: '外层 Padding 限制可用宽度后，网格仍能自适应排布',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: SantoRichInfoGrid(
              rowSpace: 10,
              pairInfoList: <SantoRichGridInfo>[
                SantoRichGridInfo("名称名称：", null),
                SantoRichGridInfo(
                    "名称名称名称名称名称名称名称名称名称：", '内容内容内容内容内容内容内容内容内容内容内容'),
                SantoRichGridInfo("名称：", '内容内容'),
                SantoRichGridInfo("名称：", ''),
              ],
            ),
          )],
          ),
        ),
SantoSection(
          title: '特殊案例：Row中',
          description: 'Row 中配合 Expanded 使用，验证网格宽度自适应',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Row(
            children: <Widget>[
              Text("我是自定义"),
              Expanded(
                child: SantoRichInfoGrid(
                  rowSpace: 10,
                  pairInfoList: <SantoRichGridInfo>[
                    SantoRichGridInfo("名称名称：", null),
                    SantoRichGridInfo(
                        "名称名称名称名称名称名称名称名称名称：", '内容内容内容内容内容内容内容内容内容内容内容'),
                    SantoRichGridInfo("名称：", '内容内容'),
                    SantoRichGridInfo("名称：", ''),
                  ],
                ),
              ),
            ],
          )],
          ),
        ),
SantoSection(
          title: '特殊案例：Column中',
          description: 'Column 中直接使用，验证竖向排布与宽度约束',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Column(
            children: <Widget>[
              SantoRichInfoGrid(
                rowSpace: 10,
                pairInfoList: <SantoRichGridInfo>[
                  SantoRichGridInfo("名称名称：", null),
                  SantoRichGridInfo(
                      "名称名称名称名称名称名称名称名称名称：", '内容内容内容内容内容内容内容内容内容内容内容'),
                  SantoRichGridInfo("名称：", '内容内容'),
                  SantoRichGridInfo("名称：", ''),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          )],
          ),
        ),
SantoSection(
          title: 'Pad 案例',
          description: '宽屏下 themeData 自定义文本样式，与上方加粗文案形成对比',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Container(
            padding: EdgeInsets.all(20),
            color: Colors.grey[100],
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
              child: Column(
                children: <Widget>[
                  SantoPairInfoTable(
                    children: <SantoInfoModal>[
                      SantoInfoModal(
                          keyPart: "名称：", valuePart: "加粗的内容，文字样式可配置"),
                      SantoInfoModal(keyPart: "名称名：", valuePart: "没加粗的内容"),
                      SantoInfoModal(
                          keyPart: "名称名称名：", valuePart: "内容内容内容内容内容"),
                      SantoInfoModal(
                        keyPart: "名称名称名称名称：",
                        valuePart: "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容",
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SantoRichInfoGrid(
                    themeData: SantoPairRichInfoGridConfig(
                        keyTextStyle: SantoTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff999999)),
                        valueTextStyle: SantoTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff999999),
                        )),
                    rowSpace: 10,
                    pairInfoList: <SantoRichGridInfo>[
                      SantoRichGridInfo("正常的名称：", '正常的内容'),
                      SantoRichGridInfo(
                          "名称名称名称名称名称名称名称名称名称：", '内容内容内容内容内容内容内容内容内容内容内容'),
                      SantoRichGridInfo("名称：", '内容内容内容内容内容内容内容内容内容内容内容内容'),
                      SantoRichGridInfo("名称：", ''),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SantoRichInfoGrid(
                    rowSpace: 10,
                    pairInfoList: <SantoRichGridInfo>[
                      SantoRichGridInfo("加粗的名称：", '加粗的内容'),
                      SantoRichGridInfo(
                          "名称名称名称名称名称名称名称名称名称：", '内容内容内容内容内容内容内容内容内容内容内容'),
                      SantoRichGridInfo("名称：", '内容内容内容内容内容内容内容内容内容内容内容内容'),
                      SantoRichGridInfo("名称：", ''),
                    ],
                  ),
                ],
              ),
            ),
          )],
          ),
        ),
],
      ),
    );
  }
}
