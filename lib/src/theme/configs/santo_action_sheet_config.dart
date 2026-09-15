import 'package:santo_ui/src/theme/base/santo_base_config.dart';
import 'package:santo_ui/src/theme/base/santo_default_config_utils.dart';
import 'package:santo_ui/src/theme/base/santo_text_style.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:flutter/material.dart';

/// SantoActionSheet 主题配置
class SantoActionSheetConfig extends SantoBaseConfig {
  /// 遵循外部主题配置
  /// 默认为 [SantoDefaultConfigUtils.defaultActionSheetConfig]
  SantoActionSheetConfig({
    SantoTextStyle? titleStyle,
    SantoTextStyle? itemTitleStyle,
    SantoTextStyle? itemTitleStyleLink,
    SantoTextStyle? itemTitleStyleAlert,
    SantoTextStyle? itemDescStyle,
    SantoTextStyle? itemDescStyleLink,
    SantoTextStyle? itemDescStyleAlert,
    SantoTextStyle? cancelStyle,
    double? topRadius,
    EdgeInsets? contentPadding,
    EdgeInsets? titlePadding,
    String configId = GLOBAL_CONFIG_ID,
  })  : _titleStyle = titleStyle,
        _itemTitleStyle = itemTitleStyle,
        _itemTitleStyleLink = itemTitleStyleLink,
        _itemTitleStyleAlert = itemTitleStyleAlert,
        _itemDescStyle = itemDescStyle,
        _itemDescStyleLink = itemDescStyleLink,
        _itemDescStyleAlert = itemDescStyleAlert,
        _cancelStyle = cancelStyle,
        _topRadius = topRadius,
        _contentPadding = contentPadding,
        _titlePadding = titlePadding,
        super(configId: configId);

  /// ActionSheet 的顶部圆角
  /// 默认值为 [SantoCommonConfig.radiusLg]
  double? _topRadius;

  /// 标题样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextSecondary],
  ///   fontSize: [SantoCommonConfig.fontSizeBase],
  /// )
  SantoTextStyle? _titleStyle;

  /// 元素标题默认样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize:[SantoCommonConfig.fontSizeSubHead],
  /// )
  SantoTextStyle? _itemTitleStyle;

  /// 元素标题链接样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorLink],
  ///   fontSize: [SantoCommonConfig.fontSizeSubHead],
  ///   fontWeight: FontWeight.w600,
  /// )
  SantoTextStyle? _itemTitleStyleLink;

  /// 元素警示项标题样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.brandError],
  ///   fontSize: [SantoCommonConfig.fontSizeBase],
  ///   fontWeight: FontWeight.w600,
  /// )
  SantoTextStyle? _itemTitleStyleAlert;

  /// 元素描述默认样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize: [SantoCommonConfig.fontSizeCaption],
  ///   fontWeight: FontWeight.w600,
  /// )
  SantoTextStyle? _itemDescStyle;

  /// 元素标题描述链接样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorLink],
  ///   fontSize: [SantoCommonConfig.fontSizeCaption],
  ///   fontWeight: FontWeight.w600,
  /// )
  SantoTextStyle? _itemDescStyleLink;

  /// 元素警示项标题描述样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.brandError],
  ///   fontSize: [SantoCommonConfig.fontSizeCaption],
  ///   fontWeight: FontWeight.w600,
  /// )
  SantoTextStyle? _itemDescStyleAlert;

  /// 取消按钮样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize: [SantoCommonConfig.fontSizeSubHead],
  ///   fontWeight: FontWeight.w600,
  /// )
  SantoTextStyle? _cancelStyle;

  /// 内容左右间距
  ///
  /// EdgeInsets.symmetric(horizontal: 60, vertical: 12)
  EdgeInsets? _contentPadding;

  /// 标题左右间距
  ///
  /// EdgeInsets.symmetric(horizontal: 60, vertical: 16)
  EdgeInsets? _titlePadding;

  double get topRadius =>
      _topRadius ?? SantoDefaultConfigUtils.defaultActionSheetConfig.topRadius;

  SantoTextStyle get titleStyle =>
      _titleStyle ?? SantoDefaultConfigUtils.defaultActionSheetConfig.titleStyle;

  SantoTextStyle get itemTitleStyle =>
      _itemTitleStyle ??
      SantoDefaultConfigUtils.defaultActionSheetConfig.itemTitleStyle;

  SantoTextStyle get itemTitleStyleLink =>
      _itemTitleStyleLink ??
      SantoDefaultConfigUtils.defaultActionSheetConfig.itemTitleStyleLink;

  SantoTextStyle get itemTitleStyleAlert =>
      _itemTitleStyleAlert ??
      SantoDefaultConfigUtils.defaultActionSheetConfig.itemTitleStyleAlert;

  SantoTextStyle get itemDescStyle =>
      _itemDescStyle ??
      SantoDefaultConfigUtils.defaultActionSheetConfig.itemDescStyle;

