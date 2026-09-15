import 'package:santo_ui/src/theme/base/santo_base_config.dart';
import 'package:santo_ui/src/theme/base/santo_default_config_utils.dart';
import 'package:santo_ui/src/theme/base/santo_text_style.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';

/// 描述: 空页面配置类
class SantoAbnormalStateConfig extends SantoBaseConfig {
  SantoAbnormalStateConfig({
    SantoTextStyle? titleTextStyle,
    SantoTextStyle? contentTextStyle,
    SantoTextStyle? operateTextStyle,
    double? btnRadius,
    SantoTextStyle? singleTextStyle,
    SantoTextStyle? doubleTextStyle,
    double? singleMinWidth,
    double? doubleMinWidth,
    String configId = GLOBAL_CONFIG_ID,
  })  : _titleTextStyle = titleTextStyle,
        _contentTextStyle = contentTextStyle,
        _operateTextStyle = operateTextStyle,
        _btnRadius = btnRadius,
        _singleTextStyle = singleTextStyle,
        _doubleTextStyle = doubleTextStyle,
        _singleMinWidth = singleMinWidth,
        _doubleMinWidth = doubleMinWidth,
        super(configId: configId);

  /// 文案区域标题
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize: [SantoCommonConfig.fontSizeSubHead],
  ///   fontWeight: FontWeight.w600,
  /// )
  SantoTextStyle? _titleTextStyle;

  /// 文案区域内容
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextHint],
  ///   fontSize: [SantoCommonConfig.fontSizeBase],
  /// )
  SantoTextStyle? _contentTextStyle;

  /// 操作区域文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.brandPrimary],
  ///   fontSize: [SantoCommonConfig.fontSizeBase],
  /// )
  SantoTextStyle? _operateTextStyle;

  /// 圆角
  /// default value is [SantoCommonConfig.radiusSm]
  double? _btnRadius;

  /// 单按钮文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBaseInverse],
  ///   fontSize: [SantoCommonConfig.fontSizeSubHead],
  /// )
  SantoTextStyle? _singleTextStyle;

  /// 双按钮文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.brandPrimary],
  ///   fontSize: [SantoCommonConfig.fontSizeSubHead],
  /// )
  SantoTextStyle? _doubleTextStyle;

  /// 单按钮的按钮最小宽度
  /// 默认值为 160
  double? _singleMinWidth;

  /// 多按钮的按钮最小宽度
  /// 默认值为 120
  double? _doubleMinWidth;

  SantoTextStyle get titleTextStyle =>
      _titleTextStyle ??
      SantoDefaultConfigUtils.defaultAbnormalStateConfig.titleTextStyle;

  SantoTextStyle get contentTextStyle =>
      _contentTextStyle ??
      SantoDefaultConfigUtils.defaultAbnormalStateConfig.contentTextStyle;

  SantoTextStyle get operateTextStyle =>
      _operateTextStyle ??
      SantoDefaultConfigUtils.defaultAbnormalStateConfig.operateTextStyle;

  double get btnRadius =>
      _btnRadius ?? SantoDefaultConfigUtils.defaultAbnormalStateConfig.btnRadius;

  SantoTextStyle get singleTextStyle =>
      _singleTextStyle ??
      SantoDefaultConfigUtils.defaultAbnormalStateConfig.singleTextStyle;

  SantoTextStyle get doubleTextStyle =>
      _doubleTextStyle ??
      SantoDefaultConfigUtils.defaultAbnormalStateConfig.doubleTextStyle;

  double get singleMinWidth =>
      _singleMinWidth ??
      SantoDefaultConfigUtils.defaultAbnormalStateConfig.singleMinWidth;

  double get doubleMinWidth =>
      _doubleMinWidth ??
      SantoDefaultConfigUtils.defaultAbnormalStateConfig.doubleMinWidth;

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
    SantoAbnormalStateConfig abnormalStateConfig = SantoThemeConfigurator.instance
        .getConfig(configId: configId)
        .abnormalStateConfig;

    _titleTextStyle = abnormalStateConfig.titleTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_titleTextStyle),
    );
    _contentTextStyle = abnormalStateConfig.contentTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextHint,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_contentTextStyle),
    );
    _operateTextStyle = abnormalStateConfig.operateTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.brandPrimary,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_operateTextStyle),
    );
    _singleTextStyle = abnormalStateConfig.singleTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBaseInverse,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_singleTextStyle),
    );
    _doubleTextStyle = abnormalStateConfig.doubleTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.brandPrimary,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_doubleTextStyle),
    );
    _btnRadius ??= abnormalStateConfig._btnRadius;
    _singleMinWidth ??= abnormalStateConfig._singleMinWidth;
    _doubleMinWidth ??= abnormalStateConfig._doubleMinWidth;
  }

  SantoAbnormalStateConfig copyWith({
    SantoTextStyle? titleTextStyle,
    SantoTextStyle? contentTextStyle,
    SantoTextStyle? operateTextStyle,
    double? btnRadius,
    SantoTextStyle? singleTextStyle,
    SantoTextStyle? doubleTextStyle,
    double? singleMinWidth,
    double? doubleMinWidth,
  }) {
    return SantoAbnormalStateConfig(
      titleTextStyle: titleTextStyle ?? _titleTextStyle,
      contentTextStyle: contentTextStyle ?? _contentTextStyle,
      operateTextStyle: operateTextStyle ?? _operateTextStyle,
      btnRadius: btnRadius ?? _btnRadius,
      singleTextStyle: singleTextStyle ?? _singleTextStyle,
      doubleTextStyle: doubleTextStyle ?? _doubleTextStyle,
      singleMinWidth: singleMinWidth ?? _singleMinWidth,
      doubleMinWidth: doubleMinWidth ?? _doubleMinWidth,
    );
  }

  SantoAbnormalStateConfig merge(SantoAbnormalStateConfig? other) {
    if (other == null) return this;
    return copyWith(
      titleTextStyle: titleTextStyle.merge(other._titleTextStyle),
      contentTextStyle: contentTextStyle.merge(other._contentTextStyle),
      operateTextStyle: operateTextStyle.merge(other._operateTextStyle),
      btnRadius: other._btnRadius,
      singleTextStyle: singleTextStyle.merge(other._singleTextStyle),
      doubleTextStyle: doubleTextStyle.merge(other._doubleTextStyle),
      singleMinWidth: other._singleMinWidth,
      doubleMinWidth: other._doubleMinWidth,
    );
  }
}
