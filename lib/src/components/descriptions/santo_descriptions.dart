import 'package:flutter/material.dart';
import 'package:santo_ui/src/theme/santo_theme.dart';

/// 描述列表的布局方向
enum SantoDescriptionsLayout {
  /// 标签在左、内容在右(默认)
  horizontal,

  /// 标签在上、内容在下
  vertical,
}

/// 描述列表的尺寸档位
enum SantoDescriptionsSize {
  /// 标签与内容 12 号,单元格横向内边距 10
  small,

  /// 标签与内容 14 号,单元格横向内边距 15(默认)
  medium,

  /// 标签与内容 16 号,单元格横向内边距 20
  large,
}

/// 描述列表的一项(对应 antd Descriptions.Item)
///
/// @since v1.1.0
class SantoDescriptionsItem {
  /// 标签文案
  final String? label;

  /// 自定义标签,优先级高于 [label]
  final Widget? labelWidget;

  /// 内容
  final Widget? child;

  /// 占几列,默认 1
  final int span;

  /// 是否占满当前行剩余列数,默认 false
  final bool filled;

  const SantoDescriptionsItem({
    this.label,
    this.labelWidget,
    this.child,
    this.span = 1,
    this.filled = false,
  });
}

/// 描述列表:成对展示 label 与内容,常见于详情页(对标 antd Descriptions)
///
/// 与 antd 的差异:[column] 默认 1(移动端单列),antd 默认 3;尺寸默认 [SantoDescriptionsSize.medium]。
///
/// ```dart
/// SantoDescriptions(
///   title: '用户信息',
///   items: const [
///     SantoDescriptionsItem(label: '姓名', child: Text('张三')),
///     SantoDescriptionsItem(label: '电话', child: Text('1810000000')),
///   ],
/// )
/// ```
///
/// @since v1.1.0
class SantoDescriptions extends StatelessWidget {
  /// 标题文案
  final String? title;

  /// 自定义标题,优先级高于 [title]
  final Widget? titleWidget;

  /// 标题右侧操作区
  final Widget? extra;

  /// 列表项
  final List<SantoDescriptionsItem> items;

  /// 每行放几项,默认 1(移动端单列)
  final int column;

  /// 布局方向,默认 [SantoDescriptionsLayout.horizontal]
  final SantoDescriptionsLayout layout;

  /// 是否显示单元格边框,默认 false
  final bool bordered;

  /// 尺寸档位,默认 [SantoDescriptionsSize.medium]
  final SantoDescriptionsSize size;

  /// 标签后是否显示冒号,默认 true
  final bool colon;

  /// horizontal 布局下标签列宽;为 null 时标签紧随内容,不占固定宽度
  final double? labelWidth;

  const SantoDescriptions({
    super.key,
    required this.items,
    this.title,
    this.titleWidget,
    this.extra,
    this.column = 1,
    this.layout = SantoDescriptionsLayout.horizontal,
    this.bordered = false,
    this.size = SantoDescriptionsSize.medium,
    this.colon = true,
    this.labelWidth,
  });

  double get _fontSize {
    switch (size) {
      case SantoDescriptionsSize.small:
        return 12;
      case SantoDescriptionsSize.medium:
        return 14;
      case SantoDescriptionsSize.large:
        return 16;
    }
  }

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final double cellGap = _cellGap(commonConfig);
    // 无边框时单元格只留横向内边距,行间用最小间距,避免上下留白翻倍
    final EdgeInsets cellPadding = bordered
        ? EdgeInsets.symmetric(horizontal: cellGap, vertical: cellGap)
        : EdgeInsets.symmetric(horizontal: cellGap);