  SantoTextStyle get itemDescStyleLink =>
      _itemDescStyleLink ??
      SantoDefaultConfigUtils.defaultActionSheetConfig.itemDescStyleLink;

  SantoTextStyle get itemDescStyleAlert =>
      _itemDescStyleAlert ??
      SantoDefaultConfigUtils.defaultActionSheetConfig.itemDescStyleAlert;

  SantoTextStyle get cancelStyle =>
      _cancelStyle ??
      SantoDefaultConfigUtils.defaultActionSheetConfig.cancelStyle;

  EdgeInsets get contentPadding =>
      _contentPadding ??
      SantoDefaultConfigUtils.defaultActionSheetConfig.contentPadding;

  EdgeInsets get titlePadding =>
      _titlePadding ??
      SantoDefaultConfigUtils.defaultActionSheetConfig.titlePadding;

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
    SantoActionSheetConfig actionSheetConfig = SantoThemeConfigurator.instance
        .getConfig(configId: configId)
        .actionSheetConfig;

    _titlePadding ??= actionSheetConfig.titlePadding;
    _contentPadding ??= actionSheetConfig.contentPadding;
    _titleStyle = actionSheetConfig.titleStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextSecondary,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_titleStyle),
    );
    _itemTitleStyle = actionSheetConfig.itemTitleStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_itemTitleStyle),
    );
    _itemTitleStyleLink = actionSheetConfig.itemTitleStyleLink.merge(
      SantoTextStyle(
        color: commonConfig.colorLink,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_itemTitleStyleLink),
    );
    _itemTitleStyleAlert = actionSheetConfig.itemTitleStyleAlert.merge(
      SantoTextStyle(
        color: commonConfig.brandError,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_itemTitleStyleAlert),
    );
    _itemDescStyle = actionSheetConfig.itemDescStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeCaption,
      ).merge(_itemDescStyle),
    );
    _itemDescStyleLink = actionSheetConfig.itemDescStyleLink.merge(
      SantoTextStyle(
        color: commonConfig.colorLink,
        fontSize: commonConfig.fontSizeCaption,
      ).merge(_itemDescStyleLink),
    );
    _itemDescStyleAlert = actionSheetConfig.itemDescStyleAlert.merge(
      SantoTextStyle(
        color: commonConfig.brandError,
        fontSize: commonConfig.fontSizeCaption,
      ).merge(_itemDescStyleAlert),
    );
    _cancelStyle = actionSheetConfig.cancelStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_cancelStyle),
    );
    _topRadius ??= commonConfig.radiusLg;
  }

  SantoActionSheetConfig copyWith({
    double? topRadius,
    SantoTextStyle? titleStyle,
    SantoTextStyle? itemTitleStyle,
    SantoTextStyle? itemTitleStyleLink,
    SantoTextStyle? itemTitleStyleAlert,
    SantoTextStyle? itemDescStyle,
    SantoTextStyle? itemDescStyleLink,
    SantoTextStyle? itemDescStyleAlert,
    SantoTextStyle? cancelStyle,
    EdgeInsets? contentPadding,
    EdgeInsets? titlePadding,
  }) {
    return SantoActionSheetConfig(
      titleStyle: titleStyle ?? _titleStyle,
      itemTitleStyle: itemTitleStyle ?? _itemTitleStyle,
      itemTitleStyleLink: itemTitleStyleLink ?? _itemTitleStyleLink,
      itemTitleStyleAlert: itemTitleStyleAlert ?? _itemTitleStyleAlert,
      itemDescStyle: itemDescStyle ?? _itemDescStyle,
      itemDescStyleLink: itemDescStyleLink ?? _itemDescStyleLink,
      itemDescStyleAlert: itemDescStyleAlert ?? _itemDescStyleAlert,
      cancelStyle: cancelStyle ?? _cancelStyle,
      topRadius: topRadius ?? _topRadius,
      contentPadding: contentPadding ?? _contentPadding,
      titlePadding: titlePadding ?? _titlePadding,
    );
  }

  SantoActionSheetConfig merge(SantoActionSheetConfig? other) {
    if (other == null) return this;
    return copyWith(
      titleStyle: titleStyle.merge(other._titleStyle),
      itemTitleStyle: itemTitleStyle.merge(other._itemTitleStyle),
      itemTitleStyleLink: itemTitleStyleLink.merge(other._itemTitleStyleLink),
      itemTitleStyleAlert:
          itemTitleStyleAlert.merge(other._itemTitleStyleAlert),
      itemDescStyle: itemDescStyle.merge(other._itemDescStyle),
      itemDescStyleLink: itemDescStyleLink.merge(other._itemDescStyleLink),
      itemDescStyleAlert: itemDescStyleAlert.merge(other._itemDescStyleAlert),
      cancelStyle: cancelStyle.merge(other._cancelStyle),
      topRadius: other._topRadius,
      contentPadding: other._contentPadding,
      titlePadding: other._titlePadding,
    );
  }
}
