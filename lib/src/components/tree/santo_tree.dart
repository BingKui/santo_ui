import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 树形控件数据模型
///
/// 每个节点包含 [label] 显示文本、[value] 值，以及可选的 [children] 子节点列表。
/// [expanded] 控制节点是否默认展开。
class SantoTreeNode {
  /// 显示文本
  final String label;

  /// 值
  final String value;

  /// 子节点列表
  final List<SantoTreeNode>? children;

  /// 是否默认展开
  bool expanded;

  /// 自定义图标
  final IconData? icon;

  /// 自定义数据
  final dynamic data;

  SantoTreeNode({
    required this.label,
    required this.value,
    this.children,
    this.expanded = false,
    this.icon,
    this.data,
  });

  /// 是否有子节点
  bool get hasChildren => children != null && children!.isNotEmpty;
}

/// 树形控件节点点击回调
///
/// [node] 为被点击的节点。
typedef SantoTreeNodeTapCallback = void Function(SantoTreeNode node);

/// 树形控件节点展开/收起回调
///
/// [node] 为被操作的节点，[expanded] 为当前展开状态。
typedef SantoTreeNodeExpandCallback = void Function(
    SantoTreeNode node, bool expanded);

/// 树形控件节点自定义构建器
///
/// [node] 为当前节点，[isExpanded] 为当前展开状态，[level] 为层级。
typedef SantoTreeNodeBuilder = Widget Function(
    SantoTreeNode node, bool isExpanded, int level);

/// 树形控件组件
///
/// 层级数据展示和选择，支持展开/收起节点、单选/多选、自定义节点内容。
///
/// 使用示例：
/// ```dart
/// SantoTree(
///   data: treeData,
///   multiple: false,
///   onNodeTap: (node) {
///     print('点击了: ${node.label}');
///   },
///   onNodeExpand: (node, expanded) {
///     print('展开状态: $expanded');
///   },
/// )
/// ```
class SantoTree extends StatefulWidget {
  /// 树形数据
  final List<SantoTreeNode> data;

  /// 是否多选模式，默认 false（单选）
  final bool multiple;

  /// 节点点击回调
  final SantoTreeNodeTapCallback? onNodeTap;

  /// 节点展开/收起回调
  final SantoTreeNodeExpandCallback? onNodeExpand;

  /// 自定义节点构建器
  final SantoTreeNodeBuilder? nodeBuilder;

  /// 选中值列表（多选模式）
  final List<String>? selectedValues;

  /// 选中值变化回调
  final ValueChanged<List<String>>? onSelectionChanged;

  /// 主题色
  final Color? activeColor;

  /// 缩进宽度，默认 24
  final double indentWidth;

  /// 节点高度，默认 44
  final double nodeHeight;

  const SantoTree({
    Key? key,
    required this.data,
    this.multiple = false,
    this.onNodeTap,
    this.onNodeExpand,
    this.nodeBuilder,
    this.selectedValues,
    this.onSelectionChanged,
    this.activeColor,
    this.indentWidth = 24,
    this.nodeHeight = 44,
  }) : super(key: key);

  @override
  State<SantoTree> createState() => _SantoTreeState();
}

class _SantoTreeState extends State<SantoTree> {
  /// 多选模式下已选中的值集合
  late Set<String> _selectedValues;

  Color get _activeColor =>
      widget.activeColor ??
      SantoThemeConfigurator.instance.getConfig().commonConfig.brandPrimary;

  @override
  void initState() {
    super.initState();
    _selectedValues = Set.from(widget.selectedValues ?? []);
  }

  @override
  void didUpdateWidget(SantoTree oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValues != null) {
      _selectedValues = Set.from(widget.selectedValues!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: _buildNodes(widget.data, 0),
    );
  }

  /// 递归构建节点列表
  List<Widget> _buildNodes(List<SantoTreeNode> nodes, int level) {
    List<Widget> widgets = [];

    for (var node in nodes) {
      // 构建当前节点
      widgets.add(_buildNodeItem(node, level));

      // 如果展开且有子节点，递归构建子节点
      if (node.expanded && node.hasChildren) {
        widgets.addAll(_buildNodes(node.children!, level + 1));
      }
    }

    return widgets;
  }

  /// 构建单个节点
  Widget _buildNodeItem(SantoTreeNode node, int level) {
    final isSelected = _selectedValues.contains(node.value);
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;

    // 如果提供了自定义构建器
    if (widget.nodeBuilder != null) {
      return GestureDetector(
        onTap: () => _handleNodeTap(node),
        behavior: HitTestBehavior.opaque,
        child: widget.nodeBuilder!(node, node.expanded, level),
      );
    }

    return Container(
      height: widget.nodeHeight,
      padding: EdgeInsets.only(left: level * widget.indentWidth + commonConfig.gapMd),
      child: Row(
        children: [
          // 展开/收起图标
          SizedBox(
            width: 24,
            height: 24,
            child: node.hasChildren
                ? GestureDetector(
                    onTap: () => _toggleExpand(node),
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: AnimatedRotation(
                        turns: node.expanded ? 0.25 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.chevron_right,
                          size: 18,
                          color: const Color(0xFF808695),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          // 多选框
          if (widget.multiple)
            GestureDetector(
              onTap: () => _handleNodeTap(node),
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 20,
                height: 20,
                margin: EdgeInsets.only(right: commonConfig.hSpacingSm),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected
                        ? _activeColor
                        : const Color(0xFFDCDEE2),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(commonConfig.radiusXs),
                  color: isSelected ? _activeColor : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 14,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
          // 自定义图标
          if (node.icon != null)
            Padding(
              padding: EdgeInsets.only(right: commonConfig.hSpacingXs),
              child: Icon(
                node.icon,
                size: 18,
                color: isSelected ? _activeColor : const Color(0xFF515A6E),
              ),
            ),
          // 节点文本
          Expanded(
            child: GestureDetector(
              onTap: () => _handleNodeTap(node),
              behavior: HitTestBehavior.opaque,
              child: Text(
                node.label,
                style: TextStyle(
                  fontSize: commonConfig.fontSizeBase,
                  color: isSelected
                      ? _activeColor
                      : const Color(0xFF17233D),
                  fontWeight:
                      isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 处理节点点击
  void _handleNodeTap(SantoTreeNode node) {
    if (widget.multiple) {
      setState(() {
        if (_selectedValues.contains(node.value)) {
          _selectedValues.remove(node.value);
        } else {
          _selectedValues.add(node.value);
        }
      });
      widget.onSelectionChanged?.call(_selectedValues.toList());
    }

    widget.onNodeTap?.call(node);
  }

  /// 切换节点展开/收起
  void _toggleExpand(SantoTreeNode node) {
    setState(() {
      node.expanded = !node.expanded;
    });
    widget.onNodeExpand?.call(node, node.expanded);
  }
}
