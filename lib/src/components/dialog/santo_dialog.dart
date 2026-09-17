import 'package:santo_ui/src/components/dialog/santo_dialog_utils.dart';
import 'package:santo_ui/src/components/button/santo_big_ghost_button.dart';
import 'package:santo_ui/src/components/button/santo_big_main_button.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_dialog_config.dart';
import 'package:santo_ui/src/utils/santo_tools.dart';
import 'package:flutter/material.dart';

/// 底部按钮的点击监听回调
typedef DialogIndexedActionClickCallback = void Function(int index);

/// icon的间距
final EdgeInsetsGeometry cIconPadding = EdgeInsets.only(
    top: SantoThemeConfigurator
        .instance
        .getConfig()
        .commonConfig
        .vSpacingLg);

/// title的文字样式
final TextStyle cTitleTextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    inherit: true,
    fontSize: SantoThemeConfigurator
        .instance
        .getConfig()
        .commonConfig
        .fontSizeHead,
    color: Color(0xFF17233D));

/// title的文字的对齐
const int cTitleMaxLines = 3;

/// title的文字的对齐
const TextAlign cTitleTextAlign = TextAlign.center;

/// 内容部分文字的对齐
const TextAlign cContentTextAlign = TextAlign.center;

/// 内容部分的文字的样式
final TextStyle cContentTextStyle = TextStyle(
    inherit: true,
    fontSize: SantoThemeConfigurator
        .instance
        .getConfig()
        .commonConfig
        .fontSizeBase,
    color: Color(0xFF515A6E),
    decoration: TextDecoration.none);

/// 警示文案样式
final TextStyle cWarningTextStyle = TextStyle(
    inherit: true,
    fontSize: SantoThemeConfigurator
        .instance
        .getConfig()
        .commonConfig
        .fontSizeBase,
    color: Color(0xFFFF4D4F),
    decoration: TextDecoration.none);

/// 警示文案的文字对齐
const TextAlign cWarningTextAlign = TextAlign.center;

/// 对话框的背景---》默认白色
const Color cBackgroundColor = Colors.white;

/// 对话框的边框----》默认圆角取 radiusXs
final ShapeBorder cShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(
        SantoThemeConfigurator.instance.getConfig().commonConfig.radiusXs)));

/// 主题按钮的背景颜色---》白色
const Color cMainBackgroundColor = Colors.white;

/// 主题按钮的文字样式---》主色调
final TextStyle cMainTextStyle = TextStyle(
    color: Color(0xFF52C41A),
    fontWeight: FontWeight.w500,
    fontSize: SantoThemeConfigurator
        .instance
        .getConfig()
        .commonConfig
        .fontSizeSubHead);

/// 灰色按钮的背景颜色---》白色
const Color cGreyBackgroundColor = Colors.white;

/// 非按钮的文字样式---》灰色
final TextStyle cGreyActionsTextStyle = TextStyle(
    color: Color(0xFF17233D),
    fontWeight: FontWeight.w500,
    fontSize: SantoThemeConfigurator
        .instance
        .getConfig()
        .commonConfig
        .fontSizeSubHead);

/// 水平分割线 内容与按钮
const VerticalDivider cVerticalDivider =
    const VerticalDivider(width: 1.0, color: Color(0xFFE8EAEC));

/// 垂直分割线 按钮分割
const Divider cDividerLine = const Divider(
  height: 1.0,
  color: Color(0xFFE8EAEC),
);


///高度灵活的通用的弹窗组件
///
///布局规则：
///   弹窗由五部分组成：Icon、标题、内容、警示、按钮操作区域。
///   每一部分都可以显示或者不显示。
///
///
///有两种使用方式：
///1：系统的showDialog
///   无标题、单按钮
///   showDialog<void>(
///     context: context,
///     barrierDismissible: true,
///     builder: (BuildContext dialogContext) {
///       return SantoDialog(
///         messageText: "辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息",
///         actionsText: [],
///       );
///     },
///   );
///
///2：使用对话框管理器
///  无标题、单按钮
///  void _showStyle1Dialog(BuildContext context) {
///    SantoDialogManager.showSingleButtonDialog(context,
///        label: "知道了", message: "辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息", onTap: () {
///      SantoToast.show('知道了', context);
///    });
///  }
///
class SantoDialog extends AlertDialog {
  /// 标题控件
  final Widget? titleWidget;

  /// 内容控件
  final Widget? contentWidget;

  /// 警示文案部分的控件
  final Widget? warningWidget;

  /// 按钮部分控件
  final List<Widget>? actionsWidget;

  ///-----如果以上属性设置了，那么对话框中的相对应的部分 以他们为基准

  /// 标题文本
  final String? titleText;

  /// 内容文本
  final String? messageText;

