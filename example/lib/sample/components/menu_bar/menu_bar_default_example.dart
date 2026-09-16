import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// MenuBar 默认样式示例
class MenuBarDefaultExample extends StatelessWidget {
  const MenuBarDefaultExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SantoAppBar(title: 'MenuBar · 默认样式'),
      body: ListView(
        children: [
          for (int i = 1; i <= 6; i++)
            Container(
              margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('首页内容卡片 $i',
                  style: const TextStyle(fontSize: 14)),
            ),
        ],
      ),
      bottomNavigationBar: SantoMenuBar(
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
