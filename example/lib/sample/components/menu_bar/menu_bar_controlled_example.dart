import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/rule_panel.dart';
import 'package:flutter/material.dart';

/// MenuBar 受控选中与更多菜单示例
class MenuBarControlledExample extends StatefulWidget {
  const MenuBarControlledExample({Key? key}) : super(key: key);

  @override
  State<MenuBarControlledExample> createState() =>
      _MenuBarControlledExampleState();
}

class _MenuBarControlledExampleState extends State<MenuBarControlledExample> {
  int _index = 0;

  List<SantoMenuBarItem> _items() => [
        SantoMenuBarItem(
          text: '首页',
          selectedIcon: const Icon(Icons.home_filled),
          unselectedIcon: const Icon(Icons.home_outlined),
        ),
        SantoMenuBarItem(
          text: '发现',
          selectedIcon: const Icon(Icons.travel_explore),
          unselectedIcon: const Icon(Icons.explore_outlined),
        ),
        SantoMenuBarItem(
          text: '消息',
          selectedIcon: const Icon(Icons.chat_bubble),
          unselectedIcon: const Icon(Icons.chat_bubble_outline),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SantoAppBar(title: 'MenuBar · 受控与更多菜单'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const RulePanel(
            'currentIndex 受控选中,点更多标签弹出 SantoMoreMenu 宫格菜单',
            maxLines: 2,
          ),
          Expanded(
            child: _index == 0
                ? const Center(child: Text('首页内容',
                    style: TextStyle(fontSize: 14, color: Colors.grey)))
                : _index == 1
                    ? const Center(child: Text('发现内容',
                        style: TextStyle(fontSize: 14, color: Colors.grey)))
                    : const Center(child: Text('消息内容',
                        style: TextStyle(fontSize: 14, color: Colors.grey))),
          ),
        ],
      ),
      bottomNavigationBar: SantoMenuBar(
        currentIndex: _index,
        onChange: (index) => setState(() => _index = index),
        showMoreMenu: true,
        moreMenu: SantoMenuBarMoreMenu(
          title: '更多',
          actionText: '编辑',
          onActionTap: () => SantoToast.show('点击了编辑', context),
          items: [
            SantoMenuBarMoreMenuItem(
              label: '文档',
              icon: Icons.description_outlined,
              onTap: () => SantoToast.show('点击了文档', context),
            ),
            SantoMenuBarMoreMenuItem(
              label: '会议',
              icon: Icons.videocam_outlined,
              onTap: () => SantoToast.show('点击了会议', context),
            ),
            SantoMenuBarMoreMenuItem(
              label: '邮箱',
              icon: Icons.mail_outline,
              onTap: () => SantoToast.show('点击了邮箱', context),
            ),
            SantoMenuBarMoreMenuItem(
              label: 'AI 表格',
              icon: Icons.grid_view_outlined,
              onTap: () => SantoToast.show('点击了 AI 表格', context),
            ),
          ],
        ),
        items: _items(),
      ),
    );
  }
}
