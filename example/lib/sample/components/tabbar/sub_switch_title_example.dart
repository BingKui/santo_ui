

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
    return SantoPageLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SantoSection(
            title: '基础用法',
            description: 'nameList 传一个标题时无选中态，多个时选中项显示主题色',
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
                  onChanged: (value) {
                    SantoToast.show(value.toString(), context);
                  },
                ),
                SizedBox(height: 12),
                SantoSubSwitchTitle(
                  nameList: ['二级标题1', '二级标题2'],
                  onChanged: (value) {
                    SantoToast.show(value.toString(), context);
                  },
                ),
                SizedBox(height: 12),
                SantoSubSwitchTitle(
                  nameList: ['二级标题1', '二级标题2', '二级标题3'],
                  defaultSelectIndex: 0,
                  onChanged: (value) {
                    SantoToast.show(value.toString(), context);
                  },
                ),
              ],
            ),
          ),
          SantoSection(
            title: '异常案例：个数特别多',
            description: '标题数量较多时横向滚动查看，选中项为主题色且无下划线',
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
              onChanged: (value) {
                SantoToast.show(value.toString(), context);
              },
            ),
          ),
          SantoSection(
            title: '外部调用tab切换',
            description: '传入 controller 后可在外部修改 index 切换选中项',
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
                  onChanged: (value) {
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
          SantoSection(
            title: '异常案例：文案过长',
            description: '单个标题文案过长时按文字宽度撑开并保持可滑动',
            child: SantoSubSwitchTitle(
              nameList: [
                '二级标题1',
                '二级标题二级标题二级标题二级标题二级标题二级标题2',
                '二级标题3',
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
            child: SantoSubSwitchTitle(
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
                SantoSubSwitchTitle(
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
                SantoSubSwitchTitle(
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
