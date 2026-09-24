

import 'package:santo_ui/src/components/charts/santo_progress_chart/santo_progress_chart_painter.dart';
import 'package:santo_ui/src/theme/santo_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 在进度条上展示的 Widget
typedef SantoProgressIndicatorBuilder = Widget Function(
    BuildContext context, double value);

/// 一个简单的进度条 Widget，支持数据变化时的动画
class SantoProgressChart extends StatefulWidget {
  /// 宽度，默认0
  final double width;

  /// 高度，默认0
  final double height;

  /// 进度图进度值，默认0.2，必须在 0 到 1 之间
  final double value;

  /// 进度条上自定义Widget的左侧padding，默认值10
  final double indicatorLeftPadding;

  /// 展示默认进度indicator的时候的文本样式,不传取主题 colorTextBaseInverse
  final TextStyle? textStyle;

  /// 自定义进度条上面的Widget，默认显示为文本
  final SantoProgressIndicatorBuilder? santoProgressIndicatorBuilder;

  /// 背景色，不传取主题 brandPrimary 淡色
  final Color? backgroundColor;

  /// 进度条颜色，不传取主题 brandPrimary
  final List<Color>? colors;

  /// 是否展示动画，默认 false
  final bool showAnimation;

  /// 动画时长,默认 Duration(milliseconds: 250)
  final Duration duration;

  /// 进度条是否从上次的值开始
  final bool isFromLastValue;

  const SantoProgressChart(
      {Key? key,
      this.width = 0,
      this.height = 0,
      this.value = 0.2,
      this.indicatorLeftPadding = 10,
      this.textStyle,
      this.santoProgressIndicatorBuilder,
      this.colors,
      this.backgroundColor,
      this.showAnimation = false,
      this.isFromLastValue = false,
      this.duration = const Duration(milliseconds: 250),})
      : assert(0 <= value && value <= 1, 'value 必须在 0 到 1 之间'),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SantoProgressChartState();
  }
}

class SantoProgressChartState extends State<SantoProgressChart>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController =
      AnimationController(vsync: this);
  double _lastValue = 0;

  bool get _isAnimation => widget.showAnimation;

  void _initAnimation() {
    final double begin = widget.isFromLastValue ? _lastValue : 0;
    final double end = widget.value;
    final Tween<double> tween = Tween<double>(begin: begin, end: end);
    _animationController.duration =
        _isAnimation ? widget.duration : Duration.zero;
    _animation = tween.animate(_animationController);
    _animationController.reset();
    _animationController.forward();
    _lastValue = end;
  }

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void didUpdateWidget(covariant SantoProgressChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (_animationController.isAnimating == true) {
        _animationController.stop();
      }
      _initAnimation();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final double _value = widget.value;
    return Stack(
      children: <Widget>[
        CustomPaint(
          size: Size(widget.width, widget.height),
          painter: SantoProgressChartPainter(
            value: _value,
            animation: _animation,
            backgroundColor: widget.backgroundColor,
            colors: widget.colors,
          ),
        ),
        Container(
          width: widget.width,
          height: widget.height,
          padding: EdgeInsets.only(left: widget.indicatorLeftPadding),
          alignment: Alignment.centerLeft,
          child: IndicatorWidgetBuilder(
            notifier: _animation,
            value: _value,
            textStyle: widget.textStyle ??
                TextStyle(color: commonConfig.colorTextBaseInverse),
            santoProgressIndicatorBuilder: widget.santoProgressIndicatorBuilder,
          ),
        )
      ],
    );
  }
}

class IndicatorWidgetBuilder extends StatefulWidget {
  const IndicatorWidgetBuilder({
    Key? key,
    required this.value,
    required this.textStyle,
    this.notifier,
    this.santoProgressIndicatorBuilder,
  }) : super(key: key);

  final ValueListenable<double>? notifier;
  final double value;
  final TextStyle textStyle;
  final SantoProgressIndicatorBuilder? santoProgressIndicatorBuilder;

  @override
  State<IndicatorWidgetBuilder> createState() => _IndicatorWidgetBuilderState();
}

class _IndicatorWidgetBuilderState extends State<IndicatorWidgetBuilder> {
  late double _value;

  void _changeListener() {
    final double value = widget.notifier?.value ?? widget.value;
    if(!mounted) return;
    setState(() {
      _value = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    widget.notifier?.addListener(_changeListener);
  }

  @override
  void dispose() {
    widget.notifier?.removeListener(_changeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SantoProgressIndicatorBuilder? builder =
        widget.santoProgressIndicatorBuilder;
    return builder?.call(context, _value) ??
        Text(_value.toStringAsFixed(2), style: widget.textStyle);
  }
}
