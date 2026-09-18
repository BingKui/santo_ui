import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

/// Tag 标签示例
///
/// 排版参考 antd Tag 文档：每个演示点一个 SantoSection
class TagExample extends StatefulWidget {
  @override
  State<TagExample> createState() => _TagExampleState();
}

class _TagExampleState extends State<TagExample> {
  final List<String> _tagList = [
    '这是一条很长很长很长很长很长很长很长很长很长很长的标签',
    '标签信息',
    '标签信息标签信息',
    '标签信息',
    '标签信息标签信息标签信息标签信息'
  ];

  late final SantoDeleteTagController _deleteTagController =
      SantoDeleteTagController(initTags: List<String>.of(_tagList));

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'Tag 标签',
      children: <Widget>[
        ExampleIntro('tag'),
        _buildBasicSection(),
        _buildColorfulSection(),
        _buildSelectTagSections(),
        _buildDeleteTagSection(),
        _buildCustomCloseTagSection(),
        _buildStateTagSection(),
        _buildTagGroupSection(),
        _buildLongTextSection(),
      ],
    );
  }

  /// 基础用法:普通标签 + 描边标签
  Widget _buildBasicSection() {
    return SantoSection(
      title: '基础用法',
      description: 'SantoTagCustom 默认样式：文字 11 号、内边距 3、圆角 2；'
          'buildBorderTag 生成描边标签',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          SantoTagCustom(tagText: '标签'),
          SantoTagCustom(tagText: '自定义标签'),
          SantoTagCustom.buildBorderTag(tagText: '已盘点'),
          SantoTagCustom.buildBorderTag(tagText: '标签1'),
        ],
      ),
    );
  }

  /// 多彩标签:自定义背景色与文字色
  Widget _buildColorfulSection() {
    return SantoSection(
      title: '多彩标签',
      description: 'backgroundColor 与 textColor 自定义配色，maxWidth 限制最大宽度',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          SantoTagCustom(
            tagText: '默认主题色',
          ),
          SantoTagCustom(
            tagText: '红色标签',
            backgroundColor: Color(0xFFFF4D4F),
          ),
          SantoTagCustom(
            tagText: '绿色标签',
            backgroundColor: Color(0xFF52C41A),
          ),
          SantoTagCustom(
            tagText: '橙色标签',
            backgroundColor: Color(0xFFFAAD14),
          ),
          SantoTagCustom.buildBorderTag(
            tagText: '描边彩色',
            textColor: Colors.red,
            borderColor: Colors.red,
            borderWidth: 2,
            fontSize: 16,
            textPadding: EdgeInsets.all(6),
          ),
          SantoTagCustom(
            tagText: '限制最大宽度',
            maxWidth: 90,
          ),
        ],
      ),
    );
  }

  /// 可选择标签:单选 / 多选 / 流式 / 横向滑动
  Widget _buildSelectTagSections() {
    return Column(
      children: <Widget>[
        SantoSection(
          title: '选择标签·单选',
          description: '默认单选，initTagState 设初始选中，onChanged 返回下标',
          child: SantoSelectTag(
            tags: _tagList,
            spacing: 12,
            tagWidth: _getTagWidth(context),
            initTagState: [true],
            onChanged: (selectedIndexes) {
              SantoToast.show(selectedIndexes.toString(), context);
            },
          ),
        ),
        SantoSection(
          title: '选择标签·多选',
          description: 'isSingleSelect 为 false 支持多选并初始化多项选中',
          child: SantoSelectTag(
            isSingleSelect: false,
            tags: _tagList,
            spacing: 12,
            tagWidth: _getTagWidth(context),
            initTagState: [true, false, true],
            onChanged: (selectedIndexes) {
              SantoToast.show(selectedIndexes.toString(), context);
            },
          ),
        ),
        SantoSection(
          title: '流式布局',
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
            },
          ),
        ),
        SantoSection(
          title: '横向滑动·等宽',
          description: 'tagWidth 固定等宽，softWrap 为 false 时横向滑动',
          child: SantoSelectTag(
            tags: _tagList,
            tagWidth: _getTagWidth(context),
            softWrap: false,
            onChanged: (index) {
              SantoToast.show('$index is selected', context);
            },
          ),
        ),
        SantoSection(
          title: '横向滑动·自适应',
          description: '流式标签横向滑动，宽度受最小宽度配置约束',
          child: SantoSelectTag(
            tags: _tagList,
            tagWidth: _getTagWidth(context),
            softWrap: false,
            fixWidthMode: false,
            onChanged: (index) {
              SantoToast.show('$index is selected', context);
            },
          ),
        ),
      ],
    );
  }

  /// 动态添加和删除
  Widget _buildDeleteTagSection() {
    return SantoSection(
      title: '动态添加和删除',
      description: 'controller 用 initTags 初始化，点击删除图标移除标签，'
          '也可调用 addTag/deleteForIndex 动态增删',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SantoDeleteTag(
            controller: _deleteTagController,
            onTagDelete: (tags, tag, index) {
              SantoToast.show(
                  '剩余的标签为：${tags.toString()},删除了的标签为：$tag  ,删除的标签index为$index',
                  context);
            },
          ),
        ],
      ),
    );
  }

  /// 自定义关闭样式
  Widget _buildCustomCloseTagSection() {
    return SantoSection(
      title: '自定义关闭样式',
      description: 'tagTextStyle 与 deleteIconSize 调整文字与删除图标样式；'
          'softWrap 为 false 时横向滑动',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SantoDeleteTag(
            controller: _deleteTagController,
            tagTextStyle: TextStyle(color: Colors.blue, fontSize: 20),
            deleteIconSize: Size(16, 16),
            onTagDelete: (tags, tag, index) {
              SantoToast.show(
                  '剩余的标签为：${tags.toString()},删除了的标签为：$tag  ,删除的标签index为$index',
                  context);
            },
          ),
          SizedBox(height: 16),
          SantoDeleteTag(
            controller: _deleteTagController,
            tagTextStyle: TextStyle(color: Colors.yellow),
            backgroundColor: Colors.blue,
            deleteIconColor: Colors.red,
            softWrap: false,
            onTagDelete: (tags, tag, index) {
              SantoToast.show(
                  '剩余的标签为：${tags.toString()},删除了的标签为：$tag  ,删除的标签index为$index',
                  context);
            },
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SantoButton(
                child: Icon(Icons.add),
                type: SantoButtonType.text,
                insertPadding: const EdgeInsets.all(12),
                onTap: () => _deleteTagController.addTag('增加的tag'),
              ),
              SantoButton(
                child: Icon(Icons.delete_forever),
                type: SantoButtonType.text,
                insertPadding: const EdgeInsets.all(12),
                onTap: () => _deleteTagController.deleteForIndex(0),
              )
            ],
          ),
        ],
      ),
    );
  }

  /// 状态标签
  Widget _buildStateTagSection() {
    return SantoSection(
      title: '状态标签',
      description: 'tagState 支持等待、失效、运行、失败、成功五种状态；'
          'backgroundColor 与 textColor 可覆盖预设配色',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              SantoStateTag(tagText: '待进行', tagState: TagState.waiting),
              SantoStateTag(tagText: '失效态', tagState: TagState.invalidate),
              SantoStateTag(tagText: '进行中', tagState: TagState.running),
              SantoStateTag(tagText: '失败态', tagState: TagState.failed),
              SantoStateTag(tagText: '成功态', tagState: TagState.succeed),
            ],
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              SantoStateTag(
                backgroundColor: Colors.green,
                textColor: Colors.white,
                tagText: '自定义配色',
              ),
              SantoStateTag(
                tagState: TagState.running,
                tagText: '自定义标签自定义标签自定义标标别长特别签自定义标签',
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 标签组
  Widget _buildTagGroupSection() {
    return SantoSection(
      title: '标签组',
      description: 'Wrap 排列多个普通标签与描边标签，自动换行并保持间距',
      child: Wrap(
        spacing: 5,
        runSpacing: 5,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          SantoTagCustom(tagText: '自定义标签'),
          SantoTagCustom(tagText: '标签'),
          SantoTagCustom.buildBorderTag(tagText: '标签1'),
          SantoTagCustom.buildBorderTag(tagText: '标签2'),
          SantoTagCustom.buildBorderTag(tagText: '特长长长长长长的标签'),
          SantoTagCustom(tagText: '一级标签'),
          SantoTagCustom(tagText: '二级标签'),
          SantoTagCustom(tagText: '其他标签'),
          SantoTagCustom(tagText: '二级标签'),
          SantoTagCustom(tagText: '一级标签'),
          SantoTagCustom(tagText: '二级标签'),
        ],
      ),
    );
  }

  /// 异常案例:文案特别长
  Widget _buildLongTextSection() {
    return SantoSection(
      title: '异常案例：文案特别长',
      description: '超长文案下的截断与省略表现',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SantoTagCustom(
            tagText:
                '标题特别长特别长特别长特别长特别长特别长特别长特别长标题特别长特别长特别长特别长特别长特别长特别长特别长标题特别长特别长特别长特别长特别长特别长特别长特别长',
          ),
          SizedBox(height: 16),
          SantoStateTag(
            tagText:
                '标题特别长特别长特别长特别长特别长特别长特别长特别长标题特别长特别长特别长特别长特别长特别长特别长特别长标题特别长特别长特别长特别长特别长特别长特别长特别长',
          ),
        ],
      ),
    );
  }

  double _getTagWidth(BuildContext context, {int rowCount = 4}) {
    double leftRightPadding = 40;
    double rowSpace = 12;
    return (MediaQuery.of(context).size.width -
            leftRightPadding -
            rowSpace * (rowCount - 1)) /
        rowCount;
  }
}
