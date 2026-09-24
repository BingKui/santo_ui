import 'package:santo_ui/src/theme/base/santo_base_config.dart';
import 'package:santo_ui/src/theme/base/santo_text_style.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 区块默认值
///
/// 直接使用常量而非 [SantoDefaultConfigUtils.defaultSectionConfig] 回退,
/// 避免 getter 在默认实例上自引用导致无限递归。
const EdgeInsets kSantoSectionContentPadding = EdgeInsets.all(10);
const EdgeInsets kSantoSectionFooterPadding = EdgeInsets.fromLTRB(16, 12, 16, 16);
const double kSantoSectionRadius = 12;

/// SantoSection 的配置文件 全局配置
class SantoSectionConfig extends SantoBaseConfig {
  /// 遵循外部主题配置
  /// 默认值见 [SantoDefaultConfigUtils.defaultSectionConfig]
  SantoSectionConfig({
    EdgeInsets? contentPadding,
    EdgeInsets? footerPadding,
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    Color? dividerColor,
    SantoTextStyle? titleTextStyle,
    SantoTextStyle? descriptionTextStyle,
    String configId = GLOBAL_CONFIG_ID,
  })  : _contentPadding = contentPadding,
        _footerPadding = footerPadding,
        _backgroundColor = backgroundColor,
        _borderColor = borderColor,
        _borderWidth = borderWidth,
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

  /// 边框颜色
  Color? _borderColor;

  /// 边框宽度
  double? _borderWidth;


  /// 分割线颜色
  Color? _dividerColor;

  /// 标题样式
  SantoTextStyle? _titleTextStyle;

  /// 描述信息样式
  SantoTextStyle? _descriptionTextStyle;

  EdgeInsets get contentPadding =>
      _contentPadding ?? kSantoSectionContentPadding;

  EdgeInsets get footerPadding => _footerPadding ?? kSantoSectionFooterPadding;

  Color get backgroundColor => _backgroundColor ?? commonConfig.fillBase;

  Color get borderColor => _borderColor ?? commonConfig.borderColorBase;

  double get borderWidth => _borderWidth ?? commonConfig.borderWidthSm;

  Color get dividerColor => _dividerColor ?? commonConfig.dividerColorBase;

  SantoTextStyle get titleTextStyle =>
      _titleTextStyle ??
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeSubHead,
        fontWeight: FontWeight.w500,
      );

  SantoTextStyle get descriptionTextStyle =>
      _descriptionTextStyle ??
      SantoTextStyle(
        color: commonConfig.colorTextSecondary,
        fontSize: commonConfig.fontSizeCaption,
        fontWeight: FontWeight.w400,
      );

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
    _borderColor ??= sectionConfig._borderColor;
    _borderWidth ??= sectionConfig._borderWidth;
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
      borderColor: other._borderColor,
      borderWidth: other._borderWidth,
      dividerColor: other._dividerColor,
      titleTextStyle: other._titleTextStyle,
      descriptionTextStyle: other._descriptionTextStyle,
    );
  }

  SantoSectionConfig copyWith({
    EdgeInsets? contentPadding,
    EdgeInsets? footerPadding,
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    Color? dividerColor,
    SantoTextStyle? titleTextStyle,
    SantoTextStyle? descriptionTextStyle,
  }) {
    return SantoSectionConfig(
      contentPadding: contentPadding ?? _contentPadding,
      footerPadding: footerPadding ?? _footerPadding,
      backgroundColor: backgroundColor ?? _backgroundColor,
      borderColor: borderColor ?? _borderColor,
      borderWidth: borderWidth ?? _borderWidth,
      dividerColor: dividerColor ?? _dividerColor,
      titleTextStyle: titleTextStyle ?? _titleTextStyle,
      descriptionTextStyle: descriptionTextStyle ?? _descriptionTextStyle,
    );
  }
}
