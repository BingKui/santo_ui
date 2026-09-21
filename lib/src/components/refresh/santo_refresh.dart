import 'dart:async';

import 'package:flutter/material.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 下拉刷新状态
///
/// 对齐 TDesign PullDownRefresh 的四态 + 超时通知
enum SantoRefreshState {
  /// 未触发(初始/完成复位后)
  inactive,

  /// 下拉中,未达到触发阈值
  dragging,

  /// 已达阈值、松手即触发刷新
  ready,

  /// 刷新进行中
  refreshing,

  /// 刷新完成、展示完成态
  done,

  /// 刷新超时的一次性通知,随后回到 [inactive]
  timeout,
}

/// 下拉刷新四态提示语,未设置时使用默认文案
class SantoRefreshTexts {
  /// 下拉未达阈值时的提示语,默认「下拉刷新」
  final String pullToRefresh;

  /// 下拉已达阈值、松手即刷新的提示语,默认「松手刷新」
  final String releaseToRefresh;

  /// 刷新进行中的提示语,默认「正在刷新」
  final String refreshing;

  /// 刷新完成时的提示语,默认「刷新完成」
  final String refreshComplete;

  const SantoRefreshTexts({
    this.pullToRefresh = '下拉刷新',
    this.releaseToRefresh = '松手刷新',
    this.refreshing = '正在刷新',
    this.refreshComplete = '刷新完成',
  });
}

/// [SantoRefresh] 的外部刷新控制器:从页面外部主动触发一次刷新
///
/// 底层刷新逻辑由 [SantoRefresh] 的 State 持有,本控制器只持有引用,
/// 不拥有需要释放的资源,因此不提供 dispose。
class SantoRefreshController {
  _SantoRefreshState? _delegate;

  /// 主动触发一次刷新
  ///
  /// 返回的 Future 在本次刷新结束(完成/失败/超时复位)后完成,不返回业务结果
  Future<void> refresh() async {
    await _delegate?._triggerRefresh();
  }

  void _attach(_SantoRefreshState state) {
    _delegate = state;
  }

  void _detach(_SantoRefreshState state) {
    if (identical(_delegate, state)) {
      _delegate = null;
    }
  }
}

/// 下拉刷新组件
///
/// 对齐 TDesign PullDownRefresh 的行为:下拉 → 松手 → 刷新 → 完成四态,
/// 支持触底加载、刷新超时、四态文案自定义与外部主动刷新
///
/// [child] 必须是**可滚动**内容(如 ListView / GridView / CustomScrollView),
/// 否则下拉与触底手势无法生效
///
/// 使用示例:
/// ```dart
/// SantoRefresh(
///   onRefresh: () async => await loadData(),
///   onLoadMore: () async => await loadMore(),
///   child: ListView.builder(...),
/// )
/// ```
class SantoRefresh extends StatefulWidget {
  /// 滚动内容(必须为可滚动组件)
  final Widget child;

  /// 外部主动刷新控制器
  final SantoRefreshController? controller;

  /// 下拉刷新回调;为空时禁用下拉刷新
  ///
  /// 返回的 Future 完成后自动展示完成态并复位;回调抛错或 Future 失败时
  /// 刷新任务正常结束,错误通过 [FlutterError.reportError] 上报
  final Future<void> Function()? onRefresh;

  /// 触底加载回调;为空时禁用触底加载
  ///
  /// 返回的 Future 完成后自动结束加载态,错误处理同 [onRefresh]
  final Future<void> Function()? onLoadMore;

  /// 刷新状态变化回调,仅在状态跳变时触发
  final ValueChanged<SantoRefreshState>? onStateChanged;

  /// 头部容器高度,即触发刷新阈值,默认 50
  final double loadingBarHeight;

  /// 最大下拉高度,默认 80
  final double maxBarHeight;

  /// 距离底部多少像素时触发加载,默认 50
  final double lowerThreshold;

  /// 刷新超时时长,默认 3 秒;传 null 关闭超时
  ///
  /// 超时后自动结束刷新并上报 [SantoRefreshState.timeout],随后回到
  /// [SantoRefreshState.inactive];迟到的刷新结果不再改变状态
  final Duration? refreshTimeout;

  /// 刷新完成提示的展示时长,默认 500 毫秒
  final Duration successDuration;

  /// 四态提示语
  final SantoRefreshTexts? texts;

  /// 是否还有更多数据;为 false 时底部展示「没有更多数据了」且不再触发加载
  final bool hasMore;

  /// 自定义刷新头部,接收当前状态与下拉距离
  final Widget Function(SantoRefreshState state, double extent)? refreshHeader;

  /// 自定义加载更多底部,接收是否还有更多数据
  final Widget Function(bool hasMore)? loadMoreFooter;

