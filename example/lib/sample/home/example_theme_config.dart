import 'package:flutter/material.dart';
import 'package:santo_ui/santo_ui.dart';

/// 主题变更通知：主题样式 / 主题色变更后广播，由 main.dart 的监听器重建整棵树
class ChangeThemeEvent extends Notification {}

/// 示例 App 的主题设置入口
///
/// 主题样式(App / Pad)决定基座配置，主题色在其之上叠加：
/// 先注册基座，再注册只带 [SantoCommonConfig.brandPrimary] 的配置，
/// 后者会从已注册的配置里补全其余字段，因此不会丢掉基座的档位。
class ExampleThemeConfig {
  ExampleThemeConfig._();

  /// App 默认主题色，与 [SantoCommonConfig.brandPrimary] 默认值一致
  static const Color defaultBrandPrimary = Color(0xFF1677FF);

  /// 可选主题色
  static const List<Color> brandPrimaryOptions = <Color>[
    defaultBrandPrimary,
    Color(0xFFF5222D),
    Color(0xFFFA541C),
    Color(0xFFFAAD14),
    Color(0xFF52C41A),
    Color(0xFF13C2C2),
    Color(0xFF722ED1),
    Color(0xFFEB2F96),
  ];

  /// 是否使用 Pad 主题样式
  static bool isPadStyle = false;

  /// 自定义主题色，null 表示使用主题样式自带的配色
  static Color? brandPrimary;

  /// 解析颜色哈希值，支持 `#RRGGBB` / `RRGGBB` / `#AARRGGBB` / `AARRGGBB`
  static Color? parseHexColor(String input) {
    String text = input.trim();
    if (text.startsWith('#')) {
      text = text.substring(1);
    }
    if (text.length == 6) {
      text = 'FF$text';
    }
    if (text.length != 8) {
      return null;
    }
    final int? value = int.tryParse(text, radix: 16);
    return value == null ? null : Color(value);
  }

  /// 当前生效的主题色
  static Color get currentBrandPrimary =>
      brandPrimary ??
      SantoThemeConfigurator.instance.getConfig().commonConfig.brandPrimary;

  /// 切换主题样式(App / Pad)
  static void setPadStyle(bool isPad) {
    if (isPadStyle == isPad) {
      return;
    }
    isPadStyle = isPad;
    apply();
  }

  /// 切换主题色，传 [defaultBrandPrimary] 表示恢复默认
  static void setBrandPrimary(Color color) {
    final Color? next = color == defaultBrandPrimary ? null : color;
    if (brandPrimary == next) {
      return;
    }
    brandPrimary = next;
    apply();
  }

  /// 注册主题配置
  static void apply() {
    // 1、铺基座：主题样式决定字号/间距档位
    SantoInitializer.register(
      allThemeConfig: isPadStyle
          ? SantoPadThemeConfig.allConfig
          : SantoDefaultConfigUtils.defaultAllConfig,
    );

    // 2、叠加主题色：未显式传的子配置会从基座补全，并按新的品牌色重新派生
    final Color? color = brandPrimary;
    if (color != null) {
      SantoInitializer.register(
        allThemeConfig: SantoAllThemeConfig(
          commonConfig: SantoCommonConfig(
            brandPrimary: color,
            brandPrimaryTap: color.withOpacity(0.1),
            colorLink: color,
          ),
        ),
      );
    }
  }
}
