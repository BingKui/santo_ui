import 'package:santo_ui/src/theme/base/santo_base_config.dart';
import 'package:santo_ui/src/theme/base/santo_default_config_utils.dart';
import 'package:santo_ui/src/theme/base/santo_text_style.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:flutter/material.dart';

import 'santo_appbar_config.dart';

/// 查看大图配置
class SantoGalleryDetailConfig extends SantoBaseConfig {
  /// 遵循全局配置
  /// 默认为 [SantoDefaultConfigUtils.defaultGalleryDetailConfig]
  SantoGalleryDetailConfig({
    SantoTextStyle? appbarTitleStyle,
    SantoTextStyle? appbarActionStyle,
    Color? appbarBackgroundColor,
    SantoAppBarConfig? appbarConfig,
    SantoTextStyle? tabBarUnSelectedLabelStyle,
    SantoTextStyle? tabBarLabelStyle,
    Color? tabBarBackgroundColor,
    Color? pageBackgroundColor,
    Color? bottomBackgroundColor,
    SantoTextStyle? titleStyle,
    SantoTextStyle? contentStyle,
    SantoTextStyle? actionStyle,
    Color? iconColor,
    String configId = GLOBAL_CONFIG_ID,
  })  : _appbarTitleStyle = appbarTitleStyle,
        _appbarActionStyle = appbarActionStyle,
        _appbarBackgroundColor = appbarBackgroundColor,
        _appbarConfig = appbarConfig,
        _tabBarUnSelectedLabelStyle = tabBarUnSelectedLabelStyle,
        _tabBarLabelStyle = tabBarLabelStyle,
        _tabBarBackgroundColor = tabBarBackgroundColor,
        _pageBackgroundColor = pageBackgroundColor,
        _bottomBackgroundColor = bottomBackgroundColor,
        _titleStyle = titleStyle,
        _contentStyle = contentStyle,
        _actionStyle = actionStyle,
        _iconColor = iconColor,
        super(configId: configId);

  /// 黑色主题
  SantoGalleryDetailConfig.dark({
    String configId = GLOBAL_CONFIG_ID,
  }) : super(configId: configId) {
    _appbarTitleStyle = SantoTextStyle(color: commonConfig.colorTextBaseInverse);
    _appbarActionStyle = SantoTextStyle(color: commonConfig.colorTextBase);
    _appbarBackgroundColor = commonConfig.fillBaseInverse;
    _appbarConfig = SantoAppBarConfig.dark();
    _tabBarUnSelectedLabelStyle =
        SantoTextStyle(color: commonConfig.colorTextHint);
    _tabBarLabelStyle = SantoTextStyle(color: commonConfig.colorTextBaseInverse);
    _tabBarBackgroundColor = commonConfig.fillBaseInverse;
    _pageBackgroundColor = commonConfig.fillBaseInverse;
    _bottomBackgroundColor = commonConfig.fillMask;
    _titleStyle = SantoTextStyle(color: commonConfig.colorTextBaseInverse);
    _contentStyle = SantoTextStyle(color: commonConfig.colorTextHint);
    _actionStyle = SantoTextStyle(color: commonConfig.colorTextBaseInverse);
    _iconColor = commonConfig.colorTextBaseInverse;
  }

  /// 白色主题
  SantoGalleryDetailConfig.light({
    String configId = GLOBAL_CONFIG_ID,
  }) : super(configId: configId) {
    _appbarTitleStyle = SantoTextStyle(color: commonConfig.colorTextBase);
    _appbarActionStyle = SantoTextStyle(color: commonConfig.colorTextBase);
    _appbarBackgroundColor = commonConfig.fillBody;
    _appbarConfig = SantoAppBarConfig.light();
    _tabBarUnSelectedLabelStyle = SantoTextStyle(
      color: commonConfig.colorTextBase,
    );
    _tabBarLabelStyle = SantoTextStyle(color: commonConfig.brandPrimary);
    _tabBarBackgroundColor = commonConfig.fillBody;
    _pageBackgroundColor = commonConfig.fillBody;
    _bottomBackgroundColor = commonConfig.fillBody.withOpacity(.85);
    _titleStyle = SantoTextStyle(color: commonConfig.colorTextBase);
    _contentStyle = SantoTextStyle(color: commonConfig.colorTextBase);
    _actionStyle = SantoTextStyle(color: commonConfig.colorTextSecondary);
    _iconColor = commonConfig.colorTextSecondary;
  }

  /// appbar   brightness待定

  /// appbar 标题样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBaseInverse],
  ///   fontSize: [SantoCommonConfig.fontSizeHead],
  ///   fontWeight: FontWeight.w600,
  /// )
  SantoTextStyle? _appbarTitleStyle;

