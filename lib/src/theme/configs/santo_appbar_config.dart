import 'package:santo_ui/src/components/icon/santo_icon.dart';
import 'package:santo_ui/src/components/icon/santo_icons.dart';
import 'package:santo_ui/src/theme/base/santo_base_config.dart';
import 'package:santo_ui/src/theme/base/santo_default_config_utils.dart';
import 'package:santo_ui/src/theme/base/santo_text_style.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef SantoWidgetBuilder = Widget Function();

/// Appbar主题配置
class SantoAppBarConfig extends SantoBaseConfig {
  /// SantoAppBar 主题配置，遵循外部主题配置
  /// 默认为 [SantoDefaultConfigUtils.defaultAppBarConfig]
  SantoAppBarConfig({
    Color? backgroundColor,
    double? appBarHeight,
    SantoWidgetBuilder? leadIconBuilder,
    SantoTextStyle? titleStyle,
    SantoTextStyle? actionsStyle,
    int? titleMaxLength,
    double? leftAndRightPadding,
    double? itemSpacing,
    EdgeInsets? titlePadding,
    double? iconSize,
    double? leadingSize,
    double? leadingSpacing,
    double? doubleLeadingSize,
    SystemUiOverlayStyle? systemOverlayStyle,
    bool? showDefaultBottom,
    String configId = GLOBAL_CONFIG_ID,
  })  : _backgroundColor = backgroundColor,
        _appBarHeight = appBarHeight,
        _leadIconBuilder = leadIconBuilder,
        _titleStyle = titleStyle,
        _actionsStyle = actionsStyle,
        _titleMaxLength = titleMaxLength,
        _leftAndRightPadding = leftAndRightPadding,
        _itemSpacing = itemSpacing,
        _titlePadding = titlePadding,
        _iconSize = iconSize,
        _leadingSize = leadingSize,
        _leadingSpacing = leadingSpacing,
        _doubleLeadingSize = doubleLeadingSize,
        _systemOverlayStyle = systemOverlayStyle,
        _showDefaultBottom = showDefaultBottom,
        super(configId: configId);

  SantoAppBarConfig.dark({
    double? appBarHeight,
    int? titleMaxLength,
    double? leftAndRightPadding,
    double? itemSpacing,
    EdgeInsets? titlePadding,
    double? iconSize,
    double? leadingSize,
    double? leadingSpacing,
    double? doubleLeadingSize,
    String configId = GLOBAL_CONFIG_ID,
  })  : _appBarHeight = appBarHeight,
        _titleMaxLength = titleMaxLength,
        _leftAndRightPadding = leftAndRightPadding,
        _itemSpacing = itemSpacing,
        _titlePadding = titlePadding,
        _iconSize = iconSize,
        _leadingSize = leadingSize,
        _leadingSpacing = leadingSpacing,
        _doubleLeadingSize = doubleLeadingSize,
        super(configId: configId) {
    // 这里不能用 commonConfig(会经 SantoThemeConfigurator 取配置),
    // 否则 defaultAllConfig 初始化 defaultGalleryDetailConfig 时形成回环栈溢出。
    final commonConfig = SantoDefaultConfigUtils.defaultCommonConfig;
    _backgroundColor = commonConfig.appBarDarkBackgroundColor;
    _leadIconBuilder = () => SantoIcon(
          SantoIcons.arrowLeft,
          size: iconSize,
          color: commonConfig.colorTextBaseInverse,
        );
    _titleStyle = SantoTextStyle(
      fontSize: commonConfig.fontSizeHead,
      fontWeight: FontWeight.w500,
      color: commonConfig.colorTextBaseInverse,
    );
    _actionsStyle = SantoTextStyle(
      color: commonConfig.colorTextBaseInverse,
      fontSize: commonConfig.fontSizeBase,
      fontWeight: FontWeight.w500,
    );
    _systemOverlayStyle = SystemUiOverlayStyle.light;
  }

