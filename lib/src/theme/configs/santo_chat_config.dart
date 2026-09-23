import 'package:santo_ui/src/theme/base/santo_base_config.dart';
import 'package:santo_ui/src/theme/base/santo_text_style.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 会话默认值
///
/// 直接使用常量而非 [SantoDefaultConfigUtils.defaultChatConfig] 回退,
/// 避免 getter 在默认实例上自引用导致无限递归。
const double kSantoChatAvatarSize = 36;
const double kSantoChatEmojiSize = 18;
const double kSantoChatBubbleMaxWidthRatio = 0.72;
const Color kSantoChatSystemBackgroundColor = Color(0x14000000);

/// 我方气泡底色的透明度(基于主题色 [SantoCommonConfig.brandPrimary] 派生)
const double kSantoChatMyBubbleOpacity = 0.1;

/// SantoChat 的配置文件 全局配置
///
/// 颜色/字号/间距/圆角默认取 [SantoCommonConfig],保证与全局主题一致。
///
/// @since v1.5.0
class SantoChatConfig extends SantoBaseConfig {
  /// 遵循外部主题配置
  /// 默认值见 [SantoDefaultConfigUtils.defaultChatConfig]
  SantoChatConfig({
    Color? backgroundColor,
    Color? myBubbleColor,
    Color? otherBubbleColor,
    SantoTextStyle? myTextStyle,
    SantoTextStyle? otherTextStyle,
    double? bubbleRadius,
    EdgeInsets? bubblePadding,
    double? bubbleMaxWidthRatio,
    Color? myAccentColor,
    Color? otherAccentColor,
    SantoTextStyle? nameTextStyle,
    SantoTextStyle? timeTextStyle,
    SantoTextStyle? systemTextStyle,
    Color? systemBackgroundColor,
    EdgeInsets? systemPadding,
    double? avatarSize,
    Color? quoteBackgroundColor,
    SantoTextStyle? quoteTitleTextStyle,
    SantoTextStyle? quotePreviewTextStyle,
    Color? inputBackgroundColor,
    SantoTextStyle? inputTextStyle,
    SantoTextStyle? inputHintTextStyle,
    double? emojiSize,
    String configId = GLOBAL_CONFIG_ID,
  })  : _backgroundColor = backgroundColor,
        _myBubbleColor = myBubbleColor,
        _otherBubbleColor = otherBubbleColor,
        _myTextStyle = myTextStyle,
        _otherTextStyle = otherTextStyle,
        _bubbleRadius = bubbleRadius,
        _bubblePadding = bubblePadding,
        _bubbleMaxWidthRatio = bubbleMaxWidthRatio,
        _myAccentColor = myAccentColor,
        _otherAccentColor = otherAccentColor,
        _nameTextStyle = nameTextStyle,
        _timeTextStyle = timeTextStyle,
        _systemTextStyle = systemTextStyle,
        _systemBackgroundColor = systemBackgroundColor,
        _systemPadding = systemPadding,
        _avatarSize = avatarSize,
        _quoteBackgroundColor = quoteBackgroundColor,
        _quoteTitleTextStyle = quoteTitleTextStyle,
        _quotePreviewTextStyle = quotePreviewTextStyle,
        _inputBackgroundColor = inputBackgroundColor,
        _inputTextStyle = inputTextStyle,
        _inputHintTextStyle = inputHintTextStyle,
        _emojiSize = emojiSize,
        super(configId: configId);

  /// 会话背景色
  Color? _backgroundColor;

  /// 我方气泡背景色
  Color? _myBubbleColor;

  /// 对方气泡背景色
  Color? _otherBubbleColor;

  /// 我方气泡文字样式
  SantoTextStyle? _myTextStyle;

  /// 对方气泡文字样式
  SantoTextStyle? _otherTextStyle;

  /// 气泡圆角
  double? _bubbleRadius;

  /// 气泡内边距
  EdgeInsets? _bubblePadding;

  /// 气泡最大宽度占列表宽度的比例
  double? _bubbleMaxWidthRatio;

  /// 我方气泡内的 @/链接强调色
  Color? _myAccentColor;

  /// 对方气泡内的 @/链接强调色
  Color? _otherAccentColor;

  /// 群聊里对方昵称样式
  SantoTextStyle? _nameTextStyle;

  /// 时间分割文案样式
  SantoTextStyle? _timeTextStyle;

  /// 系统消息文字样式
  SantoTextStyle? _systemTextStyle;

  /// 系统消息背景色
  Color? _systemBackgroundColor;

  /// 系统消息内边距
  EdgeInsets? _systemPadding;

  /// 头像边长
  double? _avatarSize;

  /// 对方气泡内引用块背景色
  Color? _quoteBackgroundColor;

  /// 引用块来源样式
  SantoTextStyle? _quoteTitleTextStyle;

  /// 引用块摘要样式
  SantoTextStyle? _quotePreviewTextStyle;

  /// 输入区背景色
  Color? _inputBackgroundColor;

  /// 输入框文字样式
  SantoTextStyle? _inputTextStyle;

