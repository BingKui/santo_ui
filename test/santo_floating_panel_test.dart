import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

const Key _panelKey = SantoFloatingPanel.panelKey;
const Key _contentKey = ValueKey<String>('content');

Widget _wrap(Widget panel) => MaterialApp(
  home: Scaffold(body: Stack(children: [panel])),
);

double _panelHeight(WidgetTester tester) =>
    tester.getSize(find.byKey(_panelKey)).height;

/// 从面板把手条位置发起拖拽
Future<void> _dragHandle(WidgetTester tester, double dy) async {
  final panelRect = tester.getRect(find.byKey(_panelKey));
  await tester.dragFrom(
    Offset(panelRect.center.dx, panelRect.top + 14),
    Offset(0, dy),
  );
  await tester.pumpAndSettle();
}

void main() {
  _renderTests();
  _gestureDragTests();
  _contentDragTests();
  _scrollOverscrollTests();
  _safeAreaTests();
}

void _renderTests() {
  testWidgets('SantoFloatingPanel 默认锚点为 [100, 可用高度*0.6]', (tester) async {
    await tester.pumpWidget(
      _wrap(
        SantoFloatingPanel(
          child: Container(key: _contentKey, color: Colors.white),
        ),
      ),
    );

    // 测试窗口高 600,首个锚点 100
    expect(_panelHeight(tester), 100);
    expect(find.byKey(_contentKey), findsOneWidget);
    // 有把手条时内容区顶边在面板顶边下方 28
    final panelRect = tester.getRect(find.byKey(_panelKey));
    expect(tester.getRect(find.byKey(_contentKey)).top - panelRect.top, 28);
  });

  testWidgets('SantoFloatingPanel 初始高度取锚点最小值并可受控', (tester) async {
    await tester.pumpWidget(
      _wrap(
        SantoFloatingPanel(
          anchors: const [320, 100],
          child: Container(key: _contentKey, color: Colors.white),
        ),
      ),
    );
    // 锚点内部按升序整理
    expect(_panelHeight(tester), 100);

    await tester.pumpWidget(
      _wrap(
        SantoFloatingPanel(
          anchors: const [320, 100],
          height: 320,
          child: Container(key: _contentKey, color: Colors.white),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(_panelHeight(tester), 320);
  });

  testWidgets('SantoFloatingPanel draggable 为 false 时不渲染把手条', (tester) async {
    await tester.pumpWidget(
      _wrap(
        SantoFloatingPanel(
          draggable: false,
          contentDraggable: false,
          child: Container(key: _contentKey, color: Colors.white),
        ),
      ),
    );

    final panelRect = tester.getRect(find.byKey(_panelKey));
    expect(tester.getRect(find.byKey(_contentKey)).top - panelRect.top, 0);
  });

  testWidgets('SantoFloatingPanel header 渲染在把手下方的拖拽区内', (tester) async {
    await tester.pumpWidget(
      _wrap(
        SantoFloatingPanel(
          header: const Text('面板标头'),
          child: Container(key: _contentKey, color: Colors.white),
        ),
      ),
    );

    expect(find.text('面板标头'), findsOneWidget);
    final panelRect = tester.getRect(find.byKey(_panelKey));
    expect(tester.getRect(find.text('面板标头')).top - panelRect.top, 28);
  });
}

void _gestureDragTests() {
  testWidgets('拖动把手向上后吸附到最近锚点', (tester) async {
    double? changed;
    await tester.pumpWidget(
      _wrap(
        SantoFloatingPanel(
          anchors: const [100, 320],
          onHeightChange: (height) => changed = height,
          child: Container(key: _contentKey, color: Colors.white),
        ),
      ),
    );

    // 100 + 130 = 230,距 320 更近
    await _dragHandle(tester, -130);

    expect(_panelHeight(tester), 320);
    expect(changed, 320);
  });

  testWidgets('拖动把手向下超过最小锚点时收到底部边界', (tester) async {
    double? changed;
    await tester.pumpWidget(
      _wrap(
        SantoFloatingPanel(
          anchors: const [100, 320],
          height: 320,
          onHeightChange: (height) => changed = height,
          child: Container(key: _contentKey, color: Colors.white),
        ),
      ),
    );

    await _dragHandle(tester, 150);

    // 320 - 150 = 170,距 100 更近
    expect(_panelHeight(tester), 100);
    expect(changed, 100);
  });

  testWidgets('关闭磁力吸附后停在拖拽位置', (tester) async {
    await tester.pumpWidget(
      _wrap(
        SantoFloatingPanel(
          anchors: const [100, 320],
          magnetic: false,
          child: Container(key: _contentKey, color: Colors.white),
        ),
      ),
    );

    await _dragHandle(tester, -130);

    expect(_panelHeight(tester), 230);
  });

  testWidgets('draggable 与 contentDraggable 均为 false 时不可拖拽', (tester) async {
    await tester.pumpWidget(
      _wrap(
        SantoFloatingPanel(
          anchors: const [100, 320],
          draggable: false,
          contentDraggable: false,
          child: Container(key: _contentKey, color: Colors.white),
        ),
      ),
    );

    await tester.drag(find.byKey(_contentKey), const Offset(0, -130));
    await tester.pumpAndSettle();

    expect(_panelHeight(tester), 100);
  });

  testWidgets('点击把手未改变高度时不触发高度回调', (tester) async {
    var called = false;
    await tester.pumpWidget(
      _wrap(
        SantoFloatingPanel(
          anchors: const [100, 320],
          onHeightChange: (_) => called = true,
          child: Container(key: _contentKey, color: Colors.white),
        ),
      ),
    );

    final panelRect = tester.getRect(find.byKey(_panelKey));
    await tester.tapAt(Offset(panelRect.center.dx, panelRect.top + 14));
    await tester.pumpAndSettle();

    expect(called, isFalse);
    expect(_panelHeight(tester), 100);
  });
}

void _contentDragTests() {
  testWidgets('内容不足一屏时可拖拽内容区改变高度', (tester) async {
    double? changed;
    await tester.pumpWidget(
      _wrap(
        SantoFloatingPanel(
          anchors: const [100, 320],
          onHeightChange: (height) => changed = height,
          child: Container(key: _contentKey, color: Colors.white),
        ),
      ),
    );

    await tester.drag(find.byKey(_contentKey), const Offset(0, -130));
    await tester.pumpAndSettle();

    expect(_panelHeight(tester), 320);
    expect(changed, 320);
  });

  testWidgets('contentDraggable 为 false 时拖拽内容区高度不变', (tester) async {
    await tester.pumpWidget(
      _wrap(
        SantoFloatingPanel(
          anchors: const [100, 320],
          contentDraggable: false,
          child: Container(key: _contentKey, color: Colors.white),
        ),
      ),
    );

    await tester.drag(find.byKey(_contentKey), const Offset(0, -130));
    await tester.pumpAndSettle();

    expect(_panelHeight(tester), 100);
  });
}

void _scrollOverscrollTests() {
  testWidgets('内容滚动到顶部后继续下拉收起面板', (tester) async {
    double? changed;
    await tester.pumpWidget(
      _wrap(
        SantoFloatingPanel(
          anchors: const [100, 400],
          height: 400,
          onHeightChange: (height) => changed = height,
          child: ListView.builder(
            key: const ValueKey<String>('list'),
            itemCount: 30,
            itemBuilder: (context, index) =>
                SizedBox(height: 48, child: Text('条目$index')),
          ),
        ),
      ),
    );

    // 列表已在顶部,继续下拉只产生边界溢出,面板随之收小
    await tester.drag(
      find.byKey(const ValueKey<String>('list')),
      const Offset(0, 350),
    );
    await tester.pumpAndSettle();

    expect(_panelHeight(tester), 100);
    expect(changed, 100);
  });

  testWidgets('列表可正常滚动时拖拽不改变面板高度', (tester) async {
    await tester.pumpWidget(
      _wrap(
        SantoFloatingPanel(
          anchors: const [100, 400],
          height: 400,
          child: ListView.builder(
            key: const ValueKey<String>('list'),
            itemCount: 30,
            itemBuilder: (context, index) =>
                SizedBox(height: 48, child: Text('条目$index')),
          ),
        ),
      ),
    );

    await tester.drag(
      find.byKey(const ValueKey<String>('list')),
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();

    expect(_panelHeight(tester), 400);
  });
}

void _safeAreaTests() {
  testWidgets('useSafeArea 为 true 时内容区底部预留安全区', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(800, 600),
            padding: EdgeInsets.only(bottom: 34),
          ),
          child: Scaffold(
            body: Stack(
              children: [
                SantoFloatingPanel(
                  anchors: const [200, 400],
                  child: Container(key: _contentKey, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final panelRect = tester.getRect(find.byKey(_panelKey));
    final contentRect = tester.getRect(find.byKey(_contentKey));
    expect(panelRect.bottom - contentRect.bottom, 34);
  });

  testWidgets('useSafeArea 为 false 时内容区贴底', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(800, 600),
            padding: EdgeInsets.only(bottom: 34),
          ),
          child: Scaffold(
            body: Stack(
              children: [
                SantoFloatingPanel(
                  anchors: const [200, 400],
                  useSafeArea: false,
                  child: Container(key: _contentKey, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final panelRect = tester.getRect(find.byKey(_panelKey));
    final contentRect = tester.getRect(find.byKey(_contentKey));
    expect(panelRect.bottom - contentRect.bottom, 0);
  });
}
