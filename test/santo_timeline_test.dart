import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

Widget _host(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Padding(padding: const EdgeInsets.all(15), child: child),
    ),
  );
}

const List<SantoTimelineItem> _plainItems = <SantoTimelineItem>[
  SantoTimelineItem(content: Text('a1')),
  SantoTimelineItem(content: Text('a2')),
  SantoTimelineItem(content: Text('a3')),
];

const List<SantoTimelineItem> _titledItems = <SantoTimelineItem>[
  SantoTimelineItem(title: 't1', content: Text('c1')),
  SantoTimelineItem(title: 't2', content: Text('c2')),
];

/// 空心/实心节点都是圆形装饰的 Container
Finder _dots() {
  return find.byWidgetPredicate(
    (Widget widget) =>
        widget is Container &&
        widget.decoration is BoxDecoration &&
        (widget.decoration! as BoxDecoration).shape == BoxShape.circle,
  );
}

BoxDecoration _dotDecoration(WidgetTester tester, int index) {
  final List<Container> dots =
      tester.widgetList<Container>(_dots()).toList(growable: false);
  return dots[index].decoration! as BoxDecoration;
}

double _dx(WidgetTester tester, String text) =>
    tester.getTopLeft(find.text(text)).dx;

double _dy(WidgetTester tester, String text) =>
    tester.getTopLeft(find.text(text)).dy;

