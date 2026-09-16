import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/card_data_config.dart';
import 'package:example/sample/home/list_item.dart';
import 'package:flutter/material.dart';

import 'setting.dart';

/// 主页面 - 使用侧边栏菜单分组展示组件
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final ScrollController _sidebarScrollController = ScrollController();
  final ScrollController _contentScrollController = ScrollController();

  List<GroupInfo> get _groups => CardDataConfig.getAllGroup();

  @override
  void dispose() {
    _sidebarScrollController.dispose();
    _contentScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(
        title: 'UI组件',
        leading: null,
        automaticallyImplyLeading: false,
        actions: [
          SantoIconAction(
            iconPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return Setting();
                },
              ));
            },
            child: Image.asset(
              'assets/image/setting.png',
              scale: 3.0,
              height: 20,
              width: 20,
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          _buildSidebar(),
          _buildContent(),
        ],
      ),
    );
  }

  /// 左侧菜单侧边栏
  Widget _buildSidebar() {
    final groups = _groups;
    return Container(
      width: 120,
      color: const Color(0xFFF0F1F6),
      child: ListView.builder(
        controller: _sidebarScrollController,
        padding: EdgeInsets.zero,
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
              _contentScrollController.jumpTo(0);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : const Color(0xFFF0F1F6),
                border: Border(
                  left: BorderSide(
                    color: isSelected
                        ? const Color(0xFF1677FF)
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              child: Text(
                groups[index].groupName,
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xFF1677FF)
                      : const Color(0xFF515A6E),
                  fontSize: 14,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }

  /// 右侧组件列表内容区
  Widget _buildContent() {
    final groups = _groups;
    if (_selectedIndex < 0 || _selectedIndex >= groups.length) {
      return const SizedBox.shrink();
    }
    final currentGroup = groups[_selectedIndex];
    final children = currentGroup.children ?? [];

    return Expanded(
      child: Container(
        color: const Color(0xFFF5F6FA),
        child: ListView.builder(
          controller: _contentScrollController,
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          itemCount: children.length,
          itemBuilder: (context, index) {
            final child = children[index];
            return Container(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: ListItem(
                isSupportTheme: child.isSupportTheme,
                isShowLine: false,
                title: child.groupName,
                describe: child.desc,
                onPressed: () {
                  if (child.navigatorPage != null) {
                    child.navigatorPage!(context);
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
