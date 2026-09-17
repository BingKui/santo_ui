import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

///标签选择view
class SelectTagExamplePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SelectTagExamplePageState();
}

class SelectTagExamplePageState extends State<SelectTagExamplePage> {
  List<String> tagList = [
    '这是一条很长很长很长很长很长很长很长很长很长很长的标签',
    '标签信息',
    '标签信息标签信息',
    '标签信息',
    '标签信息标签信息标签信息标签信息'
  ];

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      scrollable: false,
      child: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            SantoSection(
              title: '单选功能',
              description: '默认单选，initTagState 设初始选中，onChanged 返回下标',
              child: SantoSelectTag(
                  tags: tagList,
                  spacing: 12,
                  tagWidth: _getTagWidth(context),
                  initTagState: [true],
                  onChanged: (selectedIndexes) {
                    SantoToast.show(selectedIndexes.toString(), context);
                  }),
            ),
            SantoSection(
              title: '多选功能',
              description: 'isSingleSelect 为 false 支持多选并初始化多项选中',
              child: SantoSelectTag(
                  isSingleSelect: false,
                  tags: tagList,
                  spacing: 12,
                  tagWidth: _getTagWidth(context),
                  initTagState: [true, false, true],
                  onChanged: (selectedIndexes) {
                    SantoToast.show(selectedIndexes.toString(), context);
                  }),
            ),
            SantoSection(
              title: '流式布局的自适应标签',
              description: 'fixWidthMode 为 false 时标签宽度自适应并流式换行',
              child: SantoSelectTag(
                  tags: [
                    '标签',
                    '选中标签',
                    '未选中标签',
                    '标签圆角、字号、色值、高度都可主题配置',
                    '组件可设置固定宽度还是流式布局',
                    '主题定制可配置最小宽度，现在限制的最小宽度是110'
                  ],
                  isSingleSelect: false,
                  fixWidthMode: false,
                  spacing: 12,
                  onChanged: (selectedIndexes) {
                    SantoToast.show(selectedIndexes.toString(), context);
                  }),
            ),
            SantoSection(
              title: '横向滑动，等宽标签',
              description: 'tagWidth 固定等宽，softWrap 为 false 时横向滑动',
              child: SantoSelectTag(
                  tags: tagList,
                  tagWidth: _getTagWidth(context),
                  softWrap: false,
                  onChanged: (index) {
                    SantoToast.show("$index is selected", context);
                  }),
            ),
            SantoSection(
              title: '横向滑动的自适应宽度标签(最小宽度75)',
              description: '流式标签横向滑动，宽度受最小宽度配置约束',
              child: SantoSelectTag(
                  tags: tagList,
                  tagWidth: _getTagWidth(context),
                  softWrap: false,
                  fixWidthMode: false,
                  onChanged: (index) {
                    SantoToast.show("$index is selected", context);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  double _getTagWidth(context, {int rowCount = 4}) {
    double leftRightPadding = 40;
    double rowSpace = 12;
    return (MediaQuery.of(context).size.width -
            leftRightPadding -
            rowSpace * (rowCount - 1)) /
        rowCount;
  }
}
