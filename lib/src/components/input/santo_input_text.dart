import 'dart:math' as math;

import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 单行输入框的内容区高度，左右插槽在此高度内居中，不撑高输入框
const double _singleLineHeight = 44;

/// 输入框清除按钮的显示模式
enum SantoInputClearButtonMode {
  /// 从不显示清除按钮
  never,

  /// 有文本时显示清除按钮
  always,

  /// 输入框获得焦点且有文本时显示清除按钮
  focused,
}

/// 输入框的语义状态
///
/// 状态不改变已输入文字的正文色
enum SantoInputStatus {
  /// 默认状态
  normal,

  /// 成功状态
  success,

  /// 警告状态
  warning,

  /// 错误状态
  error,
}

/// 输入内容的类型限制，同时决定键盘类型与输入过滤
enum SantoInputFormat {
  /// 不限制
  text,

  /// 纯数字
  digit,

  /// 数字，可含小数点和负号
  number,

  /// 身份证号（数字与 X）
  idCard,

  /// 手机号（数字与 + - 空格）
  phone,

  /// 邮箱字符（字母、数字与常见符号）
  email,
}

/// 基于 Flutter [TextField] 编辑内核的文本输入框
///
/// API 参考 TDesign Flutter TInput
///
/// [controller] 是主控制路径；未传时由组件创建内部 controller，并使用
/// [initialValue] 初始化一次。两者不能同时传入。
class SantoInputText extends StatefulWidget {
  /// 文本控制器
  final TextEditingController? controller;

  /// 内部控制器的初始文本，仅初始化一次
  final String? initialValue;

  /// 文本变化通知
  final ValueChanged<String>? onChanged;

  /// 提交回调
  final ValueChanged<String>? onSubmitted;

  /// 编辑完成回调
  final VoidCallback? onEditingComplete;

  /// 是否可交互；为 false 时禁止编辑、聚焦和选择，并使用禁用态文字颜色
  final bool enabled;

  /// 是否只读；为 true 时禁止修改内容，但保留只读文本的选择和复制能力
  final bool readOnly;

  /// 占位提示文案
  final String? hintText;

  /// 输入框左侧标签文案
  final String? label;

  /// 是否必填，为 true 时在 [label] 前显示红色星号
  final bool required;

  /// 左侧标签宽度，为空时按内容自适应
  final double? labelWidth;

  /// 前缀组件
  final Widget? prefix;

  /// 后缀组件；传入后不显示内置清除按钮
  final Widget? suffix;

  /// 右侧标识文案，如单位"元"、"个"
  final String? suffixText;

  /// 右侧标识文案样式
  final TextStyle? suffixTextStyle;

  /// 右侧图标
  final Widget? suffixIcon;

  /// 右侧按钮，如"获取验证码"
  final Widget? suffixButton;

  /// 输入内容的类型限制，限制输入为纯数字等；与 [inputType] 同时使用时，
  /// 非 [SantoInputFormat.text] 的键盘类型以本字段为准
  final SantoInputFormat inputFormat;

  /// 清除按钮显示模式，默认 [SantoInputClearButtonMode.never]
  final SantoInputClearButtonMode? clearButtonMode;

  /// 输入框语义状态，状态色用于输入壳层、计数器和边框
  final SantoInputStatus status;

  /// 是否隐藏输入框边框
  final bool borderless;

  /// 最大行数，默认 1
  final int? maxLines;

  /// 最小行数
  final int? minLines;

  /// 最大字符数，使用 Flutter grapheme 计数语义
  final int? maxLength;

  /// 最大字符权重，按 Unicode code point 计算：ASCII code point 计 1，
  /// 非 ASCII code point 计 2
  ///
  /// 与 [maxLength] 二选一。提交中的文本超过限制时，保留不超过限制的
  /// 最长前缀；输入法正在 composing 时暂不截断，在 composing 结束后执行
  final int? maxCharacter;

  /// 是否显示当前字符计数；未配置长度限制时不会显示
  final bool indicator;

  /// 是否自动聚焦
  final bool autofocus;

  /// 焦点节点
  final FocusNode? focusNode;

  /// 键盘类型
  final TextInputType inputType;

  /// 键盘动作
  final TextInputAction? inputAction;

  /// 文本对齐方式
  final TextAlign textAlign;

  /// 是否隐藏输入文本
  final bool obscureText;

