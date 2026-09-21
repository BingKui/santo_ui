import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// SantoPageLayout 页面布局示例
class PageLayoutExample extends StatelessWidget {
  const PageLayoutExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      // 传 appBar 接管导航栏;只传 title 时 PageLayout 会用 SantoAppBar 构建
      appBar: SantoAppBar(
        title: 'PageLayout 页面布局',
        actions: SantoTextAction(
          '操作',
          iconPressed: () => SantoToast.show('点击了导航栏操作', context),
        ),
      ),
      children: <Widget>[
        ExampleIntro('layout'),
        SantoSpace(
          direction: SantoSpaceDirection.vertical,
          customSize: 12,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SantoSection(
              title: '页面导航栏',
              description:
                  'appBar 可传任意导航栏,只传 title 时用 SantoAppBar 构建,都不传则不显示导航栏',
              child: _card('示例页传入的是「标题 + 右侧文字操作」的自定义导航栏'),
            ),
            SantoSection(
              title: '标题下方固定区域',
              description:
                  'header 放在标题与内容之间且不随内容滚动,撑满宽度、高度自适应、不加内边距,支持搜索框/Tab/筛选/步骤条/日历等',
              child: SantoButton(
                text: 'Header 固定区域示例',
                block: true,
                onTap: () => _push(context, const PageLayoutHeaderExample()),
              ),
            ),
            SantoSection(
              title: '下拉刷新',
              description: 'enableRefresh 开启后内置滚动容器由 SantoRefresh 承载',
              child: SantoButton(
                text: '下拉刷新示例',
                block: true,
                onTap: () => _push(context, const PageLayoutRefreshExample()),
              ),
            ),
            SantoSection(
              title: '导航栏透传配置',
              description:
                  '只传 title 时可通过 appBarBackgroundColor / appBarElevation 等参数透传导航栏配置',
              child: SantoButton(
                text: '深色导航栏示例',
                block: true,
                onTap: () => _push(context, const PageLayoutAppBarExample()),
              ),
            ),
            SantoSection(
              title: '内容滚动与内边距',
              description:
                  '内容超出屏幕时由 PageLayout 提供滚动容器,padding 默认四边 15,可用 padding 参数覆盖',
              child: SantoButton(
                text: '自定义内边距示例',
                block: true,
                onTap: () => _push(context, const PageLayoutPaddingExample()),
              ),
            ),
            SantoSection(
              title: '底部安全区域',
              description:
                  'bottomSafeArea 默认 true 预留 Home Indicator 区域,bottomInset 可在其之上叠加留白',
              child: _card('滚动到底部时,最后一张卡片不会被底部安全区域遮住'),
            ),
          ],
        ),
      ],
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (BuildContext context) => page),
    );
  }

  Widget _card(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }
}

/// 标题下方固定区域示例:header 放各类组件
class PageLayoutHeaderExample extends StatelessWidget {
  const PageLayoutHeaderExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'Header 固定区域',
      children: <Widget>[
        ExampleIntro('layout'),
        SantoSpace(
          direction: SantoSpaceDirection.vertical,
          customSize: 12,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _item(context, '搜索框', const HeaderSearchExample()),
            _item(context, 'Tab 切换', const HeaderTabExample()),
            _item(context, 'Selection 筛选', const HeaderSelectionExample()),
            _item(context, 'DropdownMenu 下拉菜单', const HeaderDropdownMenuExample()),
            _item(context, '输入框', const HeaderInputExample()),
            _item(context, 'Step 步骤条', const HeaderStepsExample()),
            _item(context, 'Calendar 日历', const HeaderCalendarExample()),
          ],
        ),
      ],
    );
  }

  Widget _item(BuildContext context, String text, Widget page) {
    return SantoButton(
      text: text,
      block: true,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (BuildContext context) => page),
      ),
    );
  }
}

/// header 放搜索框:输入关键字过滤内容
class HeaderSearchExample extends StatefulWidget {
  const HeaderSearchExample({Key? key}) : super(key: key);

  @override
  State<HeaderSearchExample> createState() => _HeaderSearchExampleState();
}

class _HeaderSearchExampleState extends State<HeaderSearchExample> {
  String _keyword = '';

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'Header 固定区域',
      header: SantoSearchText(
        hintText: '搜索卡片标题',
        onTextChange: (text) => setState(() => _keyword = text),
      ),
      children: <Widget>[
        SantoSection(
          title: '搜索框固定在标题下方',
          description: 'header 不随内容滚动,滚动内容时搜索框始终可见',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (final text in _filteredTexts) _card(text),
              if (_filteredTexts.isEmpty) _card('没有匹配「$_keyword」的内容'),
            ],
          ),
        ),
      ],
    );
  }

  List<String> get _filteredTexts => <String>[
        '订单卡片 可搜索',
        '用户卡片 可搜索',
        '商品卡片 可搜索',
        '物流卡片',
      ]
          .where((text) => _keyword.isEmpty || text.contains(_keyword))
          .toList();

  Widget _card(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }
}

