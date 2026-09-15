

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class SantoTwoRichContentExample extends StatefulWidget {
  @override
  _SantoTwoRichContentExampleState createState() =>
      _SantoTwoRichContentExampleState();
}

class _SantoTwoRichContentExampleState extends State<SantoTwoRichContentExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SantoAppBar(
        title: '两列复杂文本',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '规则',
              style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            SantoBubbleText(
              maxLines: 4,
              text: '两组key-value内容平分屏幕，每一组key-value都是一行展示，'
                  'value紧挨着key，不考虑对齐',
            ),
            Text(
              '正常案例',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
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
            ),
            Text(
              '异常案例：key过长',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
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
            ),
            Text(
              '异常案例：内容过长',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
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
            ),
            Text(
              '异常案例：Key和Value过长',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            SantoRichInfoGrid(
              pairInfoList: <SantoRichGridInfo>[
                SantoRichGridInfo("名称名称：", '内容内容内容内容'),
                SantoRichGridInfo.valueLastClickInfo(context,
                    "名称名称名称名称名称名称名称名称名称：", '内容内容内容内容内容内容内容内容内容内容内容'),
                SantoRichGridInfo("名称：", '内容内容'),
                SantoRichGridInfo("名称：", '内容'),
              ],
            ),
            Text(
              '异常案例：可点击内容过长',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
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
    );
  }
}
