import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('SantoShare shows title, channels and cancel button',
      (tester) async {
    await tester.pumpWidget(wrap(SantoShare(
      mainTitle: '分享到',
      cancelTitle: '取消',
      firstShareChannels: [
        SantoShareItem(
          SantoShareItemConstants.shareCustom,
          customTitle: '渠道一',
          customImage: const Icon(Icons.share),
        ),
        SantoShareItem(
          SantoShareItemConstants.shareCustom,
          customTitle: '渠道二',
          customImage: const Icon(Icons.link),
        ),
      ],
    )));

    expect(find.text('分享到'), findsOneWidget);
    expect(find.text('渠道一'), findsOneWidget);
    expect(find.text('渠道二'), findsOneWidget);
    expect(find.text('取消'), findsOneWidget);
  });

  testWidgets('SantoShare triggers callback with section and index',
      (tester) async {
    int? tappedSection;
    int? tappedIndex;
    await tester.pumpWidget(wrap(SantoShare(
      mainTitle: '分享到',
      firstShareChannels: [
        SantoShareItem(
          SantoShareItemConstants.shareCustom,
          customTitle: '第一行渠道',
          customImage: const Icon(Icons.share),
        ),
      ],
      secondShareChannels: [
        SantoShareItem(
          SantoShareItemConstants.shareCustom,
          customTitle: '第二行渠道',
          customImage: const Icon(Icons.link),
        ),
      ],
      clickCallBack: (section, index, shareItem) {
        tappedSection = section;
        tappedIndex = index;
      },
    )));

    await tester.tap(find.text('第二行渠道'));
    expect(tappedSection, 1);
    expect(tappedIndex, 0);
  });

  testWidgets('SantoShare interceptor blocks the callback', (tester) async {
    var called = false;
    await tester.pumpWidget(wrap(SantoShare(
      mainTitle: '分享到',
      firstShareChannels: [
        SantoShareItem(
          SantoShareItemConstants.shareCustom,
          customTitle: '被拦截渠道',
          customImage: const Icon(Icons.share),
        ),
      ],
      clickInterceptor: (section, index, shareItem) => true,
      clickCallBack: (section, index, shareItem) => called = true,
    )));

    await tester.tap(find.text('被拦截渠道'));
    expect(called, isFalse);
  });
}
