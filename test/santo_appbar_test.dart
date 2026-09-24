import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/src/components/icon/santo_icon.dart';
import 'package:santo_ui/src/components/icon/santo_icons.dart';
import 'package:santo_ui/src/components/navbar/santo_appbar.dart';
import 'package:santo_ui/src/theme/base/santo_default_config_utils.dart';
import 'package:santo_ui/src/theme/base/santo_text_style.dart';
import 'package:santo_ui/src/theme/configs/santo_appbar_config.dart';

void main() {
  final commonConfig = SantoDefaultConfigUtils.defaultCommonConfig;
  final appBarConfig = SantoDefaultConfigUtils.defaultAppBarConfig;

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
    expect(titleStyle!.color, commonConfig.colorTextBaseInverse,
        reason: '深色背景未自定义颜色时标题默认白色');
    final actionStyle = tester.widget<Text>(find.text('操作')).style;
    expect(actionStyle!.color, Colors.green, reason: '自定义颜色应保留');
  });

  testWidgets('深色背景:标题与右侧文字操作自动切换为浅色', (tester) async {
    await tester.pumpWidget(buildApp(Colors.black));
    await tester.pumpAndSettle();

    final titleStyle = tester.widget<Text>(find.text('页面标题')).style;
    expect(titleStyle!.color, commonConfig.colorTextBaseInverse,
        reason: '深色导航栏上标题应为浅色');
    final actionStyle = tester.widget<Text>(find.text('操作')).style;
    expect(actionStyle!.color, commonConfig.colorTextBaseInverse,
        reason: '深色导航栏上右侧文字操作应为浅色');
  });

  testWidgets('浅色背景:标题与右侧文字操作保持默认深色', (tester) async {
    await tester.pumpWidget(buildApp(Colors.white));
    await tester.pumpAndSettle();

    final titleStyle = tester.widget<Text>(find.text('页面标题')).style;
    expect(titleStyle!.color, commonConfig.colorTextBase);
    final actionStyle = tester.widget<Text>(find.text('操作')).style;
    expect(actionStyle!.color, commonConfig.colorTextBase);
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
    expect(titleStyle!.color, commonConfig.colorTextBase,
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

  testWidgets('右侧图标操作与左侧同款:点击区 32×32、水波圆角 12、图标 20', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: SantoAppBar(
          title: '标题名称',
          leading: SantoBackLeading(iconPressed: () {}),
          actions: <Widget>[
            SantoIconAction(icon: SantoIcons.heart, iconPressed: () {}),
          ],
        ),
        body: const SizedBox.shrink(),
      ),
    ));
    await tester.pumpAndSettle();

    final leadingArea = find.descendant(
      of: find.byType(SantoBackLeading),
      matching: find.byType(InkWell),
    );
    final actionArea = find.descendant(
      of: find.byType(SantoIconAction),
      matching: find.byType(InkWell),
    );

    expect(tester.getSize(actionArea), const Size(32, 32),
        reason: '点击区应与返回键一致,固定 leadingSize');
    expect(tester.getSize(actionArea), tester.getSize(leadingArea));
    expect(_inkRadius(tester, actionArea), _inkRadius(tester, leadingArea),
        reason: '水波圆角应与返回键一致');
    expect(
      tester.getSize(find.descendant(
        of: find.byType(SantoIconAction),
        matching: find.byType(SantoIcon),
      )),
      const Size(20, 20),
      reason: 'icon 入参按主题图标大小(20)构建,与返回箭头一致',
    );
  });

  testWidgets('左右操作区间距一致(5),距屏幕边缘均 15', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: SantoAppBar(
          title: '标题名称',
          leading: SantoDoubleLeading(
            first: SantoBackLeading(iconPressed: () {}),
            second: SantoBackLeading(iconPressed: () {}),
          ),
          actions: <Widget>[
            SantoIconAction(icon: SantoIcons.heart, iconPressed: () {}),
            SantoIconAction(icon: SantoIcons.group, iconPressed: () {}),
          ],
        ),
        body: const SizedBox.shrink(),
      ),
    ));
    await tester.pumpAndSettle();

    final leads = find.byType(SantoBackLeading);
    final actions = find.byType(SantoIconAction);
    final double leadingGap =
        tester.getRect(leads.at(1)).left - tester.getRect(leads.at(0)).right;
    final double actionGap =
        tester.getRect(actions.at(1)).left - tester.getRect(actions.at(0)).right;

    expect(leadingGap, appBarConfig.leadingSpacing);
    expect(actionGap, leadingGap, reason: '右侧操作区间距应与左侧一致');
    expect(tester.getRect(leads.at(0)).left, 15,
        reason: '左侧操作区距屏幕边缘 15');
    expect(
      tester.getSize(find.byType(AppBar)).width -
          tester.getRect(actions.at(1)).right,
      15,
      reason: '右侧操作区距屏幕边缘 15',
    );
  });
}

/// 取 InkWell 的圆角半径
double _inkRadius(WidgetTester tester, Finder inkWell) {
  final InkWell ink = tester.widget<InkWell>(inkWell);
  return ink.borderRadius!.topLeft.x;
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
