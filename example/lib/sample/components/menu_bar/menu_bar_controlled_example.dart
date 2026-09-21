import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
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
    return SantoPageLayout(
      backgroundColor: Colors.white,
      title: 'MenuBar · 受控与更多菜单',
      children: <Widget>[
        ExampleIntro('menu_bar'),
        for (int i = 1; i <= 20; i++)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('标签${_index + 1}内容卡片 $i',
                style: const TextStyle(fontSize: 14)),
          ),
      ],
      bottomNavigationBar: SantoMenuBar(
        currentIndex: _index,
        onChanged: (index) => setState(() => _index = index),
        itemSelectedBgColor: const Color(0xFFF0F0F0),
        selectedTextColor: const Color(0xFF1677FF),
        showMoreMenu: true,
        moreMenu: SantoMenuBarMoreMenu(
          title: '更多',
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