  /// 右侧操作区域文案样式
  ///
  /// SantoTextStyle(
  ///   color: AppBarBrightness(brightness).textColor,
  ///   fontSize: SantoCommonConfig.fontSizeBase,
  ///   fontWeight: FontWeight.w600,
  /// )
  SantoTextStyle? _appbarActionStyle;

  /// appBar 背景色
  /// 默认为 Colors.black
  Color? _appbarBackgroundColor;

  /// appbar brightness
  /// 默认为 [Brightness.dark]
  SantoAppBarConfig? _appbarConfig;

  /// tabBar 标题普通样式
  ///
  /// SantoTextStyle(
  ///   color: Colors.red,
  ///   fontSize: [SantoCommonConfig.fontSizeSubHead],
  /// )
  SantoTextStyle? _tabBarUnSelectedLabelStyle;

  /// tabBar 标题选中样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBaseInverse],
  ///   fontSize: [SantoCommonConfig.fontSizeSubHead],
  ///   fontWeight: FontWeight.w600,
  /// )
  SantoTextStyle? _tabBarLabelStyle;

  /// tabBar 背景色
  /// 默认为 Colors.black
  Color? _tabBarBackgroundColor;

  /// 页面 背景色
  /// 默认为 Colors.black
  Color? _pageBackgroundColor;

  /// 底部内容区域的背景色
  /// 默认为 Color(0x88000000)
  Color? _bottomBackgroundColor;

  /// 标题文案样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBaseInverse],
  ///   fontSize: [SantoCommonConfig.fontSizeHead],
  ///   fontWeight: FontWeight.w600,
  /// )
  SantoTextStyle? _titleStyle;

  /// 内容文案样式
  ///
  /// SantoTextStyle(
  ///   color: Color(0xFFCCCCCC),
  ///   fontSize: [SantoCommonConfig.fontSizeBase],
  /// )
  SantoTextStyle? _contentStyle;

  /// 右侧展开收起样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBaseInverse],
  ///   fontSize: [SantoCommonConfig.fontSizeBase],
  /// )
  SantoTextStyle? _actionStyle;

  /// icon 颜色
  /// 默认为 Colors.white
  Color? _iconColor;

  SantoTextStyle get appbarTitleStyle =>
      _appbarTitleStyle ??
      SantoDefaultConfigUtils.defaultGalleryDetailConfig.appbarTitleStyle;

  SantoTextStyle get appbarActionStyle =>
      _appbarActionStyle ??
      SantoDefaultConfigUtils.defaultGalleryDetailConfig.appbarActionStyle;

  Color get appbarBackgroundColor =>
      _appbarBackgroundColor ??
      SantoDefaultConfigUtils.defaultGalleryDetailConfig.appbarBackgroundColor;

  SantoAppBarConfig get appbarConfig =>
      _appbarConfig ??
      SantoDefaultConfigUtils.defaultGalleryDetailConfig.appbarConfig;

  SantoTextStyle get tabBarUnSelectedLabelStyle =>
      _tabBarUnSelectedLabelStyle ??
      SantoDefaultConfigUtils
          .defaultGalleryDetailConfig.tabBarUnSelectedLabelStyle;

  SantoTextStyle get tabBarLabelStyle =>
      _tabBarLabelStyle ??
      SantoDefaultConfigUtils.defaultGalleryDetailConfig.tabBarLabelStyle;

  Color get tabBarBackgroundColor =>
      _tabBarBackgroundColor ??
      SantoDefaultConfigUtils.defaultGalleryDetailConfig.tabBarBackgroundColor;

  Color get pageBackgroundColor =>
      _pageBackgroundColor ??
      SantoDefaultConfigUtils.defaultGalleryDetailConfig.pageBackgroundColor;

  Color get bottomBackgroundColor =>
      _bottomBackgroundColor ??
      SantoDefaultConfigUtils.defaultGalleryDetailConfig.bottomBackgroundColor;

  SantoTextStyle get titleStyle =>
      _titleStyle ??
      SantoDefaultConfigUtils.defaultGalleryDetailConfig.titleStyle;

  SantoTextStyle get contentStyle =>
      _contentStyle ??
      SantoDefaultConfigUtils.defaultGalleryDetailConfig.contentStyle;

  SantoTextStyle get actionStyle =>
      _actionStyle ??
      SantoDefaultConfigUtils.defaultGalleryDetailConfig.actionStyle;

  Color get iconColor =>
      _iconColor ?? SantoDefaultConfigUtils.defaultGalleryDetailConfig.iconColor;

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
    SantoGalleryDetailConfig galleryDetailConfig = SantoThemeConfigurator.instance
        .getConfig(configId: configId)
        .galleryDetailConfig;

