import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

/// SantoRefresh 下拉刷新示例
///
/// 排版参考其他组件示例：每个演示点一个 SantoSection
class RefreshExample extends StatefulWidget {
  @override
  State<RefreshExample> createState() => _RefreshExampleState();
}

class _RefreshExampleState extends State<RefreshExample> {
  /// 演示区域的固定高度(下拉刷新需要可滚动且有界的内容)
  static const double _demoHeight = 320;

  /// 基础用法
  List<String> _items = List.generate(20, (index) => '列表项 ${index + 1}');
  bool _hasMore = true;
  int _totalCount = 20;

  /// 外部主动刷新
  final SantoRefreshController _controller = SantoRefreshController();
  List<String> _controllerItems =
      List.generate(5, (index) => '外部刷新项 ${index + 1}');
  int _controllerRefreshCount = 0;

  /// 状态回调
  SantoRefreshState _lastState = SantoRefreshState.inactive;

  /// 超时演示
  List<String> _timeoutItems =
      List.generate(8, (index) => '超时演示项 ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'Refresh 下拉刷新',
      children: <Widget>[
        ExampleIntro('refresh'),
        _buildBasicSection(),
        _buildControllerSection(),
        _buildTextsAndStateSection(),
        _buildTimeoutSection(),
      ],
    );
  }

  /// 基础用法:下拉刷新 + 触底加载
  Widget _buildBasicSection() {
    return SantoSection(
      title: '基础用法',
      description: '下拉松手触发 onRefresh；滚动到距底部 50 内触发 onLoadMore，'
          '没有更多数据时底部展示提示',
      child: SizedBox(
        height: _demoHeight,
        child: SantoRefresh(
          onRefresh: _onRefresh,
          onLoadMore: _onLoadMore,
          hasMore: _hasMore,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: _items.length,
            itemBuilder: (context, index) => _listItem(
              title: _items[index],
              badge: '${index + 1}',
            ),
          ),
        ),
      ),
    );
  }

  /// 外部主动刷新:通过 controller.refresh() 触发
  Widget _buildControllerSection() {
    return SantoSection(
      title: '外部主动刷新',
      description: 'SantoRefreshController.refresh() 支持从页面外部触发一次刷新，'
          '返回的 Future 在刷新结束后完成',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SantoButton(
            text: '主动刷新（已触发 $_controllerRefreshCount 次）',
            type: SantoButtonType.primary,
            onTap: () async {
              await _controller.refresh();
              if (mounted) {
                SantoToast.show('主动刷新完成', context);
              }
            },
          ),
          SizedBox(height: 12),
          SizedBox(
            height: _demoHeight,
            child: SantoRefresh(
              controller: _controller,
              onRefresh: () async {
                await Future<void>.delayed(const Duration(seconds: 1));
                if (!mounted) return;
                setState(() {
                  _controllerRefreshCount++;
                  _controllerItems = List.generate(
                      5, (index) => '外部刷新项 ${_controllerRefreshCount * 5 + index + 1}');
                });
              },
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _controllerItems.length,
                itemBuilder: (context, index) => _listItem(
                  title: _controllerItems[index],
                  badge: '${index + 1}',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 四态文案与状态回调
  Widget _buildTextsAndStateSection() {
    return SantoSection(
      title: '四态文案与状态回调',
      description: 'texts 自定义下拉/松手/刷新中/完成四态文案；'
          'onStateChanged 仅在状态跳变时回调，当前状态：${_stateText(_lastState)}',
      child: SizedBox(
        height: _demoHeight,
        child: SantoRefresh(
          onRefresh: () async {
            await Future<void>.delayed(const Duration(seconds: 1));
          },
          texts: const SantoRefreshTexts(
            pullToRefresh: '继续下拉可刷新',
            releaseToRefresh: '松手立即刷新',
            refreshing: '努力加载中',
            refreshComplete: '加载完成',
          ),
          successDuration: const Duration(milliseconds: 800),
          onStateChanged: (state) {
            if (mounted) {
              setState(() => _lastState = state);
            }
          },
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: 12,
            itemBuilder: (context, index) => _listItem(
              title: '状态演示项 ${index + 1}',
              badge: '${index + 1}',
            ),
          ),
        ),
      ),
    );
  }

  /// 刷新超时
  Widget _buildTimeoutSection() {
    return SantoSection(
      title: '刷新超时',
      description: 'refreshTimeout 默认 3 秒；此处设为 1 秒，超时后自动结束刷新并上报 '
          'SantoRefreshState.timeout（本例刷新耗时 2 秒）',
      child: SizedBox(
        height: _demoHeight,
        child: SantoRefresh(
          refreshTimeout: const Duration(seconds: 1),
          onRefresh: () async {
            await Future<void>.delayed(const Duration(seconds: 2));
          },
          onStateChanged: (state) {
            if (state == SantoRefreshState.timeout && mounted) {
              SantoToast.show('刷新超时，已自动结束', context);
            }
          },
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: _timeoutItems.length,
            itemBuilder: (context, index) => _listItem(
              title: _timeoutItems[index],
              badge: '${index + 1}',
            ),
          ),
        ),
      ),
    );
  }

  /// 列表项
  Widget _listItem({required String title, required String badge}) {
    final common = SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: common.hSpacingMd, vertical: common.hSpacingSm),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: common.dividerColorBase, width: 0.5),
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: common.brandPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              badge,
              style: TextStyle(
                color: common.brandPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: common.hSpacingSm),
          Expanded(
            child: Text(title, style: TextStyle(fontSize: common.fontSizeSubHead)),
          ),
          Icon(Icons.chevron_right, color: common.colorTextHint, size: 20),
        ],
      ),
    );
  }

  String _stateText(SantoRefreshState state) {
    switch (state) {
      case SantoRefreshState.inactive:
        return '未触发';
      case SantoRefreshState.dragging:
        return '下拉中';
      case SantoRefreshState.ready:
        return '松手刷新';
      case SantoRefreshState.refreshing:
        return '刷新中';
      case SantoRefreshState.done:
        return '刷新完成';
      case SantoRefreshState.timeout:
        return '刷新超时';
    }
  }

  /// 下拉刷新
  Future<void> _onRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _items = List.generate(20, (index) => '刷新后的列表项 ${index + 1}');
      _totalCount = 20;
      _hasMore = true;
    });
  }

  /// 触底加载
  Future<void> _onLoadMore() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      final newItems = List.generate(
        10,
        (index) => '列表项 ${_totalCount + index + 1}',
      );
      _items = <String>[..._items, ...newItems];
      _totalCount += 10;
      if (_totalCount >= 50) {
        _hasMore = false;
      }
    });
  }
}
