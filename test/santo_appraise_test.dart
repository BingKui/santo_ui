import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

void main() {
  testWidgets('标签平铺换行，而非一行占一个', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              child: SantoAppraise(
                title: '评价',
                tags: const <String>[
                  '我',
                  '我是可选择',
                  '我是文案特别长会独自占一行的标签文案',
                ],
                config: const SantoAppraiseConfig(
                  showTextInput: false,
                  showConfirmButton: false,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final Rect first = tester.getRect(find.text('我'));
    final Rect second = tester.getRect(find.text('我是可选择'));
    final Rect longTag = tester.getRect(find.text('我是文案特别长会独自占一行的标签文案'));

    // 两个短标签铺在同一行
    expect(first.top, second.top);
    expect(second.left, greaterThan(first.left));

    // 单个标签不再吃满整行宽度
    expect(first.width, lessThan(200));

    // 标签横间距取 gapSm:两段 chip 内边距(hSpacingSm) + Wrap spacing(gapSm)
    final SantoCommonConfig common =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    expect(
      second.left - first.right,
      common.hSpacingSm * 2 + common.gapSm,
    );

    // 超长标签换到下一行
    expect(longTag.top, greaterThan(first.top));
  });

  testWidgets('选中标签回调可用', (tester) async {
    List<String> selected = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              child: SantoAppraise(
                title: '评价',
                tags: const <String>['我', '我是可选择'],
                config: SantoAppraiseConfig(
                  showTextInput: false,
                  showConfirmButton: false,
                  tagSelectCallback: (List<String> tags) => selected = tags,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('我是可选择'));
    await tester.pumpAndSettle();

    expect(selected, <String>['我是可选择']);
  });
}
