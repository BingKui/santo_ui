import 'package:flutter/material.dart';

import 'package:santo_ui/src/components/checkbox/santo_checkbox_group.dart';
import 'package:santo_ui/src/components/line/santo_line.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 复选框勾选样式
enum SantoCheckboxStyle {
  /// 圆形
  circle,

  /// 方形
  square,

  /// 无背景勾选(仅对号)
  check,
}

/// 内容相对指示器的方位
enum SantoContentDirection {
  /// 内容在指示器左边
  left,

  /// 内容在指示器右边
  right,
}

/// 复选框尺寸
enum SantoCheckBoxSize {
  /// 大,行高 56
  large,

  /// 小,行高 48
  small,
}

/// 自定义指示器
typedef SantoCheckboxIconBuilder = Widget? Function(
    BuildContext context, bool checked);

/// 完全自定义内容
typedef SantoCheckboxContentBuilder = Widget Function(
    BuildContext context, bool checked, String? content);

/// 勾选状态变化监听
typedef SantoCheckboxValueChanged = void Function(bool checked);

/// 复选框
///
/// 内置三种勾选样式([SantoCheckboxStyle]):圆形、方形、无背景对号;
/// 支持主/副标题、内容方位、卡片模式、底部分割线,也可完全自定义指示器与内容。
/// 嵌入 [SantoCheckboxGroup]/[SantoCheckboxGroupContainer] 且设置了 [id] 时,
/// 勾选状态交给分组管理。
class SantoCheckbox extends StatefulWidget {
  const SantoCheckbox({
    Key? key,
    this.id,
    this.title,
    this.subTitle,
    this.titleStyle,
    this.subTitleStyle,
    this.enable = true,
    this.checked = false,
    this.titleMaxLine,
    this.subTitleMaxLine = 1,
    this.customIconBuilder,
    this.customContentBuilder,
    this.insetSpacing,
    this.style,
    this.spacing,
    this.backgroundColor,
    this.selectColor,
    this.disableColor,
    this.size = SantoCheckBoxSize.small,
    this.cardMode = false,
    this.showDivider = true,
    this.contentDirection = SantoContentDirection.right,
    this.onChanged,
    this.titleColor,
    this.subTitleColor,
    this.checkBoxLeftSpace,
    this.customSpace,
  }) : super(key: key);

  /// 标识;嵌入分组时必填,否则不纳入分组管理
  final String? id;

  /// 主标题
  final String? title;

  /// 主标题字体样式
  final TextStyle? titleStyle;

  /// 副标题
  final String? subTitle;

  /// 副标题字体样式
  final TextStyle? subTitleStyle;

  /// 是否可用,false 时置灰且不可点击
  final bool enable;

  /// 选中状态;嵌入分组时表示初始状态,后续由分组管理
  final bool checked;

  /// 主标题最大行数
  final int? titleMaxLine;

  /// 副标题最大行数
  final int? subTitleMaxLine;

  /// 自定义指示器
  final SantoCheckboxIconBuilder? customIconBuilder;

  /// 完全自定义内容
  final SantoCheckboxContentBuilder? customContentBuilder;

  /// 文字与组件边缘的距离
  final double? insetSpacing;

  /// 勾选样式,默认圆形
  final SantoCheckboxStyle? style;

  /// 指示器与内容的距离
  final double? spacing;

  /// 背景色
  final Color? backgroundColor;

  /// 选中颜色
  final Color? selectColor;

  /// 禁用选中颜色
  final Color? disableColor;

  /// 尺寸
  final SantoCheckBoxSize size;

  /// 卡片模式
  final bool cardMode;

  /// 是否显示底部分割线;卡片模式不显示
  final bool showDivider;

  /// 内容相对指示器的方位
  final SantoContentDirection contentDirection;

  /// 勾选状态变化监听
  final SantoCheckboxValueChanged? onChanged;

  /// 主标题颜色
  final Color? titleColor;

  /// 副标题颜色
  final Color? subTitleColor;

  /// 指示器额外左侧间距
  final double? checkBoxLeftSpace;

  /// 自定义组件内边距
  final EdgeInsetsGeometry? customSpace;

  /// 默认指示器
  Widget buildDefaultIcon(
      BuildContext context, SantoCheckboxGroupState? groupState, bool isChecked) {
    final style =
        this.style ?? groupState?.widget.style ?? SantoCheckboxStyle.circle;
    // 卡片模式不显示指示器,选中态由卡片边框与角标表达
    if (cardMode) return const SizedBox.shrink();

    final commonConfig = _commonConfig();
    final unselectedColor = style == SantoCheckboxStyle.check
        ? Colors.transparent
        : commonConfig.borderColorBase;

    final Color color;
    if (!enable) {
      color = isChecked
          ? (disableColor ?? commonConfig.brandPrimary.withAlpha(0x4D))
          : unselectedColor;
    } else {
      color = isChecked
          ? (selectColor ?? commonConfig.brandPrimary)
          : unselectedColor;
    }

    final IconData iconData = style == SantoCheckboxStyle.square
        ? (isChecked ? Icons.check_box : Icons.check_box_outline_blank)
        : style == SantoCheckboxStyle.check
            ? Icons.check
            : (isChecked ? Icons.check_circle : Icons.radio_button_unchecked);

    return SizedBox(
      width: SantoCheckboxState.indicatorSize,
      height: SantoCheckboxState.indicatorSize,
      child: Icon(iconData,
          size: SantoCheckboxState.indicatorSize, color: color),
    );
  }

