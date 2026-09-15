import 'package:santo_ui/src/theme/base/santo_base_config.dart';
import 'package:santo_ui/src/theme/base/santo_default_config_utils.dart';
import 'package:santo_ui/src/theme/base/santo_text_style.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:flutter/material.dart';

/// 描述: form 表单项主配置类
class SantoFormItemConfig extends SantoBaseConfig {
  /// 遵循全局配置
  /// 默认为 [SantoDefaultConfigUtils.defaultFormItemConfig]
  SantoFormItemConfig({
    Color? backgroundColor,
    SantoTextStyle? titleTextStyle,
    SantoTextStyle? subTitleTextStyle,
    SantoTextStyle? errorTextStyle,
    SantoTextStyle? hintTextStyle,
    SantoTextStyle? contentTextStyle,
    EdgeInsets? formPadding,
    EdgeInsets? titlePaddingSm,
    EdgeInsets? titlePaddingLg,
    EdgeInsets? optionsMiddlePadding,
    EdgeInsets? subTitlePadding,
    EdgeInsets? errorPadding,
    SantoTextStyle? disableTextStyle,
    SantoTextStyle? tipsTextStyle,
    SantoTextStyle? headTitleTextStyle,
    SantoTextStyle? optionTextStyle,
    SantoTextStyle? optionSelectedTextStyle,
    String configId = GLOBAL_CONFIG_ID,
  })  : _backgroundColor = backgroundColor,
        _titleTextStyle = titleTextStyle,
        _subTitleTextStyle = subTitleTextStyle,
        _errorTextStyle = errorTextStyle,
        _hintTextStyle = hintTextStyle,
        _contentTextStyle = contentTextStyle,
        _formPadding = formPadding,
        _titlePaddingSm = titlePaddingSm,
        _titlePaddingLg = titlePaddingLg,
        _optionsMiddlePadding = optionsMiddlePadding,
        _subTitlePadding = subTitlePadding,
        _errorPadding = errorPadding,
        _disableTextStyle = disableTextStyle,
        _tipsTextStyle = tipsTextStyle,
        _headTitleTextStyle = headTitleTextStyle,
        _optionTextStyle = optionTextStyle,
        _optionSelectedTextStyle = optionSelectedTextStyle,
        super(configId: configId);

  SantoFormItemConfig.generatorFromConfigId(String configId) {
    initThemeConfig(configId);
  }

  /// 表单项整体背景色
  /// default color is Colors.White
  Color? _backgroundColor;

  /// 左侧标题文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize: [SantoCommonConfig.fontSizeHead],
  /// )
  SantoTextStyle? _headTitleTextStyle;

  /// 左侧标题文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize: [SantoCommonConfig.fontSizeSubHead],
  /// )
  SantoTextStyle? _titleTextStyle;

  /// 左侧辅助文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextSecondary],
  ///   fontSize: [SantoCommonConfig.fontSizeCaption],
  /// )
  SantoTextStyle? _subTitleTextStyle;

  /// 左侧 Error 文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.brandError],
  ///   fontSize: [SantoCommonConfig.fontSizeCaption],
  /// )
  SantoTextStyle? _errorTextStyle;

  /// 右侧 输入、选择提示文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextHint],
  ///   fontSize: [SantoCommonConfig.fontSizeSubHead],
  /// )
  SantoTextStyle? _hintTextStyle;

  /// 右侧 主要内容样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize: [SantoCommonConfig.fontSizeSubHead],
  /// )
  SantoTextStyle? _contentTextStyle;

  /// 表单项 当有星号标识 上下右边距
  ///
  /// EdgeInsets.only(
  ///   left: 0,
  ///   top: [SantoCommonConfig.vSpacingLg],
  ///   right: [SantoCommonConfig.hSpacingLg],
  ///   bottom: [SantoCommonConfig.vSpacingLg],
  /// )
  EdgeInsets? _formPadding;

  /// 表单项 当有星号标识 左边距
  ///
  /// EdgeInsets.only(left: 10)
  EdgeInsets? _titlePaddingSm;

  /// 表单项 当无星号标识 左右边距
  ///
  /// EdgeInsets.only(left: [SantoCommonConfig.hSpacingLg])
  EdgeInsets? _titlePaddingLg;

  /// 选项之间间距 单选 or 多选
  ///
  /// EdgeInsets.only(left: [SantoCommonConfig.hSpacingMd])
  EdgeInsets? _optionsMiddlePadding;

  /// 选项普通文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextBase],
  ///   fontSize: [SantoCommonConfig.fontSizeSubHead],
  ///   height: 1.3,
  /// )
  SantoTextStyle? _optionTextStyle;

  /// 选项选中文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.brandPrimary],
  ///   fontSize: [SantoCommonConfig.fontSizeSubHead],
  ///   height: 1.3,
  /// )
  SantoTextStyle? _optionSelectedTextStyle;