  SantoAppBarConfig.light({
    double? appBarHeight,
    int? titleMaxLength,
    double? leftAndRightPadding,
    double? itemSpacing,
    EdgeInsets? titlePadding,
    double? iconSize,
    double? leadingSize,
    double? leadingSpacing,
    double? doubleLeadingSize,
    String configId = GLOBAL_CONFIG_ID,
  })  : _appBarHeight = appBarHeight,
        _titleMaxLength = titleMaxLength,
        _leftAndRightPadding = leftAndRightPadding,
        _itemSpacing = itemSpacing,
        _titlePadding = titlePadding,
        _iconSize = iconSize,
        _leadingSize = leadingSize,
        _leadingSpacing = leadingSpacing,
        _doubleLeadingSize = doubleLeadingSize,
        super(configId: configId) {
    // 同 dark():避开配置回环,走文件级默认常量
    final commonConfig = SantoDefaultConfigUtils.defaultCommonConfig;
    _backgroundColor = commonConfig.fillBase;
    _leadIconBuilder = () => SantoIcon(
          SantoIcons.arrowLeft,
          size: iconSize,
          color: commonConfig.colorTextBase,
        );
    _titleStyle = SantoTextStyle(
      fontSize: commonConfig.fontSizeHead,
      fontWeight: FontWeight.w500,
      color: commonConfig.colorTextBase,
    );
    _actionsStyle = SantoTextStyle(
      color: commonConfig.colorTextBase,
      fontSize: commonConfig.fontSizeBase,
      fontWeight: FontWeight.w500,
    );
    _systemOverlayStyle = SystemUiOverlayStyle.dark;
  }

  /// AppBar 的背景色
  Color? _backgroundColor;

  Color get backgroundColor =>
      _backgroundColor ??
      SantoDefaultConfigUtils.defaultAppBarConfig.backgroundColor;

  /// AppBar 的高度
  double? _appBarHeight;

  double get appBarHeight =>
      _appBarHeight ?? SantoDefaultConfigUtils.defaultAppBarConfig.appBarHeight;

  /// 返回按钮的child widget，一般为Image
  SantoWidgetBuilder? _leadIconBuilder;

  SantoWidgetBuilder get leadIconBuilder =>
      _leadIconBuilder ??
      SantoDefaultConfigUtils.defaultAppBarConfig.leadIconBuilder;

  /// 标题样式，仅当直接 title 设置为 String 生效
  ///
  /// **注意**：`fontSize` 必须传大小，否则报错
  SantoTextStyle? _titleStyle;

  SantoTextStyle get titleStyle =>
      _titleStyle ?? SantoDefaultConfigUtils.defaultAppBarConfig.titleStyle;

  /// 右侧文字按钮样式，仅当直接actions里面元素为SantoTextAction类型生效
  ///
  /// **注意**：`fontSize` 必须传大小，否则报错
  ///
  /// SantoTextStyle(
  ///   color: AppBarBrightness(brightness).textColor,
  ///   fontSize: SantoCommonConfig.fontSizeBase,
  ///   fontWeight: FontWeight.w500,
  /// )
  SantoTextStyle? _actionsStyle;

  SantoTextStyle get actionsStyle =>
      _actionsStyle ?? SantoDefaultConfigUtils.defaultAppBarConfig.actionsStyle;

  /// AppBar title 的最大字符数 8
  int? _titleMaxLength;

  int get titleMaxLength =>
      _titleMaxLength ??
      SantoDefaultConfigUtils.defaultAppBarConfig.titleMaxLength;

  /// 左右边距
  double? _leftAndRightPadding;

  double get leftAndRightPadding =>
      _leftAndRightPadding ??
      SantoDefaultConfigUtils.defaultAppBarConfig.leftAndRightPadding;

  /// 元素间间距
  double? _itemSpacing;

  double get itemSpacing =>
      _itemSpacing ?? SantoDefaultConfigUtils.defaultAppBarConfig.itemSpacing;

  /// title的padding
  EdgeInsets? _titlePadding;

  EdgeInsets get titlePadding =>
      _titlePadding ?? SantoDefaultConfigUtils.defaultAppBarConfig.titlePadding;

  /// leadIcon 宽高，需要相同
  /// 默认为 20
  double? _iconSize;

  double get iconSize =>
      _iconSize ?? SantoDefaultConfigUtils.defaultAppBarConfig.iconSize;

  /// 返回键(SantoBackLeading)操作区域的固定边长
  /// 默认为 32
  double? _leadingSize;

  double get leadingSize =>
      _leadingSize ?? SantoDefaultConfigUtils.defaultAppBarConfig.leadingSize;

  /// SantoDoubleLeading 中两个操作区之间的间距
  /// 默认为 5
  double? _leadingSpacing;

  double get leadingSpacing =>
      _leadingSpacing ??
      SantoDefaultConfigUtils.defaultAppBarConfig.leadingSpacing;

  /// SantoDoubleLeading 时的固定宽度
  /// 默认为 80
  double? _doubleLeadingSize;

