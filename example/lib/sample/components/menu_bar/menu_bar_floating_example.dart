import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// MenuBar 悬浮样式示例
class MenuBarFloatingExample extends StatelessWidget {
  const MenuBarFloatingExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6E4FF),
      appBar: SantoAppBar(title: 'MenuBar · 悬浮样式'),
      body: ListView(
        children: [
          for (int i = 1; i <= 6; i++)
            Container(
              margin: EdgeInsets.fromLTRB(12, i == 1 ? 12 : 0, 12, 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('悬浮页面内容卡片 $i',
                  style: const TextStyle(fontSize: 14)),
            ),
        ],
      ),
      bottomNavigationBar: SantoMenuBar(
        style: SantoMenuBarStyle.floating,
        gap: 12,
        items: [
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
            text: '我的',
            selectedIcon: const Icon(Icons.person),
            unselectedIcon: const Icon(Icons.person_outline),
          ),
        ],
      ),
    );
  }
}
