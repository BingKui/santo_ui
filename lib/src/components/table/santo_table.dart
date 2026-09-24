import 'package:flutter/material.dart';
import 'package:santo_ui/src/components/pagination/santo_pagination.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 表格列对齐方式
enum SantoTableAlign { left, center, right }

/// 列的固定位置,对标 antd Table 的 `column.fixed`
enum SantoTableColumnFixed { left, right }

/// 行选择模式
///
/// @since v1.4.0
enum SantoTableSelectionMode { multiple, single }

/// 排序方向
///
/// @since v1.4.0
enum SantoTableSortOrder { ascending, descending }

/// 单元格合并范围
///
/// `rowSpan` 为纵向合并行数,`colSpan` 为横向合并列数。设置为 0 时隐藏
/// 当前单元格;大于 1 时,后续被覆盖的单元格会自动隐藏。
///
/// @since v1.4.0
class SantoTableCellSpan {
  final int rowSpan;
  final int colSpan;

  const SantoTableCellSpan({this.rowSpan = 1, this.colSpan = 1})
    : assert(rowSpan >= 0),
      assert(colSpan >= 0);
}

/// 当前排序状态
///
/// @since v1.4.0
class SantoTableSortState {
  final int columnIndex;
  final SantoTableSortOrder? order;

  const SantoTableSortState({required this.columnIndex, required this.order});
}

typedef SantoTableRowKeyBuilder = Object Function(
  List<dynamic> row,
  int sourceIndex,
);
typedef SantoTableRowSelectable = bool Function(
  List<dynamic> row,
  int sourceIndex,
);
typedef SantoTableSelectionChanged = void Function(
  Set<Object> selectedRowKeys,
  List<List<dynamic>> selectedRows,
);
typedef SantoTableExpandedBuilder = Widget Function(
  BuildContext context,
  List<dynamic> row,
  int rowIndex,
);

/// 表格行选择配置
///
/// [selectedRowKeys] 不为 null 时为受控模式;否则组件维护内部状态,并以
/// [defaultSelectedRowKeys] 作为初始值。
///
/// @since v1.4.0
class SantoTableSelection {
  final SantoTableSelectionMode mode;
  final Set<Object>? selectedRowKeys;
  final Set<Object> defaultSelectedRowKeys;
  final SantoTableRowSelectable? rowSelectable;
  final SantoTableSelectionChanged? onChanged;
  final bool showSelectAll;
  final double columnWidth;

  const SantoTableSelection({
    this.mode = SantoTableSelectionMode.multiple,
    this.selectedRowKeys,
    this.defaultSelectedRowKeys = const <Object>{},
    this.rowSelectable,
    this.onChanged,
    this.showSelectAll = true,
    this.columnWidth = 48,
  }) : assert(columnWidth > 0);
}

/// 表格展开行配置
///
/// 展开按钮显示在首个数据列中,展开内容显示在当前行下方。
///
/// @since v1.4.0
class SantoTableExpandable {
  final SantoTableExpandedBuilder builder;
  final Set<Object>? expandedRowKeys;
  final Set<Object> defaultExpandedRowKeys;
  final SantoTableRowSelectable? rowExpandable;
  final ValueChanged<Set<Object>>? onChanged;
  final double expandedHeight;

  const SantoTableExpandable({
    required this.builder,
    this.expandedRowKeys,
    this.defaultExpandedRowKeys = const <Object>{},
    this.rowExpandable,
    this.onChanged,
    this.expandedHeight = 96,
  }) : assert(expandedHeight > 0);
}

/// 表格分页配置
///
/// @since v1.4.0
class SantoTablePagination {
  final int currentPage;
  final int pageSize;
  final List<int> pageSizeOptions;
  final bool showPageSizeSelector;
  final ValueChanged<int>? onPageChanged;
  final ValueChanged<int>? onPageSizeChanged;

  const SantoTablePagination({
    this.currentPage = 1,
    this.pageSize = 10,
    this.pageSizeOptions = const <int>[10, 20, 50],
    this.showPageSizeSelector = true,
    this.onPageChanged,
    this.onPageSizeChanged,
  }) : assert(currentPage > 0),
       assert(pageSize > 0);
}

/// 表格列配置
///
/// @since v1.0.0
/// @changed v1.4.0 新增排序和单元格合并能力
class SantoTableColumn {
  final String title;
  final double? width;
  final SantoTableAlign align;
  final SantoTableColumnFixed? fixed;

  /// 自定义单元格内容构建器
  final Widget Function(dynamic cellData, int rowIndex, int colIndex)?
  cellBuilder;

  /// 自定义表头内容构建器
  final Widget Function(String title)? headerBuilder;

  /// 单元格值比较器;不为 null 时点击表头可切换升序、降序和取消排序
  ///
  /// @since v1.4.0
  final Comparator<dynamic>? sorter;

  /// 初始排序方向
  ///
  /// @since v1.4.0
  final SantoTableSortOrder? defaultSortOrder;

  /// 单元格合并配置构建器
  ///
  /// @since v1.4.0
  final SantoTableCellSpan Function(
    dynamic cellData,
    int rowIndex,
    int colIndex,
  )?
  spanBuilder;

  /// 创建表格列配置
  ///
  /// @since v1.0.0
  /// @changed v1.4.0 新增 sorter、defaultSortOrder、spanBuilder
  const SantoTableColumn({
    required this.title,
    this.width,
    this.align = SantoTableAlign.center,
    this.fixed,
    this.cellBuilder,
    this.headerBuilder,
    this.sorter,
    this.defaultSortOrder,
    this.spanBuilder,
  });
}

/// 横向滚动模式下未定宽列的默认列宽
const double kSantoTableDefaultColumnWidth = 120;

/// Table 数据表格组件
///
/// 支持自定义渲染、单元格合并、行选择、排序、展开行、分页、固定高度滚动、
/// 横向滚动、固定列与边框控制。
///
/// @since v1.0.0
/// @changed v1.4.0 新增合并、选择、排序、展开行和分页
class SantoTable extends StatefulWidget {
  final List<SantoTableColumn> columns;
  final List<List<dynamic>> data;

