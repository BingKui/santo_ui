import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:santo_ui/src/components/badge/santo_badge.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 分段选择器尺寸
enum SantoSegmentedSize {
  /// 大号,轨道高度 40
  large,

  /// 中号(默认),轨道高度 32
  medium,

  /// 小号,轨道高度 24
  small,
}

/// 分段选择器排列方向
enum SantoSegmentedOrientation {
  /// 水平排列(默认)
  horizontal,

  /// 垂直排列
  vertical,
}

/// 分段选择器形状
enum SantoSegmentedShape {
  /// 圆角矩形(默认)
  rect,

  /// 胶囊形
  round,
}

/// 分段选择器的单个选项
class SantoSegmentedOption<T> {
  /// 选项值,与 [SantoSegmented.value] 比对判断是否选中
  final T value;

  /// 选项文案
  final String? label;

  /// 自定义选项内容,优先级高于 [label]
  final Widget? labelWidget;

  /// 选项图标,展示在文案左侧
  final Widget? icon;

  /// 是否禁用该选项
  final bool disabled;

  /// 长按提示文案
  final String? tooltip;

  /// 角标数字,大于 0 时展示在文案右侧,对标 antd Segmented 的 badge.count
  ///
  /// @since v1.1.1
  final int? badgeCount;

  /// 是否展示红点,与 [badgeCount] 同时设置时以红点为准
  ///
  /// @since v1.1.1
  final bool dot;

  const SantoSegmentedOption({
    required this.value,
    this.label,
    this.labelWidget,
    this.icon,
    this.disabled = false,
    this.tooltip,
    this.badgeCount,
    this.dot = false,
  }) : assert(
          label != null || labelWidget != null || icon != null,
          'SantoSegmentedOption 至少需要 label、labelWidget、icon 之一',
        );
}

/// 轨道内边距
const double kSantoSegmentedTrackPadding = 2;

/// 图标与文案之间的间距
const double kSantoSegmentedIconGap = 4;

/// 文案与角标之间的间距
const double kSantoSegmentedBadgeGap = 6;

/// 角标边长(红点直径为其一半)
const double kSantoSegmentedBadgeSize = 16;

/// 分段选择器:在多个选项中选择一个,切换时白色滑块在选项间滑动
///
/// 参考 antd Segmented:浅色轨道承载选项,选中项用白色滑块 + 阴影突出。
/// 传 [value] 为受控用法,传 [defaultValue] 为非受控用法(默认选中第一个未禁用项)。
///
/// 示例:
/// ```dart
/// SantoSegmented<String>(
///   value: _value,
///   options: const [
///     SantoSegmentedOption(value: 'day', label: '日'),
///     SantoSegmentedOption(value: 'week', label: '周'),
///   ],
///   onChanged: (value) => setState(() => _value = value),
/// )
/// ```
class SantoSegmented<T> extends StatefulWidget {
  /// 选项列表
  final List<SantoSegmentedOption<T>> options;

  /// 当前选中的值,传入时为受控用法
  final T? value;

  /// 默认选中的值,非受控用法下生效;为空时选中第一个未禁用项
  final T? defaultValue;

  /// 选中值变更回调;为 null 时不可交互
  final ValueChanged<T>? onChanged;

  /// 是否撑满父容器宽度
  final bool block;

  /// 是否禁用整个组件
  final bool disabled;

  /// 尺寸,默认中号
  final SantoSegmentedSize size;

  /// 排列方向,默认水平
  final SantoSegmentedOrientation orientation;

  /// 形状,默认圆角矩形
  final SantoSegmentedShape shape;

  /// 滑块滑动动画时长
  final Duration animationDuration;

