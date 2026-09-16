import 'package:santo_ui/src/theme/base/santo_base_config.dart';
import 'package:santo_ui/src/theme/base/santo_default_config_utils.dart';
import 'package:santo_ui/src/theme/base/santo_text_style.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:flutter/painting.dart';

/// 筛选项 配置类
class SantoSelectionConfig extends SantoBaseConfig {
  /// 遵循外部主题配置
  /// 默认为 [SantoDefaultConfigUtils.defaultSelectionConfig]
  SantoSelectionConfig({
    SantoTextStyle? menuNormalTextStyle,
    SantoTextStyle? menuSelectedTextStyle,
    SantoTextStyle? tagNormalTextStyle,
    SantoTextStyle? tagSelectedTextStyle,
    double? tagRadius,
    Color? tagNormalBackgroundColor,
    Color? tagSelectedBackgroundColor,
    SantoTextStyle? hintTextStyle,
    SantoTextStyle? rangeTitleTextStyle,
    SantoTextStyle? inputTextStyle,
    SantoTextStyle? itemNormalTextStyle,
    SantoTextStyle? itemSelectedTextStyle,
    SantoTextStyle? itemBoldTextStyle,
    Color? deepNormalBgColor,
    Color? deepSelectBgColor,
    Color? middleNormalBgColor,
    Color? middleSelectBgColor,
    Color? lightNormalBgColor,
    Color? lightSelectBgColor,
    SantoTextStyle? resetTextStyle,
    SantoTextStyle? titleForMoreTextStyle,
    SantoTextStyle? optionTextStyle,
    SantoTextStyle? moreTextStyle,
    SantoTextStyle? flayerNormalTextStyle,
    SantoTextStyle? flayerSelectedTextStyle,
    SantoTextStyle? flayerBoldTextStyle,
    String configId = GLOBAL_CONFIG_ID,
  })  : _menuNormalTextStyle = menuNormalTextStyle,
        _menuSelectedTextStyle = menuSelectedTextStyle,
        _tagNormalTextStyle = tagNormalTextStyle,
        _tagSelectedTextStyle = tagSelectedTextStyle,
        _tagRadius = tagRadius,
        _tagNormalBackgroundColor = tagNormalBackgroundColor,
        _tagSelectedBackgroundColor = tagSelectedBackgroundColor,
        _hintTextStyle = hintTextStyle,
        _rangeTitleTextStyle = rangeTitleTextStyle,
        _inputTextStyle = inputTextStyle,
        _itemNormalTextStyle = itemNormalTextStyle,
        _itemSelectedTextStyle = itemSelectedTextStyle,
        _itemBoldTextStyle = itemBoldTextStyle,
        _deepNormalBgColor = deepNormalBgColor,
        _deepSelectBgColor = deepSelectBgColor,
        _middleNormalBgColor = middleNormalBgColor,
        _middleSelectBgColor = middleSelectBgColor,
        _lightNormalBgColor = lightNormalBgColor,
        _lightSelectBgColor = lightSelectBgColor,
        _resetTextStyle = resetTextStyle,
        _titleForMoreTextStyle = titleForMoreTextStyle,
        _optionTextStyle = optionTextStyle,
        _moreTextStyle = moreTextStyle,
        _flayerNormalTextStyle = flayerNormalTextStyle,
        _flayerSelectedTextStyle = flayerSelectedTextStyle,
        _flayerBoldTextStyle = flayerBoldTextStyle,
        super(configId: configId);

  /// menu 正常文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize: [SantoCommonConfig.fontSizeBase],
  ///   fontWeight: FontWeight.normal,
  /// )
  SantoTextStyle? _menuNormalTextStyle;

  /// menu 选中文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.brandPrimary],
  ///   fontSize: [SantoCommonConfig.fontSizeBase],
  ///   fontWeight: FontWeight.w600,
  /// )
  SantoTextStyle? _menuSelectedTextStyle;

  /// tag 正常文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize: [SantoCommonConfig.fontSizeCaption],
  ///   fontWeight: FontWeight.w400,
  /// )
  SantoTextStyle? _tagNormalTextStyle;

  /// tag 选中文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.brandPrimary],
  ///   fontSize: [SantoCommonConfig.fontSizeCaption],
  ///   fontWeight: FontWeight.w600,
  /// )
  SantoTextStyle? _tagSelectedTextStyle;

  /// tag 圆角
  /// 默认为 [SantoCommonConfig.radiusSm]
  double? _tagRadius;

