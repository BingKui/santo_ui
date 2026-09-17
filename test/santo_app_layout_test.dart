import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

Widget _wrap(Widget child) => MaterialApp(home: child);

void main() {
  testWidgets('AppLayout 展示首个菜单对应页面并支持切换', (tester) async {
    var changed = -1;
    await tester.pumpWidget(_wrap(SantoAppLayout(
      onChange: (i) => changed = i,
      items: const <SantoAppLayoutItem>[
        SantoAppLayoutItem(text: '首页', page: Text('首页内容')),
        SantoAppLayoutItem(text: '发现', page: Text('发现内容')),
      ],
    )));

    expect(find.text('首页内容'), findsOneWidget);
    expect(tester.widget<IndexedStack>(find.byType(IndexedStack)).index, 0);

    await tester.tap(find.text('发现'));
    await tester.pumpAndSettle();

    expect(changed, 1);
    expect(tester.widget<IndexedStack>(find.byType(IndexedStack)).index, 1);
  });

  testWidgets('AppLayout 切换菜单后页面状态保留', (tester) async {
    await tester.pumpWidget(_wrap(SantoAppLayout(
      items: <SantoAppLayoutItem>[
        SantoAppLayoutItem(text: '首页', page: _CounterPage()),
        const SantoAppLayoutItem(text: '发现', page: Text('发现内容')),
      ],
    )));

    await tester.tap(find.text('加一'));
    await tester.pump();
    expect(find.text('计数 1'), findsOneWidget);

    await tester.tap(find.text('发现'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('首页'));
    await tester.pumpAndSettle();

    expect(find.text('计数 1'), findsOneWidget);
  });

  testWidgets('AppLayout 悬浮样式把菜单栏浮在内容之上', (tester) async {
    await tester.pumpWidget(_wrap(SantoAppLayout(
      items: const <SantoAppLayoutItem>[
        SantoAppLayoutItem(text: '首页', page: Text('首页内容')),
      ],
    )));

    expect(find.byType(SantoMenuBar), findsOneWidget);
    expect(tester.widget<SantoMenuBar>(find.byType(SantoMenuBar)).style,
        SantoMenuBarStyle.floating);
    expect(tester.widget<Scaffold>(find.byType(Scaffold)).bottomNavigationBar,
        isNull);
  });

  testWidgets('AppLayout 停靠样式用 bottomNavigationBar 承载菜单栏', (tester) async {
    await tester.pumpWidget(_wrap(SantoAppLayout(
      style: SantoMenuBarStyle.docked,
      items: const <SantoAppLayoutItem>[
        SantoAppLayoutItem(text: '首页', page: Text('首页内容')),
      ],
    )));

    expect(
        tester.widget<Scaffold>(find.byType(Scaffold)).bottomNavigationBar,
        isNotNull);
  });

  testWidgets('AppLayout 未配置更多菜单时不展示更多标签', (tester) async {
    await tester.pumpWidget(_wrap(SantoAppLayout(
      items: const <SantoAppLayoutItem>[
        SantoAppLayoutItem(text: '首页', page: Text('首页内容')),
      ],
    )));

    expect(find.text('更多'), findsNothing);
  });

  testWidgets('AppLayout 更多菜单按页面地址跳转命名路由', (tester) async {
    await tester.pumpWidget(MaterialApp(
      routes: <String, WidgetBuilder>{
        '/notice': (_) => const Scaffold(body: Text('通知页面')),
      },
      home: SantoAppLayout(
        moreMenu: const SantoAppLayoutMoreMenu(
          items: <SantoAppLayoutMoreItem>[
            SantoAppLayoutMoreItem(
              label: '通知',
              icon: Icons.notifications_none,
              routeName: '/notice',
            ),
          ],
        ),
        items: const <SantoAppLayoutItem>[
          SantoAppLayoutItem(text: '首页', page: Text('首页内容')),
        ],
      ),
    ));

    expect(find.text('更多'), findsOneWidget);

    await tester.tap(find.text('更多'));
    await tester.pumpAndSettle();
    expect(find.text('通知'), findsOneWidget);

    await tester.tap(find.text('通知'));
    await tester.pumpAndSettle();
    expect(find.text('通知页面'), findsOneWidget);
  });
}

class _CounterPage extends StatefulWidget {
  @override
  State<_CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<_CounterPage> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('计数 $_count'),
          TextButton(
            onPressed: () => setState(() => _count++),
            child: const Text('加一'),
          ),
        ],
      ),
    );
  }
}
