import 'package:santo_ui/src/theme/base/santo_base_config.dart';
import 'package:santo_ui/src/theme/base/santo_default_config_utils.dart';
import 'package:santo_ui/src/theme/base/santo_text_style.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:flutter/material.dart';

/// 卡片标题 配置类
class SantoCardTitleConfig extends SantoBaseConfig {
  SantoCardTitleConfig({
    SantoTextStyle? titleWithHeightTextStyle,
    SantoTextStyle? detailTextStyle,
    SantoTextStyle? accessoryTextStyle,
    EdgeInsets? cardTitlePadding,
    SantoTextStyle? titleTextStyle,
    SantoTextStyle? subtitleTextStyle,
    PlaceholderAlignment? alignment,
    Color? cardBackgroundColor,
    String configId = GLOBAL_CONFIG_ID,
  })  : _titleWithHeightTextStyle = titleWithHeightTextStyle,
        _detailTextStyle = detailTextStyle,
        _accessoryTextStyle = accessoryTextStyle,
        _cardTitlePadding = cardTitlePadding,
        _titleTextStyle = titleTextStyle,
        _subtitleTextStyle = subtitleTextStyle,
        _alignment = alignment,
        _cardBackgroundColor = cardBackgroundColor,
        super(configId: configId);

  /// 标题外边距间距
  ///
  /// EdgeInsets.only(
  ///   top: [SantoCommonConfig.vSpacingXl],
  ///   bottom: [SantoCommonConfig.vSpacingMd],
  /// )
  EdgeInsets? _cardTitlePadding;

  EdgeInsets get cardTitlePadding =>
      _cardTitlePadding ??
      SantoDefaultConfigUtils.defaultCardTitleConfig.cardTitlePadding;

  /// 标题文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize: [SantoCommonConfig.fontSizeHead],
  ///   fontWeight: FontWeight.w600,
  ///   height: 25 / 18,
  /// )
  SantoTextStyle? _titleWithHeightTextStyle;

  SantoTextStyle get titleWithHeightTextStyle =>
      _titleWithHeightTextStyle ??
      SantoDefaultConfigUtils.defaultCardTitleConfig.titleWithHeightTextStyle;

  /// 标题文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize: [SantoCommonConfig.fontSizeHead],
  ///   fontWeight: FontWeight.w600,
  /// )
  SantoTextStyle? _titleTextStyle;

  SantoTextStyle get titleTextStyle =>
      _titleTextStyle ??
      SantoDefaultConfigUtils.defaultCardTitleConfig.titleTextStyle;

  /// 标题右边的副标题文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextSecondary],
  ///   fontSize: [SantoCommonConfig.fontSizeBase],
  /// )
  SantoTextStyle? _subtitleTextStyle;

  SantoTextStyle get subtitleTextStyle =>
      _subtitleTextStyle ??
      SantoDefaultConfigUtils.defaultCardTitleConfig.subtitleTextStyle;

  /// 详情文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize: [SantoCommonConfig.fontSizeBase],
  /// )
  SantoTextStyle? _detailTextStyle;

  SantoTextStyle get detailTextStyle =>
      _detailTextStyle ??
      SantoDefaultConfigUtils.defaultCardTitleConfig.detailTextStyle;

  /// 辅助文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextSecondary],
  ///   fontSize: [SantoCommonConfig.fontSizeBase],
  /// )
  SantoTextStyle? _accessoryTextStyle;

  SantoTextStyle get accessoryTextStyle =>
      _accessoryTextStyle ??
      SantoDefaultConfigUtils.defaultCardTitleConfig.accessoryTextStyle;

  /// 对齐方式
  /// 默认为 [PlaceholderAlignment.middle]
  PlaceholderAlignment? _alignment;

  PlaceholderAlignment get alignment =>
      _alignment ?? SantoDefaultConfigUtils.defaultCardTitleConfig.alignment;

  /// 卡片背景
  /// 默认为 [SantoCommonConfig.fillBase]
  Color? _cardBackgroundColor;

  Color get cardBackgroundColor =>
      _cardBackgroundColor ??
      SantoDefaultConfigUtils.defaultCardTitleConfig.cardBackgroundColor;

  /// cardTitleConfig  获取逻辑详见 [SantoThemeConfigurator.getConfig] 方法
  @override
  void initThemeConfig(
    String configId, {
    SantoCommonConfig? currentLevelCommonConfig,
  }) {
    super.initThemeConfig(
      configId,
      currentLevelCommonConfig: currentLevelCommonConfig,
    );

    SantoCardTitleConfig cardTitleConfig = SantoThemeConfigurator.instance
        .getConfig(configId: configId)
        .cardTitleConfig;

    _cardBackgroundColor ??= commonConfig.fillBase;
    _cardTitlePadding ??= EdgeInsets.only(
      left: cardTitleConfig.cardTitlePadding.left,
      top: commonConfig.vSpacingXl,
      right: cardTitleConfig.cardTitlePadding.right,
      bottom: commonConfig.vSpacingMd,
    );
    _titleWithHeightTextStyle = cardTitleConfig.titleWithHeightTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeHead,
      ).merge(_titleWithHeightTextStyle),
    );
    _titleTextStyle = cardTitleConfig.titleTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeHead,
      ).merge(_titleTextStyle),
    );
    _subtitleTextStyle = cardTitleConfig.subtitleTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_subtitleTextStyle),
    );
    _accessoryTextStyle = cardTitleConfig.accessoryTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextSecondary,
        fontSize: commonConfig.fontSizeHead,
      ).merge(_accessoryTextStyle),
    );
    _detailTextStyle = cardTitleConfig.detailTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_detailTextStyle),
    );
    _alignment ??= cardTitleConfig._alignment;
  }

  SantoCardTitleConfig copyWith({
    EdgeInsets? cardTitlePadding,
    SantoTextStyle? titleWithHeightTextStyle,
    SantoTextStyle? titleTextStyle,
    SantoTextStyle? subtitleTextStyle,
    SantoTextStyle? detailTextStyle,
    SantoTextStyle? accessoryTextStyle,
    PlaceholderAlignment? alignment,
    Color? cardBackgroundColor,
  }) {
    return SantoCardTitleConfig(
      cardTitlePadding: cardTitlePadding ?? _cardTitlePadding,
      titleWithHeightTextStyle:
          titleWithHeightTextStyle ?? _titleWithHeightTextStyle,
      titleTextStyle: titleTextStyle ?? _titleTextStyle,
      subtitleTextStyle: subtitleTextStyle ?? _subtitleTextStyle,
      detailTextStyle: detailTextStyle ?? _detailTextStyle,
      accessoryTextStyle: accessoryTextStyle ?? _accessoryTextStyle,
      alignment: alignment ?? _alignment,
      cardBackgroundColor: cardBackgroundColor ?? _cardBackgroundColor,
    );
  }

  SantoCardTitleConfig merge(SantoCardTitleConfig? other) {
    if (other == null) return this;
    return copyWith(
      cardTitlePadding: other._cardTitlePadding,
      titleWithHeightTextStyle:
          titleWithHeightTextStyle.merge(other._titleWithHeightTextStyle),
      titleTextStyle: titleTextStyle.merge(other._titleTextStyle),
      subtitleTextStyle: subtitleTextStyle.merge(other._subtitleTextStyle),
      detailTextStyle: detailTextStyle.merge(other._detailTextStyle),
      accessoryTextStyle: accessoryTextStyle.merge(other._accessoryTextStyle),
      alignment: other._alignment,
      cardBackgroundColor: other._cardBackgroundColor,
    );
  }
}
