import 'package:santo_ui/src/components/button/santo_button.dart';
import 'package:santo_ui/src/components/chat/model/santo_chat_message.dart';
import 'package:santo_ui/src/components/chat/santo_chat_quote_view.dart';
import 'package:santo_ui/src/components/icon/santo_icon.dart';
import 'package:santo_ui/src/components/icon/santo_icons.dart';
import 'package:santo_ui/src/theme/configs/santo_chat_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 会话底部输入区
///
/// 白底铺满整个底部安全区域,内容在安全区之上避让,安全区固定预留、不提供开关。
/// [leading]/[trailing] 是留给业务方的插槽(语音、表情、更多等),组件不内置面板。
///
/// @since v1.5.0
class SantoChatInput extends StatefulWidget {
  /// 文本控制器,不传时组件内部创建
  final TextEditingController? controller;

  /// 焦点控制器
  final FocusNode? focusNode;

  /// 点击发送回调,回调后组件会清空输入框
  final ValueChanged<String>? onSend;

  /// 输入框提示文案
  final String hintText;

  /// 是否可输入
  final bool enabled;

  /// 输入框最多行数,超过后内部滚动
  final int maxLines;

  /// 输入框左侧插槽,如语音按钮
  final Widget? leading;

  /// 输入框右侧插槽,如表情、更多
  final Widget? trailing;

  /// 自定义发送按钮,不传使用主按钮「发送」
  final Widget? sendButton;

  /// 输入内容变化回调
  final ValueChanged<String>? onChanged;

  /// 当前回复的消息,不为空时在输入框上方展示回复条
  final SantoChatQuote? replyTo;

  /// 取消回复回调
  final VoidCallback? onCancelReply;

  const SantoChatInput({
    Key? key,
    this.controller,
    this.focusNode,
    this.onSend,
    this.hintText = '请输入内容',
    this.enabled = true,
    this.maxLines = 4,
    this.leading,
    this.trailing,
    this.sendButton,
    this.onChanged,
    this.replyTo,
    this.onCancelReply,
  }) : super(key: key);

  @override
  State<SantoChatInput> createState() => _SantoChatInputState();
}

class _SantoChatInputState extends State<SantoChatInput> {
  TextEditingController? _internalController;

  TextEditingController get _controller =>
      widget.controller ?? (_internalController ??= TextEditingController());

  @override
  void dispose() {
    _internalController?.dispose();
    super.dispose();
  }

  void _handleSend() {
    if (!widget.enabled) return;
    final String text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend?.call(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final SantoChatConfig config =
        SantoThemeConfigurator.instance.getConfig().chatConfig;

    return Container(
      color: config.inputBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: config.commonConfig.borderWidthSm,
            color: config.commonConfig.dividerColorBase,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: config.commonConfig.hSpacingMd,
              vertical: config.commonConfig.vSpacingSm,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (widget.replyTo != null)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: config.commonConfig.vSpacingSm,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: SantoChatQuoteView(quote: widget.replyTo!),
                        ),
                        SizedBox(width: config.commonConfig.hSpacingSm),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: widget.onCancelReply,
                          child: SantoIcon(
                            SantoIcons.xmark,
                            size: config.commonConfig.iconSizeMd,
                            color: config.commonConfig.colorTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    if (widget.leading != null) ...<Widget>[
                      widget.leading!,
                      SizedBox(width: config.commonConfig.hSpacingSm),
                    ],
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: config.commonConfig.hSpacingSm,
                          vertical: config.commonConfig.vSpacingXs,
                        ),
                        decoration: BoxDecoration(
                          color: config.backgroundColor,
                          borderRadius:
                              BorderRadius.circular(config.commonConfig.radiusMd),
                        ),
                        child: TextField(
                          controller: _controller,
                          focusNode: widget.focusNode,
                          enabled: widget.enabled,
                          minLines: 1,
                          maxLines: widget.maxLines,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _handleSend(),
                          onChanged: widget.onChanged,
                          cursorColor: config.myBubbleColor,
                          style: config.inputTextStyle.generateTextStyle(),
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            hintText: widget.hintText,
                            hintStyle:
                                config.inputHintTextStyle.generateTextStyle(),
                          ),
                        ),
                      ),
                    ),
                    if (widget.trailing != null) ...<Widget>[
                      SizedBox(width: config.commonConfig.hSpacingSm),
                      widget.trailing!,
                    ],
                    SizedBox(width: config.commonConfig.hSpacingSm),
                    widget.sendButton ??
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _controller,
                          builder: (
                            BuildContext context,
                            TextEditingValue value,
                            Widget? child,
                          ) {
                            return SantoButton(
                              text: '发送',
                              type: SantoButtonType.primary,
                              size: SantoButtonSize.middle,
                              isEnable: widget.enabled &&
                                  value.text.trim().isNotEmpty,
                              onTap: _handleSend,
                            );
                          },
                        ),
                  ],
                ),
              ],
            ),
          ),
          // 底部安全区固定预留,不可配置
          SizedBox(height: MediaQuery.paddingOf(context).bottom),
        ],
      ),
    );
  }
}
