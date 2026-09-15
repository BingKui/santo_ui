import 'package:santo_ui/src/theme/base/santo_base_config.dart';
import 'package:santo_ui/src/theme/base/santo_default_config_utils.dart';
import 'package:santo_ui/src/theme/base/santo_text_style.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';

/// 强化数字展示组件配置
class SantoEnhanceNumberCardConfig extends SantoBaseConfig {
  /// 遵循外部主题配置
  /// 默认为 [SantoDefaultConfigUtils.defaultEnhanceNumberInfoConfig]
  SantoEnhanceNumberCardConfig({
    double? runningSpace,
    double? itemRunningSpace,
    SantoTextStyle? titleTextStyle,
    SantoTextStyle? descTextStyle,
    double? dividerWidth,
    String configId = GLOBAL_CONFIG_ID,
  })  : _runningSpace = runningSpace,
        _itemRunningSpace = itemRunningSpace,
        _titleTextStyle = titleTextStyle,
        _descTextStyle = descTextStyle,
        _dividerWidth = dividerWidth,
        super(configId: configId);

  /// 如果超过一行，行间距
  double? _runningSpace;

  double get runningSpace =>
      _runningSpace ??
      SantoDefaultConfigUtils.defaultEnhanceNumberInfoConfig.runningSpace;

  /// Item的上半部分和下半部分的间距
  double? _itemRunningSpace;

  double get itemRunningSpace =>
      _itemRunningSpace ??
      SantoDefaultConfigUtils.defaultEnhanceNumberInfoConfig.itemRunningSpace;

  double? _dividerWidth;

  double get dividerWidth =>
      _dividerWidth ??
      SantoDefaultConfigUtils.defaultEnhanceNumberInfoConfig.dividerWidth;
  SantoTextStyle? _titleTextStyle;

  SantoTextStyle get titleTextStyle =>
      _titleTextStyle ??
      SantoDefaultConfigUtils.defaultEnhanceNumberInfoConfig.titleTextStyle;
  SantoTextStyle? _descTextStyle;

  SantoTextStyle get descTextStyle =>
      _descTextStyle ??
      SantoDefaultConfigUtils.defaultEnhanceNumberInfoConfig.descTextStyle;

  @override
  void initThemeConfig(
    String configId, {
    SantoCommonConfig? currentLevelCommonConfig,
  }) {
    super.initThemeConfig(
      configId,
      currentLevelCommonConfig: currentLevelCommonConfig,
    );

    SantoEnhanceNumberCardConfig userConfig = SantoThemeConfigurator.instance
        .getConfig(configId: configId)
        .enhanceNumberCardConfig;

    _runningSpace ??= userConfig._runningSpace;
    _itemRunningSpace ??= userConfig._itemRunningSpace;
    _dividerWidth ??= userConfig._dividerWidth;
    _titleTextStyle = userConfig.titleTextStyle.merge(
      SantoTextStyle(color: commonConfig.colorTextBase).merge(_titleTextStyle),
    );
    _descTextStyle = userConfig.descTextStyle.merge(
      SantoTextStyle(color: commonConfig.colorTextSecondary)
          .merge(_descTextStyle),
    );
  }

  SantoEnhanceNumberCardConfig copyWith({
    double? runningSpace,
    double? itemRunningSpace,
    double? dividerWidth,
    SantoTextStyle? titleTextStyle,
    SantoTextStyle? descTextStyle,
  }) {
    return SantoEnhanceNumberCardConfig(
      runningSpace: runningSpace ?? _runningSpace,
      itemRunningSpace: itemRunningSpace ?? _itemRunningSpace,
      dividerWidth: dividerWidth ?? _dividerWidth,
      titleTextStyle: titleTextStyle ?? _titleTextStyle,
      descTextStyle: descTextStyle ?? _descTextStyle,
    );
  }

  SantoEnhanceNumberCardConfig merge(SantoEnhanceNumberCardConfig? other) {
    if (other == null) return this;
    return copyWith(
      runningSpace: other._runningSpace,
      itemRunningSpace: other._itemRunningSpace,
      dividerWidth: other._dividerWidth,
      titleTextStyle: titleTextStyle.merge(other._titleTextStyle),
      descTextStyle: descTextStyle.merge(other._descTextStyle),
    );
  }
}
