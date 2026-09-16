import 'package:flutter/material.dart';

import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 关键词高亮文本
///
/// 对标 Vant Highlight:在 [sourceString] 中检索 [keywords] 并高亮命中的片段,
/// 支持多个关键词、大小写控制与自定义高亮内容。
///
/// 示例:
/// ```dart
/// SantoHighlight(sourceString: '慢慢来,比较快', keywords: ['慢慢来'])
///
/// SantoHighlight(
///   sourceString: '1 慢慢来 2 比较快 3',
///   keywords: ['慢慢来', '比较快'],
///   highlightStyle: TextStyle(color: Color(0xFFFF5722)),
/// )
/// ```
///
/// 说明:Vant 面向 HTML 的 `tag`/`highlight-tag`/`unhighlight-tag`/`*-class`
/// 与 `auto-escape` 在 Flutter 中没有对应物,分别由 [highlightStyle]、
/// [unhighlightStyle] 与 [highlightBuilder] 承担。
class SantoHighlight extends StatelessWidget {
  /// 源文本,即被检索的整段文本
  final String sourceString;

  /// 需要高亮的关键词
  ///
  /// 多个关键词的命中区间按位置合并,重叠部分合并为一个高亮片段
  final List<String> keywords;

  /// 是否区分大小写,默认 false
  final bool caseSensitive;

  /// 文本基础样式,默认字号 14、基础文字色
  final TextStyle? textStyle;

  /// 高亮片段样式,默认品牌主题色;优先级低于 [highlightBuilder]
  final TextStyle? highlightStyle;

  /// 非高亮片段样式,默认继承 [textStyle]
  final TextStyle? unhighlightStyle;

  /// 自定义高亮片段,返回的 span 替换默认的高亮文本
  final InlineSpan Function(BuildContext context, String text)? highlightBuilder;

  /// 自定义非高亮片段,返回的 span 替换默认的普通文本
  final InlineSpan Function(BuildContext context, String text)? unhighlightBuilder;

  const SantoHighlight({
    Key? key,
    required this.keywords,
    this.sourceString = '',
    this.caseSensitive = false,
    this.textStyle,
    this.highlightStyle,
    this.unhighlightStyle,
    this.highlightBuilder,
    this.unhighlightBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SantoCommonConfig common =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final TextStyle highlight =
        highlightStyle ?? TextStyle(color: common.brandPrimary);

    return Text.rich(
      TextSpan(
        children: <InlineSpan>[
          for (final _SantoHighlightChunk chunk in _buildChunks())
            _buildSpan(context, chunk, highlight),
        ],
      ),
      style: textStyle ??
          TextStyle(
            fontSize: common.fontSizeBase,
            color: common.colorTextBase,
          ),
    );
  }

  InlineSpan _buildSpan(
    BuildContext context,
    _SantoHighlightChunk chunk,
    TextStyle highlight,
  ) {
    final String text = sourceString.substring(chunk.start, chunk.end);
    if (chunk.highlight) {
      return highlightBuilder?.call(context, text) ??
          TextSpan(text: text, style: highlight);
    }
    return unhighlightBuilder?.call(context, text) ??
        TextSpan(text: text, style: unhighlightStyle);
  }

  /// 检索所有关键词并按位置切成「高亮 / 非高亮」片段
  ///
  /// 与 Vant 一致:命中区间按起点排序后逐个并入,与前一片段重叠时向后延长,
  /// 不相邻时补齐中间的普通片段,末尾不足的部分补成普通片段。
  List<_SantoHighlightChunk> _buildChunks() {
    final List<_SantoHighlightChunk> matched = <_SantoHighlightChunk>[];
    final String source =
        caseSensitive ? sourceString : sourceString.toLowerCase();

    for (final String keyword in keywords) {
      if (keyword.isEmpty) continue;
      final String target = caseSensitive ? keyword : keyword.toLowerCase();
      int index = source.indexOf(target);
      while (index != -1) {
        matched.add(_SantoHighlightChunk(
          start: index,
          end: index + target.length,
          highlight: true,
        ));
        index = source.indexOf(target, index + target.length);
      }
    }

    matched.sort((a, b) => a.start != b.start ? a.start - b.start : a.end - b.end);

    final List<_SantoHighlightChunk> chunks = <_SantoHighlightChunk>[];
    for (final _SantoHighlightChunk chunk in matched) {
      final _SantoHighlightChunk? prev = chunks.isEmpty ? null : chunks.last;
      if (prev == null || chunk.start > prev.end) {
        final int gapStart = prev?.end ?? 0;
        if (gapStart != chunk.start) {
          chunks.add(_SantoHighlightChunk(
            start: gapStart,
            end: chunk.start,
            highlight: false,
          ));
        }
        chunks.add(chunk);
      } else if (chunk.end > prev.end) {
        prev.end = chunk.end;
      }
    }

    final _SantoHighlightChunk? last = chunks.isEmpty ? null : chunks.last;
    if (last == null) {
      chunks.add(_SantoHighlightChunk(
        start: 0,
        end: sourceString.length,
        highlight: false,
      ));
    } else if (last.end < sourceString.length) {
      chunks.add(_SantoHighlightChunk(
        start: last.end,
        end: sourceString.length,
        highlight: false,
      ));
    }
    return chunks;
  }
}

/// 高亮文本片段,[start] 与 [end] 为源文本中的下标
class _SantoHighlightChunk {
  _SantoHighlightChunk({
    required this.start,
    required this.end,
    required this.highlight,
  });

  final int start;

  /// 片段结束下标,合并相邻命中时会向后延长
  int end;

  /// 是否为高亮片段
  final bool highlight;
}
