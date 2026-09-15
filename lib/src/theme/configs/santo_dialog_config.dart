import 'package:santo_ui/src/theme/base/santo_base_config.dart';
import 'package:santo_ui/src/theme/base/santo_default_config_utils.dart';
import 'package:santo_ui/src/theme/base/santo_text_style.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:flutter/material.dart';

/// 描述: Dialog 弹框主配置类
class SantoDialogConfig extends SantoBaseConfig {
  SantoDialogConfig({
    double? dialogWidth,
    double? radius,
    EdgeInsets? iconPadding,
    EdgeInsets? titlePaddingSm,
    EdgeInsets? titlePaddingLg,
    SantoTextStyle? titleTextStyle,
    TextAlign? titleTextAlign,
    EdgeInsets? contentPaddingSm,
    EdgeInsets? contentPaddingLg,
    SantoTextStyle? contentTextStyle,
    TextAlign? contentTextAlign,
    EdgeInsets? warningPaddingSm,
    EdgeInsets? warningPaddingLg,
    SantoTextStyle? warningTextStyle,
    TextAlign? warningTextAlign,
    EdgeInsets? dividerPadding,
    SantoTextStyle? mainActionTextStyle,
    SantoTextStyle? assistActionsTextStyle,
    Color? mainActionBackgroundColor,
    Color? assistActionsBackgroundColor,
    double? bottomHeight,
    Color? backgroundColor,
    String configId = GLOBAL_CONFIG_ID,
  })  : _dialogWidth = dialogWidth,
        _radius = radius,
        _iconPadding = iconPadding,
        _titlePaddingSm = titlePaddingSm,
        _titlePaddingLg = titlePaddingLg,
        _titleTextStyle = titleTextStyle,
        _titleTextAlign = titleTextAlign,
        _contentPaddingSm = contentPaddingSm,
        _contentPaddingLg = contentPaddingLg,
        _contentTextStyle = contentTextStyle,
        _contentTextAlign = contentTextAlign,
        _warningPaddingSm = warningPaddingSm,
        _warningPaddingLg = warningPaddingLg,
        _warningTextStyle = warningTextStyle,
        _warningTextAlign = warningTextAlign,
        _dividerPadding = dividerPadding,
        _mainActionTextStyle = mainActionTextStyle,
        _assistActionsTextStyle = assistActionsTextStyle,
        _mainActionBackgroundColor = mainActionBackgroundColor,
        _assistActionsBackgroundColor = assistActionsBackgroundColor,
        _bottomHeight = bottomHeight,
        _backgroundColor = backgroundColor,
        super(configId: configId);

  /// Dialog 宽度
  /// 默认为 300
  double? _dialogWidth;

  double get dialogWidth =>
      _dialogWidth ?? SantoDefaultConfigUtils.defaultDialogConfig.dialogWidth;

  /// Dialog 四周圆角
  /// 默认为 [SantoCommonConfig.radiusLg]
  double? _radius;

  double get radius =>
      _radius ?? SantoDefaultConfigUtils.defaultDialogConfig.radius;

  /// Dialog icon 距离顶部的边距
  ///
  /// EdgeInsets.only(top: [SantoCommonConfig.vSpacingXxl])
  EdgeInsets? _iconPadding;

  EdgeInsets get iconPadding =>
      _iconPadding ?? SantoDefaultConfigUtils.defaultDialogConfig.iconPadding;

  /// title 在顶部有 icon 时的边距
  ///
  /// EdgeInsets.only(
  ///   top: 12,
  ///   left: [SantoCommonConfig.hSpacingXxl],
  ///   right: [SantoCommonConfig.hSpacingXxl],
  /// )
  EdgeInsets? _titlePaddingSm;

  EdgeInsets get titlePaddingSm =>
      _titlePaddingSm ??
      SantoDefaultConfigUtils.defaultDialogConfig.titlePaddingSm;

  /// title 当顶部无 icon 时的边距
  ///
  /// EdgeInsets.only(
  ///   top: 28,
  ///   left: [SantoCommonConfig.hSpacingXxl],
  ///   right: [SantoCommonConfig.hSpacingXxl],
  /// )
  EdgeInsets? _titlePaddingLg;

  EdgeInsets get titlePaddingLg =>
      _titlePaddingLg ??
      SantoDefaultConfigUtils.defaultDialogConfig.titlePaddingLg;

  /// title 标题样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize: [SantoCommonConfig.fontSizeHead],
  ///   fontWeight: FontWeight.w600,
  /// )
  SantoTextStyle? _titleTextStyle;

  SantoTextStyle get titleTextStyle =>
      _titleTextStyle ??
      SantoDefaultConfigUtils.defaultDialogConfig.titleTextStyle;

