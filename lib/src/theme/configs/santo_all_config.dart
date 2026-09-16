import 'package:santo_ui/src/theme/base/santo_default_config_utils.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_abnormal_state_config.dart';
import 'package:santo_ui/src/theme/configs/santo_action_sheet_config.dart';
import 'package:santo_ui/src/theme/configs/santo_appbar_config.dart';
import 'package:santo_ui/src/theme/configs/santo_button_config.dart';
import 'package:santo_ui/src/theme/configs/santo_card_title_config.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:santo_ui/src/theme/configs/santo_dialog_config.dart';
import 'package:santo_ui/src/theme/configs/santo_enhance_number_card_config.dart';
import 'package:santo_ui/src/theme/configs/santo_form_config.dart';
import 'package:santo_ui/src/theme/configs/santo_gallery_detail_config.dart';
import 'package:santo_ui/src/theme/configs/santo_pair_info_config.dart';
import 'package:santo_ui/src/theme/configs/santo_picker_config.dart';
import 'package:santo_ui/src/theme/configs/santo_selection_config.dart';
import 'package:santo_ui/src/theme/configs/santo_tabbar_config.dart';
import 'package:santo_ui/src/theme/configs/santo_panel_config.dart';
import 'package:santo_ui/src/theme/configs/santo_section_config.dart';
import 'package:santo_ui/src/theme/configs/santo_tag_config.dart';

/// 描述: 全局配置
///
/// 当用户使用时对单个组件自定义配置，优先走单个组件特定配置（作用范围档次使用）
/// 当用户配置组件通用配置时如 [SantoDialogConfig] 优先使用该配置
/// 若没有配置组件通用配置，走 [SantoCommonConfig] 全局配置
/// 如果以上都没有配置走 Santo 默认配置，即 [SantoDefaultConfigUtils] 中的配置
/// 当没有配置组件的特定属性时使用上一级特定配置
class SantoAllThemeConfig {
  SantoAllThemeConfig({
    SantoCommonConfig? commonConfig,
    SantoAppBarConfig? appBarConfig,
    SantoButtonConfig? buttonConfig,
    SantoDialogConfig? dialogConfig,
    SantoFormItemConfig? formItemConfig,
    SantoCardTitleConfig? cardTitleConfig,
    SantoAbnormalStateConfig? abnormalStateConfig,
    SantoTagConfig? tagConfig,
    SantoPairInfoTableConfig? pairInfoTableConfig,
    SantoPairRichInfoGridConfig? pairRichInfoGridConfig,
    SantoActionSheetConfig? actionSheetConfig,
    SantoPickerConfig? pickerConfig,
    SantoEnhanceNumberCardConfig? enhanceNumberCardConfig,
    SantoTabBarConfig? tabBarConfig,
    SantoSelectionConfig? selectionConfig,
    SantoGalleryDetailConfig? galleryDetailConfig,
    SantoPanelConfig? panelConfig,
    SantoSectionConfig? sectionConfig,
    String configId = GLOBAL_CONFIG_ID,
  })  : _commonConfig = commonConfig,
        _appBarConfig = appBarConfig,
        _buttonConfig = buttonConfig,
        _dialogConfig = dialogConfig,
        _formItemConfig = formItemConfig,
        _cardTitleConfig = cardTitleConfig,
        _abnormalStateConfig = abnormalStateConfig,
        _tagConfig = tagConfig,
        _pairInfoTableConfig = pairInfoTableConfig,
        _pairRichInfoGridConfig = pairRichInfoGridConfig,
        _actionSheetConfig = actionSheetConfig,
        _pickerConfig = pickerConfig,
        _enhanceNumberCardConfig = enhanceNumberCardConfig,
        _tabBarConfig = tabBarConfig,
        _selectionConfig = selectionConfig,
        _galleryDetailConfig = galleryDetailConfig,
        _panelConfig = panelConfig,
        _sectionConfig = sectionConfig;

  SantoCommonConfig? _commonConfig;

  SantoCommonConfig get commonConfig =>
      _commonConfig ?? SantoDefaultConfigUtils.defaultCommonConfig;

  SantoAppBarConfig? _appBarConfig;

  SantoAppBarConfig get appBarConfig =>
      _appBarConfig ?? SantoDefaultConfigUtils.defaultAppBarConfig;

  SantoButtonConfig? _buttonConfig;

  SantoButtonConfig get buttonConfig =>
      _buttonConfig ?? SantoDefaultConfigUtils.defaultButtonConfig;

  SantoDialogConfig? _dialogConfig;

  SantoDialogConfig get dialogConfig =>
      _dialogConfig ?? SantoDefaultConfigUtils.defaultDialogConfig;

  SantoCardTitleConfig? _cardTitleConfig;