  /// tag 正常背景色
  /// 默认为 [SantoCommonConfig.fillBody]
  Color? _tagNormalBackgroundColor;

  /// tag 选中背景色
  /// 默认为 [SantoCommonConfig.brandPrimary].withOpacity(0.12)
  Color? _tagSelectedBackgroundColor;

  /// 输入选项标题文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize: [SantoCommonConfig.fontSizeSubHead],
  ///   fontWeight: FontWeight.w600,
  /// )
  SantoTextStyle? _rangeTitleTextStyle;

  /// 输入提示文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextHint],
  ///   fontSize: [SantoCommonConfig.fontSizeBase],
  /// )
  SantoTextStyle? _hintTextStyle;

  /// 输入框默认文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize: [SantoCommonConfig.fontSizeBase],
  /// )
  SantoTextStyle? _inputTextStyle;

  /// item 正常字体样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize: [SantoCommonConfig.fontSizeBase],
  /// )
  SantoTextStyle? _itemNormalTextStyle;

  /// item 选中文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.brandPrimary],
  ///   fontSize: [SantoCommonConfig.fontSizeBase],
  ///   fontWeight: FontWeight.w600,
  /// )
  SantoTextStyle? _itemSelectedTextStyle;

  /// item 仅加粗样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize: [SantoCommonConfig.fontSizeBase],
  ///   fontWeight: FontWeight.w600,
  /// )
  SantoTextStyle? _itemBoldTextStyle;

  /// 三级 item 背景色
  /// 默认为 Color(0xFFE8EAEC)
  Color? _deepNormalBgColor;

  /// 三级 item 选中背景色
  /// 默认为 Color(0xFFF5F5F5)
  Color? _deepSelectBgColor;

  /// 二级 item 背景色
  /// 默认为 Color(0xFFF5F5F5)
  Color? _middleNormalBgColor;

  /// 二级 item 选中背景色
  /// 默认为 Colors.white
  Color? _middleSelectBgColor;

  /// 一级 item 背景色
  /// 默认为 Colors.white
  Color? _lightNormalBgColor;

  /// 一级 item 选中背景色
  /// 默认为 Colors.white
  Color? _lightSelectBgColor;

