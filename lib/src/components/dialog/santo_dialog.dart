import 'dart:async';

import 'package:santo_ui/src/components/icon/santo_solid_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:santo_ui/src/components/button/santo_button.dart';
import 'package:santo_ui/src/components/icon/santo_icon.dart';
import 'package:santo_ui/src/components/icon/santo_icons.dart';
import 'package:santo_ui/src/components/input/santo_input.dart';
import 'package:santo_ui/src/components/line/santo_line.dart';
import 'package:santo_ui/src/constants/santo_constants.dart';
import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:santo_ui/src/theme/configs/santo_dialog_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/utils/css/santo_core_funtion.dart';
import 'package:santo_ui/src/utils/css/santo_css_2_text.dart';
import 'package:santo_ui/src/utils/santo_tools.dart';

/// 弹窗头部的预设图标,统一用 [SantoIcon] 的 **solid 实心**图标并取对应语义色
///
/// 需要线图标、多色插画或别的图形时用 `SantoDialog(icon: ...)` 传自定义 widget。
enum SantoDialogIconType {
  /// 不展示图标
  none,

  /// 提示图标:info-circle,取品牌色
  info,

  /// 警示图标:warning-triangle,取警示色
  warning,

  /// 失败图标:xmark-circle,取失败色
  error,

  /// 成功图标:check-circle,取成功色
  success,
}

/// 多选弹窗的选项
class MultiSelectItem {
  /// 选项编号
  String code;

  /// 选项内容
  String content;

  /// 是否选中
  bool isChecked;

  MultiSelectItem(this.code, this.content, {this.isChecked = false});
}

/// 单选弹窗提交回调,参数为选中的选项
typedef SantoDialogSingleSelectSubmit = void Function(String? value);

/// 多选弹窗提交回调,返回 false 时不关闭弹窗
typedef SantoDialogMultiSelectSubmit = bool Function(List<MultiSelectItem> items);

/// 弹窗内选项的点击回调,可用于埋点
typedef SantoDialogSelectItemClick = void Function(
    BuildContext dialogContext, int index);

/// 分享渠道点击回调
/// shareChannel 是分享渠道,一般传入 [SantoShareItemConstants] 下的值
typedef SantoDialogShareItemClick = void Function(
    int shareChannel, int index);

/// 获取自定义分享渠道标题,index 为该渠道在 [SantoDialog.share] 列表中的下标
typedef SantoDialogShareCustomTitle = String? Function(int index);

/// 获取自定义分享渠道图标,index 为该渠道在 [SantoDialog.share] 列表中的下标
typedef SantoDialogShareCustomIcon = Widget? Function(int index);

/// 通用弹窗,全库**唯一**的弹窗入口。
///
/// 一个弹窗由上至下由六部分组成,每部分都可配置、可省略:
///
/// 1. 图标 [SantoDialog.icon] / [SantoDialog.iconType](info / warning / error / success)
/// 2. 标题 [SantoDialog.title] / [SantoDialog.titleWidget]
/// 3. 辅助文案 [SantoDialog.message] / [SantoDialog.messageWidget]
/// 4. 输入框 [SantoDialog.showInput] 及 `input*` 一组参数,内部渲染 [SantoInput]
/// 5. 底部两个按钮 [SantoDialog.okText] / [SantoDialog.cancelText],按钮点击默认关闭弹窗
/// 6. 右上角关闭 [SantoDialog.closable]
///
/// 另有警示文案 [SantoDialog.warningText] 与完全自定义底部 [SantoDialog.footer];
/// 常见的业务形态由命名构造承接:[SantoDialog.alert](纵向主次按钮强提示)、
/// [SantoDialog.richText](长文本可滚动)、[SantoDialog.input] 形态见通用构造、
/// [SantoDialog.singleSelect]、[SantoDialog.multiSelect]、[SantoDialog.share]。
///
/// 直接 `new` 出来交给 `showDialog` 使用:
///
/// ```dart
/// showDialog<void>(
///   context: context,
///   builder: (_) => SantoDialog(
///     iconType: SantoDialogIconType.info,
///     title: '确定关注我吗?',
///     message: '辅助文案',
///     cancelText: '取消',
///     okText: '确定',
///     onOk: () {},
///   ),
/// );
/// ```
///
/// 常见的一次性弹窗也可以用静态方法:[SantoDialog.confirm] / [info] / [success] /
/// [warning] / [error],以及按 tag 精确关闭的 [SantoDialog.show] / [SantoDialog.dismiss]。
///
/// @since v1.0.0
/// @changed v1.1.0 收拢为唯一入口:`SantoDialogManager`、`SantoEnhanceOperationDialog`、
/// `SantoContentExportWidget`、`SantoScrollableTextDialog`、`SantoMiddleInputDialog`、
/// `SantoSingleSelectDialog`、`SantoMultiSelectDialog`、`SantoShareDialog`、
/// `SantoSafeDialog` 与 `SantoDialogUtils` 全部并入本组件
class SantoDialog extends StatelessWidget {
  /// 六种形态共用的弹窗本体
  final Widget _body;

  const SantoDialog._(this._body, {super.key});

  /// 通用弹窗
  ///
  /// 六个组成部分的配置面见类文档;`okText` / `cancelText` 都不传则没有底部按钮。
  factory SantoDialog({
    Key? key,
    // 1. 图标
    SantoDialogIconType iconType = SantoDialogIconType.none,
    Widget? icon,
    // 2. 标题
    String? title,
    Widget? titleWidget,
    int titleMaxLines = 3,
    // 3. 辅助文案
    String? message,
    Widget? messageWidget,
    TextAlign? messageTextAlign,
    double? messageMaxHeight,
    // 4. 输入框
    bool showInput = false,
    String? inputHintText,
    TextEditingController? inputController,
    FocusNode? inputFocusNode,
    int? inputMaxLength,
    int inputMaxLines = 1,
    int? inputMinLines,
    TextInputType inputType = TextInputType.text,
    TextInputAction? inputAction,
    List<TextInputFormatter>? inputFormatters,
    bool inputAutoFocus = false,
    ValueChanged<String>? onInputChanged,
    // 5. 底部两个按钮
    String? okText,
    VoidCallback? onOk,
    String? cancelText,
    VoidCallback? onCancel,
    bool dismissOnActionTap = true,
    // 6. 右上角关闭
    bool closable = false,
    VoidCallback? onClose,
    // 其他形态
    String? warningText,
    Widget? warningWidget,
    Widget? footer,
    double? width,
    SantoDialogConfig? themeData,
  }) {
    return SantoDialog._(
      _GeneralDialog(
        iconType: iconType,
        icon: icon,
        title: title,
        titleWidget: titleWidget,
        titleMaxLines: titleMaxLines,
        message: message,
        messageWidget: messageWidget,
        messageTextAlign: messageTextAlign,
        messageMaxHeight: messageMaxHeight,
        showInput: showInput,
        inputHintText: inputHintText,
        inputController: inputController,
        inputFocusNode: inputFocusNode,
        inputMaxLength: inputMaxLength,
        inputMaxLines: inputMaxLines,
        inputMinLines: inputMinLines,
        inputType: inputType,
        inputAction: inputAction,
        inputFormatters: inputFormatters,
        inputAutoFocus: inputAutoFocus,
        onInputChanged: onInputChanged,
        okText: okText,
        onOk: onOk,
        cancelText: cancelText,
        onCancel: onCancel,
        dismissOnActionTap: dismissOnActionTap,
        closable: closable,
        onClose: onClose,
        warningText: warningText,
        warningWidget: warningWidget,
        footer: footer,
        width: width,
        themeData: themeData,
      ),
      key: key,
    );
  }

