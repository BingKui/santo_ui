

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
    return SantoPageLayout(      title: '一级标题',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SantoSection(
            title: '基础用法',
            description: 'nameList 只有一个标题时不显示下划线、分割线与选中态',
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
                  onChanged: (value) {
                    SantoToast.show(value.toString(), context);
                  },
                ),
              ],
            ),
          ),
          SantoSection(
            title: '自定义样式',
            description: 'indicatorWeight 置 0 即可隐藏下划线指示器，文字字号可分别设置',
            child: SantoSwitchTitle(
              nameList: ['标题内容1', '标题内容2'],
              indicatorWeight: 0,
              indicatorWidth: 0,
              padding: EdgeInsets.all(0),
              selectedTextStyle: TextStyle(fontSize: 24),
              unselectedTextStyle: TextStyle(fontSize: 12),
              onChanged: (value) {
                SantoToast.show(value.toString(), context);
              },
            ),
          ),
          SantoSection(
            title: '外部调用tab切换',
            description: '传入 controller 后可在外部设置 index 切换选中项',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SantoSwitchTitle(
                  nameList: ['标题内容1', '标题内容2', '标题内容3'],
                  defaultSelectIndex: 0,
                  controller: _controller,
                  onChanged: (value) {
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
          SantoSection(
            title: '异常案例：个数特别多',
            description: '标题数量较多时横向滚动展示，超出部分可滑动查看',
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
              onChanged: (value) {
                SantoToast.show(value.toString(), context);
              },
            ),
          ),
          SantoSection(
            title: '异常案例：文案过长',
            description: '单个标题文案过长时按文字宽度撑开并保持可滑动',
            child: SantoSwitchTitle(
              nameList: [
                '标题内容1',
                '标题内容标题内容标题内容标题内容标题内容标题内容2',
                '标题内容3',
              ],
              defaultSelectIndex: 0,
              onChanged: (value) {
                SantoToast.show(value.toString(), context);
              },
            ),
          ),
          SantoSection(
            title: '异常案例：文案长度为1',
            description: '标题文案仅一个字符时仍保持正常间距与点击响应',
            child: SantoSwitchTitle(
              nameList: [
                '1',
                '2',
                '3',
              ],
              defaultSelectIndex: 0,
              onChanged: (value) {
                SantoToast.show(value.toString(), context);
              },
            ),
          ),
          SantoSection(
            title: '异常案例：文案长度为0',
            description: 'nameList 含空字符串时该项无文字，点击仍可切换选中',
            child: Column(
              children: <Widget>[
                SantoSwitchTitle(
                  nameList: [
                    '1',
                    '2',
                    '3',
                  ],
                  defaultSelectIndex: 0,
                  onChanged: (value) {
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
                  onChanged: (value) {
                    SantoToast.show(value.toString(), context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