  /// 是否在后置插槽显示内置密码显隐按钮
  ///
  /// 初始显隐状态由 [obscureText] 决定，按钮点击后的显隐状态由输入框自身维护；
  /// 仅支持单行输入。如果同时传入 [suffix]，自定义后置内容会紧跟在该按钮之后
  final bool showPasswordToggle;

  /// 输入格式化器
  final List<TextInputFormatter>? inputFormatters;

  /// 输入文本样式
  final TextStyle? style;

  /// 光标颜色
  final Color? cursorColor;

  const SantoInputText({
    Key? key,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.enabled = true,
    this.readOnly = false,
    this.hintText,
    this.label,
    this.required = false,
    this.labelWidth,
    this.prefix,
    this.suffix,
    this.suffixText,
    this.suffixTextStyle,
    this.suffixIcon,
    this.suffixButton,
    this.inputFormat = SantoInputFormat.text,
    this.clearButtonMode,
    this.status = SantoInputStatus.normal,
    this.borderless = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.maxCharacter,
    this.indicator = false,
    this.autofocus = false,
    this.focusNode,
    this.inputType = TextInputType.text,
    this.inputAction,
    this.textAlign = TextAlign.start,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.inputFormatters,
    this.style,
    this.cursorColor,
  })  : assert(controller == null || initialValue == null),
        assert(!obscureText || (maxLines == 1 && minLines == null)),
        assert(!showPasswordToggle || (maxLines == 1 && minLines == null)),
        assert(maxLength == null || maxCharacter == null),
        assert(maxLength == null || maxLength >= 0),
        assert(maxCharacter == null || maxCharacter >= 0),
        super(key: key);

  bool get _multiline => maxLines != 1 || minLines != null;

  @override
  State<SantoInputText> createState() => _SantoInputTextState();
}

class _SantoInputTextState extends State<SantoInputText> {
  late final TextEditingController _internalController;
  late final FocusNode _internalFocusNode;
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late bool _obscureText;