  double get doubleLeadingSize =>
      _doubleLeadingSize ??
      SantoDefaultConfigUtils.defaultAppBarConfig.doubleLeadingSize;

  /// statusBar 样式
  /// 默认为 [SystemUiOverlayStyle.dark]
  SystemUiOverlayStyle? _systemOverlayStyle;

  SystemUiOverlayStyle get systemOverlayStyle =>
      _systemOverlayStyle ??
      SantoDefaultConfigUtils.defaultAppBarConfig.systemOverlayStyle;

  /// 是否展示Appbar bottom 分割线
  /// 默认为 [false]
  bool? _showDefaultBottom;

  bool get showDefaultBottom =>
      _showDefaultBottom ??
          SantoDefaultConfigUtils.defaultAppBarConfig.showDefaultBottom;

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
    SantoAppBarConfig appbarConfig = SantoThemeConfigurator.instance
        .getConfig(configId: configId)
        .appBarConfig;

    _backgroundColor ??= appbarConfig._backgroundColor;
    _appBarHeight ??= appbarConfig._appBarHeight;
    _leadIconBuilder ??= appbarConfig._leadIconBuilder;
    _titleStyle = appbarConfig.titleStyle.merge(_titleStyle);
    _actionsStyle = appbarConfig.actionsStyle.merge(_actionsStyle);
    _titleMaxLength ??= appbarConfig._titleMaxLength;
    _leftAndRightPadding ??= appbarConfig._leftAndRightPadding;
    _itemSpacing ??= appbarConfig._itemSpacing;
    _titlePadding ??= appbarConfig._titlePadding;
    _iconSize ??= appbarConfig._iconSize;
    _leadingSize ??= appbarConfig._leadingSize;
    _leadingSpacing ??= appbarConfig._leadingSpacing;
    _doubleLeadingSize ??= appbarConfig._doubleLeadingSize;
    _systemOverlayStyle ??= appbarConfig._systemOverlayStyle;
    _showDefaultBottom ??= appbarConfig._showDefaultBottom;
  }

  SantoAppBarConfig copyWith({
    Color? backgroundColor,
    double? appBarHeight,
    SantoWidgetBuilder? leadIconBuilder,
    SantoTextStyle? titleStyle,
    SantoTextStyle? actionsStyle,
    int? titleMaxLength,
    double? leftAndRightPadding,
    double? itemSpacing,
    EdgeInsets? titlePadding,
    double? iconSize,
    double? leadingSize,
    double? leadingSpacing,
    double? doubleLeadingSize,
    SystemUiOverlayStyle? systemOverlayStyle,
    bool? showDefaultBottom,
  }) {
    return SantoAppBarConfig(
      backgroundColor: backgroundColor ?? _backgroundColor,
      appBarHeight: appBarHeight ?? _appBarHeight,
      leadIconBuilder: leadIconBuilder ?? _leadIconBuilder,
      titleStyle: titleStyle ?? _titleStyle,
      actionsStyle: actionsStyle ?? _actionsStyle,
      titleMaxLength: titleMaxLength ?? _titleMaxLength,
      leftAndRightPadding: leftAndRightPadding ?? _leftAndRightPadding,
      itemSpacing: itemSpacing ?? _itemSpacing,
      titlePadding: titlePadding ?? _titlePadding,
      iconSize: iconSize ?? _iconSize,
      leadingSize: leadingSize ?? _leadingSize,
      leadingSpacing: leadingSpacing ?? _leadingSpacing,
      doubleLeadingSize: doubleLeadingSize ?? _doubleLeadingSize,
      systemOverlayStyle: systemOverlayStyle ?? _systemOverlayStyle,
      showDefaultBottom: showDefaultBottom ?? _showDefaultBottom,
    );
  }

  SantoAppBarConfig merge(SantoAppBarConfig? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other._backgroundColor,
      appBarHeight: other._appBarHeight,
      leadIconBuilder: other._leadIconBuilder,
      titleStyle: titleStyle.merge(other._titleStyle),
      actionsStyle: actionsStyle.merge(other._actionsStyle),
      titleMaxLength: other._titleMaxLength,
      leftAndRightPadding: other._leftAndRightPadding,
      itemSpacing: other._itemSpacing,
      titlePadding: other._titlePadding,
      iconSize: other._iconSize,
      leadingSize: other._leadingSize,
      leadingSpacing: other._leadingSpacing,
      doubleLeadingSize: other._doubleLeadingSize,
      systemOverlayStyle: other._systemOverlayStyle,
      showDefaultBottom: other._showDefaultBottom,
    );
  }
}
