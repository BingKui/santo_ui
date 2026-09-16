import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// MenuBar 悬浮样式示例
///
/// 悬浮样式的菜单栏悬浮在页面内容之上,
/// 内容区域延伸到底部,滚动内容可从毛玻璃容器下方穿过。
class MenuBarFloatingExample extends StatefulWidget {
  const MenuBarFloatingExample({Key? key}) : super(key: key);

  @override
  State<MenuBarFloatingExample> createState() => _MenuBarFloatingExampleState();
}

class _MenuBarFloatingExampleState extends State<MenuBarFloatingExample> {
  int _index = 0;

  static const _tabNames = ['首页', '发现', '我的'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6E4FF),
      appBar: SantoAppBar(title: 'MenuBar · 悬浮样式'),
      body: Stack(
        children: [
          // 内容区域延伸到底部,从悬浮菜单栏下方穿过
          ListView(
            padding: const EdgeInsets.only(bottom: 120),
            children: [
              for (int i = 1; i <= 20; i++)
                Container(
                  margin:
                      EdgeInsets.fromLTRB(12, i == 1 ? 12 : 0, 12, 12),
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
          // 悬浮菜单栏
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
          ),
        ],
      ),
    );
  }
}
