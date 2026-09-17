import 'package:flutter/material.dart';

import 'package:santo_ui/src/components/skeleton/santo_skeleton.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 统计数值占位线的宽度比例
const int _kSantoStatisticSkeletonFlex = 3;

/// 数值格式化:按 antd Statistic 的 Number 实现做千分位分组与精度补零
///
/// 非数字内容(含 `12.5万`、`abc` 这类字符串)原样返回;`precision` 只补零与截断,不做四舍五入。
String _formatStatisticValue(
  Object? value, {
  int? precision,
  String groupSeparator = ',',
  String decimalSeparator = '.',
}) {
  final raw = _stringifyValue(value);
  final cells = RegExp(r'^(-?)(\d*)(\.(\d+))?$').firstMatch(raw);
  if (cells == null || raw == '-') {
    return raw;
  }
  final negative = cells.group(1) ?? '';
  final intPart = (cells.group(2)?.isEmpty ?? true ? '0' : cells.group(2)!)
      .replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (match) => groupSeparator,
      );
  var decimal = cells.group(4) ?? '';
  if (precision != null) {
    decimal = precision > 0
        ? decimal.padRight(precision, '0').substring(0, precision)
        : '';
  }
  final decimalPart = decimal.isEmpty ? '' : '$decimalSeparator$decimal';
  return '$negative$intPart$decimalPart';
}

/// Dart 的 double 整数值会带 `.0`,这里对齐 JS 的字符串化行为
String _stringifyValue(Object? value) {
  if (value == null) {
    return '';
  }
  if (value is double && value.isFinite && value == value.roundToDouble()) {
    return value.toInt().toString();
  }
  return value.toString();
}

/// 统计数值:突出展示带标题的数值,支持前后缀、精度与千分位
///
/// 参考 antd Statistic:标题在上、数值在下,数值默认做千分位分组。
/// 只做展示不做动画,数值变化时的数字滚动由使用方自行处理。
///
/// 示例:
/// ```dart
/// SantoStatistic(
///   title: '活跃用户',
///   value: 112893,
///   precision: 2,
///   suffix: const Text('人'),
/// )
/// ```
class SantoStatistic extends StatelessWidget {
  /// 标题文案
  final String? title;

  /// 自定义标题,优先级高于 [title]
  final Widget? titleWidget;

  /// 数值,支持 num 与 String;非数字字符串原样展示
  final Object? value;

  /// 保留的小数位数,只补零与截断,不四舍五入
  final int? precision;

  /// 数值前缀
  final Widget? prefix;

  /// 数值后缀
  final Widget? suffix;

  /// 千分位分隔符,默认 `,`
  final String groupSeparator;

  /// 小数分隔符,默认 `.`
  final String decimalSeparator;

  /// 自定义数值内容,传入后不再走内置格式化
  final Widget Function(Object? value)? formatter;

  /// 是否展示加载态,加载时数值区域显示骨架占位
  final bool loading;

  /// 标题文字样式
  final TextStyle? titleStyle;

  /// 数值文字样式
  final TextStyle? valueStyle;

  const SantoStatistic({
    Key? key,
    this.title,
    this.titleWidget,
    this.value = 0,
    this.precision,
    this.prefix,
    this.suffix,
    this.groupSeparator = ',',
    this.decimalSeparator = '.',
    this.formatter,
    this.loading = false,
    this.titleStyle,
    this.valueStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final titleTextStyle = titleStyle ??
        TextStyle(
          color: commonConfig.colorTextSecondary,
          fontSize: commonConfig.fontSizeBase,
        );
    final valueTextStyle = valueStyle ??
        TextStyle(
          color: commonConfig.colorTextBase,
          fontSize: commonConfig.fontSizeHeadLg,
        );

    final Widget? titleContent = (title == null && titleWidget == null)
        ? null
        : DefaultTextStyle(
            style: titleTextStyle,
            child: titleWidget ?? Text(title!),
          );

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (prefix != null) ...[
          prefix!,
          SizedBox(width: commonConfig.hSpacingXs),
        ],
        Flexible(child: _buildValue(valueTextStyle, commonConfig.fontSizeHeadLg)),
        if (suffix != null) ...[
          SizedBox(width: commonConfig.hSpacingXs),
          suffix!,
        ],
      ],
    );
    content = DefaultTextStyle(
      style: valueTextStyle,
      child: IconTheme(
        data: IconThemeData(color: valueTextStyle.color),
        child: content,
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (titleContent != null)
          Padding(
            padding: EdgeInsets.only(bottom: commonConfig.vSpacingXs),
            child: titleContent,
          ),
        content,
      ],
    );
  }

  Widget _buildValue(TextStyle valueTextStyle, double fallbackFontSize) {
    if (loading) {
      return SantoSkeleton.fromRowCol(
        rowCol: SantoSkeletonRowCol(
          objects: [
            [
              SantoSkeletonRowColObj.text(
                flex: _kSantoStatisticSkeletonFlex,
                height: valueTextStyle.fontSize ?? fallbackFontSize,
              ),
            ],
          ],
          rowSpacing: 0,
        ),
      );
    }
    final customFormatter = formatter;
    if (customFormatter != null) {
      return customFormatter(value);
    }
    return Text(
      _formatStatisticValue(
        value,
        precision: precision,
        groupSeparator: groupSeparator,
        decimalSeparator: decimalSeparator,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
