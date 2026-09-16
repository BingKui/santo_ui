import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 输入框输入变化的监听
typedef SantoInputTextChangeCallback = Function(String input);

/// 输入框提交的监听
typedef SantoInputTextSubmitCallback = Function(String input);

/// 输入完成点击键盘监听
typedef SantoInputTextEditingCompleteCallback = Function(String input);

/// 输入框组件(API 参考 TDesign Flutter Input)
///
/// 支持多行自适应高度、字数限制与计数、清除按钮、前后缀插槽、
/// 密码显隐、只读/禁用、聚焦边框高亮等能力。
class SantoInputText extends StatefulWidget {
  /// 输入内容变化回调
  final SantoInputTextChangeCallback? onTextChange;

  /// 点击确定后的回调
  final SantoInputTextSubmitCallback? onSubmit;

  /// 容器的最大高度,默认 200
  final double maxHeight;

  /// 最小的高度,默认 50
  final double minHeight;

  /// 整个容器的背景颜色,默认 Colors.white
  final Color bgColor;

  /// 输入框的hint文字,默认为"请输入..."
  final String? hint;

  /// 输入框的初始值,默认为""
  /// 不能定义为String,兼容example调用的传值
  final String textString;

  /// 用于对 TextField 更精细的控制,若传入该字段,[textString] 参数将失效,可使用 TextEditingController.text 进行赋值。
  final TextEditingController? textEditingController;

  /// 最大字数,默认200
  final int maxLength;

  /// 最少几行,默认1
  final int minLines;

  /// 最大行数,默认 null 自适应高度;固定行数时传具体值
  final int? maxLines;

  /// 文字距离边框的边距,默认 EdgeInsets.zero
  final EdgeInsetsGeometry padding;

  /// 最大hint行数
  final int? maxHintLines;

  /// 焦点控制器
  final FocusNode? focusNode;

  /// 键盘输入行为, 默认为 TextInputAction.done
  final TextInputAction textInputAction;

  /// 键盘类型,默认 TextInputType.multiline
  final TextInputType inputType;

  /// 光标展示
  final bool? autoFocus;

  /// 是否隐藏输入文本(密码模式)
  final bool obscureText;

  /// 是否在后置插槽显示内置密码显隐按钮,仅单行输入生效;
  /// 传入 [suffix] 时自定义后置内容紧跟在该按钮之后
  final bool showPasswordToggle;

  /// 是否只读;为 true 时禁止修改内容,但保留文本选择和复制能力
  final bool readOnly;

  /// 是否可交互;为 false 时禁用输入框,文字使用禁用态颜色
  final bool enabled;

  /// 前缀组件,显示在输入区左侧
  final Widget? prefix;

  /// 后缀组件;传入后不显示内置清除按钮
  final Widget? suffix;

  /// 是否显示内置清除按钮(有内容时展示),默认 true;传入 [suffix] 时不显示
  final bool needClear;

  /// 是否显示当前字数计数,默认 true
  final bool showCounter;

  /// 光标颜色,默认主题品牌色
  final Color? cursorColor;

  /// 输入文本样式,默认 16 号正文色
  final TextStyle? textStyle;

  /// 背景圆角
  final double? borderRadius;

  /// 边框颜色
  final Color? borderColor;

  /// 聚焦时边框颜色,用于聚焦高亮
  final Color? focusedBorderColor;

  /// 输入格式化器
  final List<TextInputFormatter>? inputFormatters;

  SantoInputText({
    Key? key,
    this.onTextChange,
    this.onSubmit,
    this.maxHeight = 200,
    this.minHeight = 50,
    this.bgColor = Colors.white,
    this.maxLength = 200,
    this.minLines = 1,
    this.maxLines,
    this.hint,
    this.maxHintLines,
    this.padding = EdgeInsets.zero,
    this.textString = "",
    this.autoFocus,
    this.textEditingController,
    this.focusNode,
    this.textInputAction = TextInputAction.done,
    this.inputType = TextInputType.multiline,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.readOnly = false,
    this.enabled = true,
    this.prefix,
    this.suffix,
    this.needClear = true,
    this.showCounter = true,
    this.cursorColor,
    this.textStyle,
    this.borderRadius,
    this.borderColor,
    this.focusedBorderColor,
    this.inputFormatters,
  }) : super(key: key);

  @override
  State<SantoInputText> createState() => _SantoInputTextState();
}

class _SantoInputTextState extends State<SantoInputText> {
  TextEditingController? _internalController;
  FocusNode? _internalFocusNode;
  bool _focused = false;
  bool _hasText = false;

  /// 密码显隐状态,初始由 [SantoInputText.obscureText] 决定
  late bool _obscure = widget.obscureText;

  CommonConfig get _commonConfig =>
      SantoThemeConfigurator.instance.getConfig().commonConfig;

  bool get _interactive => widget.enabled && !widget.readOnly;

  bool get _useInternalController => widget.textEditingController == null;

  TextEditingController get _controller =>
      widget.textEditingController ?? _internalController!;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode!;

  /// 内置密码显隐按钮和清除按钮都占据后置插槽
  bool get _showPasswordToggle =>
      widget.showPasswordToggle &&
      widget.obscureText &&
      (widget.maxLines ?? 1) == 1 &&
      widget.minLines <= 1;

  bool get _showClear =>
      widget.needClear &&
      widget.suffix == null &&
      !_showPasswordToggle &&
      _interactive &&
      _hasText;

