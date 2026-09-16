import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// MenuBar 红点与徽标示例
class MenuBarBadgeExample extends StatelessWidget {
  const MenuBarBadgeExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SantoAppBar(title: 'MenuBar · 红点与徽标'),
      body: ListView(
        children: [
          for (int i = 1; i <= 5; i++)
            Container(
              margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('消息通知 $i',
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
          const SantoMenuBarItem(
            text: '发现',
            showBadge: true,
          ),
          SantoMenuBarItem(
            text: '消息',
            badge: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: const Color(0xFFFF4D4F),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('99+',
                  style: TextStyle(color: Colors.white, fontSize: 10)),
            ),
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
