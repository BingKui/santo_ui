import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:santo_ui/santo_ui.dart';

/// SantoAppBar 导航栏示例
///
/// 导航栏在示例里以行内方式渲染(不是页面自身的 appBar),因此统一做了三件事:
/// 1. 去掉顶部安全区,否则栏高会额外算进状态栏高度;
/// 2. 搜索框关掉 autoFocus(默认 true),同一页多个搜索框会互相抢焦点;
/// 3. 深色栏指定 `systemOverlayStyle`,行内演示不应该改写页面状态栏样式
class AppBarExample extends StatefulWidget {
  const AppBarExample({super.key});

  @override
  State<AppBarExample> createState() => _AppBarExampleState();
}

class _AppBarExampleState extends State<AppBarExample> {
  /// 浅色导航栏上标题模块的选中/未选中样式
  static const TextStyle _titleSelected = TextStyle(
    fontSize: 18,
    color: Color(0xFF17233D),
    fontWeight: FontWeight.w600,
  );

  static const TextStyle _titleUnselected = TextStyle(
    fontSize: 18,
    color: Color(0xFF808695),
    fontWeight: FontWeight.w600,
  );

  /// 各演示的模块下标独立持有,避免点一个演示影响另一个
  int _moduleIndex = 0;
  int _scrollTitleIndex = 0;

