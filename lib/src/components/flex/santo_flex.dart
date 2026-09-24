import 'package:santo_ui/src/components/space/santo_space.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// Flex 排列方向
enum SantoFlexOrientation {
  /// 水平排列(默认)
  horizontal,

  /// 垂直排列
  vertical,
}

/// 弹性布局组件(参考 antd Flex)
///
/// 与 [SantoSpace] 的区别:Space 用于行内元素的等间距排列(每个子元素包一层),
/// Flex 用于块级元素的布局,不增加额外包装节点,提供更灵活的对齐与伸缩控制。
///
/// 示例:
/// ```dart
/// SantoFlex(gapSize: SantoSpaceSize.middle, children: [...])
/// SantoFlex(orientation: SantoFlexOrientation.vertical, align: CrossAxisAlignment.stretch, ...)
/// SantoFlex(justify: MainAxisAlignment.spaceBetween, ...)
/// SantoFlex(wrap: true, ...)
/// ```
class SantoFlex extends StatelessWidget {
  /// 排列方向,默认水平
  final SantoFlexOrientation orientation;

  /// 是否换行,默认 false(单行/单列)
  final bool wrap;

  /// 主轴对齐方式,默认 start
  final MainAxisAlignment justify;

  /// 交叉轴对齐方式。
  /// 为 null 时按 antd 默认行为:水平方向 start(向上对齐),垂直方向 stretch
  final CrossAxisAlignment? align;

  /// 子元素统一伸缩值,非 null 时每个子元素包一层 `Expanded(flex: flex)`
  final int? flex;

  /// 间距档位,取主题间距 token(默认 10/15/20);设置 [gap] 时失效
  final SantoSpaceSize? gapSize;

  /// 自定义间距值,优先于 [gapSize]
  final double? gap;

  /// 子组件列表
  final List<Widget> children;

  const SantoFlex({
    Key? key,
    this.orientation = SantoFlexOrientation.horizontal,
    this.wrap = false,
    this.justify = MainAxisAlignment.start,
    this.align,
    this.flex,
    this.gapSize,
    this.gap,
    required this.children,
  })  : assert(flex == null || flex > 0, 'flex 必须大于 0'),
        super(key: key);

  bool get _isVertical => orientation == SantoFlexOrientation.vertical;

  double get _gap {
    if (gap != null) return gap!;
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return switch (gapSize) {
      SantoSpaceSize.small => _isVertical
          ? commonConfig.vSpacingSm
          : commonConfig.hSpacingSm,
      SantoSpaceSize.middle => _isVertical
          ? commonConfig.vSpacingMd
          : commonConfig.hSpacingMd,
      SantoSpaceSize.large => _isVertical
          ? commonConfig.vSpacingLg
          : commonConfig.hSpacingLg,
      null => 0,
    };
  }

  CrossAxisAlignment get _crossAlignment =>
      align ??
      (_isVertical ? CrossAxisAlignment.stretch : CrossAxisAlignment.start);

  @override
  Widget build(BuildContext context) {
    List<Widget> kids = children;
    if (flex != null) {
      kids = [for (final child in children) Expanded(flex: flex!, child: child)];
    }
    if (_gap > 0) {
      final List<Widget> spaced = [];
      for (int i = 0; i < kids.length; i++) {
        spaced.add(kids[i]);
        if (i < kids.length - 1) {
          spaced.add(SizedBox(
            width: _isVertical ? 0 : _gap,
            height: _isVertical ? _gap : 0,
          ));
        }
      }
      kids = spaced;
    }

    if (wrap) {
      return Wrap(
        direction: _isVertical ? Axis.vertical : Axis.horizontal,
        spacing: _gap,
        runSpacing: _gap,
        alignment: _wrapAlignment,
        crossAxisAlignment: _wrapCrossAlignment,
        children: kids,
      );
    }

    return Flex(
      direction: _isVertical ? Axis.vertical : Axis.horizontal,
      mainAxisAlignment: justify,
      crossAxisAlignment: _crossAlignment,
      children: kids,
    );
  }

  WrapAlignment get _wrapAlignment {
    switch (justify) {
      case MainAxisAlignment.start:
        return WrapAlignment.start;
      case MainAxisAlignment.end:
        return WrapAlignment.end;
      case MainAxisAlignment.center:
        return WrapAlignment.center;
      case MainAxisAlignment.spaceBetween:
        return WrapAlignment.spaceBetween;
      case MainAxisAlignment.spaceAround:
        return WrapAlignment.spaceAround;
      case MainAxisAlignment.spaceEvenly:
        return WrapAlignment.spaceEvenly;
    }
  }

  WrapCrossAlignment get _wrapCrossAlignment {
    switch (_crossAlignment) {
      case CrossAxisAlignment.start:
        return WrapCrossAlignment.start;
      case CrossAxisAlignment.end:
        return WrapCrossAlignment.end;
      case CrossAxisAlignment.center:
        return WrapCrossAlignment.center;
      default:
        return WrapCrossAlignment.start;
    }
  }
}