  /// 警示文本
  final String? warningText;

  /// 底部按钮文案
  final List<String>? actionsText;

  /// 根据以上属性 生成对应的text控件

  /// 垂直分割线
  final VerticalDivider verticalDivider;

  /// 水平分割线
  final Divider divider;

  /// 底部按钮的点击监听回调
  final DialogIndexedActionClickCallback? indexedActionCallback;

  /// 是否展示头部icon
  final bool showIcon;

  /// 头部的icon
  final Image? iconImage;

  /// dialog配置
  final SantoDialogConfig? themeData;

  /// 标题最大行数
  final int titleMaxLines;

  SantoDialog({
    Key? key,
    this.showIcon = false,
    this.iconImage,
    this.titleText,
    this.messageText,
    this.titleWidget,
    this.contentWidget,
    this.warningText,
    this.warningWidget,
    this.actionsWidget,
    this.divider = cDividerLine,
    this.verticalDivider = cVerticalDivider,
    this.actionsText,
    this.indexedActionCallback,
    this.themeData,
    this.titleMaxLines = cTitleMaxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SantoDialogConfig? defaultConfig = themeData ?? SantoDialogConfig();

    defaultConfig = SantoThemeConfigurator.instance
        .getConfig(configId: defaultConfig.configId)
        .dialogConfig
        .merge(defaultConfig);

    final List<Widget> children = <Widget>[];

    if (_isShowIcon()) {
      Widget generateIconWidget = _generateIconWidget(context, defaultConfig);
      children.add(generateIconWidget);
    }

    if (_isShowTitle()) {
      Widget generateTitleWidget = _generateTitleWidget(context, defaultConfig);
      children.add(generateTitleWidget);
    }

    if (_isShowContent()) {
      Widget generateContentWidget =
          _generateContentWidget(context, defaultConfig);
      children.add(generateContentWidget);
    }

    if (_isShowWarning()) {
      Widget generateWarningWidget =
          _generateWarningWidget(context, defaultConfig);
      children.add(generateWarningWidget);
    }

    children.add(Padding(
      padding: defaultConfig.dividerPadding,
      child: const SizedBox.shrink(),
    ));

    if (!_isEmptyAction()) {
      children.add(_generateActionsWidget(context, defaultConfig));
    }

    Widget dialogChild = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );

    return UnconstrainedBox(
        child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(
                      SantoDialogUtils.getDialogRadius(defaultConfig)))),
              child: dialogChild,
              color: defaultConfig.backgroundColor,
            )));
  }

  Widget _generateIconWidget(
      BuildContext context, SantoDialogConfig dialogConfig) {
    Widget _createWidget(Widget widget) {
      return Center(
        child: Padding(
          padding: dialogConfig.iconPadding,
          child: SizedBox(
            width: 36,
            height: 36,
            child: widget,
          ),
        ),
      );
    }

    if (iconImage != null) {
      return _createWidget(iconImage!);
    }
    if (showIcon) {
      return _createWidget(
          SantoTools.getAssetImageWithBandColor("icons/icon_alter.png"));
    }

    return const SizedBox.shrink();
  }

  /// 标题widget：以titleWidget为准，辅以title生成的Text。
  Widget _generateTitleWidget(
      BuildContext context, SantoDialogConfig dialogConfig) {
    if (titleWidget != null) {
      return DefaultTextStyle(
        textAlign: dialogConfig.titleTextAlign,
        style: SantoDialogUtils.getDialogTitleStyle(dialogConfig),
        child: titleWidget!,
      );
    }

    return Padding(
      padding: _configTitlePadding(dialogConfig),
      child: Text(
        titleText!,
        maxLines: titleMaxLines,
        overflow: TextOverflow.ellipsis,
        style: SantoDialogUtils.getDialogTitleStyle(dialogConfig),
        textAlign: dialogConfig.titleTextAlign,
      ),
    );
  }

  /// 内容widget：以contentWidget为准，辅以message生成的Text
  Widget _generateContentWidget(
      BuildContext context, SantoDialogConfig dialogConfig) {
    if (contentWidget != null) {
      return Flexible(
        child: DefaultTextStyle(
          style: dialogConfig.contentTextStyle.generateTextStyle(),
          child: contentWidget!,
        ),
      );
    }

    return Padding(
      padding: _configContentPadding(dialogConfig),
      child: Center(
        child: Text(
          messageText ?? "",
          style: dialogConfig.contentTextStyle.generateTextStyle(),
          textAlign: dialogConfig.contentTextAlign,
        ),
      ),
    );
  }

  /// 警示widget：以warningWidget为准，辅以warning生成的Text
  Widget _generateWarningWidget(
      BuildContext context, SantoDialogConfig dialogConfig) {
    if (warningWidget != null) {
      return Flexible(
        child: DefaultTextStyle(
          style: dialogConfig.warningTextStyle.generateTextStyle(),
          child: warningWidget!,
        ),
      );
    }

    return Padding(
      padding: _configWarningPadding(dialogConfig),
      child: Text(
        warningText!,
        style: dialogConfig.warningTextStyle.generateTextStyle(),
        textAlign: dialogConfig.warningTextAlign,
      ),
    );
  }

  Widget _generateActionsWidget(
      BuildContext context, SantoDialogConfig defaultConfig) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    bool showTextActions = _isEmptyActionsWidget();
    int length = showTextActions ? actionsText!.length : actionsWidget!.length;
    if (length == 1) {
      return Padding(
        padding: EdgeInsets.fromLTRB(commonConfig.hSpacingLg, 0,
            commonConfig.hSpacingLg, commonConfig.vSpacingMd),
        child: showTextActions
            ? _mapTextToGesWidget(context, actionsText![0], 0, true)
            : actionsWidget![0],
      );
    } else if (length == 2) {
      return Padding(
        padding: EdgeInsets.fromLTRB(commonConfig.hSpacingLg, 0,
            commonConfig.hSpacingLg, commonConfig.vSpacingMd),
        child: Row(
          children: [
            Expanded(
              child: showTextActions
                  ? _mapTextToGesWidget(context, actionsText![0], 0, false)
                  : actionsWidget![0],
            ),
            SizedBox(width: commonConfig.pageGap),
            Expanded(
              child: showTextActions
                  ? _mapTextToGesWidget(context, actionsText![1], 1, true)
                  : actionsWidget![1],
            )
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.fromLTRB(commonConfig.hSpacingLg, 0,
            commonConfig.hSpacingLg, commonConfig.vSpacingMd),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < length; i++) ...[
              if (i > 0) SizedBox(height: commonConfig.pageGap),
              showTextActions
                  ? _mapTextToGesWidget(context, actionsText![i], i, true)
                  : actionsWidget![i],
            ]
          ],
        ),
      );
    }
  }

  /// 底部操作统一使用按钮组件渲染:
  /// 主操作 = 大主色按钮(品牌色实心),辅助操作 = 大辅助色按钮(品牌色低透明度填充)
  Widget _mapTextToGesWidget(
      BuildContext context, String label, int index, bool main) {
    void handleTap() {
      if (indexedActionCallback != null) {
        indexedActionCallback!(index);
      } else {
        Navigator.pop(context);
      }
    }

    return main
        ? SantoBigMainButton(
            title: label,
            onTap: handleTap,
          )
        : SantoBigGhostButton(
            title: label,
            onTap: handleTap,
          );
  }

  bool _isEmptyAction() {
    return _isEmptyActionsText() && _isEmptyActionsWidget();
  }

  bool _isShowIcon() {
    return (showIcon || iconImage != null);
  }

  bool _isShowTitle() {
    return (titleText != null || titleWidget != null);
  }

  bool _isShowContent() {
    return contentWidget != null || messageText != null;
  }

  bool _isShowWarning() {
    return warningWidget != null || warningText != null;
  }

  bool _isEmptyActionsText() {
    return actionsText == null || actionsText!.isEmpty;
  }

  bool _isEmptyActionsWidget() {
    return actionsWidget == null || actionsWidget!.isEmpty;
  }

  /// 主题配置的标题间距
  EdgeInsetsGeometry _configTitlePadding(SantoDialogConfig dialogConfig) {
    return _isShowIcon()
        ? dialogConfig.titlePaddingSm
        : dialogConfig.titlePaddingLg;
  }

  /// 主题配置的内容间距
  EdgeInsetsGeometry _configContentPadding(SantoDialogConfig dialogConfig) {
    return (_isShowIcon() || _isShowTitle())
        ? dialogConfig.contentPaddingSm
        : dialogConfig.contentPaddingLg;
  }

  /// 主题配置的警告间距
  EdgeInsetsGeometry _configWarningPadding(SantoDialogConfig dialogConfig) {
    return (_isShowIcon() || _isShowTitle() || _isShowContent())
        ? dialogConfig.warningPaddingSm
        : dialogConfig.warningPaddingLg;
  }
}

