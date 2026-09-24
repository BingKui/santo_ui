import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

Widget _host(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

/// 通知条自己的容器:带圆角背景且设了最小高度约束
Finder get _noticeContainer => find.byWidgetPredicate((Widget widget) =>
    widget is Container &&
    widget.decoration is BoxDecoration &&
    widget.constraints?.minHeight != null);

BoxDecoration _noticeDecoration(WidgetTester tester) =>
    tester.widget<Container>(_noticeContainer.first).decoration!
        as BoxDecoration;

double _noticeMinHeight(WidgetTester tester) =>
    tester.widget<Container>(_noticeContainer.first).constraints!.minHeight;

SantoIcon _iconNamed(WidgetTester tester, String name) =>
    tester.widget<SantoIcon>(find.byWidgetPredicate(
        (Widget widget) => widget is SantoIcon && widget.name == name));

void main() {
  setUp(SantoMultiClickUtils.reset);

  final SantoCommonConfig commonConfig =
      SantoThemeConfigurator.instance.getConfig().commonConfig;

  testWidgets('内置样式取色跟随主题色', (tester) async {
    // 先铺基座,再叠加只带主题色的配置(与示例 App / 业务 App 的注册方式一致)
    addTearDown(
      () => SantoThemeConfigurator.instance
          .register(SantoDefaultConfigUtils.defaultAllConfig),
    );
    SantoThemeConfigurator.instance
        .register(SantoDefaultConfigUtils.defaultAllConfig);
    const Color pink = Color(0xFFEB2F96);
    SantoThemeConfigurator.instance.register(SantoAllThemeConfig(
      commonConfig: SantoCommonConfig(
        brandPrimary: pink,
        brandPrimaryTap: Color(0x19EB2F96),
        colorLink: pink,
      ),
    ));

    await tester.pumpWidget(_host(const SantoNotice(content: '通知内容')));

    // 底是主题色 10% 透明,图标与文字都是主题色
    expect(_noticeDecoration(tester).color,
        pink.withOpacity(kSantoNoticeBackgroundOpacity));
    expect(_iconNamed(tester, SantoIcons.hourglass).color, pink);
    expect(
      tester.widget<Text>(find.text('通知内容')).style!.color,
      pink,
    );
  });

  testWidgets('十种内置样式分别取对应的品牌色', (tester) async {
    expect(santoNoticeStyleColor(commonConfig, SantoNoticeStyleType.fail),
        commonConfig.brandError);
    expect(santoNoticeStyleColor(commonConfig, SantoNoticeStyleType.succeed),
        commonConfig.brandSuccess);
    expect(santoNoticeStyleColor(commonConfig, SantoNoticeStyleType.warning),
        commonConfig.brandWarning);
    // 进行中与通知都跟随主题色
    expect(santoNoticeStyleColor(commonConfig, SantoNoticeStyleType.running),
        commonConfig.brandPrimary);
    expect(santoNoticeStyleColor(commonConfig, SantoNoticeStyleType.notice),
        commonConfig.brandPrimary);

    await tester.pumpWidget(_host(SantoNotice(
      content: '失败的通知',
      noticeStyle: NoticeStyles.failWithArrow,
    )));
    expect(_iconNamed(tester, SantoIcons.xmarkCircle).color,
        commonConfig.brandError);
    expect(_noticeDecoration(tester).color,
        commonConfig.brandError.withOpacity(kSantoNoticeBackgroundOpacity));
  });

  testWidgets('左侧标签与右侧按钮都由参数配置', (tester) async {
    int tapped = 0;
    await tester.pumpWidget(_host(SantoNotice(
      leftTagText: '任务',
      content: '通知内容',
      rightButtonText: '去完成',
      onRightButtonTap: () => tapped++,
    )));

    expect(find.text('任务'), findsOneWidget);
    expect(find.text('通知内容'), findsOneWidget);
    expect(find.text('去完成'), findsOneWidget);
    // 标签与按钮占位后不再渲染状态图标
    expect(find.byWidgetPredicate((Widget widget) => widget is SantoIcon),
        findsNothing);

    await tester.tap(find.text('去完成'));
    expect(tapped, 1);
  });

  testWidgets('带标签或按钮时最小高度 54,否则 36', (tester) async {
    await tester.pumpWidget(_host(const SantoNotice(content: '通知内容')));
    expect(_noticeMinHeight(tester), kSantoNoticeMinHeight);

    await tester.pumpWidget(
        _host(const SantoNotice(content: '通知内容', leftTagText: '任务')));
    expect(_noticeMinHeight(tester), kSantoNoticeTallMinHeight);

    await tester
        .pumpWidget(_host(const SantoNotice(content: '通知内容', rightButtonText: '去完成')));
    expect(_noticeMinHeight(tester), kSantoNoticeTallMinHeight);

    // 显式传入时以传入值为准
    await tester.pumpWidget(
        _host(const SantoNotice(content: '通知内容', minHeight: 56)));
    expect(_noticeMinHeight(tester), 56);
  });

  testWidgets('showLeftIcon / showRightIcon 控制状态图标显隐', (tester) async {
    await tester.pumpWidget(_host(
        const SantoNotice(content: '通知内容', showLeftIcon: false)));
    expect(find.byWidgetPredicate((Widget widget) => widget is SantoIcon),
        findsOneWidget);

    await tester.pumpWidget(_host(
        const SantoNotice(content: '通知内容', showRightIcon: false)));
    expect(find.byWidgetPredicate((Widget widget) => widget is SantoIcon),
        findsOneWidget);
  });

  testWidgets('自定义样式沿用传入的颜色与图标', (tester) async {
    await tester.pumpWidget(_host(SantoNotice(
      content: '通知内容',
      noticeStyle: NoticeStyle(
        const SantoIcon(SantoIcons.bell, size: 14, color: Color(0xFF00AA00)),
        const Color(0xFF00AA00),
        const Color(0x1100AA00),
        const SantoIcon(SantoIcons.xmark, size: 16, color: Color(0xFF00AA00)),
      ),
    )));

    expect(_iconNamed(tester, SantoIcons.bell).color, const Color(0xFF00AA00));
    expect(_noticeDecoration(tester).color, const Color(0x1100AA00));
    expect(tester.widget<Text>(find.text('通知内容')).style!.color,
        const Color(0xFF00AA00));
  });

  testWidgets('marquee 开启时换成跑马灯文本', (tester) async {
    await tester.pumpWidget(_host(const SantoNotice(
      content: '很长的通知内容很长的通知内容很长的通知内容',
      marquee: true,
    )));

    expect(
      find.byWidgetPredicate((Widget widget) =>
          widget.runtimeType.toString() == 'SantoMarqueeText'),
      findsOneWidget,
    );
  });

  testWidgets('点击整条触发 onNoticeTap', (tester) async {
    int tapped = 0;
    await tester.pumpWidget(_host(SantoNotice(
      content: '通知内容',
      onNoticeTap: () => tapped++,
    )));

    await tester.tap(find.text('通知内容'));
    expect(tapped, 1);
  });

  testWidgets('自定义左右控件替换图标', (tester) async {
    await tester.pumpWidget(_host(const SantoNotice(
      content: '通知内容',
      leftWidget: Icon(Icons.info_outline),
      rightWidget: Icon(Icons.arrow_forward_ios),
    )));

    expect(find.byIcon(Icons.info_outline), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
    expect(find.byWidgetPredicate((Widget widget) => widget is SantoIcon),
        findsNothing);
  });
}
