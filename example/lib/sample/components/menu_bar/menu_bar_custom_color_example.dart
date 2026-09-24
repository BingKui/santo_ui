import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

/// MenuBar 自定义选中颜色示例
///
/// 悬浮样式的选中态可用两个参数覆盖默认值:
/// [SantoMenuBar.itemSelectedBgColor] 选中底色、[SantoMenuBar.selectedTextColor]
/// 选中图标与文字色(停靠样式只支持后者)。
class MenuBarCustomColorExample extends StatefulWidget {
  const MenuBarCustomColorExample({Key? key}) : super(key: key);

  @override
  State<MenuBarCustomColorExample> createState() =>
      _MenuBarCustomColorExampleState();
}

class _MenuBarCustomColorExampleState extends State<MenuBarCustomColorExample> {
  int _index = 0;

  static const _tabNames = ['首页', '发现', '我的'];

  /// 自定义选中色:橙色实底 + 反白图标文字
  static const Color _selectedBgColor = Color(0xFFFF6B00);

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      backgroundColor: const Color(0xFFFFF3E6),
      title: 'MenuBar · 自定义选中颜色',
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
      overlay: Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: SantoMenuBar(
          style: SantoMenuBarStyle.floating,
          gap: 12,
          currentIndex: _index,
          onChanged: (i) => setState(() => _index = i),
          itemSelectedBgColor: _selectedBgColor,
          selectedTextColor: Colors.white,
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
    );
  }
}
