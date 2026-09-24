import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

Widget _host(Widget child) => MaterialApp(
      home: Scaffold(body: Center(child: child)),
    );

List<Widget> _pages(int count) => List<Widget>.generate(
      count,
      (i) => ColoredBox(color: Colors.primaries[i % Colors.primaries.length]),
    );

void main() {
  testWidgets('SantoSwiper 外部改 currentIndex 会翻到对应页', (tester) async {
    await tester.pumpWidget(_host(
      SantoSwiper(
        children: _pages(5),
        autoPlay: false,
        loop: false,
        currentIndex: 0,
      ),
    ));
    expect(tester.widget<PageView>(find.byType(PageView)).controller!.page, 0);

    await tester.pumpWidget(_host(
      SantoSwiper(
        children: _pages(5),
        autoPlay: false,
        loop: false,
        currentIndex: 3,
      ),
    ));
    await tester.pumpAndSettle();

    expect(tester.widget<PageView>(find.byType(PageView)).controller!.page, 3);
  });

  testWidgets('SantoSwiper 循环模式下外部改 currentIndex 同样生效', (tester) async {
    await tester.pumpWidget(_host(
      SantoSwiper(children: _pages(3), autoPlay: false, currentIndex: 0),
    ));
    await tester.pumpWidget(_host(
      SantoSwiper(children: _pages(3), autoPlay: false, currentIndex: 2),
    ));
    await tester.pumpAndSettle();

    // 循环模式用虚拟页,取模后等于目标页
    final double page =
        tester.widget<PageView>(find.byType(PageView)).controller!.page!;
    expect(page % 3, 2);
  });

  testWidgets('SantoSwiper 内部滑动后父级同步同值不重复跳动', (tester) async {
    int? reported;
    Widget build(int current) => _host(SantoSwiper(
          children: _pages(3),
          autoPlay: false,
          loop: false,
          currentIndex: current,
          onPageChanged: (index) => reported = index,
        ));

    await tester.pumpWidget(build(0));
    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();
    expect(reported, 1);

    // 父级把滑到的页码同步回来,不应再次动画
    await tester.pumpWidget(build(1));
    await tester.pumpAndSettle();
    expect(tester.widget<PageView>(find.byType(PageView)).controller!.page, 1);
    expect(reported, 1);
  });

  testWidgets('SantoSwiper enableSwipe 为 false 时无法手动滑动', (tester) async {
    await tester.pumpWidget(_host(
      SantoSwiper(
        children: _pages(3),
        autoPlay: false,
        loop: false,
        enableSwipe: false,
      ),
    ));

    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();

    expect(tester.widget<PageView>(find.byType(PageView)).controller!.page, 0);
  });

  testWidgets('SantoSwiper 圆角由外层容器裁切', (tester) async {
    await tester.pumpWidget(_host(
      SantoSwiper(children: _pages(3), autoPlay: false),
    ));

    final ClipRRect clip = tester.widget<ClipRRect>(find.byType(ClipRRect));
    expect(clip.borderRadius, BorderRadius.circular(12));
  });
}
