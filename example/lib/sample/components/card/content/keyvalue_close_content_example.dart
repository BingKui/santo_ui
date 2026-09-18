import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

class KeyTextCloseContentExample extends StatefulWidget {
  @override
  _KeyTextCloseContentExampleState createState() =>
      _KeyTextCloseContentExampleState();
}

class _KeyTextCloseContentExampleState
    extends State<KeyTextCloseContentExample> {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(      title: '单列展示紧随',
      children: <Widget>[
ExampleIntro('card'),
SantoSection(
        title: '正常案例',
        description: 'isValueAlign 为 false 时 key 与 value 同行紧随展示，单行不换行',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        SantoPairInfoTable(
          isValueAlign: false,
          children: <SantoInfoModal>[
            SantoInfoModal(keyPart: "名称：", valuePart: "内容内容内容内容"),
            SantoInfoModal(keyPart: "名称名：", valuePart: "内容内容内容内容内容"),
            SantoInfoModal(keyPart: "名称名称名：", valuePart: "内容内容内容内容内容"),
            SantoInfoModal(keyPart: "名称名称名称：", valuePart: "内容内容内容内容内容"),
          ],
        )],
        ),
      ),
SantoSection(
        title: '正常案例',
        description: '一行布局下 valueLastClickInfo 生成可点击文案并回调',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        GestureDetector(
          onTap: () {
            SantoToast.show("点击了卡片", context);
          },
          child: SantoPairInfoTable(
            isValueAlign: false,
            children: <SantoInfoModal>[
              SantoInfoModal(keyPart: "名称：", valuePart: "内容内容内容内容"),
              SantoInfoModal(keyPart: "名称名：", valuePart: "内容内容内容内容内容"),
              SantoInfoModal(keyPart: "名称名称名：", valuePart: "内容内容内容内容内容"),
              SantoInfoModal.valueLastClickInfo(context,"名称名：", '内容内容内容内容内容', '可点击内容',
                  clickCallback: (text) {
                SantoToast.show(text!, context);
              }),
            ],
          ),
        )],
        ),
      ),
SantoSection(
        title: '异常案例：key过长',
        description: 'key 超长时单行省略号截断，不会换行撑高卡片',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        SantoPairInfoTable(
          isValueAlign: false,
          children: <SantoInfoModal>[
            SantoInfoModal(keyPart: "名称：", valuePart: "内容内容内容内容"),
            SantoInfoModal(keyPart: "名称名：", valuePart: "内容内容内容内容内容"),
            SantoInfoModal(
                keyPart: "名称十分的长名称十分的长名称十分的长名称十分的长：",
                valuePart: "内容内容内容内容内容"),
            SantoInfoModal(
                keyPart: "名称十分的长名称十分的长名称十分的长名称十分的长十分的长：",
                valuePart: "内容内容内容内容内容"),
            SantoInfoModal(keyPart: "名称名称名：", valuePart: "内容内容内容内容内容"),
          ],
        )],
        ),
      ),
SantoSection(
        title: '异常案例：内容过长',
        description: 'value 超长时单行省略号截断，验证右侧内容不被挤压',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        SantoPairInfoTable(
          isValueAlign: false,
          children: <SantoInfoModal>[
            SantoInfoModal(
                keyPart: "名称：",
                valuePart: "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容"),
            SantoInfoModal(keyPart: "名称名：", valuePart: "内容内容内容内容内容"),
            SantoInfoModal(keyPart: "名称正常：", valuePart: "内容内容内容内容内容"),
            SantoInfoModal(
                keyPart: "名称名称名：",
                valuePart: "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容"),
            SantoInfoModal(
                keyPart: "名称名称名：",
                valuePart:
                    "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内"),
          ],
        )],
        ),
      ),
SantoSection(
        title: '异常案例：可点击内容过长',
        description: 'expandAtIndex 开启展开收起，clickTitle 超长时省略号截断',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        SantoPairInfoTable(
          isValueAlign: false,
          expandAtIndex: 2,
          children: <SantoInfoModal>[
            SantoInfoModal(
                keyPart: "名称：",
                valuePart: "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容"),
            SantoInfoModal(keyPart: "名称名：", valuePart: "内容内容内容内容内容"),
            SantoInfoModal(keyPart: "名称正常：", valuePart: "内容内容内容内容内容"),
            SantoInfoModal(
                keyPart: "名称名称名：",
                valuePart: "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容"),
            SantoInfoModal(
                keyPart: "名称名称名：",
                valuePart:
                    "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内"),
            SantoInfoModal.valueLastClickInfo(context,
                "名称十分的长名：", '内容内容内容内容内容', '可点击内容可点击内容可点击内容可点击内容',
                clickCallback: (text) {
              SantoToast.show(text!, context);
            }),
            SantoInfoModal.valueLastClickInfo(context,
                "名称十分的长名：",
                '内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容',
                '可点击内容可点击内容可点击内容可点击内容', clickCallback: (text) {
              SantoToast.show(text!, context);
            }),
          ],
        )],
        ),
      ),
SantoSection(
        title: '异常案例某个元素缺失',
        description: 'keyPart 与 valuePart 缺失或为空时仍保持单行布局',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        SantoPairInfoTable(
          isValueAlign: false,
          children: <SantoInfoModal>[
            SantoInfoModal(keyPart: "内容缺失：", valuePart: null),
            SantoInfoModal(keyPart: "", valuePart: "名称缺失"),
            SantoInfoModal(keyPart: "", valuePart: ""),
            SantoInfoModal(keyPart: "上面的都缺失：", valuePart: "内容内容内容内容内容"),
          ],
        )],
        ),
      ),
      ],
    );
  }
}
