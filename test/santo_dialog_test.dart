import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

/// 六项配置(图标/标题/辅助文案/输入框/两个按钮/右上角关闭)与五个命名构造的冒烟测试
void main() {
  // SantoButton 内置全局防连点(按真实时钟判断 500ms),测试里连续点击会被吞掉
  setUp(SantoMultiClickUtils.reset);

  // SantoButton 会给两个汉字补空格,文本断言一律改用按钮定位
  Finder okButton() => find.byType(SantoButton).last;
  Finder cancelButton() => find.byType(SantoButton).first;

  /// 挂一个宿主页面,在其上弹出 [builder] 返回的弹窗
  Future<void> pumpDialog(
    WidgetTester tester,
    Widget Function(BuildContext dialogContext) builder,
  ) async {
    late BuildContext hostContext;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            hostContext = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    ));
    showDialog<void>(context: hostContext, builder: builder);
    await tester.pumpAndSettle();
  }

  testWidgets('六项配置都渲染:图标/标题/辅助文案/输入框/两个按钮/右上角关闭',
      (WidgetTester tester) async {
    await pumpDialog(
      tester,
      (_) => SantoDialog(
        icon: const Icon(Icons.star, size: 36),
        title: '标题文案',
        message: '辅助文案',
        showInput: true,
        inputHintText: '请输入',
        cancelText: '取消',
        okText: '确定',
        closable: true,
      ),
    );

    expect(find.text('标题文案'), findsOneWidget);
    expect(find.text('辅助文案'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(find.byType(SantoInput), findsOneWidget);
    expect(find.text('请输入'), findsOneWidget);
    expect(find.byType(SantoButton), findsNWidgets(2));
    // 右上角关闭图标
    expect(find.byType(SantoIcon), findsOneWidget);
  });

  testWidgets('预设图标统一用 SantoIcon,不再用图片资源', (WidgetTester tester) async {
    await pumpDialog(
      tester,
      (_) => SantoDialog(
        iconType: SantoDialogIconType.warning,
        title: '存在风险',
        okText: '确定',
      ),
    );

    expect(find.byType(SantoIcon), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('messageMaxHeight 限定文案区高度,超出后在文案区内滚动',
      (WidgetTester tester) async {
    await pumpDialog(
      tester,
      (_) => SantoDialog(
        title: '超长文案',
        message: List<String>.filled(200, '辅助内容信息').join(),
        messageMaxHeight: 300,
        okText: '知道了',
      ),
    );

    final Rect surface = tester.getRect(find.byType(Material).last);
    // 文案再长,弹窗高度也被文案区的最大高度兜住
    expect(surface.height, lessThan(520));
    expect(find.byType(SantoButton), findsOneWidget);
  });

  testWidgets('标题、辅助文案与底部按钮的左右内边距一致', (WidgetTester tester) async {
    // 文案要长到铺满弹窗宽度,才能从文本边缘量出内边距
    const String longTitle =
        '标题文案标题文案标题文案标题文案标题文案标题文案标题文案标题文案标题文案标题文案标题文案标题文案';
    const String longMessage =
        '辅助文案辅助文案辅助文案辅助文案辅助文案辅助文案辅助文案辅助文案'
        '辅助文案辅助文案辅助文案辅助文案辅助文案辅助文案辅助文案辅助文案';
    await pumpDialog(
      tester,
      (_) => SantoDialog(
        title: longTitle,
        message: longMessage,
        cancelText: '取消',
        okText: '确定',
      ),
    );

    final Rect surface = tester.getRect(find.byType(Material).last);
    final Rect title = tester.getRect(find.text(longTitle));
    final Rect message = tester.getRect(find.text(longMessage));
    final Rect cancel = tester.getRect(find.byType(SantoButton).first);

    // 三处横向内边距统一取 hSpacingMd(15)
    expect(title.left - surface.left, closeTo(15, 0.5));
    expect(message.left - surface.left, closeTo(15, 0.5));
    expect(cancel.left - surface.left, closeTo(15, 0.5));
  });

  testWidgets('没有底部按钮时,内容与弹窗底边之间仍有留白', (WidgetTester tester) async {
    await pumpDialog(tester, (_) => SantoDialog(message: '辅助内容信息'));

    final Rect surface = tester.getRect(find.byType(Material).last);
    final Rect message = tester.getRect(find.text('辅助内容信息'));

    expect(find.byType(SantoButton), findsNothing);
    expect(surface.bottom - message.bottom, greaterThan(10));
  });

  testWidgets('点击确定先关闭弹窗再执行回调', (WidgetTester tester) async {
    var tapped = 0;
    await pumpDialog(
      tester,
      (_) => SantoDialog(
        title: '标题文案',
        cancelText: '取消',
        okText: '确定',
        onOk: () => tapped++,
      ),
    );

    await tester.tap(okButton());
    await tester.pumpAndSettle();

    expect(tapped, 1);
    expect(find.text('标题文案'), findsNothing);
  });

  testWidgets('dismissOnActionTap 为 false 时按钮不关闭弹窗', (WidgetTester tester) async {
    var tapped = 0;
    await pumpDialog(
      tester,
      (_) => SantoDialog(
        title: '标题文案',
        cancelText: '取消',
        okText: '确定',
        dismissOnActionTap: false,
        onOk: () => tapped++,
      ),
    );

    await tester.tap(okButton());
    await tester.pumpAndSettle();

    expect(tapped, 1);
    expect(find.text('标题文案'), findsOneWidget);
  });

  testWidgets('右上角关闭与取消都关闭弹窗', (WidgetTester tester) async {
    var closed = 0;
    await pumpDialog(
      tester,
      (_) => SantoDialog(
        title: '标题文案',
        closable: true,
        onClose: () => closed++,
        cancelText: '取消',
        okText: '确定',
      ),
    );

    await tester.tap(find.byType(SantoIcon));
    await tester.pumpAndSettle();

    expect(closed, 1);
    expect(find.text('标题文案'), findsNothing);
  });

  testWidgets('输入框内容可以由确定回调读取', (WidgetTester tester) async {
    final TextEditingController controller = TextEditingController();
    String? submitted;
    await pumpDialog(
      tester,
      (_) => SantoDialog(
        title: '拒绝理由',
        showInput: true,
        inputHintText: '请输入',
        inputMaxLength: 10,
        inputController: controller,
        cancelText: '取消',
        okText: '确定',
        onOk: () => submitted = controller.text,
      ),
    );

    await tester.enterText(find.byType(TextField), '太贵了');
    await tester.tap(okButton());
    await tester.pumpAndSettle();

    expect(submitted, '太贵了');
    controller.dispose();
  });

  testWidgets('单选列表选中后提交回传选中值', (WidgetTester tester) async {
    String? submitted;
    await pumpDialog(
      tester,
      (_) => SantoDialog.singleSelect(
        title: '请选择原因',
        conditions: const <String>['未接通', '号码错误'],
        checkedItem: '未接通',
        submitText: '提交',
        onSubmit: (String? value) => submitted = value,
      ),
    );

    await tester.tap(find.text('号码错误'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(SantoButton));
    await tester.pumpAndSettle();

    expect(submitted, '号码错误');
    expect(find.text('请选择原因'), findsNothing);
  });

  testWidgets('多选列表提交回传勾选项,onSubmit 返回 false 时不关闭', (WidgetTester tester) async {
    List<MultiSelectItem>? submitted;
    await pumpDialog(
      tester,
      (_) => SantoDialog.multiSelect(
        title: '请选择原因',
        conditions: <MultiSelectItem>[
          MultiSelectItem('100', '未接通'),
          MultiSelectItem('101', '号码错误', isChecked: true),
        ],
        submitText: '提交',
        onSubmit: (List<MultiSelectItem> items) {
          submitted = items;
          return false;
        },
      ),
    );

    await tester.tap(find.text('未接通'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(SantoButton));
    await tester.pumpAndSettle();

    expect(submitted?.map((MultiSelectItem e) => e.content).toList(),
        <String>['未接通', '号码错误']);
    // onSubmit 返回 false,弹窗保持打开
    expect(find.text('请选择原因'), findsOneWidget);
  });

  testWidgets('长文本弹窗可以不带提交按钮', (WidgetTester tester) async {
    await pumpDialog(
      tester,
      (_) => SantoDialog.richText(
        title: '服务协议',
        contentText: '正文内容正文内容正文内容',
        isShowOperateWidget: false,
      ),
    );

    expect(find.text('服务协议'), findsOneWidget);
    expect(find.text('正文内容正文内容正文内容'), findsOneWidget);
    expect(find.byType(SantoButton), findsNothing);
  });

  testWidgets('强提示弹窗纵向排布主次按钮', (WidgetTester tester) async {
    var mainTapped = 0;
    await pumpDialog(
      tester,
      (_) => SantoDialog.alert(
        title: '强提示文案',
        message: '这里是文案',
        mainButtonText: '主要按钮',
        secondaryButtonText: '次要信息可点击',
        onMainButton: () => mainTapped++,
      ),
    );

    expect(find.text('次要信息可点击'), findsOneWidget);
    // 主按钮与次按钮都走 SantoButton(次按钮为 text 变体)
    expect(find.byType(SantoButton), findsNWidgets(2));
    await tester.tap(find.byType(SantoButton).first);
    await tester.pumpAndSettle();

    expect(mainTapped, 1);
    expect(find.text('强提示文案'), findsNothing);
  });

  testWidgets('分享弹窗渲染预设与自定义渠道', (WidgetTester tester) async {
    int? tappedChannel;
    await pumpDialog(
      tester,
      (_) => SantoDialog.share(
        title: '分享到',
        shareChannels: const <int>[
          SantoShareItemConstants.shareLink,
          SantoShareItemConstants.shareCustom,
        ],
        getCustomChannelTitle: (int index) => index == 1 ? '自定义' : null,
        getCustomChannelWidget: (int index) =>
            index == 1 ? const Icon(Icons.link) : null,
        onChannelTap: (int channel, int index) => tappedChannel = channel,
      ),
    );

    expect(find.text('分享到'), findsOneWidget);
    expect(find.text('自定义'), findsOneWidget);

    // 渠道的图标区域可点击
    await tester.tap(find.byIcon(Icons.link));
    await tester.pumpAndSettle();

    expect(tappedChannel, SantoShareItemConstants.shareCustom);
  });

  /// 挂一个空页面,返回它的 context
  Future<BuildContext> pumpHost(WidgetTester tester) async {
    late BuildContext hostContext;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            hostContext = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    ));
    return hostContext;
  }

  testWidgets('静态 confirm 点确定回传 true', (WidgetTester tester) async {
    final BuildContext hostContext = await pumpHost(tester);

    bool? result;
    SantoDialog.confirm(hostContext, title: '提示', message: '确认删除?')
        .then((bool? value) => result = value);
    await tester.pumpAndSettle();
    await tester.tap(okButton());
    await tester.pumpAndSettle();

    expect(result, isTrue);
  });

  testWidgets('静态 confirm 点取消回传 false', (WidgetTester tester) async {
    final BuildContext hostContext = await pumpHost(tester);

    bool? result;
    SantoDialog.confirm(hostContext, title: '提示', message: '确认删除?')
        .then((bool? value) => result = value);
    await tester.pumpAndSettle();
    await tester.tap(cancelButton());
    await tester.pumpAndSettle();

    expect(result, isFalse);
  });

  testWidgets('show / dismiss 按 tag 精确关闭浮层', (WidgetTester tester) async {
    late BuildContext hostContext;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            hostContext = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    ));

    SantoDialog.show(
      context: hostContext,
      tag: 'AA',
      builder: (_) => const Text('浮层 AA'),
    );
    SantoDialog.show(
      context: hostContext,
      builder: (_) => const Text('浮层 BB'),
    );
    await tester.pumpAndSettle();
    expect(find.text('浮层 AA'), findsOneWidget);
    expect(find.text('浮层 BB'), findsOneWidget);

    // 只关掉 tag 为 AA 的那个,默认 tag 的浮层不受影响
    SantoDialog.dismiss(context: hostContext, tag: 'AA');
    await tester.pumpAndSettle();
    expect(find.text('浮层 AA'), findsNothing);
    expect(find.text('浮层 BB'), findsOneWidget);

    SantoDialog.dismiss(context: hostContext);
    await tester.pumpAndSettle();
    expect(find.text('浮层 BB'), findsNothing);
  });
}
