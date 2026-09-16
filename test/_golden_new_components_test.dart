import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

const String _long =
    '慢慢来，比较快。这是一段用于演示文本省略的长文本，超出指定行数后会自动折叠。';

void main() {
  testWidgets('golden action bar', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: RepaintBoundary(
            child: Container(
              width: 400,
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: const Color(0xFFF5F6FA),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SantoActionBar(
                    children: [
                      const SantoActionBarIcon(
                        icon: Icon(Icons.chat),
                        text: '消息',
                        dot: true,
                      ),
                      const SantoActionBarIcon(
                        icon: Icon(Icons.shopping_cart),
                        text: '购物车',
                        badgeCount: 12,
                      ),
                      SantoActionBarButton(
                        text: '加入购物车',
                        type: SantoActionBarButtonType.warning,
                      ),
                      SantoActionBarButton(
                        text: '立即购买',
                        type: SantoActionBarButtonType.danger,
                      ),
                    ],
                  ),
                  SantoActionBar(
                    children: [
                      SantoActionBarButton(text: '默认按钮'),
                      SantoActionBarButton(
                        text: '主要按钮',
                        type: SantoActionBarButtonType.primary,
                      ),
                      SantoActionBarButton(text: '禁用按钮', disabled: true),
                    ],
                  ),
                  SantoActionBar(
                    children: [
                      const SantoActionBarIcon(
                        icon: Icon(Icons.star),
                        text: '收藏',
                        color: Color(0xFFFF5722),
                      ),
                      SantoActionBarButton(
                        text: '单个按钮',
                        color: const Color(0xFF7232DD),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(RepaintBoundary).first,
      matchesGoldenFile('goldens/action_bar.png'),
    );
  });

  testWidgets('golden text ellipsis', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: RepaintBoundary(
            child: Container(
              width: 200,
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SantoTextEllipsis(
                    content: _long,
                    rows: 3,
                    expandText: '展开',
                    collapseText: '收起',
                  ),
                  const SizedBox(height: 16),
                  const SantoTextEllipsis(
                    content: _long,
                    rows: 2,
                    position: SantoTextEllipsisPosition.start,
                    expandText: '展开',
                    collapseText: '收起',
                  ),
                  const SizedBox(height: 16),
                  const SantoTextEllipsis(
                    content: _long,
                    rows: 2,
                    position: SantoTextEllipsisPosition.middle,
                    expandText: '展开',
                    collapseText: '收起',
                  ),
                  const SizedBox(height: 16),
                  const SantoHighlight(
                    sourceString: '慢慢来，比较快',
                    keywords: ['慢慢来'],
                    textStyle: TextStyle(fontSize: 48),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(RepaintBoundary).first,
      matchesGoldenFile('goldens/text_ellipsis.png'),
    );
  });
}
