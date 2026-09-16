import 'dart:core';

import 'package:santo_ui/src/theme/base/santo_base_config.dart';
import 'package:santo_ui/src/theme/base/santo_default_config_utils.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/painting.dart';

/// 描述: 全局配置
/// 配置属性：色值、字体大小、间距、圆角
class SantoCommonConfig extends SantoBaseConfig {
  SantoCommonConfig({
    Color? brandPrimary,
    Color? brandPrimaryTap,
    Color? brandSuccess,
    Color? brandWarning,
    Color? brandError,
    Color? brandImportant,
    Color? brandImportantValue,
    Color? brandAuxiliary,
    Color? colorTextBase,
    Color? colorTextImportant,
    Color? colorTextBaseInverse,
    Color? colorTextSecondary,
    Color? colorTextDisabled,
    Color? colorTextHint,
    Color? colorLink,
    Color? fillBase,
    Color? fillBody,
    Color? fillMask,
    Color? borderColorBase,
    Color? dividerColorBase,
    double? fontSizeBebas,
    double? fontSizeHeadLg,
    double? fontSizeBase,
    double? fontSizeHead,
    double? fontSizeSubHead,
    double? fontSizeCaption,
    double? fontSizeCaptionSm,
    double? radiusXs,
    double? radiusSm,
    double? radiusMd,
    double? radiusLg,
    double? borderWidthSm,
    double? borderWidthMd,
    double? borderWidthLg,
    double? hSpacingXs,
    double? hSpacingSm,
    double? hSpacingMd,
    double? hSpacingLg,
    double? hSpacingXl,
    double? hSpacingXxl,
    double? vSpacingXs,
    double? vSpacingSm,
    double? vSpacingMd,
    double? vSpacingLg,
    double? vSpacingXl,
    double? vSpacingXxl,
    double? iconSizeXxs,
    double? iconSizeXs,
    double? iconSizeSm,
    double? iconSizeMd,
    double? iconSizeLg,
    String configId = GLOBAL_CONFIG_ID,
  })  : _brandPrimary = brandPrimary,
        _brandPrimaryTap = brandPrimaryTap,
        _brandSuccess = brandSuccess,
        _brandWarning = brandWarning,
        _brandError = brandError,
        _brandImportant = brandImportant,
        _brandImportantValue = brandImportantValue,
        _brandAuxiliary = brandAuxiliary,
        _colorTextBase = colorTextBase,
        _colorTextImportant = colorTextImportant,
        _colorTextBaseInverse = colorTextBaseInverse,
        _colorTextSecondary = colorTextSecondary,
        _colorTextDisabled = colorTextDisabled,
        _colorTextHint = colorTextHint,
        _colorLink = colorLink,
        _fillBase = fillBase,
        _fillBody = fillBody,
        _fillMask = fillMask,
        _borderColorBase = borderColorBase,
        _dividerColorBase = dividerColorBase,
        _fontSizeBebas = fontSizeBebas,
        _fontSizeHeadLg = fontSizeHeadLg,
        _fontSizeBase = fontSizeBase,
        _fontSizeHead = fontSizeHead,
        _fontSizeSubHead = fontSizeSubHead,
        _fontSizeCaption = fontSizeCaption,
        _fontSizeCaptionSm = fontSizeCaptionSm,
        _radiusXs = radiusXs,
        _radiusSm = radiusSm,
        _radiusMd = radiusMd,
        _radiusLg = radiusLg,
        _borderWidthSm = borderWidthSm,
        _borderWidthMd = borderWidthMd,
        _borderWidthLg = borderWidthLg,
        _hSpacingXs = hSpacingXs,
        _hSpacingSm = hSpacingSm,
        _hSpacingMd = hSpacingMd,
        _hSpacingLg = hSpacingLg,
        _hSpacingXl = hSpacingXl,
        _hSpacingXxl = hSpacingXxl,
        _vSpacingXs = vSpacingXs,
        _vSpacingSm = vSpacingSm,
        _vSpacingMd = vSpacingMd,
        _vSpacingLg = vSpacingLg,
        _vSpacingXl = vSpacingXl,
        _vSpacingXxl = vSpacingXxl,
        _iconSizeXxs = iconSizeXxs,
        _iconSizeXs = iconSizeXs,
        _iconSizeSm = iconSizeSm,
        _iconSizeMd = iconSizeMd,
        _iconSizeLg = iconSizeLg,
        super(configId: configId);