  /// 强提示弹窗:图标 + 标题 + 辅助文案 + 纵向排布的主/次按钮
  ///
  /// 主按钮为整行实心主色按钮,次要按钮为主色文字链;两者点击后弹窗关闭。
  ///
  /// @changed v1.1.0 原 `SantoEnhanceOperationDialog`
  factory SantoDialog.alert({
    Key? key,
    SantoDialogIconType iconType = SantoDialogIconType.warning,
    Widget? icon,
    String? title,
    String? message,
    String? mainButtonText,
    String? secondaryButtonText,
    VoidCallback? onMainButton,
    VoidCallback? onSecondaryButton,
    bool closable = false,
    VoidCallback? onClose,
    double? width,
    SantoDialogConfig? themeData,
  }) {
    return SantoDialog._(
      _AlertDialog(
        iconType: iconType,
        icon: icon,
        title: title,
        message: message,
        mainButtonText: mainButtonText,
        secondaryButtonText: secondaryButtonText,
        onMainButton: onMainButton,
        onSecondaryButton: onSecondaryButton,
        closable: closable,
        onClose: onClose,
        width: width,
        themeData: themeData,
      ),
      key: key,
    );
  }

  /// 长文本弹窗:内容走 CSS2 富文本解析,超出定高可滚动
  ///
  /// [isShowOperateWidget] 为 false 时不展示底部提交按钮。
  ///
  /// @changed v1.1.0 原 `SantoScrollableTextDialog`
  /// @changed textColor 改为可空,不传时取主题 colorTextImportant
  factory SantoDialog.richText({
    Key? key,
    String? title,
    required String contentText,
    Color? textColor,
    double textFontSize = 16,
    String? submitText,
    Color? submitBgColor,
    VoidCallback? onSubmit,
    SantoHyperLinkCallback? linksCallback,
    bool isShowOperateWidget = true,
    bool dismissOnSubmit = true,
    bool closable = true,
    VoidCallback? onClose,
    double? width,
    SantoDialogConfig? themeData,
  }) {
    return SantoDialog._(
      _RichTextDialog(
        title: title,
        contentText: contentText,
        textColor: textColor,
        textFontSize: textFontSize,
        submitText: submitText,
        submitBgColor: submitBgColor,
        onSubmit: onSubmit,
        linksCallback: linksCallback,
        isShowOperateWidget: isShowOperateWidget,
        dismissOnSubmit: dismissOnSubmit,
        closable: closable,
        onClose: onClose,
        width: width,
        themeData: themeData,
      ),
      key: key,
    );
  }

  /// 单选列表弹窗:标题 + 辅助文案 + 单选列表 + 底部提交按钮
  ///
  /// [conditions] 为选项文案;[checkedItem] 为初始选中项;
  /// [customWidget] 会跟在列表尾部;[isCustomFollowScroll] 为 true 时列表跟随
  /// 整体滚动(选项少时用),为 false 时列表自身在最高 300 内滚动。
  ///
  /// @changed v1.1.0 原 `SantoSingleSelectDialog`
  factory SantoDialog.singleSelect({
    Key? key,
    String? title,
    String? message,
    Widget? messageWidget,
    required List<String> conditions,
    String? checkedItem,
    String? submitText,
    Color? submitBgColor,
    SantoDialogSingleSelectSubmit? onSubmit,
    SantoDialogSelectItemClick? onItemClick,
    Widget? customWidget,
    bool isCustomFollowScroll = true,
    bool dismissOnSubmit = true,
    bool closable = true,
    VoidCallback? onClose,
    double? width,
    SantoDialogConfig? themeData,
  }) {
    return SantoDialog._(
      _SingleSelectDialog(
        title: title,
        message: message,
        messageWidget: messageWidget,
        conditions: conditions,
        checkedItem: checkedItem,
        submitText: submitText,
        submitBgColor: submitBgColor,
        onSubmit: onSubmit,
        onItemClick: onItemClick,
        customWidget: customWidget,
        isCustomFollowScroll: isCustomFollowScroll,
        dismissOnSubmit: dismissOnSubmit,
        closable: closable,
        onClose: onClose,
        width: width,
        themeData: themeData,
      ),
      key: key,
    );
  }

  /// 多选列表弹窗:标题 + 辅助文案 + 多选列表 + 底部提交按钮
  ///
  /// [onSubmit] 返回 false 时不关闭弹窗;[isShowOperateWidget] 为 false 时不展示提交按钮。
  ///
  /// @changed v1.1.0 原 `SantoMultiSelectDialog`
  factory SantoDialog.multiSelect({
    Key? key,
    String? title,
    String? message,
    Widget? messageWidget,
    required List<MultiSelectItem> conditions,
    String? submitText,
    Color? submitBgColor,
    SantoDialogMultiSelectSubmit? onSubmit,
    SantoDialogSelectItemClick? onItemClick,
    Widget? customWidget,
    bool isCustomFollowScroll = true,
    bool isShowOperateWidget = true,
    bool dismissOnSubmit = true,
    bool closable = true,
    VoidCallback? onClose,
    double? width,
    SantoDialogConfig? themeData,
  }) {
    return SantoDialog._(
      _MultiSelectDialog(
        title: title,
        message: message,
        messageWidget: messageWidget,
        conditions: conditions,
        submitText: submitText,
        submitBgColor: submitBgColor,
        onSubmit: onSubmit,
        onItemClick: onItemClick,
        customWidget: customWidget,
        isCustomFollowScroll: isCustomFollowScroll,
        isShowOperateWidget: isShowOperateWidget,
        dismissOnSubmit: dismissOnSubmit,
        closable: closable,
        onClose: onClose,
        width: width,
        themeData: themeData,
      ),
      key: key,
    );
  }