  /// 是否显示外框与单元格分割线
  final bool border;
  final Color? borderColor;

  /// 单元格边框宽度,不传时取主题 borderWidthSm
  final double? borderWidth;

  /// 表头背景色;默认使用主题浅填充色
  final Color? headerColor;

  /// 表头文字颜色;默认使用主题主文字色
  final Color? headerTextColor;
  final TextStyle? headerTextStyle;
  final TextStyle? cellTextStyle;
  final Color? cellTextColor;
  final double rowHeight;
  final double headerHeight;
  final EdgeInsets? cellPadding;
  final Color? oddRowColor;
  final Color? evenRowColor;
  final bool striped;

  /// 内容区固定高度,超出后纵向滚动且表头固定
  final double? height;
  final double? tableWidth;
  final Widget? empty;

  /// 数据行唯一标识;选择和展开功能建议显式设置
  ///
  /// @since v1.4.0
  final SantoTableRowKeyBuilder? rowKey;

  /// 行选择配置
  ///
  /// @since v1.4.0
  final SantoTableSelection? selection;

  /// 展开行配置
  ///
  /// @since v1.4.0
  final SantoTableExpandable? expandable;

  /// 分页配置;为 null 时不分页
  ///
  /// @since v1.4.0
  final SantoTablePagination? pagination;

  /// 排序变化回调
  ///
  /// @since v1.4.0
  final ValueChanged<SantoTableSortState>? onSortChanged;

  /// 创建表格
  ///
  /// @since v1.0.0
  /// @changed v1.4.0 新增 rowKey、selection、expandable、pagination、onSortChanged
  const SantoTable({
    Key? key,
    required this.columns,
    required this.data,
    this.border = true,
    this.borderColor,
    this.borderWidth,
    this.headerColor,
    this.headerTextColor,
    this.headerTextStyle,
    this.cellTextStyle,
    this.cellTextColor,
    this.rowHeight = 48,
    this.headerHeight = 48,
    this.cellPadding,
    this.oddRowColor,
    this.evenRowColor,
    this.striped = false,
    this.height,
    this.tableWidth,
    this.empty,
    this.rowKey,
    this.selection,
    this.expandable,
    this.pagination,
    this.onSortChanged,
  }) : assert(borderWidth == null || borderWidth >= 0),
       assert(rowHeight > 0),
       assert(headerHeight > 0),
       super(key: key);

  @override
  State<SantoTable> createState() => _SantoTableState();
}

class _SantoTableState extends State<SantoTable> {
  /// 单元格边框宽度,未显式指定时取主题 borderWidthSm
  double get _borderWidth =>
      widget.borderWidth ??
      SantoThemeConfigurator.instance.getConfig().commonConfig.borderWidthSm;

  ScrollController? _verticalController;
  ScrollController? _leftVerticalController;
  ScrollController? _rightVerticalController;
  ScrollController? _selectionVerticalController;
  bool _syncingVertical = false;
  bool _verticalListenerAttached = false;

  int? _sortColumnIndex;
  SantoTableSortOrder? _sortOrder;
  late int _currentPage;
  late int _pageSize;
  late Set<Object> _selectedRowKeys;
  late Set<Object> _expandedRowKeys;

  ScrollController get _mainVerticalController =>
      _verticalController ??= ScrollController();
  ScrollController get _leftFixedVerticalController =>
      _leftVerticalController ??= ScrollController();
  ScrollController get _rightFixedVerticalController =>
      _rightVerticalController ??= ScrollController();
  ScrollController get _selectionFixedVerticalController =>
      _selectionVerticalController ??= ScrollController();

  @override
  void initState() {
    super.initState();
    _currentPage = widget.pagination?.currentPage ?? 1;
    _pageSize = widget.pagination?.pageSize ?? 10;
    _selectedRowKeys = Set<Object>.of(
      widget.selection?.defaultSelectedRowKeys ?? const <Object>{},
    );
    _expandedRowKeys = Set<Object>.of(
      widget.expandable?.defaultExpandedRowKeys ?? const <Object>{},
    );
    for (int index = 0; index < widget.columns.length; index += 1) {
      if (widget.columns[index].defaultSortOrder != null) {
        _sortColumnIndex = index;
        _sortOrder = widget.columns[index].defaultSortOrder;
        break;
      }
    }
  }

