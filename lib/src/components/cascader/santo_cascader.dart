import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 级联选择器数据模型
///
/// 每个节点包含 [label] 显示文本、[value] 值，以及可选的 [children] 子节点列表。
class SantoCascaderItem {
  /// 显示文本
  final String label;

  /// 值
  final String value;

  /// 子节点列表
  final List<SantoCascaderItem>? children;

  SantoCascaderItem({
    required this.label,
    required this.value,
    this.children,
  });
}

/// 级联选择器确认回调
///
/// [selectedItems] 为每一级选中的数据列表，[selectedValues] 为每一级选中的值列表。
typedef SantoCascaderConfirmCallback = void Function(
    List<SantoCascaderItem> selectedItems, List<String> selectedValues);

/// 级联选择器取消回调
typedef SantoCascaderCancelCallback = void Function();

/// 级联选择器组件
///
/// 多级联动选择（如省/市/区），底部弹出式选择器。
///
/// 使用示例：
/// ```dart
/// SantoCascader.show(
///   context: context,
///   title: '请选择地区',
///   data: cascaderData,
///   onConfirm: (selectedItems, selectedValues) {
///     print(selectedValues);
///   },
/// );
/// ```
class SantoCascader extends StatefulWidget {
  /// 树形数据源
  final List<SantoCascaderItem> data;

  /// 选择器标题
  final String? title;

  /// 确认回调
  final SantoCascaderConfirmCallback? onConfirm;

  /// 取消回调
  final SantoCascaderCancelCallback? onCancel;

  /// 显示的列数，默认为 3
  final int columnCount;

  /// 初始选中的值列表（每一级对应一个值）
  final List<String>? initialValues;

  /// 确认按钮文字
  final String confirmText;

  /// 取消按钮文字
  final String cancelText;

  /// 主题色
  final Color? activeColor;

  const SantoCascader({
    Key? key,
    required this.data,
    this.title,
    this.onConfirm,
    this.onCancel,
    this.columnCount = 3,
    this.initialValues,
    this.confirmText = '确认',
    this.cancelText = '取消',
    this.activeColor,
  }) : super(key: key);

  /// 弹出级联选择器
  static void show({
    required BuildContext context,
    required List<SantoCascaderItem> data,
    String? title,
    int columnCount = 3,
    List<String>? initialValues,
    SantoCascaderConfirmCallback? onConfirm,
    SantoCascaderCancelCallback? onCancel,
    String confirmText = '确认',
    String cancelText = '取消',
    Color? activeColor,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return SantoCascader(
          data: data,
          title: title,
          columnCount: columnCount,
          initialValues: initialValues,
          onConfirm: onConfirm,
          onCancel: onCancel,
          confirmText: confirmText,
          cancelText: cancelText,
          activeColor: activeColor,
        );
      },
    );
  }

  @override
  State<SantoCascader> createState() => _SantoCascaderState();
}

class _SantoCascaderState extends State<SantoCascader> {
  /// 每一级当前选中的索引
  late List<int> _selectedIndices;

  /// 当前显示的列数据
  late List<List<SantoCascaderItem>> _columns;

  /// 每一列的滚动控制器
  late List<FixedExtentScrollController> _controllers;

  Color get _activeColor =>
      widget.activeColor ??
      SantoThemeConfigurator.instance.getConfig().commonConfig.brandPrimary;

  @override
  void initState() {
    super.initState();
    _initColumns();
  }

  /// 初始化列数据和选中索引
  void _initColumns() {
    _selectedIndices = List.filled(widget.columnCount, 0);
    _controllers = List.generate(
        widget.columnCount, (_) => FixedExtentScrollController());

    // 根据 initialValues 设置初始选中
    if (widget.initialValues != null && widget.initialValues!.isNotEmpty) {
      _applyInitialValues();
    }

    _buildColumns();
  }

