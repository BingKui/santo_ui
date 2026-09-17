import 'package:flutter/material.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 刷新状态枚举
enum SantoRefreshState {
  /// 空闲状态
  idle,

  /// 下拉中（未达到刷新阈值）
  pulling,

  /// 松开即可刷新（已达到刷新阈值）
  ready,

  /// 正在刷新
  refreshing,

  /// 刷新完成
  refreshDone,

  /// 正在加载更多
  loadingMore,

  /// 没有更多数据
  noMore,
}

/// Refresh 下拉刷新组件
///
/// 支持下拉刷新和上拉加载更多。
/// 支持自定义刷新头部和加载更多底部。
/// 使用 [NotificationListener] + [ScrollController] 实现。
///
/// 注意：[child] 必须是可滚动组件（如 [ListView]、[GridView]、[SingleChildScrollView] 等），
/// 且需要传入其 [ScrollController] 以便监听滚动事件。如果不传入，组件会自动创建。
///
/// 使用示例：
/// ```dart
/// SantoRefresh(
///   onRefresh: () async {
///     await Future.delayed(Duration(seconds: 2));
///     // 刷新数据
///   },
///   onLoadMore: () async {
///     await Future.delayed(Duration(seconds: 1));
///     // 加载更多
///   },
///   hasMore: true,
///   child: ListView.builder(
///     itemCount: items.length,
///     itemBuilder: (context, index) => ListTile(title: Text(items[index])),
///   ),
/// )
/// ```
class SantoRefresh extends StatefulWidget {
  /// 子组件（必须为可滚动组件，如 ListView / GridView 等）
  final Widget child;

  /// 下拉刷新回调，返回 Future
  final Future<void> Function()? onRefresh;

  /// 上拉加载更多回调，返回 Future
  final Future<void> Function()? onLoadMore;

  /// 是否还有更多数据
  final bool hasMore;

  /// 自定义刷新头部 Widget
  /// 接收当前刷新状态和下拉距离百分比
  final Widget Function(SantoRefreshState state, double extent)? refreshHeader;

  /// 自定义加载更多底部 Widget
  /// 接收当前加载状态和是否还有更多数据
  final Widget Function(SantoRefreshState state, bool hasMore)? loadMoreFooter;

  /// 触发刷新的下拉距离阈值，默认80
  final double refreshTriggerDistance;

  /// 刷新完成后头部停留时间，默认500毫秒
  final Duration refreshCompleteDuration;

  /// 是否启用下拉刷新，默认true
  final bool enableRefresh;

  /// 是否启用上拉加载更多，默认true
  final bool enableLoadMore;

  /// 创建下拉刷新组件
  const SantoRefresh({
    Key? key,
    required this.child,
    this.onRefresh,
    this.onLoadMore,
    this.hasMore = true,
    this.refreshHeader,
    this.loadMoreFooter,
    this.refreshTriggerDistance = 80.0,
    this.refreshCompleteDuration = const Duration(milliseconds: 500),
    this.enableRefresh = true,
    this.enableLoadMore = true,
  }) : super(key: key);

  @override
  State<SantoRefresh> createState() => _SantoRefreshState();
}