/// header 放 Tab 切换:切换后内容跟随刷新
class HeaderTabExample extends StatefulWidget {
  const HeaderTabExample({Key? key}) : super(key: key);

  @override
  State<HeaderTabExample> createState() => _HeaderTabExampleState();
}

class _HeaderTabExampleState extends State<HeaderTabExample>
    with TickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: _tabs.length, vsync: this);

  static const List<String> _tabs = <String>['全部', '进行中', '已完成'];

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'Header 固定区域',
      header: SantoTabBar(
        controller: _tabController,
        tabs: <BadgeTab>[
          for (final text in _tabs) BadgeTab(text: text),
        ],
        onTap: (state, index) => setState(() {}),
      ),
      children: <Widget>[
        SantoSection(
          title: 'TabBar 固定在标题下方',
          description: 'header 不随内容滚动,切换 Tab 后内容区跟随刷新',
          child: _card('当前选中:「${_tabs[_tabController.index]}」'),
        ),
      ],
    );
  }

  Widget _card(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }
}

/// header 放 Selection 筛选
class HeaderSelectionExample extends StatefulWidget {
  const HeaderSelectionExample({Key? key}) : super(key: key);

  @override
  State<HeaderSelectionExample> createState() => _HeaderSelectionExampleState();
}

class _HeaderSelectionExampleState extends State<HeaderSelectionExample> {
  String _selected = '未选择';

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'Header 固定区域',
      header: Container(
        color: Colors.white,
        child: SantoSimpleSelection.radio(
          menuName: '订单状态',
          items: <ItemEntity>[
            ItemEntity(name: '待付款', value: 'unpaid'),
            ItemEntity(name: '待发货', value: 'unshipped'),
            ItemEntity(name: '已完成', value: 'done'),
          ],
          onSimpleSelectionChanged: (items) {
            setState(() {
              _selected = items.isEmpty ? '未选择' : items.first.name;
            });
          },
        ),
      ),
      children: <Widget>[
        SantoSection(
          title: 'Selection 筛选固定在标题下方',
          description: '点击 header 中的筛选菜单展开选项,选中后内容区跟随刷新',
          child: _card('当前筛选:「$_selected」'),
        ),
      ],
    );
  }

  Widget _card(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }
}

/// header 放 DropdownMenu 下拉菜单
class HeaderDropdownMenuExample extends StatefulWidget {
  const HeaderDropdownMenuExample({Key? key}) : super(key: key);

  @override
  State<HeaderDropdownMenuExample> createState() =>
      _HeaderDropdownMenuExampleState();
}

class _HeaderDropdownMenuExampleState extends State<HeaderDropdownMenuExample> {
  String? _sortValue;
  String? _statusValue;

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'Header 固定区域',
      header: Container(
        color: Colors.white,
        child: SantoDropdownMenu(
          children: <SantoDropdownMenuItem>[
            SantoDropdownMenuItem(
              title: '排序',
              options: const <SantoDropdownMenuOption>[
                SantoDropdownMenuOption(label: '默认排序', value: 'default'),
                SantoDropdownMenuOption(label: '价格从低到高', value: 'price_asc'),
                SantoDropdownMenuOption(label: '价格从高到低', value: 'price_desc'),
              ],
              selectedValue: _sortValue,
              onChanged: (value) => setState(() => _sortValue = value),
            ),
            SantoDropdownMenuItem(
              title: '状态',
              options: const <SantoDropdownMenuOption>[
                SantoDropdownMenuOption(label: '全部', value: 'all'),
                SantoDropdownMenuOption(label: '进行中', value: 'doing'),
                SantoDropdownMenuOption(label: '已完成', value: 'done'),
              ],
              selectedValue: _statusValue,
              onChanged: (value) => setState(() => _statusValue = value),
            ),
          ],
        ),
      ),
      children: <Widget>[
        SantoSection(
          title: 'DropdownMenu 固定在标题下方',
          description: '点击 header 中的菜单项展开下拉选项,选中后内容区跟随刷新',
          child: _card('排序:${_label(_sortValue, '默认排序')} / 状态:'
              '${_label(_statusValue, '全部')}'),
        ),
      ],
    );
  }

  String _label(String? value, String fallback) {
    if (value == null) return fallback;
    if (value == 'default') return '默认排序';
    if (value == 'price_asc') return '价格从低到高';
    if (value == 'price_desc') return '价格从高到低';
    if (value == 'all') return '全部';
    if (value == 'doing') return '进行中';
    if (value == 'done') return '已完成';
    return value;
  }

  Widget _card(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }
}

/// header 放输入框
class HeaderInputExample extends StatefulWidget {
  const HeaderInputExample({Key? key}) : super(key: key);

  @override
  State<HeaderInputExample> createState() => _HeaderInputExampleState();
}

class _HeaderInputExampleState extends State<HeaderInputExample> {
  String _text = '';

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'Header 固定区域',
      header: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: SantoInputText(
          hintText: '请输入关键字',
          onChanged: (text) => setState(() => _text = text),
        ),
      ),
      children: <Widget>[
        SantoSection(
          title: '输入框固定在标题下方',
          description: 'header 不随内容滚动,输入内容实时回显到内容区',
          child: _card(_text.isEmpty ? '输入框中还没有内容' : '输入了:「$_text」'),
        ),
      ],
    );
  }

  Widget _card(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }
}

