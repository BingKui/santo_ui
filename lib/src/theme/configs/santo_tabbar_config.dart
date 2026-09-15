import 'package:santo_ui/src/theme/base/santo_base_config.dart';
import 'package:santo_ui/src/theme/base/santo_default_config_utils.dart';
import 'package:santo_ui/src/theme/base/santo_text_style.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:flutter/material.dart';

/// TabBar配置类
class SantoTabBarConfig extends SantoBaseConfig {
  /// 遵循外部主题配置
  /// 默认为 [SantoDefaultConfigUtils.tabBarConfig]
  SantoTabBarConfig({
    double? tabHeight,
    double? indicatorHeight,
    double? indicatorWidth,
    SantoTextStyle? labelStyle,
    SantoTextStyle? unselectedLabelStyle,
    Color? backgroundColor,
    SantoTextStyle? tagNormalTextStyle,
    Color? tagNormalBgColor,
    SantoTextStyle? tagSelectedTextStyle,
    Color? tagSelectedBgColor,
    double? tagRadius,
    double? tagSpacing,
    int? preLineTagCount,
    double? tagHeight,
    String configId = GLOBAL_CONFIG_ID,
  })  : _tabHeight = tabHeight,
        _indicatorHeight = indicatorHeight,
        _indicatorWidth = indicatorWidth,
        _labelStyle = labelStyle,
        _unselectedLabelStyle = unselectedLabelStyle,
        _backgroundColor = backgroundColor,
        _tagNormalTextStyle = tagNormalTextStyle,
        _tagNormalBgColor = tagNormalBgColor,
        _tagSelectedTextStyle = tagSelectedTextStyle,
        _tagSelectedBgColor = tagSelectedBgColor,
        _tagRadius = tagRadius,
        _tagSpacing = tagSpacing,
        _preLineTagCount = preLineTagCount,
        _tagHeight = tagHeight,
        super(configId: configId);

  /// TabBar 的整体高度
  /// 默认为 50
  double? _tabHeight;

  /// 指示器的高度
  /// 默认为 2
  double? _indicatorHeight;

  /// 指示器的宽度
  /// 默认为 24
  double? _indicatorWidth;

  /// 选中 Tab 文本的样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.brandPrimary],
  ///   fontSize: [SantoCommonConfig.fontSizeSubHead],
  /// )
  SantoTextStyle? _labelStyle;

  /// 未选中 Tab 文本的样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize: [SantoCommonConfig.fontSizeSubHead],
  /// )
  SantoTextStyle? _unselectedLabelStyle;

  /// 背景色
  /// 默认为 [SantoCommonConfig.fillBase]
  Color? _backgroundColor;

  /// 标签字体样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize: [SantoCommonConfig.fontSizeCaption],
  /// )
  SantoTextStyle? _tagNormalTextStyle;

  /// 标签背景色
  /// 默认为 [SantoCommonConfig.brandPrimary].withAlpha(0x14),
  Color? _tagNormalBgColor;

  /// 标签字体样式
  ///
  /// SantoTextStyle(
  ///   color:[SantoCommonConfig.brandPrimary],
  ///   fontSize: [SantoCommonConfig.fontSizeCaption],
  /// )
  SantoTextStyle? _tagSelectedTextStyle;

  /// 标签选中背景色
  /// 默认为 [SantoCommonConfig.fillBody]
  Color? _tagSelectedBgColor;

  /// tag圆角
  /// 默认为 [SantoCommonConfig.radiusSm]
  double? _tagRadius;

  /// tag间距
  /// 默认为 12
  double? _tagSpacing;

  /// 每行的tag数
  /// 默认为 4
  int? _preLineTagCount;

  /// tag高度
  /// 默认为 32
  double? _tagHeight;

  double get tabHeight =>
      _tabHeight ?? SantoDefaultConfigUtils.defaultTabBarConfig.tabHeight;

  double get indicatorHeight =>
      _indicatorHeight ??
      SantoDefaultConfigUtils.defaultTabBarConfig.indicatorHeight;

  double get indicatorWidth =>
      _indicatorWidth ??
      SantoDefaultConfigUtils.defaultTabBarConfig.indicatorWidth;

  SantoTextStyle get labelStyle =>
      _labelStyle ?? SantoDefaultConfigUtils.defaultTabBarConfig.labelStyle;

  SantoTextStyle get unselectedLabelStyle =>
      _unselectedLabelStyle ??
      SantoDefaultConfigUtils.defaultTabBarConfig.unselectedLabelStyle;

  Color get backgroundColor =>
      _backgroundColor ??
      SantoDefaultConfigUtils.defaultTabBarConfig.backgroundColor;

  SantoTextStyle get tagNormalTextStyle =>
      _tagNormalTextStyle ??
      SantoDefaultConfigUtils.defaultTabBarConfig.tagNormalTextStyle;

  Color get tagNormalBgColor =>
      _tagNormalBgColor ??
      SantoDefaultConfigUtils.defaultTabBarConfig.tagNormalBgColor;

  SantoTextStyle get tagSelectedTextStyle =>
      _tagSelectedTextStyle ??
      SantoDefaultConfigUtils.defaultTabBarConfig.tagSelectedTextStyle;

