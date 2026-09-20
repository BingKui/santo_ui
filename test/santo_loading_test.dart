import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  /// 取 SantoLoading 内部蒙层(避免命中 Scaffold 自带的 ColoredBox)的尺寸
  Size maskSize(WidgetTester tester) => tester.getSize(find
      .descendant(
          of: find.byType(SantoLoading), matching: find.byType(ColoredBox))
      .first);

  testWidgets('默认展示主题色不确定进度圆环', (tester) async {
    final common = SantoThemeConfigurator.instance.getConfig().commonConfig;
    await tester.pumpWidget(wrap(const SantoLoading()));

    final CircularProgressIndicator indicator =
        tester.widget<CircularProgressIndicator>(
            find.byType(CircularProgressIndicator));
    expect(indicator.value, isNull);
    expect(indicator.color, common.brandPrimary);
  });

  testWidgets('size 三档尺寸', (tester) async {
    await tester.pumpWidget(wrap(Column(children: const <Widget>[
      SantoLoading(size: SantoLoadingSize.small),
      SantoLoading(),
      SantoLoading(size: SantoLoadingSize.large),
    ])));

    expect(
      tester.getSize(find.byType(CircularProgressIndicator).at(0)),
      const Size(14, 14),
    );
    expect(
      tester.getSize(find.byType(CircularProgressIndicator).at(1)),
      const Size(20, 20),
    );
    expect(
      tester.getSize(find.byType(CircularProgressIndicator).at(2)),
      const Size(32, 32),
    );
  });

  testWidgets('tip 展示在指示器下方', (tester) async {
    await tester.pumpWidget(wrap(const SantoLoading(tip: '加载中')));

    expect(find.text('加载中'), findsOneWidget);
    final double textTop = tester.getTopLeft(find.text('加载中')).dy;
    final double indicatorBottom =
        tester.getBottomLeft(find.byType(CircularProgressIndicator)).dy;
    expect(textTop, greaterThanOrEqualTo(indicatorBottom));
  });

  testWidgets('percent 展示确定进度与百分比', (tester) async {
    await tester.pumpWidget(wrap(const SantoLoading(percent: 40)));

    expect(
      tester
          .widget<CircularProgressIndicator>(
              find.byType(CircularProgressIndicator))
          .value,
      0.4,
    );
    expect(find.text('40%'), findsOneWidget);
  });

  testWidgets('percent 超出范围会被收敛到 0~1', (tester) async {
    await tester.pumpWidget(wrap(const SantoLoading(percent: 130)));

    expect(
      tester
          .widget<CircularProgressIndicator>(
              find.byType(CircularProgressIndicator))
          .value,
      1.0,
    );
  });

  testWidgets('spinning 为 false 时不展示', (tester) async {
    await tester.pumpWidget(wrap(const SantoLoading(spinning: false)));

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('delay 延迟期间不展示,到点后展示', (tester) async {
    await tester.pumpWidget(wrap(const SantoLoading(
      delay: Duration(milliseconds: 300),
    )));

    expect(find.byType(CircularProgressIndicator), findsNothing);
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(CircularProgressIndicator), findsNothing);
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('delay 期间加载结束则不展示', (tester) async {
    await tester.pumpWidget(wrap(const SantoLoading(
      delay: Duration(milliseconds: 300),
    )));
    await tester.pumpWidget(wrap(const SantoLoading(
      spinning: false,
      delay: Duration(milliseconds: 300),
    )));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('包裹模式:加载时在内容上盖蒙层', (tester) async {
    const Widget content = SizedBox(
      key: ValueKey<String>('content'),
      width: 200,
      height: 80,
    );
    await tester.pumpWidget(wrap(const SantoLoading(
      tip: '加载中',
      child: content,
    )));

    expect(find.byKey(const ValueKey<String>('content')), findsOneWidget);
    expect(find.text('加载中'), findsOneWidget);
    // 蒙层铺满被包裹的内容
    expect(maskSize(tester), const Size(200, 80));

    await tester.pumpWidget(wrap(const SantoLoading(
      spinning: false,
      tip: '加载中',
      child: content,
    )));
    expect(find.byKey(const ValueKey<String>('content')), findsOneWidget);
    expect(find.text('加载中'), findsNothing);
  });

  testWidgets('fullscreen 铺满父布局并居中', (tester) async {
    await tester.pumpWidget(wrap(const SantoLoading(
      fullscreen: true,
      tip: '全屏加载',
    )));

    expect(find.text('全屏加载'), findsOneWidget);
    expect(maskSize(tester), const Size(800, 600));

    await tester.pumpWidget(wrap(const SantoLoading(
      fullscreen: true,
      spinning: false,
    )));
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('自定义指示器替换默认圆环', (tester) async {
    await tester.pumpWidget(wrap(const SantoLoading(
      indicator: Icon(Icons.cloud_download),
    )));

    expect(find.byIcon(Icons.cloud_download), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('show 展示黑胶囊浮层,dismiss 关闭', (tester) async {
    late BuildContext context;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(builder: (BuildContext ctx) {
          context = ctx;
          return const SizedBox.shrink();
        }),
      ),
    ));

    SantoLoading.show(context, tip: '提交中');
    // 圆环是无限动画,pumpAndSettle 会超时,这里手动推帧
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('提交中'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    SantoLoading.dismiss(context);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('提交中'), findsNothing);
  });

  testWidgets('浮层胶囊宽度由布局决定,不随环境字体样式溢出', (tester) async {
    late BuildContext context;
    await tester.pumpWidget(MaterialApp(
      home: MediaQuery(
        // 放大系统字号
        data: const MediaQueryData(textScaler: TextScaler.linear(1.6)),
        child: Scaffold(
          body: DefaultTextStyle(
            // 环境字体样式与胶囊内实际渲染的样式不同:按固定测量值算死的宽度会溢出
            style: const TextStyle(letterSpacing: 6, fontSize: 14),
            child: Builder(builder: (BuildContext ctx) {
              context = ctx;
              return const SizedBox.shrink();
            }),
          ),
        ),
      ),
    ));

    const String longTip = '正在提交,请稍候,完成后会自动关闭';
    SantoLoading.show(context, tip: longTip);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // 不出现溢出异常,且胶囊不超出 2/3 屏宽
    expect(tester.takeException(), isNull);
    final Finder pill = find
        .ancestor(
            of: find.textContaining('正在提交'),
            matching: find.byType(Container))
        .first;
    expect(tester.getSize(pill).width, lessThanOrEqualTo(800 * 2 / 3));
    expect(find.textContaining('正在提交'), findsOneWidget);

    SantoLoading.dismiss(context);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  });

  testWidgets('show 不传 tip 时用本地化默认文案', (tester) async {
    late BuildContext context;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(builder: (BuildContext ctx) {
          context = ctx;
          return const SizedBox.shrink();
        }),
      ),
    ));

    SantoLoading.show(context);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final String loadingText =
        SantoIntl.of(context).localizedResource.loading;
    expect(find.text(loadingText), findsOneWidget);

    SantoLoading.dismiss(context);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  });
}