  /// 分享弹窗:标题 + 辅助文案 + 分割线文案 + 分享渠道 + 右上角关闭
  ///
  /// [shareChannels] 为渠道列表,取值见 [SantoShareItemConstants];
  /// 自定义渠道(值为 [SantoShareItemConstants.shareCustom])的名称与图标由
  /// [getCustomChannelTitle] 与 [getCustomChannelWidget] 按下标提供。
  ///
  /// @changed v1.1.0 原 `SantoShareDialog`;面板形态的分享请继续使用 `SantoShare`
  /// @changed shareTextColor 改为可空,不传时取主题 colorTextSecondary
  factory SantoDialog.share({
    Key? key,
    String? title,
    String? message,
    String? separatorText,
    required List<int> shareChannels,
    SantoDialogShareItemClick? onChannelTap,
    SantoDialogShareCustomTitle? getCustomChannelTitle,
    SantoDialogShareCustomIcon? getCustomChannelWidget,
    Color? shareTextColor,
    Color? separatorLineColor,
    bool closable = true,
    VoidCallback? onClose,
    double? width,
    SantoDialogConfig? themeData,
  }) {
    return SantoDialog._(
      _ShareDialog(
        title: title,
        message: message,
        separatorText: separatorText,
        shareChannels: shareChannels,
        onChannelTap: onChannelTap,
        getCustomChannelTitle: getCustomChannelTitle,
        getCustomChannelWidget: getCustomChannelWidget,
        shareTextColor: shareTextColor,
        separatorLineColor: separatorLineColor,
        closable: closable,
        onClose: onClose,
        width: width,
        themeData: themeData,
      ),
      key: key,
    );
  }

  /// 确认弹窗:双按钮,按钮文案默认取本地化的「确定」「取消」
  ///
  /// 返回 true 表示点了确认,false 表示点了取消,null 表示点击蒙层关闭。
  static Future<bool?> confirm(
    BuildContext context, {
    String? title,
    String? message,
    Widget? messageWidget,
    SantoDialogIconType iconType = SantoDialogIconType.none,
    Widget? icon,
    String? okText,
    String? cancelText,
    VoidCallback? onOk,
    VoidCallback? onCancel,
    double? width,
    bool barrierDismissible = true,
    SantoDialogConfig? themeData,
  }) {
    return _showPreset<bool>(
      context,
      iconType: iconType,
      icon: icon,
      title: title,
      message: message,
      messageWidget: messageWidget,
      okText: okText ?? SantoIntl.of(context).localizedResource.ok,
      cancelText: cancelText ?? SantoIntl.of(context).localizedResource.cancel,
      onOk: onOk,
      onCancel: onCancel,
      width: width,
      barrierDismissible: barrierDismissible,
      themeData: themeData,
    );
  }

  /// 提示弹窗:单按钮 + 提示图标,按钮文案默认取本地化的「确定」
  static Future<bool?> info(
    BuildContext context, {
    String? title,
    String? message,
    Widget? messageWidget,
    String? okText,
    VoidCallback? onOk,
    double? width,
    bool barrierDismissible = true,
    SantoDialogConfig? themeData,
  }) {
    return _showSingleButtonPreset(
      context,
      iconType: SantoDialogIconType.info,
      title: title,
      message: message,
      messageWidget: messageWidget,
      okText: okText,
      onOk: onOk,
      width: width,
      barrierDismissible: barrierDismissible,
      themeData: themeData,
    );
  }

  /// 成功弹窗:单按钮 + 成功图标,按钮文案默认取本地化的「确定」
  static Future<bool?> success(
    BuildContext context, {
    String? title,
    String? message,
    Widget? messageWidget,
    String? okText,
    VoidCallback? onOk,
    double? width,
    bool barrierDismissible = true,
    SantoDialogConfig? themeData,
  }) {
    return _showSingleButtonPreset(
      context,
      iconType: SantoDialogIconType.success,
      title: title,
      message: message,
      messageWidget: messageWidget,
      okText: okText,
      onOk: onOk,
      width: width,
      barrierDismissible: barrierDismissible,
      themeData: themeData,
    );
  }

  /// 警示弹窗:单按钮 + 警示图标,按钮文案默认取本地化的「确定」
  static Future<bool?> warning(
    BuildContext context, {
    String? title,
    String? message,
    Widget? messageWidget,
    String? okText,
    VoidCallback? onOk,
    double? width,
    bool barrierDismissible = true,
    SantoDialogConfig? themeData,
  }) {
    return _showSingleButtonPreset(
      context,
      iconType: SantoDialogIconType.warning,
      title: title,
      message: message,
      messageWidget: messageWidget,
      okText: okText,
      onOk: onOk,
      width: width,
      barrierDismissible: barrierDismissible,
      themeData: themeData,
    );
  }

  /// 失败弹窗:单按钮 + 失败图标,按钮文案默认取本地化的「确定」
  static Future<bool?> error(
    BuildContext context, {
    String? title,
    String? message,
    Widget? messageWidget,
    String? okText,
    VoidCallback? onOk,
    double? width,
    bool barrierDismissible = true,
    SantoDialogConfig? themeData,
  }) {
    return _showSingleButtonPreset(
      context,
      iconType: SantoDialogIconType.error,
      title: title,
      message: message,
      messageWidget: messageWidget,
      okText: okText,
      onOk: onOk,
      width: width,
      barrierDismissible: barrierDismissible,
      themeData: themeData,
    );
  }

  static Future<bool?> _showSingleButtonPreset(
    BuildContext context, {
    required SantoDialogIconType iconType,
    String? title,
    String? message,
    Widget? messageWidget,
    String? okText,
    VoidCallback? onOk,
    double? width,
    bool barrierDismissible = true,
    SantoDialogConfig? themeData,
  }) {
    return _showPreset<bool>(
      context,
      iconType: iconType,
      title: title,
      message: message,
      messageWidget: messageWidget,
      okText: okText ?? SantoIntl.of(context).localizedResource.ok,
      onOk: onOk,
      width: width,
      barrierDismissible: barrierDismissible,
      themeData: themeData,
    );
  }

