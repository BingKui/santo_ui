import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

/// MenuBar 红点与徽标示例(停靠样式)
///
/// 覆盖:图标 + 红点 / 图标 + 数字徽标 / 图标 + 超长数字徽标
class MenuBarBadgeExample extends StatefulWidget {
  const MenuBarBadgeExample({Key? key}) : super(key: key);

  @override
  State<MenuBarBadgeExample> createState() => _MenuBarBadgeExampleState();
}

class _MenuBarBadgeExampleState extends State<MenuBarBadgeExample> {
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
    return SantoPageLayout(
      backgroundColor: Colors.white,
      title: 'MenuBar · 红点与徽标',
      children: <Widget>[
        ExampleIntro('menu_bar'),
        for (int i = 1; i <= 20; i++)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('${_tabNames[_index]}内容卡片 $i',
                style: const TextStyle(fontSize: 14)),
          ),
      ],
      bottomNavigationBar: SantoMenuBar(
        currentIndex: _index,
        onChanged: (i) => setState(() => _index = i),
        selectedTextColor: const Color(0xFF1677FF),
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
    );
  }
}
