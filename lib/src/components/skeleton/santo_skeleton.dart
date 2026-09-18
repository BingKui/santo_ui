import 'dart:async';

import 'package:flutter/material.dart';

import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
// import 'package:santo_ui/src/theme/configs/santo_common_config.dart';

/// 骨架屏动画类型
enum SantoSkeletonAnimation {
  /// 无动画
  none,

  /// 渐变扫光(默认)
  gradient,

  /// 闪烁
  flashed,
}

/// 骨架屏预设主题
enum SantoSkeletonTheme {
  /// 文本骨架
  text,

  /// 头像骨架
  avatar,

  /// 图片骨架
  image,

  /// 宫格骨架
  grid,
}

/// 占位块形状
enum SantoSkeletonObjType {
  /// 文本条(默认,小圆角)
  text,

  /// 圆形
  circle,

  /// 矩形
  rect,

  /// 空白占位符(配合 flex 撑开)
  spacer,
}

/// 占位块样式
class SantoSkeletonObjStyle {
  /// 形状
  final SantoSkeletonObjType type;

  /// 背景色,默认使用主题 fillBody
  final Color? backgroundColor;

  /// 圆角;null 时按形状取默认值(text 4 / circle 全圆 / rect 12)
  final double? radius;

  const SantoSkeletonObjStyle({
    this.type = SantoSkeletonObjType.text,
    this.backgroundColor,
    this.radius,
  });

  /// 圆形占位
  const SantoSkeletonObjStyle.circle({Color? backgroundColor})
      : this(type: SantoSkeletonObjType.circle, backgroundColor: backgroundColor);

  /// 矩形占位
  const SantoSkeletonObjStyle.rect({Color? backgroundColor, double? radius})
      : this(
            type: SantoSkeletonObjType.rect,
            backgroundColor: backgroundColor,
            radius: radius);

  /// 空白占位
  const SantoSkeletonObjStyle.spacer()
      : this(type: SantoSkeletonObjType.spacer);

  /// 文本条占位
  const SantoSkeletonObjStyle.text({Color? backgroundColor, double? radius})
      : this(
            type: SantoSkeletonObjType.text,
            backgroundColor: backgroundColor,
            radius: radius);
}

/// 行列占位对象
class SantoSkeletonRowColObj {
  /// 弹性因子,默认 1;为 null 时按 [width] 固定宽度
  final int? flex;

  /// 固定宽度
  final double? width;

  /// 高度,默认 16
  final double height;

  /// 外边距
  final EdgeInsetsGeometry margin;

  /// 样式
  final SantoSkeletonObjStyle style;

  const SantoSkeletonRowColObj({
    this.flex = 1,
    this.width,
    this.height = 16,
    this.margin = EdgeInsets.zero,
    this.style = const SantoSkeletonObjStyle(),
  });

  /// 圆形占位(如头像)
  const SantoSkeletonRowColObj.circle({
    double size = 48,
    EdgeInsetsGeometry margin = EdgeInsets.zero,
    SantoSkeletonObjStyle style = const SantoSkeletonObjStyle.circle(),
  })  : flex = null,
        width = size,
        height = size,
        margin = margin,
        style = style;

  /// 矩形占位(如图片)
  const SantoSkeletonRowColObj.rect({
    double? width,
    double height = 48,
    EdgeInsetsGeometry margin = EdgeInsets.zero,
    SantoSkeletonObjStyle style = const SantoSkeletonObjStyle.rect(),
  })  : flex = width == null ? 1 : null,
        width = width,
        height = height,
        margin = margin,
        style = style;

  /// 空白占位符
  const SantoSkeletonRowColObj.spacer({int flex = 1})
      : this(flex: flex, height: 0, style: const SantoSkeletonObjStyle.spacer());

  /// 文本条
  const SantoSkeletonRowColObj.text({
    int? flex = 1,
    double? width,
    double height = 16,
    EdgeInsetsGeometry margin = EdgeInsets.zero,
  })  : this(
            flex: flex,
            width: width,
            height: height,
            margin: margin,
            style: const SantoSkeletonObjStyle.text());
}

/// 行列骨架结构:多个 Row,每个 Row 内为多个 Obj
class SantoSkeletonRowCol {
  /// 行列对象,外层为行,内层为列
  final List<List<SantoSkeletonRowColObj>> objects;

  /// 行间距,默认 16
  final double rowSpacing;

  const SantoSkeletonRowCol({
    required this.objects,
    this.rowSpacing = 16,
  });
}

/// 骨架屏组件(API 参考 TDesign Flutter 的 Skeleton)
///
/// 支持预设主题 [SantoSkeletonTheme](text/avatar/image/grid) 与自定义行列
/// [SantoSkeleton.fromRowCol],支持渐变扫光/闪烁动画与延迟显示。
///
/// 示例:
/// ```dart
/// SantoSkeleton(theme: SantoSkeletonTheme.avatar)
///
/// SantoSkeleton.fromRowCol(
///   rowCol: SantoSkeletonRowCol(objects: [
///     [SantoSkeletonRowColObj.rect(width: 48, height: 48)],
///     [SantoSkeletonRowColObj(), SantoSkeletonRowColObj.spacer()],
///   ]),
/// )
/// ```
class SantoSkeleton extends StatefulWidget {
  /// 预设主题,默认文本骨架;设置 [rowCol] 时失效
  final SantoSkeletonTheme theme;

  /// 自定义行列结构
  final SantoSkeletonRowCol? rowCol;

  /// 动画类型,默认渐变扫光
  final SantoSkeletonAnimation animation;

