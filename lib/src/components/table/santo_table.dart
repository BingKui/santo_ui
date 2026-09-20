import 'package:flutter/material.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 表格列对齐方式
enum SantoTableAlign {
  /// 左对齐
  left,

  /// 居中
  center,

  /// 右对齐
  right,
}

/// 列的固定位置,对标 antd Table 的 `column.fixed`
///
/// 固定列在表格横向滚动时钉在左侧/右侧,只在横向滚动模式下生效。
enum SantoTableColumnFixed {
  /// 固定在左侧
  left,

  /// 固定在右侧
  right,
}

/// 表格列配置
///
/// 定义表格中每一列的属性。
///
/// 使用示例：
/// ```dart
/// SantoTableColumn(
///   title: '姓名',
///   width: 100,
///   align: SantoTableAlign.center,
/// )
/// ```
class SantoTableColumn {
  /// 列标题
  final String title;

  /// 列宽度
  ///
  /// 为 null 时与其他未定宽列均分剩余空间；全部列都定宽时，
  /// 按各列定宽值等比例分摊表格宽度。
  /// 表格进入横向滚动模式后,未定宽列取默认宽 120
  final double? width;

  /// 列对齐方式，默认居中
  final SantoTableAlign align;

  /// 列固定位置,为 null 时不固定
  ///
  /// 配置了 [SantoTableColumnFixed] 的列会让表格进入横向滚动模式:
  /// 所有列按定宽渲染(未定宽列取默认宽 120),固定列钉在左侧/右侧
  final SantoTableColumnFixed? fixed;

  /// 自定义单元格内容构建器
  /// 参数：cellData 为当前单元格数据，rowIndex 为行索引，colIndex 为列索引
  final Widget Function(dynamic cellData, int rowIndex, int colIndex)?
      cellBuilder;

  /// 自定义表头内容构建器
  final Widget Function(String title)? headerBuilder;

  /// 创建表格列配置
  const SantoTableColumn({
    required this.title,
    this.width,
    this.align = SantoTableAlign.center,
    this.fixed,
    this.cellBuilder,
    this.headerBuilder,
  });
}

/// 横向滚动模式下未定宽列的默认列宽
const double kSantoTableDefaultColumnWidth = 120;

/// Table 数据表格组件
///
/// 支持自定义列数和行数,支持固定表头、横向/纵向滚动、固定列、
/// 单元格自定义内容、边框和分割线,对标 antd Table 的
/// `scroll.x`(横向滚动)/`scroll.y`(内容区高度)/`column.fixed`(固定列)。
///
/// 使用示例：
/// ```dart
/// SantoTable(
///   height: 300, // 内容区高度,超出纵向滚动且表头固定
///   columns: [
///     SantoTableColumn(title: '姓名', width: 100, fixed: SantoTableColumnFixed.left),
///     SantoTableColumn(title: '年龄', width: 80),
///     SantoTableColumn(title: '操作', width: 100, fixed: SantoTableColumnFixed.right),
///   ],
///   data: [
///     ['张三', 25, '详情'],
///     ['李四', 30, '详情'],
///   ],
/// )
/// ```
class SantoTable extends StatefulWidget {
  /// 列配置列表
  final List<SantoTableColumn> columns;

  /// 表格数据，每行为一个 List<dynamic>
  final List<List<dynamic>> data;

  /// 是否显示边框，默认true
  final bool border;

  /// 边框颜色，默认使用主题分割线颜色
  final Color? borderColor;

  /// 边框宽度，默认0.5
  final double borderWidth;

  /// 表头背景色，默认使用主题品牌色
  final Color? headerColor;

  /// 表头文字颜色，默认白色
  final Color? headerTextColor;

  /// 表头文字样式
  final TextStyle? headerTextStyle;

  /// 单元格文字样式
  final TextStyle? cellTextStyle;

  /// 单元格文字颜色，默认使用主题文字颜色
  final Color? cellTextColor;

  /// 行高，默认48
  final double rowHeight;

  /// 表头高度，默认48
  final double headerHeight;

  /// 单元格内边距,默认水平 gapMd
  final EdgeInsets? cellPadding;

  /// 奇数行背景色，默认白色
  final Color? oddRowColor;

  /// 偶数行背景色，默认浅灰色
  final Color? evenRowColor;

  /// 是否显示斑马纹，默认false
  final bool striped;

  /// 内容区高度
  ///
  /// 不为 null 时表头固定,内容超出该高度在内容区内纵向滚动
  /// (对标 antd Table 的 `scroll.y`)
  final double? height;