  SantoCommonConfig get _commonConfig =>
      SantoThemeConfigurator.instance.getConfig().commonConfig;

  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController(text: widget.initialValue);
    _internalFocusNode = FocusNode();
    _controller = _effectiveController;
    _focusNode = widget.focusNode ?? _internalFocusNode;
    _obscureText = widget.obscureText;
  }

  @override
  void didUpdateWidget(covariant SantoInputText oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller = _effectiveController;
    _focusNode = widget.focusNode ?? _internalFocusNode;
    if (oldWidget.obscureText != widget.obscureText ||
        oldWidget.showPasswordToggle != widget.showPasswordToggle) {
      _obscureText = widget.obscureText;
    }
  }

  @override
  void dispose() {
    _internalController.dispose();
    _internalFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commonConfig = _commonConfig;
    final disabled = !widget.enabled;
    final inputTextColor = disabled
        ? commonConfig.colorTextDisabled
        : commonConfig.colorTextBase;
    final tokenStyle = TextStyle(
      color: inputTextColor,
      fontSize: commonConfig.fontSizeBase,
      height: 1.5,
    );
    final textStyle = tokenStyle.merge(widget.style).copyWith(
          color: widget.style?.color ?? inputTextColor,
        );
    final hintStyle = TextStyle(
      color: commonConfig.colorTextDisabled,
      fontSize: commonConfig.fontSizeBase,
      height: 1.5,
    );
    final editor = TextField(
      controller: _controller,
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      onEditingComplete: widget.onEditingComplete,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      minLines: _effectiveMinLines,
      maxLength: null,
      autofocus: widget.autofocus,
      keyboardType: _effectiveKeyboardType,
      textInputAction: widget.inputAction,
      textAlign: widget.textAlign,
      obscureText:
          widget.showPasswordToggle ? _obscureText : widget.obscureText,
      inputFormatters: _effectiveFormatters(),
      style: textStyle,
      cursorColor: widget.cursorColor ?? commonConfig.brandPrimary,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: hintStyle,
        hintMaxLines: 1,
        filled: false,
        fillColor: Colors.transparent,
        isCollapsed: true,
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
      ),
    );

    final shell = _SantoInputShell(
      controller: _controller,
      focusNode: _focusNode,
      editor: editor,
      prefix: widget.prefix,
      suffix: widget.suffix,
      suffixText: widget.suffixText,
      suffixTextStyle: widget.suffixTextStyle,
      suffixIcon: widget.suffixIcon,
      suffixButton: widget.suffixButton,
      clearButtonMode:
          widget.clearButtonMode ?? SantoInputClearButtonMode.never,
      onClear: _clear,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      multiline: widget._multiline,
      showPasswordToggle: widget.showPasswordToggle,
      obscureText:
          widget.showPasswordToggle ? _obscureText : widget.obscureText,
      onTogglePassword: _togglePassword,
      indicator: widget.indicator,
      counterLimit: widget.maxLength ?? widget.maxCharacter,
      maxCharacter: widget.maxCharacter,
      status: widget.status,
      borderless: widget.borderless,
    );

    if (widget.label == null) {
      return shell;
    }
    final label = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.required) ...[
          Text(
            '*',
            style: TextStyle(
              color: commonConfig.brandError,
              fontSize: commonConfig.fontSizeBase,
            ),
          ),
          const SizedBox(width: 2),
        ],
        Flexible(
          child: Text(
            widget.label!,
            style: TextStyle(
              color: commonConfig.colorTextBase,
              fontSize: commonConfig.fontSizeBase,
            ),
          ),
        ),
      ],
    );
    return Row(
      children: [
        widget.labelWidth == null
            ? label
            : SizedBox(width: widget.labelWidth, child: label),
        SizedBox(width: commonConfig.hSpacingXs),
        Expanded(child: shell),
      ],
    );
  }

  /// [inputFormat] 决定键盘类型，[inputFormat] 为 text 时使用 [inputType]
  TextInputType get _effectiveKeyboardType {
    switch (widget.inputFormat) {
      case SantoInputFormat.digit:
        return TextInputType.number;
      case SantoInputFormat.number:
        return const TextInputType.numberWithOptions(
            decimal: true, signed: true);
      case SantoInputFormat.idCard:
        return TextInputType.text;
      case SantoInputFormat.phone:
        return TextInputType.phone;
      case SantoInputFormat.email:
        return TextInputType.emailAddress;
      case SantoInputFormat.text:
        return widget.inputType;
    }
  }

  int? get _effectiveMinLines {
    if (!widget._multiline) {
      return null;
    }
    final minLines = widget.minLines ?? 4;
    return widget.maxLines == null
        ? minLines
        : minLines.clamp(1, widget.maxLines!);
  }

  List<TextInputFormatter>? _effectiveFormatters() {
    final formatters = <TextInputFormatter>[];
    final formatFormatter = _formatFormatter;
    if (formatFormatter != null) {
      formatters.add(formatFormatter);
    }
    formatters.addAll(widget.inputFormatters ?? const []);
    if (widget.maxLength != null) {
      formatters.add(LengthLimitingTextInputFormatter(widget.maxLength));
    }
    if (widget.maxCharacter != null) {
      formatters.add(
        _WeightedLengthLimitingTextInputFormatter(widget.maxCharacter!),
      );
    }
    return formatters.isEmpty ? null : formatters;
  }

  /// [inputFormat] 对应的输入过滤规则
  TextInputFormatter? get _formatFormatter {
    switch (widget.inputFormat) {
      case SantoInputFormat.text:
        return null;
      case SantoInputFormat.digit:
        return FilteringTextInputFormatter.digitsOnly;
      case SantoInputFormat.number:
        return FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*$'));
      case SantoInputFormat.idCard:
        return FilteringTextInputFormatter.allow(RegExp(r'[0-9xX]'));
      case SantoInputFormat.phone:
        return FilteringTextInputFormatter.allow(RegExp(r'[0-9+\- ]'));
      case SantoInputFormat.email:
        return FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9@._\-+]'));
    }
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  void _togglePassword() {
    if (!widget.enabled) {
      return;
    }
    setState(() => _obscureText = !_obscureText);
  }
}

