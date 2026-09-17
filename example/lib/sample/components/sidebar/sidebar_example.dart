import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// 侧边栏示例
class SidebarExample extends StatefulWidget {
  @override
  _SidebarExampleState createState() => _SidebarExampleState();
}

class _SidebarExampleState extends State<SidebarExample> {
  int _selectedIndex1 = 0;
  int _selectedIndex2 = 0;
  int _selectedIndex3 = 0;

  final List<String> _foodCategories = [
    '推荐',
    '美食',
    '甜品',
    '饮品',
    '水果',
    '超市',
    '鲜花',
    '医药',
    '宠物',
    '百货',
  ];

  final List<String> _shortCategories = [
    '推荐',
    '热门',
    '最新',
    '收藏',
  ];

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'Sidebar 侧边栏示例',
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 场景1：基础侧边栏 + 右侧内容
          SantoSection(
            title: '基础侧边栏',
            description: 'items 传入分类列表，onItemSelected 回调选中的下标与文本',
            child: Container(
              height: 300,
              child: Row(
                children: [
                  SantoSidebar(
                    items: _foodCategories,
                    selectedIndex: _selectedIndex1,
                    onItemSelected: (index, label) {
                      setState(() {
                        _selectedIndex1 = index;
                      });
                    },
                  ),
                  Expanded(
                    child: Container(
                      color: Color(0xFFF5F5F5),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.restaurant,
                                size: 48, color: Color(0xFFCCCCCC)),
                            SizedBox(height: 8),
                            Text(
                              _foodCategories[_selectedIndex1],
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF515A6E),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '右侧内容区域',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF808695),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 场景2：自定义宽度
          SantoSection(
            title: '自定义宽度 (width: 120)',
            description: 'width 设为 120 后侧边栏收窄，右侧内容区域相应变宽',
            child: Container(
              height: 250,
              child: Row(
                children: [
                  SantoSidebar(
                    items: _foodCategories,
                    selectedIndex: _selectedIndex2,
                    width: 120,
                    onItemSelected: (index, label) {
                      setState(() {
                        _selectedIndex2 = index;
                      });
                    },
                  ),
                  Expanded(
                    child: Container(
                      color: Color(0xFFF5F5F5),
                      child: Center(
                        child: Text(
                          '当前分类: ${_foodCategories[_selectedIndex2]}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF515A6E),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 场景3：自定义颜色
          SantoSection(
            title: '自定义颜色',
            description: 'activeColor 覆盖选中颜色，backgroundColor 改变侧边栏底色',
            child: Container(
              height: 250,
              child: Row(
                children: [
                  SantoSidebar(
                    items: _shortCategories,
                    selectedIndex: _selectedIndex3,
                    activeColor: Color(0xFFFF4D4F),
                    backgroundColor: Color(0xFFFFF0F0),
                    onItemSelected: (index, label) {
                      setState(() {
                        _selectedIndex3 = index;
                      });
                    },
                  ),
                  Expanded(
                    child: Container(
                      color: Color(0xFFFFF0F0),
                      child: Center(
                        child: Text(
                          '当前分类: ${_shortCategories[_selectedIndex3]}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFFF4D4F),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 40),
        ],
      ),
    );
  }
}
