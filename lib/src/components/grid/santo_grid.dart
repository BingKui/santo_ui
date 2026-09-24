import 'package:flutter/material.dart';

/// 栅格列(参考 antd Grid 的 Col)
///
/// 仅能作为 [SantoRow] 的直接子组件使用。通过 24 等分栅格控制宽度:
/// 三等分一行为 `span: 8`,超出 24 的部分整体换行。
class SantoCol {
  /// 列内容
  final Widget child;

  /// 占据的栅格数,1~24;为 null 时宽度由内容自适应;
  /// 为 0 时不渲染(等效 display: none)
  final int? span;

  /// 左侧偏移的栅格数
  final int? offset;

  /// 排序权重,小的在前;相同 [order] 保持声明顺序
  final int? order;

  /// 右移的栅格数(视觉位移,不影响兄弟元素布局,参考 CSS position: relative)
  final int? push;

  /// 左移的栅格数(视觉位移,不影响兄弟元素布局,参考 CSS position: relative)
  final int? pull;

  /// 伸缩值,非 null 时该列以 `Expanded(flex: flex)` 参与布局,忽略 [span] 宽度
  final int? flex;

  const SantoCol({
    Key? key,
    required this.child,
    this.span,
    this.offset,
    this.order,
    this.push,
    this.pull,
    this.flex,
  })  : assert(span == null || (span >= 0 && span <= 24), 'span 取值 0~24'),
        assert(offset == null || (offset >= 0 && offset <= 24), 'offset 取值 0~24'),
        assert(push == null || push >= 0, 'push 不能为负'),
        assert(pull == null || pull >= 0, 'pull 不能为负'),
        assert(flex == null || flex > 0, 'flex 必须大于 0');
}

/// 栅格行(参考 antd Grid 的 Row)
///
/// 24 栅格系统:行内放置 [SantoCol],span 总和超出 24 时整列换行。
///
/// 示例:
/// ```dart
/// SantoRow(
///   gutter: 15,
///   children: [
///     SantoCol(span: 12, child: ...),
///     SantoCol(span: 12, child: ...),
///   ],
/// )
/// ```
class SantoRow extends StatelessWidget {
  /// 行内的列,只能是 [SantoCol]
  final List<SantoCol> children;

  /// 列间距(横向),由列的内边距实现,相邻列间距 = [gutter],首尾列内容与行边缘齐平
  final double gutter;

  /// 换行后的行间距(纵向),默认 0
  final double verticalGutter;

  /// span 总和超出 24 时是否自动换行,默认 true;
  /// 为 false 时所有列排在一行,超出部分溢出
  final bool wrap;

  /// 水平对齐方式,默认 start(参考 antd justify)
  final MainAxisAlignment justify;

  /// 垂直对齐方式,默认 start(参考 antd align: top/middle/bottom/stretch)
  final CrossAxisAlignment align;

  const SantoRow({
    Key? key,
    required this.children,
    this.gutter = 0,
    this.verticalGutter = 0,
    this.wrap = true,
    this.justify = MainAxisAlignment.start,
    this.align = CrossAxisAlignment.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    // order 稳定排序:相同 order 保持声明顺序
    final List<MapEntry<int, SantoCol>> indexed = [
      for (int i = 0; i < children.length; i++) MapEntry(i, children[i]),
    ];
    indexed.sort((a, b) {
      final int oa = a.value.order ?? 0;
      final int ob = b.value.order ?? 0;
      if (oa != ob) return oa - ob;
      return a.key - b.key;
    });
    final List<SantoCol> cols = indexed.map((e) => e.value).toList();

    return LayoutBuilder(builder: (context, constraints) {
      final double width = constraints.maxWidth;
      final double unit = width / 24;

      // 按 span + offset 占用拆行
      final List<List<SantoCol>> lines = [];
      List<SantoCol> current = [];
      int used = 0;
      for (final col in cols) {
        if (col.span == 0) continue;
        final int occupy = (col.offset ?? 0) + (col.span ?? 0);
        if (wrap && current.isNotEmpty && used + occupy > 24) {
          lines.add(current);
          current = [];
          used = 0;
        }
        current.add(col);
        used += occupy;
      }
      if (current.isNotEmpty) lines.add(current);

      final List<Widget> lineWidgets = [];
      for (int i = 0; i < lines.length; i++) {
        lineWidgets.add(_buildLine(lines[i], unit));
        if (i < lines.length - 1 && verticalGutter > 0) {
          lineWidgets.add(SizedBox(height: verticalGutter));
        }
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lineWidgets,
      );
    });
  }

  Widget _buildLine(List<SantoCol> line, double unit) {
    final List<Widget> items = [];
    for (int i = 0; i < line.length; i++) {
      final col = line[i];
      final bool isFirst = i == 0;
      final bool isLast = i == line.length - 1;
      final EdgeInsets padding = EdgeInsets.only(
        left: isFirst ? 0 : gutter / 2,
        right: isLast ? 0 : gutter / 2,
      );

      if ((col.offset ?? 0) > 0) {
        items.add(SizedBox(width: unit * col.offset!));
      }

      Widget content = Padding(padding: padding, child: col.child);
      if ((col.push ?? 0) > 0 || (col.pull ?? 0) > 0) {
        final double shift = unit * ((col.push ?? 0) - (col.pull ?? 0));
        content = Transform.translate(offset: Offset(shift, 0), child: content);
      }

      if (col.flex != null) {
        items.add(Expanded(flex: col.flex!, child: content));
      } else if (col.span != null) {
        items.add(SizedBox(width: unit * col.span!, child: content));
      } else {
        items.add(content);
      }
    }

    return Row(
      mainAxisAlignment: justify,
      crossAxisAlignment: align,
      children: items,
    );
  }
}
