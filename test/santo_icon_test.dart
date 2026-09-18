import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

Widget _host(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Center(child: child),
    ),
  );
}

void main() {
  final commonConfig =
      SantoThemeConfigurator.instance.getConfig().commonConfig;

  testWidgets('默认尺寸取主题 iconSizeMd', (tester) async {
    await tester.pumpWidget(_host(const SantoIcon(SantoIcons.search)));
    await tester.pumpAndSettle();

    final size = tester.getSize(find.byType(SantoIcon));
    expect(size, Size(commonConfig.iconSizeMd, commonConfig.iconSizeMd));
  });

  testWidgets('size 覆盖默认边长', (tester) async {
    await tester.pumpWidget(_host(const SantoIcon(SantoIcons.search, size: 32)));
    await tester.pumpAndSettle();

    final size = tester.getSize(find.byType(SantoIcon));
    expect(size, const Size(32, 32));
  });

  testWidgets('默认颜色取主题正文色', (tester) async {
    await tester.pumpWidget(_host(const SantoIcon(SantoIcons.search)));
    await tester.pumpAndSettle();

    final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
    expect(
      svg.colorFilter,
      ColorFilter.mode(commonConfig.colorTextBase, BlendMode.srcIn),
    );
  });

  testWidgets('color 覆盖默认颜色', (tester) async {
    await tester.pumpWidget(_host(
      const SantoIcon(SantoIcons.search, color: Color(0xFF00FF00)),
    ));
    await tester.pumpAndSettle();

    final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
    expect(
      svg.colorFilter,
      ColorFilter.mode(const Color(0xFF00FF00), BlendMode.srcIn),
    );
  });

  testWidgets('按名称加载对应 SVG 资源', (tester) async {
    await tester.pumpWidget(_host(const SantoIcon(SantoIcons.checkCircle)));
    await tester.pumpAndSettle();

    final loader = tester
        .widget<SvgPicture>(find.byType(SvgPicture))
        .bytesLoader as SvgAssetLoader;
    expect(loader.assetName, 'assets/icons/iconoir/check-circle.svg');
    expect(loader.packageName, 'santo_ui');
  });

  testWidgets('semanticLabel 透出无障碍语义', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_host(
      const SantoIcon(SantoIcons.search, semanticLabel: '搜索'),
    ));
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('搜索'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('未传 semanticLabel 时无语义标签', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_host(const SantoIcon(SantoIcons.search)));
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('搜索'), findsNothing);
    handle.dispose();
  });

  testWidgets('SantoIcons 常量值为 SVG 文件名', (tester) async {
    expect(SantoIcons.search, 'search');
    expect(SantoIcons.checkCircle, 'check-circle');
    expect(SantoIcons.arrowLeft, 'arrow-left');
  });
}
