import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:santo_ui/src/components/checkbox/santo_checkbox.dart';

/// 分组勾选状态变化监听:返回当前勾选的 id 列表
typedef SantoCheckboxGroupChange = void Function(List<String> checkedIds);

/// 复选框分组控制器,可外部操作组内勾选状态
class SantoCheckboxGroupController {
  SantoCheckboxGroupState? _state;

  /// 全选/全不选,忽略最大勾选数限制
  void toggleAll(bool check) {
    _state?.toggleAll(check);
  }

  /// 反选
  void reverseAll() {
    _state?.reverseAll();
  }

  /// 设置某一项的勾选状态
  void toggle(String id, bool check) {
    _state?.toggle(id, check, true);
  }

  /// 已勾选的 id 列表
  List<String> allChecked() {
    return _state?.allCheckedIds ?? [];
  }

  /// 某一项是否已勾选
  bool checked(String id) {
    return allChecked().contains(id);
  }
}

/// 复选框分组
///
/// [child] 可以是任意包含 [SantoCheckbox] 的容器,组内设置了 [SantoCheckbox.id]
/// 的复选框才纳入分组管理:
/// ```dart
/// SantoCheckboxGroup(
///   checkedIds: const ['1'],
///   child: Column(children: const [
///     SantoCheckbox(id: '0', title: '选项一'),
///     SantoCheckbox(id: '1', title: '选项二'),
///   ]),
/// )
/// ```
class SantoCheckboxGroup extends StatefulWidget {
  const SantoCheckboxGroup({
    Key? key,
    required this.child,
    this.onChangeGroup,
    this.controller,
    this.checkedIds,
    this.maxChecked,
    this.onOverloadChecked,
    this.titleMaxLine,
    this.customContentBuilder,
    this.contentDirection,
    this.style,
    this.spacing,
    this.customIconBuilder,
  }) : super(key: key);

  /// 分组容器,内部放置若干 [SantoCheckbox]
  final Widget child;

  /// 勾选状态变化监听
  final SantoCheckboxGroupChange? onChangeGroup;

  /// 分组控制器
  final SantoCheckboxGroupController? controller;

  /// 初始勾选的 id 列表
  final List<String>? checkedIds;

  /// 最多可勾选数量
  final int? maxChecked;

  /// 超出最大可勾选数量时回调
  final VoidCallback? onOverloadChecked;

  /// 组内复选框标题最大行数
  final int? titleMaxLine;

  /// 组内复选框完全自定义内容
  final SantoCheckboxContentBuilder? customContentBuilder;

  /// 组内复选框内容方位
  final SantoContentDirection? contentDirection;

  /// 组内复选框勾选样式
  final SantoCheckboxStyle? style;

  /// 组内复选框指示器与内容的距离
  final double? spacing;

  /// 组内复选框自定义指示器
  final SantoCheckboxIconBuilder? customIconBuilder;

  @override
  State<SantoCheckboxGroup> createState() => SantoCheckboxGroupState();
}

class SantoCheckboxGroupState extends State<SantoCheckboxGroup> {
  /// 分组内所有复选框的勾选状态
  final Map<String, bool> checkBoxStates = {};

  @override
  void initState() {
    super.initState();
    widget.controller?._state = this;
    _syncCheckState(widget.checkedIds);
  }

  @override
  void didUpdateWidget(SantoCheckboxGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.checkedIds, widget.checkedIds)) {
      _syncCheckState(widget.checkedIds);
    }
  }

  void _syncCheckState(List<String>? checkedIds) {
    checkBoxStates.clear();
    checkedIds?.forEach((id) => checkBoxStates[id] = true);
  }

  /// 已勾选的 id 列表
  List<String> get allCheckedIds =>
      checkBoxStates.entries.where((e) => e.value).map((e) => e.key).toList();

  /// 取某一项的勾选状态,首次访问时以复选框自身状态初始化
  bool getCheckBoxStateById(String id, bool checked) {
    if (checkBoxStates[id] == null) {
      checkBoxStates[id] = checked;
    }
    return checkBoxStates[id]!;
  }

  /// 勾选某一项;返回 false 表示超出最大勾选数被拦截
  bool toggle(String id, bool check, [bool notify = false]) {
    if (check && widget.maxChecked != null) {
      if (checkBoxStates.values.where((v) => v).length >= widget.maxChecked!) {
        widget.onOverloadChecked?.call();
        return false;
      }
    }
    checkBoxStates[id] = check;
    if (notify) {
      setState(() {});
    }
    _notifyChange();
    return true;
  }

  /// 全选/全不选
  void toggleAll(bool check, [bool notify = true]) {
    var changed = false;
    for (final id in checkBoxStates.keys.toList()) {
      if (check && !toggle(id, true)) break;
      if (!check) toggle(id, false);
      changed = true;
    }
    if (changed && notify) {
      setState(() {});
      _notifyChange();
    }
  }

  /// 反选
  void reverseAll() {
    for (final id in checkBoxStates.keys.toList()) {
      toggle(id, !(checkBoxStates[id] ?? false));
    }
    setState(() {});
    _notifyChange();
  }

  void _notifyChange() {
    widget.onChangeGroup?.call(allCheckedIds);
  }

  @override
  Widget build(BuildContext context) {
    return SantoCheckboxGroupInherited(this, widget.child);
  }
}

