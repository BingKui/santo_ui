import 'package:santo_ui/src/components/dialog/santo_dialog_utils.dart';
import 'package:santo_ui/src/components/line/santo_line.dart';
import 'package:santo_ui/src/constants/santo_asset_constants.dart';
import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_dialog_config.dart';
import 'package:santo_ui/src/utils/santo_tools.dart';
import 'package:flutter/material.dart';

import 'santo_dialog.dart';

typedef SantoSingleSelectOnSubmitCallback = Function(String? data);
typedef SantoSingleSelectOnItemClickCallback = void Function(
    BuildContext dialogContext, int index);

/// 单选列表弹框
class SantoSingleSelectDialog extends Dialog {
  /// 用于控制是否可以响应点击外部关闭弹窗，true 关闭，false 不关闭，默认 true
  final bool isClose;

  /// 弹窗标题
  final String title;

  /// 描述文案，优先级较 messageWidget 低，优先使用 messageWidget
  final String? messageText;

  /// 描述widget
  final Widget? messageWidget;

  /// 时间区间最大值
  final List<String> conditions;

  /// 确定/提交 按钮文案，默认 '提交'
  final String? submitText;

  /// 提交按钮点击回调
  final SantoSingleSelectOnSubmitCallback? onSubmit;

  /// item 点击回调
  final SantoSingleSelectOnItemClickCallback? onItemClick;

  /// 提交按钮背景颜色
  final Color? submitBgColor;

  /// 选中的选项名称
  final String? checkedItem;

  /// 单选列表底部自定义 Widget
  final Widget? customWidget;

  /// 内容是否可滑动。默认为 true
  final bool isCustomFollowScroll;

  /// 是否在点击时让 Diallog 消失，默认为 true
  final bool canDismissOnConfirmClick;

  /// 点击关闭按钮回调
  final VoidCallback? onCloseClick;

  const SantoSingleSelectDialog(
      {this.isClose = true,
      this.title = "",
      this.messageText,
      this.messageWidget,
      required this.conditions,
      this.submitText,
      this.submitBgColor,
      this.onSubmit,
      this.onItemClick,
      this.checkedItem,
      this.customWidget,
      this.onCloseClick,
      this.canDismissOnConfirmClick = true,
      this.isCustomFollowScroll = true});

  @override
  Widget build(BuildContext context) {
    return SantoSingleSelectDialogWidget(
      isClose: isClose,
      title: title,
      messageText: messageText,
      messageWidget: messageWidget,
      conditions: conditions,
      submitText: submitText ?? SantoIntl.of(context).localizedResource.submit,
      onSubmit: onSubmit,
      onItemClick: onItemClick,
      submitBgColor: submitBgColor,
      checkedItem: checkedItem,
      customWidget: customWidget,
      canDismissOnConfirmClick: canDismissOnConfirmClick,
      isCustomFollowScroll: isCustomFollowScroll,
      onCloseClick: onCloseClick,
    );
  }
}

/// 单选列表弹框 widget
// ignore: must_be_immutable
class SantoSingleSelectDialogWidget extends StatefulWidget {
  final bool isClose;
  final String title;
  final String? messageText;
  final Widget? messageWidget;
  final List<String>? conditions;
  final String submitText;
  final SantoSingleSelectOnSubmitCallback? onSubmit;
  final SantoSingleSelectOnItemClickCallback? onItemClick; //可供埋点需求用
  final Color? submitBgColor;
  String? checkedItem; // 选择项目

  final Widget? customWidget;

  final bool isCustomFollowScroll;

  final bool canDismissOnConfirmClick;

  /// 点击关闭按钮回调
  final VoidCallback? onCloseClick;

  SantoDialogConfig? themeData;

  SantoSingleSelectDialogWidget(
      {this.isClose = true,
      this.title = "",
      this.messageText,
      this.messageWidget,
      this.conditions,
      this.submitText = "",
      this.submitBgColor,
      this.onSubmit,
      this.onItemClick,
      this.checkedItem,
      this.customWidget,
      this.onCloseClick,
      this.isCustomFollowScroll = true,
      this.canDismissOnConfirmClick = true,
      this.themeData}) {
    this.themeData ??= SantoDialogConfig();
    this.themeData = SantoThemeConfigurator.instance
        .getConfig(configId: themeData!.configId)
        .dialogConfig
        .merge(themeData);
  }

  @override
  State<StatefulWidget> createState() {
    return SantoSingleSelectDialogWidgetState();
  }
}