  Color get tagSelectedBgColor =>
      _tagSelectedBgColor ??
      SantoDefaultConfigUtils.defaultTabBarConfig.tagSelectedBgColor;

  double get tagRadius =>
      _tagRadius ?? SantoDefaultConfigUtils.defaultTabBarConfig.tagRadius;

  double get tagSpacing =>
      _tagSpacing ?? SantoDefaultConfigUtils.defaultTabBarConfig.tagSpacing;

  int get preLineTagCount =>
      _preLineTagCount ??
      SantoDefaultConfigUtils.defaultTabBarConfig.preLineTagCount;

  double get tagHeight =>
      _tagHeight ?? SantoDefaultConfigUtils.defaultTabBarConfig.tagHeight;

  @override
  void initThemeConfig(
    String configId, {
    SantoCommonConfig? currentLevelCommonConfig,
  }) {
    super.initThemeConfig(
      configId,
      currentLevelCommonConfig: currentLevelCommonConfig,
    );

    SantoTabBarConfig tabBarConfig = SantoThemeConfigurator.instance
        .getConfig(configId: configId)
        .tabBarConfig;

    _tabHeight ??= tabBarConfig._tabHeight;
    _indicatorHeight ??= tabBarConfig._indicatorHeight;
    _indicatorWidth ??= tabBarConfig._indicatorWidth;
    _labelStyle = tabBarConfig.labelStyle.merge(
      SantoTextStyle(
        color: commonConfig.brandPrimary,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_labelStyle),
    );
    _unselectedLabelStyle = tabBarConfig.unselectedLabelStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_unselectedLabelStyle),
    );
    _backgroundColor ??= tabBarConfig._backgroundColor;
    _tagNormalTextStyle = tabBarConfig.tagNormalTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeCaption,
      ).merge(_tagNormalTextStyle),
    );
    _tagSelectedTextStyle = tabBarConfig.tagSelectedTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.brandPrimary,
        fontSize: commonConfig.fontSizeCaption,
      ).merge(_tagSelectedTextStyle),
    );
    _tagNormalBgColor ??= tabBarConfig._tagNormalBgColor;
    _tagSelectedBgColor ??= tabBarConfig._tagSelectedBgColor;
    _tagRadius ??= commonConfig.radiusSm;
    _tagSpacing ??= tabBarConfig._tagSpacing;
    _preLineTagCount ??= tabBarConfig._preLineTagCount;
    _tagHeight ??= tabBarConfig._tagHeight;
  }

  SantoTabBarConfig copyWith({
    double? tabHeight,
    double? indicatorHeight,
    double? indicatorWidth,
    SantoTextStyle? labelStyle,
    SantoTextStyle? unselectedLabelStyle,
    Color? backgroundColor,
    SantoTextStyle? tagNormalTextStyle,
    Color? tagNormalColor,
    SantoTextStyle? tagSelectedTextStyle,
    Color? tagSelectedColor,
    double? tagRadius,
    double? tagSpacing,
    int? preLineTagSize,
    double? tagHeight,
  }) {
    return SantoTabBarConfig(
      tabHeight: tabHeight ?? _tabHeight,
      indicatorHeight: indicatorHeight ?? _indicatorHeight,
      indicatorWidth: indicatorWidth ?? _indicatorWidth,
      labelStyle: labelStyle ?? _labelStyle,
      unselectedLabelStyle: unselectedLabelStyle ?? _unselectedLabelStyle,
      backgroundColor: backgroundColor ?? _backgroundColor,
      tagNormalTextStyle: tagNormalTextStyle ?? _tagNormalTextStyle,
      tagNormalBgColor: tagNormalColor ?? _tagNormalBgColor,
      tagSelectedTextStyle: tagSelectedTextStyle ?? _tagSelectedTextStyle,
      tagSelectedBgColor: tagSelectedColor ?? _tagSelectedBgColor,
      tagRadius: tagRadius ?? _tagRadius,
      tagSpacing: tagSpacing ?? _tagSpacing,
      preLineTagCount: preLineTagSize ?? _preLineTagCount,
      tagHeight: tagHeight ?? _tagHeight,
    );
  }

  SantoTabBarConfig merge(SantoTabBarConfig? other) {
    if (other == null) return this;
    return copyWith(
      tabHeight: other._tabHeight,
      indicatorHeight: other._indicatorHeight,
      indicatorWidth: other._indicatorWidth,
      labelStyle: labelStyle.merge(other._labelStyle),
      unselectedLabelStyle:
          unselectedLabelStyle.merge(other._unselectedLabelStyle),
      backgroundColor: other._backgroundColor,
      tagNormalTextStyle: tagNormalTextStyle.merge(other._tagNormalTextStyle),
      tagNormalColor: other._tagNormalBgColor,
      tagSelectedTextStyle:
          tagSelectedTextStyle.merge(other._tagSelectedTextStyle),
      tagSelectedColor: other._tagSelectedBgColor,
      tagRadius: other._tagRadius,
      tagSpacing: other._tagSpacing,
      preLineTagSize: other._preLineTagCount,
      tagHeight: other._tagHeight,
    );
  }
}
