

import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

class NumberItemRowExample extends StatefulWidget {
  @override
  _NumberItemRowExampleState createState() => _NumberItemRowExampleState();
}

class _NumberItemRowExampleState extends State<NumberItemRowExample> {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: '数字信息',
      children: <Widget>[
  ExampleIntro('card'),
  SantoSection(
              title: '正常案例 只有一个Item',
              description: '只有一个 item 时的基础展示，number 使用 Bebas 字体放大',
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
  SantoSection(
              title: '正常案例',
              description: 'preDesc 与 lastDesc 在数字前后附加单位，numberInfoIcon 设为 arrow 展示箭头',
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
  SantoSection(
              title: '正常案例',
              description: 'rowCount 为 3 时按三列平铺，title 最多两行且超出省略',
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
  SantoSection(
              title: '正常案例',
              description: 'rowCount 控制每行列数，item 之间自动展示分割线',
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
  SantoSection(
              title: 'Pad 案例',
              description: 'itemTextAlign 控制文案对齐，topWidget 与 bottomWidget 完全自定义',
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
  SantoSection(
              title: '异常案例 非数字',
              description: 'number 混入中文时字体回退异常，中文请改用 preDesc 或 lastDesc',
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
  SantoSection(
              title: '异常案例 非数字',
              description: 'number 混入字母时整体按 Bebas 渲染，建议只传纯数字',
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
  SantoSection(
              title: '异常案例',
              description: 'preDesc 与 lastDesc 为多字符时的间距与对齐表现',
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
    );
  }
}
