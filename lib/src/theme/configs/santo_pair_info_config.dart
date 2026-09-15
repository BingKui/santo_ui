import 'package:santo_ui/src/theme/base/santo_base_config.dart';
import 'package:santo_ui/src/theme/base/santo_default_config_utils.dart';
import 'package:santo_ui/src/theme/base/santo_text_style.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';

/// SantoPairInfoTable 的配置文件 全局配置
class SantoPairInfoTableConfig extends SantoBaseConfig {
  /// 遵循外部主题配置
  /// 默认为 [SantoDefaultConfigUtils.defaultPairInfoTableConfig]
  SantoPairInfoTableConfig({
    double? rowSpacing,
    double? itemSpacing,
    SantoTextStyle? keyTextStyle,
    SantoTextStyle? valueTextStyle,
    SantoTextStyle? linkTextStyle,
    String configId = GLOBAL_CONFIG_ID,
  })  : _rowSpacing = rowSpacing,
        _itemSpacing = itemSpacing,
        _keyTextStyle = keyTextStyle,
        _valueTextStyle = valueTextStyle,
        _linkTextStyle = linkTextStyle,
        super(configId: configId);

  /// 行间距 纵向
  double? _rowSpacing;

  /// SantoInfoModal 属性配置 行间距
  double? _itemSpacing;

  /// SantoInfoModal key文字样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextSecondary],
  ///   fontSize: [SantoCommonConfig.fontSizeBase],
  ///   fontWeight: FontWeight.w400,
  /// )
  SantoTextStyle? _keyTextStyle;

  /// SantoInfoModal value文字样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize: [SantoCommonConfig.fontSizeBase],
  ///   fontWeight: FontWeight.w400,
  /// )
  SantoTextStyle? _valueTextStyle;

  /// SantoInfoModal 链接文字样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.brandPrimary],
  ///   fontWeight: FontWeight.w400,
  ///   fontSize: [SantoCommonConfig.fontSizeBase]
  /// )
  SantoTextStyle? _linkTextStyle;

  double get rowSpacing =>
      _rowSpacing ??
      SantoDefaultConfigUtils.defaultPairInfoTableConfig.rowSpacing;

  double get itemSpacing =>
      _itemSpacing ??
      SantoDefaultConfigUtils.defaultPairInfoTableConfig.itemSpacing;

  SantoTextStyle get keyTextStyle =>
      _keyTextStyle ??
      SantoDefaultConfigUtils.defaultPairInfoTableConfig.keyTextStyle;

  SantoTextStyle get valueTextStyle =>
      _valueTextStyle ??
      SantoDefaultConfigUtils.defaultPairInfoTableConfig.valueTextStyle;

  SantoTextStyle get linkTextStyle =>
      _linkTextStyle ??
      SantoDefaultConfigUtils.defaultPairInfoTableConfig.linkTextStyle;

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
    SantoPairInfoTableConfig pairInfoTableConfig = SantoThemeConfigurator.instance
        .getConfig(configId: configId)
        .pairInfoTableConfig;

    _rowSpacing ??= pairInfoTableConfig._rowSpacing;
    _keyTextStyle = pairInfoTableConfig.keyTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextSecondary,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_keyTextStyle),
    );
    _valueTextStyle = pairInfoTableConfig.valueTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_valueTextStyle),
    );
    _linkTextStyle = pairInfoTableConfig.linkTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.brandPrimary,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_linkTextStyle),
    );
    _itemSpacing ??= pairInfoTableConfig._itemSpacing;
  }

  SantoPairInfoTableConfig copyWith({
    double? rowSpacing,
    double? itemSpacing,
    SantoTextStyle? keyTextStyle,
    SantoTextStyle? valueTextStyle,
    SantoTextStyle? linkTextStyle,
  }) {
    return SantoPairInfoTableConfig(
      rowSpacing: rowSpacing ?? _rowSpacing,
      itemSpacing: itemSpacing ?? _itemSpacing,
      keyTextStyle: keyTextStyle ?? _keyTextStyle,
      valueTextStyle: valueTextStyle ?? _valueTextStyle,
      linkTextStyle: linkTextStyle ?? _linkTextStyle,
    );
  }

  SantoPairInfoTableConfig merge(SantoPairInfoTableConfig? other) {
    if (other == null) return this;
    return copyWith(
      rowSpacing: other._rowSpacing,
      itemSpacing: other._itemSpacing,
      keyTextStyle: keyTextStyle.merge(other._keyTextStyle),
      valueTextStyle: valueTextStyle.merge(other._valueTextStyle),
      linkTextStyle: linkTextStyle.merge(other._linkTextStyle),
    );
  }
}