  static SantoCommonConfig _commonConfig() =>
      SantoThemeConfigurator.instance.getConfig().commonConfig;

  @override
  State<SantoCheckbox> createState() => SantoCheckboxState();
}

class SantoCheckboxState extends State<SantoCheckbox> {
  /// 指示器尺寸
  static const double indicatorSize = 24;

  /// 卡片圆角
  static const double cardRadius = 12;

  /// 卡片左上角角标尺寸
  static const double cornerLength = 28;

  /// 当前勾选状态;分组内由分组维护
  bool checked = false;

  bool _pressed = false;

  /// 严格模式下只能切换、不能取消勾选(单选使用)
  bool canNotCancel = false;

  SantoCommonConfig get _commonConfig =>
      SantoThemeConfigurator.instance.getConfig().commonConfig;

  bool get _disabled => !widget.enable;

  @override
  void initState() {
    checked = widget.checked;
    super.initState();
  }

  @override
  void didUpdateWidget(SantoCheckbox oldWidget) {
    checked = widget.checked;
    super.didUpdateWidget(oldWidget);
  }

  double _contentMinHeight() =>
      widget.size == SantoCheckBoxSize.large ? 56 : 48;

  /// 组件内边距:左右为 insetSpacing,上下按尺寸;卡片模式只留顶部
  EdgeInsets _contentPadding(double insetSpacing) {
    if (widget.cardMode) {
      return EdgeInsets.symmetric(horizontal: insetSpacing, vertical: 16 - 1.5);
    }
    return EdgeInsets.symmetric(
      horizontal: insetSpacing,
      vertical: widget.size == SantoCheckBoxSize.large ? 16 : 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 嵌入分组且设置了 id 时,勾选状态由分组管理
    final groupState = SantoCheckboxGroupInherited.of(context)?.state;
    if (groupState != null && widget.id != null) {
      checked = groupState.getCheckBoxStateById(widget.id!, checked);
    }

    final icon = _buildIcon(context, groupState);
    final content = _buildContent(context, groupState);
    final hasContent = content != null;

    Widget tile = _buildTile(context, groupState, icon, content);
    if (widget.cardMode) {
      tile = _buildCardWrapper(tile);
    }

    if (!_disabled && !(canNotCancel && checked)) {
      Widget tappable = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (_) => _pressState(true),
        onTapUp: (_) => _pressState(false),
        onTapCancel: () => _pressState(false),
        onTap: () => _handleTap(groupState),
        child: tile,
      );
      if (_pressed) {
        tappable = Opacity(opacity: 0.68, child: tappable);
      }
      tile = tappable;
    }

    if (!widget.showDivider || widget.cardMode) {
      return Semantics(enabled: !_disabled, checked: checked, child: tile);
    }
    // 分割线覆盖在底部,不额外占位
    return Semantics(
      enabled: !_disabled,
      checked: checked,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [tile, _buildDivider(groupState, hasContent)],
      ),
    );
  }

  /// 点击切换勾选状态
  void _handleTap(SantoCheckboxGroupState? groupState) {
    if (_disabled) return;
    if (widget.onChanged == null && groupState == null) return;
    final next = !checked;
    if (groupState != null && widget.id != null) {
      // 超出分组最大勾选数时分组会回调 onOverloadChecked,此处保持原状态
      if (!groupState.toggle(widget.id!, next, true)) return;
    }
    setState(() => checked = next);
    widget.onChanged?.call(next);
  }

  void _pressState(bool pressed) {
    if (_disabled) return;
    setState(() => _pressed = pressed);
  }

  Widget _buildTile(
    BuildContext context,
    SantoCheckboxGroupState? groupState,
    Widget? icon,
    Widget? content,
  ) {
    if (icon == null) return content ?? const SizedBox.shrink();

    final spacing = widget.spacing ?? groupState?.widget.spacing ?? 8;
    final direction =
        groupState?.widget.contentDirection ?? widget.contentDirection;
    final insetSpacing = widget.insetSpacing ?? 16;

    if (content == null) {
      return Padding(
        padding: widget.customSpace ?? EdgeInsets.zero,
        child: icon,
      );
    }

    final iconBox = Padding(
      padding: direction == SantoContentDirection.right
          ? EdgeInsets.only(left: widget.checkBoxLeftSpace ?? 0)
          : EdgeInsets.only(right: widget.checkBoxLeftSpace ?? 0),
      child: icon,
    );
    final gap = widget.cardMode ? 0.0 : spacing;

    return Container(
      constraints:
          widget.cardMode ? null : BoxConstraints(minHeight: _contentMinHeight()),
      padding: widget.customSpace ?? _contentPadding(insetSpacing),
      color: widget.cardMode
          ? null
          : (widget.backgroundColor ?? _commonConfig.fillBase),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final expanded = constraints.hasBoundedWidth;
          final contentBox = expanded ? Expanded(child: content) : content;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: direction == SantoContentDirection.right
                    ? [iconBox, SizedBox(width: gap), contentBox]
                    : [contentBox, SizedBox(width: gap), iconBox],
              ),
              _buildSubTitle(direction, insetSpacing),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSubTitle(SantoContentDirection direction, double insetSpacing) {
    final subTitle = widget.subTitle;
    if (subTitle == null || subTitle == '') return const SizedBox.shrink();
    final subTitleStyle = (widget.subTitleStyle ??
            const TextStyle(fontSize: 14, color: Color(0xFF808695)))
        .copyWith(
      color: _disabled
          ? _commonConfig.colorTextDisabled
          : (widget.subTitleColor ?? _commonConfig.colorTextSecondary),
    );
    // 非卡片且指示器在左时,副标题与内容左对齐
    final left = widget.cardMode
        ? insetSpacing
        : (direction == SantoContentDirection.right
            ? insetSpacing + indicatorSize + (widget.spacing ?? 8)
            : 0.0);
    return Padding(
      padding: EdgeInsets.only(top: 4, left: left, right: insetSpacing),
      child: Text(
        subTitle,
        maxLines: widget.subTitleMaxLine,
        overflow: TextOverflow.ellipsis,
        style: subTitleStyle,
      ),
    );
  }

  /// 卡片模式:背景 + 选中描边 + 左上角勾选角标
  Widget _buildCardWrapper(Widget child) {
    final selectColor = widget.selectColor ?? _commonConfig.brandPrimary;
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? _commonConfig.fillBase,
        border: Border.all(
          width: 1.5,
          color: checked ? selectColor : Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      child: Stack(
        children: [
          child,
          if (checked)
            Positioned(
              top: 0,
              left: 0,
              child: _CornerCheck(
                length: cornerLength,
                radius: cardRadius - 1.5,
                color: selectColor,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDivider(SantoCheckboxGroupState? groupState, bool hasContent) {
    final direction =
        groupState?.widget.contentDirection ?? widget.contentDirection;
    final insetSpacing = widget.insetSpacing ?? 16;
    final leftInset =
        direction == SantoContentDirection.right && hasContent
            ? insetSpacing + indicatorSize + (widget.spacing ?? 8)
            : insetSpacing;
    return SantoLine(leftInset: leftInset);
  }

  Widget? _buildIcon(
      BuildContext context, SantoCheckboxGroupState? groupState) {
    final iconBuilder =
        widget.customIconBuilder ?? groupState?.widget.customIconBuilder;
    if (iconBuilder != null) {
      return iconBuilder.call(context, checked);
    }
    return widget.buildDefaultIcon(context, groupState, checked);
  }

  Widget? _buildContent(
      BuildContext context, SantoCheckboxGroupState? groupState) {
    final customContent =
        widget.customContentBuilder ?? groupState?.widget.customContentBuilder;
    final content = customContent?.call(context, checked, widget.title);
    if (content != null) return content;
    final title = widget.title;
    if (title == null) return null;
    final titleStyle = (widget.titleStyle ??
            const TextStyle(fontSize: 16, color: Color(0xFF17233D)))
        .copyWith(
      color: _disabled
          ? _commonConfig.colorTextDisabled
          : (widget.titleColor ?? _commonConfig.colorTextBase),
    );
    return Text(
      title,
      maxLines: widget.titleMaxLine ?? groupState?.widget.titleMaxLine,
      overflow: TextOverflow.ellipsis,
      style: titleStyle,
    );
  }
}

/// 卡片模式左上角的三角勾选角标
class _CornerCheck extends StatelessWidget {
  const _CornerCheck({
    required this.length,
    required this.radius,
    required this.color,
  });

  final double length;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: length,
      height: length,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(length, length),
            painter: _CornerCheckPainter(radius: radius, color: color),
          ),
          const Positioned(
            top: 5,
            left: 4,
            child: Icon(Icons.check, size: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _CornerCheckPainter extends CustomPainter {
  const _CornerCheckPainter({required this.radius, required this.color});

  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..isAntiAlias = true
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, radius)
      ..arcTo(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        3.1415,
        3.1415 / 2,
        false,
      )
      ..lineTo(size.width, 0)
      ..lineTo(0, size.height)
      ..lineTo(0, radius)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CornerCheckPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