    _appbarTitleStyle = galleryDetailConfig.appbarTitleStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBaseInverse,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_appbarTitleStyle),
    );
    _appbarActionStyle = galleryDetailConfig.appbarActionStyle.merge(
      _appbarActionStyle,
    );
    _appbarConfig ??= galleryDetailConfig.appbarConfig;
    _appbarBackgroundColor ??= galleryDetailConfig.appbarBackgroundColor;
    _tabBarUnSelectedLabelStyle = galleryDetailConfig.tabBarUnSelectedLabelStyle
        .merge(SantoTextStyle(fontSize: commonConfig.fontSizeSubHead))
        .merge(_tabBarUnSelectedLabelStyle);
    _tabBarLabelStyle = galleryDetailConfig.tabBarLabelStyle
        .merge(
          SantoTextStyle(
            color: commonConfig.colorTextBaseInverse,
            fontSize: commonConfig.fontSizeSubHead,
          ),
        )
        .merge(_tabBarLabelStyle);
    _tabBarBackgroundColor ??= galleryDetailConfig._tabBarBackgroundColor;
    _pageBackgroundColor ??= galleryDetailConfig._pageBackgroundColor;
    _bottomBackgroundColor ??= galleryDetailConfig._bottomBackgroundColor;
    _titleStyle = galleryDetailConfig.titleStyle
        .merge(
          SantoTextStyle(
            color: commonConfig.colorTextBaseInverse,
            fontSize: commonConfig.fontSizeHead,
          ),
        )
        .merge(_titleStyle);
    _contentStyle = galleryDetailConfig.contentStyle
        .merge(SantoTextStyle(fontSize: commonConfig.fontSizeBase))
        .merge(_contentStyle);
    _actionStyle = galleryDetailConfig.actionStyle
        .merge(
          SantoTextStyle(
            color: commonConfig.colorTextBaseInverse,
            fontSize: commonConfig.fontSizeBase,
          ),
        )
        .merge(_actionStyle);
    _iconColor ??= galleryDetailConfig._iconColor;
  }

  SantoGalleryDetailConfig copyWith({
    SantoTextStyle? appbarTitleStyle,
    SantoTextStyle? appbarActionStyle,
    Color? appbarBackgroundColor,
    SantoAppBarConfig? appbarConfig,
    SantoTextStyle? tabBarUnSelectedLabelStyle,
    Color? tabBarUnselectedLabelColor,
    SantoTextStyle? tabBarLabelStyle,
    Color? tabBarLabelColor,
    Color? tabBarBackgroundColor,
    Color? indicatorColor,
    Color? pageBackgroundColor,
    Color? bottomBackgroundColor,
    SantoTextStyle? titleStyle,
    SantoTextStyle? contentStyle,
    SantoTextStyle? actionStyle,
    Color? iconColor,
  }) {
    return SantoGalleryDetailConfig(
      appbarTitleStyle: appbarTitleStyle ?? _appbarTitleStyle,
      appbarActionStyle: appbarActionStyle ?? _appbarActionStyle,
      appbarBackgroundColor: appbarBackgroundColor ?? _appbarBackgroundColor,
      appbarConfig: appbarConfig ?? _appbarConfig,
      tabBarUnSelectedLabelStyle:
          tabBarUnSelectedLabelStyle ?? _tabBarUnSelectedLabelStyle,
      tabBarLabelStyle: tabBarLabelStyle ?? _tabBarLabelStyle,
      tabBarBackgroundColor: tabBarBackgroundColor ?? _tabBarBackgroundColor,
      pageBackgroundColor: pageBackgroundColor ?? _pageBackgroundColor,
      bottomBackgroundColor: bottomBackgroundColor ?? _bottomBackgroundColor,
      titleStyle: titleStyle ?? _titleStyle,
      contentStyle: contentStyle ?? _contentStyle,
      actionStyle: actionStyle ?? _actionStyle,
      iconColor: iconColor ?? _iconColor,
    );
  }

  SantoGalleryDetailConfig merge(SantoGalleryDetailConfig? other) {
    if (other == null) return this;
    return copyWith(
      appbarTitleStyle: appbarTitleStyle.merge(other._appbarTitleStyle),
      appbarActionStyle: appbarActionStyle.merge(other._appbarActionStyle),
      appbarBackgroundColor: other._appbarBackgroundColor,
      appbarConfig: other._appbarConfig,
      tabBarUnSelectedLabelStyle:
          tabBarUnSelectedLabelStyle.merge(other._tabBarUnSelectedLabelStyle),
      tabBarLabelStyle: tabBarLabelStyle.merge(other._tabBarLabelStyle),
      tabBarBackgroundColor: other._tabBarBackgroundColor,
      pageBackgroundColor: other._pageBackgroundColor,
      bottomBackgroundColor: other._bottomBackgroundColor,
      titleStyle: titleStyle.merge(other._titleStyle),
      contentStyle: contentStyle.merge(other._contentStyle),
      actionStyle: actionStyle.merge(other._actionStyle),
      iconColor: other._iconColor,
    );
  }
}
