import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

void main() {
  // 按钮自带 500ms 防重复点击(静态状态),避免上一个用例的点击影响当前用例
  setUp(SantoMultiClickUtils.reset);

  testWidgets('SantoMoreMenu shows title, action and grid items',
      (tester) async {
    var actionTapped = false;
    var itemTapped = false;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(builder: (context) {
          return Center(
            child: SantoNormalButton(
              text: '打开',
              onTap: () {
                SantoMoreMenu.show(
                  context,
                  title: '更多',
                  actionText: '编辑',
                  onActionTap: () => actionTapped = true,
                  items: [
                    SantoMoreMenuItem(
                      label: '文档',
                      icon: Icons.description_outlined,
                      onTap: () => itemTapped = true,
                    ),
                    SantoMoreMenuItem(label: '会议', icon: Icons.videocam_outlined),
                  ],
                );
              },
            ),
          );
        }),
      ),
    ));

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    expect(find.text('更多'), findsOneWidget);
    expect(find.text('编辑'), findsOneWidget);
    expect(find.text('文档'), findsOneWidget);
    expect(find.text('会议'), findsOneWidget);

    // 点击菜单项:先关闭再回调
    await tester.tap(find.text('文档'));
    await tester.pumpAndSettle();
    expect(itemTapped, isTrue);
    expect(find.text('更多'), findsNothing);
  });

  testWidgets('SantoMoreMenu action button works', (tester) async {
    var actionTapped = false;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(builder: (context) {
          return Center(
            child: SantoNormalButton(
              text: '打开',
              onTap: () {
                SantoMoreMenu.show(
                  context,
                  title: '更多',
                  actionText: '编辑',
                  onActionTap: () => actionTapped = true,
                  items: [SantoMoreMenuItem(label: '文档', icon: Icons.edit)],
                );
              },
            ),
          );
        }),
      ),
    ));

    // 跨过全局防连点的 500ms 窗口(上一测试的点击时间戳仍在生效)
    await tester.pump(const Duration(milliseconds: 600));
    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('编辑'));
    await tester.pumpAndSettle();
    expect(actionTapped, isTrue);
  });
}