  /// 展示一个预设形态的弹窗,按钮点击后按 [dismissOnActionTap] 的语义关闭并回传结果
  static Future<T?> _showPreset<T>(
    BuildContext context, {
    SantoDialogIconType iconType = SantoDialogIconType.none,
    Widget? icon,
    String? title,
    String? message,
    Widget? messageWidget,
    String? okText,
    String? cancelText,
    VoidCallback? onOk,
    VoidCallback? onCancel,
    double? width,
    bool barrierDismissible = true,
    SantoDialogConfig? themeData,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext dialogContext) {
        return SantoDialog(
          iconType: iconType,
          icon: icon,
          title: title,
          message: message,
          messageWidget: messageWidget,
          okText: okText,
          cancelText: cancelText,
          dismissOnActionTap: false,
          onOk: () {
            Navigator.of(dialogContext).pop(true);
            onOk?.call();
          },
          onCancel: () {
            Navigator.of(dialogContext).pop(false);
            onCancel?.call();
          },
          width: width,
          themeData: themeData,
        );
      },
    );
  }

  /// 按 [tag] 记录路由后展示弹窗,配合 [dismiss] 精确关闭(原 `SantoSafeDialog`)
  ///
  /// 同一个 tag 下可叠加多个弹窗,[dismiss] 只会移除该 tag 最后入栈的那个;
  /// 同一个弹窗既可以直接被系统返回键关闭,也可以由 [dismiss] 主动移除。
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    String tag = _safeDialogDefaultTag,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) {
    assert(debugCheckHasMaterialLocalizations(context));
    final CapturedThemes themes = InheritedTheme.capture(
      from: context,
      to: Navigator.of(context, rootNavigator: useRootNavigator).context,
    );

    final _SafeDialogRoute<T> safeDialogRoute = _SafeDialogRoute<T>(
      context: context,
      builder: builder,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      settings: routeSettings,
      themes: themes,
    );

    // 手动管理路由,把路由自身的结果通过 Completer 转发出去
    _dialogStates[tag] ??= <_SafeDialogRoute<Object?>>[];
    _dialogStates[tag]!.add(safeDialogRoute);
    final Future<T?> future =
        Navigator.of(context, rootNavigator: useRootNavigator)
            .push<T>(safeDialogRoute);
    future.then((result) {
      _dialogStates[tag]?.remove(safeDialogRoute);
      if (!safeDialogRoute.completer.isCompleted) {
        safeDialogRoute.completer.complete(result);
      }
    });
    return safeDialogRoute.completer.future;
  }

  /// 关闭同 [tag] 下最后入栈的弹窗
  ///
  /// 直接 remove 不会走 push future 的 then 回调,因此用 Completer 转发结果;
  /// 路由已不在队列中时会抛异常,这里 catch 后打印日志。
  static void dismiss<T extends Object?>({
    required BuildContext context,
    String tag = _safeDialogDefaultTag,
    T? result,
  }) {
    final List<_SafeDialogRoute<Object?>> typeStates =
        _dialogStates[tag] ??= <_SafeDialogRoute<Object?>>[];
    if (typeStates.isEmpty) {
      return;
    }
    try {
      final _SafeDialogRoute<Object?> safeDialogRoute = typeStates.removeLast();
      Navigator.removeRoute(context, safeDialogRoute);
      if (!safeDialogRoute.completer.isCompleted) {
        safeDialogRoute.completer.complete(result);
      }
    } catch (e) {
      debugPrint('SantoDialog.dismiss failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) => _body;
}

/// 默认 tag,用于 [SantoDialog.show] / [SantoDialog.dismiss]
const String _safeDialogDefaultTag = '_santoDialogDefaultTag';

/// 按 tag 区分某一类弹窗的队列状态
final Map<String, List<_SafeDialogRoute<Object?>>> _dialogStates =
    <String, List<_SafeDialogRoute<Object?>>>{};

/// 基于 DialogRoute 封装 Completer,用于转发 Route 的结果
class _SafeDialogRoute<T> extends DialogRoute<T> {
  /// 转发 Route 结果
  final Completer<T?> completer = Completer<T?>();

  _SafeDialogRoute({
    required BuildContext context,
    required WidgetBuilder builder,
    CapturedThemes? themes,
    Color? barrierColor,
    bool barrierDismissible = true,
    String? barrierLabel,
    bool useSafeArea = true,
    RouteSettings? settings,
  }) : super(
          context: context,
          builder: builder,
          themes: themes,
          barrierColor: barrierColor,
          barrierDismissible: barrierDismissible,
          barrierLabel: barrierLabel,
          useSafeArea: useSafeArea,
          settings: settings,
        );
}

/// 取「内置默认 < 全局配置 < 组件临时配置」合并后的弹窗配置
SantoDialogConfig _resolveConfig(SantoDialogConfig? themeData) {
  final SantoDialogConfig dialogConfig = themeData ?? SantoDialogConfig();
  return SantoThemeConfigurator.instance
      .getConfig(configId: dialogConfig.configId)
      .dialogConfig
      .merge(dialogConfig);
}

/// 弹窗默认宽度:屏幕宽的 85%(与收拢前的 `SantoDialog` 一致),
/// 需要固定宽度时用组件的 `width` 参数覆盖
double _dialogWidth(BuildContext context) =>
    MediaQuery.sizeOf(context).width * 0.85;

/// 按 [dismiss] 决定是否先关闭当前弹窗,再执行按钮回调
void _dismissThen(BuildContext context, VoidCallback? callback, bool dismiss) {
  if (dismiss) {
    Navigator.maybeOf(context)?.pop();
  }
  callback?.call();
}

/// 弹窗的白色圆角本体,六种形态共用
///
/// 内容超出可用高度(屏幕高度扣掉安全区、键盘与上下留白)时整体可滚动。
class _DialogSurface extends StatelessWidget {
  const _DialogSurface({
    required this.config,
    this.icon,
    this.title,
    this.content,
    this.warning,
    this.footer,
    this.closable = false,
    this.onClose,
    this.width,
  });

  final SantoDialogConfig config;
  final Widget? icon;
  final Widget? title;
  final Widget? content;
  final Widget? warning;
  final Widget? footer;
  final bool closable;
  final VoidCallback? onClose;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final MediaQueryData media = MediaQuery.of(context);
    final double available = media.size.height -
        media.padding.top -
        media.padding.bottom -
        media.viewInsets.bottom -
        commonConfig.vSpacingXxl * 2;

    final List<Widget> children = <Widget>[];
    if (icon != null) {
      children.add(icon!);
    }
    if (title != null) {
      children.add(title!);
    }
    if (content != null) {
      children.add(content!);
    }
    if (warning != null) {
      children.add(warning!);
    }
    // 底部间距由这一档留白提供,没有 footer 时它同时充当内容的下边距,
    // 避免最后一行文字贴住弹窗底边
    children.add(Padding(
      padding: config.dividerPadding,
      child: const SizedBox.shrink(),
    ));
    if (footer != null) {
      // 底部区域统一留出左右与下边距,各形态的 footer 只需给内容
      children.add(Padding(
        padding: EdgeInsets.fromLTRB(
          commonConfig.hSpacingMd,
          0,
          commonConfig.hSpacingMd,
          commonConfig.vSpacingMd,
        ),
        child: footer!,
      ));
    }

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: available > 0 ? available : double.infinity,
        ),
        child: SizedBox(
          width: width ?? _dialogWidth(context),
          child: Material(
            color: config.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(config.radius)),
            ),
            child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: children,
                  ),
                ),
                if (closable)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onClose,
                      child: Padding(
                        padding: EdgeInsets.all(commonConfig.vSpacingMd),
                        child: SantoIcon(SantoIcons.xmark),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 通用形态:图标 / 标题 / 辅助文案 / 输入框 / 两个按钮 / 右上角关闭
class _GeneralDialog extends StatelessWidget {
  const _GeneralDialog({
    this.iconType = SantoDialogIconType.none,
    this.icon,
    this.title,
    this.titleWidget,
    this.titleMaxLines = 3,
    this.message,
    this.messageWidget,
    this.messageTextAlign,
    this.messageMaxHeight,
    this.showInput = false,
    this.inputHintText,
    this.inputController,
    this.inputFocusNode,
    this.inputMaxLength,
    this.inputMaxLines = 1,
    this.inputMinLines,
    this.inputType = TextInputType.text,
    this.inputAction,
    this.inputFormatters,
    this.inputAutoFocus = false,
    this.onInputChanged,
    this.okText,
    this.onOk,
    this.cancelText,
    this.onCancel,
    this.dismissOnActionTap = true,
    this.closable = false,
    this.onClose,
    this.warningText,
    this.warningWidget,
    this.footer,
    this.width,
    this.themeData,
  });

  final SantoDialogIconType iconType;
  final Widget? icon;
  final String? title;
  final Widget? titleWidget;
  final int titleMaxLines;
  final String? message;
  final Widget? messageWidget;
  final TextAlign? messageTextAlign;
  final double? messageMaxHeight;
  final bool showInput;
  final String? inputHintText;
  final TextEditingController? inputController;
  final FocusNode? inputFocusNode;
  final int? inputMaxLength;
  final int inputMaxLines;
  final int? inputMinLines;
  final TextInputType inputType;
  final TextInputAction? inputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool inputAutoFocus;
  final ValueChanged<String>? onInputChanged;
  final String? okText;
  final VoidCallback? onOk;
  final String? cancelText;
  final VoidCallback? onCancel;
  final bool dismissOnActionTap;
  final bool closable;
  final VoidCallback? onClose;
  final String? warningText;
  final Widget? warningWidget;
  final Widget? footer;
  final double? width;
  final SantoDialogConfig? themeData;

  @override
  Widget build(BuildContext context) {
    final SantoDialogConfig config = _resolveConfig(themeData);
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final bool hasIcon = icon != null || iconType != SantoDialogIconType.none;
    final bool hasTitle = title != null || titleWidget != null;
    final bool hasMessage = message != null || messageWidget != null;

    return _DialogSurface(
      config: config,
      width: width,
      icon: _buildIcon(config, hasIcon),
      title: _buildTitle(config, commonConfig, hasIcon),
      content: _buildContent(config, commonConfig,
          hasAbove: hasIcon || hasTitle, hasMessage: hasMessage),
      warning: _buildWarning(config, commonConfig,
          hasAbove: hasIcon || hasTitle || hasMessage),
      footer: _buildFooter(context, commonConfig),
      closable: closable,
      onClose: () => _dismissThen(context, onClose, dismissOnActionTap),
    );
  }

  Widget? _buildIcon(SantoDialogConfig config, bool hasIcon) {
    if (!hasIcon) {
      return null;
    }
    final Widget iconWidget = icon ?? _presetIcon(iconType);
    return Center(
      child: Padding(
        padding: config.iconPadding,
        child: SizedBox(width: 36, height: 36, child: iconWidget),
      ),
    );
  }

  Widget? _buildTitle(
      SantoDialogConfig config, SantoCommonConfig commonConfig, bool hasIcon) {
    if (titleWidget != null) {
      return DefaultTextStyle(
        textAlign: config.titleTextAlign,
        style: config.titleTextStyle.generateTextStyle(),
        child: titleWidget!,
      );
    }
    if (title == null) {
      return null;
    }
    return Padding(
      padding: hasIcon ? config.titlePaddingSm : config.titlePaddingLg,
      child: Text(
        title!,
        maxLines: titleMaxLines,
        overflow: TextOverflow.ellipsis,
        textAlign: config.titleTextAlign,
        style: config.titleTextStyle.generateTextStyle(),
      ),
    );
  }

  /// 辅助文案与输入框同属弹窗内容区,两者都存在时纵向排列
  Widget? _buildContent(
    SantoDialogConfig config,
    SantoCommonConfig commonConfig, {
    required bool hasAbove,
    required bool hasMessage,
  }) {
    final List<Widget> items = <Widget>[];
    final Widget? messageChild =
        _buildMessage(config, commonConfig, hasAbove, hasMessage);
    if (messageChild != null) {
      items.add(messageChild);
    }
    if (showInput) {
      items.add(Padding(
        padding: (hasAbove || hasMessage)
            ? config.contentPaddingSm
            : config.contentPaddingLg,
        child: SantoInput(
          controller: inputController,
          hintText: inputHintText,
          maxLength: inputMaxLength,
          maxLines: inputMaxLines,
          minLines: inputMinLines,
          autofocus: inputAutoFocus,
          focusNode: inputFocusNode,
          inputType: inputType,
          inputAction: inputAction,
          inputFormatters: inputFormatters,
          onChanged: onInputChanged,
        ),
      ));
    }
    if (items.isEmpty) {
      return null;
    }
    if (items.length == 1) {
      return items.first;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: items,
    );
  }

  Widget? _buildMessage(SantoDialogConfig config,
      SantoCommonConfig commonConfig, bool hasAbove, bool hasMessage) {
    if (!hasMessage) {
      return null;
    }
    final Widget inner = messageWidget != null
        ? DefaultTextStyle(
            style: config.contentTextStyle.generateTextStyle(),
            child: messageWidget!,
          )
        : Center(
            child: Text(
              message!,
              textAlign: messageTextAlign ?? config.contentTextAlign,
              style: config.contentTextStyle.generateTextStyle(),
            ),
          );
    Widget result = Padding(
      padding: hasAbove ? config.contentPaddingSm : config.contentPaddingLg,
      child: inner,
    );
    if (messageMaxHeight != null) {
      result = ConstrainedBox(
        constraints: BoxConstraints(maxHeight: messageMaxHeight!),
        child: SingleChildScrollView(child: result),
      );
    }
    return result;
  }

  Widget? _buildWarning(SantoDialogConfig config,
      SantoCommonConfig commonConfig, {required bool hasAbove}) {
    if (warningWidget != null) {
      return DefaultTextStyle(
        style: config.warningTextStyle.generateTextStyle(),
        child: warningWidget!,
      );
    }
    if (warningText == null) {
      return null;
    }
    return Padding(
      padding: hasAbove ? config.warningPaddingSm : config.warningPaddingLg,
      child: Text(
        warningText!,
        textAlign: config.warningTextAlign,
        style: config.warningTextStyle.generateTextStyle(),
      ),
    );
  }

  Widget? _buildFooter(BuildContext context, SantoCommonConfig commonConfig) {
    if (footer != null) {
      return footer!;
    }
    final bool hasOk = okText != null;
    final bool hasCancel = cancelText != null;
    if (!hasOk && !hasCancel) {
      return null;
    }
    final bool single = hasOk != hasCancel;
    final List<Widget> buttons = <Widget>[];
    if (hasCancel) {
      buttons.add(_actionButton(
        label: cancelText!,
        main: single,
        onTap: () => _dismissThen(context, onCancel, dismissOnActionTap),
      ));
    }
    if (hasOk) {
      buttons.add(_actionButton(
        label: okText!,
        main: true,
        onTap: () => _dismissThen(context, onOk, dismissOnActionTap),
      ));
    }
    if (buttons.length == 1) {
      return buttons.first;
    }
    return Row(
      children: <Widget>[
        Expanded(child: buttons[0]),
        SizedBox(width: commonConfig.gapMd),
        Expanded(child: buttons[1]),
      ],
    );
  }
}

/// 主操作为实心主色按钮,辅助操作为主色低透明度填充按钮
Widget _actionButton({
  required String label,
  required bool main,
  required VoidCallback onTap,
}) {
  return main
      ? SantoButton(
          text: label,
          type: SantoButtonType.primary,
          size: SantoButtonSize.large,
          block: true,
          onTap: onTap,
        )
      : SantoButton(
          text: label,
          color: SantoButtonColor.primary,
          variant: SantoButtonVariant.filled,
          size: SantoButtonSize.large,
          block: true,
          onTap: onTap,
        );
}

/// 预设图标:提示 / 警示 / 失败 / 成功,统一走 [SantoIcon] 的 solid 实心图标与语义色
Widget _presetIcon(SantoDialogIconType iconType) {
  final SantoCommonConfig commonConfig =
      SantoThemeConfigurator.instance.getConfig().commonConfig;
  switch (iconType) {
    case SantoDialogIconType.none:
      return const SizedBox.shrink();
    case SantoDialogIconType.info:
      return SantoIcon(
        SantoSolidIcons.infoCircle,
        solid: true,
        size: 36,
        color: commonConfig.brandPrimary,
      );
    case SantoDialogIconType.warning:
      return SantoIcon(
        SantoSolidIcons.warningTriangle,
        solid: true,
        size: 36,
        color: commonConfig.brandWarning,
      );
    case SantoDialogIconType.error:
      return SantoIcon(
        SantoSolidIcons.xmarkCircle,
        solid: true,
        size: 36,
        color: commonConfig.brandError,
      );
    case SantoDialogIconType.success:
      return SantoIcon(
        SantoSolidIcons.checkCircle,
        solid: true,
        size: 36,
        color: commonConfig.brandSuccess,
      );
  }
}

/// 强提示形态:图标 / 标题 / 辅助文案 / 纵向主次按钮
class _AlertDialog extends StatelessWidget {
  const _AlertDialog({
    this.iconType = SantoDialogIconType.warning,
    this.icon,
    this.title,
    this.message,
    this.mainButtonText,
    this.secondaryButtonText,
    this.onMainButton,
    this.onSecondaryButton,
    this.closable = false,
    this.onClose,
    this.width,
    this.themeData,
  });

  final SantoDialogIconType iconType;
  final Widget? icon;
  final String? title;
  final String? message;
  final String? mainButtonText;
  final String? secondaryButtonText;
  final VoidCallback? onMainButton;
  final VoidCallback? onSecondaryButton;
  final bool closable;
  final VoidCallback? onClose;
  final double? width;
  final SantoDialogConfig? themeData;

  @override
  Widget build(BuildContext context) {
    final SantoDialogConfig config = _resolveConfig(themeData);
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final Widget? iconWidget = icon ?? _presetIcon(iconType);

    return _DialogSurface(
      config: config,
      width: width,
      icon: iconWidget == null
          ? null
          : Center(
              child: Padding(
                padding: config.iconPadding,
                child: SizedBox(width: 36, height: 36, child: iconWidget),
              ),
            ),
      title: title == null
          ? null
          : Padding(
              padding: iconWidget == null
                  ? config.titlePaddingLg
                  : config.titlePaddingSm,
              child: Text(
                title!,
                textAlign: config.titleTextAlign,
                style: config.titleTextStyle.generateTextStyle(),
              ),
            ),
      content: message == null
          ? null
          : Padding(
              padding: config.contentPaddingSm,
              child: Center(
                child: Text(
                  message!,
                  textAlign: config.contentTextAlign,
                  style: config.contentTextStyle.generateTextStyle(),
                ),
              ),
            ),
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SantoButton(
            text: mainButtonText ?? SantoIntl.of(context).localizedResource.confirm,
            type: SantoButtonType.primary,
            size: SantoButtonSize.large,
            block: true,
            onTap: () => _dismissThen(context, onMainButton, true),
          ),
          if (secondaryButtonText != null) ...<Widget>[
            SizedBox(height: commonConfig.vSpacingMd),
            SantoButton(
              text: secondaryButtonText!,
              color: SantoButtonColor.primary,
              variant: SantoButtonVariant.text,
              size: SantoButtonSize.middle,
              block: true,
              onTap: () => _dismissThen(context, onSecondaryButton, true),
            ),
          ],
        ],
      ),
      closable: closable,
      onClose: () => _dismissThen(context, onClose, true),
    );
  }
}

