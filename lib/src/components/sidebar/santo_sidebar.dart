import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 侧边栏选中回调
///
/// [index] 为选中项的索引，[label] 为选中项的文本。
typedef SantoSidebarItemSelectedCallback = void Function(int index, String label);

/// 侧边栏组件
///
/// 垂直排列的标签列表，常用于分类页面左侧导航（如外卖分类页）。
/// 支持选中状态高亮和选中回调。
///
/// 使用示例：
/// ```dart
/// SantoSidebar(
///   items: ['推荐', '美食', '超市', '水果'],
///   selectedIndex: 0,
///   onItemSelected: (index, label) {
///     print('选中了: $label');
///   },
/// )
/// ```
class SantoSidebar extends StatelessWidget {
  /// 标签列表
  final List<String> items;

  /// 当前选中的索引
  final int selectedIndex;

  /// 选中回调
  final SantoSidebarItemSelectedCallback? onItemSelected;

  /// 侧边栏宽度，默认 90
  final double width;

  /// 选中状态颜色
  final Color? activeColor;

  /// 未选中状态颜色
  final Color? inactiveColor;

  /// 背景颜色
  final Color? backgroundColor;

  /// 选中指示条宽度，默认 3
  final double indicatorWidth;

  /// 每项高度，默认 56
  final double itemHeight;

  /// 文字样式
  final TextStyle? textStyle;

  /// 选中文字样式
  final TextStyle? activeTextStyle;

  const SantoSidebar({
    Key? key,
    required this.items,
    this.selectedIndex = 0,
    this.onItemSelected,
    this.width = 90,
    this.activeColor,
    this.inactiveColor,
    this.backgroundColor,
    this.indicatorWidth = 3,
    this.itemHeight = 56,
    this.textStyle,
    this.activeTextStyle,
  }) : super(key: key);

  Color get _activeColor =>
      activeColor ??
      SantoThemeConfigurator.instance.getConfig().commonConfig.brandPrimary;

  Color get _inactiveColor =>
      inactiveColor ?? const Color(0xFF666666);

  Color get _backgroundColor =>
      backgroundColor ?? const Color(0xFFF8F8F8);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: _backgroundColor,
      child: ListView.builder(
        itemCount: items.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return _buildItem(index);
        },
      ),
    );
  }

  /// 构建单个标签项
  Widget _buildItem(int index) {
    final isSelected = index == selectedIndex;
    final label = items[index];

    return GestureDetector(
      onTap: () {
        onItemSelected?.call(index, label);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: itemHeight,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : _backgroundColor,
        ),
        child: Row(
          children: [
            // 选中指示条
            Container(
              width: isSelected ? indicatorWidth : 0,
              height: isSelected ? 20 : 0,
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: isSelected ? _activeColor : Colors.transparent,
                borderRadius: BorderRadius.circular(indicatorWidth / 2),
              ),
            ),
            // 标签文本
            Expanded(
              child: Center(
                child: Text(
                  label,
                  style: isSelected
                      ? (activeTextStyle ??
                          TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _activeColor,
                          ))
                      : (textStyle ??
                          TextStyle(
                            fontSize: 14,
                            color: _inactiveColor,
                          )),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
