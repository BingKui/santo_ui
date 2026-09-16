import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// 下拉菜单示例
class DropdownMenuExample extends StatefulWidget {
  @override
  _DropdownMenuExampleState createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  String? _sortValue = 'default';
  String? _categoryValue;
  String? _priceValue;

  final List<SantoDropdownMenuOption> _sortOptions = [
    SantoDropdownMenuOption(label: '默认排序', value: 'default'),
    SantoDropdownMenuOption(label: '价格从低到高', value: 'price_asc'),
    SantoDropdownMenuOption(label: '价格从高到低', value: 'price_desc'),
    SantoDropdownMenuOption(label: '销量优先', value: 'sales'),
    SantoDropdownMenuOption(label: '好评优先', value: 'rating'),
  ];

  final List<SantoDropdownMenuOption> _categoryOptions = [
    SantoDropdownMenuOption(label: '全部', value: 'all'),
    SantoDropdownMenuOption(label: '美食', value: 'food'),
    SantoDropdownMenuOption(label: '电影', value: 'movie'),
    SantoDropdownMenuOption(label: '酒店', value: 'hotel'),
    SantoDropdownMenuOption(label: '休闲娱乐', value: 'entertainment'),
    SantoDropdownMenuOption(label: '生活服务', value: 'life'),
  ];

  final List<SantoDropdownMenuOption> _priceOptions = [
    SantoDropdownMenuOption(label: '不限', value: 'all'),
    SantoDropdownMenuOption(label: '0-50', value: '0-50'),
    SantoDropdownMenuOption(label: '50-100', value: '50-100'),
    SantoDropdownMenuOption(label: '100-200', value: '100-200'),
    SantoDropdownMenuOption(label: '200以上', value: '200+'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(title: 'DropdownMenu 下拉菜单示例'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 场景1：基础三列筛选
            SantoSection(
              title: '基础三列筛选菜单',
              description: '三个菜单项并排展示，selectedValue 控制选中回显',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoDropdownMenu(
                    children: [
                      SantoDropdownMenuItem(
                        title: '排序',
                        options: _sortOptions,
                        selectedValue: _sortValue,
                        onChanged: (value) {
                          setState(() {
                            _sortValue = value;
                          });
                        },
                      ),
                      SantoDropdownMenuItem(
                        title: '分类',
                        options: _categoryOptions,
                        selectedValue: _categoryValue,
                        onChanged: (value) {
                          setState(() {
                            _categoryValue = value;
                          });
                        },
                      ),
                      SantoDropdownMenuItem(
                        title: '价格',
                        options: _priceOptions,
                        selectedValue: _priceValue,
                        onChanged: (value) {
                          setState(() {
                            _priceValue = value;
                          });
                        },
                      ),
                    ],
                  ),
                  // 模拟内容区域
                  Container(
                    height: 200,
                    color: Color(0xFFF5F5F5),
                    child: Center(
                      child: Text(
                        '筛选结果区域\n'
                        '排序: ${_sortValue ?? "无"}\n'
                        '分类: ${_categoryValue ?? "无"}\n'
                        '价格: ${_priceValue ?? "无"}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF808695), fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 场景2：单列筛选
            SantoSection(
              title: '单列筛选菜单',
              description: '单个菜单项展开选项面板，onChanged 回调更新选中值',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoDropdownMenu(
                    children: [
                      SantoDropdownMenuItem(
                        title: '综合排序',
                        options: _sortOptions,
                        selectedValue: _sortValue,
                        onChanged: (value) {
                          setState(() {
                            _sortValue = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Container(
                    height: 120,
                    color: Color(0xFFF5F5F5),
                    child: Center(
                      child: Text(
                        '当前排序: ${_sortValue ?? "无"}',
                        style: TextStyle(color: Color(0xFF808695), fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 场景3：自定义主题色
            SantoSection(
              title: '自定义主题色',
              description: 'activeColor 设为红色，选中态文字与勾选图标同步变色',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoDropdownMenu(
                    activeColor: Color(0xFFFF4D4F),
                    children: [
                      SantoDropdownMenuItem(
                        title: '排序',
                        options: _sortOptions,
                        selectedValue: _sortValue,
                        onChanged: (value) {
                          setState(() {
                            _sortValue = value;
                          });
                        },
                        activeColor: Color(0xFFFF4D4F),
                      ),
                      SantoDropdownMenuItem(
                        title: '分类',
                        options: _categoryOptions,
                        selectedValue: _categoryValue,
                        onChanged: (value) {
                          setState(() {
                            _categoryValue = value;
                          });
                        },
                        activeColor: Color(0xFFFF4D4F),
                      ),
                    ],
                  ),
                  Container(
                    height: 120,
                    color: Color(0xFFF5F5F5),
                    child: Center(
                      child: Text(
                        '使用红色主题的下拉菜单',
                        style: TextStyle(color: Color(0xFF808695), fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
