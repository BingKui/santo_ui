import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

void main() {
  const Color customPrimary = Color(0xFFEB2F96);

  /// 示例 App 的做法：先注册基座（浅色 AppBar），再叠加一个只改品牌色的配置。
  void registerCustomPrimary() {
    SantoThemeConfigurator.instance.register(
      SantoAllThemeConfig(appBarConfig: SantoAppBarConfig.light()),
    );
    SantoThemeConfigurator.instance.register(
      SantoAllThemeConfig(
        commonConfig: SantoCommonConfig(
          brandPrimary: customPrimary,
          brandPrimaryTap: customPrimary.withOpacity(0.1),
          colorLink: customPrimary,
        ),
      ),
    );
  }

  test('叠加主题色：品牌色与其派生配置生效，基座样式保留', () {
    registerCustomPrimary();

    final SantoAllThemeConfig config =
        SantoThemeConfigurator.instance.getConfig();

    expect(config.commonConfig.brandPrimary, customPrimary);
    expect(config.commonConfig.colorLink, customPrimary);
    // 按品牌色派生的子配置跟着变
    expect(config.tagConfig.selectedTagBackgroundColor, customPrimary);
    expect(config.selectionConfig.tagSelectedBackgroundColor,
        customPrimary.withOpacity(0.12));
    // 基座样式不被叠加配置覆盖
    expect(config.appBarConfig.backgroundColor, Colors.white);
    expect(config.tagConfig.tagHeight, 32);
  });

  test('重新注册基座后品牌色回到基座值', () {
    registerCustomPrimary();
    SantoThemeConfigurator.instance
        .register(SantoDefaultConfigUtils.defaultAllConfig);

    final SantoAllThemeConfig config =
        SantoThemeConfigurator.instance.getConfig();

    expect(config.commonConfig.brandPrimary,
        SantoCommonConfig().brandPrimary);
    expect(config.tagConfig.selectedTagBackgroundColor,
        SantoCommonConfig().brandPrimary);
    expect(config.appBarConfig.backgroundColor, Colors.white);
  });
}