/// header 放 Step 步骤条
class HeaderStepsExample extends StatefulWidget {
  const HeaderStepsExample({Key? key}) : super(key: key);

  @override
  State<HeaderStepsExample> createState() => _HeaderStepsExampleState();
}

class _HeaderStepsExampleState extends State<HeaderStepsExample> {
  final SantoStepsController _stepsController = SantoStepsController(currentIndex: 1);

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'Header 固定区域',
      header: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: SantoHorizontalSteps(
          controller: _stepsController,
          steps: const <SantoStep>[
            SantoStep(stepContentText: '提交订单'),
            SantoStep(stepContentText: '支付订单'),
            SantoStep(stepContentText: '完成'),
          ],
        ),
      ),
      children: <Widget>[
        SantoSection(
          title: 'Step 步骤条固定在标题下方',
          description: 'header 中的步骤条通过 controller 驱动,内容区按钮切换步骤',
          child: SantoButton(
            text: '下一步(当前第 ${_stepsController.currentIndex + 1} 步)',
            block: true,
            onTap: () {
              setState(() {
                _stepsController
                    .setCurrentIndex(_stepsController.currentIndex + 1);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _card(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }
}

/// header 放 Calendar 日历
class HeaderCalendarExample extends StatefulWidget {
  const HeaderCalendarExample({Key? key}) : super(key: key);

  @override
  State<HeaderCalendarExample> createState() => _HeaderCalendarExampleState();
}

class _HeaderCalendarExampleState extends State<HeaderCalendarExample> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'Header 固定区域',
      header: Container(
        color: Colors.white,
        child: SantoCalendar.single(
          showControllerBar: true,
          dateChange: (date) => setState(() => _selectedDate = date),
        ),
      ),
      children: <Widget>[
        SantoSection(
          title: 'Calendar 固定在标题下方',
          description: 'header 高度自适应,日历完整展示,选中日期后内容区跟随刷新',
          child: _card('当前选中:'
              '${_selectedDate == null ? '未选择' : _formatDate(_selectedDate!)}'),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${date.year}-${two(date.month)}-${two(date.day)}';
  }

  Widget _card(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }
}

/// 下拉刷新示例:enableRefresh 开启后由 SantoRefresh 承载滚动容器
class PageLayoutRefreshExample extends StatefulWidget {
  const PageLayoutRefreshExample({Key? key}) : super(key: key);

  @override
  State<PageLayoutRefreshExample> createState() =>
      _PageLayoutRefreshExampleState();
}

class _PageLayoutRefreshExampleState extends State<PageLayoutRefreshExample> {
  int _refreshCount = 0;

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: '下拉刷新',
      enableRefresh: true,
      onRefresh: () async {
        await Future<void>.delayed(const Duration(milliseconds: 800));
        setState(() => _refreshCount++);
      },
      children: <Widget>[
        SantoSection(
          title: '下拉刷新',
          description: 'enableRefresh 为 true 时内置滚动容器由 SantoRefresh 承载',
          child: _card('已刷新 $_refreshCount 次,下拉页面试试'),
        ),
        SantoSection(
          title: '内容块',
          description: '刷新时下拉头部出现在内容上方,不遮挡内容',
          child: _card('页面内容照常排布'),
        ),
      ],
    );
  }

  Widget _card(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }
}

/// 内容区内边距示例:padding 参数覆盖默认的四边 15
class PageLayoutPaddingExample extends StatelessWidget {
  const PageLayoutPaddingExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: '自定义内边距',
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      children: <Widget>[
        SantoSection(
          title: '自定义内容区内边距',
          description: '本页 padding 传入四边 24,默认取主题 iGapAllMiddle(四边 15)',
          child: _card('内容区四边留白是 24'),
        ),
      ],
    );
  }

  Widget _card(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }
}

/// 导航栏透传配置示例:title 简写构建时透传 appBar 系列参数
class PageLayoutAppBarExample extends StatelessWidget {
  const PageLayoutAppBarExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: '深色导航栏',
      appBarBackgroundColor: const Color(0xFF1677FF),
      appBarElevation: 4,
      appBarShadowColor: const Color(0x331677FF),
      appBarSystemOverlayStyle: SystemUiOverlayStyle.light,
      appBarActions: SantoTextAction(
        '操作',
        iconPressed: () => SantoToast.show('点击了导航栏操作', context),
      ),
      children: <Widget>[
        SantoSection(
          title: '导航栏透传配置',
          description:
              '只传 title 时可通过 appBarBackgroundColor / appBarElevation 等参数透传导航栏配置,传 appBar 时自行配置',
          child: _card('本页导航栏是蓝色背景 + 阴影,白色文字由主题深色样式提供'),
        ),
      ],
    );
  }

  Widget _card(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }
}
