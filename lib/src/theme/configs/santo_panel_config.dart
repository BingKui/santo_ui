import 'package:santo_ui/src/theme/base/santo_base_config.dart';
import 'package:santo_ui/src/theme/base/santo_default_config_utils.dart';
import 'package:santo_ui/src/theme/base/santo_text_style.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/painting.dart';

/// SantoPanel 的配置文件 全局配置
class SantoPanelConfig extends SantoBaseConfig {
  /// 遵循外部主题配置
  /// 默认为 [SantoDefaultConfigUtils.defaultPanelConfig]
  SantoPanelConfig({
    EdgeInsets? margin,
    EdgeInsets? contentPadding,
    Color? backgroundColor,
    double? radius,
    double? headerHeight,
    SantoTextStyle? titleTextStyle,
    Color? borderColor,
    double? borderWidth,
    bool? showHeaderDivider,
    String configId = GLOBAL_CONFIG_ID,
  })  : _margin = margin,
        _contentPadding = contentPadding,
        _backgroundColor = backgroundColor,
        _radius = radius,
        _headerHeight = headerHeight,
        _titleTextStyle = titleTextStyle,
        super(configId: configId);

  /// 面板外边距
  EdgeInsets? _margin;

  /// 内容区域内边距,可在组件内通过 contentPadding 参数关闭
  EdgeInsets? _contentPadding;

  /// 面板背景色
  Color? _backgroundColor;

  /// 面板圆角
  double? _radius;

  /// Header 区域高度,默认自适应内容
  double? _headerHeight;

  /// Header 左侧标题样式
  SantoTextStyle? _titleTextStyle;

  /// 面板边框颜色
  Color? _borderColor;

  /// 面板边框宽度
  double? _borderWidth;

  /// 是否显示 Header 底部分割线
  bool? _showHeaderDivider;

  EdgeInsets get margin =>
      _margin ?? SantoDefaultConfigUtils.defaultPanelConfig.margin;

  EdgeInsets get contentPadding =>
      _contentPadding ??
      SantoDefaultConfigUtils.defaultPanelConfig.contentPadding;

  Color get backgroundColor =>
      _backgroundColor ??
      SantoDefaultConfigUtils.defaultPanelConfig.backgroundColor;

  double get radius =>
      _radius ?? SantoDefaultConfigUtils.defaultPanelConfig.radius;

  double get headerHeight =>
      _headerHeight ?? SantoDefaultConfigUtils.defaultPanelConfig.headerHeight;

  SantoTextStyle get titleTextStyle =>
      _titleTextStyle ??
      SantoDefaultConfigUtils.defaultPanelConfig.titleTextStyle;

  Color get borderColor =>
      _borderColor ?? SantoDefaultConfigUtils.defaultPanelConfig.borderColor;

  double get borderWidth =>
      _borderWidth ?? SantoDefaultConfigUtils.defaultPanelConfig.borderWidth;

  bool get showHeaderDivider =>
      _showHeaderDivider ??
      SantoDefaultConfigUtils.defaultPanelConfig.showHeaderDivider;

  @override
  void initThemeConfig(
    String configId, {
    SantoCommonConfig? currentLevelCommonConfig,
  }) {
    super.initThemeConfig(
      configId,
      currentLevelCommonConfig: currentLevelCommonConfig,
    );

    SantoPanelConfig panelConfig = SantoThemeConfigurator.instance
        .getConfig(configId: configId)
        .panelConfig;

    _margin ??= panelConfig._margin;
    _contentPadding ??= panelConfig._contentPadding;
    _backgroundColor ??= panelConfig._backgroundColor;
    _radius ??= panelConfig._radius;
    _headerHeight ??= panelConfig._headerHeight;
    _borderColor ??= panelConfig._borderColor;
    _borderWidth ??= panelConfig._borderWidth;
    _showHeaderDivider ??= panelConfig._showHeaderDivider;
    _titleTextStyle = panelConfig.titleTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeSubHead,
        fontWeight: FontWeight.w600,
      ).merge(_titleTextStyle),
    );
  }

  /// 合并配置,[other] 中的非空字段优先
  SantoPanelConfig merge(SantoPanelConfig? other) {
    if (other == null) return this;
    return copyWith(
      margin: other._margin,
      contentPadding: other._contentPadding,
      backgroundColor: other._backgroundColor,
      radius: other._radius,
      headerHeight: other._headerHeight,
      titleTextStyle: other._titleTextStyle,
      borderColor: other._borderColor,
      borderWidth: other._borderWidth,
      showHeaderDivider: other._showHeaderDivider,
    );
  }

  SantoPanelConfig copyWith({
    EdgeInsets? margin,
    EdgeInsets? contentPadding,
    Color? backgroundColor,
    double? radius,
    double? headerHeight,
    SantoTextStyle? titleTextStyle,
    Color? borderColor,
    double? borderWidth,
    bool? showHeaderDivider,
  }) {
    return SantoPanelConfig(
      margin: margin ?? _margin,
      contentPadding: contentPadding ?? _contentPadding,
      backgroundColor: backgroundColor ?? _backgroundColor,
      radius: radius ?? _radius,
      headerHeight: headerHeight ?? _headerHeight,
      titleTextStyle: titleTextStyle ?? _titleTextStyle,
      borderColor: borderColor ?? _borderColor,
      borderWidth: borderWidth ?? _borderWidth,
      showHeaderDivider: showHeaderDivider ?? _showHeaderDivider,
    );
  }
}