  /// 标题的文字对齐
  /// 默认为 [TextAlign.center]
  TextAlign? _titleTextAlign;

  TextAlign get titleTextAlign =>
      _titleTextAlign ??
      SantoDefaultConfigUtils.defaultDialogConfig.titleTextAlign;

  /// content 当顶部有 title 或者 icon 时的边距
  ///
  /// EdgeInsets.only(
  ///   top: 8,
  ///   left: [SantoCommonConfig.hSpacingXl],
  ///   right: [SantoCommonConfig.hSpacingXl],
  /// )
  EdgeInsets? _contentPaddingSm;

  EdgeInsets get contentPaddingSm =>
      _contentPaddingSm ??
      SantoDefaultConfigUtils.defaultDialogConfig.contentPaddingSm;

  /// content 当顶部无 title 或者 icon 时的边距
  ///
  /// EdgeInsets.only(
  ///   top: 28,
  ///   left: [SantoCommonConfig.hSpacingXl],
  ///   right: [SantoCommonConfig.hSpacingXl],
  /// )
  EdgeInsets? _contentPaddingLg;

  EdgeInsets get contentPaddingLg =>
      _contentPaddingLg ??
      SantoDefaultConfigUtils.defaultDialogConfig.contentPaddingLg;

  /// message 内容样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextImportant],
  ///   fontSize: [SantoCommonConfig.fontSizeBase],
  /// )
  SantoTextStyle? _contentTextStyle;

  SantoTextStyle get contentTextStyle =>
      _contentTextStyle ??
      SantoDefaultConfigUtils.defaultDialogConfig.contentTextStyle;

  /// 内容文字的对齐
  /// 默认为 [TextAlign.center]
  TextAlign? _contentTextAlign;

  TextAlign get contentTextAlign =>
      _contentTextAlign ??
      SantoDefaultConfigUtils.defaultDialogConfig.contentTextAlign;

  /// warning 当顶部有 title/icon/content 时的边距
  ///
  /// EdgeInsets.only(
  ///   top: 6,
  ///   left: [SantoCommonConfig.hSpacingXl],
  ///   right: [SantoCommonConfig.hSpacingXl],
  /// )
  EdgeInsets? _warningPaddingSm;

  EdgeInsets get warningPaddingSm =>
      _warningPaddingSm ??
      SantoDefaultConfigUtils.defaultDialogConfig.warningPaddingSm;

  /// warning 当顶部无 title/icon/content 时的边距
  ///
  /// EdgeInsets.only(
  ///   top: 28,
  ///   left: [SantoCommonConfig.hSpacingXl],
  ///   right: [SantoCommonConfig.hSpacingXl],
  /// )
  EdgeInsets? _warningPaddingLg;

  EdgeInsets get warningPaddingLg =>
      _warningPaddingLg ??
      SantoDefaultConfigUtils.defaultDialogConfig.warningPaddingLg;

  /// 警告样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.brandError],
  ///   fontSize: [SantoCommonConfig.fontSizeBase],
  /// )
  SantoTextStyle? _warningTextStyle;

  SantoTextStyle get warningTextStyle =>
      _warningTextStyle ??
      SantoDefaultConfigUtils.defaultDialogConfig.warningTextStyle;

  /// 警示文案文字的对齐
  /// 默认为 [TextAlign.center]
  TextAlign? _warningTextAlign;

  TextAlign get warningTextAlign =>
      _warningTextAlign ??
      SantoDefaultConfigUtils.defaultDialogConfig.warningTextAlign;

  /// action 顶部 divider 的上方边距
  ///
  /// EdgeInsets.only(top: 28)
  EdgeInsets? _dividerPadding;

  EdgeInsets get dividerPadding =>
      _dividerPadding ??
      SantoDefaultConfigUtils.defaultDialogConfig.dividerPadding;

  /// 主色调按钮样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.brandPrimary],
  ///   fontSize: [SantoCommonConfig.fontSizeSubHead],
  ///   fontWeight: FontWeight.w600,
  /// )
  SantoTextStyle? _mainActionTextStyle;

  SantoTextStyle get mainActionTextStyle =>
      _mainActionTextStyle ??
      SantoDefaultConfigUtils.defaultDialogConfig.mainActionTextStyle;

  /// 主色调按钮的背景
  /// 默认为 [SantoCommonConfig.fillBase]
  Color? _mainActionBackgroundColor;

  Color get mainActionBackgroundColor =>
      _mainActionBackgroundColor ??
      SantoDefaultConfigUtils.defaultDialogConfig.mainActionBackgroundColor;

