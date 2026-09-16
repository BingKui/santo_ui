import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

/// 收集富文本中的叶子片段
List<TextSpan> _leafSpans(InlineSpan span) {
  final List<TextSpan> spans = <TextSpan>[];
  span.visitChildren((InlineSpan child) {
    if (child is TextSpan && child.text != null) {
      spans.add(child);
    }
    return true;
  });
  return spans;
}

Future<List<TextSpan>> _pumpHighlight(
  WidgetTester tester, {
  required String sourceString,
  required List<String> keywords,
  bool caseSensitive = false,
  InlineSpan Function(BuildContext context, String text)? highlightBuilder,
}) async {
  await tester.pumpWidget(MaterialApp(
    home: Center(
      child: SantoHighlight(
        sourceString: sourceString,
        keywords: keywords,
        caseSensitive: caseSensitive,
        highlightBuilder: highlightBuilder,
      ),
    ),
  ));

  final RichText richText = tester.widget<RichText>(find.byType(RichText));
  return _leafSpans(richText.text);
}

void main() {
  testWidgets('SantoHighlight 高亮命中的关键词', (tester) async {
    final List<TextSpan> spans = await _pumpHighlight(
      tester,
      sourceString: '慢慢来，比较快',
      keywords: const ['慢慢来'],
    );

    expect(spans.map((s) => s.text).toList(), <String>['慢慢来', '，比较快']);
    expect(spans.first.style?.color, const Color(0xFF1677FF));
    expect(spans.last.style?.color, isNull);
  });

  testWidgets('SantoHighlight 支持多个关键词并按位置拆分片段', (tester) async {
    final List<TextSpan> spans = await _pumpHighlight(
      tester,
      sourceString: '1 慢慢来 2 比较快 3',
      keywords: const ['慢慢来', '比较快'],
    );

    expect(
      spans.map((s) => s.text).toList(),
      <String>['1 ', '慢慢来', ' 2 ', '比较快', ' 3'],
    );
    expect(spans[1].style?.color, const Color(0xFF1677FF));
    expect(spans[3].style?.color, const Color(0xFF1677FF));
  });

  testWidgets('SantoHighlight 合并重叠的关键词', (tester) async {
    final List<TextSpan> spans = await _pumpHighlight(
      tester,
      sourceString: 'abc',
      keywords: const ['ab', 'bc'],
    );

    expect(spans.length, 1);
    expect(spans.single.text, 'abc');
    expect(spans.single.style?.color, const Color(0xFF1677FF));
  });

  testWidgets('SantoHighlight 默认忽略大小写,caseSensitive 为 true 时区分', (tester) async {
    final List<TextSpan> ignoreCase = await _pumpHighlight(
      tester,
      sourceString: 'Flutter flutter',
      keywords: const ['Flutter'],
    );
    expect(
      ignoreCase.where((s) => s.style?.color == const Color(0xFF1677FF)).length,
      2,
    );

    final List<TextSpan> sensitive = await _pumpHighlight(
      tester,
      sourceString: 'Flutter flutter',
      keywords: const ['Flutter'],
      caseSensitive: true,
    );
    expect(
      sensitive.where((s) => s.style?.color == const Color(0xFF1677FF)).length,
      1,
    );
  });

  testWidgets('SantoHighlight 支持自定义高亮片段', (tester) async {
    final List<TextSpan> spans = await _pumpHighlight(
      tester,
      sourceString: '慢慢来，比较快',
      keywords: const ['比较快'],
      highlightBuilder: (context, text) => TextSpan(text: '[$text]'),
    );

    expect(spans.map((s) => s.text).toList(), <String>['慢慢来，', '[比较快]']);
  });

  testWidgets('SantoHighlight 未命中时整段为普通片段', (tester) async {
    final List<TextSpan> spans = await _pumpHighlight(
      tester,
      sourceString: '慢慢来，比较快',
      keywords: const ['不存在的词'],
    );

    expect(spans.length, 1);
    expect(spans.single.text, '慢慢来，比较快');
    expect(spans.single.style?.color, isNull);
  });

  testWidgets('SantoHighlight 忽略空关键词', (tester) async {
    final List<TextSpan> spans = await _pumpHighlight(
      tester,
      sourceString: '慢慢来',
      keywords: const ['', '慢慢'],
    );

    expect(spans.length, 2);
    expect(spans.first.style?.color, const Color(0xFF1677FF));
  });
}
