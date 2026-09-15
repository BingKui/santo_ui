import 'package:santo_ui/src/theme/base/santo_base_config.dart';
import 'package:santo_ui/src/theme/base/santo_default_config_utils.dart';
import 'package:santo_ui/src/theme/base/santo_text_style.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:flutter/material.dart';

/// 选择器配置
class SantoPickerConfig extends SantoBaseConfig {
  /// 遵循外部主题配置
  /// 默认为 [SantoDefaultConfigUtils.defaultPickerConfig]
  SantoPickerConfig({
    Color? backgroundColor,
    SantoTextStyle? cancelTextStyle,
    SantoTextStyle? confirmTextStyle,
    SantoTextStyle? titleTextStyle,
    double? pickerHeight,
    double? titleHeight,
    double? itemHeight,
    SantoTextStyle? itemTextStyle,
    SantoTextStyle? itemTextSelectedStyle,
    Color? dividerColor,
    double? cornerRadius,
    String configId = GLOBAL_CONFIG_ID,
  })  : _backgroundColor = backgroundColor,
        _cancelTextStyle = cancelTextStyle,
        _confirmTextStyle = confirmTextStyle,
        _titleTextStyle = titleTextStyle,
        _pickerHeight = pickerHeight,
        _titleHeight = titleHeight,
        _itemHeight = itemHeight,
        _itemTextStyle = itemTextStyle,
        _itemTextSelectedStyle = itemTextSelectedStyle,
        _dividerColor = dividerColor,
        _cornerRadius = cornerRadius,
        super(configId: configId);

  /// 日期选择器的背景色
  /// 默认为 [PICKER_BACKGROUND_COLOR]
  Color? _backgroundColor;

  /// 取消文字的样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize: [SantoCommonConfig.fontSizeSubHead],
  /// )
  SantoTextStyle? _cancelTextStyle;

  /// 确认文字的样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.brandPrimary],
  ///   fontSize: [SantoCommonConfig.fontSizeSubHead],
  /// )
  SantoTextStyle? _confirmTextStyle;

  /// 标题文字的样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize: [SantoCommonConfig.fontSizeSubHead],
  ///   fontWidget:FontWeight.w600,
  /// )
  SantoTextStyle? _titleTextStyle;

  /// 日期选择器的高度
  /// 默认为 [PICKER_HEIGHT]
  double? _pickerHeight;

  /// 日期选择器标题的高度
  /// 默认为 [PICKER_TITLE_HEIGHT]
  double? _titleHeight;

  /// 日期选择器列表的高度
  /// 默认为 [PICKER_ITEM_HEIGHT]
  double? _itemHeight;

  /// 日期选择器列表的文字样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize: [SantoCommonConfig.fontSizeHead],
  /// )
  SantoTextStyle? _itemTextStyle;

  /// 日期选择器列表选中的文字样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.brandPrimary],
  ///   fontSize: [SantoCommonConfig.fontSizeHead],
  ///   fontWidget: FontWeight.w600,
  /// )
  SantoTextStyle? _itemTextSelectedStyle;

  Color? _dividerColor;
  double? _cornerRadius;

  Color get backgroundColor =>
      _backgroundColor ??
      SantoDefaultConfigUtils.defaultPickerConfig.backgroundColor;

  SantoTextStyle get cancelTextStyle =>
      _cancelTextStyle ??
      SantoDefaultConfigUtils.defaultPickerConfig.cancelTextStyle;

  SantoTextStyle get confirmTextStyle =>
      _confirmTextStyle ??
      SantoDefaultConfigUtils.defaultPickerConfig.confirmTextStyle;

  SantoTextStyle get titleTextStyle =>
      _titleTextStyle ??
      SantoDefaultConfigUtils.defaultPickerConfig.titleTextStyle;

  double get pickerHeight =>
      _pickerHeight ?? SantoDefaultConfigUtils.defaultPickerConfig.pickerHeight;

  double get titleHeight =>
      _titleHeight ?? SantoDefaultConfigUtils.defaultPickerConfig.titleHeight;

  double get itemHeight =>
      _itemHeight ?? SantoDefaultConfigUtils.defaultPickerConfig.itemHeight;

  SantoTextStyle get itemTextStyle =>
      _itemTextStyle ?? SantoDefaultConfigUtils.defaultPickerConfig.itemTextStyle;