/// SantoRefresh 内部状态
class _SantoRefreshState extends State<SantoRefresh>
    with TickerProviderStateMixin {
  /// 滚动控制器
  late ScrollController _scrollController;

  /// 是否自动创建了 ScrollController
  bool _ownScrollController = false;

  /// 当前刷新状态
  SantoRefreshState _refreshState = SantoRefreshState.idle;

  /// 当前下拉距离
  double _pullExtent = 0.0;

  /// 是否正在刷新
  bool _isRefreshing = false;

  /// 是否正在加载更多
  bool _isLoadingMore = false;

  /// 刷新头部动画控制器
  late AnimationController _headerAnimController;

  /// 刷新头部高度动画值
  late Animation<double> _headerHeightAnimation;

  @override
  void initState() {
    super.initState();
    _headerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _headerHeightAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _headerAnimController, curve: Curves.easeOut),
    );

    _setupScrollController();
  }

  /// 设置滚动控制器
  void _setupScrollController() {
    // 尝试从子组件中获取 ScrollController
    // 如果没有，则自动创建
    _scrollController = ScrollController();
    _ownScrollController = true;

    if (widget.enableLoadMore && widget.onLoadMore != null) {
      _scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    if (_ownScrollController) {
      _scrollController.dispose();
    }
    _headerAnimController.dispose();
    super.dispose();
  }

  /// 滚动监听，检测是否滚动到底部
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_isLoadingMore || !widget.hasMore) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll - 50) {
      _loadMore();
    }
  }

  /// 执行加载更多
  Future<void> _loadMore() async {
    if (_isLoadingMore || !widget.hasMore || widget.onLoadMore == null) return;

    setState(() {
      _isLoadingMore = true;
      _refreshState = SantoRefreshState.loadingMore;
    });

    try {
      await widget.onLoadMore!();
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
          _refreshState = SantoRefreshState.idle;
        });
      }
    }
  }

  /// 处理滚动通知（用于下拉刷新）
  bool _handleScrollNotification(ScrollNotification notification) {
    if (!widget.enableRefresh || widget.onRefresh == null || _isRefreshing) {
      return false;
    }

    if (notification is ScrollUpdateNotification) {
      final metrics = notification.metrics;
      // 检测过度滚动（下拉）
      if (metrics.extentBefore == 0 &&
          notification.dragDetails != null &&
          notification.dragDetails!.delta.dy > 0) {
        final overscroll = metrics.extentBefore == 0
            ? -metrics.pixels
            : 0.0;
        if (overscroll > 0) {
          setState(() {
            _pullExtent = overscroll.clamp(0.0, widget.refreshTriggerDistance * 1.5);
            if (_pullExtent >= widget.refreshTriggerDistance) {
              _refreshState = SantoRefreshState.ready;
            } else {
              _refreshState = SantoRefreshState.pulling;
            }
          });
        }
      }
    } else if (notification is OverscrollNotification) {
      // 处理 Overscroll（下拉时顶部过度滚动）
      if (notification.overscroll < 0) {
        setState(() {
          _pullExtent += -notification.overscroll;
          _pullExtent = _pullExtent.clamp(0.0, widget.refreshTriggerDistance * 1.5);
          if (_pullExtent >= widget.refreshTriggerDistance) {
            _refreshState = SantoRefreshState.ready;
          } else {
            _refreshState = SantoRefreshState.pulling;
          }
        });
      }
    } else if (notification is ScrollEndNotification) {
      if (_pullExtent > 0 && !_isRefreshing) {
        if (_pullExtent >= widget.refreshTriggerDistance) {
          // 达到阈值，触发刷新
          _performRefresh();
        } else {
          // 未达到阈值，回弹
          setState(() {
            _pullExtent = 0;
            _refreshState = SantoRefreshState.idle;
          });
        }
      }
    }

    return false;
  }

  /// 执行刷新
  Future<void> _performRefresh() async {
    if (_isRefreshing || widget.onRefresh == null) return;

    setState(() {
      _isRefreshing = true;
      _refreshState = SantoRefreshState.refreshing;
      _pullExtent = widget.refreshTriggerDistance;
    });

    try {
      await widget.onRefresh!();
    } finally {
      // 刷新完成，停留一段时间后回弹
      await Future.delayed(widget.refreshCompleteDuration);
      if (mounted) {
        setState(() {
          _isRefreshing = false;
          _pullExtent = 0;
          _refreshState = SantoRefreshState.idle;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Stack(
        children: [
          // 子组件（可滚动内容）
          widget.child,
          // 刷新头部覆盖层
          if (widget.enableRefresh)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildRefreshHeader(),
            ),
          // 加载更多底部
          if (widget.enableLoadMore && widget.onLoadMore != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildLoadMoreFooter(),
            ),
        ],
      ),
    );
  }

  /// 构建刷新头部
  Widget _buildRefreshHeader() {
    if (_pullExtent <= 0 && !_isRefreshing) {
      return const SizedBox.shrink();
    }

    if (widget.refreshHeader != null) {
      return widget.refreshHeader!(_refreshState, _pullExtent);
    }
    return _buildDefaultRefreshHeader();
  }

  /// 构建默认刷新头部
  Widget _buildDefaultRefreshHeader() {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final brandColor = commonConfig.brandPrimary;

    return Container(
      height: _isRefreshing ? widget.refreshTriggerDistance : _pullExtent,
      alignment: Alignment.center,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: _isRefreshing
                ? CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(brandColor),
                  )
                : Icon(
                    _refreshState == SantoRefreshState.ready
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    color: brandColor,
                    size: 20,
                  ),
          ),
          SizedBox(width: commonConfig.hSpacingSm),
          Text(
            _getRefreshText(),
            style: TextStyle(
              color: commonConfig.colorTextSecondary,
              fontSize: commonConfig.fontSizeBase,
            ),
          ),
        ],
      ),
    );
  }

  /// 获取刷新提示文字
  String _getRefreshText() {
    switch (_refreshState) {
      case SantoRefreshState.pulling:
        return '下拉刷新';
      case SantoRefreshState.ready:
        return '松开刷新';
      case SantoRefreshState.refreshing:
        return '正在刷新...';
      case SantoRefreshState.refreshDone:
        return '刷新完成';
      default:
        return '下拉刷新';
    }
  }

  /// 构建加载更多底部
  Widget _buildLoadMoreFooter() {
    if (widget.loadMoreFooter != null) {
      return widget.loadMoreFooter!(_refreshState, widget.hasMore);
    }
    return _buildDefaultLoadMoreFooter();
  }

  /// 构建默认加载更多底部
  Widget _buildDefaultLoadMoreFooter() {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;

    if (!widget.hasMore) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: commonConfig.vSpacingMd),
        alignment: Alignment.center,
        color: Colors.white,
        child: Text(
          '没有更多数据了',
          style: TextStyle(
            color: commonConfig.colorTextSecondary,
            fontSize: commonConfig.fontSizeCaption,
          ),
        ),
      );
    }

    if (_isLoadingMore) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: commonConfig.vSpacingMd),
        alignment: Alignment.center,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                    commonConfig.brandPrimary),
              ),
            ),
            SizedBox(width: commonConfig.hSpacingSm),
            Text(
              '正在加载...',
              style: TextStyle(
                color: commonConfig.colorTextSecondary,
                fontSize: commonConfig.fontSizeCaption,
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
