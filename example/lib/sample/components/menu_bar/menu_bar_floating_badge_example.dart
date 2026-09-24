import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
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
    return SantoPageLayout(
      backgroundColor: const Color(0xFFD6E4FF),
      title: 'MenuBar · 悬浮红点与徽标',
      // 内容从悬浮栏下方穿过:用 bottomInset 留出栏高 64 + gap 12
      bottomInset: 64 + 12,
      children: <Widget>[
        ExampleIntro('menu_bar'),
        for (int i = 1; i <= 20; i++)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('${_tabNames[_index]}内容卡片 $i',
                style: const TextStyle(fontSize: 14)),
          ),
      ],
      // 悬浮菜单栏:叠在内容之上
      overlay:           Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SantoMenuBar(
            style: SantoMenuBarStyle.floating,
            gap: 12,
            currentIndex: _index,
            onChanged: (i) => setState(() => _index = i),
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
    );
  }
}