/// 只监听输入值和焦点变化的外壳，负责边框、清除按钮和字数指示器等派生视觉状态
class _SantoInputShell extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Widget editor;
  final Widget? prefix;
  final Widget? suffix;
  final String? suffixText;
  final TextStyle? suffixTextStyle;
  final Widget? suffixIcon;
  final Widget? suffixButton;
  final SantoInputClearButtonMode clearButtonMode;
  final VoidCallback onClear;
  final bool enabled;
  final bool readOnly;
  final bool multiline;
  final bool showPasswordToggle;
  final bool obscureText;
  final VoidCallback onTogglePassword;
  final bool indicator;
  final int? counterLimit;
  final int? maxCharacter;
  final SantoInputStatus status;
  final bool borderless;

  const _SantoInputShell({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.editor,
    required this.clearButtonMode,
    required this.onClear,
    required this.enabled,
    required this.readOnly,
    required this.multiline,
    required this.showPasswordToggle,
    required this.obscureText,
    required this.onTogglePassword,
    required this.indicator,
    required this.counterLimit,
    required this.status,
    required this.borderless,
    this.prefix,
    this.suffix,
    this.suffixText,
    this.suffixTextStyle,
    this.suffixIcon,
    this.suffixButton,
    this.maxCharacter,
  }) : super(key: key);

  @override
  State<_SantoInputShell> createState() => _SantoInputShellState();
}

class _SantoInputShellState extends State<_SantoInputShell> {
  static const double _iconSlotSize = 24;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleStateChanged);
    widget.focusNode.addListener(_handleStateChanged);
  }

  @override
  void didUpdateWidget(covariant _SantoInputShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleStateChanged);
      widget.controller.addListener(_handleStateChanged);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_handleStateChanged);
      widget.focusNode.addListener(_handleStateChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleStateChanged);
    widget.focusNode.removeListener(_handleStateChanged);
    super.dispose();
  }

  void _handleStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Color _statusColor(SantoCommonConfig commonConfig) {
    switch (widget.status) {
      case SantoInputStatus.normal:
        return commonConfig.brandPrimary;
      case SantoInputStatus.success:
        return commonConfig.brandSuccess;
      case SantoInputStatus.warning:
        return commonConfig.brandWarning;
      case SantoInputStatus.error:
        return commonConfig.brandError;
    }
  }

  Color _borderColor(SantoCommonConfig commonConfig) {
    if (widget.status == SantoInputStatus.normal) {
      return commonConfig.borderColorBase;
    }
    return _statusColor(commonConfig);
  }

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final hasText = widget.controller.text.isNotEmpty;
    final hasFocus = widget.focusNode.hasFocus;
    final interactive = widget.enabled && !widget.readOnly;
    final hasSuffix = widget.suffix != null ||
        widget.suffixText != null ||
        widget.suffixIcon != null ||
        widget.suffixButton != null;
    final showClearButton = !hasSuffix &&
        !widget.showPasswordToggle &&
        widget.clearButtonMode != SantoInputClearButtonMode.never &&
        hasText &&
        (widget.clearButtonMode == SantoInputClearButtonMode.always ||
            hasFocus);
    final clearButton = showClearButton
        ? SizedBox(
            width: 32,
            height: 32,
            child: IconButton(
              tooltip: '清除',
              onPressed: interactive ? widget.onClear : null,
              padding: EdgeInsets.zero,
              constraints:
                  const BoxConstraints.tightFor(width: 32, height: 32),
              iconSize: 20,
              icon: Icon(
                Icons.cancel,
                color: commonConfig.colorTextHint,
              ),
            ),
          )
        : null;
    final passwordButton = widget.showPasswordToggle
        ? SizedBox(
            width: _iconSlotSize,
            height: _iconSlotSize,
            child: IconButton(
              tooltip: widget.obscureText ? '显示密码' : '隐藏密码',
              onPressed: widget.enabled ? widget.onTogglePassword : null,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(
                width: _iconSlotSize,
                height: _iconSlotSize,
              ),
              iconSize: _iconSlotSize,
              icon: Icon(
                widget.obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: widget.enabled
                    ? commonConfig.colorTextHint
                    : commonConfig.colorTextDisabled,
              ),
            ),
          )
        : null;
    final counter = widget.indicator && widget.counterLimit != null
        ? Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              '${_inputLength(widget.controller.text, widget.maxCharacter)}/${widget.counterLimit}',
              style: TextStyle(
                fontSize: commonConfig.fontSizeCaption,
                color: widget.status == SantoInputStatus.error
                    ? commonConfig.brandError
                    : widget.multiline
                        ? commonConfig.colorTextHint
                        : commonConfig.colorTextSecondary,
              ),
            ),
          )
        : null;
    final borderSide = BorderSide(
      color: _borderColor(commonConfig),
      width: commonConfig.borderWidthMd,
    );
    final border = widget.borderless
        ? null
        : Border.fromBorderSide(
            hasFocus
                ? borderSide.copyWith(color: _statusColor(commonConfig))
                : borderSide,
          );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: commonConfig.fillBase,
        border: border,
        borderRadius: widget.borderless
            ? null
            : BorderRadius.circular(commonConfig.hSpacingSm),
      ),
      child: widget.multiline
          ? Padding(
              padding: EdgeInsets.symmetric(
                horizontal: commonConfig.hSpacingSm,
                vertical: commonConfig.hSpacingSm,
              ),
              child: _buildContent(commonConfig, clearButton, passwordButton,
                  counter),
            )
          : ConstrainedBox(
              constraints: const BoxConstraints(minHeight: _singleLineHeight),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: commonConfig.hSpacingSm,
                ),
                child: Center(
                  child: _buildContent(commonConfig, clearButton,
                      passwordButton, counter),
                ),
              ),
            ),
    );
  }

  /// 单行输入的内容区至少为 [_singleLineHeight]，左右插槽在这个高度内居中，
  /// 不会把输入框撑高
  Widget _buildContent(
    SantoCommonConfig commonConfig,
    Widget? clearButton,
    Widget? passwordButton,
    Widget? counter,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: widget.multiline
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            if (widget.prefix != null) ...[
              _SantoInputSlot(
                color: widget.enabled
                    ? commonConfig.colorTextBase
                    : commonConfig.colorTextDisabled,
                child: widget.prefix!,
              ),
              SizedBox(width: commonConfig.hSpacingMd),
            ],
            Expanded(child: widget.editor),
            if (clearButton != null) ...[
              SizedBox(width: commonConfig.hSpacingXs),
              clearButton,
            ],
            if (passwordButton != null) ...[
              SizedBox(width: commonConfig.hSpacingXs),
              passwordButton,
            ],
            if (widget.suffixText != null) ...[
              SizedBox(width: commonConfig.hSpacingXs),
              Text(
                widget.suffixText!,
                style: widget.suffixTextStyle ??
                    TextStyle(
                      color: commonConfig.colorTextBase,
                      fontSize: commonConfig.fontSizeBase,
                    ),
              ),
            ],
            if (widget.suffixIcon != null) ...[
              SizedBox(width: commonConfig.hSpacingXs),
              _SantoInputSlot(
                color: widget.enabled
                    ? commonConfig.colorTextHint
                    : commonConfig.colorTextDisabled,
                child: widget.suffixIcon!,
              ),
            ],
            if (widget.suffixButton != null) ...[
              SizedBox(width: commonConfig.hSpacingXs),
              widget.suffixButton!,
            ],
            if (widget.suffix != null) ...[
              SizedBox(width: commonConfig.hSpacingXs),
              _SantoInputSlot(
                color: widget.enabled
                    ? commonConfig.colorTextHint
                    : commonConfig.colorTextDisabled,
                child: widget.suffix!,
              ),
            ],
          ],
        ),
        if (counter != null) ...[
          SizedBox(height: widget.multiline ? commonConfig.vSpacingSm : 2),
          counter,
        ],
      ],
    );
  }
}