  /// 表格总宽度，为 null 时自适应父容器
  final double? tableWidth;

  /// 数据为空时展示的占位内容，为 null 时使用默认"暂无数据"
  final Widget? empty;

  /// 创建表格组件
  const SantoTable({
    Key? key,
    required this.columns,
    required this.data,
    this.border = true,
    this.borderColor,
    this.borderWidth = 0.5,
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
  }) : super(key: key);

  @override
  State<SantoTable> createState() => _SantoTableState();
}

class _SantoTableState extends State<SantoTable> {
  /// 内容区(中间滚动区)的纵向控制器,左右固定区由它驱动
  ScrollController? _verticalController;

  /// 左固定区的纵向控制器,固定区不响应手势,由中间区同步
  ScrollController? _leftVerticalController;
  ScrollController? _rightVerticalController;

  bool _syncingVertical = false;
  bool _verticalListenerAttached = false;

  @override
  void dispose() {
    _verticalController?.dispose();
    _leftVerticalController?.dispose();
    _rightVerticalController?.dispose();
    super.dispose();
  }

  ScrollController get _mainVerticalController =>
      _verticalController ??= ScrollController();

  ScrollController get _leftFixedVerticalController =>
      _leftVerticalController ??= ScrollController();

  ScrollController get _rightFixedVerticalController =>
      _rightVerticalController ??= ScrollController();

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;

    final bColor = widget.borderColor ?? commonConfig.dividerColorBase;
    final hTextColor = widget.headerTextColor ?? commonConfig.colorTextBaseInverse;
    final cTextColor = widget.cellTextColor ?? commonConfig.colorTextBase;
    final oColor = widget.oddRowColor ?? Colors.white;
    final eColor = widget.evenRowColor ?? const Color(0xFFF5F5F5);

    final defaultHeaderStyle = widget.headerTextStyle ??
        TextStyle(
          color: hTextColor,
          fontSize: commonConfig.fontSizeBase,
          fontWeight: FontWeight.w500,
        );

    final defaultCellStyle = widget.cellTextStyle ??
        TextStyle(
          color: cTextColor,
          fontSize: commonConfig.fontSizeBase,
        );

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final double containerWidth = constraints.maxWidth.isFinite
          ? constraints.maxWidth
          : (widget.tableWidth ?? 0);
      final _TableLayout layout = _resolveLayout(containerWidth);

