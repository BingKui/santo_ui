import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 下拉菜单选项数据模型
///
/// 每个选项包含 [label] 显示文本和 [value] 值。
class SantoDropdownMenuOption {
  /// 显示文本
  final String label;

  /// 值
  final String value;

  const SantoDropdownMenuOption({
    required this.label,
    required this.value,
  });
}

/// 下拉菜单项变化回调
///
/// [value] 为当前选中的值。
typedef SantoDropdownMenuChangedCallback = void Function(String? value);

/// 下拉菜单项
///
/// 单个筛选项，显示标题和下拉选项列表。
///
/// 使用示例：
/// ```dart
/// SantoDropdownMenuItem(
///   title: '排序',
///   options: [
///     SantoDropdownMenuOption(label: '默认排序', value: 'default'),
///     SantoDropdownMenuOption(label: '价格升序', value: 'price_asc'),
///   ],
///   selectedValue: _sortValue,
///   onChanged: (value) => setState(() => _sortValue = value),
/// )
/// ```
class SantoDropdownMenuItem extends StatefulWidget {
  /// 菜单项标题
  final String title;

  /// 选项列表
  final List<SantoDropdownMenuOption> options;

  /// 当前选中的值
  final String? selectedValue;

  /// 选中值变化回调
  final SantoDropdownMenuChangedCallback? onChanged;

  /// 激活状态颜色
  final Color? activeColor;

  /// 自定义下拉内容，如果提供则忽略 [options]
  final WidgetBuilder? customContentBuilder;

  const SantoDropdownMenuItem({
    Key? key,
    required this.title,
    required this.options,
    this.selectedValue,
    this.onChanged,
    this.activeColor,
    this.customContentBuilder,
  }) : super(key: key);

  @override
  State<SantoDropdownMenuItem> createState() => _SantoDropdownMenuItemState();
}

class _SantoDropdownMenuItemState extends State<SantoDropdownMenuItem>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  Color get _activeColor =>
      widget.activeColor ??
      SantoThemeConfigurator.instance.getConfig().commonConfig.brandPrimary;

  /// 获取当前选中的选项
  SantoDropdownMenuOption? get _selectedOption {
    if (widget.selectedValue == null) return null;
    for (var option in widget.options) {
      if (option.value == widget.selectedValue) return option;
    }
    return null;
  }

  /// 获取显示文本
  String get _displayText =>
      _selectedOption?.label ?? widget.title;

  bool get _isActive => _selectedOption != null;

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return GestureDetector(
      onTap: () {
        _toggle();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48,
        padding: EdgeInsets.symmetric(horizontal: commonConfig.hSpacingSm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                _displayText,
                style: TextStyle(
                  fontSize: commonConfig.fontSizeBase,
                  color: _isActive ? _activeColor : const Color(0xFF17233D),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: commonConfig.hSpacingXs),
            AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: _isActive ? _activeColor : const Color(0xFF808695),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggle() {
    final menuState = SantoDropdownMenu._of(context);
    if (menuState != null) {
      menuState._toggleItem(widget, _isExpanded);
    }
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}

/// 下拉菜单容器
///
/// 包含多个 [SantoDropdownMenuItem] 的横向菜单栏，点击后在下方展开对应的下拉内容。
///
/// 使用示例：
/// ```dart
/// SantoDropdownMenu(
///   children: [
///     SantoDropdownMenuItem(
///       title: '排序',
///       options: sortOptions,
///       selectedValue: _sortValue,
///       onChanged: (v) => setState(() => _sortValue = v),
///     ),
///     SantoDropdownMenuItem(
///       title: '分类',
///       options: categoryOptions,
///       selectedValue: _categoryValue,
///       onChanged: (v) => setState(() => _categoryValue = v),
///     ),
///   ],
/// )
/// ```
class SantoDropdownMenu extends StatefulWidget {
  /// 菜单项列表
  final List<SantoDropdownMenuItem> children;

  /// 激活状态颜色
  final Color? activeColor;

  const SantoDropdownMenu({
    Key? key,
    required this.children,
    this.activeColor,
  }) : super(key: key);

  static _SantoDropdownMenuState? _of(BuildContext context) {
    return context.findAncestorStateOfType<_SantoDropdownMenuState>();
  }

  @override
  State<SantoDropdownMenu> createState() => _SantoDropdownMenuState();
}

class _SantoDropdownMenuState extends State<SantoDropdownMenu>
    with SingleTickerProviderStateMixin {
  /// 当前展开的菜单项
  SantoDropdownMenuItem? _expandedItem;

  /// 动画控制器
  late AnimationController _animationController;
  late Animation<double> _animation;

  Color get _activeColor =>
      widget.activeColor ??
      SantoThemeConfigurator.instance.getConfig().commonConfig.brandPrimary;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// 切换菜单项展开/收起
  void _toggleItem(SantoDropdownMenuItem item, bool currentlyExpanded) {
    if (currentlyExpanded) {
      // 收起当前
      setState(() {
        _expandedItem = null;
      });
      _animationController.reverse();
    } else {
      // 展开新的
      setState(() {
        _expandedItem = item;
      });
      _animationController.forward();
    }
  }

  /// 关闭所有展开
  void _closeAll() {
    if (_expandedItem != null) {
      setState(() {
        _expandedItem = null;
      });
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 菜单栏
        Container(
          height: 48,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFE8EAEC),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: widget.children.map((item) {
              return Expanded(
                child: SantoDropdownMenuItem(
                  key: item.key,
                  title: item.title,
                  options: item.options,
                  selectedValue: item.selectedValue,
                  onChanged: item.onChanged,
                  activeColor: item.activeColor ?? _activeColor,
                  customContentBuilder: item.customContentBuilder,
                ),
              );
            }).toList(),
          ),
        ),
        // 下拉内容
        SizeTransition(
          sizeFactor: _animation,
          axisAlignment: -1,
          child: _buildDropdownContent(),
        ),
      ],
    );
  }

  /// 构建下拉内容
  Widget _buildDropdownContent() {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    if (_expandedItem == null) {
      return const SizedBox.shrink();
    }

    // 如果提供了自定义内容
    if (_expandedItem!.customContentBuilder != null) {
      return _expandedItem!.customContentBuilder!(context);
    }

    // 默认列表内容
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      color: Colors.white,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: _expandedItem!.options.length,
        itemBuilder: (context, index) {
          final option = _expandedItem!.options[index];
          final isSelected = option.value == _expandedItem!.selectedValue;
          return GestureDetector(
            onTap: () {
              _expandedItem!.onChanged?.call(option.value);
              _closeAll();
            },
            child: Container(
              height: 48,
              padding:
                  EdgeInsets.symmetric(horizontal: commonConfig.hSpacingMd),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      option.label,
                      style: TextStyle(
                        fontSize: commonConfig.fontSizeBase,
                        color: isSelected
                            ? _activeColor
                            : const Color(0xFF17233D),
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check,
                      size: 18,
                      color: _activeColor,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
