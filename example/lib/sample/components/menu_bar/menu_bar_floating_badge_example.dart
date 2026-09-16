import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// MenuBar 悬浮样式红点与徽标示例
///
/// 悬浮样式下同样支持红点/徽标:图标 + 红点、图标 + 数字徽标
class MenuBarFloatingBadgeExample extends StatefulWidget {
  const MenuBarFloatingBadgeExample({Key? key}) : super(key: key);

  @override
  State<MenuBarFloatingBadgeExample> createState() =>
      _MenuBarFloatingBadgeExampleState();
}

class _MenuBarFloatingBadgeExampleState
    extends State<MenuBarFloatingBadgeExample> {
  int _index = 0;

  static const _tabNames = ['首页', '发现', '消息', '我的'];

  Widget _numberBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: const Color(0xFFFF4D4F),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text,
          style: const TextStyle(color: Colors.white, fontSize: 10)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6E4FF),
      appBar: SantoAppBar(title: 'MenuBar · 悬浮红点与徽标'),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(bottom: 120),
            children: [
              for (int i = 1; i <= 20; i++)
                Container(
                  margin: EdgeInsets.fromLTRB(12, i == 1 ? 12 : 0, 12, 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('${_tabNames[_index]}内容卡片 $i',
                      style: const TextStyle(fontSize: 14)),
                ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SantoMenuBar(
              style: SantoMenuBarStyle.floating,
              gap: 12,
              currentIndex: _index,
              onChange: (i) => setState(() => _index = i),
              items: [
                SantoMenuBarItem(
                  text: '首页',
                  selectedIcon: const Icon(Icons.home_filled),
                  unselectedIcon: const Icon(Icons.home_outlined),
                ),
                // 图标 + 红点
                SantoMenuBarItem(
                  text: '发现',
                  selectedIcon: const Icon(Icons.explore),
                  unselectedIcon: const Icon(Icons.explore_outlined),
                  showBadge: true,
                ),
                // 图标 + 数字徽标
                SantoMenuBarItem(
                  text: '消息',
                  selectedIcon: const Icon(Icons.chat_bubble),
                  unselectedIcon: const Icon(Icons.chat_bubble_outline),
                  badge: _numberBadge('9'),
                ),
                // 图标 + 超长数字徽标
                SantoMenuBarItem(
                  text: '我的',
                  selectedIcon: const Icon(Icons.person),
                  unselectedIcon: const Icon(Icons.person_outline),
                  badge: _numberBadge('99+'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
