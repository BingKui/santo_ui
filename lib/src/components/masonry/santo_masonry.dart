import 'dart:math' as math;

import 'package:flutter/rendering.dart';

import 'package:flutter/material.dart';

/// 瀑布流组件:多列布局,子项按"最短列优先"规则依次排布。
///
/// API 对齐 Ant Design 6 的 Masonry 组件:
/// * [columns] 列数,默认 3
/// * [gutter] 水平间距,默认 0;[verticalGutter] 垂直间距,默认与 [gutter] 相同
/// * [items] 子项列表
///
/// 示例:
/// ```dart
/// SantoMasonry(
///   columns: 3,
///   gutter: 16,
///   items: [
///     Container(height: 100, color: Colors.red),
///     Container(height: 60, color: Colors.blue),
///   ],
/// )
/// ```
class SantoMasonry extends MultiChildRenderObjectWidget {
  /// 列数,默认 3
  final int columns;

  /// 水平间距,默认 0
  final double gutter;

  /// 垂直间距,默认与 [gutter] 相同
  final double? verticalGutter;

  /// 子项列表
  final List<Widget> items;

  SantoMasonry({
    Key? key,
    this.columns = 3,
    this.gutter = 0,
    this.verticalGutter,
    required this.items,
  })  : assert(columns >= 1, 'columns 至少为 1'),
        super(key: key, children: items);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSantoMasonry(
      columns: columns,
      gutter: gutter,
      verticalGutter: verticalGutter ?? gutter,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderSantoMasonry renderObject) {
    renderObject
      ..columns = columns
      ..gutter = gutter
      ..verticalGutter = verticalGutter ?? gutter;
  }
}

class SantoMasonryParentData extends ContainerBoxParentData<RenderBox> {}

class RenderSantoMasonry extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, SantoMasonryParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, SantoMasonryParentData> {
  RenderSantoMasonry({
    required int columns,
    required double gutter,
    required double verticalGutter,
  })  : _columns = columns,
        _gutter = gutter,
        _verticalGutter = verticalGutter;

  int _columns;
  int get columns => _columns;
  set columns(int value) {
    if (_columns == value) return;
    _columns = value;
    markNeedsLayout();
  }

  double _gutter;
  double get gutter => _gutter;
  set gutter(double value) {
    if (_gutter == value) return;
    _gutter = value;
    markNeedsLayout();
  }

  double _verticalGutter;
  double get verticalGutter => _verticalGutter;
  set verticalGutter(double value) {
    if (_verticalGutter == value) return;
    _verticalGutter = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! SantoMasonryParentData) {
      child.parentData = SantoMasonryParentData();
    }
  }

  @override
  void performLayout() {
    final count = childCount;
    if (count == 0) {
      size = constraints.smallest;
      return;
    }

    final width = constraints.maxWidth.isFinite
        ? constraints.maxWidth
        : 400.0;
    final vGap = _verticalGutter;
    final columnWidth =
        (width - _gutter * (_columns - 1)) / _columns;
    final columnHeights = List.filled(_columns, 0.0);

    RenderBox? child = firstChild;
    while (child != null) {
      final parentData = child.parentData as SantoMasonryParentData;

      // 找到当前最短的列
      int shortest = 0;
      for (int i = 1; i < _columns; i++) {
        if (columnHeights[i] < columnHeights[shortest]) shortest = i;
      }

      child.layout(
        BoxConstraints.tightFor(width: columnWidth),
        parentUsesSize: true,
      );

      final x = shortest * (columnWidth + _gutter);
      final y = columnHeights[shortest];
      parentData.offset = Offset(x, y);
      columnHeights[shortest] = y + child.size.height + vGap;

      child = parentData.nextSibling;
    }

    final maxHeight = columnHeights.reduce(math.max) - vGap;
    size = constraints.constrain(
        Size(width, count > 0 ? math.max(0.0, maxHeight) : 0.0));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
