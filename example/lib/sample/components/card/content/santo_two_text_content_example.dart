

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class SantoTextRIchContentExample extends StatefulWidget {
  @override
  _SantoTextRIchContentExampleState createState() =>
      _SantoTextRIchContentExampleState();
}

class _SantoTextRIchContentExampleState extends State<SantoTextRIchContentExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SantoAppBar(
        title: '两列纯文本',
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
              text: '两组key-value内容平分屏幕，每一组key-value都是一行展示，'
                  'value紧挨着key，不考虑对齐',
            )],
            ),
          ),
SantoPanel(
            title: '正常案例',
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
SantoPanel(
            title: '异常案例：key过长',
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
SantoPanel(
            title: '异常案例：内容过长',
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
SantoPanel(
            title: '异常案例：Key和Value过长',
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
SantoPanel(
            title: '特殊案例：Padding中',
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
SantoPanel(
            title: '特殊案例：Row中',
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
SantoPanel(
            title: '特殊案例：Column中',
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
SantoPanel(
            title: 'Pad 案例',
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
      ),
    );
  }
}