  /// 重置按钮颜色
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextImportant],
  ///   fontSize: [SantoCommonConfig.fontSizeCaption]
  /// )
  SantoTextStyle? _resetTextStyle;

  /// 更多筛选-标题文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize: [SantoCommonConfig.fontSizeBase],
  ///   fontWeight: FontWeight.w600,
  /// )
  SantoTextStyle? _titleForMoreTextStyle;

  /// 选项-显示文本
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.brandPrimary],
  ///   fontSize: [SantoCommonConfig.fontSizeBase],
  /// )
  SantoTextStyle? _optionTextStyle;

  /// 更多文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextSecondary],
  ///   fontSize: [SantoCommonConfig.fontSizeCaption],
  /// )
  SantoTextStyle? _moreTextStyle;

  /// 跳转二级页-正常文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize: [SantoCommonConfig.fontSizeSubHead],
  ///   fontWeight: FontWeight.normal,
  /// )
  SantoTextStyle? _flayerNormalTextStyle;

  /// 跳转二级页-选中文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.brandPrimary],
  ///   fontSize: [SantoCommonConfig.fontSizeSubHead],
  ///   fontWeight: FontWeight.w600,
  /// )
  SantoTextStyle? _flayerSelectedTextStyle;

  /// 跳转二级页-加粗文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize: [SantoCommonConfig.fontSizeSubHead],
  ///   fontWeight: FontWeight.w600
  /// )
  SantoTextStyle? _flayerBoldTextStyle;

  SantoTextStyle get menuNormalTextStyle =>
      _menuNormalTextStyle ??
      SantoDefaultConfigUtils.defaultSelectionConfig.menuNormalTextStyle;

  SantoTextStyle get menuSelectedTextStyle =>
      _menuSelectedTextStyle ??
      SantoDefaultConfigUtils.defaultSelectionConfig.menuSelectedTextStyle;

  SantoTextStyle get tagNormalTextStyle =>
      _tagNormalTextStyle ??
      SantoDefaultConfigUtils.defaultSelectionConfig.tagNormalTextStyle;

  SantoTextStyle get tagSelectedTextStyle =>
      _tagSelectedTextStyle ??
      SantoDefaultConfigUtils.defaultSelectionConfig.tagSelectedTextStyle;

  double get tagRadius =>
      _tagRadius ?? SantoDefaultConfigUtils.defaultSelectionConfig.tagRadius;

  Color get tagNormalBackgroundColor =>
      _tagNormalBackgroundColor ??
      SantoDefaultConfigUtils.defaultSelectionConfig.tagNormalBackgroundColor;

  Color get tagSelectedBackgroundColor =>
      _tagSelectedBackgroundColor ??
      SantoDefaultConfigUtils.defaultSelectionConfig.tagSelectedBackgroundColor;

  SantoTextStyle get rangeTitleTextStyle =>
      _rangeTitleTextStyle ??
      SantoDefaultConfigUtils.defaultSelectionConfig.rangeTitleTextStyle;

  SantoTextStyle get hintTextStyle =>
      _hintTextStyle ??
      SantoDefaultConfigUtils.defaultSelectionConfig.hintTextStyle;

  SantoTextStyle get inputTextStyle =>
      _inputTextStyle ??
      SantoDefaultConfigUtils.defaultSelectionConfig.inputTextStyle;

  SantoTextStyle get itemNormalTextStyle =>
      _itemNormalTextStyle ??
      SantoDefaultConfigUtils.defaultSelectionConfig.itemNormalTextStyle;

  SantoTextStyle get itemSelectedTextStyle =>
      _itemSelectedTextStyle ??
      SantoDefaultConfigUtils.defaultSelectionConfig.itemSelectedTextStyle;

  SantoTextStyle get itemBoldTextStyle =>
      _itemBoldTextStyle ??
      SantoDefaultConfigUtils.defaultSelectionConfig.itemBoldTextStyle;

  Color get deepNormalBgColor =>
      _deepNormalBgColor ??
      SantoDefaultConfigUtils.defaultSelectionConfig.deepNormalBgColor;

  Color get deepSelectBgColor =>
      _deepSelectBgColor ??
      SantoDefaultConfigUtils.defaultSelectionConfig.deepSelectBgColor;

  Color get middleNormalBgColor =>
      _middleNormalBgColor ??
      SantoDefaultConfigUtils.defaultSelectionConfig.middleNormalBgColor;

  Color get middleSelectBgColor =>
      _middleSelectBgColor ??
      SantoDefaultConfigUtils.defaultSelectionConfig.middleSelectBgColor;

  Color get lightNormalBgColor =>
      _lightNormalBgColor ??
      SantoDefaultConfigUtils.defaultSelectionConfig.lightNormalBgColor;

  Color get lightSelectBgColor =>
      _lightSelectBgColor ??
      SantoDefaultConfigUtils.defaultSelectionConfig.lightSelectBgColor;

  SantoTextStyle get resetTextStyle =>
      _resetTextStyle ??
      SantoDefaultConfigUtils.defaultSelectionConfig.resetTextStyle;

  SantoTextStyle get titleForMoreTextStyle =>
      _titleForMoreTextStyle ??
      SantoDefaultConfigUtils.defaultSelectionConfig.titleForMoreTextStyle;

  SantoTextStyle get optionTextStyle =>
      _optionTextStyle ??
      SantoDefaultConfigUtils.defaultSelectionConfig.optionTextStyle;

  SantoTextStyle get moreTextStyle =>
      _moreTextStyle ??
      SantoDefaultConfigUtils.defaultSelectionConfig.moreTextStyle;

  SantoTextStyle get flayerNormalTextStyle =>
      _flayerNormalTextStyle ??
      SantoDefaultConfigUtils.defaultSelectionConfig.flayerNormalTextStyle;

  SantoTextStyle get flayerSelectedTextStyle =>
      _flayerSelectedTextStyle ??
      SantoDefaultConfigUtils.defaultSelectionConfig.flayerSelectedTextStyle;

  SantoTextStyle get flayerBoldTextStyle =>
      _flayerBoldTextStyle ??
      SantoDefaultConfigUtils.defaultSelectionConfig.flayerBoldTextStyle;

  @override
  void initThemeConfig(
    String configId, {
    SantoCommonConfig? currentLevelCommonConfig,
  }) {
    super.initThemeConfig(
      configId,
      currentLevelCommonConfig: currentLevelCommonConfig,
    );

    /// 用户全局筛选配置
    SantoSelectionConfig selectionConfig = SantoThemeConfigurator.instance
        .getConfig(configId: configId)
        .selectionConfig;

    _lightSelectBgColor ??= selectionConfig._lightSelectBgColor;
    _lightNormalBgColor ??= selectionConfig._lightNormalBgColor;
    _middleSelectBgColor ??= selectionConfig._middleSelectBgColor;
    _middleNormalBgColor ??= selectionConfig._middleNormalBgColor;
    _deepSelectBgColor ??= selectionConfig._deepSelectBgColor;
    _deepNormalBgColor ??= selectionConfig._deepNormalBgColor;
    _tagSelectedBackgroundColor ??= commonConfig.brandPrimary.withOpacity(0.12);
    _tagNormalBackgroundColor ??= commonConfig.fillBody;
    _tagRadius ??= commonConfig.radiusSm;
    _flayerBoldTextStyle = selectionConfig.flayerBoldTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_flayerBoldTextStyle),
    );
    _flayerSelectedTextStyle = selectionConfig.flayerSelectedTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.brandPrimary,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_flayerSelectedTextStyle),
    );
    _flayerNormalTextStyle = selectionConfig.flayerNormalTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_flayerNormalTextStyle),
    );
    _moreTextStyle = selectionConfig.moreTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextSecondary,
        fontSize: commonConfig.fontSizeCaption,
      ).merge(_moreTextStyle),
    );
    _optionTextStyle = selectionConfig.optionTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.brandPrimary,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_optionTextStyle),
    );
    _titleForMoreTextStyle = selectionConfig.titleForMoreTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_titleForMoreTextStyle),
    );
    _resetTextStyle = selectionConfig.resetTextStyle.merge(SantoTextStyle(
      color: commonConfig.colorTextImportant,
      fontSize: commonConfig.fontSizeCaption,
    ).merge(_resetTextStyle));
    _itemBoldTextStyle = selectionConfig.itemBoldTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_itemBoldTextStyle),
    );
    _itemSelectedTextStyle = selectionConfig.itemSelectedTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.brandPrimary,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_itemSelectedTextStyle),
    );
    _itemNormalTextStyle = selectionConfig.itemNormalTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_itemNormalTextStyle),
    );
    _inputTextStyle = selectionConfig.inputTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_inputTextStyle),
    );
    _hintTextStyle = selectionConfig.hintTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextHint,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_hintTextStyle),
    );
    _rangeTitleTextStyle = selectionConfig.rangeTitleTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_rangeTitleTextStyle),
    );
    _tagSelectedTextStyle = selectionConfig.tagSelectedTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.brandPrimary,
        fontSize: commonConfig.fontSizeCaption,
      ).merge(_tagSelectedTextStyle),
    );
    _tagNormalTextStyle = selectionConfig.tagNormalTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeCaption,
      ).merge(_tagNormalTextStyle),
    );
    _menuNormalTextStyle = selectionConfig.menuNormalTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_menuNormalTextStyle),
    );
    _menuSelectedTextStyle = selectionConfig.menuSelectedTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.brandPrimary,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_menuSelectedTextStyle),
    );
  }

  SantoSelectionConfig copyWith({
    SantoTextStyle? menuNormalTextStyle,
    SantoTextStyle? menuSelectedTextStyle,
    SantoTextStyle? tagTextStyle,
    SantoTextStyle? tagSelectedTextStyle,
    double? tagRadius,
    Color? tagBackgroundColor,
    Color? tagSelectedBackgroundColor,
    SantoTextStyle? hintTextStyle,
    SantoTextStyle? rangeTitleTextStyle,
    SantoTextStyle? inputTextStyle,
    SantoTextStyle? itemNormalTextStyle,
    SantoTextStyle? itemSelectedTextStyle,
    SantoTextStyle? itemBoldTextStyle,
    Color? deepNormalBgColor,
    Color? deepSelectBgColor,
    Color? middleNormalBgColor,
    Color? middleSelectBgColor,
    Color? lightNormalBgColor,
    Color? lightSelectBgColor,
    SantoTextStyle? resetTextStyle,
    SantoTextStyle? titleForMoreTextStyle,
    SantoTextStyle? optionTextStyle,
    SantoTextStyle? moreTextStyle,
    SantoTextStyle? flayerNormalTextStyle,
    SantoTextStyle? flayerSelectedTextStyle,
    SantoTextStyle? flayerBoldTextStyle,
  }) {
    return SantoSelectionConfig(
      menuNormalTextStyle: menuNormalTextStyle ?? _menuNormalTextStyle,
      menuSelectedTextStyle: menuSelectedTextStyle ?? _menuSelectedTextStyle,
      tagNormalTextStyle: tagTextStyle ?? _tagNormalTextStyle,
      tagSelectedTextStyle: tagSelectedTextStyle ?? _tagSelectedTextStyle,
      tagRadius: tagRadius ?? _tagRadius,
      tagNormalBackgroundColor: tagBackgroundColor ?? _tagNormalBackgroundColor,
      tagSelectedBackgroundColor:
          tagSelectedBackgroundColor ?? _tagSelectedBackgroundColor,
      hintTextStyle: hintTextStyle ?? _hintTextStyle,
      rangeTitleTextStyle: rangeTitleTextStyle ?? _rangeTitleTextStyle,
      inputTextStyle: inputTextStyle ?? _inputTextStyle,
      itemNormalTextStyle: itemNormalTextStyle ?? _itemNormalTextStyle,
      itemSelectedTextStyle: itemSelectedTextStyle ?? _itemSelectedTextStyle,
      itemBoldTextStyle: itemBoldTextStyle ?? _itemBoldTextStyle,
      deepNormalBgColor: deepNormalBgColor ?? _deepNormalBgColor,
      deepSelectBgColor: deepSelectBgColor ?? _deepSelectBgColor,
      middleNormalBgColor: middleNormalBgColor ?? _middleNormalBgColor,
      middleSelectBgColor: middleSelectBgColor ?? _middleSelectBgColor,
      lightNormalBgColor: lightNormalBgColor ?? _lightNormalBgColor,
      lightSelectBgColor: lightSelectBgColor ?? _lightSelectBgColor,
      resetTextStyle: resetTextStyle ?? _resetTextStyle,
      titleForMoreTextStyle: titleForMoreTextStyle ?? _titleForMoreTextStyle,
      optionTextStyle: optionTextStyle ?? _optionTextStyle,
      moreTextStyle: moreTextStyle ?? _moreTextStyle,
      flayerNormalTextStyle: flayerNormalTextStyle ?? _flayerNormalTextStyle,
      flayerSelectedTextStyle:
          flayerSelectedTextStyle ?? _flayerSelectedTextStyle,
      flayerBoldTextStyle: flayerBoldTextStyle ?? _flayerBoldTextStyle,
    );
  }

  SantoSelectionConfig merge(SantoSelectionConfig other) {
    return copyWith(
      menuNormalTextStyle:
          menuNormalTextStyle.merge(other._menuNormalTextStyle),
      menuSelectedTextStyle:
          menuSelectedTextStyle.merge(other._menuSelectedTextStyle),
      tagTextStyle: tagNormalTextStyle.merge(other._tagNormalTextStyle),
      tagSelectedTextStyle:
          tagSelectedTextStyle.merge(other._tagSelectedTextStyle),
      tagRadius: other._tagRadius,
      tagBackgroundColor: other._tagNormalBackgroundColor,
      tagSelectedBackgroundColor: other._tagSelectedBackgroundColor,
      hintTextStyle: hintTextStyle.merge(other._hintTextStyle),
      rangeTitleTextStyle:
          rangeTitleTextStyle.merge(other._rangeTitleTextStyle),
      inputTextStyle: inputTextStyle.merge(other._inputTextStyle),
      itemNormalTextStyle:
          itemNormalTextStyle.merge(other._itemNormalTextStyle),
      itemSelectedTextStyle:
          itemSelectedTextStyle.merge(other._itemSelectedTextStyle),
      itemBoldTextStyle: itemBoldTextStyle.merge(other._itemBoldTextStyle),
      deepNormalBgColor: other._deepNormalBgColor,
      deepSelectBgColor: other._deepSelectBgColor,
      middleNormalBgColor: other._middleNormalBgColor,
      middleSelectBgColor: other._middleSelectBgColor,
      lightNormalBgColor: other._lightNormalBgColor,
      lightSelectBgColor: other._lightSelectBgColor,
      resetTextStyle: resetTextStyle.merge(other._resetTextStyle),
      titleForMoreTextStyle:
          titleForMoreTextStyle.merge(other._titleForMoreTextStyle),
      optionTextStyle: optionTextStyle.merge(other._optionTextStyle),
      moreTextStyle: moreTextStyle.merge(other._moreTextStyle),
      flayerNormalTextStyle:
          flayerNormalTextStyle.merge(other._flayerNormalTextStyle),
      flayerSelectedTextStyle:
          flayerSelectedTextStyle.merge(other._flayerSelectedTextStyle),
      flayerBoldTextStyle:
          flayerBoldTextStyle.merge(other._flayerBoldTextStyle),
    );
  }
}
