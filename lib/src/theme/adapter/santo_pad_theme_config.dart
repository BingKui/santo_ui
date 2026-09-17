import 'package:santo_ui/src/theme/base/santo_text_style.dart';
import 'package:flutter/material.dart';

import '../configs/santo_all_config.dart';
import '../configs/santo_appbar_config.dart';
import '../configs/santo_button_config.dart';
import '../configs/santo_common_config.dart';
import '../configs/santo_dialog_config.dart';
import '../configs/santo_enhance_number_card_config.dart';
import '../configs/santo_form_config.dart';
import '../configs/santo_pair_info_config.dart';
import '../configs/santo_tag_config.dart';

/// Pad 主题配置
class SantoPadThemeConfig {
  ///  默认全局配置
  static SantoAllThemeConfig allConfig = SantoAllThemeConfig(
      commonConfig: commonConfig,
      formItemConfig: formItemConfig,
      dialogConfig: dialogConfig,
      appBarConfig: appbarConfig,
      pairInfoTableConfig: metaPairInfoTableConfig,
      pairRichInfoGridConfig: metaPairRichInfoGridConfig,
      buttonConfig: buttonConfig,
      enhanceNumberCardConfig: numberInfoConfig,
      tagConfig: tagConfig);

  /// 全局默认配置
  /// 颜色对齐 DevOpsMobile lib/constants/constants.dart,仅字号/间距为 Pad 放大档位
  static SantoCommonConfig commonConfig = SantoCommonConfig(
    /// 主题色相关
    brandPrimary: const Color(0xFF1677FF),
    brandPrimaryTap: const Color(0x191677FF),
    brandSuccess: const Color(0xFF52C41A),
    brandWarning: const Color(0xFFFAAD14),
    brandError: const Color(0xFFFF4D4F),
    brandImportant: const Color(0xFFFF4D4F),
    brandImportantValue: const Color(0xFFFF5722),

    colorTextBase: const Color(0xFF17233D),

    colorTextImportant: const Color(0xFF515A6E),

    colorTextBaseInverse: const Color(0xFFFFFFFF),

    colorTextSecondary: const Color(0xFF808695),

    colorTextDisabled: const Color(0xFFC5C8CE),

    colorTextHint: const Color(0xFFCCCCCC),

    colorLink: const Color(0xFF1677FF),

    borderColorBase: const Color(0xFFDCDEE2),

    dividerColorBase: const Color(0xFFE8EAEC),

    fillBase: const Color(0xFFFFFFFF),
    fillBody: const Color(0xFFF5F5F5),
    fillMask: const Color(0x99000000),
    fontSizeBebas: 18,
    fontSizeHeadLg: 28,
    fontSizeHead: 22,
    fontSizeSubHead: 18,
    fontSizeBase: 16,
    fontSizeCaption: 14,
    fontSizeCaptionSm: 14,

    radiusXs: 12.0,
    radiusSm: 12.0,
    radiusMd: 12.0,
    radiusLg: 12.0,
    borderWidthSm: 0.5,
    borderWidthMd: 1,
    borderWidthLg: 2,

    hSpacingXs: 8,
    hSpacingSm: 12,
    hSpacingMd: 16,
    hSpacingLg: 20,
    hSpacingXl: 24,
    hSpacingXxl: 42,

    vSpacingXs: 4,
    vSpacingSm: 8,
    vSpacingMd: 12,
    vSpacingLg: 14,
    vSpacingXl: 16,
    vSpacingXxl: 28,

    pageGap: 16,

    iconSizeXxs: 8,
    iconSizeXs: 12,
    iconSizeSm: 14,
    iconSizeMd: 16,
    iconSizeLg: 32,
  );

  ///******** 以下是子配置项 ********///

  /// tagView 默认配置
  static SantoTagConfig tagConfig = SantoTagConfig(
      tagRadius: 12,
      tagMinWidth: 110,
      tagTextStyle: SantoTextStyle(fontSize: 12, fontWeight: FontWeight.w500));

  /// 数字信息展示默认配置
  static SantoEnhanceNumberCardConfig numberInfoConfig =
      SantoEnhanceNumberCardConfig(
    itemRunningSpace: 0,
    titleTextStyle: SantoTextStyle(fontSize: 32),
    descTextStyle: SantoTextStyle(fontSize: 16),
  );

  /// 表单项默认配置
  static SantoFormItemConfig formItemConfig = SantoFormItemConfig(
      subTitleTextStyle: SantoTextStyle(fontSize: 14),
      optionsMiddlePadding: EdgeInsets.only(left: 20),
      errorTextStyle: SantoTextStyle(fontSize: 14));

  /// Dialog默认配置
  static SantoDialogConfig dialogConfig = SantoDialogConfig(
    dialogWidth: 420,
    radius: 12.0,
    titleTextStyle: SantoTextStyle(fontSize: 22),
    titlePaddingSm: EdgeInsets.only(top: 14, left: 32, right: 32),
    titlePaddingLg: EdgeInsets.only(top: 28, left: 32, right: 32),
    contentTextStyle: SantoTextStyle(fontSize: 16),
    contentPaddingSm: EdgeInsets.only(top: 14, left: 32, right: 32),
    contentPaddingLg: EdgeInsets.only(top: 28, left: 32, right: 32),
  );

  static SantoAppBarConfig appbarConfig = SantoAppBarConfig(
    appBarHeight: 57,
    leftAndRightPadding: 24,
    itemSpacing: 24,
    titleMaxLength: 20,
    titleStyle: SantoTextStyle(
        color: Color(0xFF17233D), fontWeight: FontWeight.w500, fontSize: 24),
    actionsStyle: SantoTextStyle(
        color: Color(0xFF1677FF), fontWeight: FontWeight.w500, fontSize: 18),
  );

  static SantoButtonConfig buttonConfig = SantoButtonConfig(
      bigButtonRadius: 12,
      bigButtonHeight: 50,
      bigButtonFontSize: 18,
      smallButtonRadius: 12,
      smallButtonFontSize: 14,
      smallButtonHeight: 36);

  static SantoPairInfoTableConfig metaPairInfoTableConfig =
      SantoPairInfoTableConfig(
          rowSpacing: 6,
          itemSpacing: 8,
          valueTextStyle:
              SantoTextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          keyTextStyle: SantoTextStyle(fontSize: 16),
          linkTextStyle: SantoTextStyle(fontSize: 16));

  static SantoPairRichInfoGridConfig metaPairRichInfoGridConfig =
      SantoPairRichInfoGridConfig(
          rowSpacing: 6,
          itemSpacing: 4,
          valueTextStyle:
              SantoTextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          keyTextStyle: SantoTextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          linkTextStyle: SantoTextStyle(fontSize: 16));
}