  /// 应用初始值
  void _applyInitialValues() {
    List<SantoCascaderItem>? currentLevel = widget.data;
    for (int i = 0; i < widget.columnCount && i < widget.initialValues!.length; i++) {
      if (currentLevel == null || currentLevel.isEmpty) break;
      int idx = currentLevel.indexWhere(
          (item) => item.value == widget.initialValues![i]);
      if (idx >= 0) {
        _selectedIndices[i] = idx;
        currentLevel = currentLevel[idx].children;
      }
    }
  }

  /// 根据当前选中索引构建每一列的数据
  void _buildColumns() {
    _columns = [];
    List<SantoCascaderItem>? currentLevel = widget.data;

    for (int i = 0; i < widget.columnCount; i++) {
      if (currentLevel == null || currentLevel.isEmpty) break;
      _columns.add(currentLevel);

      int idx = _selectedIndices[i];
      if (idx >= currentLevel.length) {
        idx = 0;
        _selectedIndices[i] = 0;
      }
      currentLevel = currentLevel[idx].children;
    }
  }

  /// 某列选中变化时，更新后续列
  void _onColumnChanged(int columnIndex, int newIndex) {
    setState(() {
      _selectedIndices[columnIndex] = newIndex;

      // 清除后续列的选中并重新构建
      for (int i = columnIndex + 1; i < widget.columnCount; i++) {
        _selectedIndices[i] = 0;
      }

      _buildColumns();

      // 滚动后续列到初始位置
      for (int i = columnIndex + 1; i < _controllers.length && i < _columns.length; i++) {
        if (_controllers[i].hasClients) {
          _controllers[i].jumpToItem(0);
        }
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = MediaQueryData.fromView(View.of(context)).padding;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          _buildDivider(),
          _buildColumnsView(),
          SizedBox(height: padding.bottom),
        ],
      ),
    );
  }

  /// 构建头部（取消、标题、确认）
  Widget _buildHeader() {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              widget.onCancel?.call();
              Navigator.of(context).pop();
            },
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.cancelText,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF666666),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                widget.title ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF222222),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _onConfirm();
            },
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.confirmText,
                style: TextStyle(
                  fontSize: 15,
                  color: _activeColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建分割线
  Widget _buildDivider() {
    return const Divider(
      height: 0.5,
      thickness: 0.5,
      color: Color(0xFFF0F0F0),
    );
  }

  /// 构建多列选择视图
  Widget _buildColumnsView() {
    return SizedBox(
      height: 250,
      child: Row(
        children: List.generate(_columns.length, (colIndex) {
          return Expanded(
            child: _buildSingleColumn(colIndex),
          );
        }),
      ),
    );
  }

  /// 构建单列
  Widget _buildSingleColumn(int colIndex) {
    final items = _columns[colIndex];
    final selectedIndex = _selectedIndices[colIndex];

    return ListWheelScrollView.useDelegate(
      controller: _controllers[colIndex],
      itemExtent: 40,
      perspective: 0.001,
      diameterRatio: 2.5,
      onSelectedItemChanged: (index) {
        _onColumnChanged(colIndex, index);
      },
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: items.length,
        builder: (context, index) {
          final isSelected = index == selectedIndex;
          return Center(
            child: Text(
              items[index].label,
              style: TextStyle(
                fontSize: 15,
                color: isSelected ? _activeColor : const Color(0xFF222222),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ),
    );
  }

  /// 确认选择
  void _onConfirm() {
    List<SantoCascaderItem> selectedItems = [];
    List<String> selectedValues = [];

    for (int i = 0; i < _columns.length; i++) {
      int idx = _selectedIndices[i];
      if (idx < _columns[i].length) {
        selectedItems.add(_columns[i][idx]);
        selectedValues.add(_columns[i][idx].value);
      }
    }

    widget.onConfirm?.call(selectedItems, selectedValues);
    Navigator.of(context).pop();
  }
}
