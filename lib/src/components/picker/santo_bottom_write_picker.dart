import 'package:santo_ui/src/components/picker/base/santo_picker_title_config.dart';
import 'package:santo_ui/src/components/picker/santo_bottom_picker.dart';
import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

///取消输入事件回调
typedef SantoBottomWritePickerClickCallback = Future<void>? Function(
    String? content);

///确认输入事件回调
typedef SantoBottomWritePickerConfirmClickCallback = Future<void>? Function(
    BuildContext dialogContext, String? content);

class SantoBottomWritePicker extends StatefulWidget {
  /// 弹窗左边自定义文案，默认 '取消'
  final String? leftTag;

  /// 弹窗自定义标题
  final String title;

  /// 弹窗右边自定义文案，默认 '确认'
  final String? rightTag;

  /// 输入框默认提示文案，默认'请输入'
  final String? hintText;

  /// 输入框最大能输入的字符长度，默认 200
  final int maxLength;

  /// 取消输入事件回调
  final SantoBottomWritePickerClickCallback? onCancel;

  /// 确认输入内容事件回调
  final SantoBottomWritePickerConfirmClickCallback? onConfirm;

  /// 弹窗右边文案颜色
  final Color? rightTextColor;

  /// 光标颜色
  final Color? cursorColor;

  /// 默认文本
  final String? defaultText;

  /// 用于对 TextField  更精细的控制，若传入该字段，[defaultText] 参数将失效，可使用 TextEditingController.text 进行赋值。
  final TextEditingController? textEditingController;

  const SantoBottomWritePicker(
      {this.maxLength = 200,
      this.hintText,
      this.leftTag,
      this.title = "",
      this.rightTag,
      this.onCancel,
      this.onConfirm,
      this.rightTextColor,
      this.cursorColor,
      this.defaultText,
      this.textEditingController});

  @override
  State<StatefulWidget> createState() {
    return _BottomWritePickerState();
  }

  static void show(BuildContext context,
      {int maxLength = 200,
      String? hintText,
      String? leftTag,
      String title = "",
      String? rightTag,
      SantoBottomWritePickerClickCallback? onCancel,
      SantoBottomWritePickerConfirmClickCallback? onConfirm,
      bool confirmDismiss = false,
      bool cancelDismiss = true,
      Color? rightTextColor,
      Color? cursorColor,
      String? defaultText,
      TextEditingController? textEditingController}) {
    final ThemeData theme = Theme.of(context);
    showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          final Widget pageChild = SantoBottomWritePicker(
            maxLength: maxLength,
            hintText: hintText ?? SantoIntl.of(context).localizedResource.pleaseEnter,
            leftTag: leftTag ?? SantoIntl.of(context).localizedResource.cancel,
            title: title,
            rightTag: rightTag ?? SantoIntl.of(context).localizedResource.ok,
            onConfirm: onConfirm,
            onCancel: onCancel,
            rightTextColor: rightTextColor ??
                SantoThemeConfigurator.instance
                    .getConfig()
                    .commonConfig
                    .brandPrimary,
            cursorColor: cursorColor ??
                SantoThemeConfigurator.instance
                    .getConfig()
                    .commonConfig
                    .brandPrimary,
            defaultText: defaultText,
            textEditingController: textEditingController,
          );
          return Theme(data: theme, child: pageChild);
        });
  }
}

class _BottomWritePickerState extends State<SantoBottomWritePicker> {
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    if (_controller == null) {
      if (widget.defaultText != null && widget.defaultText!.isNotEmpty) {
        _controller = TextEditingController.fromValue(TextEditingValue(
            text: widget.defaultText!,
            selection: TextSelection.fromPosition(TextPosition(
                affinity: TextAffinity.downstream,
                offset: widget.defaultText!.length))));
      } else {
        _controller = TextEditingController();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SantoBottomPickerWidget(
      contentWidget: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
        color: Colors.white,
        child: TextField(
            style: TextStyle(
                fontSize: 16,
                color: SantoThemeConfigurator.instance
                    .getConfig()
                    .commonConfig
                    .colorTextBase),
            controller: _controller,
            autofocus: true,
            maxLines: 8,
            maxLength: widget.maxLength,
            cursorColor: widget.cursorColor,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(
                  fontSize: 16,
                  color: SantoThemeConfigurator.instance
                      .getConfig()
                      .commonConfig
                      .colorTextHint),
              counterStyle: TextStyle(
                  fontSize: 16,
                  color: SantoThemeConfigurator.instance
                      .getConfig()
                      .commonConfig
                      .colorTextHint),
              hintText: widget.hintText ?? SantoIntl.of(context).localizedResource.pleaseEnter,
            )),
      ),
      pickerTitleConfig: SantoPickerTitleConfig(
        titleContent: widget.title,
      ),
      confirm: _buildRightTag(context),
      cancel: widget.leftTag ?? SantoIntl.of(context).localizedResource.cancel,
      onConfirmPressed: () {
        if (widget.onConfirm != null) {
          widget.onConfirm!(context, _controller?.text);
        }
      },
      onCancelPressed: () {
        if (widget.onCancel != null) {
          widget.onCancel!(_controller?.text);
        }
      },
      barrierDismissible: true,
    );
  }

  //此处返回类型为dynamic，在build的时候，会判读具体类型
  dynamic _buildRightTag(BuildContext context) {
    if (widget.rightTextColor != null) {
      return Text(
        widget.rightTag ?? SantoIntl.of(context).localizedResource.ok,
        style: TextStyle(
          fontSize: 16.0,
          color: widget.rightTextColor,
        ),
      );
    } else {
      return widget.rightTag;
    }
  }
}