  /// 浮层锚点(每个演示各自持有,GlobalKey 不能跨 widget 复用)
  final GlobalKey _leadDarkKey = GlobalKey();
  final GlobalKey _leadLightKey = GlobalKey();
  final GlobalKey _actionKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'AppBar 导航栏',
      children: <Widget>[
        ExampleIntro('appbar'),
        _buildBasicSection(),
        _buildTitleDropdownSection(),
        _buildTitleTagSection(),
        _buildTitleModulesSection(),
        _buildCustomLeadingSection(),
        _buildDoubleLeadingSection(),
        _buildTextActionSection(),
        _buildIconActionsSection(),
        _buildDarkSection(),
        _buildCustomBackgroundSection(),
        _buildSearchBarSection(),
        _buildSearchBarLeadingSection(),
        _buildSearchResultSection(),
      ],
    );
  }

  /// 默认返回按钮 + 居中标题
  Widget _buildBasicSection() {
    return SantoSection(
      title: '基础用法',
      description: '默认展示返回按钮与居中标题,title 直接传字符串',
      contentPadding: EdgeInsets.zero,
      child: _barStage(<PreferredSizeWidget>[SantoAppBar(title: '标题名称')]),
    );
  }

  /// title 传 Widget:标题右侧跟一个下拉箭头
  Widget _buildTitleDropdownSection() {
    return SantoSection(
      title: '标题带下拉',
      description: 'title 传 Widget,标题右侧放一个 navArrowDown 图标',
      contentPadding: EdgeInsets.zero,
      child: _barStage(<PreferredSizeWidget>[
        SantoAppBar(
          themeData: SantoAppBarConfig.light(),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text('标题名称', style: _titleSelected),
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: SantoIcon(SantoIcons.navArrowDown, size: 20),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  /// 标题带状态标签
  Widget _buildTitleTagSection() {
    return SantoSection(
      title: '标题带标签',
      description: '自定义 title 内放一个浅底标签,如「住宅」',
      contentPadding: EdgeInsets.zero,
      child: _barStage(<PreferredSizeWidget>[
        SantoAppBar(
          themeData: SantoAppBarConfig.light(),
          leading: _demoLeading(
            child: const SantoIcon(SantoIcons.search, size: 20),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text('标题名称', style: _titleSelected),
              Container(
                height: 17,
                margin: const EdgeInsets.only(left: 6),
                padding: const EdgeInsets.only(left: 3, right: 3),
                decoration: BoxDecoration(
                  color: const Color(0xff8E8E8E).withOpacity(0.15),
                ),
                child: const Center(
                  child: Text(
                    '住宅',
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontSize: 11,
                      height: 1,
                      color: Color(0xFF17233D),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  /// 标题模块切换:固定模块 + 标题区横向滚动
  Widget _buildTitleModulesSection() {
    return SantoSection(
      title: '多模块标题切换',
      description: 'title 传可点击模块,点击切换选中态;第二例标题区横向滚动',
      contentPadding: EdgeInsets.zero,
      child: _barStage(<PreferredSizeWidget>[
        SantoAppBar(
          themeData: SantoAppBarConfig.light(),
          leading: _demoLeading(
            child: const SantoIcon(SantoIcons.search, size: 20),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildModule('二手', 0),
              const SizedBox(width: 24),
              _buildModule('新房', 1),
            ],
          ),
          actions: SantoIconAction(
            icon: SantoIcons.plus,
            iconPressed: () => SantoToast.show('点击了右上角的+号', context),
          ),
        ),
        SantoAppBar(
          themeData: SantoAppBarConfig.light(),
          automaticallyImplyLeading: false,
          leading: _demoLeading(
            child: const SantoIcon(SantoIcons.search, size: 20),
          ),
          title: SizedBox(
            height: 44,
            child: ListView.separated(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 24, right: 12),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => setState(() => _scrollTitleIndex = index),
                  child: Center(
                    child: Text(
                      '标题',
                      style: index == _scrollTitleIndex
                          ? _titleSelected
                          : _titleUnselected,
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(width: 24);
              },
            ),
          ),
          actions: SantoIconAction(icon: SantoIcons.plus, iconPressed: () {}),
        ),
      ]),
    );
  }

  /// 演示用左侧操作
  ///
  /// 包一层 [SantoBackLeading]:它给图标固定 32×32 的盒子,SantoIcon 直接放到
  /// leading 槽位里会被 47×44 的紧约束撑开(BoxFit.contain 跟着放大);
  /// iconPressed 改成 toast,避免点了把示例页 pop 掉
  SantoBackLeading _demoLeading({Widget? child, String label = '返回'}) {
    return SantoBackLeading(
      child: child,
      iconPressed: () => SantoToast.show('点击了$label', context),
    );
  }

  /// 标题模块(点击切换选中态)
  Widget _buildModule(String text, int index) {
    return GestureDetector(
      onTap: () => setState(() => _moduleIndex = index),
      child: Text(
        text,
        style: _moduleIndex == index ? _titleSelected : _titleUnselected,
      ),
    );
  }

  /// leading 传任意 Widget
  Widget _buildCustomLeadingSection() {
    return SantoSection(
      title: '自定义 leading',
      description: 'leading 可传任意 Widget,如单独一个 SantoIcon',
      contentPadding: EdgeInsets.zero,
      child: _barStage(<PreferredSizeWidget>[
        SantoAppBar(
          themeData: SantoAppBarConfig.light(),
          leading: _demoLeading(
            child: const SantoIcon(SantoIcons.search, size: 20),
          ),
          title: '标题名称',
        ),
      ]),
    );
  }

  /// 左侧两个操作区
  Widget _buildDoubleLeadingSection() {
    return SantoSection(
      title: '双返回操作',
      description: 'SantoDoubleLeading 在左侧放两个操作区,标题仍居中',
      contentPadding: EdgeInsets.zero,
      child: _barStage(<PreferredSizeWidget>[
        SantoAppBar(
          themeData: SantoAppBarConfig.light(),
          title: '标题名称',
          leading: SantoDoubleLeading(
            first: _demoLeading(),
            second: _demoLeading(
              child: const SantoIcon(SantoIcons.xmark, size: 20),
              label: '关闭',
            ),
          ),
          actions: SantoTextAction('文本按钮'),
        ),
      ]),
    );
  }

  /// 文字操作 + 浮层菜单
  Widget _buildTextActionSection() {
    return SantoSection(
      title: '文字操作与浮层',
      description: 'SantoTextAction 承载文字操作,点击弹 SantoPopupListWindow',
      contentPadding: EdgeInsets.zero,
      child: _barStage(<PreferredSizeWidget>[
        SantoAppBar(
          title: '标题名称',
          leading: SantoDoubleLeading(
            first: _demoLeading(),
            second: _demoLeading(
              child: const SantoIcon(SantoIcons.xmark, size: 20),
              label: '关闭',
            ),
          ),
          actions: SantoTextAction(
            '弹出菜单',
            key: _actionKey,
            iconPressed: () {
              SantoPopupListWindow.showPopListWindow(
                context,
                _actionKey,
                offset: 10,
                data: const <String>['aaaa', 'bbbbb'],
                onItemClick: (int index, String item) {
                  SantoDialog.confirm(
                    context,
                    cancelText: 'cancel',
                    okText: 'confirm',
                    message: 'message',
                  );
                  return true;
                },
                onDismiss: () => SantoToast.show('onDismiss', context),
              );
            },
          ),
        ),
      ]),
    );
  }

  /// 右侧多个图标操作
  Widget _buildIconActionsSection() {
    return SantoSection(
      title: '多个图标操作',
      description: 'actions 传 List,右侧多个 SantoIconAction 自动加间距',
      contentPadding: EdgeInsets.zero,
      child: _barStage(<PreferredSizeWidget>[
        SantoAppBar(
          themeData: SantoAppBarConfig.light(),
          automaticallyImplyLeading: true,
          title: '天通苑天通苑天通苑天通苑天通苑天通苑天通苑天通苑天通苑',
          actions: <Widget>[
            SantoIconAction(icon: SantoIcons.shareIos, iconPressed: () {}),
            SantoIconAction(icon: SantoIcons.group, iconPressed: () {}),
            SantoIconAction(icon: SantoIcons.heart, iconPressed: () {}),
          ],
        ),
        SantoAppBar(
          themeData: SantoAppBarConfig.light(),
          automaticallyImplyLeading: true,
          actions: <Widget>[
            SantoIconAction(icon: SantoIcons.chatLines, iconPressed: () {}),
            SantoIconAction(icon: SantoIcons.shareIos, iconPressed: () {}),
            SantoIconAction(icon: SantoIcons.group, iconPressed: () {}),
            SantoIconAction(icon: SantoIcons.heart, iconPressed: () {}),
          ],
        ),
      ]),
    );
  }

  /// 深色导航栏
  Widget _buildDarkSection() {
    return SantoSection(
      title: '深色导航栏',
      description: 'themeData 传 SantoAppBarConfig.dark(),标题与图标转白',
      contentPadding: EdgeInsets.zero,
      child: _barStage(<PreferredSizeWidget>[
        SantoAppBar(
          themeData: SantoAppBarConfig.dark(),
          // 行内演示不改写页面状态栏样式
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          title: '标题名称',
          actions: <Widget>[
            SantoIconAction(icon: SantoIcons.shareIos, iconPressed: () {}),
            SantoIconAction(icon: SantoIcons.heart, iconPressed: () {}),
          ],
        ),
      ]),
    );
  }

  /// 自定义背景色的全屏导航栏
  Widget _buildCustomBackgroundSection() {
    return SantoSection(
      title: '自定义背景色',
      description: '进入单页查看浅色背景的黑色状态栏图标与深色背景的白色状态栏图标',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SantoButton(
            text: '浅色背景',
            onTap: () => _openThemeExample(
              title: '浅色导航栏',
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          SantoButton(
            text: '深色背景',
            type: SantoButtonType.primary,
            onTap: () => _openThemeExample(
              title: '深色导航栏',
              backgroundColor: const Color(0xFF17233D),
            ),
          ),
        ],
      ),
    );
  }

  void _openThemeExample({
    required String title,
    required Color backgroundColor,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _AppBarThemeExamplePage(
          title: title,
          backgroundColor: backgroundColor,
        ),
      ),
    );
  }

  /// 搜索栏
  Widget _buildSearchBarSection() {
    return SantoSection(
      title: '搜索栏',
      description: 'SantoSearchAppbar 承载搜索输入,showDivider 控制左侧分割线',
      contentPadding: EdgeInsets.zero,
      child: _barStage(<PreferredSizeWidget>[
        SantoSearchAppbar(
          showDivider: false,
          autoFocus: false,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          searchBarInputChangeCallback: (String input) =>
              SantoToast.show(input, context),
          searchBarInputSubmitCallback: (String input) =>
              SantoToast.show(input, context),
          dismissClickCallback: (
            TextEditingController controller,
            VoidCallback update,
          ) => SantoToast.show('点击了取消', context),
        ),
      ]),
    );
  }

  /// 搜索栏 + 左侧业务类型下拉
  Widget _buildSearchBarLeadingSection() {
    return SantoSection(
      title: '搜索栏·自定义左侧',
      description: 'leading 放业务类型下拉,点击弹 SantoPopupListWindow 选项',
      contentPadding: EdgeInsets.zero,
      child: _barStage(<PreferredSizeWidget>[
        SantoSearchAppbar(
          autoFocus: false,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          leading: _buildLeadType(Colors.white, _leadDarkKey),
          leadClickCallback: (
            TextEditingController controller,
            VoidCallback update,
          ) => _showLeadPopList(_leadDarkKey),
          searchBarInputChangeCallback: (String input) =>
              SantoToast.show(input, context),
        ),
        SantoSearchAppbar(
          themeData: SantoAppBarConfig.light(),
          autoFocus: false,
          leading: _buildLeadType(const Color(0xFF17233D), _leadLightKey),
          leadClickCallback: (
            TextEditingController controller,
            VoidCallback update,
          ) => _showLeadPopList(_leadLightKey),
          searchBarInputSubmitCallback: (String input) =>
              SantoToast.show(input, context),
        ),
      ]),
    );
  }

  /// 搜索结果栏
  Widget _buildSearchResultSection() {
    return SantoSection(
      title: '搜索结果样式',
      description: 'buildSearchResultStyle 构建「返回 + 分割线 + 结果标题」栏',
      contentPadding: EdgeInsets.zero,
      child: _barStage(<PreferredSizeWidget>[
        SantoAppBar.buildSearchResultStyle(
          title: '天通苑天通苑天通苑天通苑天通苑天通苑天通苑天通苑天通苑',
          showLeadingDivider: false,
        ),
      ]),
    );
  }

  /// 左侧业务类型(文字 + 下拉箭头)
  Widget _buildLeadType(Color color, Key key) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        key: key,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('类型1', style: TextStyle(color: color, height: 1, fontSize: 16)),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: SantoIcon(SantoIcons.navArrowDown, size: 12, color: color),
          ),
        ],
      ),
    );
  }

  void _showLeadPopList(GlobalKey anchor) {
    SantoPopupListWindow.showPopListWindow(
      context,
      anchor,
      data: const <String>['aaaa', 'bbbbb'],
      onItemClick: (int index, String data) {
        SantoDialog.confirm(
          context,
          cancelText: 'cancel',
          okText: 'confirm',
          message: 'message',
        );
        return true;
      },
      onDismiss: () => SantoToast.show('onDismiss', context),
    );
  }

  /// 演示舞台:页面底色铺底 + 若干导航栏
  ///
  /// 导航栏自身需要有限高度约束才能构建(否则内部 Column 报无界高度),
  /// 高度取 preferredSize;并去掉顶部安全区,避免把状态栏高度算进栏高
  Widget _barStage(List<PreferredSizeWidget> bars) {
    final common = SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Container(
      color: common.fillBody,
      padding: EdgeInsets.symmetric(vertical: common.gapMd),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (int i = 0; i < bars.length; i++) ...<Widget>[
            SizedBox(
              height: bars[i].preferredSize.height,
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: bars[i],
              ),
            ),
            if (i != bars.length - 1) SizedBox(height: common.gapMd),
          ],
        ],
      ),
    );
  }
}

class _AppBarThemeExamplePage extends StatelessWidget {
  const _AppBarThemeExamplePage({
    required this.title,
    required this.backgroundColor,
  });

  final String title;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(
        title: title,
        backgroundColor: backgroundColor,
        actions: <Widget>[
          SantoIconAction(icon: SantoIcons.shareIos, iconPressed: () {}),
        ],
      ),
      body: const ColoredBox(color: Color(0xFFF5F5F5)),
    );
  }
}
