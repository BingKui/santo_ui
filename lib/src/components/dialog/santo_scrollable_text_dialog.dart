import 'package:santo_ui/src/components/dialog/santo_content_export_dialog.dart';
import 'package:santo_ui/src/utils/css/santo_core_funtion.dart';
import 'package:santo_ui/src/utils/css/santo_css_2_text.dart';
import 'package:flutter/material.dart';

///  纯文本展示Dialog 超过定高可滚动
///  可有操作区域也可没有皂搓区域
class SantoScrollableTextDialog extends Dialog {
  /// 标题
  final String? title;

  /// 是否可关闭 默认true支持关闭
  final bool isClose;

  /// 中间富文本内容
  final String contentText;

  /// 文字颜色 默认 Color(0xFF666666)
  final Color textColor;

  /// 文字字体大小 默认 16
  final double textFontSize;

  /// 提交按钮文字
  final String? submitText;

  /// 操作按钮背景色
  final Color? submitBgColor;

  /// 提交操作
  final VoidCallback? onSubmitClick;

  /// 富文本超链接点击回调
  final SantoHyperLinkCallback? linksCallback;

  /// 是否展示底部操作区域 默认true展示
  final bool isShowOperateWidget;

  const SantoScrollableTextDialog(
      {this.title,
      this.isClose = true,
      required this.contentText,
      this.textColor = const Color(0xFF666666),
      this.textFontSize = 16,
      this.submitText,
      this.onSubmitClick,
      this.submitBgColor,
      this.linksCallback,
      this.isShowOperateWidget = true});

  @override
  Widget build(BuildContext context) {
    return SantoScrollableText(
        title: title,
        isClose: isClose,
        contentText: contentText,
        textColor: textColor,
        textFontSize: textFontSize,
        submitText: submitText,
        onSubmitClick: onSubmitClick,
        submitBgColor: submitBgColor,
        linksCallback: linksCallback,
        isShowOperateWidget: isShowOperateWidget);
  }
}

class SantoScrollableText extends StatelessWidget {
  /// 标题
  final String? title;

  /// 是否可关闭
  final bool isClose;

  /// 中间富文本内容
  final String contentText;

  /// 文字颜色
  final Color? textColor;

  /// 文字字体
  final double? textFontSize;

  /// 提交按钮文字
  final String? submitText;

  /// 提交操作
  final VoidCallback? onSubmitClick;

  /// 操作按钮背景色
  final Color? submitBgColor;

  /// 富文本超链接点击回调
  final SantoHyperLinkCallback? linksCallback;

  /// 是否展示底部操作区域
  final bool isShowOperateWidget;

  const SantoScrollableText(
      {this.title,
      this.isClose = true,
      required this.contentText,
      this.textColor,
      this.textFontSize,
      this.submitText,
      this.onSubmitClick,
      this.submitBgColor,
      this.linksCallback,
      this.isShowOperateWidget = true});

  @override
  Widget build(BuildContext context) {
    return SantoContentExportWidget(
      Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 8, 0),
        child: Container(
          constraints: BoxConstraints(maxHeight: 220),
          child: Scrollbar(
            radius: Radius.circular(2.0),
            thickness: 4.0,
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  SantoCSS2Text.toTextView(contentText,
                      linksCallback: linksCallback,
                      defaultStyle: TextStyle(
                          fontSize: textFontSize, color: textColor, fontWeight: FontWeight.normal))
                ]),
              ),
            ),
          ),
        ),
      ),
      title: title,
      isClose: isClose,
      submitText: submitText,
      submitBgColor: submitBgColor,
      onSubmit: () {
        if (onSubmitClick != null) {
          onSubmitClick!();
        }
      },
      isShowOperateWidget: isShowOperateWidget,
    );
  }
}
