

import 'package:santo_ui/src/components/form/base/santo_form_item_type.dart';
import 'package:santo_ui/src/components/form/base/input_item_interface.dart';
import 'package:santo_ui/src/components/icon/santo_icon.dart';
import 'package:santo_ui/src/components/icon/santo_icons.dart';
import 'package:santo_ui/src/theme/santo_theme.dart';
import 'package:flutter/widgets.dart';

///
/// UI配置相关
///
class SantoFormUtil {
  /// 获取添加、删除图标
  static Widget buildPrefixIcon(String prefixIconType, bool isEdit,
      BuildContext context, VoidCallback? onAddTap, VoidCallback? onRemoveTap) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Offstage(
      offstage: prefixIconType == SantoPrefixIconType.normal,
      child: Container(
        padding: EdgeInsets.only(right: commonConfig.hSpacingXs),
        child: GestureDetector(
          onTap: () {
            if (!SantoFormUtil.isEdit(isEdit)) {
              return;
            }

            SantoFormUtil.notifyAddRemoveTap(
                context, prefixIconType, onAddTap, onRemoveTap);
          },
          child: SantoFormUtil.getPrefixIcon(prefixIconType),
        ),
      ),
    );
  }

  /// 获取错误提示widget
  static Widget buildErrorWidget(String error, SantoFormItemConfig themeData) {
    return Offstage(
      offstage: error.isEmpty,
      child: Container(
        padding: errorEdgeInsets(themeData),
        child: Text(error, style: getErrorTextStyle(themeData)),
      ),
    );
  }

  /// 获取子标题Widget
  static Widget buildSubTitleWidget(
      String? subTitle, SantoFormItemConfig themeData) {
    return Offstage(
      offstage: (subTitle == null || subTitle.isEmpty),
      child: Container(
          padding: subTitleEdgeInsets(themeData),
          child: Text(
            subTitle ?? "",
            style: getSubTitleTextStyle(themeData),
          )),
    );
  }

  /// 获取必填项
  static Widget buildRequireWidget(bool isRequire) {
    return Offstage(
      offstage: (!isRequire),
      child: SantoFormUtil.getRequireIcon(isRequire),
    );
  }

  /// 获取问号
  static Widget buildTipLabelWidget(
      String? tipLabel, VoidCallback? onTip, SantoFormItemConfig themeData) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Offstage(
      offstage: (tipLabel == null),
      child: GestureDetector(
        onTap: () {
          if (onTip != null) {
            onTip();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(
                    left: commonConfig.hSpacingXs,
                    right: commonConfig.hSpacingXs),
                child: SantoFormUtil.getQuestionMarkIcon()),
            Container(
              child: Text(
                tipLabel ?? "",
                style: SantoFormUtil.getTipsTextStyle(themeData),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 获取二级标题Widget
  static Widget buildTitleWidget(String title, SantoFormItemConfig themeData) {
    return Container(
        child: Text(
      title,
      style: SantoFormUtil.getTitleTextStyle(themeData),
    ));
  }

  /// 录入项是否可编辑
  static bool isEdit(bool isEdit) {
    return isEdit;
  }

  //
  static Widget getPrefixIcon(String type) {
    if (type == SantoPrefixIconType.add) {
      return SantoIcon(SantoIcons.plusCircle,
          color: SantoThemeConfigurator.instance
              .getConfig()
              .commonConfig
              .brandPrimary);
    } else if (type == SantoPrefixIconType.remove) {
      return SantoIcon(SantoIcons.minusCircle,
          color: SantoThemeConfigurator.instance
              .getConfig()
              .commonConfig
              .brandError);
    } else {
      return Container();
    }
  }

  static Widget getPrefixIconWithDisable(String type, bool isEnabled) {
    return (isEnabled)
        ? SantoFormUtil.getPrefixIcon(type)
        : ColorFiltered(
            colorFilter: ColorFilter.mode(
                SantoThemeConfigurator.instance
                    .getConfig()
                    .commonConfig
                    .colorTextHint,
                BlendMode.srcIn),
            child: SantoFormUtil.getPrefixIcon(type),
          );
  }

  static Widget getRequireIcon(bool isRequire) {
    return Container(
      padding:
          isRequire ? EdgeInsets.only(right: 2) : EdgeInsets.only(right: 0),
      child: isRequire
          ? SantoIcon(SantoIcons.asterisk,
                  size: 8, color: const Color(0xFFFF4D4F))
          : null,
    );
  }

  /// 视觉同学要求修改右箭头图标
  static Widget getRightArrowIcon() {
    return SantoIcon(SantoIcons.navArrowRight, size: rightArrowSize);
  }

  static Widget getQuestionMarkIcon() {
    return SantoIcon(SantoIcons.helpCircle);
  }

  static EdgeInsets computeErrorEdgeInsets(String type, bool isRequire) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return EdgeInsets.only(
      left: commonConfig.hSpacingLg,
      top: commonConfig.vSpacingXs,
    );
  }

  static TextInputType getInputType(String? type) {
    TextInputType inputType = TextInputType.text;

    if (type == null || type.isEmpty) {
      return inputType;
    }

    switch (type) {
      case SantoInputType.text:
        inputType = TextInputType.text;
        break;
      case SantoInputType.multiLine:
        inputType = TextInputType.multiline;
        break;
      case SantoInputType.number:
        inputType = TextInputType.number;
        break;
      case SantoInputType.decimal:
        inputType = TextInputType.numberWithOptions(decimal: true);
        break;
      case SantoInputType.phone:
        inputType = TextInputType.phone;
        break;
      case SantoInputType.date:
        inputType = TextInputType.datetime;
        break;
      case SantoInputType.email:
        inputType = TextInputType.emailAddress;
        break;
      case SantoInputType.url:
        inputType = TextInputType.url;
        break;
      case SantoInputType.pwd:
        inputType = TextInputType.visiblePassword;
        break;
      default:
        break;
    }

    return inputType;
  }

  ///
  /// 交互行为相关
  ///

  /// 处理点击"添加/删除"按钮动作
  static void notifyAddRemoveTap(BuildContext context, String prefixIconType,
      VoidCallback? onAddTap, VoidCallback? onRemoveTap) {
    if (SantoPrefixIconType.add == prefixIconType) {
      if (onAddTap != null) {
        onAddTap();
      }
    } else if (SantoPrefixIconType.remove == prefixIconType) {
      if (onRemoveTap != null) {
        onRemoveTap();
      }
    }
  }

  /// 处理点击"添加/删除"按钮动作
  static void notifyAddTap(BuildContext context, VoidCallback? onAddTap) {
    if (onAddTap != null) {
      onAddTap();
    }
  }

  /// 处理点击"添加/删除"按钮动作
  static void notifyRemoveTap(BuildContext context, VoidCallback? onRemoveTap) {
    if (onRemoveTap != null) {
      onRemoveTap();
    }
  }

  /// 处理点击"按钮"动作
  static void notifyTap(BuildContext context, VoidCallback? onWidgetTap) {
    if (onWidgetTap != null) {
      onWidgetTap();
    }
  }

  /// 处理 输入状态 变化
  static void notifyInputChanged(
      ValueChanged<String>? onTextChanged, String newStr) {
    if (onTextChanged != null) {
      onTextChanged(/*oldStr, */ newStr);
    }
  }

  /// 处理 开关 变化
  static void notifySwitchChanged(OnSantoFormSwitchChanged? onSwitchChanged,
      BuildContext context, bool oldValue, bool newValue) {
    if (onSwitchChanged != null) {
      onSwitchChanged(oldValue, newValue);
    }
  }

  /// 处理 数字值 变化
  static void notifyValueChanged(OnSantoFormValueChanged? onChanged,
      BuildContext context, int oldVal, int newVal) {
    if (onChanged != null) {
      onChanged(oldVal, newVal);
    }
  }

  /// 处理 单选选中状态变化
  static void notifyRadioStatusChanged(
      OnSantoFormRadioValueChanged? onTextChanged,
      BuildContext context,
      Object? oldVal,
      Object? newVal) {
    if (onTextChanged != null) {
      onTextChanged(oldVal as String?, newVal as String?);
    }
  }

  /// 处理 多选选中状态变化
  static void notifyMultiChoiceStatusChanged(
    OnSantoFormMultiChoiceValueChanged? onChoiceChanged,
    BuildContext context,
    List<String> oldVal,
    List<String> newVal,
  ) {
    if (onChoiceChanged != null) {
      onChoiceChanged(oldVal, newVal);
    }
  }

  ///
  /// 主题配置相关
  ///

  /// 选项之间的间距
  static EdgeInsets? optionsMiddlePadding(SantoFormItemConfig themeData) {
    return themeData.optionsMiddlePadding;
  }

  /// 走主题配置 上下右间距
  static EdgeInsets itemEdgeInsets(SantoFormItemConfig themeData) {
    return themeData.formPadding;
  }

  /// 标题行的左间距
  static EdgeInsets titleEdgeInsets(
      String type, bool isRequire, SantoFormItemConfig themeData) {
    if (isRequire && type == SantoPrefixIconType.normal) {
      return themeData.titlePaddingSm;
    }
    return themeData.titlePaddingLg;
  }

  /// 标题行的左间距
  static EdgeInsets titleEdgeInsetsForHead(
      bool isRequire, SantoFormItemConfig themeData) {
    return isRequire ? themeData.titlePaddingSm : themeData.titlePaddingLg;
  }

  /// 子标题的右上间距
  static EdgeInsets subTitleEdgeInsets(SantoFormItemConfig themeData) {
    return themeData.subTitlePadding;
  }

  /// error的右上间距
  static EdgeInsets errorEdgeInsets(SantoFormItemConfig themeData) {
    return themeData.errorPadding;
  }

  /// 提示文本样式
  static TextStyle getTipsTextStyle(SantoFormItemConfig themeData) {
    return themeData.tipsTextStyle.generateTextStyle();
  }

  /// 获取 右侧 输入、选择默认文本样式
  static TextStyle getHintTextStyle(SantoFormItemConfig themeData,
      {double height = 0}) {
    if (height > 0) {
      return SantoTextStyle(height: height)
          .merge(themeData.hintTextStyle)
          .generateTextStyle();
    }
    return themeData.hintTextStyle.generateTextStyle();
  }

  /// 获取是否可编辑的字体
  static TextStyle getIsEditTextStyle(SantoFormItemConfig themeData, bool isEdit,
      {double height = 0}) {
    if (height > 0) {
      return isEdit
          ? SantoTextStyle(height: height)
              .merge(themeData.contentTextStyle)
              .generateTextStyle()
          : SantoTextStyle(height: height)
              .merge(themeData.disableTextStyle)
              .generateTextStyle();
    }
    return isEdit
        ? themeData.contentTextStyle.generateTextStyle()
        : themeData.disableTextStyle.generateTextStyle();
  }

  /// 获取标题文本样式
  static TextStyle getTitleTextStyle(SantoFormItemConfig themeData,
      {double height = 0}) {
    if (height > 0) {
      return SantoTextStyle(height: height)
          .merge(themeData.titleTextStyle)
          .generateTextStyle();
    }
    return themeData.titleTextStyle.generateTextStyle();
  }

  /// 获取标题文本样式
  static TextStyle getHeadTitleTextStyle(SantoFormItemConfig themeData,
      {bool isBold = false}) {
    if (isBold) {
      return themeData.headTitleTextStyle
          .merge(SantoTextStyle(fontWeight: FontWeight.w500))
          .generateTextStyle();
    }
    return themeData.headTitleTextStyle.generateTextStyle();
  }

  /// 获取左侧辅助样式
  static TextStyle getSubTitleTextStyle(SantoFormItemConfig themeData) {
    return themeData.subTitleTextStyle.generateTextStyle();
  }

  /// 获取error 文本样式
  static TextStyle getErrorTextStyle(SantoFormItemConfig themeData) {
    return themeData.errorTextStyle.generateTextStyle();
  }

  /// 获取选项文本样式
  static TextStyle getOptionTextStyle(SantoFormItemConfig themeData) {
    return themeData.optionTextStyle.generateTextStyle();
  }

  /// 获取选中选项文本样式
  static TextStyle getOptionSelectedTextStyle(SantoFormItemConfig themeData) {
    return themeData.optionSelectedTextStyle.generateTextStyle();
  }

  ///
  /// AutoLayout
  ///

  static double rightArrowSize = 16;
  static double rightArrowLeftPadding = 10;

  /// 右边内容区域比例
  static double contentRatio = 0.6;

  /// 表单 tip 说明文字限制4个字长的最大宽度
  static double tipDescMaxWidth = 56;

  /// 当左右内容超出默认比例且「有」提示语，则按比例  6:4 布局
  /// 当左右内容超出默认比例且「无」提示语，则按比例  4:6 布局
  /// 有用户自定义比例时用用户自定义比例
  static double getAutoLayoutContentRatio(
      {required bool tipLabelHidden, double? layoutRatio}) {
    double defaultRatio = tipLabelHidden
        ? SantoFormUtil.contentRatio
        : 1 - SantoFormUtil.contentRatio;
    double contentRatio = layoutRatio != null && layoutRatio > 0
        ? 1 / (layoutRatio + 1)
        : defaultRatio;
    return contentRatio;
  }
}
