import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

void main() {
  testWidgets('bubble shrink-wraps content', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoBubbleText(text: '蓝色气泡，白色文字'),
              const SizedBox(height: 12),
              SantoBubbleText(
                placement: SantoBubblePlacement.end,
                text: '蓝色气泡，白色文字',
              ),
            ],
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    final bubbles = find.byType(SantoBubbleText);
    print('SantoBubbleText (Align) size: start=${tester.getSize(bubbles.first)}, end=${tester.getSize(bubbles.at(1))}');

    final bubbleContainers = find.byWidgetPredicate((w) =>
        w is Container && w.decoration is BoxDecoration);
    for (int i = 0; i < bubbleContainers.evaluate().length; i++) {
      print('bubble container[$i] size: ${tester.getSize(bubbleContainers.at(i))}');
    }

    expect(tester.getSize(bubbleContainers.first).width, lessThan(300),
        reason: '气泡应自适应内容宽度');
  });
}
