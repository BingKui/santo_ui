import 'package:santo_ui/src/components/navbar/santo_appbar_theme.dart';
import 'package:santo_ui/src/components/picker/base/santo_picker_constants.dart';
import 'package:santo_ui/src/constants/santo_asset_constants.dart';
import 'package:santo_ui/src/constants/santo_strings_constants.dart';
import 'package:santo_ui/src/theme/base/santo_text_style.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart'
    show SANTO_CONFIG_ID;
import 'package:santo_ui/src/theme/configs/santo_abnormal_state_config.dart';
import 'package:santo_ui/src/theme/configs/santo_action_sheet_config.dart';
import 'package:santo_ui/src/theme/configs/santo_all_config.dart';
import 'package:santo_ui/src/theme/configs/santo_appbar_config.dart';
import 'package:santo_ui/src/theme/configs/santo_button_config.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:santo_ui/src/theme/configs/santo_dialog_config.dart';
import 'package:santo_ui/src/theme/configs/santo_form_config.dart';
import 'package:santo_ui/src/theme/configs/santo_gallery_detail_config.dart';
import 'package:santo_ui/src/theme/configs/santo_enhance_number_card_config.dart';
import 'package:santo_ui/src/theme/configs/santo_pair_info_config.dart';
import 'package:santo_ui/src/theme/configs/santo_picker_config.dart';
import 'package:santo_ui/src/theme/configs/santo_selection_config.dart';
import 'package:santo_ui/src/theme/configs/santo_tabbar_config.dart';
import 'package:santo_ui/src/theme/configs/santo_panel_config.dart';
import 'package:santo_ui/src/theme/configs/santo_section_config.dart';
import 'package:santo_ui/src/theme/configs/santo_tag_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Santo默认配置
class SantoDefaultConfigUtils {
  const SantoDefaultConfigUtils._();

  /// 默认全局配置
  static SantoAllThemeConfig defaultAllConfig = SantoAllThemeConfig(
    commonConfig: defaultCommonConfig,
    formItemConfig: defaultFormItemConfig,
    dialogConfig: defaultDialogConfig,
    abnormalStateConfig: defaultAbnormalStateConfig,
    tagConfig: defaultTagConfig,
    appBarConfig: defaultAppBarConfig,
    pairInfoTableConfig: defaultPairInfoTableConfig,
    pairRichInfoGridConfig: defaultPairRichInfoGridConfig,
    buttonConfig: defaultButtonConfig,
    actionSheetConfig: defaultActionSheetConfig,
    pickerConfig: defaultPickerConfig,
    enhanceNumberCardConfig: defaultEnhanceNumberInfoConfig,
    tabBarConfig: defaultTabBarConfig,
    selectionConfig: defaultSelectionConfig,
    galleryDetailConfig: defaultGalleryDetailConfig,
    panelConfig: defaultPanelConfig,
    sectionConfig: defaultSectionConfig,
  );

