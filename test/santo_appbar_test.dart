import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/src/components/navbar/santo_appbar.dart';
import 'package:santo_ui/src/components/navbar/santo_appbar_theme.dart';
import 'package:santo_ui/src/theme/base/santo_text_style.dart';
import 'package:santo_ui/src/theme/configs/santo_appbar_config.dart';

void main() {
  Widget buildApp(Color? backgroundColor) {
    return MaterialApp(
      home: Scaffold(
        appBar: SantoAppBar(
          title: '页面标题',
          backgroundColor: backgroundColor,
          actions: SantoTextAction('操作', iconPressed: () {}),
        ),
        body: const SizedBox.shrink(),
      ),
    );
  }

  testWidgets('深色模式:未自定义颜色时标题与操作默认白色,自定义颜色保留', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: SantoAppBar(
          title: '页面标题',
          backgroundColor: const Color(0xFF2E313B),
          themeData: SantoAppBarConfig(
            actionsStyle: SantoTextStyle(color: Colors.green),
          ),
          actions: SantoTextAction('操作', iconPressed: () {}),
        ),
        body: const SizedBox.shrink(),
      ),
    ));
    await tester.pumpAndSettle();

    final titleStyle = tester.widget<Text>(find.text('页面标题')).style;
    expect(titleStyle!.color, SantoAppBarTheme.darkTextColor,
        reason: '深色背景未自定义颜色时标题默认白色');
    final actionStyle = tester.widget<Text>(find.text('操作')).style;
    expect(actionStyle!.color, Colors.green, reason: '自定义颜色应保留');
  });

  testWidgets('深色背景:标题与右侧文字操作自动切换为浅色', (tester) async {
    await tester.pumpWidget(buildApp(Colors.black));
    await tester.pumpAndSettle();

    final titleStyle = tester.widget<Text>(find.text('页面标题')).style;
    expect(titleStyle!.color, SantoAppBarTheme.darkTextColor,
        reason: '深色导航栏上标题应为浅色');
    final actionStyle = tester.widget<Text>(find.text('操作')).style;
    expect(actionStyle!.color, SantoAppBarTheme.darkTextColor,
        reason: '深色导航栏上右侧文字操作应为浅色');
  });

  testWidgets('浅色背景:标题与右侧文字操作保持默认深色', (tester) async {
    await tester.pumpWidget(buildApp(Colors.white));
    await tester.pumpAndSettle();

    final titleStyle = tester.widget<Text>(find.text('页面标题')).style;
    expect(titleStyle!.color, SantoAppBarTheme.lightTextColor);
    final actionStyle = tester.widget<Text>(find.text('操作')).style;
    expect(actionStyle!.color, SantoAppBarTheme.lightTextColor);
  });

  testWidgets('浅色背景:自定义白色标题被强制回退为黑色', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: SantoAppBar(
          title: '页面标题',
          backgroundColor: Colors.white,
          themeData: SantoAppBarConfig(
            titleStyle: SantoTextStyle(color: Colors.white),
          ),
        ),
        body: const SizedBox.shrink(),
      ),
    ));
    await tester.pumpAndSettle();

    final titleStyle = tester.widget<Text>(find.text('页面标题')).style;
    expect(titleStyle!.color, SantoAppBarTheme.lightTextColor,
        reason: '浅色模式不允许白色内容,应回退为黑色');
  });

  testWidgets('左右操作区域距屏幕边缘 15,双操作区间距 5 且不溢出', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: SantoDoubleLeadingBar(),
        body: const SizedBox.shrink(),
      ),
    ));
    await tester.pumpAndSettle();

    final screenWidth = tester.view.physicalSize.width /
        tester.view.devicePixelRatio;
    final leadingRight = tester.getRect(find.byType(SantoDoubleLeading)).right;
    // SantoDoubleLeading 宽 15 + 32 + 5 + 32 = 84
    expect(leadingRight, 84);
    expect(screenWidth, greaterThan(leadingRight));
  });
}

class SantoDoubleLeadingBar extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(44);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(
        title: '标题名称',
        leading: SantoDoubleLeading(
          first: SantoBackLeading(),
          second: SantoBackLeading(),
        ),
        actions: SantoTextAction('文本按钮'),
      ),
      body: const SizedBox.shrink(),
    );
  }
}
