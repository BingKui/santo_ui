import 'package:santo_ui/src/theme/base/santo_base_config.dart';
import 'package:santo_ui/src/theme/base/santo_default_config_utils.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';

/// 按钮基础配置
///
/// 尺寸档位对标 antd Button 的 size:large(大)、middle(中)、small(小)
class SantoButtonConfig extends SantoBaseConfig {
  /// 遵循外部主题配置
  /// 默认为 [SantoDefaultConfigUtils.defaultButtonConfig]
  SantoButtonConfig({
    double? largeButtonRadius,
    double? largeButtonHeight,
    double? largeButtonFontSize,
    double? middleButtonRadius,
    double? middleButtonHeight,
    double? middleButtonFontSize,
    double? smallButtonRadius,
    double? smallButtonHeight,
    double? smallButtonFontSize,
    String configId = GLOBAL_CONFIG_ID,
  })  : _largeButtonRadius = largeButtonRadius,
        _largeButtonHeight = largeButtonHeight,
        _largeButtonFontSize = largeButtonFontSize,
        _middleButtonRadius = middleButtonRadius,
        _middleButtonHeight = middleButtonHeight,
        _middleButtonFontSize = middleButtonFontSize,
        _smallButtonRadius = smallButtonRadius,
        _smallButtonHeight = smallButtonHeight,
        _smallButtonFontSize = smallButtonFontSize,
        super(configId: configId);

  /// 默认为 12
  double? _largeButtonRadius;

  double get largeButtonRadius =>
      _largeButtonRadius ??
      SantoDefaultConfigUtils.defaultButtonConfig.largeButtonRadius;

  /// 默认为 48
  double? _largeButtonHeight;

  double get largeButtonHeight =>
      _largeButtonHeight ??
      SantoDefaultConfigUtils.defaultButtonConfig.largeButtonHeight;

  /// 默认为 16
  double? _largeButtonFontSize;

  double get largeButtonFontSize =>
      _largeButtonFontSize ??
      SantoDefaultConfigUtils.defaultButtonConfig.largeButtonFontSize;

  /// 默认为 12
  double? _middleButtonRadius;

  double get middleButtonRadius =>
      _middleButtonRadius ??
      SantoDefaultConfigUtils.defaultButtonConfig.middleButtonRadius;

  /// 默认为 32
  double? _middleButtonHeight;

  double get middleButtonHeight =>
      _middleButtonHeight ??
      SantoDefaultConfigUtils.defaultButtonConfig.middleButtonHeight;

  /// 默认为 14
  double? _middleButtonFontSize;

  double get middleButtonFontSize =>
      _middleButtonFontSize ??
      SantoDefaultConfigUtils.defaultButtonConfig.middleButtonFontSize;

  /// 默认为 12
  double? _smallButtonRadius;

  double get smallButtonRadius =>
      _smallButtonRadius ??
      SantoDefaultConfigUtils.defaultButtonConfig.smallButtonRadius;

  /// 默认为 24
  double? _smallButtonHeight;

  double get smallButtonHeight =>
      _smallButtonHeight ??
      SantoDefaultConfigUtils.defaultButtonConfig.smallButtonHeight;

  /// 默认为 12
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

    _largeButtonRadius ??= userConfig._largeButtonRadius;
    _largeButtonHeight ??= userConfig._largeButtonHeight;
    _largeButtonFontSize ??= userConfig._largeButtonFontSize;
    _middleButtonRadius ??= userConfig._middleButtonRadius;
    _middleButtonHeight ??= userConfig._middleButtonHeight;
    _middleButtonFontSize ??= userConfig._middleButtonFontSize;
    _smallButtonRadius ??= userConfig._smallButtonRadius;
    _smallButtonHeight ??= userConfig._smallButtonHeight;
    _smallButtonFontSize ??= userConfig._smallButtonFontSize;
  }

  SantoButtonConfig copyWith({
    double? largeButtonRadius,
    double? largeButtonHeight,
    double? largeButtonFontSize,
    double? middleButtonRadius,
    double? middleButtonHeight,
    double? middleButtonFontSize,
    double? smallButtonRadius,
    double? smallButtonHeight,
    double? smallButtonFontSize,
  }) {
    return SantoButtonConfig(
      largeButtonRadius: largeButtonRadius ?? _largeButtonRadius,
      largeButtonHeight: largeButtonHeight ?? _largeButtonHeight,
      largeButtonFontSize: largeButtonFontSize ?? _largeButtonFontSize,
      middleButtonRadius: middleButtonRadius ?? _middleButtonRadius,
      middleButtonHeight: middleButtonHeight ?? _middleButtonHeight,
      middleButtonFontSize: middleButtonFontSize ?? _middleButtonFontSize,
      smallButtonRadius: smallButtonRadius ?? _smallButtonRadius,
      smallButtonHeight: smallButtonHeight ?? _smallButtonHeight,
      smallButtonFontSize: smallButtonFontSize ?? _smallButtonFontSize,
    );
  }

  SantoButtonConfig merge(SantoButtonConfig? other) {
    if (other == null) return this;
    return copyWith(
      largeButtonRadius: other._largeButtonRadius,
      largeButtonHeight: other._largeButtonHeight,
      largeButtonFontSize: other._largeButtonFontSize,
      middleButtonRadius: other._middleButtonRadius,
      middleButtonHeight: other._middleButtonHeight,
      middleButtonFontSize: other._middleButtonFontSize,
      smallButtonRadius: other._smallButtonRadius,
      smallButtonHeight: other._smallButtonHeight,
      smallButtonFontSize: other._smallButtonFontSize,
    );
  }
}
