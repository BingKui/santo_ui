import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

Future<void> _pump(
  WidgetTester tester,
  Widget bar, {
  double bottomPadding = 0,
}) {
  return tester.pumpWidget(MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(
        size: const Size(800, 600),
        padding: EdgeInsets.only(bottom: bottomPadding),
      ),
      child: Align(alignment: Alignment.bottomCenter, child: bar),
    ),
  ));
}

/// 取按钮的背景装饰
BoxDecoration _decorationOf(WidgetTester tester, String text) {
  final Finder container = find
      .ancestor(
        of: find.text(text),
        matching: find.byWidgetPredicate((Widget widget) =>
            widget is Container && widget.decoration is BoxDecoration),
      )
      .first;
  return tester.widget<Container>(container).decoration! as BoxDecoration;
}

/// 取按钮上第一个容器的左边缘
double _leftOf(WidgetTester tester, String text) {
  final Finder container = find
      .ancestor(
        of: find.text(text),
        matching: find.byWidgetPredicate((Widget widget) =>
            widget is Container && widget.decoration is BoxDecoration),
      )
      .first;
  return tester.getTopLeft(container).dx;
}

/// 取按钮上第一个容器的右边缘
double _rightOf(WidgetTester tester, String text) {
  final Finder container = find
      .ancestor(
        of: find.text(text),
        matching: find.byWidgetPredicate((Widget widget) =>
            widget is Container && widget.decoration is BoxDecoration),
      )
      .first;
  return tester.getTopRight(container).dx;
}

const Radius _r12 = Radius.circular(12);

