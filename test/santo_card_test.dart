import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

Widget _host(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: Padding(padding: const EdgeInsets.all(15), child: child),
      ),
    ),
  );
}

void main() {
  final commonConfig =
      SantoThemeConfigurator.instance.getConfig().commonConfig;

  testWidgets('只传 child 时是纯容器,不渲染头部与分割线', (tester) async {
    await tester.pumpWidget(_host(
      const SantoCard(
        padding: EdgeInsets.all(15),
        child: Text('内容'),
      ),
    ));

    expect(find.text('内容'), findsOneWidget);
    expect(find.byType(SantoCardMeta), findsNothing);

    final decoration = tester
        .widget<Container>(find.descendant(
          of: find.byType(SantoCard),
          matching: find.byType(Container),
        ))
        .decoration! as BoxDecoration;
    expect(decoration.color, commonConfig.fillBase);
    expect(decoration.color, Colors.white);
    expect(
      decoration.borderRadius,
      BorderRadius.circular(12),
    );
  });

  testWidgets('title 与 extra 渲染在头部,内容区取主题内边距', (tester) async {
    await tester.pumpWidget(_host(
      const SantoCard(
        title: '卡片标题',
        extra: Text('操作'),
        child: Text('内容'),
      ),
    ));

    expect(find.text('卡片标题'), findsOneWidget);
    expect(find.text('操作'), findsOneWidget);
    expect(find.text('内容'), findsOneWidget);

    // 标题在内容上方
    expect(
      tester.getTopLeft(find.text('卡片标题')).dy,
      lessThan(tester.getTopLeft(find.text('内容')).dy),
    );

    // 未显式传 padding 时,标题与内容同一左边界(都取 hSpacingMd),且比卡片边缘内缩
    expect(
      tester.getTopLeft(find.text('内容')).dx,
      tester.getTopLeft(find.text('卡片标题')).dx,
    );
    expect(
      tester.getTopLeft(find.text('内容')).dx,
      greaterThan(
        tester.getTopLeft(find.byType(SantoCard)).dx + commonConfig.hSpacingMd,
      ),
    );
  });

  testWidgets('titleWidget 优先于 title', (tester) async {
    await tester.pumpWidget(_host(
      SantoCard(
        title: '文案标题',
        titleWidget: const Text('组件标题'),
        child: const Text('内容'),
      ),
    ));

    expect(find.text('组件标题'), findsOneWidget);
    expect(find.text('文案标题'), findsNothing);
  });

  testWidgets('meta 渲染头像、标题与描述,并在内容之上', (tester) async {
    await tester.pumpWidget(_host(
      const SantoCard(
        meta: SantoCardMeta(
          avatar: SantoAvatar(text: 'S', size: 40),
          title: '元信息标题',
          description: '元信息描述',
        ),
        child: Text('内容'),
      ),
    ));

    expect(find.byType(SantoAvatar), findsOneWidget);
    expect(find.text('元信息标题'), findsOneWidget);
    expect(find.text('元信息描述'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('元信息描述')).dy,
      lessThan(tester.getTopLeft(find.text('内容')).dy),
    );
  });

  testWidgets('显式传 padding 时不被主题内边距覆盖', (tester) async {
    await tester.pumpWidget(_host(
      const SantoCard(
        title: '卡片标题',
        padding: EdgeInsets.all(6),
        child: Text('内容'),
      ),
    ));

    // 显式 padding(6) 生效,未被主题的 hSpacingMd 覆盖
    final double inset =
        tester.getTopLeft(find.text('内容')).dx -
            tester.getTopLeft(find.byType(SantoCard)).dx;
    expect(inset, lessThan(commonConfig.hSpacingMd));
    expect(inset, greaterThan(0));
  });
}
