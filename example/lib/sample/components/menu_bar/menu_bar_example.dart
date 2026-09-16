import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/rule_panel.dart';
import 'package:flutter/material.dart';

/// MenuBar 菜单栏示例
class MenuBarExample extends StatefulWidget {
  @override
  State<MenuBarExample> createState() => _MenuBarExampleState();
}

class _MenuBarExampleState extends State<MenuBarExample> {
  int _controlledIndex = 0;

  List<SantoMenuBarItem> _items({bool withBadge = false}) => [
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
        if (withBadge)
          const SantoMenuBarItem(
            text: '消息',
            showBadge: true,
          ),
        SantoMenuBarItem(
          text: '我的',
          selectedIcon: const Icon(Icons.person),
          unselectedIcon: const Icon(Icons.person_outline),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SantoAppBar(title: 'MenuBar 菜单栏'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RulePanel(
              '底部标签栏分默认和悬浮两种样式:默认样式为纯色背景、顶部左右圆角;'
              '悬浮样式为透明毛玻璃圆角容器,与屏幕边缘保持 gap 间距,每个标签项为大圆角胶囊。',
              maxLines: 3,
            ),
            SantoSection(
              title: '默认样式(停靠)',
              description: '纯色背景、顶部左右圆角,默认停靠在页面底部',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: Container(
                    color: const Color(0xFFF5F6FA),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SantoMenuBar(items: _items()),
                    ),
                  ),
                ),
              ),
            ),
            SantoSection(
              title: '悬浮样式(毛玻璃)',
              description: 'floating 为毛玻璃圆角容器,gap 控制与屏幕边缘的间距',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Container(
                        color: const Color(0xFFD6E4FF),
                        alignment: Alignment.center,
                        child: const Text('页面内容',
                            style: TextStyle(color: Colors.grey)),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: SantoMenuBar(
                          style: SantoMenuBarStyle.floating,
                          gap: 12,
                          items: _items(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SantoSection(
              title: '红点与徽标',
              description: 'showBadge 在标签右上角显示红点',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: Container(
                    color: const Color(0xFFF5F6FA),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SantoMenuBar(
                        items: _items(withBadge: true),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SantoSection(
              title: '受控选中 + 回调',
              description: 'currentIndex 受控选中,onChange 回传点击的标签下标',
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: 120,
                      width: double.infinity,
                      child: Container(
                        color: const Color(0xFFF5F6FA),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SantoMenuBar(
                            currentIndex: _controlledIndex,
                            onChange: (index) {
                              setState(() => _controlledIndex = index);
                              SantoToast.show('选中第 ${index + 1} 个标签',
                                  context);
                            },
                            items: _items(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('当前选中索引: $_controlledIndex',
                      style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