  @override
  void initState() {
    super.initState();
    String textData = widget.textString;
    if (textData.runes.length > widget.maxLength) {
      textData = String.fromCharCodes(
          textData.runes, 0, _runeOffsetForMax(textData));
    }
    if (_useInternalController) {
      _internalController = TextEditingController.fromValue(TextEditingValue(
        text: textData,
        selection: TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream, offset: textData.length)),
      ));
      _internalController!.addListener(_onControllerChanged);
    }
    _hasText = _controller.text.isNotEmpty;
    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode();
      _internalFocusNode!.addListener(_onFocusChanged);
    }
    _focused = _focusNode.hasFocus;
  }

  /// 截断到不超过 maxLength 的最长前缀(按 code point)
  int _runeOffsetForMax(String text) {
    int count = 0;
    int offset = 0;
    for (final rune in text.runes) {
      if (count >= widget.maxLength) break;
      count++;
      offset += rune > 0xFFFF ? 2 : 1;
    }
    return offset;
  }

  void _onControllerChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _onFocusChanged() {
    if (_focused != _focusNode.hasFocus) {
      setState(() => _focused = _focusNode.hasFocus);
    }
  }

  @override
  void didUpdateWidget(SantoInputText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.obscureText != oldWidget.obscureText) {
      _obscure = widget.obscureText;
    }
    if (_useInternalController &&
        widget.textString != oldWidget.textString &&
        widget.textString != _controller.text) {
      _controller.text = widget.textString;
    }
  }

  @override
  void dispose() {
    _internalController?.removeListener(_onControllerChanged);
    _internalController?.dispose();
    _internalFocusNode?.removeListener(_onFocusChanged);
    _internalFocusNode?.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onTextChange?.call('');
  }

  Color? get _effectiveBorderColor {
    if (_focused && widget.focusedBorderColor != null) {
      return widget.focusedBorderColor;
    }
    return widget.borderColor;
  }

  @override
  Widget build(BuildContext context) {
    Widget inputField = _buildTextField(context);
    if (!widget.enabled) {
      inputField = IgnorePointer(child: inputField);
    } else if (widget.readOnly) {
      inputField = IgnorePointer(child: inputField);
    }

    final children = <Widget>[
      if (widget.prefix != null) ...[
        widget.prefix!,
        const SizedBox(width: 8),
      ],
      Expanded(child: inputField),
      if (_showClear)
        _buildClearButton()
      else if (_showPasswordToggle) ...[
        _buildPasswordToggle(),
        if (widget.suffix != null) const SizedBox(width: 8),
      ],
      if (widget.suffix != null) widget.suffix!,
    ];

    return Container(
      decoration: BoxDecoration(
        color: widget.bgColor,
        border: Border.all(color: _effectiveBorderColor ?? Colors.transparent),
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
      ),
      padding: widget.padding,
      constraints: BoxConstraints(
        maxHeight: widget.maxHeight,
        minHeight: widget.minHeight,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    final disabled = !widget.enabled;
    return Center(
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        keyboardType: widget.inputType,
        textInputAction: widget.textInputAction,
        maxLength: widget.maxLength,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        maxLines: widget.obscureText ? 1 : widget.maxLines,
        minLines: widget.minLines,
        autofocus: widget.autoFocus ?? true,
        readOnly: widget.readOnly,
        obscureText: _obscure,
        enabled: widget.enabled,
        inputFormatters: widget.inputFormatters,
        cursorColor: widget.cursorColor ?? _commonConfig.brandPrimary,
        textAlign: TextAlign.left,
        style: (widget.textStyle ??
                TextStyle(
                  fontSize: 16,
                  color: _commonConfig.colorTextBase,
                ))
            .copyWith(
          color: disabled ? _commonConfig.colorTextDisabled : null,
        ),
        buildCounter: (
          BuildContext context, {
          required int currentLength,
          required int? maxLength,
          required bool isFocused,
        }) {
          if (!widget.showCounter) return const SizedBox.shrink();
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                "$currentLength",
                style: TextStyle(
                  color: (currentLength == 0
                      ? _commonConfig.colorTextHint
                      : _commonConfig.colorTextSecondary),
                  fontSize: 16,
                ),
              ),
              Text(
                "/$maxLength",
                style: TextStyle(
                  color: _commonConfig.colorTextHint,
                  fontSize: 16,
                ),
              ),
            ],
          );
        },
        decoration: InputDecoration(
          hintText: widget.hint ??
              SantoIntl.of(context).localizedResource.pleaseEnter,
          hintMaxLines: widget.maxHintLines,
          hintStyle: TextStyle(
            fontSize: 16.0,
            color: disabled
                ? _commonConfig.colorTextDisabled
                : _commonConfig.colorTextHint,
          ),
          contentPadding: EdgeInsets.all(0),
          border: InputBorder.none,
          isDense: true,
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
        ),
        onSubmitted: (text) {
          widget.onSubmit?.call(text);
        },
        onChanged: (text) {
          widget.onTextChange?.call(text);
        },
      ),
    );
  }

  /// 内置清除按钮
  Widget _buildClearButton() {
    return GestureDetector(
      onTap: _clear,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(Icons.cancel,
            size: 18, color: _commonConfig.colorTextHint),
      ),
    );
  }

  /// 内置密码显隐按钮
  Widget _buildPasswordToggle() {
    return GestureDetector(
      onTap: () => setState(() => _obscure = !_obscure),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(
          _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          size: 20,
          color: _commonConfig.colorTextHint,
        ),
      ),
    );
  }
}
