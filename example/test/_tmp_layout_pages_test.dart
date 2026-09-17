import 'package:example/sample/components/layout/app_layout_example.dart';
import 'package:example/sample/components/layout/page_layout_example.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

void main() {
  testWidgets('AppLayout 示例页交互无异常', (tester) async {
    tester.view.physicalSize = const Size(750, 1334);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFF5F6FA)),
      routes: <String, WidgetBuilder>{
        AppLayoutDemoRoutes.notice: (_) =>
            const AppLayoutDemoRoutePage(title: '通知'),
      },
      home: const AppLayoutExample(),
    ));
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);

    // 切到「发现」
    await tester.tap(find.descendant(
        of: find.byType(SantoMenuBar), matching: find.text('发现')));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);

    // 切到「我的」
    await tester.tap(find.descendant(
        of: find.byType(SantoMenuBar), matching: find.text('我的')));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);

    // 打开「更多」面板
    await tester.tap(find.descendant(
        of: find.byType(SantoMenuBar), matching: find.text('更多')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // 点「通知」按命名路由跳转
    await tester.tap(find.text('通知'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('通知'), findsWidgets);
  });

  testWidgets('PageLayout 示例页渲染无异常', (tester) async {
    tester.view.physicalSize = const Size(750, 1334);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFF5F6FA)),
      home: const PageLayoutExample(),
    ));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);
    expect(find.byType(SantoPageLayout), findsOneWidget);
  });
}