  SantoCommonConfig.autoFlatConfig({
    Color? brandPrimary,
    Color? brandPrimaryTap,
    Color? brandSuccess,
    Color? brandWarning,
    Color? brandError,
    Color? brandImportant,
    Color? brandImportantValue,
    Color? brandAuxiliary,
    Color? colorTextBase,
    Color? colorTextImportant,
    Color? colorTextBaseInverse,
    Color? colorTextSecondary,
    Color? colorTextDisabled,
    Color? colorTextHint,
    Color? colorLink,
    Color? fillBase,
    Color? fillBody,
    Color? fillMask,
    Color? borderColorBase,
    Color? dividerColorBase,
    double? fontSizeBebas,
    double? fontSizeHeadLg,
    double? fontSizeBase,
    double? fontSizeHead,
    double? fontSizeSubHead,
    double? fontSizeCaption,
    double? fontSizeCaptionSm,
    double? radiusXs,
    double? radiusSm,
    double? radiusMd,
    double? radiusLg,
    double? borderWidthSm,
    double? borderWidthMd,
    double? borderWidthLg,
    double? hSpacingXs,
    double? hSpacingSm,
    double? hSpacingMd,
    double? hSpacingLg,
    double? hSpacingXl,
    double? hSpacingXxl,
    double? vSpacingXs,
    double? vSpacingSm,
    double? vSpacingMd,
    double? vSpacingLg,
    double? vSpacingXl,
    double? vSpacingXxl,
    double? iconSizeXxs,
    double? iconSizeXs,
    double? iconSizeSm,
    double? iconSizeMd,
    double? iconSizeLg,
    String configId = GLOBAL_CONFIG_ID,
  })  : _brandPrimary = brandPrimary,
        _brandPrimaryTap = brandPrimaryTap,
        _brandSuccess = brandSuccess,
        _brandWarning = brandWarning,
        _brandError = brandError,
        _brandImportant = brandImportant,
        _brandImportantValue = brandImportantValue,
        _brandAuxiliary = brandAuxiliary,
        _colorTextBase = colorTextBase,
        _colorTextImportant = colorTextImportant,
        _colorTextBaseInverse = colorTextBaseInverse,
        _colorTextSecondary = colorTextSecondary,
        _colorTextDisabled = colorTextDisabled,
        _colorTextHint = colorTextHint,
        _colorLink = colorLink,
        _fillBase = fillBase,
        _fillBody = fillBody,
        _fillMask = fillMask,
        _borderColorBase = borderColorBase,
        _dividerColorBase = dividerColorBase,
        _fontSizeBebas = fontSizeBebas,
        _fontSizeHeadLg = fontSizeHeadLg,
        _fontSizeBase = fontSizeBase,
        _fontSizeHead = fontSizeHead,
        _fontSizeSubHead = fontSizeSubHead,
        _fontSizeCaption = fontSizeCaption,
        _fontSizeCaptionSm = fontSizeCaptionSm,
        _radiusXs = radiusXs,
        _radiusSm = radiusSm,
        _radiusMd = radiusMd,
        _radiusLg = radiusLg,
        _borderWidthSm = borderWidthSm,
        _borderWidthMd = borderWidthMd,
        _borderWidthLg = borderWidthLg,
        _hSpacingXs = hSpacingXs,
        _hSpacingSm = hSpacingSm,
        _hSpacingMd = hSpacingMd,
        _hSpacingLg = hSpacingLg,
        _hSpacingXl = hSpacingXl,
        _hSpacingXxl = hSpacingXxl,
        _vSpacingXs = vSpacingXs,
        _vSpacingSm = vSpacingSm,
        _vSpacingMd = vSpacingMd,
        _vSpacingLg = vSpacingLg,
        _vSpacingXl = vSpacingXl,
        _vSpacingXxl = vSpacingXxl,
        _iconSizeXxs = iconSizeXxs,
        _iconSizeXs = iconSizeXs,
        _iconSizeSm = iconSizeSm,
        _iconSizeMd = iconSizeMd,
        _iconSizeLg = iconSizeLg,
        super(configId: configId, autoFlatConfig: true);

