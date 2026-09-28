import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

/// 1x1 透明 PNG，用于校验 base64 / Data URI 头像的解析
const String _pngBase64 =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAC0lEQVR4nGNgAAIAAAUAAXpeqz8AAAAASUVORK5CYII=';

Widget _host(Widget child) => MaterialApp(home: Scaffold(body: child));

ImageProvider? _providerOf(WidgetTester tester) {
  final Finder finder = find.byType(Image);
  if (finder.evaluate().isEmpty) return null;
  return tester.widget<Image>(finder.first).image;
}

void main() {
  testWidgets('http(s) 头像走网络图', (WidgetTester tester) async {
    await tester.pumpWidget(_host(
      const SantoAvatar(imageUrl: 'https://example.com/a.png', text: '张'),
    ));
    expect(_providerOf(tester), isA<NetworkImage>());
  });

  testWidgets('Data URI 头像解码为内存图', (WidgetTester tester) async {
    await tester.pumpWidget(_host(
      SantoAvatar(imageUrl: 'data:image/png;base64,$_pngBase64', text: '张'),
    ));
    expect(_providerOf(tester), isA<MemoryImage>());
  });

  testWidgets('纯 base64 头像解码为内存图', (WidgetTester tester) async {
    await tester.pumpWidget(_host(
      SantoAvatar(imageUrl: _pngBase64, text: '张'),
    ));
    expect(_providerOf(tester), isA<MemoryImage>());
  });

  testWidgets('地址为空时降级为文字头像', (WidgetTester tester) async {
    await tester.pumpWidget(_host(
      const SantoAvatar(imageUrl: '', text: '张'),
    ));
    expect(find.byType(Image), findsNothing);
    expect(find.text('张'), findsOneWidget);
  });

  testWidgets('地址无法解码时降级为文字头像', (WidgetTester tester) async {
    await tester.pumpWidget(_host(
      const SantoAvatar(imageUrl: '!!!not-base64!!!', text: '张'),
    ));
    expect(find.byType(Image), findsNothing);
    expect(find.text('张'), findsOneWidget);
  });
}