      if (widget.data.isEmpty) {
        return _buildEmptyTable(layout, bColor, defaultHeaderStyle, oColor);
      }
      if (layout.scroll) {
        return _buildScrollTable(
          layout: layout,
          bColor: bColor,
          oColor: oColor,
          eColor: eColor,
          defaultHeaderStyle: defaultHeaderStyle,
          defaultCellStyle: defaultCellStyle,
        );
      }
      return _buildFlexTable(
        bColor: bColor,
        oColor: oColor,
        eColor: eColor,
        defaultHeaderStyle: defaultHeaderStyle,
        defaultCellStyle: defaultCellStyle,
      );
    });
  }

  /// 解析列宽与布局模式
  ///
  /// - 任一列配置了 fixed,或全部定宽但列宽和超出容器 → 横向滚动模式,
  ///   所有列按定宽渲染(未定宽列取默认宽)
  /// - 其余情况为弹性模式:未定宽列均分剩余空间,全定宽按比例分摊
  _TableLayout _resolveLayout(double containerWidth) {
    final bool hasFixed = widget.columns.any((c) => c.fixed != null);
    final List<double?> widths =
        widget.columns.map((c) => c.width).toList();
    final double fixedSum =
        widths.fold<double>(0, (double sum, double? w) => sum + (w ?? 0));
    final int autoCount = widths.where((w) => w == null).length;

    final bool scroll = hasFixed ||
        (autoCount == 0 && fixedSum > containerWidth + 0.1);
    if (!scroll) {
      return _TableLayout(scroll: false);
    }
    final List<double> resolved =
        widths.map((w) => w ?? kSantoTableDefaultColumnWidth).toList();
    return _TableLayout(
      scroll: true,
      widths: resolved,
      contentWidth: resolved.fold<double>(0, (double sum, double w) => sum + w),
    );
  }

  // ==================== 弹性模式(现状行为) ====================

  Widget _buildFlexTable({
    required Color bColor,
    required Color oColor,
    required Color eColor,
    required TextStyle defaultHeaderStyle,
    required TextStyle defaultCellStyle,
  }) {
    return _buildTableShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderRow(
            columns: _allIndices(),
            bColor: bColor,
            style: defaultHeaderStyle,
            widths: null,
            hasAutoColumns: widget.columns.any((c) => c.width == null),
          ),
          if (widget.data.isEmpty) _buildEmptyPlaceholder(oColor)
          else if (widget.height != null)
            SizedBox(
              height: widget.height!,
              child: ListView.builder(
                controller: _mainVerticalController,
                itemCount: widget.data.length,
                itemBuilder: (BuildContext context, int index) =>
                    _buildFlexDataRow(index, bColor, defaultCellStyle,
                        _rowBgColor(index, oColor, eColor)),
              ),
            )
          else
            for (int index = 0; index < widget.data.length; index++)
              _buildFlexDataRow(index, bColor, defaultCellStyle,
                  _rowBgColor(index, oColor, eColor)),
        ],
      ),
    );
  }

  Widget _buildFlexDataRow(
      int index, Color bColor, TextStyle defaultCellStyle, Color bgColor) {
    return Container(
      height: widget.rowHeight,
      decoration: BoxDecoration(
        color: bgColor,
        border: widget.border
            ? Border(
                bottom: BorderSide(color: bColor, width: widget.borderWidth),
              )
            : null,
      ),
      child: Row(
        children: List.generate(widget.columns.length, (colIndex) {
          final col = widget.columns[colIndex];
          return _wrapColumnWidth(
            col,
            _buildCell(
              col: col,
              cellData: colIndex < widget.data[index].length
                  ? widget.data[index][colIndex]
                  : '',
              rowIndex: index,
              colIndex: colIndex,
              style: defaultCellStyle,
              bColor: bColor,
              showRightBorder: colIndex < widget.columns.length - 1,
            ),
            hasAutoColumns:
                widget.columns.any((c) => c.width == null),
          );
        }),
      ),
    );
  }

  // ==================== 滚动模式(横向滚动 + 固定列) ====================

  Widget _buildScrollTable({
    required _TableLayout layout,
    required Color bColor,
    required Color oColor,
    required Color eColor,
    required TextStyle defaultHeaderStyle,
    required TextStyle defaultCellStyle,
  }) {
    final List<int> leftIndices = <int>[];
    final List<int> middleIndices = <int>[];
    final List<int> rightIndices = <int>[];
    for (int i = 0; i < widget.columns.length; i += 1) {
      final SantoTableColumnFixed? fixed = widget.columns[i].fixed;
      if (fixed == SantoTableColumnFixed.left) {
        leftIndices.add(i);
      } else if (fixed == SantoTableColumnFixed.right) {
        rightIndices.add(i);
      } else {
        middleIndices.add(i);
      }
    }
    double widthOf(List<int> indices) =>
        indices.fold<double>(0, (double sum, int i) => sum + layout.widths![i]);

    final double leftWidth = widthOf(leftIndices);
    final double rightWidth = widthOf(rightIndices);
    final double middleWidth = widthOf(middleIndices);

    final bool vertical = widget.height != null;
    if (vertical && !_verticalListenerAttached) {
      _mainVerticalController.addListener(_syncFixedAreas);
      _verticalListenerAttached = true;
    }

    Widget areaBody(List<int> indices, ScrollController? controller) {
      final Widget rows = widget.height != null
          ? SizedBox(
              height: widget.height,
              child: ListView.builder(
                controller: controller,
                // 固定区不响应手势,统一由中间区驱动
                physics: identical(controller, _verticalController)
                    ? null
                    : const NeverScrollableScrollPhysics(),
                itemCount: widget.data.length,
                itemBuilder: (BuildContext context, int index) =>
                    _buildScrollRow(
                  indices: indices,
                  widths: layout.widths!,
                  rowData: widget.data[index],
                  rowIndex: index,
                  bColor: bColor,
                  style: defaultCellStyle,
                  bgColor: _rowBgColor(index, oColor, eColor),
                ),
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int index = 0; index < widget.data.length; index++)
                  _buildScrollRow(
                    indices: indices,
                    widths: layout.widths!,
                    rowData: widget.data[index],
                    rowIndex: index,
                    bColor: bColor,
                    style: defaultCellStyle,
                    bgColor: _rowBgColor(index, oColor, eColor),
                  ),
              ],
            );
      return rows;
    }

    Widget area(List<int> indices, double width, ScrollController? controller) {
      return SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderRow(
              columns: indices,
              bColor: bColor,
              style: defaultHeaderStyle,
              widths: layout.widths,
              hasAutoColumns: false,
            ),
            areaBody(indices, controller),
          ],
        ),
      );
    }

    return _buildTableShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (leftIndices.isNotEmpty)
                area(leftIndices, leftWidth, _leftFixedVerticalController),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: middleWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeaderRow(
                          columns: middleIndices,
                          bColor: bColor,
                          style: defaultHeaderStyle,
                          widths: layout.widths,
                          hasAutoColumns: false,
                        ),
                        areaBody(middleIndices, _mainVerticalController),
                      ],
                    ),
                  ),
                ),
              ),
              if (rightIndices.isNotEmpty)
                area(rightIndices, rightWidth, _rightFixedVerticalController),
            ],
          ),
        ],
      ),
    );
  }

  /// 把中间内容区的纵向偏移同步到左右固定区
  void _syncFixedAreas() {
    if (_syncingVertical || !_mainVerticalController.hasClients) {
      return;
    }
    _syncingVertical = true;
    final double offset = _mainVerticalController.offset;
    for (final ScrollController? controller
        in <ScrollController?>[_leftVerticalController, _rightVerticalController]) {
      if (controller != null && controller.hasClients) {
        controller.jumpTo(offset.clamp(0.0, controller.position.maxScrollExtent));
      }
    }
    _syncingVertical = false;
  }

  /// 滚动模式下的数据行:按区给定的列下标与定宽渲染
  Widget _buildScrollRow({
    required List<int> indices,
    required List<double> widths,
    required List<dynamic> rowData,
    required int rowIndex,
    required Color bColor,
    required TextStyle style,
    required Color bgColor,
  }) {
    return Container(
      height: widget.rowHeight,
      decoration: BoxDecoration(
        color: bgColor,
        border: widget.border
            ? Border(
                bottom: BorderSide(color: bColor, width: widget.borderWidth),
              )
            : null,
      ),
      child: Row(
        children: [
          for (int i = 0; i < indices.length; i += 1)
            _buildCell(
              col: widget.columns[indices[i]],
              cellData: indices[i] < rowData.length
                  ? rowData[indices[i]]
                  : '',
              rowIndex: rowIndex,
              colIndex: indices[i],
              style: style,
              bColor: bColor,
              width: widths[indices[i]],
              showRightBorder: indices[i] < widget.columns.length - 1,
            ),
        ],
      ),
    );
  }

  // ==================== 公共部分 ====================

  List<int> _allIndices() =>
      List<int>.generate(widget.columns.length, (int i) => i);

  Color _rowBgColor(int index, Color oColor, Color eColor) =>
      widget.striped ? (index.isEven ? oColor : eColor) : oColor;


  /// 表格外框
  ///
  /// 用 foregroundDecoration 在前景绘制：单元格背景是直角矩形，
  /// 若边框画在背景下层，圆角处的边线会被背景盖住
  BoxDecoration? _tableBorder(Color bColor) {
    if (!widget.border) {
      return null;
    }
    return BoxDecoration(
      border: Border.all(color: bColor, width: widget.borderWidth),
      borderRadius: BorderRadius.circular(
          SantoThemeConfigurator.instance.getConfig().commonConfig.radiusXs),
    );
  }

  Widget _buildTableShell({required Widget child}) {
    return Container(
      width: widget.tableWidth,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
            SantoThemeConfigurator.instance.getConfig().commonConfig.radiusXs),
      ),
      foregroundDecoration: _tableBorder(
          widget.borderColor ??
              SantoThemeConfigurator.instance.getConfig().commonConfig.dividerColorBase),
      child: child,
    );
  }

  /// 表头行,columns 为该区包含的列下标
  ///
  /// 滚动模式按 [widths] 定宽渲染,与数据行对齐;弹性模式走 [_wrapColumnWidth]
  Widget _buildHeaderRow({
    required List<int> columns,
    required Color bColor,
    required TextStyle style,
    required List<double>? widths,
    required bool hasAutoColumns,
  }) {
    return Container(
      height: widget.headerHeight,
      color: widget.headerColor ??
          SantoThemeConfigurator.instance.getConfig().commonConfig.brandPrimary,
      child: Row(
        children: [
          for (final int colIndex in columns)
            _wrapCellWidth(
              widget.columns[colIndex],
              widths?[colIndex],
              _buildHeaderCell(
                col: widget.columns[colIndex],
                colIndex: colIndex,
                style: style,
                bColor: bColor,
                showRightBorder: widths != null ||
                    colIndex < widget.columns.length - 1,
              ),
              hasAutoColumns: hasAutoColumns,
            ),
        ],
      ),
    );
  }

  /// 单元格宽度包装:滚动模式按给定宽度定宽,弹性模式按列配置伸缩
  Widget _wrapCellWidth(
      SantoTableColumn col, double? width, Widget child,
      {required bool hasAutoColumns}) {
    if (width != null) {
      return SizedBox(width: width, child: child);
    }
    return _wrapColumnWidth(col, child, hasAutoColumns: hasAutoColumns);
  }

  Widget _buildHeaderCell({
    required SantoTableColumn col,
    required int colIndex,
    required TextStyle style,
    required Color bColor,
    double? width,
    required bool showRightBorder,
  }) {
    final Widget cell = Container(
      width: width,
      padding: widget.cellPadding ?? _defaultCellPadding(),
      alignment: _getAlignment(col.align),
      decoration: widget.border
          ? BoxDecoration(
              border: Border(
                right: showRightBorder
                    ? BorderSide(color: bColor, width: widget.borderWidth)
                    : BorderSide.none,
              ),
            )
          : null,
      child: col.headerBuilder != null
          ? col.headerBuilder!(col.title)
          : Text(
              col.title,
              style: style,
              textAlign: _getTextAlign(col.align),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
    );
    return cell;
  }

  EdgeInsets _defaultCellPadding() => EdgeInsets.symmetric(
      horizontal:
          SantoThemeConfigurator.instance.getConfig().commonConfig.gapMd);

  /// 单元格
  Widget _buildCell({
    required SantoTableColumn col,
    required dynamic cellData,
    required int rowIndex,
    required int colIndex,
    required TextStyle style,
    required Color bColor,
    double? width,
    required bool showRightBorder,
  }) {
    return Container(
      width: width,
      padding: widget.cellPadding ?? _defaultCellPadding(),
      alignment: _getAlignment(col.align),
      decoration: widget.border
          ? BoxDecoration(
              border: Border(
                right: showRightBorder
                    ? BorderSide(color: bColor, width: widget.borderWidth)
                    : BorderSide.none,
              ),
            )
          : null,
      child: col.cellBuilder != null
          ? col.cellBuilder!(cellData, rowIndex, colIndex)
          : Text(
              cellData.toString(),
              style: style,
              textAlign: _getTextAlign(col.align),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
    );
  }

  /// 构建空数据占位
  Widget _buildEmptyPlaceholder(Color bgColor) {
    final hintColor =
        SantoThemeConfigurator.instance.getConfig().commonConfig.colorTextHint;
    return Container(
      height: 56,
      color: bgColor,
      alignment: Alignment.center,
      child: widget.empty ??
          Text(
            '暂无数据',
            style: TextStyle(
              color: hintColor,
              fontSize: SantoThemeConfigurator.instance
                  .getConfig()
                  .commonConfig
                  .fontSizeCaption),
          ),
    );
  }

  /// 空数据表格
  Widget _buildEmptyTable(_TableLayout layout, Color bColor,
      TextStyle defaultHeaderStyle, Color oColor) {
    Widget table = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeaderRow(
          columns: _allIndices(),
          bColor: bColor,
          style: defaultHeaderStyle,
          widths: layout.widths,
          hasAutoColumns: false,
        ),
        _buildEmptyPlaceholder(oColor),
      ],
    );
    if (layout.scroll) {
      table = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(width: layout.contentWidth, child: table),
      );
    }
    return _buildTableShell(child: table);
  }

  /// 定宽列按 [SantoTableColumn.width] 固定宽度，未定宽列均分剩余空间；
  /// 全部列都定宽时，按定宽值等比例分摊表格宽度，避免溢出或留白
  Widget _wrapColumnWidth(SantoTableColumn col, Widget child,
      {required bool hasAutoColumns}) {
    if (col.width != null) {
      if (hasAutoColumns) {
        return SizedBox(width: col.width, child: child);
      }
      return Expanded(flex: col.width!.round(), child: child);
    }
    return Expanded(child: child);
  }

  /// 获取对齐方式
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

  /// 获取对齐方式
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

/// 表格的布局模式
class _TableLayout {
  const _TableLayout({required this.scroll, this.widths, this.contentWidth});

  /// 是否进入横向滚动模式
  final bool scroll;

  /// 滚动模式下每列的渲染宽度(与 columns 一一对应)
  final List<double>? widths;

  /// 滚动模式下的内容总宽
  final double? contentWidth;
}
