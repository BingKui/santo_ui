import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// Space 方向
enum SantoSpaceDirection {
  /// 水平排列
  horizontal,

  /// 垂直排列
  vertical,
}

/// Space 间距档位
///
/// 三档取主题间距 token:水平方向取 `hSpacingSm / hSpacingMd / hSpacingLg`,
/// 垂直方向取 `vSpacingSm / vSpacingMd / vSpacingLg`(默认 10/15/20)。
enum SantoSpaceSize {
  /// 小间距,取主题 hSpacingSm / vSpacingSm
  small,

  /// 中间距,取主题 hSpacingMd / vSpacingMd(默认)
  middle,

  /// 大间距,取主题 hSpacingLg / vSpacingLg
  large,
}

/// 间距组件:为多个元素之间统一增加水平/垂直 gap,参考 Ant Design 的 Space。
///
/// 示例:
/// ```dart
/// SantoSpace(
///   direction: SantoSpaceDirection.horizontal,
///   size: SantoSpaceSize.middle,
///   children: [Text('A'), Text('B'), Text('C')],
/// )
///
/// // 自定义间距
/// SantoSpace(direction: SantoSpaceDirection.vertical, customSize: 32, children: [...])
///
/// // 超出换行
/// SantoSpace(wrap: true, children: [...])
/// ```
class SantoSpace extends StatelessWidget {
  /// 排列方向,默认水平
  final SantoSpaceDirection direction;

  /// 间距档位,默认 middle;设置 [customSize] 时失效
  final SantoSpaceSize size;

  /// 自定义间距值,优先级高于 [size]
  final double? customSize;

  /// 是否自动换行(仅水平方向生效)
  final bool wrap;

  /// 子组件列表
  final List<Widget> children;

  /// 主轴对齐方式,默认 start
  final MainAxisAlignment mainAxisAlignment;

  /// 交叉轴对齐方式,默认 start;水平方向为垂直对齐
  final CrossAxisAlignment crossAxisAlignment;

  const SantoSpace({
    Key? key,
    this.direction = SantoSpaceDirection.horizontal,
    this.size = SantoSpaceSize.middle,
    this.customSize,
    this.wrap = false,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  }) : super(key: key);

  /// 生成一个固定间距的空隙
  const SantoSpace.gap(
    double gap, {
    Key? key,
    this.direction = SantoSpaceDirection.horizontal,
  })  : size = SantoSpaceSize.middle,
        customSize = gap,
        wrap = false,
        children = const [],
        mainAxisAlignment = MainAxisAlignment.start,
        crossAxisAlignment = CrossAxisAlignment.start,
        super(key: key);

  double get _gap {
    if (customSize != null) return customSize!;
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final bool isHorizontal = direction == SantoSpaceDirection.horizontal;
    return switch (size) {
      SantoSpaceSize.small =>
        isHorizontal ? commonConfig.hSpacingSm : commonConfig.vSpacingSm,
      SantoSpaceSize.middle =>
        isHorizontal ? commonConfig.hSpacingMd : commonConfig.vSpacingMd,
      SantoSpaceSize.large =>
        isHorizontal ? commonConfig.hSpacingLg : commonConfig.vSpacingLg,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      // 仅作为固定间距使用(SantoSpace.gap)
      return SizedBox(
        width: direction == SantoSpaceDirection.horizontal ? _gap : 0,
        height: direction == SantoSpaceDirection.vertical ? _gap : 0,
      );
    }

    final isHorizontal = direction == SantoSpaceDirection.horizontal;
    if (isHorizontal && wrap) {
      return Wrap(
        spacing: _gap,
        runSpacing: _gap,
        alignment: _wrapAlignment,
        crossAxisAlignment: _wrapCrossAlignment,
        children: children,
      );
    }

    final List<Widget> spaced = [];
    for (int i = 0; i < children.length; i++) {
      spaced.add(children[i]);
      if (i < children.length - 1) {
        spaced.add(SizedBox(
          width: isHorizontal ? _gap : 0,
          height: isHorizontal ? 0 : _gap,
        ));
      }
    }

    return Flex(
      direction: isHorizontal ? Axis.horizontal : Axis.vertical,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: spaced,
    );
  }

  WrapAlignment get _wrapAlignment {
    switch (mainAxisAlignment) {
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
    switch (crossAxisAlignment) {
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
