import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

Widget _host(Widget child) =>
    MaterialApp(home: Scaffold(body: Center(child: child)));

List<SantoAvatar> _avatars(WidgetTester tester) =>
    tester.widgetList<SantoAvatar>(find.byType(SantoAvatar)).toList();

void main() {
  testWidgets('没有成员时回退群图标', (WidgetTester tester) async {
    await tester.pumpWidget(_host(
      const SantoGroupAvatar(items: <SantoGroupAvatarItem>[]),
    ));
    expect(find.byType(SantoAvatar), findsNothing);
    expect(find.byType(SantoIcon), findsOneWidget);
  });

  testWidgets('只有 1 个成员时整格展示，尺寸等于外框', (WidgetTester tester) async {
    await tester.pumpWidget(_host(
      const SantoGroupAvatar(
        size: 48,
        items: <SantoGroupAvatarItem>[SantoGroupAvatarItem(text: '张')],
      ),
    ));
    final List<SantoAvatar> avatars = _avatars(tester);
    expect(avatars.length, 1);
    expect(avatars.first.size, 48);
    expect(find.text('张'), findsOneWidget);
  });

  testWidgets('2 个成员按 2 列平铺', (WidgetTester tester) async {
    await tester.pumpWidget(_host(
      const SantoGroupAvatar(
        size: 48,
        items: <SantoGroupAvatarItem>[
          SantoGroupAvatarItem(text: '张'),
          SantoGroupAvatarItem(text: '李'),
        ],
      ),
    ));
    // cell = floor((48 - 2*2 - 1) / 2) = 21
    final List<SantoAvatar> avatars = _avatars(tester);
    expect(avatars.length, 2);
    for (final SantoAvatar avatar in avatars) {
      expect(avatar.size, 21);
    }
  });

  testWidgets('5 个成员按 3 列平铺', (WidgetTester tester) async {
    await tester.pumpWidget(_host(
      SantoGroupAvatar(
        size: 48,
        items: List<SantoGroupAvatarItem>.generate(
          5,
          (int i) => SantoGroupAvatarItem(text: '$i'),
        ),
      ),
    ));
    // cell = floor((48 - 2*2 - 2) / 3) = 14
    final List<SantoAvatar> avatars = _avatars(tester);
    expect(avatars.length, 5);
    for (final SantoAvatar avatar in avatars) {
      expect(avatar.size, 14);
    }
  });

  testWidgets('超过 maxCount 只展示前 N 个', (WidgetTester tester) async {
    await tester.pumpWidget(_host(
      SantoGroupAvatar(
        size: 48,
        items: List<SantoGroupAvatarItem>.generate(
          12,
          (int i) => SantoGroupAvatarItem(text: '${i % 10}'),
        ),
      ),
    ));
    expect(_avatars(tester).length, 9);
  });

  testWidgets('有图片地址时渲染图片，只有文字时渲染首字', (WidgetTester tester) async {
    await tester.pumpWidget(_host(
      const SantoGroupAvatar(
        size: 48,
        items: <SantoGroupAvatarItem>[
          SantoGroupAvatarItem(imageUrl: 'https://example.com/a.png', text: '张'),
          SantoGroupAvatarItem(text: '李'),
        ],
      ),
    ));
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('李'), findsOneWidget);
  });
}
