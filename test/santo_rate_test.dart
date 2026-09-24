import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

Widget _host(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

/// 已选中的实心星
Finder get _selectedStars => find.byWidgetPredicate((Widget widget) =>
    widget is SantoIcon && widget.name == SantoIcons.star && widget.solid);

/// 未选中的空心星
Finder get _unselectedStars => find.byWidgetPredicate((Widget widget) =>
    widget is SantoIcon && widget.name == SantoIcons.star && !widget.solid);

SantoIcon _firstIcon(WidgetTester tester, Finder finder) =>
    tester.widget<SantoIcon>(finder.first);

void main() {
  final SantoCommonConfig commonConfig =
      SantoThemeConfigurator.instance.getConfig().commonConfig;

  testWidgets('选中星取品牌主色、未选星取分割线色与主题图标尺寸', (tester) async {
    await tester.pumpWidget(_host(const SantoRate(selectedCount: 3)));

    expect(_selectedStars, findsNWidgets(3));
    expect(_unselectedStars, findsNWidgets(2));
    expect(_firstIcon(tester, _selectedStars).color, commonConfig.brandPrimary);
    expect(_firstIcon(tester, _selectedStars).size, commonConfig.iconSizeMd);
    expect(
      _firstIcon(tester, _unselectedStars).color,
      commonConfig.dividerColorBase,
    );
  });

  testWidgets('换自定义主题色后选中星跟着变', (tester) async {
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

    await tester.pumpWidget(_host(const SantoRate(selectedCount: 2)));

    expect(_firstIcon(tester, _selectedStars).color, pink);
  });

  testWidgets('半颗星同样取品牌主色', (tester) async {
    await tester.pumpWidget(_host(const SantoRate(selectedCount: 2.5)));

    final SantoIcon halfStar = _firstIcon(
      tester,
      find.byWidgetPredicate((Widget widget) =>
          widget is SantoIcon && widget.name == SantoIcons.starHalfDashed),
    );
    expect(halfStar.color, commonConfig.brandPrimary);
  });
}
