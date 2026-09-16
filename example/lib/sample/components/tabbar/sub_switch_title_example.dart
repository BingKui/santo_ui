

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class SubSwitchTitleExample extends StatefulWidget {
  @override
  _SubSwitchTitleExampleState createState() => _SubSwitchTitleExampleState();
}

class _SubSwitchTitleExampleState extends State<SubSwitchTitleExample>
    with TickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      initialIndex: 0,
      length: 6,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(
        title: '二级标题',
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
                    text: "默认颜色文字颜色0XFF17233D，选中文字颜色为主题色，没有下划线，"
                        "title之间水平间距为20，只有一个标题时，不显示选中态",
                  ),
                  SizedBox(height: 12),
                  SantoSubSwitchTitle(
                    nameList: ['二级标题'],
                    onSelect: (value) {
                      SantoToast.show(value.toString(), context);
                    },
                  ),
                  SizedBox(height: 12),
                  SantoSubSwitchTitle(
                    nameList: ['二级标题1', '二级标题2'],
                    onSelect: (value) {
                      SantoToast.show(value.toString(), context);
                    },
                  ),
                  SizedBox(height: 12),
                  SantoSubSwitchTitle(
                    nameList: ['二级标题1', '二级标题2', '二级标题3'],
                    defaultSelectIndex: 0,
                    onSelect: (value) {
                      SantoToast.show(value.toString(), context);
                    },
                  ),
                ],
              ),
            ),
            SantoPanel(
              title: '异常案例：个数特别多',
              child: SantoSubSwitchTitle(
                nameList: [
                  '二级标题1',
                  '二级标题2',
                  '二级标题3',
                  '二级标题4',
                  '二级标题5',
                  '二级标题6'
                ],
                defaultSelectIndex: 0,
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
                  SantoSubSwitchTitle(
                    nameList: [
                      '二级标题1',
                      '二级标题2',
                      '二级标题3',
                      '二级标题4',
                      '二级标题5',
                      '二级标题6'
                    ],
                    defaultSelectIndex: 0,
                    controller: _controller,
                    onSelect: (value) {
                      SantoToast.show(value.toString(), context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: SantoSmallOutlineButton(
                      title: '点击选中第三个',
                      onTap: () {
                        _controller.index = 2;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SantoPanel(
              title: '异常案例：文案过长',
              child: SantoSubSwitchTitle(
                nameList: [
                  '二级标题1',
                  '二级标题二级标题二级标题二级标题二级标题二级标题2',
                  '二级标题3',
                ],
                defaultSelectIndex: 0,
                onSelect: (value) {
                  SantoToast.show(value.toString(), context);
                },
              ),
            ),
            SantoPanel(
              title: '异常案例：文案长度为1',
              child: SantoSubSwitchTitle(
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
                  SantoSubSwitchTitle(
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
                  SantoSubSwitchTitle(
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
