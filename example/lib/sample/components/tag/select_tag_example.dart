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
    return Scaffold(
      appBar: SantoAppBar(
        title: '选择标签',
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            SantoPanel(
              title: '单选功能',
              child: SantoSelectTag(
                  tags: tagList,
                  spacing: 12,
                  tagWidth: _getTagWidth(context),
                  initTagState: [true],
                  onSelect: (selectedIndexes) {
                    SantoToast.show(selectedIndexes.toString(), context);
                  }),
            ),
            SantoPanel(
              title: '多选功能',
              child: SantoSelectTag(
                  isSingleSelect: false,
                  tags: tagList,
                  spacing: 12,
                  tagWidth: _getTagWidth(context),
                  initTagState: [true, false, true],
                  onSelect: (selectedIndexes) {
                    SantoToast.show(selectedIndexes.toString(), context);
                  }),
            ),
            SantoPanel(
              title: '流式布局的自适应标签',
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
                  onSelect: (selectedIndexes) {
                    SantoToast.show(selectedIndexes.toString(), context);
                  }),
            ),
            SantoPanel(
              title: '横向滑动，等宽标签',
              child: SantoSelectTag(
                  tags: tagList,
                  tagWidth: _getTagWidth(context),
                  softWrap: false,
                  onSelect: (index) {
                    SantoToast.show("$index is selected", context);
                  }),
            ),
            SantoPanel(
              title: '横向滑动的自适应宽度标签(最小宽度75)',
              child: SantoSelectTag(
                  tags: tagList,
                  tagWidth: _getTagWidth(context),
                  softWrap: false,
                  fixWidthMode: false,
                  onSelect: (index) {
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
