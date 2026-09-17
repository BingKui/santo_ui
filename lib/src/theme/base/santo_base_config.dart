import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';

/// 组件配置基类
abstract class SantoBaseConfig {
  SantoBaseConfig({
    String configId = GLOBAL_CONFIG_ID,
    bool autoFlatConfig = false,
  }) : _configId = configId {
    if (autoFlatConfig) {
      initThemeConfig(configId);
    }
  }

  String get configId => _configId;
  String _configId;
  SantoCommonConfig? _currentLevelCommonConfig;

  /// 部分代码示意如下：
  ///
  /// ```dart
  /// pairInfoTableConfig.valueTextStyle.merge(
  ///   SantoTextStyle(
  ///     color: commonConfig.colorTextBase,
  ///     fontSize: commonConfig.fontSizeBase,
  ///   ).merge(valueTextStyle),
  /// );
  ///
  /// - 以 `commonConfig` 字段为基础 merge `valueTextStyle`。
  ///   `valueTextStyle` 字段优先级高，当valueTextStyle中字段（如 color）为 null 时
  ///   会使用 `commonConfig.colorTextBase`。
  /// - 以默认上一级配置为基础 merge 第一步的结果，当第一步中字段（如 color）为空时，
  ///   使用上一层级配置的 color (`pairInfoTableConfig.valueTextStyle.color`)。
  void initThemeConfig(
    String configId, {
    SantoCommonConfig? currentLevelCommonConfig,
  }) {
    _currentLevelCommonConfig = currentLevelCommonConfig;
  }

  /// 当自定义组件的配置时调用
  /// 根据自定义时传入的 [configId] 对配置字段打平
  void initThemeConfigPersonal() {
    initThemeConfig(configId);
  }

  SantoCommonConfig get commonConfig =>
      _currentLevelCommonConfig ??
      SantoThemeConfigurator.instance
          .getConfig(configId: configId)
          .commonConfig;
}