  @override
  void didUpdateWidget(covariant SantoTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pagination?.currentPage != oldWidget.pagination?.currentPage) {
      _currentPage = widget.pagination?.currentPage ?? 1;
    }
    if (widget.pagination?.pageSize != oldWidget.pagination?.pageSize) {
      _pageSize = widget.pagination?.pageSize ?? 10;
    }
  }

  @override
  void dispose() {
    _verticalController?.dispose();
    _leftVerticalController?.dispose();
    _rightVerticalController?.dispose();
    _selectionVerticalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commonConfig = SantoThemeConfigurator.instance
        .getConfig()
        .commonConfig;
    final Color borderColor =
        widget.borderColor ?? commonConfig.dividerColorBase;
    final Color headerTextColor =
        widget.headerTextColor ?? commonConfig.colorTextBase;
    final Color cellTextColor =
        widget.cellTextColor ?? commonConfig.colorTextBase;
    final Color oddColor = widget.oddRowColor ?? commonConfig.fillBase;
    final Color evenColor = widget.evenRowColor ?? commonConfig.fillBody;
    final TextStyle headerStyle =
        widget.headerTextStyle ??
        TextStyle(
          color: headerTextColor,
          fontSize: commonConfig.fontSizeBase,
          fontWeight: FontWeight.w600,
        );
    final TextStyle cellStyle =
        widget.cellTextStyle ??
        TextStyle(color: cellTextColor, fontSize: commonConfig.fontSizeBase);
    final List<_TableRowEntry> sortedRows = _sortedRows();
    final List<_TableRowEntry> visibleRows = _pagedRows(sortedRows);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double containerWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : (widget.tableWidth ?? 0);
        final _TableLayout layout = _resolveLayout(containerWidth);
        final Widget table =
            widget.columns.any((column) => column.spanBuilder != null)
            ? _buildMergedTable(
                rows: visibleRows,
                layout: layout,
                containerWidth: containerWidth,
                borderColor: borderColor,
                oddColor: oddColor,
                evenColor: evenColor,
                headerStyle: headerStyle,
                cellStyle: cellStyle,
              )
            : layout.scroll
            ? _buildScrollTable(
                rows: visibleRows,
                layout: layout,
                borderColor: borderColor,
                oddColor: oddColor,
                evenColor: evenColor,
                headerStyle: headerStyle,
                cellStyle: cellStyle,
              )
            : _buildFlexTable(
                rows: visibleRows,
                borderColor: borderColor,
                oddColor: oddColor,
                evenColor: evenColor,
                headerStyle: headerStyle,
                cellStyle: cellStyle,
              );
        if (widget.pagination == null) return table;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            table,
            SizedBox(height: commonConfig.vSpacingMd),
            _buildPagination(sortedRows.length),
          ],
        );
      },
    );
  }

  List<_TableRowEntry> _sortedRows() {
    final List<_TableRowEntry> rows = List<_TableRowEntry>.generate(
      widget.data.length,
      (int index) => _TableRowEntry(
        data: widget.data[index],
        sourceIndex: index,
        key: widget.rowKey?.call(widget.data[index], index) ?? index,
      ),
    );
    final int? columnIndex = _sortColumnIndex;
    final SantoTableSortOrder? order = _sortOrder;
    if (columnIndex == null ||
        order == null ||
        columnIndex >= widget.columns.length) {
      return rows;
    }
    final Comparator<dynamic>? comparator = widget.columns[columnIndex].sorter;
    if (comparator == null) return rows;
    rows.sort((_TableRowEntry left, _TableRowEntry right) {
      final dynamic leftValue = columnIndex < left.data.length
          ? left.data[columnIndex]
          : null;
      final dynamic rightValue = columnIndex < right.data.length
          ? right.data[columnIndex]
          : null;
      final int result = comparator(leftValue, rightValue);
      if (result == 0) return left.sourceIndex.compareTo(right.sourceIndex);
      return order == SantoTableSortOrder.ascending ? result : -result;
    });
    return rows;
  }

  List<_TableRowEntry> _pagedRows(List<_TableRowEntry> rows) {
    if (widget.pagination == null) return rows;
    final int pageCount = (rows.length / _pageSize).ceil().clamp(1, 1 << 30);
    final int page = _currentPage.clamp(1, pageCount);
    final int start = (page - 1) * _pageSize;
    if (start >= rows.length) return const <_TableRowEntry>[];
    return rows.sublist(start, (start + _pageSize).clamp(0, rows.length));
  }

  _TableLayout _resolveLayout(double containerWidth) {
    final double selectionWidth = widget.selection?.columnWidth ?? 0;
    final double availableWidth = (containerWidth - selectionWidth).clamp(
      0,
      double.infinity,
    );
    final bool hasFixed = widget.columns.any((column) => column.fixed != null);
    final List<double?> widths = widget.columns
        .map((column) => column.width)
        .toList();
    final double fixedSum = widths.fold<double>(
      0,
      (double sum, double? width) => sum + (width ?? 0),
    );
    final int autoCount = widths.where((double? width) => width == null).length;
    final bool scroll =
        hasFixed || (autoCount == 0 && fixedSum > availableWidth + 0.1);
    if (scroll) {
      final List<double> resolved = widths
          .map((double? width) => width ?? kSantoTableDefaultColumnWidth)
          .toList();
      return _TableLayout(
        scroll: true,
        widths: resolved,
        contentWidth: resolved.fold<double>(
          0,
          (double sum, double width) => sum + width,
        ),
      );
    }
    return const _TableLayout(scroll: false);
  }

  Widget _buildFlexTable({
    required List<_TableRowEntry> rows,
    required Color borderColor,
    required Color oddColor,
    required Color evenColor,
    required TextStyle headerStyle,
    required TextStyle cellStyle,
  }) {
    Widget body;
    if (rows.isEmpty) {
      body = _buildEmptyPlaceholder(oddColor);
    } else if (widget.height != null) {
      body = SizedBox(
        height: widget.height,
        child: ListView.builder(
          controller: _mainVerticalController,
          padding: EdgeInsets.zero,
          itemCount: rows.length,
          itemBuilder: (BuildContext context, int index) => _buildFlexDataItem(
            rows[index],
            index,
            borderColor,
            cellStyle,
            _rowBgColor(index, oddColor, evenColor),
          ),
        ),
      );
    } else {
      body = Column(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(
          rows.length,
          (int index) => _buildFlexDataItem(
            rows[index],
            index,
            borderColor,
            cellStyle,
            _rowBgColor(index, oddColor, evenColor),
          ),
        ),
      );
    }
    return _buildTableShell(
      borderColor: borderColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              if (widget.selection != null)
                _buildSelectionHeader(rows, borderColor),
              Expanded(
                child: _buildHeaderRow(
                  columns: _allIndices(),
                  rows: rows,
                  borderColor: borderColor,
                  style: headerStyle,
                  widths: null,
                  hasAutoColumns: widget.columns.any(
                    (column) => column.width == null,
                  ),
                ),
              ),
            ],
          ),
          body,
        ],
      ),
    );
  }

  Widget _buildFlexDataItem(
    _TableRowEntry entry,
    int rowIndex,
    Color borderColor,
    TextStyle style,
    Color backgroundColor,
  ) {
    final bool hasAutoColumns = widget.columns.any(
      (column) => column.width == null,
    );
    final Widget row = SizedBox(
      height: widget.rowHeight,
      child: DecoratedBox(
        decoration: _rowDecoration(backgroundColor, borderColor),
        child: Row(
          children: <Widget>[
            if (widget.selection != null)
              _buildSelectionCell(entry, borderColor),
            Expanded(
              child: Row(
                children: List<Widget>.generate(widget.columns.length, (
                  int columnIndex,
                ) {
                  final SantoTableColumn column = widget.columns[columnIndex];
                  return _wrapColumnWidth(
                    column,
                    _buildCell(
                      entry: entry,
                      column: column,
                      rowIndex: rowIndex,
                      columnIndex: columnIndex,
                      style: style,
                      borderColor: borderColor,
                      showRightBorder: columnIndex < widget.columns.length - 1,
                    ),
                    hasAutoColumns: hasAutoColumns,
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
    return _wrapExpandedRow(entry, rowIndex, row, null);
  }

  Widget _buildScrollTable({
    required List<_TableRowEntry> rows,
    required _TableLayout layout,
    required Color borderColor,
    required Color oddColor,
    required Color evenColor,
    required TextStyle headerStyle,
    required TextStyle cellStyle,
  }) {
    final List<int> leftIndices = <int>[];
    final List<int> middleIndices = <int>[];
    final List<int> rightIndices = <int>[];
    for (int index = 0; index < widget.columns.length; index += 1) {
      switch (widget.columns[index].fixed) {
        case SantoTableColumnFixed.left:
          leftIndices.add(index);
        case SantoTableColumnFixed.right:
          rightIndices.add(index);
        case null:
          middleIndices.add(index);
      }
    }
    double widthOf(List<int> indices) => indices.fold<double>(
      0,
      (double sum, int index) => sum + layout.widths![index],
    );
    final double leftWidth = widthOf(leftIndices);
    final double middleWidth = widthOf(middleIndices);
    final double rightWidth = widthOf(rightIndices);

    if (widget.height != null && !_verticalListenerAttached) {
      _mainVerticalController.addListener(_syncFixedAreas);
      _verticalListenerAttached = true;
    }

    Widget areaBody(
      List<int> indices,
      double width,
      ScrollController? controller,
      bool showExpandedContent,
    ) {
      if (rows.isEmpty) return _buildEmptyPlaceholder(oddColor);
      Widget item(int index) => _buildScrollDataItem(
        entry: rows[index],
        rowIndex: index,
        indices: indices,
        widths: layout.widths!,
        width: width,
        borderColor: borderColor,
        style: cellStyle,
        backgroundColor: _rowBgColor(index, oddColor, evenColor),
        showExpandedContent: showExpandedContent,
      );
      if (widget.height != null) {
        return SizedBox(
          height: widget.height,
          child: ListView.builder(
            controller: controller,
            padding: EdgeInsets.zero,
            physics: identical(controller, _verticalController)
                ? null
                : const NeverScrollableScrollPhysics(),
            itemCount: rows.length,
            itemBuilder: (BuildContext context, int index) => item(index),
          ),
        );
      }
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(rows.length, item),
      );
    }

    Widget area(
      List<int> indices,
      double width,
      ScrollController? controller, {
      bool showExpandedContent = false,
    }) {
      return SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildHeaderRow(
              columns: indices,
              rows: rows,
              borderColor: borderColor,
              style: headerStyle,
              widths: layout.widths,
              hasAutoColumns: false,
            ),
            areaBody(indices, width, controller, showExpandedContent),
          ],
        ),
      );
    }

    final bool expandedInMiddle = middleIndices.isNotEmpty;
    return _buildTableShell(
      borderColor: borderColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.selection != null)
            SizedBox(
              width: widget.selection!.columnWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildSelectionHeader(rows, borderColor),
                  _buildSelectionAreaBody(
                    rows,
                    borderColor,
                    oddColor,
                    evenColor,
                  ),
                ],
              ),
            ),
          if (leftIndices.isNotEmpty)
            area(
              leftIndices,
              leftWidth,
              _leftFixedVerticalController,
              showExpandedContent: !expandedInMiddle,
            ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: middleWidth,
                child: area(
                  middleIndices,
                  middleWidth,
                  _mainVerticalController,
                  showExpandedContent: expandedInMiddle,
                ),
              ),
            ),
          ),
          if (rightIndices.isNotEmpty)
            area(rightIndices, rightWidth, _rightFixedVerticalController),
        ],
      ),
    );
  }

  Widget _buildScrollDataItem({
    required _TableRowEntry entry,
    required int rowIndex,
    required List<int> indices,
    required List<double> widths,
    required double width,
    required Color borderColor,
    required TextStyle style,
    required Color backgroundColor,
    required bool showExpandedContent,
  }) {
    final Widget row = SizedBox(
      height: widget.rowHeight,
      child: DecoratedBox(
        decoration: _rowDecoration(backgroundColor, borderColor),
        child: Row(
          children: <Widget>[
            for (final int columnIndex in indices)
              SizedBox(
                width: widths[columnIndex],
                child: _buildCell(
                  entry: entry,
                  column: widget.columns[columnIndex],
                  rowIndex: rowIndex,
                  columnIndex: columnIndex,
                  style: style,
                  borderColor: borderColor,
                  showRightBorder: columnIndex < widget.columns.length - 1,
                ),
              ),
          ],
        ),
      ),
    );
    return _wrapExpandedRow(
      entry,
      rowIndex,
      row,
      showExpandedContent ? width : 0,
    );
  }

  Widget _buildSelectionAreaBody(
    List<_TableRowEntry> rows,
    Color borderColor,
    Color oddColor,
    Color evenColor,
  ) {
    if (rows.isEmpty) return _buildEmptyPlaceholder(oddColor);
    Widget item(int index) {
      final _TableRowEntry entry = rows[index];
      final Widget row = SizedBox(
        height: widget.rowHeight,
        child: DecoratedBox(
          decoration: _rowDecoration(
            _rowBgColor(index, oddColor, evenColor),
            borderColor,
          ),
          child: _buildSelectionCell(entry, borderColor),
        ),
      );
      return _wrapExpandedRow(entry, index, row, 0);
    }

    if (widget.height != null) {
      return SizedBox(
        height: widget.height,
        child: ListView.builder(
          controller: _selectionFixedVerticalController,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rows.length,
          itemBuilder: (BuildContext context, int index) => item(index),
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(rows.length, item),
    );
  }

  Widget _buildMergedTable({
    required List<_TableRowEntry> rows,
    required _TableLayout layout,
    required double containerWidth,
    required Color borderColor,
    required Color oddColor,
    required Color evenColor,
    required TextStyle headerStyle,
    required TextStyle cellStyle,
  }) {
    final double selectionWidth = widget.selection?.columnWidth ?? 0;
    final double availableWidth = (containerWidth - selectionWidth).clamp(
      0,
      double.infinity,
    );
    final List<double> widths =
        layout.widths ?? _resolveFlexWidths(availableWidth);
    final double dataWidth = widths.fold<double>(
      0,
      (double sum, double width) => sum + width,
    );
    final double totalWidth = dataWidth + selectionWidth;
    final Widget header = Row(
      children: <Widget>[
        if (widget.selection != null) _buildSelectionHeader(rows, borderColor),
        SizedBox(
          width: dataWidth,
          child: _buildHeaderRow(
            columns: _allIndices(),
            rows: rows,
            borderColor: borderColor,
            style: headerStyle,
            widths: widths,
            hasAutoColumns: false,
          ),
        ),
      ],
    );
    final Widget body = rows.isEmpty
        ? _buildEmptyPlaceholder(oddColor)
        : _buildMergedBody(
            rows: rows,
            widths: widths,
            selectionWidth: selectionWidth,
            totalWidth: totalWidth,
            borderColor: borderColor,
            oddColor: oddColor,
            evenColor: evenColor,
            cellStyle: cellStyle,
          );
    Widget table = SizedBox(
      width: totalWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[header, body],
      ),
    );
    if (layout.scroll) {
      table = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: table,
      );
    }
    return _buildTableShell(borderColor: borderColor, child: table);
  }

  Widget _buildMergedBody({
    required List<_TableRowEntry> rows,
    required List<double> widths,
    required double selectionWidth,
    required double totalWidth,
    required Color borderColor,
    required Color oddColor,
    required Color evenColor,
    required TextStyle cellStyle,
  }) {
    final int rowCount = rows.length;
    final int columnCount = widget.columns.length;
    final List<List<bool>> covered = List<List<bool>>.generate(
      rowCount,
      (_) => List<bool>.filled(columnCount, false),
    );
    final List<double> leftOffsets = List<double>.filled(columnCount + 1, 0);
    for (int index = 0; index < columnCount; index += 1) {
      leftOffsets[index + 1] = leftOffsets[index] + widths[index];
    }
    final List<double> rowOffsets = List<double>.filled(rowCount + 1, 0);
    for (int index = 0; index < rowCount; index += 1) {
      rowOffsets[index + 1] =
          rowOffsets[index] +
          widget.rowHeight +
          (_expandedKeys.contains(rows[index].key)
              ? widget.expandable?.expandedHeight ?? 0
              : 0);
    }
    final List<Widget> cells = <Widget>[];
    final List<Widget> expandedRows = <Widget>[];
    for (int rowIndex = 0; rowIndex < rowCount; rowIndex += 1) {
      final _TableRowEntry entry = rows[rowIndex];
      if (widget.selection != null) {
        cells.add(
          Positioned(
            left: 0,
            top: rowOffsets[rowIndex],
            width: selectionWidth,
            height: widget.rowHeight,
            child: ColoredBox(
              color: _rowBgColor(rowIndex, oddColor, evenColor),
              child: _buildSelectionCell(entry, borderColor),
            ),
          ),
        );
      }
      for (int columnIndex = 0; columnIndex < columnCount; columnIndex += 1) {
        if (covered[rowIndex][columnIndex]) continue;
        final dynamic cellData = _cellData(entry, columnIndex);
        final SantoTableCellSpan requested =
            widget.columns[columnIndex].spanBuilder?.call(
              cellData,
              rowIndex,
              columnIndex,
            ) ??
            const SantoTableCellSpan();
        if (requested.rowSpan == 0 || requested.colSpan == 0) continue;
        final int rowSpan = requested.rowSpan.clamp(1, rowCount - rowIndex);
        final int colSpan = requested.colSpan.clamp(
          1,
          columnCount - columnIndex,
        );
        for (
          int coveredRow = rowIndex;
          coveredRow < rowIndex + rowSpan;
          coveredRow += 1
        ) {
          for (
            int coveredColumn = columnIndex;
            coveredColumn < columnIndex + colSpan;
            coveredColumn += 1
          ) {
            if (coveredRow != rowIndex || coveredColumn != columnIndex) {
              covered[coveredRow][coveredColumn] = true;
            }
          }
        }
        cells.add(
          Positioned(
            left: selectionWidth + leftOffsets[columnIndex],
            top: rowOffsets[rowIndex],
            width:
                leftOffsets[columnIndex + colSpan] - leftOffsets[columnIndex],
            height:
                rowOffsets[rowIndex + rowSpan - 1] +
                widget.rowHeight -
                rowOffsets[rowIndex],
            child: Container(
              key: ValueKey<String>(
                'santo_table_cell_${rowIndex}_$columnIndex',
              ),
              padding: widget.cellPadding ?? _defaultCellPadding(),
              alignment: _getAlignment(widget.columns[columnIndex].align),
              decoration: BoxDecoration(
                color: _rowBgColor(rowIndex, oddColor, evenColor),
                border: widget.border
                    ? Border(
                        right: BorderSide(
                          color: borderColor,
                          width: _borderWidth,
                        ),
                        bottom: BorderSide(
                          color: borderColor,
                          width: _borderWidth,
                        ),
                      )
                    : null,
              ),
              child: _buildCellContent(
                entry: entry,
                column: widget.columns[columnIndex],
                rowIndex: rowIndex,
                columnIndex: columnIndex,
                style: cellStyle,
              ),
            ),
          ),
        );
      }
      if (_expandedKeys.contains(entry.key) && widget.expandable != null) {
        expandedRows.add(
          Positioned(
            left: 0,
            top: rowOffsets[rowIndex] + widget.rowHeight,
            width: totalWidth,
            height: widget.expandable!.expandedHeight,
            child: Container(
              color: SantoThemeConfigurator.instance
                  .getConfig()
                  .commonConfig
                  .fillBody,
              alignment: Alignment.centerLeft,
              padding: widget.cellPadding ?? _defaultCellPadding(),
              child: widget.expandable!.builder(context, entry.data, rowIndex),
            ),
          ),
        );
      }
    }
    final Widget stack = SizedBox(
      height: rowOffsets.last,
      child: Stack(children: <Widget>[...cells, ...expandedRows]),
    );
    if (widget.height == null) return stack;
    return SizedBox(
      height: widget.height,
      child: SingleChildScrollView(child: stack),
    );
  }

  List<double> _resolveFlexWidths(double availableWidth) {
    final int autoCount = widget.columns
        .where((column) => column.width == null)
        .length;
    final double fixedSum = widget.columns.fold<double>(
      0,
      (double sum, SantoTableColumn column) => sum + (column.width ?? 0),
    );
    if (autoCount > 0) {
      final double autoWidth = ((availableWidth - fixedSum) / autoCount).clamp(
        0,
        double.infinity,
      );
      return widget.columns.map((column) => column.width ?? autoWidth).toList();
    }
    if (fixedSum <= 0) {
      return List<double>.filled(
        widget.columns.length,
        widget.columns.isEmpty ? 0 : availableWidth / widget.columns.length,
      );
    }
    return widget.columns
        .map((column) => availableWidth * column.width! / fixedSum)
        .toList();
  }

  Widget _buildHeaderRow({
    required List<int> columns,
    required List<_TableRowEntry> rows,
    required Color borderColor,
    required TextStyle style,
    required List<double>? widths,
    required bool hasAutoColumns,
  }) {
    final Color headerColor =
        widget.headerColor ??
        SantoThemeConfigurator.instance.getConfig().commonConfig.fillBody;
    return Container(
      height: widget.headerHeight,
      color: headerColor,
      child: Row(
        children: <Widget>[
          for (final int columnIndex in columns)
            _wrapCellWidth(
              widget.columns[columnIndex],
              widths?[columnIndex],
              _buildHeaderCell(
                column: widget.columns[columnIndex],
                columnIndex: columnIndex,
                style: style,
                borderColor: borderColor,
                showRightBorder:
                    widths != null || columnIndex < widget.columns.length - 1,
              ),
              hasAutoColumns: hasAutoColumns,
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell({
    required SantoTableColumn column,
    required int columnIndex,
    required TextStyle style,
    required Color borderColor,
    required bool showRightBorder,
  }) {
    final commonConfig = SantoThemeConfigurator.instance
        .getConfig()
        .commonConfig;
    final double spacing = commonConfig.hSpacingXs;
    Widget content =
        column.headerBuilder?.call(column.title) ??
        Text(
          column.title,
          style: style,
          textAlign: _getTextAlign(column.align),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
    if (column.sorter != null) {
      final bool active = _sortColumnIndex == columnIndex && _sortOrder != null;
      final IconData icon = !active
          ? Icons.unfold_more
          : _sortOrder == SantoTableSortOrder.ascending
          ? Icons.arrow_upward
          : Icons.arrow_downward;
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(child: content),
          SizedBox(width: spacing),
          Icon(icon, size: commonConfig.iconSizeSm, color: style.color),
        ],
      );
    }
    Widget cell = Container(
      key: ValueKey<String>('santo_table_header_$columnIndex'),
      padding: widget.cellPadding ?? _defaultCellPadding(),
      alignment: _getAlignment(column.align),
      decoration: widget.border
          ? BoxDecoration(
              border: Border(
                right: showRightBorder
                    ? BorderSide(color: borderColor, width: _borderWidth)
                    : BorderSide.none,
                bottom: BorderSide(
                  color: borderColor,
                  width: _borderWidth,
                ),
              ),
            )
          : null,
      child: content,
    );
    if (column.sorter != null) {
      cell = InkWell(
        key: ValueKey<String>('santo_table_sort_$columnIndex'),
        onTap: () => _changeSort(columnIndex),
        child: cell,
      );
    }
    return cell;
  }

  Widget _buildCell({
    required _TableRowEntry entry,
    required SantoTableColumn column,
    required int rowIndex,
    required int columnIndex,
    required TextStyle style,
    required Color borderColor,
    required bool showRightBorder,
  }) {
    return Container(
      key: ValueKey<String>('santo_table_cell_${rowIndex}_$columnIndex'),
      padding: widget.cellPadding ?? _defaultCellPadding(),
      alignment: _getAlignment(column.align),
      decoration: widget.border
          ? BoxDecoration(
              border: Border(
                right: showRightBorder
                    ? BorderSide(color: borderColor, width: _borderWidth)
                    : BorderSide.none,
              ),
            )
          : null,
      child: _buildCellContent(
        entry: entry,
        column: column,
        rowIndex: rowIndex,
        columnIndex: columnIndex,
        style: style,
      ),
    );
  }

  Widget _buildCellContent({
    required _TableRowEntry entry,
    required SantoTableColumn column,
    required int rowIndex,
    required int columnIndex,
    required TextStyle style,
  }) {
    final commonConfig = SantoThemeConfigurator.instance
        .getConfig()
        .commonConfig;
    final dynamic cellData = _cellData(entry, columnIndex);
    Widget content =
        column.cellBuilder?.call(cellData, rowIndex, columnIndex) ??
        Text(
          cellData?.toString() ?? '',
          style: style,
          textAlign: _getTextAlign(column.align),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
    if (columnIndex == 0 &&
        widget.expandable != null &&
        _rowExpandable(entry)) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            key: ValueKey<String>('santo_table_expand_${entry.key}'),
            onTap: () => _toggleExpanded(entry),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: commonConfig.hSpacingXs,
                vertical: commonConfig.vSpacingXs,
              ),
              child: Icon(
                _expandedKeys.contains(entry.key)
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right,
                size: 18,
              ),
            ),
          ),
          SizedBox(width: commonConfig.hSpacingXs),
          Flexible(child: content),
        ],
      );
    }
    return content;
  }

  Widget _wrapExpandedRow(
    _TableRowEntry entry,
    int rowIndex,
    Widget row,
    double? contentWidth,
  ) {
    final SantoTableExpandable? expandable = widget.expandable;
    if (expandable == null || !_expandedKeys.contains(entry.key)) return row;
    final Widget expanded = Container(
      height: expandable.expandedHeight,
      width: contentWidth == 0 ? null : contentWidth,
      color: SantoThemeConfigurator.instance.getConfig().commonConfig.fillBody,
      alignment: Alignment.centerLeft,
      padding: widget.cellPadding ?? _defaultCellPadding(),
      child: contentWidth == 0
          ? null
          : expandable.builder(context, entry.data, rowIndex),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[row, expanded],
    );
  }

  Widget _buildSelectionHeader(List<_TableRowEntry> rows, Color borderColor) {
    final SantoTableSelection selection = widget.selection!;
    final Color headerColor =
        widget.headerColor ??
        SantoThemeConfigurator.instance.getConfig().commonConfig.fillBody;
    Widget? control;
    if (selection.mode == SantoTableSelectionMode.multiple &&
        selection.showSelectAll) {
      final List<_TableRowEntry> selectable = rows
          .where(_rowSelectable)
          .toList();
      final int selectedCount = selectable
          .where((entry) => _selectedKeys.contains(entry.key))
          .length;
      final bool? value = selectedCount == 0
          ? false
          : selectedCount == selectable.length
          ? true
          : null;
      control = Checkbox(
        key: const ValueKey<String>('santo_table_select_all'),
        value: value,
        tristate: true,
        onChanged: selectable.isEmpty
            ? null
            : (bool? checked) =>
                  _toggleAll(selectable, selectedCount != selectable.length),
      );
    }
    return Container(
      width: selection.columnWidth,
      height: widget.headerHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: headerColor,
        border: widget.border
            ? Border(
                right: BorderSide(
                  color: borderColor,
                  width: _borderWidth,
                ),
                bottom: BorderSide(
                  color: borderColor,
                  width: _borderWidth,
                ),
              )
            : null,
      ),
      child: control,
    );
  }

  Widget _buildSelectionCell(_TableRowEntry entry, Color borderColor) {
    final SantoTableSelection selection = widget.selection!;
    final bool enabled = _rowSelectable(entry);
    final bool selected = _selectedKeys.contains(entry.key);
    final Widget control = selection.mode == SantoTableSelectionMode.multiple
        ? Checkbox(
            key: ValueKey<String>('santo_table_select_${entry.key}'),
            value: selected,
            onChanged: enabled
                ? (bool? checked) => _toggleSelected(entry, checked == true)
                : null,
          )
        : Radio<Object>(
            key: ValueKey<String>('santo_table_select_${entry.key}'),
            value: entry.key,
            groupValue: selected ? entry.key : null,
            onChanged: enabled
                ? (Object? value) => _toggleSelected(entry, value != null)
                : null,
          );
    return Container(
      width: selection.columnWidth,
      alignment: Alignment.center,
      decoration: widget.border
          ? BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: borderColor,
                  width: _borderWidth,
                ),
              ),
            )
          : null,
      child: control,
    );
  }

  Widget _buildPagination(int totalItems) {
    final SantoTablePagination pagination = widget.pagination!;
    final commonConfig = SantoThemeConfigurator.instance
        .getConfig()
        .commonConfig;
    final List<int> options = <int>{
      ...pagination.pageSizeOptions.where((int value) => value > 0),
      _pageSize,
    }.toList()..sort();
    return Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: commonConfig.hSpacingMd,
      runSpacing: commonConfig.vSpacingMd,
      children: <Widget>[
        if (pagination.showPageSizeSelector)
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              key: const ValueKey<String>('santo_table_page_size'),
              value: _pageSize,
              items: options
                  .map(
                    (int value) => DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value 条/页'),
                    ),
                  )
                  .toList(),
              onChanged: (int? value) {
                if (value == null || value == _pageSize) return;
                setState(() {
                  _pageSize = value;
                  _currentPage = 1;
                });
                pagination.onPageSizeChanged?.call(value);
                pagination.onPageChanged?.call(1);
              },
            ),
          ),
        SantoPagination(
          current: _currentPage,
          totalItems: totalItems,
          itemsPerPage: _pageSize,
          onChanged: (int page) {
            setState(() => _currentPage = page);
            pagination.onPageChanged?.call(page);
          },
        ),
      ],
    );
  }

  void _changeSort(int columnIndex) {
    setState(() {
      if (_sortColumnIndex != columnIndex || _sortOrder == null) {
        _sortColumnIndex = columnIndex;
        _sortOrder = SantoTableSortOrder.ascending;
      } else if (_sortOrder == SantoTableSortOrder.ascending) {
        _sortOrder = SantoTableSortOrder.descending;
      } else {
        _sortColumnIndex = null;
        _sortOrder = null;
      }
      _currentPage = 1;
    });
    widget.onSortChanged?.call(
      SantoTableSortState(columnIndex: columnIndex, order: _sortOrder),
    );
  }

  Set<Object> get _selectedKeys =>
      widget.selection?.selectedRowKeys ?? _selectedRowKeys;

  Set<Object> get _expandedKeys =>
      widget.expandable?.expandedRowKeys ?? _expandedRowKeys;

  bool _rowSelectable(_TableRowEntry entry) =>
      widget.selection?.rowSelectable?.call(entry.data, entry.sourceIndex) ??
      true;

  bool _rowExpandable(_TableRowEntry entry) =>
      widget.expandable?.rowExpandable?.call(entry.data, entry.sourceIndex) ??
      true;

  void _toggleSelected(_TableRowEntry entry, bool selected) {
    final SantoTableSelection selection = widget.selection!;
    final Set<Object> keys = Set<Object>.of(_selectedKeys);
    if (selection.mode == SantoTableSelectionMode.single) {
      keys
        ..clear()
        ..add(entry.key);
    } else if (selected) {
      keys.add(entry.key);
    } else {
      keys.remove(entry.key);
    }
    _commitSelection(keys);
  }

  void _toggleAll(List<_TableRowEntry> rows, bool selected) {
    final Set<Object> keys = Set<Object>.of(_selectedKeys);
    for (final _TableRowEntry entry in rows) {
      selected ? keys.add(entry.key) : keys.remove(entry.key);
    }
    _commitSelection(keys);
  }

  void _commitSelection(Set<Object> keys) {
    if (widget.selection?.selectedRowKeys == null) {
      setState(() => _selectedRowKeys = keys);
    }
    final List<List<dynamic>> selectedRows = <List<dynamic>>[];
    for (int index = 0; index < widget.data.length; index += 1) {
      final Object key =
          widget.rowKey?.call(widget.data[index], index) ?? index;
      if (keys.contains(key)) selectedRows.add(widget.data[index]);
    }
    widget.selection?.onChanged?.call(
      Set<Object>.unmodifiable(keys),
      List<List<dynamic>>.unmodifiable(selectedRows),
    );
  }

  void _toggleExpanded(_TableRowEntry entry) {
    final Set<Object> keys = Set<Object>.of(_expandedKeys);
    keys.contains(entry.key) ? keys.remove(entry.key) : keys.add(entry.key);
    if (widget.expandable?.expandedRowKeys == null) {
      setState(() => _expandedRowKeys = keys);
    }
    widget.expandable?.onChanged?.call(Set<Object>.unmodifiable(keys));
  }

  void _syncFixedAreas() {
    if (_syncingVertical || !_mainVerticalController.hasClients) return;
    _syncingVertical = true;
    final double offset = _mainVerticalController.offset;
    for (final ScrollController? controller in <ScrollController?>[
      _leftVerticalController,
      _rightVerticalController,
      _selectionVerticalController,
    ]) {
      if (controller != null && controller.hasClients) {
        controller.jumpTo(
          offset.clamp(0.0, controller.position.maxScrollExtent),
        );
      }
    }
    _syncingVertical = false;
  }

  dynamic _cellData(_TableRowEntry entry, int columnIndex) =>
      columnIndex < entry.data.length ? entry.data[columnIndex] : '';

  List<int> _allIndices() =>
      List<int>.generate(widget.columns.length, (int index) => index);

  Color _rowBgColor(int index, Color oddColor, Color evenColor) =>
      widget.striped && index.isOdd ? evenColor : oddColor;

  BoxDecoration _rowDecoration(Color backgroundColor, Color borderColor) =>
      BoxDecoration(
        color: backgroundColor,
        border: widget.border
            ? Border(
                bottom: BorderSide(
                  color: borderColor,
                  width: _borderWidth,
                ),
              )
            : null,
      );

  Widget _buildEmptyPlaceholder(Color backgroundColor) {
    final commonConfig = SantoThemeConfigurator.instance
        .getConfig()
        .commonConfig;
    return Container(
      height: 56,
      color: backgroundColor,
      alignment: Alignment.center,
      child:
          widget.empty ??
          Text(
            '暂无数据',
            style: TextStyle(
              color: commonConfig.colorTextHint,
              fontSize: commonConfig.fontSizeCaption,
            ),
          ),
    );
  }

  Widget _buildTableShell({required Color borderColor, required Widget child}) {
    final double radius = SantoThemeConfigurator.instance
        .getConfig()
        .commonConfig
        .radiusXs;
    return Container(
      width: widget.tableWidth,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
      foregroundDecoration: widget.border
          ? BoxDecoration(
              border: Border.all(color: borderColor, width: _borderWidth),
              borderRadius: BorderRadius.circular(radius),
            )
          : null,
      child: child,
    );
  }

  EdgeInsets _defaultCellPadding() {
    final commonConfig = SantoThemeConfigurator.instance
        .getConfig()
        .commonConfig;
    return EdgeInsets.symmetric(horizontal: commonConfig.hSpacingMd);
  }

  Widget _wrapCellWidth(
    SantoTableColumn column,
    double? width,
    Widget child, {
    required bool hasAutoColumns,
  }) {
    if (width != null) return SizedBox(width: width, child: child);
    return _wrapColumnWidth(column, child, hasAutoColumns: hasAutoColumns);
  }

  Widget _wrapColumnWidth(
    SantoTableColumn column,
    Widget child, {
    required bool hasAutoColumns,
  }) {
    if (column.width != null) {
      if (hasAutoColumns) return SizedBox(width: column.width, child: child);
      return Expanded(flex: column.width!.round(), child: child);
    }
    return Expanded(child: child);
  }

  TextAlign _getTextAlign(SantoTableAlign align) {
    switch (align) {
      case SantoTableAlign.left:
        return TextAlign.left;
      case SantoTableAlign.center:
        return TextAlign.center;
      case SantoTableAlign.right:
        return TextAlign.right;
    }
  }

  Alignment _getAlignment(SantoTableAlign align) {
    switch (align) {
      case SantoTableAlign.left:
        return Alignment.centerLeft;
      case SantoTableAlign.center:
        return Alignment.center;
      case SantoTableAlign.right:
        return Alignment.centerRight;
    }
  }
}

class _TableRowEntry {
  final List<dynamic> data;
  final int sourceIndex;
  final Object key;

  const _TableRowEntry({
    required this.data,
    required this.sourceIndex,
    required this.key,
  });
}

class _TableLayout {
  final bool scroll;
  final List<double>? widths;
  final double? contentWidth;

  const _TableLayout({required this.scroll, this.widths, this.contentWidth});
}