  /// 延迟显示毫秒数,默认 0(立即显示)
  final int delay;

  const SantoSkeleton({
    Key? key,
    this.theme = SantoSkeletonTheme.text,
    this.animation = SantoSkeletonAnimation.gradient,
    this.delay = 0,
  })  : rowCol = null,
        super(key: key);

  /// 从行列框架创建骨架屏
  const SantoSkeleton.fromRowCol({
    Key? key,
    required SantoSkeletonRowCol rowCol,
    this.animation = SantoSkeletonAnimation.gradient,
    this.delay = 0,
  })  : theme = SantoSkeletonTheme.text,
        rowCol = rowCol,
        super(key: key);

  @override
  State<SantoSkeleton> createState() => _SantoSkeletonState();
}

class _SantoSkeletonState extends State<SantoSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _visible = true;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    if (widget.animation != SantoSkeletonAnimation.none) {
      _controller.repeat();
    }
    if (widget.delay > 0) {
      _visible = false;
      _delayTimer = Timer(Duration(milliseconds: widget.delay), () {
        if (mounted) setState(() => _visible = true);
      });
    }
  }

  @override
  void didUpdateWidget(covariant SantoSkeleton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animation != oldWidget.animation) {
      if (widget.animation == SantoSkeletonAnimation.none) {
        _controller.stop();
      } else {
        _controller.repeat();
      }
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Color get _baseColor =>
      SantoThemeConfigurator.instance.getConfig().commonConfig.fillBody;

  SantoSkeletonRowCol get _rowCol =>
      widget.rowCol ?? _themeRowCol(widget.theme);

  SantoSkeletonRowCol _themeRowCol(SantoSkeletonTheme theme) {
    switch (theme) {
      case SantoSkeletonTheme.text:
        return SantoSkeletonRowCol(objects: const [
          [SantoSkeletonRowColObj.text()],
          [SantoSkeletonRowColObj.text()],
          [SantoSkeletonRowColObj.text(flex: 3)],
        ]);
      case SantoSkeletonTheme.avatar:
        return SantoSkeletonRowCol(objects: const [
          [
            SantoSkeletonRowColObj.circle(size: 48),
            SantoSkeletonRowColObj.text(),
          ],
          [
            SantoSkeletonRowColObj.spacer(),
            SantoSkeletonRowColObj.text(flex: 3),
          ],
        ], rowSpacing: 12);
      case SantoSkeletonTheme.image:
        return SantoSkeletonRowCol(objects: const [
          [SantoSkeletonRowColObj.rect(height: 120)],
          [SantoSkeletonRowColObj.text(flex: 3)],
        ]);
      case SantoSkeletonTheme.grid:
        return SantoSkeletonRowCol(objects: const [
          [
            SantoSkeletonRowColObj.circle(size: 40),
            SantoSkeletonRowColObj.spacer(),
            SantoSkeletonRowColObj.circle(size: 40),
            SantoSkeletonRowColObj.spacer(),
            SantoSkeletonRowColObj.circle(size: 40),
          ],
          [
            SantoSkeletonRowColObj.text(height: 12),
            SantoSkeletonRowColObj.spacer(),
            SantoSkeletonRowColObj.text(height: 12),
            SantoSkeletonRowColObj.spacer(),
            SantoSkeletonRowColObj.text(height: 12),
          ],
        ], rowSpacing: 12);
    }
  }

  Widget _buildObj(SantoSkeletonRowColObj obj) {
    if (obj.style.type == SantoSkeletonObjType.spacer) {
      return const SizedBox.shrink();
    }
    double radius;
    switch (obj.style.type) {
      case SantoSkeletonObjType.circle:
        radius = obj.style.radius ?? 999;
        break;
      case SantoSkeletonObjType.rect:
        radius = obj.style.radius ?? 12;
        break;
      default:
        radius = obj.style.radius ?? 4;
        break;
    }
    Widget block = Container(
      width: obj.flex == null ? obj.width : null,
      height: obj.height,
      margin: obj.margin,
      decoration: BoxDecoration(
        color: obj.style.backgroundColor ?? _baseColor,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
    if (obj.flex != null) {
      block = Expanded(flex: obj.flex!, child: block);
    }
    return block;
  }

  Widget _buildRowCol(SantoSkeletonRowCol rowCol) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < rowCol.objects.length; i++) ...[
          if (i > 0) SizedBox(height: rowCol.rowSpacing),
          Row(
            children: [
              for (final obj in rowCol.objects[i])
                obj.style.type == SantoSkeletonObjType.spacer
                    ? Expanded(flex: obj.flex ?? 1, child: const SizedBox())
                    : _buildObj(obj),
            ],
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();

    Widget skeleton = _buildRowCol(_rowCol);

    switch (widget.animation) {
      case SantoSkeletonAnimation.none:
        break;
      case SantoSkeletonAnimation.gradient:
        skeleton = AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return ShaderMask(
              blendMode: BlendMode.srcATop,
              shaderCallback: (bounds) {
                final dx = (bounds.width * 2) * (_controller.value - 0.5);
                return LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.white.withAlpha(0xB3),
                    Colors.transparent,
                  ],
                ).createShader(bounds.shift(Offset(dx, 0)));
              },
              child: child,
            );
          },
          child: skeleton,
        );
        break;
      case SantoSkeletonAnimation.flashed:
        skeleton = AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: 0.4 + 0.6 * _controller.value,
              child: child,
            );
          },
          child: skeleton,
        );
        break;
    }

    return skeleton;
  }
}