class _SantoInputSlot extends StatelessWidget {
  final Widget child;
  final Color color;

  const _SantoInputSlot({Key? key, required this.child, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: color, size: 24),
      child: Center(child: child),
    );
  }
}

int _inputLength(String value, int? maxCharacter) =>
    maxCharacter == null ? value.characters.length : _characterLength(value);

int _characterLength(String value) =>
    value.runes.fold<int>(0, (length, rune) => length + (rune <= 0x7f ? 1 : 2));

/// 按字符权重限制输入的格式化器：ASCII code point 计 1，非 ASCII 计 2
class _WeightedLengthLimitingTextInputFormatter extends TextInputFormatter {
  const _WeightedLengthLimitingTextInputFormatter(this.maxCharacter);

  final int maxCharacter;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (_characterLength(newValue.text) <= maxCharacter ||
        newValue.composing.isValid) {
      return newValue;
    }

    final buffer = StringBuffer();
    var length = 0;
    for (final rune in newValue.text.runes) {
      final runeLength = rune <= 0x7f ? 1 : 2;
      if (length + runeLength > maxCharacter) {
        break;
      }
      buffer.writeCharCode(rune);
      length += runeLength;
    }

    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: newValue.selection.copyWith(
        baseOffset: math.min(newValue.selection.start, text.length),
        extentOffset: math.min(newValue.selection.end, text.length),
      ),
    );
  }
}
