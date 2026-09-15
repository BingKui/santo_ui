import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// Drawer 抽屉示例
class DrawerExample extends StatefulWidget {
  @override
  _DrawerExampleState createState() => _DrawerExampleState();
}

class _DrawerExampleState extends State<DrawerExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SantoAppBar(title: 'Drawer 示例'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SantoPanel(
              title: '基础抽屉',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 右侧抽屉
                  SantoNormalButton(
                    onTap: () {
                      SantoDrawer.show(
                        context: context,
                        direction: SantoDrawerDirection.right,
                        child: _buildDrawerContent('右侧抽屉'),
                      );
                    },
                    text: '打开右侧抽屉',
                  ),

                  const SizedBox(height: 16),

                  // 左侧抽屉
                  SantoNormalButton(
                    onTap: () {
                      SantoDrawer.show(
                        context: context,
                        direction: SantoDrawerDirection.left,
                        child: _buildDrawerContent('左侧抽屉'),
                      );
                    },
                    text: '打开左侧抽屉',
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
            SantoPanel(
              title: '自定义宽度',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 自定义宽度
                  SantoNormalButton(
                    onTap: () {
                      SantoDrawer.show(
                        context: context,
                        direction: SantoDrawerDirection.right,
                        width: 200,
                        child: _buildDrawerContent('宽度 200'),
                      );
                    },
                    text: '打开窄抽屉 (width: 200)',
                  ),

                  const SizedBox(height: 16),

                  SantoNormalButton(
                    onTap: () {
                      SantoDrawer.show(
                        context: context,
                        direction: SantoDrawerDirection.right,
                        width: 400,
                        child: _buildDrawerContent('宽度 400'),
                      );
                    },
                    text: '打开宽抽屉 (width: 400)',
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            SantoPanel(
              title: '自定义遮罩',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoNormalButton(
                    onTap: () {
                      SantoDrawer.show(
                        context: context,
                        direction: SantoDrawerDirection.right,
                        maskColor: Colors.black.withAlpha(0x33),
                        child: _buildDrawerContent('浅色遮罩'),
                      );
                    },
                    text: '打开抽屉（浅色遮罩）',
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            SantoPanel(
              title: '筛选面板场景',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoNormalButton(
                    onTap: () {
                      SantoDrawer.show(
                        context: context,
                        direction: SantoDrawerDirection.right,
                        width: 320,
                        child: _buildFilterContent(context),
                      );
                    },
                    text: '打开筛选面板',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建抽屉内容
  Widget _buildDrawerContent(String title) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),
          ...List.generate(
            10,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 8, color: Colors.grey[400]),
                  const SizedBox(width: 12),
                  Text('列表项 ${index + 1}', style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建筛选面板内容
  Widget _buildFilterContent(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              children: [
                Text(
                  '筛选条件',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.close, size: 22),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('状态', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['全部', '进行中', '已完成', '已取消'].map((e) {
                      return ChoiceChip(
                        label: Text(e),
                        selected: e == '全部',
                        onSelected: (selected) {},
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Text('类型', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['全部', '类型A', '类型B', '类型C'].map((e) {
                      return ChoiceChip(
                        label: Text(e),
                        selected: e == '全部',
                        onSelected: (selected) {},
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 1),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: SantoNormalButton.outline(
                    onTap: () => Navigator.of(context).pop(),
                    text: '重置',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SantoNormalButton(
                    onTap: () {
                      Navigator.of(context).pop();
                      SantoToast.show('应用筛选', context);
                    },
                    text: '确定',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
