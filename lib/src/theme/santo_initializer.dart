import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_all_config.dart';

/// Santo 初始化
class SantoInitializer {
  /// 手动注册时，默认注册渠道是 GLOBAL_CONFIG_ID
  static register({
    SantoAllThemeConfig? allThemeConfig,
    String configId = GLOBAL_CONFIG_ID,
  }) {
    /// 配置主题定制
    SantoThemeConfigurator.instance.register(allThemeConfig, configId: configId);
  }
}