/// 长文本形态:标题 + CSS2 富文本内容 + 提交按钮
class _RichTextDialog extends StatelessWidget {
  const _RichTextDialog({
    this.title,
    required this.contentText,
    this.textColor,
    this.textFontSize = 16,
    this.submitText,
    this.submitBgColor,
    this.onSubmit,
    this.linksCallback,
    this.isShowOperateWidget = true,
    this.dismissOnSubmit = true,
    this.closable = true,
    this.onClose,
    this.width,
    this.themeData,
  });

  final String? title;
  final String contentText;
  final Color? textColor;
  final double textFontSize;
  final String? submitText;
  final Color? submitBgColor;
  final VoidCallback? onSubmit;
  final SantoHyperLinkCallback? linksCallback;
  final bool isShowOperateWidget;
  final bool dismissOnSubmit;
  final bool closable;
  final VoidCallback? onClose;
  final double? width;
  final SantoDialogConfig? themeData;

  @override
  Widget build(BuildContext context) {
    final SantoDialogConfig config = _resolveConfig(themeData);
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;

    return _DialogSurface(
      config: config,
      width: width,
      title: title == null
          ? null
          : Padding(
              padding: config.titlePaddingLg,
              child: Text(
                title!,
                textAlign: config.titleTextAlign,
                style: config.titleTextStyle.generateTextStyle(),
              ),
            ),
      content: Padding(
        padding: EdgeInsets.fromLTRB(commonConfig.hSpacingMd,
            config.contentPaddingSm.top, commonConfig.hSpacingSm, 0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 220),
          child: Scrollbar(
            radius: const Radius.circular(2.0),
            thickness: 4.0,
            child: Padding(
              padding: EdgeInsets.only(right: commonConfig.hSpacingSm),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SantoCSS2Text.toTextView(
                      contentText,
                      linksCallback: linksCallback,
                      defaultStyle: TextStyle(
                        fontSize: textFontSize,
                        color: textColor ?? commonConfig.colorTextImportant,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      footer: isShowOperateWidget
          ? _submitButton(
              text: submitText ?? SantoIntl.of(context).localizedResource.submit,
              backgroundColor: submitBgColor,
              onTap: () => _dismissThen(context, onSubmit, dismissOnSubmit),
            )
          : null,
      closable: closable,
      onClose: () => _dismissThen(context, onClose, true),
    );
  }
}

/// 底部整行提交按钮
Widget _submitButton({
  required String text,
  Color? backgroundColor,
  required VoidCallback onTap,
}) {
  return SantoButton(
    text: text,
    type: SantoButtonType.primary,
    size: SantoButtonSize.large,
    block: true,
    backgroundColor: backgroundColor,
    onTap: onTap,
  );
}

/// 单选列表形态
class _SingleSelectDialog extends StatefulWidget {
  const _SingleSelectDialog({
    this.title,
    this.message,
    this.messageWidget,
    required this.conditions,
    this.checkedItem,
    this.submitText,
    this.submitBgColor,
    this.onSubmit,
    this.onItemClick,
    this.customWidget,
    this.isCustomFollowScroll = true,
    this.dismissOnSubmit = true,
    this.closable = true,
    this.onClose,
    this.width,
    this.themeData,
  });

  final String? title;
  final String? message;
  final Widget? messageWidget;
  final List<String> conditions;
  final String? checkedItem;
  final String? submitText;
  final Color? submitBgColor;
  final SantoDialogSingleSelectSubmit? onSubmit;
  final SantoDialogSelectItemClick? onItemClick;
  final Widget? customWidget;
  final bool isCustomFollowScroll;
  final bool dismissOnSubmit;
  final bool closable;
  final VoidCallback? onClose;
  final double? width;
  final SantoDialogConfig? themeData;

  @override
  State<_SingleSelectDialog> createState() => _SingleSelectDialogState();
}

class _SingleSelectDialogState extends State<_SingleSelectDialog> {
  String? _checkedItem;

  @override
  void initState() {
    super.initState();
    _checkedItem = widget.checkedItem;
  }

  void _select(int index) {
    setState(() => _checkedItem = widget.conditions[index]);
    widget.onItemClick?.call(context, index);
  }

  @override
  Widget build(BuildContext context) {
    final SantoDialogConfig config = _resolveConfig(widget.themeData);
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final Widget? header =
        _listHeader(config, commonConfig, widget.message, widget.messageWidget);

    return _DialogSurface(
      config: config,
      width: widget.width,
      title: widget.title == null
          ? null
          : Padding(
              padding: config.titlePaddingLg,
              child: Text(
                widget.title!,
                textAlign: config.titleTextAlign,
                style: config.titleTextStyle.generateTextStyle(),
              ),
            ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ?header,
          _buildList(commonConfig),
        ],
      ),
      footer: _submitButton(
        text:
            widget.submitText ?? SantoIntl.of(context).localizedResource.submit,
        backgroundColor: widget.submitBgColor,
        onTap: () => _dismissThen(
          context,
          () => widget.onSubmit?.call(_checkedItem),
          widget.dismissOnSubmit,
        ),
      ),
      closable: widget.closable,
      onClose: () =>
          _dismissThen(context, widget.onClose, widget.dismissOnSubmit),
    );
  }

  Widget _buildList(SantoCommonConfig commonConfig) {
    final List<Widget> items = <Widget>[
      for (int i = 0; i < widget.conditions.length; i++) _buildItem(i),
    ];
    if (widget.customWidget != null) {
      items.add(Padding(
        padding: EdgeInsets.only(
          left: commonConfig.hSpacingMd,
          right: commonConfig.hSpacingMd,
          top: commonConfig.vSpacingMd,
        ),
        child: widget.customWidget,
      ));
    }
    if (widget.isCustomFollowScroll) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 300),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: items,
          ),
        ),
      );
    }
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 300),
      child: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: items,
      ),
    );
  }

  Widget _buildItem(int index) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final bool checked = widget.conditions[index] == _checkedItem;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(
              commonConfig.hSpacingMd, 0, commonConfig.hSpacingMd, 0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _select(index),
                  child: Text(
                    widget.conditions[index],
                    style: TextStyle(
                      fontWeight: checked ? FontWeight.w500 : FontWeight.normal,
                      fontSize: commonConfig.fontSizeSubHead,
                      color: checked
                          ? commonConfig.brandPrimary
                          : commonConfig.colorTextBase,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _select(index),
                child: Container(
                  alignment: Alignment.center,
                  height: 44,
                  child: SantoIcon(
                    checked ? SantoSolidIcons.checkCircle : SantoIcons.circle,
                    solid: checked,
                    size: commonConfig.iconSizeMd,
                    color: checked
                        ? commonConfig.brandPrimary
                        : commonConfig.colorTextDisabled,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (index != widget.conditions.length - 1)
          Padding(
            padding: EdgeInsets.fromLTRB(
                commonConfig.hSpacingMd, 0, commonConfig.hSpacingMd, 0),
            child: SantoLine(),
          ),
      ],
    );
  }
}

/// 多选列表形态
class _MultiSelectDialog extends StatefulWidget {
  const _MultiSelectDialog({
    this.title,
    this.message,
    this.messageWidget,
    required this.conditions,
    this.submitText,
    this.submitBgColor,
    this.onSubmit,
    this.onItemClick,
    this.customWidget,
    this.isCustomFollowScroll = true,
    this.isShowOperateWidget = true,
    this.dismissOnSubmit = true,
    this.closable = true,
    this.onClose,
    this.width,
    this.themeData,
  });

  final String? title;
  final String? message;
  final Widget? messageWidget;
  final List<MultiSelectItem> conditions;
  final String? submitText;
  final Color? submitBgColor;
  final SantoDialogMultiSelectSubmit? onSubmit;
  final SantoDialogSelectItemClick? onItemClick;
  final Widget? customWidget;
  final bool isCustomFollowScroll;
  final bool isShowOperateWidget;
  final bool dismissOnSubmit;
  final bool closable;
  final VoidCallback? onClose;
  final double? width;
  final SantoDialogConfig? themeData;

  @override
  State<_MultiSelectDialog> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<_MultiSelectDialog> {
  void _toggle(int index) {
    setState(() => widget.conditions[index].isChecked =
        !widget.conditions[index].isChecked);
    widget.onItemClick?.call(context, index);
  }

  void _submit() {
    final List<MultiSelectItem> checked = widget.conditions
        .where((MultiSelectItem item) => item.isChecked)
        .toList();
    final bool allow = widget.onSubmit?.call(checked) ?? true;
    if (allow && widget.dismissOnSubmit) {
      Navigator.maybeOf(context)?.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final SantoDialogConfig config = _resolveConfig(widget.themeData);
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final Widget? header =
        _listHeader(config, commonConfig, widget.message, widget.messageWidget);

    return _DialogSurface(
      config: config,
      width: widget.width,
      title: widget.title == null
          ? null
          : Padding(
              padding: config.titlePaddingLg,
              child: Text(
                widget.title!,
                textAlign: config.titleTextAlign,
                style: config.titleTextStyle.generateTextStyle(),
              ),
            ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ?header,
          _buildList(commonConfig),
        ],
      ),
      footer: widget.isShowOperateWidget
          ? _submitButton(
              text: widget.submitText ??
                  SantoIntl.of(context).localizedResource.submit,
              backgroundColor: widget.submitBgColor,
              onTap: _submit,
            )
          : null,
      closable: widget.closable,
      onClose: () =>
          _dismissThen(context, widget.onClose, widget.dismissOnSubmit),
    );
  }

  Widget _buildList(SantoCommonConfig commonConfig) {
    final List<Widget> items = <Widget>[
      for (int i = 0; i < widget.conditions.length; i++) _buildItem(i),
    ];
    if (widget.customWidget != null) {
      items.add(Padding(
        padding: EdgeInsets.only(
          left: commonConfig.hSpacingMd,
          right: commonConfig.hSpacingMd,
          top: commonConfig.vSpacingMd,
        ),
        child: widget.customWidget,
      ));
    }
    if (widget.isCustomFollowScroll) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 300),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: items,
          ),
        ),
      );
    }
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 300),
      child: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: items,
      ),
    );
  }

  Widget _buildItem(int index) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final bool checked = widget.conditions[index].isChecked;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _toggle(index),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                commonConfig.hSpacingMd, 0, commonConfig.hSpacingMd, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    widget.conditions[index].content,
                    style: TextStyle(
                      fontWeight: checked ? FontWeight.w500 : FontWeight.normal,
                      fontSize: commonConfig.fontSizeSubHead,
                      color: checked
                          ? commonConfig.brandPrimary
                          : commonConfig.colorTextBase,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 44,
                  child: SantoIcon(
                    checked ? SantoSolidIcons.checkCircle : SantoIcons.circle,
                    solid: checked,
                    size: commonConfig.iconSizeMd,
                    color: checked
                        ? commonConfig.brandPrimary
                        : commonConfig.colorTextDisabled,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (index != widget.conditions.length - 1)
          Padding(
            padding: EdgeInsets.fromLTRB(
                commonConfig.hSpacingMd, 0, commonConfig.hSpacingMd, 0),
            child: SantoLine(),
          ),
      ],
    );
  }
}