  SantoCardTitleConfig get cardTitleConfig =>
      _cardTitleConfig ?? SantoDefaultConfigUtils.defaultCardTitleConfig;

  SantoAbnormalStateConfig? _abnormalStateConfig;

  SantoAbnormalStateConfig get abnormalStateConfig =>
      _abnormalStateConfig ?? SantoDefaultConfigUtils.defaultAbnormalStateConfig;

  SantoTagConfig? _tagConfig;

  SantoTagConfig get tagConfig =>
      _tagConfig ?? SantoDefaultConfigUtils.defaultTagConfig;

  SantoPairInfoTableConfig? _pairInfoTableConfig;

  SantoPairInfoTableConfig get pairInfoTableConfig =>
      _pairInfoTableConfig ?? SantoDefaultConfigUtils.defaultPairInfoTableConfig;

  SantoPairRichInfoGridConfig? _pairRichInfoGridConfig;

  SantoPairRichInfoGridConfig get pairRichInfoGridConfig =>
      _pairRichInfoGridConfig ??
      SantoDefaultConfigUtils.defaultPairRichInfoGridConfig;

  SantoActionSheetConfig? _actionSheetConfig;

  SantoActionSheetConfig get actionSheetConfig =>
      _actionSheetConfig ?? SantoDefaultConfigUtils.defaultActionSheetConfig;

  SantoPickerConfig? _pickerConfig;

  SantoPickerConfig get pickerConfig =>
      _pickerConfig ?? SantoDefaultConfigUtils.defaultPickerConfig;

  SantoEnhanceNumberCardConfig? _enhanceNumberCardConfig;

  SantoEnhanceNumberCardConfig get enhanceNumberCardConfig =>
      _enhanceNumberCardConfig ??
      SantoDefaultConfigUtils.defaultEnhanceNumberInfoConfig;

  SantoTabBarConfig? _tabBarConfig;

  SantoTabBarConfig get tabBarConfig =>
      _tabBarConfig ?? SantoDefaultConfigUtils.defaultTabBarConfig;

  SantoFormItemConfig? _formItemConfig;

  SantoFormItemConfig get formItemConfig =>
      _formItemConfig ?? SantoDefaultConfigUtils.defaultFormItemConfig;

  SantoSelectionConfig? _selectionConfig;

  SantoSelectionConfig get selectionConfig =>
      _selectionConfig ?? SantoDefaultConfigUtils.defaultSelectionConfig;

  SantoGalleryDetailConfig? _galleryDetailConfig;

  SantoGalleryDetailConfig get galleryDetailConfig =>
      _galleryDetailConfig ?? SantoDefaultConfigUtils.defaultGalleryDetailConfig;

  SantoPanelConfig? _panelConfig;

  SantoPanelConfig get panelConfig =>
      _panelConfig ?? SantoDefaultConfigUtils.defaultPanelConfig;

  SantoSectionConfig? _sectionConfig;

  SantoSectionConfig get sectionConfig =>
      _sectionConfig ?? SantoDefaultConfigUtils.defaultSectionConfig;

  void initThemeConfig(String configId) {
    this._commonConfig ??= SantoCommonConfig();
    this._appBarConfig ??= SantoAppBarConfig();
    this._buttonConfig ??= SantoButtonConfig();
    this._dialogConfig ??= SantoDialogConfig();
    this._formItemConfig ??= SantoFormItemConfig();
    this._cardTitleConfig ??= SantoCardTitleConfig();
    this._abnormalStateConfig ??= SantoAbnormalStateConfig();
    this._tagConfig ??= SantoTagConfig();
    this._appBarConfig ??= SantoAppBarConfig();
    this._pairInfoTableConfig ??= SantoPairInfoTableConfig();
    this._pairRichInfoGridConfig ??= SantoPairRichInfoGridConfig();
    this._actionSheetConfig ??= SantoActionSheetConfig();
    this._pickerConfig ??= SantoPickerConfig();
    this._enhanceNumberCardConfig ??= SantoEnhanceNumberCardConfig();
    this._tabBarConfig ??= SantoTabBarConfig();
    this._selectionConfig ??= SantoSelectionConfig();
    this._galleryDetailConfig ??= SantoGalleryDetailConfig();
    this._panelConfig ??= SantoPanelConfig();
    this._sectionConfig ??= SantoSectionConfig();

    commonConfig.initThemeConfig(configId);
    appBarConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    buttonConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    dialogConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    formItemConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    cardTitleConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    abnormalStateConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    tagConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    pairInfoTableConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    pairRichInfoGridConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    selectionConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    actionSheetConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    pickerConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    enhanceNumberCardConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    tabBarConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    galleryDetailConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    panelConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
    sectionConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
  }
}