/// 把分组状态传递给组内复选框
class SantoCheckboxGroupInherited extends InheritedWidget {
  const SantoCheckboxGroupInherited(this.state, Widget child, {Key? key})
      : super(child: child, key: key);

  final SantoCheckboxGroupState state;

  /// 取树上的分组节点
  static SantoCheckboxGroupInherited? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SantoCheckboxGroupInherited>();
  }

  @override
  bool updateShouldNotify(covariant SantoCheckboxGroupInherited oldWidget) =>
      true;
}

/// 已勾选 id 列表变化监听(分组容器使用)
typedef SantoCheckBoxGroupChange = void Function(List<String> ids);

/// 带排布能力的分组容器
///
/// 使用 [direction] + [directionalCheckboxes] 时按横向/纵向排列,
/// 使用 [child] 时可自行组织布局(两者只能二选一)。
class SantoCheckboxGroupContainer extends SantoCheckboxGroup {
  SantoCheckboxGroupContainer({
    Key? key,
    Widget? child,
    Axis? direction,
    List<SantoCheckbox>? directionalCheckboxes,
    List<String>? selectIds,
    bool? passThrough,
    bool cardMode = false,
    int? titleMaxLine,
    int? maxSelected,
    SantoCheckboxStyle? style,
    SantoCheckboxGroupController? controller,
    SantoCheckboxIconBuilder? customIconBuilder,
    SantoCheckboxContentBuilder? customContentBuilder,
    double? spacing,
    SantoContentDirection? contentDirection,
    SantoCheckBoxGroupChange? onCheckBoxGroupChange,
    VoidCallback? onOverloadChecked,
    int? rowCount,
  })  : assert(
          direction == null || directionalCheckboxes != null,
          'SantoCheckboxGroupContainer: 设置 direction 时必须同时设置 directionalCheckboxes',
        ),
        assert(
          direction != null || child != null,
          'SantoCheckboxGroupContainer: 未设置 direction 时必须设置 child',
        ),
        super(
          key: key,
          child: _buildLayout(
            child: child,
            direction: direction,
            directionalCheckboxes: directionalCheckboxes ?? const [],
            cardMode: cardMode,
            passThrough: passThrough ?? false,
            rowCount: rowCount,
          ),
          onChangeGroup: (ids) => onCheckBoxGroupChange?.call(ids),
          onOverloadChecked: onOverloadChecked,
          controller: controller,
          checkedIds: selectIds,
          maxChecked: maxSelected,
          titleMaxLine: titleMaxLine,
          contentDirection: contentDirection,
          customIconBuilder: customIconBuilder,
          customContentBuilder: customContentBuilder,
          style: style,
          spacing: spacing,
        );

  static Widget _buildLayout({
    required Widget? child,
    required Axis? direction,
    required List<SantoCheckbox> directionalCheckboxes,
    required bool cardMode,
    required bool passThrough,
    required int? rowCount,
  }) {
    if (direction == null) return child!;
    final isHorizontal = direction == Axis.horizontal;
    // 非通栏样式:整体裁切圆角并向左右留出外边距
    Widget container = isHorizontal
        ? (cardMode
            ? Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.topLeft,
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: directionalCheckboxes
                      .map((e) => SizedBox(width: 106.3, height: 56, child: e))
                      .toList(),
                ),
              )
            : Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: _horizontalMoreThanOneRow(directionalCheckboxes, rowCount),
              ))
        : ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: directionalCheckboxes.length,
            separatorBuilder: (context, index) => cardMode
                ? const SizedBox(height: 12)
                : const SizedBox.shrink(),
            itemBuilder: (context, index) => Container(
              margin: cardMode
                  ? const EdgeInsets.symmetric(horizontal: 16)
                  : null,
              height: cardMode ? 82 : null,
              child: directionalCheckboxes[index],
            ),
          );

    // 非通栏样式仅用于纵向排列:整体裁切圆角并向左右留出外边距
    if (passThrough && !isHorizontal) {
      container = Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: container,
      );
    }
    return container;
  }

  /// 横向且超过一行时,按 rowCount 分列
  static Widget _horizontalMoreThanOneRow(
      List<SantoCheckbox> items, int? rowCount) {
    if (rowCount == null || rowCount <= 1) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: items.map((e) => Expanded(child: e)).toList(),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate((items.length / rowCount).ceil(), (index) {
        var end = (index + 1) * rowCount;
        if (end > items.length) end = items.length;
        final subList = items.sublist(index * rowCount, end);
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...subList.map((e) => Expanded(child: e)),
            if (subList.length < rowCount)
              ...List.generate(
                rowCount - subList.length,
                (index) => const Expanded(child: SizedBox()),
              ),
          ],
        );
      }),
    );
  }
}
