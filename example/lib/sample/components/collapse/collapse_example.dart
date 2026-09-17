import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// Collapse 折叠面板示例
class CollapseExample extends StatefulWidget {
  @override
  State<CollapseExample> createState() => _CollapseExampleState();
}

class _CollapseExampleState extends State<CollapseExample> {
  List<String> _basicValue = const ['basic'];
  List<String> _operationValue = const ['operation'];
  List<String> _accordionValue = const ['0'];
  List<String> _cardValue = const ['card-0'];
  List<String> _disabledValue = const ['disabled'];
  List<String> _iconValue = const ['icon'];

  @override
  Widget build(BuildContext context) {
    const String content =
        '此处可自定义内容此处可自定义内容此处可自定义内容此处可自定义内容此处可自定义内容此处可自定义内容此处可自定义内容此处可自定义内容';

    return SantoPageLayout(      title: 'Collapse 折叠面板',
      children: <Widget>[
        SantoSection(
          title: '基础折叠面板',
          description: '受控用法，value 绑定当前展开项，onChanged 回传最新选中集合',
          child: SantoCollapse<String>(
            value: _basicValue,
            onChanged: (value) => setState(() => _basicValue = value),
            children: [
              SantoCollapsePanel<String>(
                value: 'basic',
                headerBuilder: (context, isExpanded) =>
                    const Text('折叠面板标题'),
                body: const Text(content),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '带操作说明',
          description: 'trailingBuilder 自定义标题右侧区域，文案随展开状态切换',
          child: SantoCollapse<String>(
            value: _operationValue,
            onChanged: (value) => setState(() => _operationValue = value),
            children: [
              SantoCollapsePanel<String>(
                value: 'operation',
                headerBuilder: (context, isExpanded) =>
                    const Text('折叠面板标题'),
                trailingBuilder: (context, isExpanded) =>
                    Text(isExpanded ? '收起' : '展开'),
                body: const Text(content),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '手风琴式',
          description: 'mode 设为 accordion，同一时间只允许一个面板处于展开态',
          child: SantoCollapse<String>(
            mode: SantoCollapseMode.accordion,
            value: _accordionValue,
            onChanged: (value) => setState(() => _accordionValue = value),
            children: List.generate(3, (index) {
              return SantoCollapsePanel<String>(
                value: '$index',
                headerBuilder: (context, isExpanded) =>
                    const Text('折叠面板标题'),
                body: const Text(content),
              );
            }),
          ),
        ),
        SantoSection(
          title: '卡片折叠面板',
          description: 'variant 设为 card，面板之间以卡片样式分隔而非连排',
          child: SantoCollapse<String>(
            variant: SantoCollapseVariant.card,
            value: _cardValue,
            onChanged: (value) => setState(() => _cardValue = value),
            children: List.generate(3, (index) {
              return SantoCollapsePanel<String>(
                value: 'card-$index',
                headerBuilder: (context, isExpanded) =>
                    const Text('折叠面板标题'),
                body: const Text(content),
              );
            }),
          ),
        ),
        SantoSection(
          title: '禁用状态',
          description: 'disabled 为 true 的面板无法点击展开，与可展开项形成对比',
          child: SantoCollapse<String>(
            value: _disabledValue,
            onChanged: (value) => setState(() => _disabledValue = value),
            children: [
              SantoCollapsePanel<String>(
                value: 'disabled',
                headerBuilder: (context, isExpanded) =>
                    const Text('折叠面板标题'),
                body: const Text(content),
              ),
              SantoCollapsePanel<String>(
                value: 'disabled-target',
                disabled: true,
                headerBuilder: (context, isExpanded) =>
                    const Text('禁用面板标题'),
                body: const Text(content),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '自定义展开图标',
          description: 'expandIconBuilder 自定义展开图标，返回 null 时不展示图标',
          child: SantoCollapse<String>(
            value: _iconValue,
            onChanged: (value) => setState(() => _iconValue = value),
            children: [
              SantoCollapsePanel<String>(
                value: 'icon',
                headerBuilder: (context, isExpanded) =>
                    const Text('折叠面板标题'),
                expandIconBuilder: (context, isExpanded) => Icon(
                  isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                ),
                body: const Text(content),
              ),
              SantoCollapsePanel<String>(
                value: 'icon-hidden',
                headerBuilder: (context, isExpanded) =>
                    const Text('隐藏展开图标'),
                expandIconBuilder: null,
                body: const Text(content),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