  /// 基本单位
  static const double hd = 1;

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////// 色彩 /////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

//////////////////////////////////// 品牌色 /////////////////////////////////////

  /// 品牌色
  /// 默认为 Color(0xFF1677FF)
  Color? _brandPrimary;

  /// 主题色按下效果
  /// 默认为 Color(0x191677FF)
  Color? _brandPrimaryTap;

  /// 成功色
  /// 默认为 Color(0xFF52C41A)
  Color? _brandSuccess;

  /// 警告色
  /// 默认为 Color(0xFFFAAD14)
  Color? _brandWarning;

  /// 失败色
  /// 默认为 Color(0xFFFF4D4F)
  Color? _brandError;

  /// 重要-多用于红点色
  /// 默认为 Color(0xFFFF4D4F)
  Color? _brandImportant;

  /// 重要数值色
  /// 默认为 Color(0xFFFF5722)
  Color? _brandImportantValue;

  /// 辅助色
  /// 默认为 Color(0xFF2DB7F5)
  Color? _brandAuxiliary;

  /// 文本色相关
  ///
  /// 基础文字纯黑色
  /// 默认为 Color(0xFF17233D)
  Color? _colorTextBase;

  /// 基础文字重要色
  /// 默认为 Color(0xFF515A6E)
  Color? _colorTextImportant;

  /// 基础文字-反色
  /// 默认为 Color(0xFFFFFFFF)
  Color? _colorTextBaseInverse;

  /// 辅助文字色
  /// 默认为 Color(0xFF808695)
  Color? _colorTextSecondary;

  /// 失效或不可更改文字色
  /// 默认为 Color(0xFF808695)
  Color? _colorTextDisabled;

  /// 文本框提示暗文文字色
  /// 默认为 Color(0xFFCCCCCC)
  Color? _colorTextHint;

  /// 跟随主题色[brandPrimary]
  Color? _colorLink;

  /// 背景色相关
  ///
  /// 组件背景色
  /// 默认为 Color(0xFFFFFFFF)
  Color? _fillBase;

  /// 页面背景色
  /// 默认为 Color(0xFFF5F5F5)
  Color? _fillBody;

  /// 遮罩背景
  /// 默认为 Color(0x99000000)
  Color? _fillMask;

  /// 边框色
  /// 默认为 Color(0xFFE8EAEC)
  Color? _borderColorBase;

  /// 分割线色
  /// 默认为 Color(0xFFE8EAEC)
  Color? _dividerColorBase;

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////// 尺寸 /////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

  /// 文本字号
  ///
  /// 特殊数据展示，Bebas 数字字体，用于强吸引
  /// default value is 28
  double? _fontSizeBebas;

  /// 标题字体
  /// 名称/页面大标题
  /// 默认为 22
  double? _fontSizeHeadLg;

  /// 标题字体
  /// 内容模块标题/一级标题
  /// 默认为 18
  double? _fontSizeHead;

  /// 子标题字体
  /// 标题/录入文字/大按钮文字/二级标题
  /// 默认为  16
  double? _fontSizeSubHead;

  /// 基础字体
  /// 内容副文本/普通说明文字
  /// 默认为 14
  double? _fontSizeBase;

  /// 辅助字体-普通
  /// 默认为 12
  double? _fontSizeCaption;

  ///辅助字体-小
  /// 默认为 11
  double? _fontSizeCaptionSm;

  /// 圆角尺寸
  /// 默认为 2.0
  double? _radiusXs;

  /// 默认为 4.0
  double? _radiusSm;

  /// 默认为 6.0
  double? _radiusMd;

  /// 默认为 8.0
  double? _radiusLg;

  /// 边框尺寸
  ///
  /// 默认为 0.5
  double? _borderWidthSm;

  /// 默认为 1
  double? _borderWidthMd;

  /// 默认为 2
  double? _borderWidthLg;

