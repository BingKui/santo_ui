

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class RadioExample extends StatefulWidget {
  @override
  _RadioExampleState createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioExample> {
  /// 单选选中的index
  int _singleSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(
        title: '单选示例',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SantoSection(
              title: '基础用法',
              description: 'radioIndex 标识选项，isSelected 控制选中态并自行维护互斥',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SantoBubbleText(
                      maxLines: 2, text: '具备选中、未选中、以及禁用状态,支持设置左右widget'),
                  SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Text("选项："),
                      SantoRadioButton(
                        radioIndex: 0,
                        isSelected: _singleSelectedIndex == 0,
                        child: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text("选项A"),
                        ),
                        onValueChangedAtIndex: (index, value) {
                          setState(() {
                            _singleSelectedIndex = index;
                          });
                          SantoToast.show("单选，选中第$index个", context);
                        },
                      ),
                      SizedBox(width: 20),
                      SantoRadioButton(
                        radioIndex: 1,
                        isSelected: _singleSelectedIndex == 1,
                        child: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text("选项B"),
                        ),
                        onValueChangedAtIndex: (index, value) {
                          setState(() {
                            _singleSelectedIndex = index;
                          });
                          SantoToast.show("单选，选中第$index个", context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SantoSection(
              title: '禁用状态',
              description: 'disable 为 true 时组件置灰且不响应点击',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SantoRadioButton(
                        disable: true,
                        radioIndex: 0,
                        isSelected: false,
                        onValueChangedAtIndex: (index, value) {},
                      ),
                      SizedBox(width: 8),
                      Text('未选中，禁用',
                          style: TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      SantoRadioButton(
                        disable: true,
                        radioIndex: 0,
                        isSelected: true,
                        onValueChangedAtIndex: (index, value) {},
                      ),
                      SizedBox(width: 8),
                      Text('已选中，禁用',
                          style: TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