    // 按 span / filled 把 items 折行
    final List<List<(SantoDescriptionsItem, int)>> rows =
        _groupRows(column);
    final Widget grid = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int r = 0; r < rows.length; r++) ...[
          if (r > 0 && !bordered)
            SizedBox(height: commonConfig.gapXs),
          _row(commonConfig, rows, r, cellPadding),
        ],
      ],
    );

    final Widget? header = _header(commonConfig);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (header != null) ...[
          header,
          SizedBox(height: commonConfig.vSpacingMd),
        ],
        if (bordered)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(commonConfig.radiusXs),
              border: Border.all(
                color: commonConfig.dividerColorBase,
                width: commonConfig.borderWidthSm,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: grid,
          )
        else
          grid,
      ],
    );
  }

  double _cellGap(SantoCommonConfig commonConfig) {
    switch (size) {
      case SantoDescriptionsSize.small:
        return commonConfig.gapSm;
      case SantoDescriptionsSize.medium:
        return commonConfig.gapMd;
      case SantoDescriptionsSize.large:
        return commonConfig.gapLg;
    }
  }

  List<List<(SantoDescriptionsItem, int)>> _groupRows(int column) {
    final int maxColumn = column < 1 ? 1 : column;
    final List<List<(SantoDescriptionsItem, int)>> rows = [];
    List<(SantoDescriptionsItem, int)> current = [];
    int used = 0;

    for (final SantoDescriptionsItem item in items) {
      final int span = item.filled
          ? (maxColumn - used).clamp(1, maxColumn)
          : item.span.clamp(1, maxColumn);
      if (used + span > maxColumn && current.isNotEmpty) {
        rows.add(current);
        current = [];
        used = 0;
      }
      final int effectiveSpan = item.filled
          ? (maxColumn - used).clamp(1, maxColumn)
          : span;
      current.add((item, effectiveSpan));
      used += effectiveSpan;
      if (used >= maxColumn) {
        rows.add(current);
        current = [];
        used = 0;
      }
    }
    if (current.isNotEmpty) {
      rows.add(current);
    }
    return rows;
  }

  /// 一行:有边框时用 [IntrinsicHeight] 让同行单元格等高,便于画竖分隔线
  Widget _row(
    SantoCommonConfig commonConfig,
    List<List<(SantoDescriptionsItem, int)>> rows,
    int rowIndex,
    EdgeInsets cellPadding,
  ) {
    final List<(SantoDescriptionsItem, int)> row = rows[rowIndex];
    final Widget rowContent = Row(
      crossAxisAlignment:
          bordered ? CrossAxisAlignment.stretch : CrossAxisAlignment.start,
      children: [
        for (int c = 0; c < row.length; c++)
          Expanded(
            flex: row[c].$2,
            child: _cell(
              commonConfig,
              row[c].$1,
              padding: cellPadding,
              isLastInRow: c == row.length - 1,
              isLastRow: rowIndex == rows.length - 1,
            ),
          ),
      ],
    );
    return bordered ? IntrinsicHeight(child: rowContent) : rowContent;
  }

  Widget? _header(SantoCommonConfig commonConfig) {
    final Widget? headerTitle = titleWidget ??
        (title == null
            ? null
            : Text(
                title!,
                style: TextStyle(
                  fontSize: commonConfig.fontSizeSubHead,
                  fontWeight: FontWeight.w500,
                  color: commonConfig.colorTextBase,
                ),
              ));
    if (headerTitle == null && extra == null) {
      return null;
    }
    return Row(
      children: [
        Expanded(child: headerTitle ?? const SizedBox.shrink()),
        ?extra,
      ],
    );
  }

  Widget _cell(
    SantoCommonConfig commonConfig,
    SantoDescriptionsItem item, {
    required EdgeInsets padding,
    required bool isLastInRow,
    required bool isLastRow,
  }) {
    final Widget? label = item.labelWidget ??
        (item.label == null
            ? null
            : Text(
                colon ? '${item.label}:' : item.label!,
                style: TextStyle(
                  fontSize: _fontSize,
                  color: commonConfig.colorTextSecondary,
                ),
              ));
    final Widget content = DefaultTextStyle.merge(
      style: TextStyle(
        fontSize: _fontSize,
        color: commonConfig.colorTextBase,
        height: 1.5,
      ),
      child: item.child ?? const SizedBox.shrink(),
    );

    final Widget body;
    if (layout == SantoDescriptionsLayout.vertical) {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null) ...[
            label,
            SizedBox(height: commonConfig.vSpacingXs),
          ],
          content,
        ],
      );
    } else {
      body = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            labelWidth == null
                ? label
                : SizedBox(width: labelWidth, child: label),
            SizedBox(width: commonConfig.hSpacingSm),
          ],
          Expanded(child: content),
        ],
      );
    }

    if (!bordered) {
      return Padding(padding: padding, child: body);
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        border: Border(
          right: isLastInRow
              ? BorderSide.none
              : BorderSide(
                  color: commonConfig.dividerColorBase,
                  width: commonConfig.borderWidthSm,
                ),
          bottom: isLastRow
              ? BorderSide.none
              : BorderSide(
                  color: commonConfig.dividerColorBase,
                  width: commonConfig.borderWidthSm,
                ),
        ),
      ),
      child: body,
    );
  }
}
