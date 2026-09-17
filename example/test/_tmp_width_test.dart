import 'package:example/sample/components/section/section_example.dart';
import 'package:example/sample/components/pagination/pagination_example.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

void main() {
  for (final entry in {
    'SectionExample': const SectionExample(),
    'PaginationExample': PaginationExample(),
  }.entries) {
    testWidgets('${entry.key} Section 宽度', (tester) async {
      tester.view.physicalSize = const Size(860, 1334);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFF5F6FA)),
        home: entry.value,
      ));
      await tester.pump(const Duration(milliseconds: 300));
      final screen = tester.getSize(find.byType(Scaffold));
      final section = tester.getRect(find.byType(SantoSection).first);
      debugPrint('### ${entry.key}: screen=${screen.width} section.width=${section.width} left=${section.left}');
      expect(tester.takeException(), isNull);
    });
  }
}
