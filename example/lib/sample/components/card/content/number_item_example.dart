

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';
import 'package:example/sample/home/rule_panel.dart';

class NumberItemRowExample extends StatefulWidget {
  @override
  _NumberItemRowExampleState createState() => _NumberItemRowExampleState();
}

class _NumberItemRowExampleState extends State<NumberItemRowExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(
        title: '数字信息',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
RulePanel(
            '数字信息是特殊字体，前后可携带正常字体\n'
                    '特殊字体的样式为28号字，正常字体为12号字\n'
                    '上下间距是8',
            maxLines: 4),
SantoPanel(
            title: '正常案例 只有一个Item',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              SantoEnhanceNumberCard(
                itemChildren: [
                  SantoNumberInfoItemModel(
                    title: '数字信息',
                    number: '3',
                  ),
                ],
              )],
            ),
          ),
SantoPanel(
            title: '正常案例',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              SantoEnhanceNumberCard(
                itemChildren: [
                  SantoNumberInfoItemModel(
                      title: '数字信息',
                      number: '3',
                      preDesc: '前',
                      lastDesc: '后',
                      numberInfoIcon: SantoNumberInfoIcon.arrow,
                      iconTapCallBack: (data) {}),
                ],
              )],
            ),
          ),
SantoPanel(
            title: '正常案例',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              SantoEnhanceNumberCard(
                rowCount: 3,
                itemChildren: [
                  SantoNumberInfoItemModel(
                      title: '数字信息数息数字信息数字信息数息数字信息数字信息数息数字信息',
                      number: '3',
                      preDesc: '前',
                      lastDesc: '后',
                      numberInfoIcon: SantoNumberInfoIcon.arrow,
                      iconTapCallBack: (data) {
                        SantoToast.show(data.title!, context);
                      }),
                  SantoNumberInfoItemModel(
                    title: '数字信息数字信息数字信息数字信息数字信息数字信息',
                    number: '3',
                    preDesc: '前',
                    lastDesc: '后',
                  ),
                  SantoNumberInfoItemModel(
                    title: '数字信息数字信息数字信息数字信息数字信息数字信息',
                    number: '3',
                    preDesc: '前',
                    lastDesc: '后',
                  ),
                  SantoNumberInfoItemModel(
                      title: '数字信息',
                      number: '3',
                      preDesc: '前',
                      lastDesc: '后',
                      iconTapCallBack: (data) {}),
                  SantoNumberInfoItemModel(
                    title: '数字信息',
                    number: '3',
                    preDesc: '前',
                    lastDesc: '后',
                  ),
                ],
              )],
            ),
          ),
SantoPanel(
            title: '正常案例',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              SantoEnhanceNumberCard(
                rowCount: 3,
                itemChildren: [
                  SantoNumberInfoItemModel(
                    title: '数字信息',
                    number: '3',
                    preDesc: '前',
                    lastDesc: '后',
                  ),
                  SantoNumberInfoItemModel(
                    title: '数字信息',
                    number: '3',
                    preDesc: '前',
                    lastDesc: '后',
                  ),
                  SantoNumberInfoItemModel(
                    title: '数字信息',
                    number: '3',
                    preDesc: '前',
                    lastDesc: '后',
                  ),
                ],
              )],
            ),
          ),
SantoPanel(
            title: 'Pad 案例',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              SantoEnhanceNumberCard(
                rowCount: 3,
                itemTextAlign: TextAlign.center,
                itemChildren: [
                  SantoNumberInfoItemModel(
                    title: 'itemTextAlign设置居中',
                    number: '1',
                  ),
                  SantoNumberInfoItemModel(
                    title: '可以设置左对齐',
                    number: '4',
                  ),
                  SantoNumberInfoItemModel(
                    title: '主题定制可去掉分割线',
                    number: '2',
                  ),
                  SantoNumberInfoItemModel(
                      title: '数字和描述文案字体都可配置', number: '3', lastDesc: '单位'),
                  SantoNumberInfoItemModel(
                    title: '上下间距可配置',
                    number: '5',
                  ),
                  SantoNumberInfoItemModel(
                      topWidget: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Container(
                            height: 26,
                            transform: Matrix4.translationValues(0, 1, 0),
                            child: Text('3',
                                style: TextStyle(
                                  height: 1.0,
                                  textBaseline: TextBaseline.ideographic,
                                  color: Color(0xFF17233D),
                                  package: SantoStrings.flutterPackageName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 28,
                                  fontFamily: 'Bebas',
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 1),
                            child: Text(
                              '室',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                textBaseline: TextBaseline.ideographic,
                                color: Color(0xFF17233D),
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Container(
                            height: 26,
                            transform: Matrix4.translationValues(0, 1, 0),
                            child: Text('1',
                                style: TextStyle(
                                  height: 1.0,
                                  textBaseline: TextBaseline.ideographic,
                                  color: Color(0xFF17233D),
                                  package: SantoStrings.flutterPackageName,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 28,
                                  fontFamily: 'Bebas',
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 1),
                            child: Text(
                              '厅',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                textBaseline: TextBaseline.ideographic,
                                color: Color(0xFF17233D),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      bottomWidget: Text(
                        "自定义底部",
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF808695)),
                        overflow: TextOverflow.ellipsis,
                      )),
                  SantoNumberInfoItemModel(
                    title: '数字信息',
                    number: '3',
                    preDesc: '前',
                    lastDesc: '后',
                  ),
                ],
              )],
            ),
          ),
SantoPanel(
            title: '异常案例 非数字',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              SantoEnhanceNumberCard(
                itemChildren: [
                  SantoNumberInfoItemModel(
                    title: '数字信息',
                    number: '3我',
                    preDesc: '前',
                    lastDesc: '后',
                  ),
                ],
              )],
            ),
          ),
SantoPanel(
            title: '异常案例 非数字',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              SantoEnhanceNumberCard(
                itemChildren: [
                  SantoNumberInfoItemModel(
                    title: '数字信息',
                    number: '3A',
                    preDesc: '前',
                    lastDesc: '后',
                  ),
                ],
              )],
            ),
          ),
SantoPanel(
            title: '异常案例',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              SantoEnhanceNumberCard(
                itemChildren: [
                  SantoNumberInfoItemModel(
                    title: '数字信息',
                    number: '3A',
                    preDesc: '前前',
                    lastDesc: '后后',
                  ),
                  SantoNumberInfoItemModel(
                    title: '数字信息',
                    number: '3A',
                    preDesc: '前',
                    lastDesc: '后后',
                  ),
                ],
              )
            ],
            ),
          ),
],
          ),
        ),
      ),
    );
  }
}