class SantoPairRichInfoGridConfig extends SantoBaseConfig {
  /// 遵循外部主题配置
  /// 默认为 [SantoDefaultConfigUtils.defaultPairRichInfoGridConfig]
  SantoPairRichInfoGridConfig({
    double? rowSpacing,
    double? itemSpacing,
    double? itemHeight,
    SantoTextStyle? keyTextStyle,
    SantoTextStyle? valueTextStyle,
    SantoTextStyle? linkTextStyle,
    String configId = GLOBAL_CONFIG_ID,
  })  : _rowSpacing = rowSpacing,
        _itemSpacing = itemSpacing,
        _itemHeight = itemHeight,
        _keyTextStyle = keyTextStyle,
        _valueTextStyle = valueTextStyle,
        _linkTextStyle = linkTextStyle,
        super(configId: configId);

  /// 行间距 纵向
  double? _rowSpacing;

  /// 元素间距 横向
  double? _itemSpacing;

  /// 元素高度
  double? _itemHeight;

  /// key文字样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextSecondary],
  ///   fontSize: [SantoCommonConfig.fontSizeBase],
  ///   fontWeight: FontWeight.w400,
  /// )
  SantoTextStyle? _keyTextStyle;

  /// value文字样式
  ///
  /// SantoTextStyle(
  ///   fontWeight: FontWeight.w400,
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize: [SantoCommonConfig.fontSizeBase],
  /// )
  SantoTextStyle? _valueTextStyle;

  /// 链接文字样式
  ///
  /// SantoTextStyle(
  ///   fontWeight: FontWeight.w400,
  ///   color: [SantoCommonConfig.brandPrimary],
  ///   fontSize: [SantoCommonConfig.fontSizeBase],
  /// )
  SantoTextStyle? _linkTextStyle;

  double get rowSpacing =>
      _rowSpacing ??
      SantoDefaultConfigUtils.defaultPairRichInfoGridConfig.rowSpacing;

  double get itemSpacing =>
      _itemSpacing ??
      SantoDefaultConfigUtils.defaultPairRichInfoGridConfig.itemSpacing;

  double get itemHeight =>
      _itemHeight ??
      SantoDefaultConfigUtils.defaultPairRichInfoGridConfig.itemHeight;

  SantoTextStyle get keyTextStyle =>
      _keyTextStyle ??
      SantoDefaultConfigUtils.defaultPairRichInfoGridConfig.keyTextStyle;

  SantoTextStyle get valueTextStyle =>
      _valueTextStyle ??
      SantoDefaultConfigUtils.defaultPairRichInfoGridConfig.valueTextStyle;

  SantoTextStyle get linkTextStyle =>
      _linkTextStyle ??
      SantoDefaultConfigUtils.defaultPairRichInfoGridConfig.linkTextStyle;

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
    SantoPairRichInfoGridConfig pairRichInfoGridConfig = SantoThemeConfigurator
        .instance
        .getConfig(configId: configId)
        .pairRichInfoGridConfig;

    _rowSpacing ??= pairRichInfoGridConfig._rowSpacing;
    _itemSpacing ??= pairRichInfoGridConfig._itemSpacing;
    _itemHeight ??= pairRichInfoGridConfig._itemHeight;
    _keyTextStyle = pairRichInfoGridConfig.keyTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextSecondary,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_keyTextStyle),
    );
    _valueTextStyle = pairRichInfoGridConfig.valueTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_valueTextStyle),
    );
    _linkTextStyle = pairRichInfoGridConfig.linkTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.brandPrimary,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_linkTextStyle),
    );
  }

  SantoPairRichInfoGridConfig copyWith({
    double? rowSpacing,
    double? itemSpacing,
    double? itemHeight,
    SantoTextStyle? keyTextStyle,
    SantoTextStyle? valueTextStyle,
    SantoTextStyle? linkTextStyle,
    SantoTextStyle? titleTextsStyle,
  }) {
    return SantoPairRichInfoGridConfig(
      rowSpacing: rowSpacing ?? _rowSpacing,
      itemSpacing: itemSpacing ?? _itemSpacing,
      itemHeight: itemHeight ?? _itemHeight,
      keyTextStyle: keyTextStyle ?? _keyTextStyle,
      valueTextStyle: valueTextStyle ?? _valueTextStyle,
      linkTextStyle: linkTextStyle ?? _linkTextStyle,
    );
  }

  SantoPairRichInfoGridConfig merge(SantoPairRichInfoGridConfig? other) {
    if (other == null) return this;
    return copyWith(
      rowSpacing: other._rowSpacing,
      itemSpacing: other._itemSpacing,
      itemHeight: other._itemHeight,
      keyTextStyle: keyTextStyle.merge(other._keyTextStyle),
      valueTextStyle: valueTextStyle.merge(other._valueTextStyle),
      linkTextStyle: linkTextStyle.merge(other._linkTextStyle),
    );
  }
}
