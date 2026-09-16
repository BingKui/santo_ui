import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// 底部导航栏示例
class BottomTabbarExample extends StatefulWidget {
  const BottomTabbarExample({Key? key}) : super(key: key);

  @override
  State<BottomTabbarExample> createState() => _BottomTabbarExampleState();
}

class _BottomTabbarExampleState extends State<BottomTabbarExample> {
  static const _brandColor = Color(0xFF0984F9);

  /// 基础用法选中项
  int _basicIndex = 0;

  /// shifting 类型选中项
  int _shiftingIndex = 0;

  /// 带未读消息选中项,选中第一个后清除未读
  int _badgeIndex = 0;
  String _badgeNo = '8';

  /// 极限条件选中项
  int _stressIndex = 0;

  static const _titles = ['首页', '发现', '发布', '消息', '我的'];
  static const _icons = [
    Icons.home,
    Icons.explore,
    Icons.add_circle_outline,
    Icons.chat_bubble_outline,
    Icons.person_outline,
  ];

  List<SantoBottomTabBarItem> _buildItems({
    int count = 5,
    bool withAssetIcon = false,
    String? badgeIndexNo,
  }) {
    return List.generate(count, (index) {
      Widget icon = Icon(_icons[index % _icons.length], size: 24);
      if (withAssetIcon) {
        icon = const Image(
          image: AssetImage('assets/icons/navbar_house.png'),
        );
      }
      return SantoBottomTabBarItem(
        icon: icon,
        activeIcon: withAssetIcon
            ? const Image(
                image: AssetImage('assets/icons/navbar_house.png'),
                color: _brandColor,
              )
            : Icon(_icons[index % _icons.length], size: 24, color: _brandColor),
        title: Text(_titles[index % _titles.length]),
        badgeNo: badgeIndexNo == index ? _badgeNo : null,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(title: 'BottomTabBar 示例'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SantoPanel(
              title: '基础用法 (fixed)',
              child: SantoBottomTabBar(
                fixedColor: _brandColor,
                currentIndex: _basicIndex,
                onTap: (index) => setState(() => _basicIndex = index),
                items: _buildItems(),
              ),
            ),
            SantoPanel(
              title: '图片资源图标',
              child: SantoBottomTabBar(
                fixedColor: _brandColor,
                currentIndex: _basicIndex,
                onTap: (index) => setState(() => _basicIndex = index),
                items: _buildItems(withAssetIcon: true),
              ),
            ),
            SantoPanel(
              title: 'shifting 类型(选中项背景高亮)',
              child: SantoBottomTabBar(
                type: SantoBottomTabBarDisplayType.shifting,
                fixedColor: _brandColor,
                currentIndex: _shiftingIndex,
                onTap: (index) => setState(() => _shiftingIndex = index),
                items: _buildItems(),
              ),
            ),
            SantoPanel(
              title: '未读消息角标',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('点击「消息」后清除未读数量'),
                  const SizedBox(height: 12),
                  SantoBottomTabBar(
                    fixedColor: _brandColor,
                    badgeColor: const Color(0xFFFA3F3F),
                    currentIndex: _badgeIndex,
                    onTap: (index) {
                      setState(() {
                        _badgeIndex = index;
                        if (index == 3) _badgeNo = '';
                      });
                    },
                    items: _buildItems(badgeIndexNo: 3),
                  ),
                ],
              ),
            ),
            SantoPanel(
              title: '自定义文字样式和背景色',
              child: SantoBottomTabBar(
                fixedColor: _brandColor,
                currentIndex: _basicIndex,
                onTap: (index) => setState(() => _basicIndex = index),
                items: [
                  SantoBottomTabBarItem(
                    icon: const Icon(Icons.home, size: 24),
                    activeIcon:
                        const Icon(Icons.home, size: 24, color: _brandColor),
                    title: const Text('首页'),
                    backgroundColor: const Color(0xFFE0EDFF),
                    selectedTextStyle: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  ..._buildItems(count: 3)
                      .skip(1)
                      .take(3)
                      .map((e) => SantoBottomTabBarItem(
                            icon: (e.icon as Icon),
                            activeIcon: (e.activeIcon as Icon),
                            title: e.title,
                          )),
                ],
              ),
            ),
            SantoPanel(
              title: '极限条件',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('只有 1 个 item'),
                  const SizedBox(height: 12),
                  SantoBottomTabBar(
                    fixedColor: _brandColor,
                    currentIndex: _stressIndex,
                    onTap: (index) => setState(() => _stressIndex = index),
                    items: _buildItems(count: 1),
                  ),
                  const SizedBox(height: 16),
                  const Text('8 个 item (shifting)'),
                  const SizedBox(height: 12),
                  SantoBottomTabBar(
                    type: SantoBottomTabBarDisplayType.shifting,
                    fixedColor: _brandColor,
                    currentIndex: _stressIndex,
                    onTap: (index) => setState(() => _stressIndex = index),
                    items: _buildItems(
                      count: 8,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('标题文本很长'),
                  const SizedBox(height: 12),
                  SantoBottomTabBar(
                    fixedColor: _brandColor,
                    currentIndex: _stressIndex,
                    onTap: (index) => setState(() => _stressIndex = index),
                    items: _buildItems(count: 4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
