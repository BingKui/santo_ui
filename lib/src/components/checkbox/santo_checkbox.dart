import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:santo_ui/src/components/checkbox/santo_checkbox_group.dart';
import 'package:santo_ui/src/components/icon/santo_icon.dart';
import 'package:santo_ui/src/components/icon/santo_solid_icons.dart';
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

  /// 卡片模式,选中显示品牌色边框与右上角选中图标
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

  /// 自定义组件内边距;设置后不再施加默认行高与内边距
  final EdgeInsetsGeometry? customSpace;

  /// 默认指示器
  Widget buildDefaultIcon(
      BuildContext context, SantoCheckboxGroupState? groupState, bool isChecked) {
    final style =
        this.style ?? groupState?.widget.style ?? SantoCheckboxStyle.circle;
    // 卡片模式不显示指示器,选中态由卡片边框与右上角选中图标表达
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

  /// 卡片模式选中背景图标高度占卡片高度的比例
  static const double cardBadgeHeightFactor = 0.4;

  /// 卡片模式内容区上下内边距(减去边框宽度后距卡片外沿 16)
  static const double cardPaddingVertical = 16 - 1.5;

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

  /// 组件内边距:左右为 insetSpacing,上下按尺寸;卡片模式只留上下
  EdgeInsets _contentPadding(double insetSpacing) {
    if (widget.cardMode) {
      return EdgeInsets.symmetric(
          horizontal: insetSpacing, vertical: cardPaddingVertical);
    }
    return EdgeInsets.symmetric(
      horizontal: insetSpacing,
      vertical: widget.size == SantoCheckBoxSize.large
          ? _commonConfig.vSpacingMd
          : 12,
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

    // 手势与按压态必须保持同一组件结构:按下时在 GestureDetector 外侧增删组件
    // 会卸载手势识别器,本次点击随即作废(真机上表现为要点两次),因此 Opacity 常驻
    tile = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) => _pressState(true),
      onTapUp: (_) => _pressState(false),
      onTapCancel: () => _pressState(false),
      onTap: () => _handleTap(groupState),
      child: Opacity(
        opacity: _pressed ? 0.68 : 1,
        child: tile,
      ),
    );

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
    // 严格模式(单选)下已选中项不可取消勾选
    if (canNotCancel && checked) return;
    final next = !checked;
    if (groupState != null && widget.id != null) {
      // 超出分组最大勾选数时分组会回调 onOverloadChecked,此处保持原状态
      if (!groupState.toggle(widget.id!, next, true)) return;
    }
    setState(() => checked = next);
    widget.onChanged?.call(next);
  }

  void _pressState(bool pressed) {
    if (_disabled || !mounted || _pressed == pressed) return;
    // 组件在本帧内被移除时(手势识别器释放会回调 onTapCancel),树已锁定不能 setState
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      return;
    }
    setState(() => _pressed = pressed);
  }

  Widget _buildTile(
    BuildContext context,
    SantoCheckboxGroupState? groupState,
    Widget? icon,
    Widget? content,
  ) {
    if (icon == null) return content ?? const SizedBox.shrink();

    final spacing = widget.spacing ??
        groupState?.widget.spacing ??
        _commonConfig.hSpacingSm;
    final direction =
        groupState?.widget.contentDirection ?? widget.contentDirection;
    final insetSpacing = widget.insetSpacing ?? _commonConfig.hSpacingMd;

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
      constraints: widget.cardMode || widget.customSpace != null
          ? null
          : BoxConstraints(minHeight: _contentMinHeight()),
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
              _buildSubTitle(direction, gap),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSubTitle(SantoContentDirection direction, double gap) {
    final subTitle = widget.subTitle;
    if (subTitle == null || subTitle == '') return const SizedBox.shrink();
    final subTitleStyle = (widget.subTitleStyle ??
            TextStyle(
                fontSize: _commonConfig.fontSizeBase,
                color: Color(0xFF808695)))
        .copyWith(
      color: _disabled
          ? _commonConfig.colorTextDisabled
          : (widget.subTitleColor ?? _commonConfig.colorTextSecondary),
    );
    // 容器内边距已含左右留白,这里只补指示器占位,保证描述与标题左对齐
    final left = widget.cardMode || direction == SantoContentDirection.left
        ? 0.0
        : indicatorSize + gap;
    return Padding(
      padding: EdgeInsets.only(top: _commonConfig.vSpacingXs, left: left),
      child: Text(
        subTitle,
        maxLines: widget.subTitleMaxLine,
        overflow: TextOverflow.ellipsis,
        style: subTitleStyle,
      ),
    );
  }

  /// 卡片模式:背景 + 选中描边 + 选中背景图标
  Widget _buildCardWrapper(Widget child) {
    final selectColor = widget.selectColor ?? _commonConfig.brandPrimary;
    final insetSpacing = widget.insetSpacing ?? _commonConfig.hSpacingMd;
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? _commonConfig.fillBase,
        border: Border.all(
          width: 1.5,
          // 未选中用分割线色描边,保证白色页面上卡片可见
          color: checked ? selectColor : _commonConfig.dividerColorBase,
        ),
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      child: Stack(
        // 选中图标是背景层,压在内容之下;边长取卡片高度的一半
        children: [
          if (checked)
            Positioned.fill(
              right: insetSpacing,
              child: Align(
                alignment: Alignment.centerRight,
                child: LayoutBuilder(
                  builder: (context, constraints) => SantoIcon(
                    SantoSolidIcons.checkCircle,
                    solid: true,
                    size: constraints.maxHeight * cardBadgeHeightFactor,
                    color: selectColor,
                  ),
                ),
              ),
            ),
          child,
        ],
      ),
    );
  }

  Widget _buildDivider(SantoCheckboxGroupState? groupState, bool hasContent) {
    final direction =
        groupState?.widget.contentDirection ?? widget.contentDirection;
    final insetSpacing = widget.insetSpacing ?? _commonConfig.hSpacingMd;
    final leftInset =
        direction == SantoContentDirection.right && hasContent
            ? insetSpacing + indicatorSize + (widget.spacing ?? _commonConfig.hSpacingSm)
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
            TextStyle(
                fontSize: _commonConfig.fontSizeSubHead,
                color: Color(0xFF17233D)))
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
