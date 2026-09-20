import 'dart:async';

import 'package:flutter/material.dart';
import 'package:santo_ui/src/components/dialog/santo_dialog.dart';
import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 加载尺寸,对标 antd Spin 的 size
enum SantoLoadingSize {
  /// 小:指示器 14,用于文字旁的加载
  small,

  /// 中:指示器 20,用于卡片级区块的加载(默认)
  medium,

  /// 大:指示器 32,用于整页加载
  large,
}

/// 指示器边长,对标 antd Spin 的 small / medium / large
const double _kSmallIndicatorSize = 14;
const double _kMediumIndicatorSize = 20;
const double _kLargeIndicatorSize = 32;

/// 圆环粗细
const double _kSmallStrokeWidth = 2;
const double _kMediumStrokeWidth = 2.5;
const double _kLargeStrokeWidth = 3.5;

/// 浮层黑胶囊底色(不与尺寸/主题挂钩,保持既有视觉)
const Color _kPillBackgroundColor = Color(0xFF1A1A1A);

/// 统一的加载组件,对标 antd Spin
///
/// 三种用法:
///
/// * 独立指示器:直接使用 [SantoLoading],可按需配 [size] 与 [tip]
/// * 包裹内容:传入 [child] 后进入包裹模式,[spinning] 为 true 时在内容上盖一层蒙层并居中展示指示器
/// * 浮层:[SantoLoading.show] 展示加载浮层(黑胶囊 + 文案),[SantoLoading.dismiss] 关闭
///
/// ```dart
/// // 独立使用
/// SizedBox(height: 120, child: SantoLoading(tip: '加载中'))
/// SantoLoading(size: SantoLoadingSize.small)
/// SantoLoading(percent: 40)
///
/// // 包裹内容
/// SantoLoading(spinning: isLoading, tip: '加载中', child: SantoList())
///
/// // 浮层
/// SantoLoading.show(context, tip: '提交中');
/// SantoLoading.dismiss(context);
/// ```
class SantoLoading extends StatefulWidget {
  /// 被包裹的内容,传入后进入包裹模式
  final Widget? child;

  /// 加载文案;不传时包裹模式与浮层展示本地化的「加载中」
  final String? tip;

  /// 自定义指示器,默认为主题色圆环
  final Widget? indicator;

  /// 指示器尺寸,默认 [SantoLoadingSize.medium]
  final SantoLoadingSize size;

  /// 是否处于加载中,默认 true
  final bool spinning;

  /// 延迟展示时长;延迟期间 [spinning] 变回 false 则不展示,对齐 antd 的 delay
  final Duration? delay;

  /// 进度百分比(0~100):传值后圆环展示确定进度,不传为不确定进度
  final double? percent;

  /// 全屏模式:铺满父布局的蒙层 + 居中指示器
  final bool fullscreen;

  /// 指示器颜色,默认主题色
  final Color? color;

  /// 包裹/全屏模式的蒙层颜色
  final Color? overlayColor;

  const SantoLoading({
    Key? key,
    this.child,
    this.tip,
    this.indicator,
    this.size = SantoLoadingSize.medium,
    this.spinning = true,
    this.delay,
    this.percent,
    this.fullscreen = false,
    this.color,
    this.overlayColor,
  }) : super(key: key);

  /// 浮层的 tag,用于 [SantoDialog] 按类型移除
  static const String _overlayTag = '_santoLoadingOverlayTag';

  /// 展示加载浮层,不传 [fullscreen] 时为「蒙层 + 黑胶囊」,传 true 时为全屏遮罩
  ///
  /// * [tip] 加载文案,默认本地化的「加载中」
  /// * [fullscreen] 是否全屏遮罩,默认 false
  /// * [barrierDismissible] 点击蒙层是否关闭,默认 true
  /// * [useRootNavigator] 是否挂到 rootNavigator,默认 true
  static Future<T?> show<T>(
    BuildContext context, {
    String? tip,
    bool fullscreen = false,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
  }) {
    final SantoCommonConfig commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final String text =
        tip ?? SantoIntl.of(context).localizedResource.loading;
    return SantoDialog.show<T>(
      context: context,
      tag: _overlayTag,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      // 全屏模式用自己的遮罩色,避免与路由蒙层叠加变深
      barrierColor: fullscreen ? commonConfig.fillMask : Colors.black54,
      builder: (_) => fullscreen
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SantoLoading(
                    size: SantoLoadingSize.large,
                    color: commonConfig.colorTextBaseInverse,
                  ),
                  SizedBox(height: commonConfig.vSpacingSm),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: commonConfig.fontSizeBase,
                      color: commonConfig.colorTextBaseInverse,
                    ),
                  ),
                ],
              ),
            )
          : _LoadingPill(content: text),
    );
  }

  /// 关闭 [show] 打开的加载浮层
  static void dismiss<T extends Object?>(BuildContext context, [T? result]) {
    SantoDialog.dismiss<T>(
      context: context,
      tag: _overlayTag,
      result: result,
    );
  }

  @override
  State<SantoLoading> createState() => _SantoLoadingState();
}