class SantoSingleSelectDialogWidgetState
    extends State<SantoSingleSelectDialogWidget> {
  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Scaffold(
        backgroundColor: Color(0x33808695),
        body: Container(
            alignment: Alignment.center,
            child: Container(
              constraints: BoxConstraints(maxWidth: 300),
              decoration: BoxDecoration(
                //背景
                color: widget.themeData?.backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(
                    SantoDialogUtils.getDialogRadius(
                        widget.themeData!))), //设置四周圆角 角度
              ),
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(commonConfig.hSpacingLg,
                            commonConfig.vSpacingLg, commonConfig.hSpacingLg, 12),
                        child: Text(
                          widget.title,
                          style: SantoDialogUtils.getDialogTitleStyle(
                              widget.themeData!),
                        ),
                      ),
                      _generateContentWidget(),
                      Container(
                        constraints: BoxConstraints(maxHeight: 300),
                        child: widget.isCustomFollowScroll
                            ? SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) =>
                                            _buildItem(context, index),
                                        itemCount:
                                            widget.conditions?.length ?? 0),
                                    widget.customWidget != null
                                        ? Container(
                                            child: widget.customWidget,
                                            padding: EdgeInsets.only(
                                                left: commonConfig.hSpacingLg,
                                                right: commonConfig.hSpacingLg,
                                                top: 12),
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                              )
                            : Column(
                                children: <Widget>[
                                  Expanded(
                                    child: ListView.builder(
                                        itemBuilder: (context, index) =>
                                            _buildItem(context, index),
                                        itemCount:
                                            widget.conditions?.length ?? 0),
                                  ),
                                  widget.customWidget != null
                                      ? Container(
                                          child: widget.customWidget,
                                          padding: EdgeInsets.only(
                                              left: commonConfig.hSpacingLg,
                                              right: commonConfig.hSpacingLg,
                                              top: 12),
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(
                              commonConfig.hSpacingLg,
                              12,
                              commonConfig.hSpacingLg,
                              commonConfig.vSpacingLg),
                          child: GestureDetector(
                            child: Container(
                                decoration: BoxDecoration(
                                  //背景
                                  color: SantoThemeConfigurator.instance
                                      .getConfig()
                                      .commonConfig
                                      .brandPrimary,
                                  borderRadius: BorderRadius.all(Radius.circular(
                                      commonConfig.radiusXs)), //设置四周圆角 角度
                                ),
                                alignment: Alignment.center,
                                height: 48,
                                color: widget.submitBgColor,
                                child: Text(widget.submitText,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: commonConfig.fontSizeHead))),
                            onTap: () {
                              if (widget.canDismissOnConfirmClick) {
                                Navigator.of(context).pop();
                              }
                              if (widget.onSubmit != null) {
                                widget.onSubmit!(widget.checkedItem);
                              }
                            },
                          ))
                    ],
                  ),
                  widget.isClose
                      ? Positioned(
                          right: 0.0,
                          child: GestureDetector(
                              onTap: () {
                                if (widget.onCloseClick != null) {
                                  widget.onCloseClick!();
                                } else {
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Padding(
                                padding:
                                    EdgeInsets.all(commonConfig.vSpacingMd),
                                child: SantoTools.getAssetImage(
                                    SantoAsset.iconPickerClose),
                              )))
                      : const SizedBox.shrink()
                ],
              ),
            )));
  }

  /// 内容widget 以 messageWidget 为准，
  /// 若无则以 messageText 生成widget 填充，
  /// 都没设置则为空 Container
  Widget _generateContentWidget() {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    if (widget.messageWidget != null) {
      return Padding(
        padding: EdgeInsets.only(
            bottom: commonConfig.vSpacingSm,
            left: commonConfig.hSpacingLg,
            right: commonConfig.hSpacingLg),
        child: widget.messageWidget,
      );
    }

    if (!SantoTools.isEmpty(widget.messageText)) {
      return Padding(
        padding: EdgeInsets.only(
            bottom: commonConfig.vSpacingSm,
            left: commonConfig.hSpacingLg,
            right: commonConfig.hSpacingLg),
        child: Text(
          widget.messageText!,
          style: cContentTextStyle,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildItem(BuildContext context, int index) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    if (widget.conditions == null) {
      return const SizedBox.shrink();
    } else {
      return Container(
          child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(commonConfig.hSpacingLg, 0,
                commonConfig.hSpacingLg, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    setState(() {
                      for (dynamic item in widget.conditions!) {
                        if (widget.conditions![index] == item) {
                          if (widget.onItemClick != null &&
                              widget.checkedItem != item) {
                            widget.onItemClick!(context, index);
                          }
                          widget.checkedItem = item;
                          break;
                        }
                      }
                    });
                  },
                  child: Text(widget.conditions![index],
                      style: TextStyle(
                          fontWeight:
                              widget.conditions![index] == widget.checkedItem
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                          fontSize: commonConfig.fontSizeSubHead,
                          color: widget.conditions![index] == widget.checkedItem
                              ? SantoThemeConfigurator.instance
                                  .getConfig()
                                  .commonConfig
                                  .brandPrimary
                              : SantoThemeConfigurator.instance
                                  .getConfig()
                                  .commonConfig
                                  .colorTextBase)),
                )),
                GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    height: 44,
                    child: widget.checkedItem == widget.conditions![index]
                        ? SantoTools.getAssetImageWithBandColor(
                            SantoAsset.iconSingleSelected)
                        : SantoTools.getAssetImage(SantoAsset.iconUnSelect),
                  ),
                  onTap: () {
                    if (widget.onItemClick != null) {
                      widget.onItemClick!(context, index);
                    }
                    setState(() {
                      widget.checkedItem = widget.conditions![index];
                    });
                  },
                )
              ],
            ),
          ),
          index != widget.conditions!.length - 1
              ? Padding(
                  padding: EdgeInsets.fromLTRB(commonConfig.hSpacingLg, 0,
                      commonConfig.hSpacingLg, 0),
                  child: SantoLine())
              : const SizedBox.shrink()
        ],
      ));
    }
  }
}
