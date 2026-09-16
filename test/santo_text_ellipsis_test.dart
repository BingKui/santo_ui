import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

const String _content =
    '慢慢来，比较快。这是一段用于演示文本省略的长文本，超出指定行数后会自动折叠，'
    '并在省略号之后紧跟展开操作，点击即可展开全部内容，再次点击即可收起。';

const String _expand = '展开全文';
const String _collapse = '收起全文';

Future<void> _pump(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    MaterialApp(home: Center(child: SizedBox(width: 120, child: child))),
  );
}

String _plainText(WidgetTester tester) {
  final RichText richText = tester.widget<RichText>(find.byType(RichText));
  return richText.text.toPlainText();
}

/// 去掉尾部的展开操作文案,得到折叠后的正文
String _body(WidgetTester tester) {
  final String plain = _plainText(tester);
  return plain.endsWith(_expand)
      ? plain.substring(0, plain.length - _expand.length)
      : plain;
}

void main() {
  testWidgets('SantoTextEllipsis 内容未超出时不展示操作', (tester) async {
    await _pump(
      tester,
      const SantoTextEllipsis(
        content: '慢慢来，比较快',
        rows: 2,
        expandText: _expand,
        collapseText: _collapse,
      ),
    );

    expect(_plainText(tester), '慢慢来，比较快');
    expect(find.text(_expand, findRichText: true), findsNothing);
  });

  testWidgets('SantoTextEllipsis 超出时折叠并以省略号和展开操作收尾', (tester) async {
    await _pump(
      tester,
      const SantoTextEllipsis(
        content: _content,
        expandText: _expand,
        collapseText: _collapse,
      ),
    );

    final String body = _body(tester);
    expect(body.endsWith('...'), isTrue);
    // 折叠后保留的文本是原文的前缀
    expect(_content.startsWith(body.substring(0, body.length - 3)), isTrue);
    expect(_content.length, greaterThan(body.length));
  });

  testWidgets('SantoTextEllipsis rows 越大保留的文本越多', (tester) async {
    await _pump(
      tester,
      const SantoTextEllipsis(
        content: _content,
        rows: 1,
        expandText: _expand,
        collapseText: _collapse,
      ),
    );
    final String oneRow = _body(tester);

    await _pump(
      tester,
      const SantoTextEllipsis(
        content: _content,
        rows: 3,
        expandText: _expand,
        collapseText: _collapse,
      ),
    );
    final String threeRows = _body(tester);

    expect(threeRows.length, greaterThan(oneRow.length));
    expect(
      _content.startsWith(threeRows.substring(0, threeRows.length - 3)),
      isTrue,
    );
  });

  testWidgets('SantoTextEllipsis 省略开头时保留结尾文本', (tester) async {
    await _pump(
      tester,
      const SantoTextEllipsis(
        content: _content,
        rows: 2,
        position: SantoTextEllipsisPosition.start,
        expandText: _expand,
        collapseText: _collapse,
      ),
    );

    final String body = _body(tester);
    expect(body.startsWith('...'), isTrue);
    expect(_content.endsWith(body.substring(3)), isTrue);
  });

  testWidgets('SantoTextEllipsis 省略中间时保留开头与结尾文本', (tester) async {
    await _pump(
      tester,
      const SantoTextEllipsis(
        content: _content,
        rows: 2,
        position: SantoTextEllipsisPosition.middle,
        expandText: _expand,
        collapseText: _collapse,
      ),
    );

    final String body = _body(tester);
    final int dotsIndex = body.indexOf('...');
    expect(dotsIndex, greaterThan(0));
    expect(_content.startsWith(body.substring(0, dotsIndex)), isTrue);
    expect(_content.endsWith(body.substring(dotsIndex + 3)), isTrue);
  });

  testWidgets('SantoTextEllipsis 支持自定义省略文案', (tester) async {
    await _pump(
      tester,
      const SantoTextEllipsis(
        content: _content,
        dots: '……',
        expandText: _expand,
        collapseText: _collapse,
      ),
    );

    expect(_body(tester).endsWith('……'), isTrue);
  });

  testWidgets('SantoTextEllipsis 点击操作文案展开并可再次收起', (tester) async {
    bool? lastExpanded;
    await _pump(
      tester,
      SantoTextEllipsis(
        content: _content,
        expandText: _expand,
        collapseText: _collapse,
        onClickAction: (expanded) => lastExpanded = expanded,
      ),
    );

    await tester.tapOnText(find.textRange.ofSubstring(_expand));
    await tester.pump();

    expect(lastExpanded, isTrue);
    expect(_plainText(tester), '$_content$_collapse');

    await tester.tapOnText(find.textRange.ofSubstring(_collapse));
    await tester.pump();

    expect(lastExpanded, isFalse);
    expect(_plainText(tester).endsWith('...$_expand'), isTrue);
  });

  testWidgets('SantoTextEllipsis 支持外部切换展开态', (tester) async {
    final GlobalKey<SantoTextEllipsisState> key = GlobalKey();
    await _pump(
      tester,
      SantoTextEllipsis(
        key: key,
        content: _content,
        expandText: _expand,
        collapseText: _collapse,
      ),
    );

    expect(key.currentState?.expanded, isFalse);

    key.currentState?.toggle();
    await tester.pump();

    expect(key.currentState?.expanded, isTrue);
    expect(_plainText(tester), '$_content$_collapse');

    key.currentState?.toggle(false);
    await tester.pump();

    expect(key.currentState?.expanded, isFalse);
  });

  testWidgets('SantoTextEllipsis 支持自定义操作内容', (tester) async {
    await _pump(
      tester,
      SantoTextEllipsis(
        content: _content,
        actionBuilder: (context, expanded) =>
            TextSpan(text: expanded ? '[收起]' : '[展开]'),
      ),
    );

    expect(_plainText(tester).endsWith('[展开]'), isTrue);
  });
}
