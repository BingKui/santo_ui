import 'package:santo_ui/src/theme/base/santo_base_config.dart';
import 'package:santo_ui/src/theme/base/santo_default_config_utils.dart';
import 'package:santo_ui/src/theme/base/santo_text_style.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/painting.dart';

/// SantoSection 的配置文件 全局配置
class SantoSectionConfig extends SantoBaseConfig {
  /// 遵循外部主题配置
  /// 默认为 [SantoDefaultConfigUtils.defaultSectionConfig]
  SantoSectionConfig({
    EdgeInsets? contentPadding,
    EdgeInsets? footerPadding,
    Color? backgroundColor,
    double? radius,
    Color? borderColor,
    double? borderWidth,
    bool? showDivider,
    Color? dividerColor,
    SantoTextStyle? titleTextStyle,
    SantoTextStyle? descriptionTextStyle,
    String configId = GLOBAL_CONFIG_ID,
  })  : _contentPadding = contentPadding,
        _footerPadding = footerPadding,
        _backgroundColor = backgroundColor,
        _radius = radius,
        _borderColor = borderColor,
        _borderWidth = borderWidth,
        _showDivider = showDivider,
        _dividerColor = dividerColor,
        _titleTextStyle = titleTextStyle,
        _descriptionTextStyle = descriptionTextStyle,
        super(configId: configId);

  /// 展示区域内边距
  EdgeInsets? _contentPadding;

  /// 标题/描述区域内边距
  EdgeInsets? _footerPadding;

  /// 背景色
  Color? _backgroundColor;

  /// 圆角
  double? _radius;

  /// 边框颜色
  Color? _borderColor;

  /// 边框宽度
  double? _borderWidth;

  /// 展示区与标题之间是否显示分割线
  bool? _showDivider;

  /// 分割线颜色
  Color? _dividerColor;

  /// 标题样式
  SantoTextStyle? _titleTextStyle;

  /// 描述信息样式
  SantoTextStyle? _descriptionTextStyle;

  EdgeInsets get contentPadding =>
      _contentPadding ?? SantoDefaultConfigUtils.defaultSectionConfig.contentPadding;

  EdgeInsets get footerPadding =>
      _footerPadding ?? SantoDefaultConfigUtils.defaultSectionConfig.footerPadding;

  Color get backgroundColor =>
      _backgroundColor ?? SantoDefaultConfigUtils.defaultSectionConfig.backgroundColor;

  double get radius =>
      _radius ?? SantoDefaultConfigUtils.defaultSectionConfig.radius;

  Color get borderColor =>
      _borderColor ?? SantoDefaultConfigUtils.defaultSectionConfig.borderColor;

  double get borderWidth =>
      _borderWidth ?? SantoDefaultConfigUtils.defaultSectionConfig.borderWidth;

  bool get showDivider =>
      _showDivider ?? SantoDefaultConfigUtils.defaultSectionConfig.showDivider;

  Color get dividerColor =>
      _dividerColor ?? SantoDefaultConfigUtils.defaultSectionConfig.dividerColor;

  SantoTextStyle get titleTextStyle =>
      _titleTextStyle ?? SantoDefaultConfigUtils.defaultSectionConfig.titleTextStyle;

  SantoTextStyle get descriptionTextStyle =>
      _descriptionTextStyle ??
      SantoDefaultConfigUtils.defaultSectionConfig.descriptionTextStyle;

  @override
  void initThemeConfig(
    String configId, {
    SantoCommonConfig? currentLevelCommonConfig,
  }) {
    super.initThemeConfig(
      configId,
      currentLevelCommonConfig: currentLevelCommonConfig,
    );

    SantoSectionConfig sectionConfig = SantoThemeConfigurator.instance
        .getConfig(configId: configId)
        .sectionConfig;

    _contentPadding ??= sectionConfig._contentPadding;
    _footerPadding ??= sectionConfig._footerPadding;
    _backgroundColor ??= sectionConfig._backgroundColor;
    _radius ??= sectionConfig._radius;
    _borderColor ??= sectionConfig._borderColor;
    _borderWidth ??= sectionConfig._borderWidth;
    _showDivider ??= sectionConfig._showDivider;
    _dividerColor ??= sectionConfig._dividerColor;

    _titleTextStyle = sectionConfig.titleTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeSubHead,
        fontWeight: FontWeight.w500,
      ).merge(_titleTextStyle),
    );

    _descriptionTextStyle = sectionConfig.descriptionTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextSecondary,
        fontSize: commonConfig.fontSizeCaption,
        fontWeight: FontWeight.w400,
      ).merge(_descriptionTextStyle),
    );
  }

  /// 合并配置,[other] 中的非空字段优先
  SantoSectionConfig merge(SantoSectionConfig? other) {
    if (other == null) return this;
    return copyWith(
      contentPadding: other._contentPadding,
      footerPadding: other._footerPadding,
      backgroundColor: other._backgroundColor,
      radius: other._radius,
      borderColor: other._borderColor,
      borderWidth: other._borderWidth,
      showDivider: other._showDivider,
      dividerColor: other._dividerColor,
      titleTextStyle: other._titleTextStyle,
      descriptionTextStyle: other._descriptionTextStyle,
    );
  }

  SantoSectionConfig copyWith({
    EdgeInsets? contentPadding,
    EdgeInsets? footerPadding,
    Color? backgroundColor,
    double? radius,
    Color? borderColor,
    double? borderWidth,
    bool? showDivider,
    Color? dividerColor,
    SantoTextStyle? titleTextStyle,
    SantoTextStyle? descriptionTextStyle,
  }) {
    return SantoSectionConfig(
      contentPadding: contentPadding ?? _contentPadding,
      footerPadding: footerPadding ?? _footerPadding,
      backgroundColor: backgroundColor ?? _backgroundColor,
      radius: radius ?? _radius,
      borderColor: borderColor ?? _borderColor,
      borderWidth: borderWidth ?? _borderWidth,
      showDivider: showDivider ?? _showDivider,
      dividerColor: dividerColor ?? _dividerColor,
      titleTextStyle: titleTextStyle ?? _titleTextStyle,
      descriptionTextStyle: descriptionTextStyle ?? _descriptionTextStyle,
    );
  }
}
