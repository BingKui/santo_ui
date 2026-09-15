import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 返回顶部组件
///
/// 用于长列表快速回到顶部。监听滚动位置，超过阈值时显示按钮，
/// 点击后平滑滚动回顶部。支持自定义按钮样式。
///
/// 使用示例：
/// ```dart
/// Stack(
///   children: [
///     ListView.builder(
///       controller: _scrollController,
///       itemCount: 100,
///       itemBuilder: (context, index) => ListTile(title: Text('$index')),
///     ),
///     SantoBackTop(
///       scrollController: _scrollController,
///     ),
///   ],
/// )
/// ```
class SantoBackTop extends StatefulWidget {
  /// 滚动控制器
  final ScrollController scrollController;

  /// 显示按钮的滚动阈值，默认 400
  final double visibilityThreshold;

  /// 自定义按钮组件，不传则使用默认样式
  final Widget? child;

  /// 滚动回顶部的动画时长
  final Duration duration;

  const SantoBackTop({
    Key? key,
    required this.scrollController,
    this.visibilityThreshold = 400,
    this.child,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  State<SantoBackTop> createState() => _SantoBackTopState();
}

class _SantoBackTopState extends State<SantoBackTop>
    with SingleTickerProviderStateMixin {
  bool _visible = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final shouldShow =
        widget.scrollController.offset >= widget.visibilityThreshold;
    if (shouldShow != _visible) {
      setState(() {
        _visible = shouldShow;
        if (_visible) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      });
    }
  }

  void _scrollToTop() {
    widget.scrollController.animateTo(
      0,
      duration: widget.duration,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;

    return Positioned(
      right: 16,
      bottom: 24,
      child: IgnorePointer(
        ignoring: !_visible,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: GestureDetector(
            onTap: _scrollToTop,
            child: widget.child ??
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(0x1A),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    size: 28,
                    color: commonConfig.brandPrimary,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