  /// 水平间距
  /// 默认为 8
  double? _hSpacingXs;

  /// 默认为 12
  double? _hSpacingSm;

  /// 默认为 16
  double? _hSpacingMd;

  /// 默认为 20
  double? _hSpacingLg;

  /// 默认为 24
  double? _hSpacingXl;

  /// 默认为 42
  double? _hSpacingXxl;

  /// 垂直间距
  /// 默认为 4
  double? _vSpacingXs;

  /// 默认为 8
  double? _vSpacingSm;

  /// 默认为 12
  double? _vSpacingMd;

  /// 默认为 14
  double? _vSpacingLg;

  /// 默认为 16
  double? _vSpacingXl;

  /// 默认为 28
  double? _vSpacingXxl;

  /// 图标尺寸
  /// 默认为 8
  double? _iconSizeXxs;

  /// 默认为 12
  double? _iconSizeXs;

  /// 默认为 14
  double? _iconSizeSm;

  /// 默认为 16
  double? _iconSizeMd;

  /// 默认为 32
  double? _iconSizeLg;

  Color get brandPrimary =>
      _brandPrimary ?? SantoDefaultConfigUtils.defaultCommonConfig.brandPrimary;

  Color get brandPrimaryTap =>
      _brandPrimaryTap ??
      SantoDefaultConfigUtils.defaultCommonConfig.brandPrimaryTap;

  Color get brandSuccess =>
      _brandSuccess ?? SantoDefaultConfigUtils.defaultCommonConfig.brandSuccess;

  Color get brandWarning =>
      _brandWarning ?? SantoDefaultConfigUtils.defaultCommonConfig.brandWarning;

  Color get brandError =>
      _brandError ?? SantoDefaultConfigUtils.defaultCommonConfig.brandError;

  Color get brandImportant =>
      _brandImportant ??
      SantoDefaultConfigUtils.defaultCommonConfig.brandImportant;

  Color get brandImportantValue =>
      _brandImportantValue ??
      SantoDefaultConfigUtils.defaultCommonConfig.brandImportantValue;

  Color get brandAuxiliary =>
      _brandAuxiliary ??
      SantoDefaultConfigUtils.defaultCommonConfig.brandAuxiliary;

  Color get colorTextBase =>
      _colorTextBase ?? SantoDefaultConfigUtils.defaultCommonConfig.colorTextBase;

  Color get colorTextImportant =>
      _colorTextImportant ??
      SantoDefaultConfigUtils.defaultCommonConfig.colorTextImportant;

  Color get colorTextBaseInverse =>
      _colorTextBaseInverse ??
      SantoDefaultConfigUtils.defaultCommonConfig.colorTextBaseInverse;

  Color get colorTextSecondary =>
      _colorTextSecondary ??
      SantoDefaultConfigUtils.defaultCommonConfig.colorTextSecondary;

  Color get colorTextDisabled =>
      _colorTextDisabled ??
      SantoDefaultConfigUtils.defaultCommonConfig.colorTextDisabled;

  Color get colorTextHint =>
      _colorTextHint ?? SantoDefaultConfigUtils.defaultCommonConfig.colorTextHint;

  Color get colorLink =>
      _colorLink ?? SantoDefaultConfigUtils.defaultCommonConfig.colorLink;

  Color get fillBase =>
      _fillBase ?? SantoDefaultConfigUtils.defaultCommonConfig.fillBase;

  Color get fillBody =>
      _fillBody ?? SantoDefaultConfigUtils.defaultCommonConfig.fillBody;

  Color get fillMask =>
      _fillMask ?? SantoDefaultConfigUtils.defaultCommonConfig.fillMask;

  Color get borderColorBase =>
      _borderColorBase ??
      SantoDefaultConfigUtils.defaultCommonConfig.borderColorBase;

  Color get dividerColorBase =>
      _dividerColorBase ??
      SantoDefaultConfigUtils.defaultCommonConfig.dividerColorBase;

  double get fontSizeBebas =>
      _fontSizeBebas ?? SantoDefaultConfigUtils.defaultCommonConfig.fontSizeBebas;

