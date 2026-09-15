import 'package:santo_ui/src/theme/base/santo_base_config.dart';
import 'package:santo_ui/src/theme/base/santo_default_config_utils.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';

/// 按钮基础配置
class SantoButtonConfig extends SantoBaseConfig {
  /// 遵循外部主题配置
  /// 默认为 [SantoDefaultConfigUtils.defaultButtonConfig]
  SantoButtonConfig({
    double? bigButtonRadius,
    double? bigButtonHeight,
    double? bigButtonFontSize,
    double? smallButtonRadius,
    double? smallButtonHeight,
    double? smallButtonFontSize,
    String configId = GLOBAL_CONFIG_ID,
  })  : _bigButtonRadius = bigButtonRadius,
        _bigButtonHeight = bigButtonHeight,
        _bigButtonFontSize = bigButtonFontSize,
        _smallButtonRadius = smallButtonRadius,
        _smallButtonHeight = smallButtonHeight,
        _smallButtonFontSize = smallButtonFontSize,
        super(configId: configId);

  /// 默认为 6
  double? _bigButtonRadius;

  double get bigButtonRadius =>
      _bigButtonRadius ??
      SantoDefaultConfigUtils.defaultButtonConfig.bigButtonRadius;

  /// 默认为 48
  double? _bigButtonHeight;

  double get bigButtonHeight =>
      _bigButtonHeight ??
      SantoDefaultConfigUtils.defaultButtonConfig.bigButtonHeight;

  /// 默认为 16
  double? _bigButtonFontSize;

  double get bigButtonFontSize =>
      _bigButtonFontSize ??
      SantoDefaultConfigUtils.defaultButtonConfig.bigButtonFontSize;

  /// 默认为 4
  double? _smallButtonRadius;

  double get smallButtonRadius =>
      _smallButtonRadius ??
      SantoDefaultConfigUtils.defaultButtonConfig.smallButtonRadius;

  /// 默认为 32
  double? _smallButtonHeight;

  double get smallButtonHeight =>
      _smallButtonHeight ??
      SantoDefaultConfigUtils.defaultButtonConfig.smallButtonHeight;

  /// 默认为 14
  double? _smallButtonFontSize;

  double get smallButtonFontSize =>
      _smallButtonFontSize ??
      SantoDefaultConfigUtils.defaultButtonConfig.smallButtonFontSize;

  @override
  void initThemeConfig(
    String configId, {
    SantoCommonConfig? currentLevelCommonConfig,
  }) {
    super.initThemeConfig(
      configId,
      currentLevelCommonConfig: currentLevelCommonConfig,
    );

    SantoButtonConfig userConfig = SantoThemeConfigurator.instance
        .getConfig(configId: configId)
        .buttonConfig;

    _bigButtonRadius ??= userConfig._bigButtonRadius;
    _bigButtonHeight ??= userConfig._bigButtonHeight;
    _bigButtonFontSize ??= userConfig._bigButtonFontSize;
    _smallButtonRadius ??= userConfig._smallButtonRadius;
    _smallButtonHeight ??= userConfig._smallButtonHeight;
    _smallButtonFontSize ??= userConfig._smallButtonFontSize;
  }

  SantoButtonConfig copyWith({
    double? bigButtonRadius,
    double? bigButtonHeight,
    double? bigButtonFontSize,
    double? smallButtonRadius,
    double? smallButtonHeight,
    double? smallButtonFontSize,
  }) {
    return SantoButtonConfig(
      bigButtonRadius: bigButtonRadius ?? _bigButtonRadius,
      bigButtonHeight: bigButtonHeight ?? _bigButtonHeight,
      bigButtonFontSize: bigButtonFontSize ?? _bigButtonFontSize,
      smallButtonRadius: smallButtonRadius ?? _smallButtonRadius,
      smallButtonHeight: smallButtonHeight ?? _smallButtonHeight,
      smallButtonFontSize: smallButtonFontSize ?? _smallButtonFontSize,
    );
  }

  SantoButtonConfig merge(SantoButtonConfig? other) {
    if (other == null) return this;
    return copyWith(
      bigButtonRadius: other._bigButtonRadius,
      bigButtonHeight: other._bigButtonHeight,
      bigButtonFontSize: other._bigButtonFontSize,
      smallButtonRadius: other._smallButtonRadius,
      smallButtonHeight: other._smallButtonHeight,
      smallButtonFontSize: other._smallButtonFontSize,
    );
  }
}
