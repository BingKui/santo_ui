import 'dart:async';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 轮播圆角
const double kSantoSwiperRadius = 12;

/// 轮播图组件
///
/// 支持自动播放、指示器（圆点/数字）、无限循环、自定义高度和间距。
/// 圆角由外层容器统一裁切(12px),内容整页铺满即可。
///
/// 使用示例：
/// ```dart
/// SantoSwiper(
///   children: [Image.asset('1.png'), Image.asset('2.png')],
///   autoPlay: true,
///   indicator: true,
/// )
/// ```
class SantoSwiper extends StatefulWidget {
  /// 子组件列表
  final List<Widget> children;

  /// 是否自动播放
  final bool autoPlay;

  /// 自动播放间隔（毫秒）
  final int interval;

  /// 是否显示指示器
  final bool indicator;

  /// 指示器类型：dot（圆点）或 number（数字）
  final SantoSwiperIndicatorType indicatorType;

  /// 是否无限循环
  final bool loop;

  /// 轮播高度
  final double height;

  /// 页面切换回调
  final ValueChanged<int>? onPageChanged;

  /// 当前页索引
  final int currentIndex;

  /// 子组件之间的间距
  final double spacing;

  /// 是否启用滑动切换
  final bool enableSwipe;

  SantoSwiper({
    Key? key,
    required this.children,
    this.autoPlay = true,
    this.interval = 3000,
    this.indicator = true,
    this.indicatorType = SantoSwiperIndicatorType.dot,
    this.loop = true,
    this.height = 200.0,
    this.onPageChanged,
    this.currentIndex = 0,
    this.spacing = 0.0,
    this.enableSwipe = true,
  }) : super(key: key) {
    assert(children.isNotEmpty, 'children 不能为空');
  }

  @override
  State<SantoSwiper> createState() => _SantoSwiperState();
}

/// 指示器类型
enum SantoSwiperIndicatorType {
  /// 圆点指示器
  dot,

  /// 数字指示器
  number,
}

class _SantoSwiperState extends State<SantoSwiper> {
  late PageController _pageController;
  Timer? _autoPlayTimer;
  late int _currentPage;
  int _realPageCount = 0;

  /// 无限循环时使用的乘数，用于在 PageView 中模拟无缝循环
  static const int _loopMultiplier = 100;

  @override
  void initState() {
    super.initState();
    _realPageCount = widget.children.length;
    final int initialPage = widget.loop
        ? _loopMultiplier * _realPageCount ~/ 2 + widget.currentIndex
        : widget.currentIndex;
    _currentPage = widget.currentIndex;
    _pageController = PageController(initialPage: initialPage);
    _startAutoPlay();
  }

  @override
  void didUpdateWidget(SantoSwiper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.autoPlay != widget.autoPlay) {
      if (widget.autoPlay) {
        _startAutoPlay();
      } else {
        _stopAutoPlay();
      }
    }
    // 外部改了 currentIndex 且与内部当前页不一致时才翻页;
    // 内部滑动触发的变更(父级同步同一个值)不再重复动画
    if (oldWidget.currentIndex != widget.currentIndex &&
        widget.currentIndex != _currentPage) {
      _currentPage = widget.currentIndex;
      if (widget.loop) {
        final int targetPage =
            _loopMultiplier * _realPageCount ~/ 2 + _currentPage;
        _pageController.animateToPage(
          targetPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _stopAutoPlay();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    if (!widget.autoPlay || _realPageCount <= 1) return;
    _stopAutoPlay();
    _autoPlayTimer = Timer.periodic(
      Duration(milliseconds: widget.interval),
      (_) {
        if (!mounted) return;
        _goToNextPage();
      },
    );
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
  }

  void _goToNextPage() {
    if (!mounted || !_pageController.hasClients) return;
    if (widget.loop) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      if (_currentPage < _realPageCount - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _onPageChanged(int page) {
    int realIndex;
    if (widget.loop) {
      realIndex = page % _realPageCount;
      // 当滚动到边界时，无感跳转到中间区域
      if (page <= 0 || page >= _loopMultiplier * _realPageCount - 1) {
        final int middleStart = _loopMultiplier * _realPageCount ~/ 2;
        final int targetPage = middleStart + realIndex;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _pageController.hasClients) {
            _pageController.jumpToPage(targetPage);
          }
        });
      }
    } else {
      realIndex = page;
    }

    if (realIndex != _currentPage) {
      _currentPage = realIndex;
      widget.onPageChanged?.call(realIndex);
      setState(() {});
    }
  }

  Color get _brandPrimary =>
      SantoThemeConfigurator.instance.getConfig().commonConfig.brandPrimary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      // 圆角由外层容器裁切,内容整页铺满
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(kSantoSwiperRadius)),
        child: Stack(
          children: [
            // 轮播内容
            PageView.builder(
              controller: _pageController,
              itemCount: widget.loop ? null : _realPageCount,
              onPageChanged: _onPageChanged,
              physics: widget.enableSwipe
                  ? const ClampingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final int realIndex;
                if (widget.loop) {
                  realIndex = index % _realPageCount;
                } else {
                  realIndex = index;
                }
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
                  child: widget.children[realIndex],
                );
              },
            ),
            // 指示器
            if (widget.indicator && _realPageCount > 1)
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Center(
                  child: widget.indicatorType == SantoSwiperIndicatorType.dot
                      ? _buildDotIndicator()
                      : _buildNumberIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDotIndicator() {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_realPageCount, (index) {
        final bool isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 16 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? _brandPrimary : Colors.white.withAlpha(180),
            borderRadius: BorderRadius.circular(commonConfig.radiusXs),
          ),
        );
      }),
    );
  }

  Widget _buildNumberIndicator() {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: commonConfig.hSpacingSm, vertical: commonConfig.vSpacingXs),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(100),
        borderRadius: BorderRadius.circular(commonConfig.radiusXs),
      ),
      child: Text(
        '${_currentPage + 1} / $_realPageCount',
        style: TextStyle(
          color: Colors.white,
          fontSize: commonConfig.fontSizeCaption,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