/// 是对话框显示的管理类。
/// 根据底部按钮的数量分为：单个按钮对话框、两个按钮对话框 和 不定按钮对话框
///
/// 通用属性：
/// showIcon 是否展示 头部Icon，会展示默认的 对号图片
/// iconWidget 头部icon的图片，如果设置了这个属性 即使showIcon为false也会展示 设置的图片
///
/// title 是展示的标题文案
/// titleWidget 展示的标题widget，如果设置了widget 则会以widget为准
///
/// message 中间的辅助信息文案
/// messageWidget 展示中间辅助信息的widget
///
/// warning 警示文案
/// warningWidget 展示警示文案的widget
///
/// dismiss 点击按钮后是否 消失弹窗
///
/// barrierDismissible 点击四周的黑色遮罩 是否关闭弹窗
///
/// titleMaxLines 标题的最大行数
///
class SantoDialogManager {
  ///展示底部只有一个按钮的对话框 对话框的点击回调是onTap
  ///label 底部按钮的文案
  ///labelWidget  自定义底部按钮的显示
  static void showSingleButtonDialog(
    BuildContext context, {
    required String label,
    bool showIcon = false,
    Image? iconWidget,
    String? title,
    Widget? titleWidget,
    String? message,
    Widget? messageWidget,
    String? warning,
    Widget? warningWidget,
    Widget? labelWidget,
    GestureTapCallback? onTap,
    bool barrierDismissible = true,
    int titleMaxLines = cTitleMaxLines,
    SantoDialogConfig? themeData,
  }) {
    List<Widget> actionsWidget = [];

    if (labelWidget != null) {
      actionsWidget.add(labelWidget);
    }
    showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext dialogContext) {
        return SantoDialog(
          iconImage: iconWidget,
          showIcon: showIcon,
          titleText: title,
          titleWidget: titleWidget,
          messageText: message,
          contentWidget: messageWidget,
          warningText: warning,
          warningWidget: warningWidget,
          actionsText: [label],
          actionsWidget: actionsWidget,
          titleMaxLines: titleMaxLines,
          themeData: themeData,
          indexedActionCallback: (index) {
            if (index == 0) {
              if (onTap != null) {
                onTap();
              }
            }
          },
        );
      },
    );
  }

  /// 展示底部有两个按钮的弹窗 左侧是cancel 右侧是confirm
  /// cancel 左侧显示的文案
  /// confirm 右侧显示的文案
  /// cancelWidget 自定义显示的左侧
  /// conformWidget 自定义显示的右侧
  static void showConfirmDialog(
    BuildContext context, {
    required String cancel,
    required String confirm,
    bool showIcon = false,
    Image? iconWidget,
    String? title,
    Widget? titleWidget,
    String? message,
    Widget? messageWidget,
    String? warning,
    Widget? warningWidget,
    Widget? cancelWidget,
    Widget? conformWidget,
    GestureTapCallback? onCancel,
    GestureTapCallback? onConfirm,
    bool barrierDismissible = true,
    int titleMaxLines = cTitleMaxLines,
    SantoDialogConfig? themeData,
  }) {
    List<Widget> actionsWidget = [];

    if (cancelWidget != null) {
      actionsWidget.add(cancelWidget);
    }
    if (conformWidget != null) {
      actionsWidget.add(conformWidget);
    }
    showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext dialogContext) {
        return SantoDialog(
          iconImage: iconWidget,
          showIcon: showIcon,
          titleText: title,
          titleWidget: titleWidget,
          messageText: message,
          contentWidget: messageWidget,
          warningWidget: warningWidget,
          warningText: warning,
          themeData: themeData,
          titleMaxLines: titleMaxLines,
          actionsText: [cancel, confirm],
          actionsWidget: actionsWidget,
          indexedActionCallback: (index) {
            if (index == 0) {
              if (onCancel != null) {
                onCancel();
              }
            }
            if (index == 1) {
              if (onConfirm != null) {
                onConfirm();
              }
            }
          },
        );
      },
    );
  }

  ///展示底部按钮为多个的dialog 如果设置的是文字按钮那么，每个按钮的点击通过indexedActionClickCallback处理
  ///如果底部按钮的数量小于等于2 ，会以横排展示，否则会议竖排展示
  ///如果数量超过了三个 会滑动展示
  static void showMoreButtonDialog(
    BuildContext context, {
    required List<String> actions,
    bool showIcon = false,
    Image? iconWidget,
    String? title,
    Widget? titleWidget,
    String? message,
    Widget? messageWidget,
    String? warning,
    Widget? warningWidget,
    List<Widget>? actionsWidget,
    bool barrierDismissible = true,
    int titleMaxLines = cTitleMaxLines,
    SantoDialogConfig? themeData,
    DialogIndexedActionClickCallback? indexedActionClickCallback,
  }) {
    showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext dialogContext) {
        return SantoDialog(
            iconImage: iconWidget,
            showIcon: showIcon,
            titleText: title,
            titleWidget: titleWidget,
            messageText: message,
            contentWidget: messageWidget,
            warningWidget: warningWidget,
            warningText: warning,
            actionsText: actions,
            actionsWidget: actionsWidget,
            themeData: themeData,
            titleMaxLines: titleMaxLines,
            indexedActionCallback: indexedActionClickCallback);
      },
    );
  }
}