  double get fontSizeHeadLg =>
      _fontSizeHeadLg ??
      SantoDefaultConfigUtils.defaultCommonConfig.fontSizeHeadLg;

  double get fontSizeHead =>
      _fontSizeHead ?? SantoDefaultConfigUtils.defaultCommonConfig.fontSizeHead;

  double get fontSizeSubHead =>
      _fontSizeSubHead ??
      SantoDefaultConfigUtils.defaultCommonConfig.fontSizeSubHead;

  double get fontSizeBase =>
      _fontSizeBase ?? SantoDefaultConfigUtils.defaultCommonConfig.fontSizeBase;

  double get fontSizeCaption =>
      _fontSizeCaption ??
      SantoDefaultConfigUtils.defaultCommonConfig.fontSizeCaption;

  double get fontSizeCaptionSm =>
      _fontSizeCaptionSm ??
      SantoDefaultConfigUtils.defaultCommonConfig.fontSizeCaptionSm;

  double get radiusXs =>
      _radiusXs ?? SantoDefaultConfigUtils.defaultCommonConfig.radiusXs;

  double get radiusSm =>
      _radiusSm ?? SantoDefaultConfigUtils.defaultCommonConfig.radiusSm;

  double get radiusMd =>
      _radiusMd ?? SantoDefaultConfigUtils.defaultCommonConfig.radiusMd;

  double get radiusLg =>
      _radiusLg ?? SantoDefaultConfigUtils.defaultCommonConfig.radiusLg;

  double get borderWidthSm =>
      _borderWidthSm ?? SantoDefaultConfigUtils.defaultCommonConfig.borderWidthSm;

  double get borderWidthMd =>
      _borderWidthMd ?? SantoDefaultConfigUtils.defaultCommonConfig.borderWidthMd;

  double get borderWidthLg =>
      _borderWidthLg ?? SantoDefaultConfigUtils.defaultCommonConfig.borderWidthLg;

  double get hSpacingXs =>
      _hSpacingXs ?? SantoDefaultConfigUtils.defaultCommonConfig.hSpacingXs;

  double get hSpacingSm =>
      _hSpacingSm ?? SantoDefaultConfigUtils.defaultCommonConfig.hSpacingSm;

  double get hSpacingMd =>
      _hSpacingMd ?? SantoDefaultConfigUtils.defaultCommonConfig.hSpacingMd;

  double get hSpacingLg =>
      _hSpacingLg ?? SantoDefaultConfigUtils.defaultCommonConfig.hSpacingLg;

  double get hSpacingXl =>
      _hSpacingXl ?? SantoDefaultConfigUtils.defaultCommonConfig.hSpacingXl;

  double get hSpacingXxl =>
      _hSpacingXxl ?? SantoDefaultConfigUtils.defaultCommonConfig.hSpacingXxl;

  double get vSpacingXs =>
      _vSpacingXs ?? SantoDefaultConfigUtils.defaultCommonConfig.vSpacingXs;

  double get vSpacingSm =>
      _vSpacingSm ?? SantoDefaultConfigUtils.defaultCommonConfig.vSpacingSm;

  double get vSpacingMd =>
      _vSpacingMd ?? SantoDefaultConfigUtils.defaultCommonConfig.vSpacingMd;

  double get vSpacingLg =>
      _vSpacingLg ?? SantoDefaultConfigUtils.defaultCommonConfig.vSpacingLg;

  double get vSpacingXl =>
      _vSpacingXl ?? SantoDefaultConfigUtils.defaultCommonConfig.vSpacingXl;

  double get vSpacingXxl =>
      _vSpacingXxl ?? SantoDefaultConfigUtils.defaultCommonConfig.vSpacingXxl;

  double get iconSizeXxs =>
      _iconSizeXxs ?? SantoDefaultConfigUtils.defaultCommonConfig.iconSizeXxs;

  double get iconSizeXs =>
      _iconSizeXs ?? SantoDefaultConfigUtils.defaultCommonConfig.iconSizeXs;

  double get iconSizeSm =>
      _iconSizeSm ?? SantoDefaultConfigUtils.defaultCommonConfig.iconSizeSm;