  /// 输入框提示文字样式
  SantoTextStyle? _inputHintTextStyle;

  /// 表情图片边长
  double? _emojiSize;

  Color get backgroundColor => _backgroundColor ?? commonConfig.fillBody;

  /// 我方气泡背景色:主题色加透明度派生,浅底配深色文字,对齐 DevOpsMobile
  Color get myBubbleColor => _myBubbleColor ??
      commonConfig.brandPrimary.withOpacity(kSantoChatMyBubbleOpacity);

  Color get otherBubbleColor => _otherBubbleColor ?? commonConfig.fillBase;

  SantoTextStyle get myTextStyle =>
      _myTextStyle ??
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeBase,
      );

  SantoTextStyle get otherTextStyle =>
      _otherTextStyle ??
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeBase,
      );

  double get bubbleRadius => _bubbleRadius ?? commonConfig.radiusMd;

  EdgeInsets get bubblePadding =>
      _bubblePadding ??
      EdgeInsets.symmetric(
        horizontal: commonConfig.hSpacingSm,
        vertical: commonConfig.hSpacingSm,
      );

  double get bubbleMaxWidthRatio =>
      _bubbleMaxWidthRatio ?? kSantoChatBubbleMaxWidthRatio;

  Color get myAccentColor => _myAccentColor ?? commonConfig.colorLink;

  Color get otherAccentColor => _otherAccentColor ?? commonConfig.colorLink;

  SantoTextStyle get nameTextStyle =>
      _nameTextStyle ??
      SantoTextStyle(
        color: commonConfig.colorTextSecondary,
        fontSize: commonConfig.fontSizeCaption,
      );

  SantoTextStyle get timeTextStyle =>
      _timeTextStyle ??
      SantoTextStyle(
        color: commonConfig.colorTextSecondary,
        fontSize: commonConfig.fontSizeCaptionSm,
      );

  SantoTextStyle get systemTextStyle =>
      _systemTextStyle ??
      SantoTextStyle(
        color: commonConfig.colorTextSecondary,
        fontSize: commonConfig.fontSizeCaption,
      );

  Color get systemBackgroundColor =>
      _systemBackgroundColor ?? kSantoChatSystemBackgroundColor;

  EdgeInsets get systemPadding =>
      _systemPadding ??
      EdgeInsets.symmetric(
        horizontal: commonConfig.hSpacingSm,
        vertical: commonConfig.vSpacingXs,
      );

  double get avatarSize => _avatarSize ?? kSantoChatAvatarSize;

  Color get quoteBackgroundColor =>
      _quoteBackgroundColor ?? commonConfig.fillBody;

  SantoTextStyle get quoteTitleTextStyle =>
      _quoteTitleTextStyle ??
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeCaption,
        fontWeight: FontWeight.w600,
      );

  SantoTextStyle get quotePreviewTextStyle =>
      _quotePreviewTextStyle ??
      SantoTextStyle(
        color: commonConfig.colorTextSecondary,
        fontSize: commonConfig.fontSizeCaption,
      );

  Color get inputBackgroundColor =>
      _inputBackgroundColor ?? commonConfig.fillBase;

  SantoTextStyle get inputTextStyle =>
      _inputTextStyle ??
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeBase,
      );

  SantoTextStyle get inputHintTextStyle =>
      _inputHintTextStyle ??
      SantoTextStyle(
        color: commonConfig.colorTextHint,
        fontSize: commonConfig.fontSizeBase,
      );

  double get emojiSize => _emojiSize ?? kSantoChatEmojiSize;

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
    SantoChatConfig chatConfig = SantoThemeConfigurator.instance
        .getConfig(configId: configId)
        .chatConfig;

    _backgroundColor ??= chatConfig._backgroundColor;
    _myBubbleColor ??= chatConfig._myBubbleColor;
    _otherBubbleColor ??= chatConfig._otherBubbleColor;
    _bubbleRadius ??= chatConfig._bubbleRadius;
    _bubblePadding ??= chatConfig._bubblePadding;
    _bubbleMaxWidthRatio ??= chatConfig._bubbleMaxWidthRatio;
    _myAccentColor ??= chatConfig._myAccentColor;
    _otherAccentColor ??= chatConfig._otherAccentColor;
    _systemBackgroundColor ??= chatConfig._systemBackgroundColor;
    _systemPadding ??= chatConfig._systemPadding;
    _avatarSize ??= chatConfig._avatarSize;
    _quoteBackgroundColor ??= chatConfig._quoteBackgroundColor;
    _inputBackgroundColor ??= chatConfig._inputBackgroundColor;
    _emojiSize ??= chatConfig._emojiSize;

    _myTextStyle = chatConfig.myTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_myTextStyle),
    );
    _otherTextStyle = chatConfig.otherTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_otherTextStyle),
    );
    _nameTextStyle = chatConfig.nameTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextSecondary,
        fontSize: commonConfig.fontSizeCaption,
      ).merge(_nameTextStyle),
    );
    _timeTextStyle = chatConfig.timeTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextSecondary,
        fontSize: commonConfig.fontSizeCaptionSm,
      ).merge(_timeTextStyle),
    );
    _systemTextStyle = chatConfig.systemTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextSecondary,
        fontSize: commonConfig.fontSizeCaption,
      ).merge(_systemTextStyle),
    );
    _quoteTitleTextStyle = chatConfig.quoteTitleTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeCaption,
        fontWeight: FontWeight.w600,
      ).merge(_quoteTitleTextStyle),
    );
    _quotePreviewTextStyle = chatConfig.quotePreviewTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextSecondary,
        fontSize: commonConfig.fontSizeCaption,
      ).merge(_quotePreviewTextStyle),
    );
    _inputTextStyle = chatConfig.inputTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_inputTextStyle),
    );
    _inputHintTextStyle = chatConfig.inputHintTextStyle.merge(
      SantoTextStyle(
        color: commonConfig.colorTextHint,
        fontSize: commonConfig.fontSizeBase,
      ).merge(_inputHintTextStyle),
    );
  }

  /// 合并配置,[other] 中的非空字段优先
  SantoChatConfig merge(SantoChatConfig? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other._backgroundColor,
      myBubbleColor: other._myBubbleColor,
      otherBubbleColor: other._otherBubbleColor,
      myTextStyle: other._myTextStyle,
      otherTextStyle: other._otherTextStyle,
      bubbleRadius: other._bubbleRadius,
      bubblePadding: other._bubblePadding,
      bubbleMaxWidthRatio: other._bubbleMaxWidthRatio,
      myAccentColor: other._myAccentColor,
      otherAccentColor: other._otherAccentColor,
      nameTextStyle: other._nameTextStyle,
      timeTextStyle: other._timeTextStyle,
      systemTextStyle: other._systemTextStyle,
      systemBackgroundColor: other._systemBackgroundColor,
      systemPadding: other._systemPadding,
      avatarSize: other._avatarSize,
      quoteBackgroundColor: other._quoteBackgroundColor,
      quoteTitleTextStyle: other._quoteTitleTextStyle,
      quotePreviewTextStyle: other._quotePreviewTextStyle,
      inputBackgroundColor: other._inputBackgroundColor,
      inputTextStyle: other._inputTextStyle,
      inputHintTextStyle: other._inputHintTextStyle,
      emojiSize: other._emojiSize,
    );
  }

  SantoChatConfig copyWith({
    Color? backgroundColor,
    Color? myBubbleColor,
    Color? otherBubbleColor,
    SantoTextStyle? myTextStyle,
    SantoTextStyle? otherTextStyle,
    double? bubbleRadius,
    EdgeInsets? bubblePadding,
    double? bubbleMaxWidthRatio,
    Color? myAccentColor,
    Color? otherAccentColor,
    SantoTextStyle? nameTextStyle,
    SantoTextStyle? timeTextStyle,
    SantoTextStyle? systemTextStyle,
    Color? systemBackgroundColor,
    EdgeInsets? systemPadding,
    double? avatarSize,
    Color? quoteBackgroundColor,
    SantoTextStyle? quoteTitleTextStyle,
    SantoTextStyle? quotePreviewTextStyle,
    Color? inputBackgroundColor,
    SantoTextStyle? inputTextStyle,
    SantoTextStyle? inputHintTextStyle,
    double? emojiSize,
  }) {
    return SantoChatConfig(
      backgroundColor: backgroundColor ?? _backgroundColor,
      myBubbleColor: myBubbleColor ?? _myBubbleColor,
      otherBubbleColor: otherBubbleColor ?? _otherBubbleColor,
      myTextStyle: myTextStyle ?? _myTextStyle,
      otherTextStyle: otherTextStyle ?? _otherTextStyle,
      bubbleRadius: bubbleRadius ?? _bubbleRadius,
      bubblePadding: bubblePadding ?? _bubblePadding,
      bubbleMaxWidthRatio: bubbleMaxWidthRatio ?? _bubbleMaxWidthRatio,
      myAccentColor: myAccentColor ?? _myAccentColor,
      otherAccentColor: otherAccentColor ?? _otherAccentColor,
      nameTextStyle: nameTextStyle ?? _nameTextStyle,
      timeTextStyle: timeTextStyle ?? _timeTextStyle,
      systemTextStyle: systemTextStyle ?? _systemTextStyle,
      systemBackgroundColor: systemBackgroundColor ?? _systemBackgroundColor,
      systemPadding: systemPadding ?? _systemPadding,
      avatarSize: avatarSize ?? _avatarSize,
      quoteBackgroundColor: quoteBackgroundColor ?? _quoteBackgroundColor,
      quoteTitleTextStyle: quoteTitleTextStyle ?? _quoteTitleTextStyle,
      quotePreviewTextStyle: quotePreviewTextStyle ?? _quotePreviewTextStyle,
      inputBackgroundColor: inputBackgroundColor ?? _inputBackgroundColor,
      inputTextStyle: inputTextStyle ?? _inputTextStyle,
      inputHintTextStyle: inputHintTextStyle ?? _inputHintTextStyle,
      emojiSize: emojiSize ?? _emojiSize,
    );
  }
}