  const SantoSegmented({
    Key? key,
    required this.options,
    this.value,
    this.defaultValue,
    this.onChanged,
    this.block = false,
    this.disabled = false,
    this.size = SantoSegmentedSize.medium,
    this.orientation = SantoSegmentedOrientation.horizontal,
    this.shape = SantoSegmentedShape.rect,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  State<SantoSegmented<T>> createState() => _SantoSegmentedState<T>();
}

class _SantoSegmentedState<T> extends State<SantoSegmented<T>> {
  final GlobalKey _groupKey = GlobalKey();
  final List<GlobalKey> _itemKeys = <GlobalKey>[];

  /// 非受控用法下的选中值
  T? _innerValue;

  /// 滑块相对选项组的矩形,为空时表示当前没有选中项
  Rect? _thumbRect;

  /// 首次定位不播动画,避免挂载时滑块从左上角滑入
  bool _thumbAnimated = false;
  bool _thumbSyncScheduled = false;

  bool get _isControlled => widget.value != null;

  T? get _selectedValue {
    if (_isControlled) {
      return widget.value;
    }
    if (_innerValue != null) {
      return _innerValue;
    }
    if (widget.defaultValue != null) {
      return widget.defaultValue;
    }
    for (final option in widget.options) {
      if (!option.disabled) {
        return option.value;
      }
    }
    return null;
  }

  @override
  void didUpdateWidget(SantoSegmented<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_innerValue != null &&
        !widget.options.any((option) => option.value == _innerValue)) {
      _innerValue = null;
    }
  }

  void _handleTap(SantoSegmentedOption<T> option) {
    if (!_isControlled) {
      setState(() => _innerValue = option.value);
    }
    widget.onChanged?.call(option.value);
  }

  double _trackHeight() {
    switch (widget.size) {
      case SantoSegmentedSize.large:
        return 40;
      case SantoSegmentedSize.medium:
        return 32;
      case SantoSegmentedSize.small:
        return 24;
    }
  }

  double _horizontalPadding(SantoCommonConfig commonConfig) {
    switch (widget.size) {
      case SantoSegmentedSize.small:
        return 7;
      case SantoSegmentedSize.large:
      case SantoSegmentedSize.medium:
        return commonConfig.hSpacingMd;
    }
  }

  void _syncItemKeys() {
    while (_itemKeys.length < widget.options.length) {
      _itemKeys.add(GlobalKey());
    }
    if (_itemKeys.length > widget.options.length) {
      _itemKeys.removeRange(widget.options.length, _itemKeys.length);
    }
  }

  /// 选项位置在布局完成后才能取到,这里在帧末同步滑块位置
  void _scheduleThumbSync() {
    if (_thumbSyncScheduled) {
      return;
    }
    _thumbSyncScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _thumbSyncScheduled = false;
      _syncThumbRect();
    });
  }

  void _syncThumbRect() {
    if (!mounted) {
      return;
    }
    final selectedValue = _selectedValue;
    final index = selectedValue == null
        ? -1
        : widget.options.indexWhere((option) => option.value == selectedValue);
    final groupBox = _groupKey.currentContext?.findRenderObject() as RenderBox?;
    if (groupBox == null || !groupBox.hasSize) {
      return;
    }
    if (index < 0 || index >= _itemKeys.length) {
      if (_thumbRect != null) {
        setState(() => _thumbRect = null);
      }
      return;
    }
    final itemBox =
        _itemKeys[index].currentContext?.findRenderObject() as RenderBox?;
    if (itemBox == null || !itemBox.hasSize) {
      return;
    }
    final rect =
        itemBox.localToGlobal(Offset.zero, ancestor: groupBox) & itemBox.size;
    if (_thumbRect == rect) {
      return;
    }
    setState(() => _thumbRect = rect);
    if (!_thumbAnimated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _thumbAnimated = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    _syncItemKeys();
    _scheduleThumbSync();

    final isHorizontal =
        widget.orientation == SantoSegmentedOrientation.horizontal;
    final trackHeight = _trackHeight();
    final labelHeight = trackHeight - kSantoSegmentedTrackPadding * 2;
    final trackRadius = widget.shape == SantoSegmentedShape.round
        ? trackHeight / 2
        : commonConfig.radiusLg;
    final itemRadius = widget.shape == SantoSegmentedShape.round
        ? labelHeight / 2
        : math.max(trackRadius - kSantoSegmentedTrackPadding, 0.0);

    final selectedValue = _selectedValue;
    final items = <Widget>[
      for (int index = 0; index < widget.options.length; index += 1)
        _buildItem(
          index: index,
          selectedValue: selectedValue,
          labelHeight: labelHeight,
          itemRadius: itemRadius,
          isHorizontal: isHorizontal,
          commonConfig: commonConfig,
        ),
    ];

    final group = isHorizontal
        ? Row(
            key: _groupKey,
            mainAxisSize: widget.block ? MainAxisSize.max : MainAxisSize.min,
            children: items,
          )
        : Column(
            key: _groupKey,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: items,
          );

    final thumbRect = _thumbRect;
    return Container(
      width: widget.block && isHorizontal ? double.infinity : null,
      padding: const EdgeInsets.all(kSantoSegmentedTrackPadding),
      decoration: BoxDecoration(
        color: commonConfig.fillBody,
        borderRadius: BorderRadius.circular(trackRadius),
      ),
      child: Stack(
        children: [
          if (thumbRect != null)
            AnimatedPositioned(
              duration:
                  _thumbAnimated ? widget.animationDuration : Duration.zero,
              curve: Curves.easeInOutCubic,
              left: thumbRect.left,
              top: thumbRect.top,
              width: thumbRect.width,
              height: thumbRect.height,
              child: _buildThumb(itemRadius, commonConfig),
            ),
          group,
        ],
      ),
    );
  }

  /// 选中项背后的白色滑块
  Widget _buildThumb(double itemRadius, SantoCommonConfig commonConfig) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: commonConfig.fillBase,
        borderRadius: BorderRadius.circular(itemRadius),
        boxShadow: [
          BoxShadow(
            color: commonConfig.shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required int index,
    required T? selectedValue,
    required double labelHeight,
    required double itemRadius,
    required bool isHorizontal,
    required SantoCommonConfig commonConfig,
  }) {
    final option = widget.options[index];
    final isSelected = option.value == selectedValue;
    final isDisabled = widget.disabled || option.disabled;
    final isInteractive = !isDisabled && widget.onChanged != null;

    final textColor = isDisabled
        ? commonConfig.colorTextDisabled
        : isSelected
            ? commonConfig.colorTextBase
            : commonConfig.colorTextImportant;
    final fontSize = widget.size == SantoSegmentedSize.large
        ? commonConfig.fontSizeSubHead
        : commonConfig.fontSizeBase;

    final hasLabel = option.label != null || option.labelWidget != null;
    final hasBadge = option.dot || (option.badgeCount ?? 0) > 0;
    // 高度交给 minHeight 约束,不用 Center/Align 包裹:宽松约束下它们会撑满可用高度
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (option.icon != null)
          IconTheme(
            data: IconThemeData(color: textColor, size: fontSize + 2),
            child: option.icon!,
          ),
        if (option.icon != null && hasLabel)
          const SizedBox(width: kSantoSegmentedIconGap),
        if (hasLabel)
          Flexible(
            child: option.labelWidget ??
                Text(
                  option.label!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: textColor, fontSize: fontSize),
                ),
          ),
        if (hasBadge) ...[
          const SizedBox(width: kSantoSegmentedBadgeGap),
          SantoBadge(
            count: option.badgeCount,
            isDot: option.dot,
            badgeSize: kSantoSegmentedBadgeSize,
          ),
        ],
      ],
    );

    content = ConstrainedBox(
      constraints: BoxConstraints(minHeight: labelHeight),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: _horizontalPadding(commonConfig)),
        child: content,
      ),
    );

    Widget item = MergeSemantics(
      child: Semantics(
        button: true,
        selected: isSelected,
        enabled: isInteractive,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(itemRadius),
            onTap: isInteractive ? () => _handleTap(option) : null,
            child: content,
          ),
        ),
      ),
    );

    if (option.tooltip != null) {
      item = Tooltip(message: option.tooltip!, child: item);
    }

    final keyedItem = KeyedSubtree(key: _itemKeys[index], child: item);
    return widget.block && isHorizontal
        ? Expanded(child: keyedItem)
        : keyedItem;
  }
}