/// 列表形态共用的描述区:描述 widget 优先于描述文案
Widget? _listHeader(
  SantoDialogConfig config,
  SantoCommonConfig commonConfig,
  String? message,
  Widget? messageWidget,
) {
  if (messageWidget != null) {
    return Padding(
      padding: EdgeInsets.only(
        top: config.contentPaddingSm.top,
        bottom: commonConfig.vSpacingMd,
        left: commonConfig.hSpacingMd,
        right: commonConfig.hSpacingMd,
      ),
      child: messageWidget,
    );
  }
  if (SantoTools.isEmpty(message)) {
    return null;
  }
  return Padding(
    padding: EdgeInsets.only(
      top: config.contentPaddingSm.top,
      bottom: commonConfig.vSpacingMd,
      left: commonConfig.hSpacingMd,
      right: commonConfig.hSpacingMd,
    ),
    child: Text(
      message!,
      style: config.contentTextStyle.generateTextStyle(),
    ),
  );
}

/// 分享渠道形态
class _ShareDialog extends StatelessWidget {
  const _ShareDialog({
    this.title,
    this.message,
    this.separatorText,
    required this.shareChannels,
    this.onChannelTap,
    this.getCustomChannelTitle,
    this.getCustomChannelWidget,
    this.shareTextColor,
    this.separatorLineColor,
    this.closable = true,
    this.onClose,
    this.width,
    this.themeData,
  });

