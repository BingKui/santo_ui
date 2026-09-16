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

    return Scaffold(
      appBar: SantoAppBar(title: 'Collapse 折叠面板'),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SantoPanel(
              title: '基础折叠面板',
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
            SantoPanel(
              title: '带操作说明',
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
            SantoPanel(
              title: '手风琴式',
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
            SantoPanel(
              title: '卡片折叠面板',
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
            SantoPanel(
              title: '禁用状态',
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
            SantoPanel(
              title: '自定义展开图标',
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
        ),
      ),
    );
  }
}