void main() {
  final commonConfig =
      SantoThemeConfigurator.instance.getConfig().commonConfig;

  group('纵向', () {
    testWidgets('默认轴线在左、内容在右,节点自上而下', (tester) async {
      await tester.pumpWidget(_host(const SantoTimeline(items: _plainItems)));

      expect(tester.takeException(), isNull);
      expect(_dy(tester, 'a1'), lessThan(_dy(tester, 'a2')));
      expect(_dy(tester, 'a2'), lessThan(_dy(tester, 'a3')));

      final double dotX = tester.getCenter(_dots().at(0)).dx;
      expect(tester.getCenter(_dots().at(1)).dx, dotX);
      expect(tester.getCenter(_dots().at(2)).dx, dotX);
      expect(dotX, lessThan(_dx(tester, 'a1')));
    });

    testWidgets('标题与内容分列轴线两侧', (tester) async {
      await tester.pumpWidget(_host(const SantoTimeline(items: _titledItems)));

      expect(tester.takeException(), isNull);
      final double dotX = tester.getCenter(_dots().at(0)).dx;
      expect(_dx(tester, 't1'), lessThan(dotX));
      expect(_dx(tester, 'c1'), greaterThan(dotX));
      // 标题右对齐至轴线,内容左对齐,首行与节点圆心齐平
      expect(
        tester.getCenter(_dots().at(0)).dy,
        closeTo(tester.getCenter(find.text('c1')).dy, 1),
      );
    });

    testWidgets('mode 为 end 时内容在左、标题在右', (tester) async {
      await tester.pumpWidget(
        _host(const SantoTimeline(items: _titledItems, mode: SantoTimelineMode.end)),
      );

      expect(tester.takeException(), isNull);
      final double dotX = tester.getCenter(_dots().at(0)).dx;
      expect(_dx(tester, 'c1'), lessThan(dotX));
      expect(_dx(tester, 't1'), greaterThan(dotX));
    });

    testWidgets('mode 为 alternate 时内容左右交替', (tester) async {
      await tester.pumpWidget(
        _host(const SantoTimeline(
          items: _plainItems,
          mode: SantoTimelineMode.alternate,
        )),
      );

      expect(tester.takeException(), isNull);
      final double dotX = tester.getCenter(_dots().at(0)).dx;
      expect(_dx(tester, 'a1'), greaterThan(dotX));
      expect(_dx(tester, 'a2'), lessThan(dotX));
      expect(_dx(tester, 'a3'), greaterThan(dotX));
    });

    testWidgets('titleSpan 控制标题列宽度,不传时轴线居中', (tester) async {
      await tester.pumpWidget(_host(const SantoTimeline(items: _titledItems)));
      final Rect timeline = tester.getRect(find.byType(SantoTimeline));
      expect(
        tester.getCenter(_dots().at(0)).dx,
        closeTo(timeline.center.dx, 1),
      );

      await tester.pumpWidget(
        _host(const SantoTimeline(items: _titledItems, titleSpan: 60)),
      );
      final double narrow = tester.getCenter(_dots().at(0)).dx;
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(
        _host(const SantoTimeline(items: _titledItems, titleSpan: 200)),
      );
      final double wide = tester.getCenter(_dots().at(0)).dx;

      // 标题列越宽,轴线越靠右
      expect(narrow, closeTo(timeline.left + 60 + 8, 1));
      expect(wide, closeTo(timeline.left + 200 + 8, 1));
      expect(narrow, lessThan(wide));
    });

    testWidgets('placement 覆盖单个节点的侧位', (tester) async {
      await tester.pumpWidget(
        _host(const SantoTimeline(
          items: <SantoTimelineItem>[
            SantoTimelineItem(content: Text('a1')),
            SantoTimelineItem(
              content: Text('a2'),
              placement: SantoTimelinePlacement.end,
            ),
          ],
          mode: SantoTimelineMode.alternate,
        )),
      );

      expect(tester.takeException(), isNull);
      expect(_dx(tester, 'a2'), lessThan(_dx(tester, 'a1')));
    });

    testWidgets('reverse 倒序渲染', (tester) async {
      await tester.pumpWidget(
        _host(const SantoTimeline(items: _plainItems, reverse: true)),
      );

      expect(tester.takeException(), isNull);
      expect(_dy(tester, 'a3'), lessThan(_dy(tester, 'a1')));
    });

    testWidgets('color / variant / dotColor 控制节点外观', (tester) async {
      await tester.pumpWidget(
        _host(const SantoTimeline(
          items: <SantoTimelineItem>[
            SantoTimelineItem(content: Text('a1')),
            SantoTimelineItem(
              content: Text('a2'),
              color: SantoTimelineColor.red,
            ),
            SantoTimelineItem(
              content: Text('a3'),
              dotColor: Colors.black,
            ),
          ],
        )),
      );

      expect(tester.takeException(), isNull);
      expect(_dotDecoration(tester, 0).border!.top.color,
          commonConfig.brandPrimary);
      expect(
          _dotDecoration(tester, 1).border!.top.color, commonConfig.brandError);
      expect(_dotDecoration(tester, 2).border!.top.color, Colors.black);
      // 空心节点内部填组件背景色
      expect(_dotDecoration(tester, 0).color, commonConfig.fillBase);

      await tester.pumpWidget(
        _host(const SantoTimeline(
          items: _plainItems,
          variant: SantoTimelineVariant.filled,
        )),
      );
      expect(_dotDecoration(tester, 0).color, commonConfig.brandPrimary);
      expect(_dotDecoration(tester, 0).border, isNull);
    });

    testWidgets('icon 自定义节点,loading 展示加载指示器', (tester) async {
      await tester.pumpWidget(
        _host(const SantoTimeline(
          items: <SantoTimelineItem>[
            SantoTimelineItem(content: Text('a1')),
            SantoTimelineItem(icon: Text('★'), content: Text('a2')),
            SantoTimelineItem(content: Text('a3'), loading: true),
          ],
        )),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('★'), findsOneWidget);
      expect(find.byType(SantoLoading), findsOneWidget);
      expect(_dots(), findsOneWidget);

      // 节点槽位比指示器矮,指示器必须拿回自身尺寸,不能被压成椭圆
      final Rect indicator =
          tester.getRect(find.byType(CircularProgressIndicator));
      expect(indicator.width, indicator.height);
      expect(indicator.center.dy, closeTo(tester.getCenter(find.text('a3')).dy, 0.5));
      expect(
        tester.getRect(find.byType(CircularProgressIndicator)).center.dx,
        closeTo(tester.getCenter(_dots().at(0)).dx, 0.5),
      );
    });

    testWidgets('items 为空时不渲染', (tester) async {
      await tester.pumpWidget(
        _host(const SantoTimeline(items: <SantoTimelineItem>[])),
      );

      expect(tester.takeException(), isNull);
      expect(_dots(), findsNothing);
    });
  });

  group('横向', () {
    testWidgets('默认内容在轴线下方且左右排开', (tester) async {
      await tester.pumpWidget(
        _host(const SantoTimeline(
          items: _plainItems,
          orientation: SantoTimelineOrientation.horizontal,
        )),
      );

      expect(tester.takeException(), isNull);
      expect(_dx(tester, 'a1'), lessThan(_dx(tester, 'a2')));
      expect(_dx(tester, 'a2'), lessThan(_dx(tester, 'a3')));

      // 节点在同一条水平轴线上,内容都在轴线下方
      for (int i = 0; i < 3; i++) {
        expect(
          tester.getCenter(_dots().at(i)).dy,
          closeTo(tester.getCenter(_dots().at(0)).dy, 0.5),
        );
        expect(tester.getCenter(find.text('a${i + 1}')).dy,
            greaterThan(tester.getCenter(_dots().at(i)).dy));
      }
    });

    testWidgets('mode 为 end 时内容在轴线上方', (tester) async {
      await tester.pumpWidget(
        _host(const SantoTimeline(
          items: _plainItems,
          orientation: SantoTimelineOrientation.horizontal,
          mode: SantoTimelineMode.end,
        )),
      );

      expect(tester.takeException(), isNull);
      for (int i = 0; i < 3; i++) {
        expect(tester.getCenter(find.text('a${i + 1}')).dy,
            lessThan(tester.getCenter(_dots().at(i)).dy));
        expect(
          tester.getCenter(_dots().at(i)).dy,
          closeTo(tester.getCenter(_dots().at(0)).dy, 0.5),
        );
      }
    });

    testWidgets('mode 为 alternate 时内容上下交替', (tester) async {
      await tester.pumpWidget(
        _host(const SantoTimeline(
          items: _plainItems,
          orientation: SantoTimelineOrientation.horizontal,
          mode: SantoTimelineMode.alternate,
        )),
      );

      expect(tester.takeException(), isNull);
      final double dotY = tester.getCenter(_dots().at(0)).dy;
      expect(tester.getCenter(_dots().at(1)).dy, closeTo(dotY, 0.5));
      expect(tester.getCenter(_dots().at(2)).dy, closeTo(dotY, 0.5));
      expect(tester.getCenter(find.text('a1')).dy, greaterThan(dotY));
      expect(tester.getCenter(find.text('a2')).dy, lessThan(dotY));
    });

    testWidgets('标题与内容排在轴线同侧', (tester) async {
      await tester.pumpWidget(
        _host(const SantoTimeline(
          items: _titledItems,
          orientation: SantoTimelineOrientation.horizontal,
        )),
      );

      expect(tester.takeException(), isNull);
      final double dotY = tester.getCenter(_dots().at(0)).dy;
      expect(_dy(tester, 't1'), greaterThan(dotY));
      expect(_dy(tester, 'c1'), greaterThan(_dy(tester, 't1')));
    });
  });
}