  /// 其他按钮的样式(超2个时按钮样式)
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize: [SantoCommonConfig.fontSizeSubHead],
  ///   fontWeight: FontWeight.w600,
  /// )
  SantoTextStyle? _assistActionsTextStyle;

  SantoTextStyle get assistActionsTextStyle =>
      _assistActionsTextStyle ??
      SantoDefaultConfigUtils.defaultDialogConfig.assistActionsTextStyle;

  /// 其他按钮的背景
  /// 默认为 [SantoCommonConfig.fillBase]
  Color? _assistActionsBackgroundColor;

  Color get assistActionsBackgroundColor =>
      _assistActionsBackgroundColor ??
      SantoDefaultConfigUtils.defaultDialogConfig.assistActionsBackgroundColor;

  /// 底部按钮高度
  /// 默认为 44.0
  double? _bottomHeight;

  double get bottomHeight =>
      _bottomHeight ?? SantoDefaultConfigUtils.defaultDialogConfig.bottomHeight;

  /// Dialog背景
  /// 默认为 [SantoCommonConfig.fillBase]
  Color? _backgroundColor;

  Color get backgroundColor =>
      _backgroundColor ??
      SantoDefaultConfigUtils.defaultDialogConfig.backgroundColor;

  /// 按优先级，打平 【Santo 内置配置】 < 【用户全局的默认配置】 < 【用户特殊配置】 < 【临时组件配置】
  ///
  /// 举例：
  /// ① 尝试获取最近的配置 [topRadius] 若配不为 null，直接使用该配置.
  /// ② [topRadius] 若为 null，尝试使用 全局配置中的配置 dialogConfig.
  /// ③ 如果全局配置中的配置同样为 null 则根据 [configId] 取出全局配置。
  /// ④ 如果没有配置 [configId] 的全局配置，则使用 Santo 默认的配置
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
    SantoDialogConfig dialogConfig = SantoThemeConfigurator.instance
        .getConfig(configId: configId)
        .dialogConfig;

