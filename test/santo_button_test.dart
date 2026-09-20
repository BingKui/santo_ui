import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  Color? bgOf(WidgetTester tester, {Finder? of}) {
    final Container container = tester.widget<Container>(find
        .descendant(
            of: of ?? find.byType(SantoButton), matching: find.byType(Container))
        .first);
    final Decoration? decoration = container.decoration;
    return decoration is BoxDecoration ? decoration.color : null;
  }

  testWidgets('type 语法糖渲染 antd 的五种样式', (tester) async {
    await tester.pumpWidget(wrap(Column(children: [
      SantoButton(text: '主按钮', type: SantoButtonType.primary),
      SantoButton(text: '默认按钮', type: SantoButtonType.normal),
      SantoButton(text: '文本按钮', type: SantoButtonType.text),
      SantoButton(text: '链接按钮', type: SantoButtonType.link),
    ])));

    // 主按钮为主题色实心
    expect(bgOf(tester), const Color(0xFF1677FF));

    // 链接按钮文字用主题色
    final Text linkText = tester.widget<Text>(find.text('链接按钮'));
    expect(linkText.style?.color, const Color(0xFF1677FF));

    // 默认按钮白底带描边
    final Container normalContainer = tester.widget<Container>(find
        .ancestor(of: find.text('默认按钮'), matching: find.byType(Container))
        .first);
    final BoxDecoration normalDecoration =
        normalContainer.decoration as BoxDecoration;
    expect(normalDecoration.color, Colors.white);
    expect(normalDecoration.border, isNotNull);

    // 文本按钮无底色无边框
    final Container textContainer = tester.widget<Container>(find
        .ancestor(of: find.text('文本按钮'), matching: find.byType(Container))
        .first);
    final BoxDecoration textDecoration =
        textContainer.decoration as BoxDecoration;
    expect(textDecoration.color, Colors.transparent);
    expect(textDecoration.border, isNull);
  });

  testWidgets('danger 使用失败色', (tester) async {
    await tester.pumpWidget(wrap(
      SantoButton(
        text: '删除',
        type: SantoButtonType.primary,
        danger: true,
      ),
    ));

    expect(bgOf(tester), const Color(0xFFFF4D4F));
  });

  testWidgets('color + variant 组合出更多样式', (tester) async {
    await tester.pumpWidget(wrap(Column(children: [
      SantoButton(
        text: '填充按钮',
        color: SantoButtonColor.primary,
        variant: SantoButtonVariant.filled,
      ),
      SantoButton(
        text: '幽灵按钮',
        type: SantoButtonType.normal,
        ghost: true,
      ),
    ])));

    // 浅色填充:主题色 10% 透明度
    expect(bgOf(tester), const Color(0xFF1677FF).withOpacity(0.1));

    // 幽灵按钮背景透明,文字默认反色
    expect(
      bgOf(tester,
          of: find.ancestor(
              of: find.text('幽灵按钮'), matching: find.byType(SantoButton))),
      Colors.transparent,
    );
    expect(
      tester.widget<Text>(find.text('幽灵按钮')).style?.color,
      const Color(0xFFFFFFFF),
    );
  });

  testWidgets('幽灵按钮:透明底,文字与边框取该颜色的主色', (tester) async {
    final common = SantoThemeConfigurator.instance.getConfig().commonConfig;
    await tester.pumpWidget(wrap(Column(children: [
      SantoButton(text: '默认幽灵', type: SantoButtonType.normal, ghost: true),
      SantoButton(text: '主色幽灵', type: SantoButtonType.primary, ghost: true),
      SantoButton(
        text: '危险幽灵',
        type: SantoButtonType.primary,
        danger: true,
        ghost: true,
      ),
    ])));

    BorderSide borderOf(String label) {
      final BoxDecoration decoration = tester
          .widget<Container>(find
              .ancestor(
                  of: find.text(label), matching: find.byType(Container))
              .first)
          .decoration! as BoxDecoration;
      return (decoration.border! as Border).top;
    }

    // 背景透明 + 文字/边框同色:默认色用反色白,primary 用主题色,danger 用失败色
    expect(
      bgOf(tester,
          of: find.ancestor(
              of: find.text('默认幽灵'), matching: find.byType(SantoButton))),
      Colors.transparent,
    );
    expect(tester.widget<Text>(find.text('默认幽灵')).style?.color,
        common.colorTextBaseInverse);
    expect(borderOf('默认幽灵').color, common.colorTextBaseInverse);

    expect(tester.widget<Text>(find.text('主色幽灵')).style?.color,
        common.brandPrimary);
    expect(borderOf('主色幽灵').color, common.brandPrimary);

    expect(tester.widget<Text>(find.text('危险幽灵')).style?.color,
        common.brandError);
    expect(borderOf('危险幽灵').color, common.brandError);
  });

  testWidgets('color 支持主题里的语义色', (tester) async {
    final common = SantoThemeConfigurator.instance.getConfig().commonConfig;
    await tester.pumpWidget(wrap(Column(children: [
      SantoButton(
        text: '成功按钮',
        color: SantoButtonColor.success,
        variant: SantoButtonVariant.solid,
      ),
      SantoButton(
        text: '警告按钮',
        color: SantoButtonColor.warning,
        variant: SantoButtonVariant.filled,
      ),
      SantoButton(
        text: '信息按钮',
        color: SantoButtonColor.info,
        variant: SantoButtonVariant.outlined,
      ),
    ])));

    Color textColorOf(String label) =>
        tester.widget<Text>(find.text(label)).style!.color!;

    expect(
      bgOf(tester,
          of: find.ancestor(
              of: find.text('成功按钮'), matching: find.byType(SantoButton))),
      common.brandSuccess,
    );
    expect(textColorOf('成功按钮'), common.colorTextBaseInverse);
    expect(textColorOf('警告按钮'), common.brandWarning);
    expect(textColorOf('信息按钮'), common.brandAuxiliary);
  });

  testWidgets('虚线按钮画的是虚线:描边不能是实线', (tester) async {
    final GlobalKey boundaryKey = GlobalKey();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: RepaintBoundary(
            key: boundaryKey,
            child: SantoButton(
              text: '虚线按钮',
              type: SantoButtonType.dashed,
              size: SantoButtonSize.large,
            ),
          ),
        ),
      ),
    ));

    // 不能用 BoxDecoration 的实线边框,否则会盖住虚线画笔
    final Container container = tester.widget<Container>(find
        .descendant(
            of: find.byType(SantoButton), matching: find.byType(Container))
        .first);
    expect((container.decoration! as BoxDecoration).border, isNull);
    expect(
      find.descendant(
          of: find.byType(SantoButton), matching: find.byType(CustomPaint)),
      findsWidgets,
    );

    // 顶边像素上应当出现"有笔迹/无笔迹"交替
    final RenderRepaintBoundary boundary = boundaryKey.currentContext!
        .findRenderObject()! as RenderRepaintBoundary;
    late ByteData bytes;
    late int width;
    await tester.runAsync(() async {
      final ui.Image image = await boundary.toImage();
      width = image.width;
      bytes = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
      image.dispose();
    });

    bool inkAt(int x, int y) {
      final int offset = (y * width + x) * 4;
      final int r = bytes.getUint8(offset);
      final int g = bytes.getUint8(offset + 1);
      final int b = bytes.getUint8(offset + 2);
      return r < 240 || g < 240 || b < 240;
    }

    int dashes = 0;
    for (int y = 0; y < 3; y++) {
      int runs = 0;
      bool previous = false;
      for (int x = 2; x < width - 2; x++) {
        final bool ink = inkAt(x, y);
        if (ink && !previous) runs++;
        previous = ink;
      }
      dashes = runs > dashes ? runs : dashes;
    }
    expect(dashes, greaterThan(2), reason: '顶边是连续的实线,没有虚线间隔');
  });

  testWidgets('size 三档高度与字号', (tester) async {
    await tester.pumpWidget(wrap(Column(children: [
      SantoButton(
          text: '大号按钮',
          type: SantoButtonType.primary,
          size: SantoButtonSize.large),
      SantoButton(text: '中号按钮', type: SantoButtonType.primary),
      SantoButton(
          text: '小号按钮',
          type: SantoButtonType.primary,
          size: SantoButtonSize.small),
    ])));

    expect(tester.getSize(find.byType(SantoButton).at(0)).height, 48);
    expect(tester.getSize(find.byType(SantoButton).at(1)).height, 32);
    expect(tester.getSize(find.byType(SantoButton).at(2)).height, 24);
    expect(tester.widget<Text>(find.text('大号按钮')).style?.fontSize, 16);
    expect(tester.widget<Text>(find.text('中号按钮')).style?.fontSize, 14);
    expect(tester.widget<Text>(find.text('小号按钮')).style?.fontSize, 12);
  });

  testWidgets('文案在三档尺寸里都垂直居中', (tester) async {
    await tester.pumpWidget(wrap(Column(children: [
      SantoButton(
          text: '小号按钮',
          type: SantoButtonType.primary,
          size: SantoButtonSize.small),
      SantoButton(text: '中号按钮', type: SantoButtonType.primary),
      SantoButton(
          text: '大号按钮',
          type: SantoButtonType.primary,
          size: SantoButtonSize.large),
      SantoButton(
        text: '大号图标',
        type: SantoButtonType.normal,
        size: SantoButtonSize.large,
        icon: const Icon(Icons.search),
      ),
      SantoButton(
        text: '大号选中',
        type: SantoButtonType.primary,
        size: SantoButtonSize.large,
        block: true,
      ),
    ])));

    for (final String label in <String>[
      '小号按钮',
      '中号按钮',
      '大号按钮',
      '大号图标',
      '大号选中',
    ]) {
      final Finder button = find.ancestor(
          of: find.text(label), matching: find.byType(SantoButton));
      expect(tester.getCenter(find.text(label)).dy,
          closeTo(tester.getCenter(button).dy, 0.5),
          reason: '$label 的文案没有垂直居中');
    }
  });

  testWidgets('shape 为 circle 时是等宽高的纯图标按钮', (tester) async {
    await tester.pumpWidget(wrap(
      SantoButton(
        icon: const Icon(Icons.search),
        type: SantoButtonType.primary,
        shape: SantoButtonShape.circle,
      ),
    ));

    final Size size = tester.getSize(find.byType(SantoButton));
    expect(size.width, 32);
    expect(size.height, 32);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('禁用态使用置灰配色', (tester) async {
    await tester.pumpWidget(wrap(Column(children: [
      SantoButton(
          text: '禁用主按钮',
          type: SantoButtonType.primary,
          isEnable: false),
      SantoButton(
          text: '禁用默认按钮',
          type: SantoButtonType.normal,
          isEnable: false),
    ])));

    expect(bgOf(tester), const Color(0xFFCCCCCC));
    final Text disabledNormalText =
        tester.widget<Text>(find.text('禁用默认按钮'));
    expect(
        disabledNormalText.style?.color,
        SantoThemeConfigurator.instance
            .getConfig()
            .commonConfig
            .colorTextDisabled);
  });

  testWidgets('loading 时不可点击并展示指示器', (tester) async {
    var tapped = false;
    await tester.pumpWidget(wrap(
      SantoButton(
        text: '提交',
        type: SantoButtonType.primary,
        loading: true,
        onTap: () => tapped = true,
      ),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.byType(SantoButton));
    expect(tapped, isFalse);
  });

  testWidgets('block 撑满父布局宽度', (tester) async {
    await tester.pumpWidget(wrap(SizedBox(
      width: 300,
      child: SantoButton(
        text: '确定',
        type: SantoButtonType.primary,
        block: true,
      ),
    )));

    expect(tester.getSize(find.byType(SantoButton)).width, 300);
  });

  testWidgets('两个汉字的文案自动补空格', (tester) async {
    await tester.pumpWidget(wrap(Column(children: [
      SantoButton(text: '确定', type: SantoButtonType.primary),
      SantoButton(
        text: '取消',
        type: SantoButtonType.primary,
        autoInsertSpace: false,
      ),
    ])));

    expect(find.text('确 定'), findsOneWidget);
    expect(find.text('取消'), findsOneWidget);
  });

  testWidgets('图标位置支持 start/end/top/bottom', (tester) async {
    await tester.pumpWidget(wrap(Column(children: [
      SantoButton(
        text: '搜索',
        type: SantoButtonType.primary,
        icon: const Icon(Icons.search),
      ),
      SantoButton(
        text: '下一步',
        type: SantoButtonType.primary,
        iconPlacement: SantoButtonIconPlacement.end,
        icon: const Icon(Icons.arrow_forward),
      ),
      SantoButton(
        text: '图标在上',
        type: SantoButtonType.primary,
        iconPlacement: SantoButtonIconPlacement.top,
        icon: const Icon(Icons.arrow_upward),
      ),
      SantoButton(
        text: '图标在下',
        type: SantoButtonType.normal,
        iconPlacement: SantoButtonIconPlacement.bottom,
        icon: const Icon(Icons.arrow_downward),
      ),
    ])));

    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
    expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
  });

  testWidgets('外部传入的 key 挂到元素上,可当 Tooltip 锚点', (tester) async {
    final GlobalKey buttonKey = GlobalKey();
    await tester.pumpWidget(wrap(SantoButton(
      key: buttonKey,
      text: '带 key',
      onTap: () => SantoTooltip.show(buttonKey.currentContext!, '提示内容', buttonKey),
    )));

    expect(buttonKey.currentContext, isNotNull);
    expect(buttonKey.currentContext!.findRenderObject(), isNotNull);

    await tester.tap(find.byType(SantoButton));
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);
    expect(find.text('提示内容'), findsOneWidget);
  });
}
