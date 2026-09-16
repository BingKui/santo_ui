

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class SantoSwitchTitleExample extends StatefulWidget {
  @override
  _SantoSwitchTitleExampleState createState() => _SantoSwitchTitleExampleState();
}

class _SantoSwitchTitleExampleState extends State<SantoSwitchTitleExample>
    with TickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      initialIndex: 1,
      length: 3,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(
        title: '一级标题',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SantoPanel(
              title: '基础用法',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SantoBubbleText(
                    maxLines: 4,
                    text: "默认颜色文字颜色0XFF243238，选中文字颜色为主题色，title之间水平间距为20，"
                        "上下间距为14，title下面有分割线。只有一个标题时，不显示下划线、分割线和选中态",
                  ),
                  SizedBox(height: 12),
                  SantoSwitchTitle(
                    nameList: ['标题内容'],
                    onSelect: (value) {
                      SantoToast.show(value.toString(), context);
                    },
                  ),
                ],
              ),
            ),
            SantoPanel(
              title: '自定义样式',
              child: SantoSwitchTitle(
                nameList: ['标题内容1', '标题内容2'],
                indicatorWeight: 0,
                indicatorWidth: 0,
                padding: EdgeInsets.all(0),
                selectedTextStyle: TextStyle(fontSize: 24),
                unselectedTextStyle: TextStyle(fontSize: 12),
                onSelect: (value) {
                  SantoToast.show(value.toString(), context);
                },
              ),
            ),
            SantoPanel(
              title: '外部调用tab切换',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoSwitchTitle(
                    nameList: ['标题内容1', '标题内容2', '标题内容3'],
                    defaultSelectIndex: 0,
                    controller: _controller,
                    onSelect: (value) {
                      SantoToast.show(value.toString(), context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: SantoSmallOutlineButton(
                      title: '点击选中第二个',
                      onTap: () {
                        _controller.index = 1;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SantoPanel(
              title: '异常案例：个数特别多',
              child: SantoSwitchTitle(
                nameList: [
                  '标题内容1',
                  '标题内容2',
                  '标题内容3',
                  '标题内容4',
                  '标题内容5',
                  '标题内容6'
                ],
                defaultSelectIndex: 0,
                onSelect: (value) {
                  SantoToast.show(value.toString(), context);
                },
              ),
            ),
            SantoPanel(
              title: '异常案例：文案过长',
              child: SantoSwitchTitle(
                nameList: [
                  '标题内容1',
                  '标题内容标题内容标题内容标题内容标题内容标题内容2',
                  '标题内容3',
                ],
                defaultSelectIndex: 0,
                onSelect: (value) {
                  SantoToast.show(value.toString(), context);
                },
              ),
            ),
            SantoPanel(
              title: '异常案例：文案长度为1',
              child: SantoSwitchTitle(
                nameList: [
                  '1',
                  '2',
                  '3',
                ],
                defaultSelectIndex: 0,
                onSelect: (value) {
                  SantoToast.show(value.toString(), context);
                },
              ),
            ),
            SantoPanel(
              title: '异常案例：文案长度为0',
              child: Column(
                children: <Widget>[
                  SantoSwitchTitle(
                    nameList: [
                      '1',
                      '2',
                      '3',
                    ],
                    defaultSelectIndex: 0,
                    onSelect: (value) {
                      SantoToast.show(value.toString(), context);
                    },
                  ),
                  SizedBox(height: 12),
                  SantoSwitchTitle(
                    nameList: [
                      '1',
                      '',
                      '3',
                    ],
                    defaultSelectIndex: 0,
                    onSelect: (value) {
                      SantoToast.show(value.toString(), context);
                    },
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