  final String? title;
  final String? message;
  final String? separatorText;
  final List<int> shareChannels;
  final SantoDialogShareItemClick? onChannelTap;
  final SantoDialogShareCustomTitle? getCustomChannelTitle;
  final SantoDialogShareCustomIcon? getCustomChannelWidget;
  final Color? shareTextColor;

  /// 分隔线颜色,不传取主题 dividerColorBase
  final Color? separatorLineColor;
  final bool closable;
  final VoidCallback? onClose;
  final double? width;
  final SantoDialogConfig? themeData;

  @override
  Widget build(BuildContext context) {
    final SantoDialogConfig config = _resolveConfig(themeData);
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final Widget? header = _buildHeader(context, config, commonConfig);

    return _DialogSurface(
      config: config,
      width: width,
      title: title == null
          ? null
          : Padding(
              padding: config.titlePaddingLg,
              child: Text(
                title!,
                textAlign: config.titleTextAlign,
                style: config.titleTextStyle.generateTextStyle(),
              ),
            ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ?header,
          Padding(
            padding: EdgeInsets.only(top: commonConfig.gapMd),
            child: _buildChannels(context, config, commonConfig),
          ),
        ],
      ),
      closable: closable,
      onClose: () => _dismissThen(context, onClose, true),
    );
  }

  /// 辅助文案 + 渠道分割线,两者都没有时不占位
  Widget? _buildHeader(
      BuildContext context, SantoDialogConfig config, SantoCommonConfig commonConfig) {
    final List<Widget> items = <Widget>[];
    if (message != null) {
      items.add(Padding(
        padding: config.contentPaddingSm,
        child: Center(
          child: Text(
            message!,
            textAlign: config.contentTextAlign,
            style: config.contentTextStyle.generateTextStyle(),
          ),
        ),
      ));
    }
    items.add(Padding(
      padding: EdgeInsets.only(
          left: commonConfig.hSpacingMd, right: commonConfig.hSpacingMd),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
              color: separatorLineColor ?? commonConfig.dividerColorBase,
              height: 1),
          Container(
            color: config.backgroundColor,
            padding: EdgeInsets.only(
                left: commonConfig.hSpacingXs, right: commonConfig.hSpacingXs),
            child: Text(
              separatorText ??
                  SantoIntl.of(context).localizedResource.shareWayTip,
              style: TextStyle(
                  fontSize: commonConfig.fontSizeCaption,
                  color: shareTextColor ?? commonConfig.colorTextSecondary),
            ),
          ),
        ],
      ),
    ));
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: items,
    );
  }

  Widget _buildChannels(BuildContext context, SantoDialogConfig config,
      SantoCommonConfig commonConfig) {
    final List<Widget> shareItems = <Widget>[];
    for (int index = 0; index < shareChannels.length; index++) {
      final Widget? item = _buildChannel(context, commonConfig, index);
      if (item != null) {
        shareItems.add(item);
      }
    }
    if (shareItems.isEmpty) {
      return const SizedBox.shrink();
    }
    final double dialogWidth = width ?? config.dialogWidth;
    final double space = (shareItems.length >= 5)
        ? 14
        : (dialogWidth - 39 * shareItems.length) / (shareItems.length + 1);
    return Padding(
      padding: EdgeInsets.only(bottom: commonConfig.vSpacingMd),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: space,
        runSpacing: 31,
        children: shareItems,
      ),
    );
  }

  /// 单个分享渠道,渠道名或图标缺失时返回 null 不展示
  Widget? _buildChannel(
      BuildContext context, SantoCommonConfig commonConfig, int index) {
    final int channel = shareChannels[index];
    final String? channelTitle = channel == SantoShareItemConstants.shareCustom
        ? getCustomChannelTitle?.call(index)
        : SantoIntl.of(context).localizedResource.shareChannels[channel];
    final Widget? channelIcon = channel == SantoShareItemConstants.shareCustom
        ? getCustomChannelWidget?.call(index)
        : SantoTools.getAssetImage(
            SantoShareItemConstants.shareItemImagePathList[channel]);
    if (channelTitle == null || channelIcon == null) {
      return null;
    }
    return SizedBox(
      width: 39,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _dismissThen(
              context,
              () => onChannelTap?.call(channel, index),
              true,
            ),
            child: SizedBox(width: 39, height: 39, child: channelIcon),
          ),
          Divider(height: commonConfig.vSpacingXs, color: Colors.transparent),
          Text(
            channelTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: commonConfig.fontSizeCaption,
                color: shareTextColor ?? commonConfig.colorTextSecondary),
          ),
        ],
      ),
    );
  }
}
