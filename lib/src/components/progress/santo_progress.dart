import 'dart:math' as math;
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 线性进度条
///
/// 支持百分比显示、自定义颜色、动画过渡。
///
/// 使用示例：
/// ```dart
/// SantoProgress(value: 0.6)
/// SantoProgress(value: 0.8, showLabel: true, color: Colors.green)
/// ```
class SantoProgress extends StatefulWidget {
  /// 进度值，范围 0.0 ~ 1.0
  final double value;

  /// 进度条颜色，默认使用主题色 brandPrimary
  final Color? color;

  /// 进度条背景色，默认使用灰色
  final Color? backgroundColor;

  /// 进度条高度
  final double strokeWidth;

  /// 是否显示百分比标签
  final bool showLabel;

  /// 百分比标签样式
  final TextStyle? labelStyle;

  /// 是否使用动画过渡
  final bool animated;

  const SantoProgress({
    Key? key,
    required this.value,
    this.color,
    this.backgroundColor,
    this.strokeWidth = 8.0,
    this.showLabel = false,
    this.labelStyle,
    this.animated = true,
  })  : assert(value >= 0.0 && value <= 1.0),
        super(key: key);

  @override
  State<SantoProgress> createState() => _SantoProgressState();
}

class _SantoProgressState extends State<SantoProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _previousValue = 0.0;

  Color get _brandPrimary =>
      SantoThemeConfigurator.instance.getConfig().commonConfig.brandPrimary;

  Color get _dividerColor =>
      SantoThemeConfigurator.instance.getConfig().commonConfig.dividerColorBase;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: widget.value, end: widget.value)
        .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(SantoProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(begin: oldWidget.value, end: widget.value)
          .animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));
      _animationController.forward(from: 0.0);
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
    final Color activeColor = widget.color ?? _brandPrimary;
    final Color bgColor =
        widget.backgroundColor ?? _dividerColor.withAlpha(80);

    Widget bar = LayoutBuilder(
      builder: (context, constraints) {
        if (widget.animated) {
          return AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final double animValue = _animation.value.clamp(0.0, 1.0);
              return _buildBar(constraints, animValue, activeColor, bgColor);
            },
          );
        }
        return _buildBar(
            constraints, widget.value.clamp(0.0, 1.0), activeColor, bgColor);
      },
    );

    if (widget.showLabel) {
      return Row(
        children: [
          Expanded(child: bar),
          SizedBox(width: commonConfig.hSpacingSm),
          AnimatedBuilder(
            animation: widget.animated ? _animation : kAlwaysCompleteAnimation,
            builder: (context, child) {
              final double animValue =
                  widget.animated ? _animation.value : widget.value;
              final int percent = (animValue.clamp(0.0, 1.0) * 100).round();
              return Text(
                '$percent%',
                style: widget.labelStyle ??
                    TextStyle(
                      fontSize: SantoThemeConfigurator.instance
                          .getConfig()
                          .commonConfig
                          .fontSizeCaption,
                      color: activeColor,
                      fontWeight: FontWeight.w500,
                    ),
              );
            },
          ),
        ],
      );
    }
    return bar;
  }

  Widget _buildBar(
      BoxConstraints constraints, double progressValue, Color activeColor, Color bgColor) {
    return Stack(
      children: [
        // 背景
        Container(
          height: widget.strokeWidth,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(widget.strokeWidth / 2),
          ),
        ),
        // 进度
        Container(
          height: widget.strokeWidth,
          width: constraints.maxWidth * progressValue,
          decoration: BoxDecoration(
            color: activeColor,
            borderRadius: BorderRadius.circular(widget.strokeWidth / 2),
          ),
        ),
      ],
    );
  }
}

/// 环形进度条
///
/// 支持自定义半径、线宽、颜色、百分比显示。
///
/// 使用示例：
/// ```dart
/// SantoCircularProgress(value: 0.7, radius: 40)
/// ```
class SantoCircularProgress extends StatefulWidget {
  /// 环形半径
  final double radius;

  /// 环形线宽
  final double strokeWidth;

  /// 进度值，范围 0.0 ~ 1.0
  final double value;

  /// 进度条颜色，默认使用主题色 brandPrimary
  final Color? color;

  /// 背景环颜色
  final Color? backgroundColor;

  /// 是否显示百分比标签
  final bool showLabel;

  /// 标签样式
  final TextStyle? labelStyle;

  const SantoCircularProgress({
    Key? key,
    this.radius = 30.0,
    this.strokeWidth = 6.0,
    required this.value,
    this.color,
    this.backgroundColor,
    this.showLabel = true,
    this.labelStyle,
  })  : assert(value >= 0.0 && value <= 1.0),
        super(key: key);

  @override
  State<SantoCircularProgress> createState() => _SantoCircularProgressState();
}

class _SantoCircularProgressState extends State<SantoCircularProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  Color get _brandPrimary =>
      SantoThemeConfigurator.instance.getConfig().commonConfig.brandPrimary;

  Color get _dividerColor =>
      SantoThemeConfigurator.instance.getConfig().commonConfig.dividerColorBase;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: widget.value).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(SantoCircularProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(begin: oldWidget.value, end: widget.value)
          .animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color activeColor = widget.color ?? _brandPrimary;
    final Color bgColor =
        widget.backgroundColor ?? _dividerColor.withAlpha(80);

    return SizedBox(
      width: widget.radius * 2,
      height: widget.radius * 2,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final double animValue = _animation.value.clamp(0.0, 1.0);
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(widget.radius * 2, widget.radius * 2),
                painter: _CircularProgressPainter(
                  strokeWidth: widget.strokeWidth,
                  backgroundColor: bgColor,
                  valueColor: activeColor,
                  value: animValue,
                ),
              ),
              if (widget.showLabel)
                Text(
                  '${(animValue * 100).round()}%',
                  style: widget.labelStyle ??
                      TextStyle(
                        fontSize: widget.radius * 0.4,
                        fontWeight: FontWeight.w500,
                        color: activeColor,
                      ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double strokeWidth;
  final Color backgroundColor;
  final Color valueColor;
  final double value;

  _CircularProgressPainter({
    required this.strokeWidth,
    required this.backgroundColor,
    required this.valueColor,
    required this.value,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius =
        (math.min(size.width, size.height) - strokeWidth) / 2;

    // 背景环
    final Paint bgPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, bgPaint);

    // 进度环
    final Paint progressPaint = Paint()
      ..color = valueColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // 从顶部开始
      2 * math.pi * value,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.valueColor != valueColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