void main() {
  testWidgets('SantoActionBar 渲染图标与按钮并响应点击', (tester) async {
    String? tapped;
    await _pump(
      tester,
      SantoActionBar(
        children: [
          SantoActionBarIcon(
            icon: const Icon(Icons.headset_mic),
            text: '客服',
            onTap: () => tapped = '客服',
          ),
          SantoActionBarButton(
            text: '立即购买',
            type: SantoActionBarButtonType.danger,
            onTap: () => tapped = '立即购买',
          ),
        ],
      ),
    );

    expect(find.text('客服'), findsOneWidget);
    expect(find.text('立即购买'), findsOneWidget);

    await tester.tap(find.text('客服'));
    expect(tapped, '客服');

    await tester.tap(find.text('立即购买'));
    expect(tapped, '立即购买');
  });

  testWidgets('SantoActionBar 图标固定宽度,按钮平分剩余宽度', (tester) async {
    await _pump(
      tester,
      SantoActionBar(
        children: [
          const SantoActionBarIcon(
            icon: Icon(Icons.shopping_cart),
            text: '购物车',
          ),
          SantoActionBarButton(text: '加入购物车'),
          SantoActionBarButton(text: '立即购买'),
        ],
      ),
    );

    expect(tester.getSize(find.byType(SantoActionBarIcon)).width, 48);
    expect(tester.getSize(find.byType(SantoActionBarButton).at(0)).width, 376);
    expect(
      tester.getSize(find.byType(SantoActionBarButton).at(0)).width,
      tester.getSize(find.byType(SantoActionBarButton).at(1)).width,
    );
  });

  testWidgets('SantoActionBar 首尾按钮带外侧圆角与外边距', (tester) async {
    await _pump(
      tester,
      SantoActionBar(
        children: [
          SantoActionBarButton(text: '加入购物车'),
          SantoActionBarButton(text: '立即购买'),
        ],
      ),
    );

    expect(
      _decorationOf(tester, '加入购物车').borderRadius,
      const BorderRadius.only(topLeft: _r12, bottomLeft: _r12),
    );
    expect(
      _decorationOf(tester, '立即购买').borderRadius,
      const BorderRadius.only(topRight: _r12, bottomRight: _r12),
    );
    expect(_leftOf(tester, '加入购物车'), 5);
    expect(800 - _rightOf(tester, '立即购买'), 5);
  });

  testWidgets('SantoActionBar 只有单个按钮时两侧都收圆角', (tester) async {
    await _pump(
      tester,
      SantoActionBar(
        children: [SantoActionBarButton(text: '确定')],
      ),
    );

    expect(
      _decorationOf(tester, '确定').borderRadius,
      const BorderRadius.all(_r12),
    );
    expect(_leftOf(tester, '确定'), 5);
    expect(800 - _rightOf(tester, '确定'), 5);
  });

  testWidgets('SantoActionBar 按钮类型决定背景与描边', (tester) async {
    await _pump(
      tester,
      SantoActionBar(
        children: [
          SantoActionBarButton(text: '默认按钮'),
          SantoActionBarButton(
            text: '危险按钮',
            type: SantoActionBarButtonType.danger,
          ),
        ],
      ),
    );

    expect(_decorationOf(tester, '默认按钮').color, const Color(0xFFFFFFFF));
    expect(_decorationOf(tester, '默认按钮').border, isNotNull);
    expect(_decorationOf(tester, '危险按钮').color, const Color(0xFFFF4D4F));
    expect(_decorationOf(tester, '危险按钮').border, isNull);
  });

  testWidgets('SantoActionBar 图标支持红点与数字角标', (tester) async {
    await _pump(
      tester,
      SantoActionBar(
        children: [
          const SantoActionBarIcon(
            icon: Icon(Icons.chat),
            text: '消息',
            dot: true,
          ),
          const SantoActionBarIcon(
            icon: Icon(Icons.shopping_cart),
            text: '购物车',
            badgeCount: 5,
          ),
        ],
      ),
    );

    expect(find.byType(SantoBadge), findsNWidgets(2));
    expect(tester.widget<SantoBadge>(find.byType(SantoBadge).first).isDot, isTrue);
    expect(tester.widget<SantoBadge>(find.byType(SantoBadge).last).count, 5);
    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('SantoActionBar 禁用状态不响应点击', (tester) async {
    bool tapped = false;
    await _pump(
      tester,
      SantoActionBar(
        children: [
          SantoActionBarIcon(
            icon: const Icon(Icons.star),
            text: '收藏',
            disabled: true,
            onTap: () => tapped = true,
          ),
          SantoActionBarButton(
            text: '已下架',
            disabled: true,
            onTap: () => tapped = true,
          ),
        ],
      ),
    );

    await tester.tap(find.text('收藏'));
    await tester.tap(find.text('已下架'));
    expect(tapped, isFalse);
  });

  testWidgets('SantoActionBar 加载状态展示进度指示且不响应点击', (tester) async {
    bool tapped = false;
    await _pump(
      tester,
      SantoActionBar(
        children: [
          SantoActionBarButton(
            text: '提交订单',
            loading: true,
            onTap: () => tapped = true,
          ),
        ],
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.tap(find.text('提交订单'));
    expect(tapped, isFalse);
  });

  testWidgets('SantoActionBar 默认适配底部安全区', (tester) async {
    await _pump(
      tester,
      SantoActionBar(
        children: [SantoActionBarButton(text: '确定')],
      ),
      bottomPadding: 34,
    );

    final Container root = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(SantoActionBar),
            matching: find.byType(Container),
          )
          .first,
    );
    expect(root.padding, const EdgeInsets.only(bottom: 34));
    expect(tester.getSize(find.byType(SantoActionBar)).height, 84);
  });

  testWidgets('SantoActionBar 关闭安全区适配后不预留高度', (tester) async {
    await _pump(
      tester,
      SantoActionBar(
        safeAreaInsetBottom: false,
        children: [SantoActionBarButton(text: '确定')],
      ),
      bottomPadding: 34,
    );

    final Container root = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(SantoActionBar),
            matching: find.byType(Container),
          )
          .first,
    );
    expect(root.padding, EdgeInsets.zero);
    expect(tester.getSize(find.byType(SantoActionBar)).height, 50);
  });
}