class _SantoLoadingState extends State<SantoLoading> {
  bool _visible = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (!widget.spinning) return;
    final Duration? delay = widget.delay;
    if (delay == null || delay <= Duration.zero) {
      _visible = true;
    } else {
      _timer = Timer(delay, () {
        if (mounted && widget.spinning) {
          setState(() => _visible = true);
        }
      });
    }
  }

  @override
  void didUpdateWidget(SantoLoading oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.spinning != widget.spinning ||
        oldWidget.delay != widget.delay) {
      _syncVisible();
    }
  }

  /// 延迟期间被打断则不展示,对齐 antd 的 delay 语义
  void _syncVisible() {
    _timer?.cancel();
    _timer = null;
    if (!widget.spinning) {
      if (_visible) setState(() => _visible = false);
      return;
    }
    final Duration? delay = widget.delay;
    if (delay == null || delay <= Duration.zero) {
      if (!_visible) setState(() => _visible = true);
      return;
    }
    _timer = Timer(delay, () {
      if (mounted && widget.spinning) {
        setState(() => _visible = true);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  double get _indicatorSize {
    switch (widget.size) {
      case SantoLoadingSize.small:
        return _kSmallIndicatorSize;
      case SantoLoadingSize.medium:
        return _kMediumIndicatorSize;
      case SantoLoadingSize.large:
        return _kLargeIndicatorSize;
    }
  }

  double get _strokeWidth {
    switch (widget.size) {
      case SantoLoadingSize.small:
        return _kSmallStrokeWidth;
      case SantoLoadingSize.medium:
        return _kMediumStrokeWidth;
      case SantoLoadingSize.large:
        return _kLargeStrokeWidth;
    }
  }

  SantoCommonConfig get _commonConfig =>
      SantoThemeConfigurator.instance.getConfig().commonConfig;

  @override
  Widget build(BuildContext context) {
    final Widget indicator = _buildIndicator();

    // 包裹模式:内容之上盖一层蒙层
    if (widget.child != null) {
      if (!_visible) return widget.child!;
      return Stack(
        // 内容区小于指示器时允许指示器溢出绘制,不做裁剪
        clipBehavior: Clip.none,
        children: <Widget>[
          widget.child!,
          Positioned.fill(
            child: ColoredBox(
              color: widget.overlayColor ??
                  _commonConfig.fillBase.withOpacity(0.5),
              child: OverflowBox(
                alignment: Alignment.center,
                minWidth: 0,
                maxWidth: double.infinity,
                minHeight: 0,
                maxHeight: double.infinity,
                child: indicator,
              ),
            ),
          ),
        ],
      );
    }

    // 全屏模式:铺满父布局的遮罩
    if (widget.fullscreen) {
      if (!_visible) return const SizedBox.shrink();
      return Stack(
        children: <Widget>[
          Positioned.fill(
            child: ColoredBox(
              color: widget.overlayColor ?? _commonConfig.fillMask,
              child: Center(child: indicator),
            ),
          ),
        ],
      );
    }

    if (!_visible) return const SizedBox.shrink();
    return Center(child: indicator);
  }

  /// 指示器 + 文案;文案取 [SantoLoading.tip],未传时展示百分比
  Widget _buildIndicator() {
    final Widget indicator = widget.indicator ??
        SizedBox.square(
          dimension: _indicatorSize,
          child: CircularProgressIndicator(
            value: _progressValue,
            strokeWidth: _strokeWidth,
            color: widget.color ?? _commonConfig.brandPrimary,
            backgroundColor:
                _progressValue == null ? null : _commonConfig.dividerColorBase,
          ),
        );

    final double? percent = widget.percent;
    final String? text =
        widget.tip ?? (percent == null ? null : '${percent.round()}%');
    if (text == null) return indicator;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        indicator,
        SizedBox(height: _commonConfig.vSpacingSm),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: _commonConfig.fontSizeBase,
            color: widget.fullscreen
                ? _commonConfig.colorTextBaseInverse
                : _commonConfig.colorTextSecondary,
          ),
        ),
      ],
    );
  }

  /// 百分比换算成 0~1,超出范围由 CircularProgressIndicator 约束
  double? get _progressValue {
    final double? percent = widget.percent;
    if (percent == null) return null;
    return (percent / 100).clamp(0.0, 1.0);
  }
}

/// 加载浮层的黑胶囊:圆环 + 文案并排,宽度随文案自适应
///
/// 宽度交给布局计算(容器只有最大宽度约束):不用 TextPainter 手算,
/// 否则设备字体度量与测量样式有差异时,精确贴合的行会溢出出黄黑条纹
class _LoadingPill extends StatelessWidget {
  final String content;

  const _LoadingPill({Key? key, required this.content}) : super(key: key);

  /// 圆环尺寸
  static const double _iconSize = 19;

  @override
  Widget build(BuildContext context) {
    final SantoCommonConfig commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;

    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: commonConfig.hSpacingSm,
            vertical: commonConfig.vSpacingMd),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 2 / 3,
        ),
        decoration: BoxDecoration(
          color: _kPillBackgroundColor,
          borderRadius: BorderRadius.circular(commonConfig.radiusXs),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: _iconSize,
              height: _iconSize,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                    commonConfig.colorTextBaseInverse),
              ),
            ),
            SizedBox(width: commonConfig.hSpacingSm),
            Flexible(
              child: Text(
                content,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: commonConfig.fontSizeBase,
                  fontWeight: FontWeight.w500,
                  color: commonConfig.colorTextBaseInverse,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