  SantoTextStyle get itemTextSelectedStyle =>
      _itemTextSelectedStyle ??
      SantoDefaultConfigUtils.defaultPickerConfig.itemTextSelectedStyle;

  Color get dividerColor =>
      _dividerColor ?? SantoDefaultConfigUtils.defaultPickerConfig.dividerColor;

  double get cornerRadius =>
      _cornerRadius ?? SantoDefaultConfigUtils.defaultPickerConfig.cornerRadius;

  @override
  void initThemeConfig(
    String configId, {
    SantoCommonConfig? currentLevelCommonConfig,
  }) {
    super.initThemeConfig(
      configId,
      currentLevelCommonConfig: currentLevelCommonConfig,
    );

    /// 用户全局组件配置
    SantoPickerConfig pickerConfig = SantoThemeConfigurator.instance
        .getConfig(configId: configId)
        .pickerConfig;

    _backgroundColor ??= pickerConfig.backgroundColor;
    _pickerHeight ??= pickerConfig.pickerHeight;
    _titleHeight ??= pickerConfig.titleHeight;
    _itemHeight ??= pickerConfig.itemHeight;
    _dividerColor ??= pickerConfig.dividerColor;
    _cornerRadius ??= pickerConfig.cornerRadius;
    _titleTextStyle = pickerConfig.titleTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_titleTextStyle),
    );
    _cancelTextStyle = pickerConfig.cancelTextStyle
        .merge(
          SantoTextStyle(
            color: commonConfig.colorTextBase,
            fontSize: commonConfig.fontSizeSubHead,
          ),
        )
        .merge(_cancelTextStyle);
    _confirmTextStyle = pickerConfig.confirmTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.brandPrimary,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_confirmTextStyle),
    );
    _itemTextStyle = pickerConfig.itemTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeHead,
      ).merge(_itemTextStyle),
    );
    _itemTextSelectedStyle = pickerConfig.itemTextSelectedStyle.merge(
      SantoTextStyle(
        color: commonConfig.brandPrimary,
        fontSize: commonConfig.fontSizeHead,
      ).merge(_itemTextSelectedStyle),
    );
  }

  SantoPickerConfig copyWith({
    Color? backgroundColor,
    SantoTextStyle? cancelTextStyle,
    SantoTextStyle? confirmTextStyle,
    SantoTextStyle? titleTextStyle,
    double? pickerHeight,
    double? titleHeight,
    double? itemHeight,
    SantoTextStyle? itemTextStyle,
    SantoTextStyle? itemTextSelectedStyle,
    Color? dividerColor,
    double? cornerRadius,
  }) {
    return SantoPickerConfig(
      backgroundColor: backgroundColor ?? _backgroundColor,
      cancelTextStyle: cancelTextStyle ?? _cancelTextStyle,
      confirmTextStyle: confirmTextStyle ?? _confirmTextStyle,
      titleTextStyle: titleTextStyle ?? _titleTextStyle,
      pickerHeight: pickerHeight ?? _pickerHeight,
      titleHeight: titleHeight ?? _titleHeight,
      itemHeight: itemHeight ?? _itemHeight,
      itemTextStyle: itemTextStyle ?? _itemTextStyle,
      itemTextSelectedStyle: itemTextSelectedStyle ?? _itemTextSelectedStyle,
      dividerColor: dividerColor ?? _dividerColor,
      cornerRadius: cornerRadius ?? _cornerRadius,
    );
  }

  SantoPickerConfig merge(SantoPickerConfig? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other._backgroundColor,
      cancelTextStyle: cancelTextStyle.merge(other._cancelTextStyle),
      confirmTextStyle: confirmTextStyle.merge(other._confirmTextStyle),
      titleTextStyle: titleTextStyle.merge(other._titleTextStyle),
      pickerHeight: other._pickerHeight,
      titleHeight: other._titleHeight,
      itemHeight: other._itemHeight,
      itemTextStyle: itemTextStyle.merge(other._itemTextStyle),
      itemTextSelectedStyle:
          itemTextSelectedStyle.merge(other._itemTextSelectedStyle),
      dividerColor: other._dividerColor,
      cornerRadius: other._cornerRadius,
    );
  }
}