  double get iconSizeMd =>
      _iconSizeMd ?? SantoDefaultConfigUtils.defaultCommonConfig.iconSizeMd;

  double get iconSizeLg =>
      _iconSizeLg ?? SantoDefaultConfigUtils.defaultCommonConfig.iconSizeLg;

  /// 优先级 [GLOBAL_CONFIG_ID] 获取配置 > [SANTO_CONFIG_ID] 获取配置
  @override
  void initThemeConfig(
    String configId, {
    SantoCommonConfig? currentLevelCommonConfig,
  }) {
    super.initThemeConfig(
      configId,
      currentLevelCommonConfig: currentLevelCommonConfig,
    );

    /// 获取合适的 完整配置（SantoAllConfig）
    _colorTextBase ??= commonConfig._colorTextBase;
    _colorTextImportant ??= commonConfig._colorTextImportant;
    _colorTextBaseInverse ??= commonConfig._colorTextBaseInverse;
    _colorTextSecondary ??= commonConfig._colorTextSecondary;
    _colorTextHint ??= commonConfig._colorTextHint;
    _colorTextDisabled ??= commonConfig._colorTextDisabled;
    _brandAuxiliary ??= commonConfig._brandAuxiliary;
    _colorLink ??= commonConfig._colorLink;
    _fillBase ??= commonConfig._fillBase;
    _fillBody ??= commonConfig._fillBody;
    _fillMask ??= commonConfig._fillMask;
    _brandPrimary ??= commonConfig._brandPrimary;
    _brandPrimaryTap ??= commonConfig._brandPrimaryTap;
    _brandSuccess ??= commonConfig._brandSuccess;
    _brandWarning ??= commonConfig._brandWarning;
    _brandError ??= commonConfig._brandError;
    _brandImportant ??= commonConfig._brandImportant;
    _brandImportantValue ??= commonConfig._brandImportantValue;
    _borderColorBase ??= commonConfig._borderColorBase;
    _dividerColorBase ??= commonConfig._dividerColorBase;
    _fontSizeBebas ??= commonConfig._fontSizeBebas;
    _fontSizeHeadLg ??= commonConfig._fontSizeHeadLg;
    _fontSizeBase ??= commonConfig._fontSizeBase;
    _fontSizeHead ??= commonConfig._fontSizeHead;
    _fontSizeSubHead ??= commonConfig._fontSizeSubHead;
    _fontSizeCaption ??= commonConfig._fontSizeCaption;
    _fontSizeCaptionSm ??= commonConfig._fontSizeCaptionSm;
    _radiusXs ??= commonConfig._radiusXs;
    _radiusSm ??= commonConfig._radiusSm;
    _radiusMd ??= commonConfig._radiusMd;
    _radiusLg ??= commonConfig._radiusLg;
    _borderWidthSm ??= commonConfig._borderWidthSm;
    _borderWidthMd ??= commonConfig._borderWidthMd;
    _borderWidthLg ??= commonConfig._borderWidthLg;
    _hSpacingXs ??= commonConfig._hSpacingXs;
    _hSpacingSm ??= commonConfig._hSpacingSm;
    _hSpacingMd ??= commonConfig._hSpacingMd;
    _hSpacingLg ??= commonConfig._hSpacingLg;
    _hSpacingXl ??= commonConfig._hSpacingXl;
    _hSpacingXxl ??= commonConfig._hSpacingXxl;
    _vSpacingXs ??= commonConfig._vSpacingXs;
    _vSpacingSm ??= commonConfig._vSpacingSm;
    _vSpacingMd ??= commonConfig._vSpacingMd;
    _vSpacingLg ??= commonConfig._vSpacingLg;
    _vSpacingXl ??= commonConfig._vSpacingXl;
    _vSpacingXxl ??= commonConfig._vSpacingXxl;
    _iconSizeXxs ??= commonConfig._iconSizeXxs;
    _iconSizeXs ??= commonConfig._iconSizeXs;
    _iconSizeSm ??= commonConfig._iconSizeSm;
    _iconSizeMd ??= commonConfig._iconSizeMd;
    _iconSizeLg ??= commonConfig._iconSizeLg;
  }
}