  /// 面板配置
  static SantoPanelConfig defaultPanelConfig = SantoPanelConfig(
    contentPadding: const EdgeInsets.all(10),
    backgroundColor: Colors.white,
    radius: 12,
    headerHeight: 48,
    borderColor: const Color(0xFFDCDEE2),
    borderWidth: 0.5,
    showHeaderDivider: true,
    titleTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBase,
      fontSize: defaultCommonConfig.fontSizeSubHead,
      fontWeight: FontWeight.w500,
    ),
    descriptionTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextSecondary,
      fontSize: defaultCommonConfig.fontSizeCaption,
      fontWeight: FontWeight.w400,
    ),
  );

  /// 区块配置
  static SantoSectionConfig defaultSectionConfig = SantoSectionConfig(
    contentPadding: kSantoSectionContentPadding,
    footerPadding: kSantoSectionFooterPadding,
    backgroundColor: Colors.white,
    borderColor: kSantoSectionBorderColor,
    borderWidth: kSantoSectionBorderWidth,
    dividerColor: kSantoSectionDividerColor,
    titleTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBase,
      fontSize: defaultCommonConfig.fontSizeSubHead,
      fontWeight: FontWeight.w500,
    ),
    descriptionTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextSecondary,
      fontSize: defaultCommonConfig.fontSizeCaption,
      fontWeight: FontWeight.w400,
    ),
  );

  /// 全局默认配置
  /// 颜色/字号/间距对齐 DevOpsMobile lib/constants/constants.dart
  static SantoCommonConfig defaultCommonConfig = SantoCommonConfig(
    /// 主题色相关
    ///
    /// 主题色 iPrimary
    brandPrimary: const Color(0xFF1677FF),

    /// 主题色按下效果
    brandPrimaryTap: const Color(0x191677FF),

    /// 成功色 iSuccess
    brandSuccess: const Color(0xFF52C41A),

    /// 警告色 iWarn
    brandWarning: const Color(0xFFFAAD14),

    /// 失败色 iError
    brandError: const Color(0xFFFF4D4F),

    /// 重要-多用于红点色 iError
    brandImportant: const Color(0xFFFF4D4F),

    /// 重要数值色
    brandImportantValue: const Color(0xFFFF5722),

    /// 辅助色 iInfo
    brandAuxiliary: const Color(0xFF2DB7F5),

    /// 文本色相关
    ///
    /// 基础文字纯黑色 iTitleColor
    colorTextBase: const Color(0xFF17233D),

    /// 基础文字重要色 iContentColor
    colorTextImportant: const Color(0xFF515A6E),

    /// 基础文字-反色
    colorTextBaseInverse: const Color(0xFFFFFFFF),

    /// 辅助文字色 iSubTitleColor
    colorTextSecondary: const Color(0xFF808695),

    /// 失效或不可更改文字色 iDisableColor
    colorTextDisabled: const Color(0xFFC5C8CE),

    /// 文本框提示暗文文字色 iGray
    colorTextHint: const Color(0xFFCCCCCC),

    /// 跟随主题色[brandPrimary] iPrimary
    colorLink: const Color(0xFF1677FF),

    /// 背景色相关
    ///
    /// 组件背景色
    fillBase: const Color(0xFFFFFFFF),

    /// 页面背景色 iBackgroundColor
    fillBody: const Color(0xFFF5F5F5),

    /// 遮罩背景
    fillMask: const Color(0x99000000),

    /// 边框色 iBorderColor
    borderColorBase: const Color(0xFFDCDEE2),

    /// 分割线色 iDividerColor
    dividerColorBase: const Color(0xFFE8EAEC),

    /// 文本字号
    ///
    /// 特殊数据展示，Bebas 数字字体，用于强吸引
    fontSizeBebas: 28.0,

    /// 标题字体
    /// 名称/页面大标题
    fontSizeHeadLg: 22.0,

    /// 标题字体
    /// 内容模块标题/一级标题 iFontSizeLarger
    fontSizeHead: 18.0,

    /// 子标题字体
    /// 标题/录入文字/大按钮文字/二级标题 iFontSizeMiddle
    fontSizeSubHead: 16.0,

    /// 基础字体
    /// 内容副文本/普通说明文字 iFontSize
    fontSizeBase: 14.0,

    /// 辅助字体-普通 iFontSizeSmall
    fontSizeCaption: 12.0,

    ///辅助字体-小 iFontSizeMini
    fontSizeCaptionSm: 10.0,

    /// 圆角尺寸 iRadius，统一 12
    radiusXs: 12.0,
    radiusSm: 12.0,
    radiusMd: 12.0,
    radiusLg: 12.0,

    /// 边框尺寸
    borderWidthSm: 0.5,
    borderWidthMd: 1.0,
    borderWidthLg: 2.0,

    /// 水平间距 iDefaultGap 梯度 5/10/15/20/40
    hSpacingXs: 5.0,
    hSpacingSm: 10.0,
    hSpacingMd: 15.0,
    hSpacingLg: 20.0,
    hSpacingXl: 20.0,
    hSpacingXxl: 40.0,

    /// 垂直间距 iDefaultGap 梯度 5/10/15/20/40
    vSpacingXs: 5.0,
    vSpacingSm: 10.0,
    vSpacingMd: 15.0,
    vSpacingLg: 20.0,
    vSpacingXl: 20.0,
    vSpacingXxl: 40.0,

    /// 页面左右/区块间距 iPageGap
    pageGap: kSantoPageGap,

    /// 图标大小
    iconSizeXxs: 8.0,
    iconSizeXs: 12.0,
    iconSizeSm: 14.0,
    iconSizeMd: 16.0,
    iconSizeLg: 32.0,
  );

  ///******** 以下是子配置项 ********///

  /// 表单项默认配置
  static SantoFormItemConfig defaultFormItemConfig = SantoFormItemConfig(
    backgroundColor: Colors.white,
    headTitleTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBase,
      fontSize: defaultCommonConfig.fontSizeHead,
    ),
    titleTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBase,
      fontSize: defaultCommonConfig.fontSizeSubHead,
    ),
    subTitleTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextSecondary,
      fontSize: defaultCommonConfig.fontSizeCaption,
    ),
    errorTextStyle: SantoTextStyle(
      color: defaultCommonConfig.brandError,
      fontSize: defaultCommonConfig.fontSizeCaption,
    ),
    hintTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextHint,
      fontSize: defaultCommonConfig.fontSizeSubHead,
    ),
    contentTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBase,
      fontSize: defaultCommonConfig.fontSizeSubHead,
    ),
    optionsMiddlePadding: EdgeInsets.only(
      left: defaultCommonConfig.hSpacingMd,
    ),
    optionTextStyle: SantoTextStyle(
      height: 1.3,
      color: defaultCommonConfig.colorTextBase,
      fontSize: defaultCommonConfig.fontSizeSubHead,
    ),
    optionSelectedTextStyle: SantoTextStyle(
      height: 1.3,
      color: defaultCommonConfig.brandPrimary,
      fontSize: defaultCommonConfig.fontSizeSubHead,
    ),
    formPadding: EdgeInsets.only(
      left: 0.0,
      top: defaultCommonConfig.vSpacingLg,
      right: defaultCommonConfig.hSpacingLg,
      bottom: defaultCommonConfig.vSpacingLg,
    ),
    titlePaddingSm: EdgeInsets.only(left: 10),
    titlePaddingLg: EdgeInsets.only(left: defaultCommonConfig.hSpacingLg),
    subTitlePadding: EdgeInsets.only(
      left: defaultCommonConfig.hSpacingLg,
      top: defaultCommonConfig.vSpacingXs,
    ),
    errorPadding: EdgeInsets.only(
      left: defaultCommonConfig.hSpacingLg,
      top: defaultCommonConfig.vSpacingXs,
    ),
    disableTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextDisabled,
      fontSize: defaultCommonConfig.fontSizeSubHead,
    ),
    tipsTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextSecondary,
      fontSize: defaultCommonConfig.fontSizeBase,
    ),
  );

  /// Dialog默认配置
  static SantoDialogConfig defaultDialogConfig = SantoDialogConfig(
    dialogWidth: 300.0,
    radius: defaultCommonConfig.radiusLg,
    iconPadding: EdgeInsets.only(top: defaultCommonConfig.vSpacingXxl),
    titlePaddingSm: EdgeInsets.only(
      top: 12.0,
      left: defaultCommonConfig.hSpacingXxl,
      right: defaultCommonConfig.hSpacingXxl,
    ),
    titlePaddingLg: EdgeInsets.only(
      top: 25.0,
      left: defaultCommonConfig.hSpacingXxl,
      right: defaultCommonConfig.hSpacingXxl,
    ),
    titleTextStyle: SantoTextStyle(
      fontWeight: FontWeight.w500,
      fontSize: defaultCommonConfig.fontSizeHead,
      color: defaultCommonConfig.colorTextBase,
    ),
    titleTextAlign: TextAlign.center,
    contentPaddingSm: EdgeInsets.only(
      top: 8.0,
      left: defaultCommonConfig.hSpacingXl,
      right: defaultCommonConfig.hSpacingXl,
    ),
    contentPaddingLg: EdgeInsets.only(
      top: 25.0,
      left: defaultCommonConfig.hSpacingXl,
      right: defaultCommonConfig.hSpacingXl,
    ),
    contentTextStyle: SantoTextStyle(
      fontSize: defaultCommonConfig.fontSizeBase,
      color: defaultCommonConfig.colorTextImportant,
      decoration: TextDecoration.none,
    ),
    contentTextAlign: TextAlign.center,
    warningPaddingSm: EdgeInsets.only(
      top: 6.0,
      left: defaultCommonConfig.hSpacingXl,
      right: defaultCommonConfig.hSpacingXl,
    ),
    warningPaddingLg: EdgeInsets.only(
      top: 25.0,
      left: defaultCommonConfig.hSpacingXl,
      right: defaultCommonConfig.hSpacingXl,
    ),
    warningTextAlign: TextAlign.center,
    warningTextStyle: SantoTextStyle(
      fontSize: defaultCommonConfig.fontSizeBase,
      color: defaultCommonConfig.brandError,
      decoration: TextDecoration.none,
    ),
    dividerPadding: EdgeInsets.only(top: 25.0),
    backgroundColor: defaultCommonConfig.fillBase,
  );

  /// 空页面配置
  static SantoAbnormalStateConfig defaultAbnormalStateConfig =
      SantoAbnormalStateConfig(
    titleTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBase,
      fontSize: defaultCommonConfig.fontSizeSubHead,
      fontWeight: FontWeight.w500,
    ),
    contentTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextHint,
      fontSize: defaultCommonConfig.fontSizeBase,
    ),
    operateTextStyle: SantoTextStyle(
      color: defaultCommonConfig.brandPrimary,
      fontSize: defaultCommonConfig.fontSizeBase,
    ),
    btnRadius: 12,
    doubleTextStyle: SantoTextStyle(
      color: defaultCommonConfig.brandPrimary,
      fontSize: defaultCommonConfig.fontSizeSubHead,
    ),
    singleTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBaseInverse,
      fontSize: defaultCommonConfig.fontSizeSubHead,
    ),
    singleMinWidth: 160.0,
    doubleMinWidth: 120.0,
  );

  /// 标签配置
  static SantoTagConfig defaultTagConfig = SantoTagConfig(
    tagTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBase,
      fontSize: defaultCommonConfig.fontSizeCaption,
    ),
    selectTagTextStyle: SantoTextStyle(
      fontWeight: FontWeight.w500,
      color: defaultCommonConfig.brandPrimary,
      fontSize: defaultCommonConfig.fontSizeCaption,
    ),
    tagBackgroundColor: defaultCommonConfig.fillBody,
    selectedTagBackgroundColor: defaultCommonConfig.brandPrimary,
    tagRadius: defaultCommonConfig.radiusXs,
    tagHeight: 34.0,
    tagWidth: 75.0,
    tagMinWidth: 75.0,
  );

  /// 导航栏配置
  static SantoAppBarConfig defaultAppBarConfig = SantoAppBarConfig(
    backgroundColor: Colors.white,
    appBarHeight: SantoAppBarTheme.appBarHeight,
    leadIconBuilder: () => Image.asset(
      SantoAsset.iconBackBlack,
      package: SantoStrings.flutterPackageName,
      width: SantoAppBarTheme.iconSize,
      height: SantoAppBarTheme.iconSize,
      fit: BoxFit.fitHeight,
    ),
    titleStyle: SantoTextStyle(
      fontSize: SantoAppBarTheme.titleFontSize,
      fontWeight: FontWeight.w500,
      color: SantoAppBarTheme.lightTextColor,
    ),
    actionsStyle: SantoTextStyle(
      color: SantoAppBarTheme.lightTextColor,
      fontSize: SantoAppBarTheme.actionFontSize,
      fontWeight: FontWeight.w500,
    ),
    titleMaxLength: SantoAppBarTheme.maxLength,
    leftAndRightPadding: 20.0,
    itemSpacing: SantoAppBarTheme.iconMargin,
    titlePadding: EdgeInsets.zero,
    iconSize: SantoAppBarTheme.iconSize,
    configId: SANTO_CONFIG_ID,
    systemUiOverlayStyle: SystemUiOverlayStyle.dark,
    showDefaultBottom: false,
  );

  /// 内容信息（两列）配置
  static SantoPairInfoTableConfig defaultPairInfoTableConfig =
      SantoPairInfoTableConfig(
    rowSpacing: 4,
    itemSpacing: 2,
    keyTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextSecondary,
      fontSize: defaultCommonConfig.fontSizeBase,
    ),
    valueTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBase,
      fontSize: defaultCommonConfig.fontSizeBase,
    ),
    linkTextStyle: SantoTextStyle(
      color: defaultCommonConfig.brandPrimary,
      fontSize: defaultCommonConfig.fontSizeBase,
    ),
    configId: SANTO_CONFIG_ID,
  );

  /// 内容信息（一列）配置
  static SantoPairRichInfoGridConfig defaultPairRichInfoGridConfig =
      SantoPairRichInfoGridConfig(
    rowSpacing: 4.0,
    itemSpacing: 2.0,
    itemHeight: 20.0,
    keyTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextSecondary,
      fontSize: defaultCommonConfig.fontSizeBase,
      textBaseline: TextBaseline.ideographic,
    ),
    valueTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBase,
      fontSize: defaultCommonConfig.fontSizeBase,
      textBaseline: TextBaseline.ideographic,
    ),
    linkTextStyle: SantoTextStyle(
      color: defaultCommonConfig.brandPrimary,
      fontSize: defaultCommonConfig.fontSizeBase,
      textBaseline: TextBaseline.ideographic,
    ),
    configId: SANTO_CONFIG_ID,
  );

  /// 按钮配置
  static SantoButtonConfig defaultButtonConfig = SantoButtonConfig(
    bigButtonRadius: 12.0,
    bigButtonHeight: 48.0,
    bigButtonFontSize: 16.0,
    smallButtonRadius: 12.0,
    smallButtonHeight: 32.0,
    smallButtonFontSize: 14.0,
    configId: SANTO_CONFIG_ID,
  );

  static SantoActionSheetConfig defaultActionSheetConfig = SantoActionSheetConfig(
    topRadius: defaultCommonConfig.radiusLg,
    titleStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextSecondary,
      fontSize: defaultCommonConfig.fontSizeBase,
    ),
    itemTitleStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBase,
      fontSize: defaultCommonConfig.fontSizeSubHead,
      fontWeight: FontWeight.w500,
    ),
    itemTitleStyleLink: SantoTextStyle(
      fontSize: defaultCommonConfig.fontSizeSubHead,
      fontWeight: FontWeight.w500,
      color: defaultCommonConfig.colorLink,
    ),
    itemTitleStyleAlert: SantoTextStyle(
      color: defaultCommonConfig.brandError,
      fontSize: defaultCommonConfig.fontSizeSubHead,
      fontWeight: FontWeight.w500,
    ),
    itemDescStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBase,
      fontSize: defaultCommonConfig.fontSizeCaption,
      fontWeight: FontWeight.w500,
    ),
    itemDescStyleLink: SantoTextStyle(
      color: defaultCommonConfig.colorLink,
      fontSize: defaultCommonConfig.fontSizeCaption,
      fontWeight: FontWeight.w500,
    ),
    itemDescStyleAlert: SantoTextStyle(
      color: defaultCommonConfig.brandError,
      fontSize: defaultCommonConfig.fontSizeCaption,
      fontWeight: FontWeight.w500,
    ),
    cancelStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBase,
      fontSize: defaultCommonConfig.fontSizeSubHead,
      fontWeight: FontWeight.w500,
    ),
    titlePadding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 12.0),
    contentPadding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 12.0),
  );

  static SantoPickerConfig defaultPickerConfig = SantoPickerConfig(
    backgroundColor: pickerBackgroundColor,
    cancelTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBase,
      fontSize: defaultCommonConfig.fontSizeSubHead,
    ),
    confirmTextStyle: SantoTextStyle(
      color: defaultCommonConfig.brandPrimary,
      fontSize: defaultCommonConfig.fontSizeSubHead,
    ),
    titleTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBase,
      fontSize: defaultCommonConfig.fontSizeSubHead,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none,
    ),
    pickerHeight: pickerHeight,
    titleHeight: pickerTitleHeight,
    itemHeight: pickerItemHeight,
    dividerColor: Color(0xFFE8EAEC),
    itemTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBase,
      fontSize: defaultCommonConfig.fontSizeHead,
    ),
    itemTextSelectedStyle: SantoTextStyle(
      color: defaultCommonConfig.brandPrimary,
      fontSize: defaultCommonConfig.fontSizeHead,
      fontWeight: FontWeight.w500,
    ),
    cornerRadius: 8,
  );

  /// 数字增强信息配置
  static SantoEnhanceNumberCardConfig defaultEnhanceNumberInfoConfig =
      SantoEnhanceNumberCardConfig(
    runningSpace: 16.0,
    itemRunningSpace: 8.0,
    titleTextStyle: SantoTextStyle(fontSize: 28.0, fontWeight: FontWeight.w500),
    descTextStyle: SantoTextStyle(
      fontSize: 12.0,
      color: defaultCommonConfig.colorTextSecondary,
    ),
    dividerWidth: 0.5,
  );

  /// TabBar配置
  static SantoTabBarConfig defaultTabBarConfig = SantoTabBarConfig(
    backgroundColor: Colors.white,
    tabHeight: 50.0,
    indicatorHeight: 2.0,
    indicatorWidth: 24.0,
    labelStyle: SantoTextStyle(
      color: defaultCommonConfig.brandPrimary,
      fontSize: defaultCommonConfig.fontSizeSubHead,
      fontWeight: FontWeight.w500,
    ),
    unselectedLabelStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBase,
      fontSize: defaultCommonConfig.fontSizeSubHead,
      fontWeight: FontWeight.normal,
    ),
    tagRadius: defaultCommonConfig.radiusSm,
    tagNormalTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBase,
      fontSize: defaultCommonConfig.fontSizeCaption,
    ),
    tagNormalBgColor: defaultCommonConfig.fillBody,
    tagSelectedTextStyle: SantoTextStyle(
      color: defaultCommonConfig.brandPrimary,
      fontSize: defaultCommonConfig.fontSizeCaption,
    ),
    tagSelectedBgColor: defaultCommonConfig.brandPrimary.withAlpha(0x14),
    tagSpacing: 12.0,
    preLineTagCount: 4,
    tagHeight: 32.0,
  );

  /// 筛选项配置
  static SantoSelectionConfig defaultSelectionConfig = SantoSelectionConfig(
    menuNormalTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBase,
      fontSize: defaultCommonConfig.fontSizeBase,
    ),
    menuSelectedTextStyle: SantoTextStyle(
      fontWeight: FontWeight.w500,
      fontSize: defaultCommonConfig.fontSizeBase,
      color: defaultCommonConfig.brandPrimary,
    ),
    tagNormalTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBase,
      fontSize: defaultCommonConfig.fontSizeCaption,
    ),
    tagSelectedTextStyle: SantoTextStyle(
      color: defaultCommonConfig.brandPrimary,
      fontSize: defaultCommonConfig.fontSizeCaption,
      fontWeight: FontWeight.w500,
    ),
    tagRadius: defaultCommonConfig.radiusSm,
    tagNormalBackgroundColor: defaultCommonConfig.fillBody,
    tagSelectedBackgroundColor:
        defaultCommonConfig.brandPrimary.withOpacity(0.12),
    rangeTitleTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBase,
      fontSize: defaultCommonConfig.fontSizeSubHead,
      fontWeight: FontWeight.w500,
    ),
    hintTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextHint,
      fontSize: defaultCommonConfig.fontSizeBase,
    ),
    inputTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBase,
      fontSize: defaultCommonConfig.fontSizeBase,
    ),
    itemNormalTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBase,
      fontSize: defaultCommonConfig.fontSizeBase,
    ),
    itemSelectedTextStyle: SantoTextStyle(
      color: defaultCommonConfig.brandPrimary,
      fontSize: defaultCommonConfig.fontSizeBase,
      fontWeight: FontWeight.w500,
    ),
    itemBoldTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBase,
      fontSize: defaultCommonConfig.fontSizeBase,
      fontWeight: FontWeight.w500,
    ),
    lightSelectBgColor: Colors.white,
    lightNormalBgColor: Colors.white,
    middleSelectBgColor: Colors.white,
    middleNormalBgColor: Color(0xFFF5F5F5),
    deepSelectBgColor: Color(0xFFF5F5F5),
    deepNormalBgColor: Color(0xFFE8EAEC),
    resetTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextImportant,
      fontSize: defaultCommonConfig.fontSizeCaption,
    ),
    titleForMoreTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBase,
      fontSize: defaultCommonConfig.fontSizeBase,
      fontWeight: FontWeight.w500,
    ),
    optionTextStyle: SantoTextStyle(
      color: defaultCommonConfig.brandPrimary,
      fontSize: defaultCommonConfig.fontSizeBase,
    ),
    moreTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextSecondary,
      fontSize: defaultCommonConfig.fontSizeCaption,
    ),
    flayerNormalTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBase,
      fontSize: defaultCommonConfig.fontSizeSubHead,
    ),
    flayerSelectedTextStyle: SantoTextStyle(
      color: defaultCommonConfig.brandPrimary,
      fontSize: defaultCommonConfig.fontSizeSubHead,
      fontWeight: FontWeight.w500,
    ),
    flayerBoldTextStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBase,
      fontSize: defaultCommonConfig.fontSizeSubHead,
      fontWeight: FontWeight.w500,
    ),
  );

  /// 查看图片配置
  static SantoGalleryDetailConfig defaultGalleryDetailConfig =
      SantoGalleryDetailConfig(
    appbarTitleStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBaseInverse,
      fontSize: defaultCommonConfig.fontSizeSubHead,
      fontWeight: FontWeight.w500,
    ),
    appbarActionStyle: SantoTextStyle(
      color: SantoAppBarTheme.lightTextColor,
      fontSize: SantoAppBarTheme.actionFontSize,
      fontWeight: FontWeight.w500,
    ),
    appbarBackgroundColor: Colors.black,
    appbarConfig: SantoAppBarConfig.dark(),
    tabBarUnSelectedLabelStyle: SantoTextStyle(
      fontSize: 16.0,
      color: Color(0XFFCCCCCC),
    ),
    tabBarLabelStyle: SantoTextStyle(
      fontSize: defaultCommonConfig.fontSizeSubHead,
      fontWeight: FontWeight.w500,
      color: defaultCommonConfig.colorTextBaseInverse,
    ),
    tabBarBackgroundColor: Colors.black,
    pageBackgroundColor: Colors.black,
    bottomBackgroundColor: Color(0X88000000),
    titleStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBaseInverse,
      fontSize: defaultCommonConfig.fontSizeHead,
      fontWeight: FontWeight.w500,
    ),
    contentStyle: SantoTextStyle(
      color: Color(0xFFCCCCCC),
      fontSize: defaultCommonConfig.fontSizeBase,
    ),
    actionStyle: SantoTextStyle(
      color: defaultCommonConfig.colorTextBaseInverse,
      fontSize: defaultCommonConfig.fontSizeBase,
    ),
    iconColor: Colors.white,
  );
}
