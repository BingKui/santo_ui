import 'package:flutter/material.dart';

import 'package:santo_ui/src/components/checkbox/santo_checkbox.dart';
import 'package:santo_ui/src/components/checkbox/santo_checkbox_group.dart';
import 'package:santo_ui/src/components/line/santo_line.dart';
import 'package:santo_ui/src/components/radio/santo_radio.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 单选状态变化监听:返回选中的 id,未选中任何项时为 null
typedef SantoRadioGroupChange = void Function(String? selectedId);

/// 单选框分组
///
/// 组内 [SantoRadio] 互斥,只有一个能被选中;默认严格模式,选中后不可取消,只能切换。
class SantoRadioGroup extends SantoCheckboxGroup {
  SantoRadioGroup({
    Key? key,
    Widget? child,
    Axis? direction,
    List<SantoRadio>? directionalRadios,
    String? selectId,
    bool? passThrough,
    bool cardMode = false,
    this.strictMode = true,
    this.radioCheckStyle,
    int? titleMaxLine,
    SantoCheckboxIconBuilder? customIconBuilder,
    SantoCheckboxContentBuilder? customContentBuilder,
    double? spacing,
    this.rowCount = 1,
    SantoContentDirection? contentDirection,
    SantoRadioGroupChange? onRadioGroupChange,
    this.showDivider = false,
    this.divider,
    SantoCheckboxGroupController? controller,
  })  : assert(
          direction == null || directionalRadios != null,
          'SantoRadioGroup: 设置 direction 时必须同时设置 directionalRadios',
        ),
        assert(
          direction != null || child != null,
          'SantoRadioGroup: 未设置 direction 时必须设置 child',
        ),
        super(
          key: key,
          child: _buildLayout(
            child: child,
            direction: direction,
            directionalRadios: directionalRadios ?? const [],
            cardMode: cardMode,
            passThrough: passThrough ?? false,
            rowCount: rowCount,
            showDivider: showDivider,
            divider: divider,
          ),
          onChanged: (ids) =>
              onRadioGroupChange?.call(ids.isEmpty ? null : ids.first),
          controller: controller,
          checkedIds: selectId != null ? [selectId] : null,
          maxChecked: 1,
          titleMaxLine: titleMaxLine,
          contentDirection: contentDirection,
          customIconBuilder: customIconBuilder,
          customContentBuilder: customContentBuilder,
          spacing: spacing,
        );

  /// 严格模式:选中后不可取消,只能切换
  final bool strictMode;

  /// 统一勾选样式,设置后覆盖组内单选框自身样式
  final SantoRadioStyle? radioCheckStyle;

  /// 横向排列时是否显示下划线
  final bool showDivider;

  /// 自定义下划线
  final Widget? divider;

  /// 横向排列时每行个数
  final int rowCount;

  static Widget _buildLayout({
    required Widget? child,
    required Axis? direction,
    required List<SantoRadio> directionalRadios,
    required bool cardMode,
    required bool passThrough,
    required int rowCount,
    required bool showDivider,
    required Widget? divider,
  }) {
    if (direction == null) return child!;
    final isHorizontal = direction == Axis.horizontal;
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    Widget container;
    if (!isHorizontal) {
      container = ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: directionalRadios.length,
        separatorBuilder: (context, index) => cardMode
            ? SizedBox(
                height: SantoThemeConfigurator.instance
                    .getConfig()
                    .commonConfig
                    .gapMd)
            : const SizedBox.shrink(),
        itemBuilder: (context, index) => Container(
          margin: cardMode
              ? EdgeInsets.symmetric(horizontal: commonConfig.hSpacingMd)
              : null,
          height: cardMode ? 82 : null,
          child: directionalRadios[index],
        ),
      );
    } else if (cardMode) {
      container = Container(
        margin: EdgeInsets.symmetric(horizontal: commonConfig.hSpacingMd),
        alignment: Alignment.topLeft,
        child: LayoutBuilder(builder: (context, constraints) {
          // 三等分去掉两个列间距,避免按屏幕宽度硬编码卡片宽
          final itemWidth = (constraints.maxWidth - 24) / 3;
          return Wrap(
            spacing: SantoThemeConfigurator.instance
                .getConfig()
                .commonConfig
                .gapMd,
            runSpacing: SantoThemeConfigurator.instance
                .getConfig()
                .commonConfig
                .gapMd,
            children: directionalRadios
                .map((e) => SizedBox(width: itemWidth, height: 56, child: e))
                .toList(),
          );
        }),
      );
    } else {
      container = Container(
        margin: EdgeInsets.symmetric(horizontal: commonConfig.hSpacingMd),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRadioRows(directionalRadios, rowCount),
            if (showDivider)
              divider ??
                  Padding(
                    padding: EdgeInsets.only(top: commonConfig.vSpacingSm),
                    child: SantoLine(),
                  ),
          ],
        ),
      );
    }

    // 非通栏样式仅用于纵向排列:整体裁切圆角并向左右留出外边距
    if (passThrough && !isHorizontal) {
      container = Container(
        clipBehavior: Clip.hardEdge,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(commonConfig.radiusXs)),
        margin: EdgeInsets.symmetric(horizontal: commonConfig.hSpacingMd),
        child: container,
      );
    }
    return container;
  }

  static Widget _buildRadioRows(List<SantoRadio> items, int rowCount) {
    if (rowCount <= 1) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: items.map((e) => Expanded(child: e)).toList(),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate((items.length / rowCount).ceil(), (index) {
        var end = (index + 1) * rowCount;
        if (end > items.length) end = items.length;
        final subList = items.sublist(index * rowCount, end);
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...subList.map((e) => Expanded(child: e)),
            if (subList.length < rowCount)
              ...List.generate(
                rowCount - subList.length,
                (index) => const Expanded(child: SizedBox()),
              ),
          ],
        );
      }),
    );
  }

  @override
  State<SantoCheckboxGroup> createState() => SantoRadioGroupState();
}

class SantoRadioGroupState extends SantoCheckboxGroupState {
  @override
  bool toggle(String id, bool check, [bool notify = false]) {
    // 单选:先清空其它项
    for (final key in checkBoxStates.keys.toList()) {
      checkBoxStates[key] = false;
    }
    return super.toggle(id, check, notify);
  }
}