    _dialogWidth ??= dialogConfig.dialogWidth;
    _radius ??= commonConfig.radiusLg;
    _titlePaddingSm ??= EdgeInsets.only(
      left: commonConfig.hSpacingXxl,
      right: commonConfig.hSpacingXxl,
      top: dialogConfig.titlePaddingSm.top,
      bottom: dialogConfig.titlePaddingSm.bottom,
    );
    _titlePaddingLg ??= EdgeInsets.only(
      left: commonConfig.hSpacingXxl,
      right: commonConfig.hSpacingXxl,
      top: dialogConfig.titlePaddingLg.top,
      bottom: dialogConfig.titlePaddingLg.bottom,
    );
    _iconPadding ??= EdgeInsets.only(
      left: dialogConfig.iconPadding.left,
      top: commonConfig.vSpacingXxl,
      right: dialogConfig.iconPadding.right,
      bottom: dialogConfig.iconPadding.bottom,
    );
    _titleTextStyle = dialogConfig.titleTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeHead,
      ).merge(_titleTextStyle),
    );
    _contentTextStyle = dialogConfig.contentTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextImportant,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_contentTextStyle),
    );
    _warningTextStyle = dialogConfig.warningTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.brandError,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_warningTextStyle),
    );
    _mainActionTextStyle = dialogConfig.mainActionTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.brandPrimary,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_mainActionTextStyle),
    );
    _assistActionsTextStyle = dialogConfig.assistActionsTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_assistActionsTextStyle),
    );
    _contentPaddingSm ??= EdgeInsets.only(
      left: commonConfig.hSpacingXl,
      right: commonConfig.hSpacingXl,
      top: dialogConfig.contentPaddingSm.top,
      bottom: dialogConfig.contentPaddingSm.bottom,
    );
    _contentPaddingSm ??= EdgeInsets.only(
      left: commonConfig.hSpacingXl,
      right: commonConfig.hSpacingXl,
      top: dialogConfig.contentPaddingLg.top,
      bottom: dialogConfig.contentPaddingLg.bottom,
    );
    _warningPaddingSm ??= EdgeInsets.only(
      left: commonConfig.hSpacingXl,
      right: commonConfig.hSpacingXl,
      top: dialogConfig.warningPaddingSm.top,
      bottom: dialogConfig.warningPaddingSm.bottom,
    );
    _warningPaddingLg ??= EdgeInsets.only(
      left: commonConfig.hSpacingXl,
      right: commonConfig.hSpacingXl,
      top: dialogConfig.warningPaddingLg.top,
      bottom: dialogConfig.warningPaddingLg.bottom,
    );
    _titleTextAlign ??= dialogConfig.titleTextAlign;
    _contentTextAlign ??= dialogConfig.contentTextAlign;
    _warningTextAlign ??= dialogConfig.warningTextAlign;
    _mainActionBackgroundColor ??= commonConfig.fillBase;
    _assistActionsBackgroundColor ??= commonConfig.fillBase;
    _bottomHeight ??= dialogConfig.bottomHeight;
    _dividerPadding ??= dialogConfig.dividerPadding;
    _backgroundColor ??= commonConfig.fillBase;
  }

  SantoDialogConfig copyWith({
    double? dialogWidth,
    double? radius,
    EdgeInsets? iconPadding,
    EdgeInsets? titlePaddingSm,
    EdgeInsets? titlePaddingLg,
    SantoTextStyle? titleTextStyle,
    TextAlign? titleTextAlign,
    EdgeInsets? contentPaddingSm,
    EdgeInsets? contentPaddingLg,
    SantoTextStyle? contentTextStyle,
    TextAlign? contentTextAlign,
    EdgeInsets? warningPaddingSm,
    EdgeInsets? warningPaddingLg,
    SantoTextStyle? warningTextStyle,
    TextAlign? warningTextAlign,
    EdgeInsets? dividerPadding,
    SantoTextStyle? mainActionTextStyle,
    SantoTextStyle? assistActionsTextStyle,
    Color? mainActionBackgroundColor,
    Color? assistActionsBackgroundColor,
    double? bottomHeight,
    Color? backgroundColor,
  }) {
    return SantoDialogConfig(
      dialogWidth: dialogWidth ?? _dialogWidth,
      radius: radius ?? _radius,
      iconPadding: iconPadding ?? _iconPadding,
      titlePaddingSm: titlePaddingSm ?? _titlePaddingSm,
      titlePaddingLg: titlePaddingLg ?? _titlePaddingLg,
      titleTextStyle: titleTextStyle ?? _titleTextStyle,
      titleTextAlign: titleTextAlign ?? _titleTextAlign,
      contentPaddingSm: contentPaddingSm ?? _contentPaddingSm,
      contentPaddingLg: contentPaddingLg ?? _contentPaddingLg,
      contentTextStyle: contentTextStyle ?? _contentTextStyle,
      contentTextAlign: contentTextAlign ?? _contentTextAlign,
      warningPaddingSm: warningPaddingSm ?? _warningPaddingSm,
      warningPaddingLg: warningPaddingLg ?? _warningPaddingLg,
      warningTextStyle: warningTextStyle ?? _warningTextStyle,
      warningTextAlign: warningTextAlign ?? _warningTextAlign,
      dividerPadding: dividerPadding ?? _dividerPadding,
      mainActionTextStyle: mainActionTextStyle ?? _mainActionTextStyle,
      assistActionsTextStyle: assistActionsTextStyle ?? _assistActionsTextStyle,
      mainActionBackgroundColor:
          mainActionBackgroundColor ?? _mainActionBackgroundColor,
      assistActionsBackgroundColor:
          assistActionsBackgroundColor ?? _assistActionsBackgroundColor,
      bottomHeight: bottomHeight ?? _bottomHeight,
      backgroundColor: backgroundColor ?? _backgroundColor,
    );
  }

  SantoDialogConfig merge(SantoDialogConfig? other) {
    if (other == null) return this;
    return copyWith(
      dialogWidth: other._dialogWidth,
      radius: other._radius,
      iconPadding: other._iconPadding,
      titlePaddingSm: other._titlePaddingSm,
      titlePaddingLg: other._titlePaddingLg,
      titleTextStyle: titleTextStyle.merge(other._titleTextStyle),
      titleTextAlign: other._titleTextAlign,
      contentPaddingSm: other._contentPaddingSm,
      contentPaddingLg: other._contentPaddingLg,
      contentTextStyle: contentTextStyle.merge(other._contentTextStyle),
      contentTextAlign: other._contentTextAlign,
      warningPaddingSm: other._warningPaddingSm,
      warningPaddingLg: other._warningPaddingLg,
      warningTextStyle: warningTextStyle.merge(other._warningTextStyle),
      warningTextAlign: other._warningTextAlign,
      dividerPadding: other._dividerPadding,
      mainActionTextStyle:
          mainActionTextStyle.merge(other._mainActionTextStyle),
      assistActionsTextStyle:
          assistActionsTextStyle.merge(other._assistActionsTextStyle),
      mainActionBackgroundColor: other._mainActionBackgroundColor,
      assistActionsBackgroundColor: other._assistActionsBackgroundColor,
      bottomHeight: other._bottomHeight,
      backgroundColor: other._backgroundColor,
    );
  }
}
