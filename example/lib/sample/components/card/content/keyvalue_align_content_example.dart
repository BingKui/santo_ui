

import 'dart:math';

import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

class TextContentExample extends StatefulWidget {
  @override
  _TextContentExampleState createState() => _TextContentExampleState();
}

class _TextContentExampleState extends State<TextContentExample> {
  late List<SantoInfoModal> list;

  @override
  void initState() {
    super.initState();
    list = [
      SantoInfoModal(keyPart: "名称：", valuePart: "内容内容内容内容"),
      SantoInfoModal(keyPart: "名称名：", valuePart: "内容内容内容内容内容"),
      SantoInfoModal(keyPart: "名称名称名：", valuePart: "内容内容内容内容内容"),
      SantoInfoModal(keyPart: "名称名称名：", valuePart: "内容内容内容内容内容"),
      SantoInfoModal(keyPart: "名称名称名：", valuePart: "内容内容内容内容内容"),
      SantoInfoModal(keyPart: "名称名称名：", valuePart: "内容内容内容内容内容"),
      SantoInfoModal(
          keyPart: "名称名称名称名称：",
          valuePart: "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容"),
      SantoInfoModal.valueLastClickInfo(context,"名称名：", '内容内容内容内容内容', '可点击内容',
          clickCallback: (text) {
        SantoToast.show(text!, context);
      })
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(      title: '单列展示左对齐',
      children: <Widget>[
ExampleIntro('card'),
SantoSection(
        title: '正常案例',
        description: 'valuePart 左对齐展示，可组合 Row 追加尾部金额，点击整块区域弹出提示',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        GestureDetector(
          onTap: () {
            SantoToast.show('点击', context);
          },
          child: SantoPairInfoTable(
            children: <SantoInfoModal>[
              SantoInfoModal(keyPart: "名称：", valuePart: "内容内容内容内容"),
              SantoInfoModal(
                  keyPart: "名称名称名：",
                  valuePart: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '测试 valuevalu内容内容valuevalu内容内容',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF17233D),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        '2000元',
                        style: TextStyle(
                          color: Color(0xFF17233D),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      )
                    ],
                  )),
              SantoInfoModal(
                  keyPart: "名称名称名：",
                  valuePart: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '测试 valueva',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF17233D),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        '2000元',
                        style: TextStyle(
                          color: Color(0xFF17233D),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      )
                    ],
                  )),
              SantoInfoModal(
                  keyPart: "名称名称名：",
                  valuePart: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '测试 valuevalu内容内容',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF17233D),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        '2000元',
                        style: TextStyle(
                          color: Color(0xFF17233D),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      )
                    ],
                  )),
              SantoInfoModal(
                  keyPart: "名称名称名：",
                  valuePart: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '测试 valuevalu内容',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF17233D),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        '2000元',
                        style: TextStyle(
                          color: Color(0xFF17233D),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      )
                    ],
                  )),
              SantoInfoModal(
                  keyPart: "总费用：",
                  valuePart: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF17233D),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        '8000元',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      )
                    ],
                  )),
            ],
          ),
        )],
        ),
      ),
SantoSection(
        title: '正常案例',
        description: 'SantoPairInfoTable 对齐两列展示，value 过长时自动换行不截断',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        SantoPairInfoTable(
          children: <SantoInfoModal>[
            SantoInfoModal(keyPart: "名称：", valuePart: "内容内容内容内容"),
            SantoInfoModal(keyPart: "名称名：", valuePart: "内容内容内容内容内容"),
            SantoInfoModal(keyPart: "名称名称名：", valuePart: "内容内容内容内容内容"),
            SantoInfoModal(
                keyPart: "名称名称名称名称：",
                valuePart: "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容"),
          ],
        )],
        ),
      ),
SantoSection(
        title: '正常案例',
        description: 'valueLastClickInfo 构造可点击文案，点击后弹出提示',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        GestureDetector(
          onTap: () {
            SantoToast.show('点击了卡片', context);
          },
          child: SantoPairInfoTable(
            children: <SantoInfoModal>[
              SantoInfoModal(keyPart: "名称1：", valuePart: "内容内容内容内容"),
              SantoInfoModal(keyPart: "名称名：", valuePart: "内容内容内容内容内容"),
              SantoInfoModal(keyPart: "名称名称名：", valuePart: "内容内容内容内容内容"),
              SantoInfoModal(
                  keyPart: "名称名称名称名称：",
                  valuePart: "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容"),
              SantoInfoModal.valueLastClickInfo(context,
                  "名称名：", '11111111', '22222222', clickCallback: (text) {
                SantoToast.show(text!, context);
              }),
            ],
          ),
        )],
        ),
      ),