  /// 子标题 左上间距
  ///
  /// EdgeInsets.only(
  ///   left: [SantoCommonConfig.hSpacingLg],
  ///   top: [SantoCommonConfig.vSpacingXs],
  /// )
  EdgeInsets? _subTitlePadding;

  /// error提示 左上间距
  ///
  /// EdgeInsets.only(
  ///   left: [SantoCommonConfig.hSpacingLg],
  ///   top: [SantoCommonConfig.vSpacingXs],
  /// )
  EdgeInsets? _errorPadding;

  /// 不可修改内容展示
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextDisabled],
  ///   fontSize: [SantoCommonConfig.fontSizeSubHead],
  /// )
  SantoTextStyle? _disableTextStyle;

  /// 提示文本样式
  ///
  /// SantoTextStyle(
  ///   color: [SantoCommonConfig.colorTextSecondary],
  ///   fontSize: [SantoCommonConfig.fontSizeBase],
  /// )
  SantoTextStyle? _tipsTextStyle;

  Color get backgroundColor =>
      _backgroundColor ??
      SantoDefaultConfigUtils.defaultFormItemConfig.backgroundColor;

  SantoTextStyle get headTitleTextStyle =>
      _headTitleTextStyle ??
      SantoDefaultConfigUtils.defaultFormItemConfig.headTitleTextStyle;

  SantoTextStyle get titleTextStyle =>
      _titleTextStyle ??
      SantoDefaultConfigUtils.defaultFormItemConfig.titleTextStyle;

  SantoTextStyle get subTitleTextStyle =>
      _subTitleTextStyle ??
      SantoDefaultConfigUtils.defaultFormItemConfig.subTitleTextStyle;

  SantoTextStyle get errorTextStyle =>
      _errorTextStyle ??
      SantoDefaultConfigUtils.defaultFormItemConfig.errorTextStyle;

  SantoTextStyle get hintTextStyle =>
      _hintTextStyle ??
      SantoDefaultConfigUtils.defaultFormItemConfig.hintTextStyle;

  SantoTextStyle get contentTextStyle =>
      _contentTextStyle ??
      SantoDefaultConfigUtils.defaultFormItemConfig.contentTextStyle;

  EdgeInsets get formPadding =>
      _formPadding ?? SantoDefaultConfigUtils.defaultFormItemConfig.formPadding;

  EdgeInsets get titlePaddingSm =>
      _titlePaddingSm ??
      SantoDefaultConfigUtils.defaultFormItemConfig.titlePaddingSm;

  EdgeInsets get titlePaddingLg =>
      _titlePaddingLg ??
      SantoDefaultConfigUtils.defaultFormItemConfig.titlePaddingLg;

  EdgeInsets get optionsMiddlePadding =>
      _optionsMiddlePadding ??
      SantoDefaultConfigUtils.defaultFormItemConfig.optionsMiddlePadding;

  SantoTextStyle get optionTextStyle =>
      _optionTextStyle ??
      SantoDefaultConfigUtils.defaultFormItemConfig.optionTextStyle;

  SantoTextStyle get optionSelectedTextStyle =>
      _optionSelectedTextStyle ??
      SantoDefaultConfigUtils.defaultFormItemConfig.optionSelectedTextStyle;

  EdgeInsets get subTitlePadding =>
      _subTitlePadding ??
      SantoDefaultConfigUtils.defaultFormItemConfig.subTitlePadding;

  EdgeInsets get errorPadding =>
      _errorPadding ?? SantoDefaultConfigUtils.defaultFormItemConfig.errorPadding;

  SantoTextStyle get disableTextStyle =>
      _disableTextStyle ??
      SantoDefaultConfigUtils.defaultFormItemConfig.disableTextStyle;

  SantoTextStyle get tipsTextStyle =>
      _tipsTextStyle ??
      SantoDefaultConfigUtils.defaultFormItemConfig.tipsTextStyle;

  /// 举例：
  /// ① 尝试获取最近的配置 [topRadius] 若配不为 null，直接使用该配置.
  /// ② [topRadius] 若为 null，尝试使用 全局配置中的配置 SantoFormItemConfig.
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

    /// 用户全局form组件配置
    SantoFormItemConfig formItemThemeData = SantoThemeConfigurator.instance
        .getConfig(configId: configId)
        .formItemConfig;

    _backgroundColor ??= formItemThemeData.backgroundColor;
    _titlePaddingSm ??= formItemThemeData.titlePaddingSm;
    _titlePaddingLg ??= formItemThemeData.titlePaddingLg;
    _optionSelectedTextStyle = formItemThemeData.optionSelectedTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.brandPrimary,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_optionSelectedTextStyle),
    );
    _optionTextStyle = formItemThemeData.optionTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_optionTextStyle),
    );
    _headTitleTextStyle = formItemThemeData.headTitleTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeHead,
      ).merge(_headTitleTextStyle),
    );
    _errorPadding ??= EdgeInsets.only(
      left: commonConfig.hSpacingLg,
      right: formItemThemeData.errorPadding.right,
      top: commonConfig.vSpacingXs,
      bottom: formItemThemeData.errorPadding.bottom,
    );
    _subTitlePadding ??= EdgeInsets.only(
      left: commonConfig.hSpacingLg,
      right: formItemThemeData.subTitlePadding.right,
      top: commonConfig.vSpacingXs,
      bottom: formItemThemeData.subTitlePadding.bottom,
    );
    _formPadding ??= EdgeInsets.only(
      left: formItemThemeData.formPadding.left,
      right: commonConfig.hSpacingLg,
      top: commonConfig.vSpacingLg,
      bottom: commonConfig.vSpacingLg,
    );
    _tipsTextStyle = formItemThemeData.tipsTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextSecondary,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_tipsTextStyle),
    );
    _disableTextStyle = formItemThemeData.disableTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextDisabled,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_disableTextStyle),
    );
    _contentTextStyle = formItemThemeData.contentTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_contentTextStyle),
    );
    _hintTextStyle = formItemThemeData.hintTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextHint,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_hintTextStyle),
    );
    _titleTextStyle = formItemThemeData.titleTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_titleTextStyle),
    );
    _subTitleTextStyle = formItemThemeData.subTitleTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextSecondary,
        fontSize: commonConfig.fontSizeCaption,
      ).merge(_subTitleTextStyle),
    );
    _errorTextStyle = formItemThemeData.errorTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.brandError,
        fontSize: commonConfig.fontSizeCaption,
      ).merge(_errorTextStyle),
    );
    _optionsMiddlePadding ??= formItemThemeData.optionsMiddlePadding;
  }

  SantoFormItemConfig copyWith({
    Color? backgroundColor,
    SantoTextStyle? titleTextStyle,
    SantoTextStyle? subTitleTextStyle,
    SantoTextStyle? errorTextStyle,
    SantoTextStyle? hintTextStyle,
    SantoTextStyle? contentTextStyle,
    EdgeInsets? formPadding,
    EdgeInsets? titlePaddingSm,
    EdgeInsets? titlePaddingLg,
    EdgeInsets? optionsMiddlePadding,
    EdgeInsets? subTitlePadding,
    EdgeInsets? errorPadding,
    SantoTextStyle? disableTextStyle,
    SantoTextStyle? tipsTextStyle,
    SantoTextStyle? headTitleTextStyle,
    SantoTextStyle? optionTextStyle,
    SantoTextStyle? optionSelectedTextStyle,
  }) {
    return SantoFormItemConfig(
      backgroundColor: backgroundColor ?? _backgroundColor,
      titleTextStyle: titleTextStyle ?? _titleTextStyle,
      subTitleTextStyle: subTitleTextStyle ?? _subTitleTextStyle,
      errorTextStyle: errorTextStyle ?? _errorTextStyle,
      hintTextStyle: hintTextStyle ?? _hintTextStyle,
      contentTextStyle: contentTextStyle ?? _contentTextStyle,
      formPadding: formPadding ?? _formPadding,
      titlePaddingSm: titlePaddingSm ?? _titlePaddingSm,
      titlePaddingLg: titlePaddingLg ?? _titlePaddingLg,
      optionsMiddlePadding: optionsMiddlePadding ?? _optionsMiddlePadding,
      subTitlePadding: subTitlePadding ?? _subTitlePadding,
      errorPadding: errorPadding ?? _errorPadding,
      disableTextStyle: disableTextStyle ?? _disableTextStyle,
      tipsTextStyle: tipsTextStyle ?? _tipsTextStyle,
      headTitleTextStyle: headTitleTextStyle ?? _headTitleTextStyle,
      optionTextStyle: optionTextStyle ?? _optionTextStyle,
      optionSelectedTextStyle:
          optionSelectedTextStyle ?? _optionSelectedTextStyle,
    );
  }

  SantoFormItemConfig merge(SantoFormItemConfig? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other._backgroundColor,
      titleTextStyle: titleTextStyle.merge(other._titleTextStyle),
      subTitleTextStyle: subTitleTextStyle.merge(other._subTitleTextStyle),
      errorTextStyle: errorTextStyle.merge(other._errorTextStyle),
      hintTextStyle: hintTextStyle.merge(other._hintTextStyle),
      contentTextStyle: contentTextStyle.merge(other._contentTextStyle),
      formPadding: other._formPadding,
      titlePaddingSm: other._titlePaddingSm,
      titlePaddingLg: other._titlePaddingLg,
      optionsMiddlePadding: other._optionsMiddlePadding,
      subTitlePadding: other._subTitlePadding,
      errorPadding: other._errorPadding,
      disableTextStyle: disableTextStyle.merge(other._disableTextStyle),
      tipsTextStyle: tipsTextStyle.merge(other._tipsTextStyle),
      headTitleTextStyle: headTitleTextStyle.merge(other._headTitleTextStyle),
      optionTextStyle: optionTextStyle.merge(other._optionTextStyle),
      optionSelectedTextStyle:
          optionSelectedTextStyle.merge(other._optionSelectedTextStyle),
    );
  }
}
