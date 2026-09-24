import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/src/components/selectcity/santo_az_listview.dart';
import 'package:santo_ui/src/components/selectcity/santo_select_city_model.dart';
import 'package:santo_ui/src/theme/base/santo_default_config_utils.dart';

void main() {
  final commonConfig = SantoDefaultConfigUtils.defaultCommonConfig;

  Future<List<SantoSelectCityModel>> buildData() async {
    return [
      SantoSelectCityModel(name: '北京')
        ..tagIndex = 'B'
        ..tag = 'B',
      SantoSelectCityModel(name: '杭州')
        ..tagIndex = 'H'
        ..tag = 'H',
    ];
  }

  Widget buildApp(List<SantoSelectCityModel> data) {
    return MaterialApp(
      home: Scaffold(
        body: AzListView(
          data: data,
          suspensionWidget: const SizedBox(),
          itemBuilder: (context, model) =>
              SizedBox(height: 50, child: Text((model as dynamic).name)),
          isUseRealIndex: true,
        ),
      ),
    );
  }

  Text letterText(WidgetTester tester, String letter) {
    return tester
        .widgetList<Text>(find.text(letter))
        .firstWhere((t) => t.style != null);
  }

  testWidgets('默认选中字母显示品牌色圆底白字,其余为默认样式', (tester) async {
    final data = await buildData();
    await tester.pumpWidget(buildApp(data));
    await tester.pumpAndSettle();

    final b = letterText(tester, 'B');
    expect(b.style!.color, commonConfig.colorTextBaseInverse,
        reason: '默认选中的第一个字母应为白字');
    expect(b.style!.fontWeight, FontWeight.w500);

    final h = letterText(tester, 'H');
    expect(h.style!.color, commonConfig.colorTextBase,
        reason: '未选中字母取主题文字色');
  });

  testWidgets('按下其他字母时该字母高亮,松手后选中态跟随列表分组', (tester) async {
    final data = await buildData();
    await tester.pumpWidget(buildApp(data));
    await tester.pumpAndSettle();

    // 按下索引条上的字母 H(列表项文字是城市名,H 只出现在索引条)
    final gesture =
        await tester.startGesture(tester.getCenter(find.text('H')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final h = letterText(tester, 'H');
    expect(h.style!.color, isNot(const Color(0xFF101D37)),
        reason: '按下的字母应高亮');

    await gesture.up();
    await tester.pumpAndSettle();

    final selected = tester
        .widgetList<Text>(find.byType(Text))
        .where((t) => t.style?.color == Colors.white)
        .length;
    expect(selected, 1, reason: '松手后应恰好有一个字母处于选中态');
  });
}