SantoSection(
        title: '正常案例',
        description: 'expandAtIndex 指定折叠起始行，isFolded 为 false 时默认展开',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        SantoPairInfoTable(
          expandAtIndex: 3,
          isFolded: false,
          children: <SantoInfoModal>[
            SantoInfoModal(keyPart: "名称：", valuePart: "内容内容内容内容"),
            SantoInfoModal(keyPart: "名称名：", valuePart: "内容内容内容内容内容"),
            SantoInfoModal(keyPart: "名称名称名：", valuePart: "内容内容内容内容内容"),
            SantoInfoModal(keyPart: "名称名称名：", valuePart: "内容内容内容内容内容"),
            SantoInfoModal(keyPart: "名称名称名：", valuePart: "内容内容内容内容内容"),
            SantoInfoModal(keyPart: "名称名称名：", valuePart: "内容内容内容内容内容"),
            SantoInfoModal(
                keyPart: "名称名称名称名称：",
                valuePart: "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容"),
            SantoInfoModal.valueLastClickInfo(context,"名称名：", '内容内容内容内容内容', '可点击内容',
                clickCallback: (text) {
              SantoToast.show(text!, context);
            }),
          ],
        )],
        ),
      ),
SantoSection(
        title: '正常案例：动态追加',
        description: '点击更多动态追加数据，列表随 children 变化实时刷新',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Stack(
          children: <Widget>[
            SantoPairInfoTable(
              children: list,
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      list.add(
                        SantoInfoModal(keyPart: "名称：", valuePart: "内容内容内容内容"),
                      );
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 30),
                    alignment: Alignment.center,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: Text(
                            '更多',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF808695),
                            ),
                          ),
                        ),
                        Transform.rotate(
                            angle: pi,
                            child: SantoIcon(SantoIcons.navArrowUp)),
                      ],
                    ),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      colors: [
                        Colors.white.withAlpha(100),
                        Colors.white,
                        Colors.white
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )),
                  ),
                )),
          ],
        )],
        ),
      ),
SantoSection(
        title: '正常案例：动态收起',
        description: '点击收起移除最后一条数据，观察列表收缩后的表现',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Stack(
          children: <Widget>[
            SantoPairInfoTable(
              children: list,
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      list.removeLast();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 30),
                    alignment: Alignment.center,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: Text(
                            '收起',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF808695),
                            ),
                          ),
                        ),
                        Transform.rotate(
                            angle: pi,
                            child: SantoIcon(SantoIcons.navArrowDown)),
                      ],
                    ),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      colors: [
                        Colors.white.withAlpha(100),
                        Colors.white,
                        Colors.white
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )),
                  ),
                )),
          ],
        )],
        ),
      ),
SantoSection(
        title: '异常案例：key过长',
        description: 'key 超长时 key 列按换行撑开宽度，value 仍保持左对齐',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        SantoPairInfoTable(
          children: <SantoInfoModal>[
            SantoInfoModal(keyPart: "名称：", valuePart: "内容内容内容内容"),
            SantoInfoModal(keyPart: "名称名：", valuePart: "内容内容内容内容内容"),
            SantoInfoModal(
                keyPart: "11111111111111111111111111111111111：",
                valuePart: "内容内容内容内容内容"),
            SantoInfoModal(keyPart: "名称名称名：", valuePart: "内容内容内容内容内容"),
            SantoInfoModal.valueLastClickInfo(context,
                "名称十分的长名称十分的长名称十分的长名称十分的长：", '内容内容内容内容内容', '可点击内容',
                clickCallback: (text) {
              SantoToast.show(text!, context);
            }),
          ],
        )],
        ),
      ),
SantoSection(
        title: '异常案例：内容过长',
        description: 'value 超长时自动换行，验证内容不会溢出或遮挡其它行',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        SantoPairInfoTable(
          children: <SantoInfoModal>[
            SantoInfoModal(
                keyPart: "名称：",
                valuePart: "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容"),
            SantoInfoModal(keyPart: "名称名：", valuePart: "内容内容内容内容内容"),
            SantoInfoModal(keyPart: "名称正常：", valuePart: "内容内容内容内容内容"),
            SantoInfoModal(
                keyPart: "名称名称名：",
                valuePart: "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容"),
            SantoInfoModal.valueLastClickInfo(context,
                "名称十分的长名称十分的长名称十分的长名称十分的长：",
                '内容内容内容内容内容',
                '可点击内容可点击内容可点击内容可点击内容可点击内容可点击内容', clickCallback: (text) {
              SantoToast.show(text!, context);
            }),
          ],
        )],
        ),
      ),
SantoSection(
        title: '异常案例某个元素缺失',
        description: 'keyPart 与 valuePart 缺失或为空时的兜底占位展示',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        SantoPairInfoTable(
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
