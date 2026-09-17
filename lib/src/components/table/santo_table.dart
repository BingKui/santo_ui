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
  /// 按各列定宽值等比例分摊表格宽度
  final double? width;

  /// 列对齐方式，默认居中
  final SantoTableAlign align;

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
    this.cellBuilder,
    this.headerBuilder,
  });
}

/// Table 数据表格组件
///
/// 支持自定义列数和行数，支持表头固定、单元格自定义内容、边框和分割线。
///
/// 使用示例：
/// ```dart
/// SantoTable(
///   columns: [
///     SantoTableColumn(title: '姓名', width: 100),
///     SantoTableColumn(title: '年龄', width: 80),
///     SantoTableColumn(title: '城市', width: 120),
///   ],
///   data: [
///     ['张三', 25, '北京'],
///     ['李四', 30, '上海'],
///     ['王五', 28, '广州'],
///   ],
/// )
/// ```
class SantoTable extends StatelessWidget {
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

  /// 单元格内边距，默认 EdgeInsets.symmetric(horizontal: 12)
  final EdgeInsets cellPadding;

  /// 奇数行背景色，默认白色
  final Color? oddRowColor;

  /// 偶数行背景色，默认浅灰色
  final Color? evenRowColor;

  /// 是否显示斑马纹，默认false
  final bool striped;

  /// 是否固定表头（配合 SingleChildScrollView 使用），默认false
  final bool pinnedHeader;

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
    this.cellPadding = const EdgeInsets.symmetric(horizontal: 12),
    this.oddRowColor,
    this.evenRowColor,
    this.striped = false,
    this.pinnedHeader = false,
    this.tableWidth,
    this.empty,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;

    final bColor = borderColor ?? commonConfig.dividerColorBase;
    final hColor = headerColor ?? commonConfig.brandPrimary;
    final hTextColor = headerTextColor ?? commonConfig.colorTextBaseInverse;
    final cTextColor = cellTextColor ?? commonConfig.colorTextBase;
    final oColor = oddRowColor ?? Colors.white;
    final eColor = evenRowColor ?? const Color(0xFFF5F5F5);

    final defaultHeaderStyle = headerTextStyle ??
        TextStyle(
          color: hTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        );

    final defaultCellStyle = cellTextStyle ??
        TextStyle(
          color: cTextColor,
          fontSize: 14,
        );

    if (pinnedHeader) {
      return _buildPinnedHeaderTable(
        bColor: bColor,
        hColor: hColor,
        oColor: oColor,
        eColor: eColor,
        defaultHeaderStyle: defaultHeaderStyle,
        defaultCellStyle: defaultCellStyle,
      );
    }

    return _buildNormalTable(
      bColor: bColor,
      hColor: hColor,
      oColor: oColor,
      eColor: eColor,
      defaultHeaderStyle: defaultHeaderStyle,
      defaultCellStyle: defaultCellStyle,
    );
  }

  /// 构建普通表格
  Widget _buildNormalTable({
    required Color bColor,
    required Color hColor,
    required Color oColor,
    required Color eColor,
    required TextStyle defaultHeaderStyle,
    required TextStyle defaultCellStyle,
  }) {
    return Container(
      width: tableWidth,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      foregroundDecoration: _tableBorder(bColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 表头
          _buildHeaderRow(hColor, defaultHeaderStyle, bColor),
          // 空数据占位
          if (data.isEmpty) _buildEmptyPlaceholder(oColor),
          // 数据行
          for (int index = 0; index < data.length; index++)
            _buildDataRow(
              rowData: data[index],
              rowIndex: index,
              bgColor: striped ? (index.isEven ? oColor : eColor) : oColor,
              defaultCellStyle: defaultCellStyle,
              bColor: bColor,
            ),
        ],
      ),
    );
  }

  /// 构建固定表头表格
  Widget _buildPinnedHeaderTable({
    required Color bColor,
    required Color hColor,
    required Color oColor,
    required Color eColor,
    required TextStyle defaultHeaderStyle,
    required TextStyle defaultCellStyle,
  }) {
    return Container(
      width: tableWidth,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      foregroundDecoration: _tableBorder(bColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 固定表头
          _buildHeaderRow(hColor, defaultHeaderStyle, bColor),
          // 可滚动数据区域
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (int index = 0; index < data.length; index++)
                    _buildDataRow(
                      rowData: data[index],
                      rowIndex: index,
                      bgColor:
                          striped ? (index.isEven ? oColor : eColor) : oColor,
                      defaultCellStyle: defaultCellStyle,
                      bColor: bColor,
                    ),
                  if (data.isEmpty) _buildEmptyPlaceholder(oColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 表格外框
  ///
  /// 用 foregroundDecoration 在前景绘制：单元格背景是直角矩形，
  /// 若边框画在背景下层，圆角处的边线会被背景盖住
  BoxDecoration? _tableBorder(Color bColor) {
    if (!border) {
      return null;
    }
    return BoxDecoration(
      border: Border.all(color: bColor, width: borderWidth),
      borderRadius: BorderRadius.circular(12),
    );
  }

  /// 构建表头行
  Widget _buildHeaderRow(
      Color hColor, TextStyle headerStyle, Color bColor) {
    final hasAutoColumns = columns.any((col) => col.width == null);
    return Container(
      height: headerHeight,
      color: hColor,
      child: Row(
        children: [
          for (int colIndex = 0; colIndex < columns.length; colIndex += 1)
            _wrapColumnWidth(
              columns[colIndex],
              Container(
                padding: cellPadding,
                alignment: _getAlignment(columns[colIndex].align),
                decoration: border
                    ? BoxDecoration(
                        border: Border(
                          right: BorderSide(color: bColor, width: borderWidth),
                        ),
                      )
                    : null,
                child: columns[colIndex].headerBuilder != null
                    ? columns[colIndex].headerBuilder!(columns[colIndex].title)
                    : Text(
                        columns[colIndex].title,
                        style: headerStyle,
                        textAlign: _getTextAlign(columns[colIndex].align),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
              hasAutoColumns: hasAutoColumns,
            ),
        ],
      ),
    );
  }

  /// 构建数据行
  Widget _buildDataRow({
    required List<dynamic> rowData,
    required int rowIndex,
    required Color bgColor,
    required TextStyle defaultCellStyle,
    required Color bColor,
  }) {
    final hasAutoColumns = columns.any((col) => col.width == null);
    return Container(
      height: rowHeight,
      decoration: BoxDecoration(
        color: bgColor,
        border: border
            ? Border(
                bottom: BorderSide(color: bColor, width: borderWidth),
              )
            : null,
      ),
      child: Row(
        children: List.generate(columns.length, (colIndex) {
          final col = columns[colIndex];
          final cellData =
              colIndex < rowData.length ? rowData[colIndex] : '';

          return _wrapColumnWidth(
            col,
            Container(
              padding: cellPadding,
              alignment: _getAlignment(col.align),
              decoration: border
                  ? BoxDecoration(
                      border: Border(
                        right: colIndex < columns.length - 1
                            ? BorderSide(color: bColor, width: borderWidth)
                            : BorderSide.none,
                      ),
                    )
                  : null,
              child: col.cellBuilder != null
                  ? col.cellBuilder!(cellData, rowIndex, colIndex)
                  : Text(
                      cellData.toString(),
                      style: defaultCellStyle,
                      textAlign: _getTextAlign(col.align),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            hasAutoColumns: hasAutoColumns,
          );
        }),
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
      child: empty ??
          Text(
            '暂无数据',
            style: TextStyle(color: hintColor, fontSize: 12),
          ),
    );
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