  /// 创建下拉刷新组件
  const SantoRefresh({
    Key? key,
    required this.child,
    this.controller,
    this.onRefresh,
    this.onLoadMore,
    this.onStateChanged,
    this.loadingBarHeight = 50,
    this.maxBarHeight = 80,
    this.lowerThreshold = 50,
    this.refreshTimeout = const Duration(milliseconds: 3000),
    this.successDuration = const Duration(milliseconds: 500),
    this.texts,
    this.hasMore = true,
    this.refreshHeader,
    this.loadMoreFooter,
  })  : assert(loadingBarHeight >= 0, 'loadingBarHeight 不能为负'),
        assert(maxBarHeight >= 0, 'maxBarHeight 不能为负'),
        assert(refreshTimeout == null || refreshTimeout >= Duration.zero,
            'refreshTimeout 不能为负'),
        super(key: key);

  @override
  State<SantoRefresh> createState() => _SantoRefreshState();
}

class _SantoRefreshState extends State<SantoRefresh>
    with SingleTickerProviderStateMixin {
  /// 当前下拉距离
  double _pullExtent = 0;

  /// 最近一次滚动位置中的负向部分(Bouncing 物理松手回弹期间 < 0)。
  /// 弹性物理下列表自身会平移,平移量需从头部位移中扣除,避免内容双重位移
  double _negativePixels = 0;

  /// 当前状态
  SantoRefreshState _state = SantoRefreshState.inactive;

  /// 是否正在加载更多
  bool _isLoadingMore = false;

  /// 头部高度过渡动画(松手后回弹/停在刷新高度)
  late final AnimationController _settleController;
  Animation<double>? _settleAnimation;

  SantoRefreshTexts get _texts => widget.texts ?? const SantoRefreshTexts();

  @override
  void initState() {
    super.initState();
    _settleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        final animation = _settleAnimation;
        if (animation != null) {
          setState(() => _pullExtent = animation.value);
        }
      });
    widget.controller?._attach(this);
  }

  @override
  void didUpdateWidget(covariant SantoRefresh oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach(this);
      widget.controller?._attach(this);
    }
  }

  @override
  void dispose() {
    widget.controller?._detach(this);
    _settleController.dispose();
    super.dispose();
  }

  /// 状态跳变时通知外部(异步调度,不在 build 期间同步回调)
  void _notifyState(SantoRefreshState state) {
    if (_state == state) return;
    setState(() => _state = state);
    final callback = widget.onStateChanged;
    if (callback != null) {
      scheduleMicrotask(() {
        if (mounted) callback(state);
      });
    }
  }

  /// 头部高度动画到 [target]
  void _settleTo(double target) {
    _settleController.stop();
    if (_pullExtent == target) return;
    _settleAnimation = Tween<double>(begin: _pullExtent, end: target).animate(
      CurvedAnimation(parent: _settleController, curve: Curves.easeOut),
    );
    _settleController
      ..reset()
      ..forward();
  }

  /// 更新下拉距离与状态
  void _updatePull(double extent) {
    final double value = extent.clamp(0.0, widget.maxBarHeight).toDouble();
    setState(() => _pullExtent = value);
    _notifyState(value >= widget.loadingBarHeight
        ? SantoRefreshState.ready
        : SantoRefreshState.dragging);
  }

  /// 滚动通知:处理下拉刷新与触底加载
  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth != 0) return false;

    final px = notification.metrics.pixels;
    _negativePixels = px < 0 ? px : 0.0;

    final bool refreshing = _state == SantoRefreshState.refreshing ||
        _state == SantoRefreshState.done;
    if (widget.onRefresh != null && !refreshing) {
      if (notification is OverscrollNotification &&
          notification.overscroll < 0) {
        _updatePull(_pullExtent - notification.overscroll);
      } else if (notification is ScrollUpdateNotification &&
          notification.metrics.extentBefore == 0 &&
          notification.metrics.pixels < 0) {
        // 不要求 dragDetails:松手后的回弹阶段也要跟随,否则位移会对不上
        _updatePull(-notification.metrics.pixels);
      } else if (notification is ScrollEndNotification &&
          _state != SantoRefreshState.inactive) {
        if (_pullExtent >= widget.loadingBarHeight) {
          _triggerRefresh();
        } else {
          _settleTo(0);
          _notifyState(SantoRefreshState.inactive);
        }
      }
    }

    if (_pullExtent == 0 && !refreshing) {
      _handleLoadMoreIfNeeded(notification);
    }
    return false;
  }

  /// 触底检测
  void _handleLoadMoreIfNeeded(ScrollNotification notification) {
    if (widget.onLoadMore == null || _isLoadingMore || !widget.hasMore) return;
    if (notification is! ScrollUpdateNotification) return;
    final metrics = notification.metrics;
    if (metrics.axis != Axis.vertical) return;
    if (metrics.extentAfter > widget.lowerThreshold) return;
    _loadMore();
  }

  /// 触发下拉刷新
  Future<void> _triggerRefresh() async {
    final onRefresh = widget.onRefresh;
    if (onRefresh == null || _state == SantoRefreshState.refreshing) return;

    _settleController.stop();
    setState(() => _pullExtent = widget.loadingBarHeight);
    _notifyState(SantoRefreshState.refreshing);

    /// 回调是否已结束(用于区分超时)
    bool callbackDone = false;
    final completer = Completer<void>();

    /// 刷新超时计时器,回调结束后取消
    Timer? timeoutTimer;
    final timeout = widget.refreshTimeout;
    if (timeout != null) {
      timeoutTimer = Timer(timeout, () {
        if (!completer.isCompleted) {
          completer.complete();
        }
      });
    }

    // 回调异常上报,不吞掉也不中断刷新流程
    _guard(Future<void>(() => onRefresh())).whenComplete(() {
      callbackDone = true;
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    await completer.future;
    timeoutTimer?.cancel();
    if (!mounted) return;

    if (!callbackDone) {
      _notifyState(SantoRefreshState.timeout);
    }
    _notifyState(SantoRefreshState.done);

    await Future<void>.delayed(widget.successDuration);
    if (!mounted) return;
    _settleTo(0);
    _notifyState(SantoRefreshState.inactive);
  }

  /// 执行回调并把异常上报(不吞掉,也不中断动画流程)
  Future<void> _guard(Future<void> callback) async {
    try {
      await callback;
    } catch (error, stack) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stack,
        library: 'santo_ui',
        context: ErrorDescription('SantoRefresh 回调执行失败'),
      ));
    }
  }

  /// 触底加载
  Future<void> _loadMore() async {
    final onLoadMore = widget.onLoadMore;
    if (onLoadMore == null || _isLoadingMore || !widget.hasMore) return;
    setState(() => _isLoadingMore = true);
    try {
      await _guard(Future<void>(() => onLoadMore()));
    } finally {
      if (mounted) {
        setState(() => _isLoadingMore = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                // 头部高度变化只平移内容(纯绘制不触发布局),
                // 避免每帧改变视口高度导致列表抖动、可见内容被压缩;
                // 扣除负向 pixels,Bouncing 物理下内容不会双重位移
                child: Transform.translate(
                  offset: Offset(
                      0,
                      widget.onRefresh != null
                          ? _pullExtent + _negativePixels
                          : 0.0),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: _handleScrollNotification,
                    child: widget.child,
                  ),
                ),
              ),
              if (widget.onRefresh != null && _pullExtent > 0)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: _pullExtent,
                  child: _buildRefreshHeader(),
                ),
            ],
          ),
        ),
        if (widget.onLoadMore != null) _buildLoadMoreFooter(),
      ],
    );
  }

  /// 刷新头部:覆盖在列表顶部,随下拉距离露出(不挤压列表视口)
  Widget _buildRefreshHeader() {
    if (widget.refreshHeader != null) {
      return widget.refreshHeader!(_state, _pullExtent);
    }
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Container(
      height: _pullExtent,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: commonConfig.fillBody,
        borderRadius: BorderRadius.circular(commonConfig.radiusMd),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 18,
            height: 18,
            child: _state == SantoRefreshState.refreshing
                ? CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(commonConfig.brandPrimary),
                  )
                : Icon(
                    _state == SantoRefreshState.ready
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    size: 18,
                    color: commonConfig.brandPrimary,
                  ),
          ),
          SizedBox(width: commonConfig.hSpacingSm),
          Text(
            _refreshText,
            style: TextStyle(
              color: commonConfig.colorTextSecondary,
              fontSize: commonConfig.fontSizeBase,
            ),
          ),
        ],
      ),
    );
  }

  /// 当前状态对应的提示语
  String get _refreshText {
    switch (_state) {
      case SantoRefreshState.ready:
        return _texts.releaseToRefresh;
      case SantoRefreshState.refreshing:
        return _texts.refreshing;
      case SantoRefreshState.done:
        return _texts.refreshComplete;
      case SantoRefreshState.inactive:
      case SantoRefreshState.dragging:
      case SantoRefreshState.timeout:
        return _texts.pullToRefresh;
    }
  }

  /// 加载更多底部:占据布局空间,不遮挡列表内容
  Widget _buildLoadMoreFooter() {
    if (widget.loadMoreFooter != null) {
      return widget.loadMoreFooter!(widget.hasMore);
    }
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    if (!widget.hasMore) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: commonConfig.vSpacingMd),
        alignment: Alignment.center,
        child: Text(
          '没有更多数据了',
          style: TextStyle(
            color: commonConfig.colorTextHint,
            fontSize: commonConfig.fontSizeCaption,
          ),
        ),
      );
    }
    if (!_isLoadingMore) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: commonConfig.vSpacingMd),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor:
                  AlwaysStoppedAnimation<Color>(commonConfig.brandPrimary),
            ),
          ),
          SizedBox(width: commonConfig.hSpacingSm),
          Text(
            '正在加载',
            style: TextStyle(
              color: commonConfig.colorTextSecondary,
              fontSize: commonConfig.fontSizeCaption,
            ),
          ),
        ],
      ),
    );
  }
}
