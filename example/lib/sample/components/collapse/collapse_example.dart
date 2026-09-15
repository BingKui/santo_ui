import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// Collapse 折叠面板示例
class CollapseExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(title: 'Collapse 折叠面板'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SantoPanel(
              title: '基础用法',
              child: SantoCollapse(
                children: [
                  SantoCollapsePanel(
                    title: Text('面板一'),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('面板一的内容,点击标题可展开或收起。'),
                    ),
                  ),
                  SantoCollapsePanel(
                    title: Text('面板二'),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('面板二的内容。'),
                    ),
                  ),
                  SantoCollapsePanel(
                    title: Text('面板三'),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('面板三的内容。'),
                    ),
                  ),
                ],
              ),
            ),
            SantoPanel(
              title: '手风琴模式',
              child: SantoCollapse(
                accordion: true,
                children: [
                  SantoCollapsePanel(
                    title: Text('同时只展开一个'),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('手风琴模式下,展开某个面板时会自动收起其他面板。'),
                    ),
                  ),
                  SantoCollapsePanel(
                    title: Text('第二个面板'),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('面板内容。'),
                    ),
                  ),
                ],
              ),
            ),
            SantoPanel(
              title: '默认展开',
              child: SantoCollapse(
                children: [
                  SantoCollapsePanel(
                    title: Text('默认展开的面板'),
                    expanded: true,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('该面板默认处于展开状态。'),
                    ),
                  ),
                  SantoCollapsePanel(
                    title: Text('默认收起的面板'),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('面板内容。'),
                    ),
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
