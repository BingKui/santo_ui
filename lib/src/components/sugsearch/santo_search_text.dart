import 'package:santo_ui/src/components/icon/santo_icon.dart';
import 'package:santo_ui/src/components/icon/santo_icons.dart';
import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 搜索框内容变化回调
typedef SantoOnSearchTextChange = void Function(String content);

/// 提交搜索框内容时的回调
typedef SantoOnCommit = void Function(String content);

/// 右侧清除按钮 X 被点击的回调
typedef SantoOnTextClear = bool Function();

/// 基本IOS风格搜索框, 提供输入回调
class SantoSearchText extends StatefulWidget {
  /// 提示语
  final String? hintText;

  /// 提示语样式
  final TextStyle? hintStyle;

  /// 输入框样式
  final TextStyle? textStyle;

  /// 用于设置搜索框前端的 Icon
  final Widget? prefixIcon;

  /// 包裹搜索框的容器背景色，不传时取主题 fillBase
  final Color? outSideColor;

  /// 搜索框内部的颜色
  final Color innerColor;

  /// 最大展示行数
  final int maxLines;

  /// 最大输入长度
  final int? maxLength;

  /// 输入框最大高度，默认 60
  final double maxHeight;

  ///内部搜索框之外的 Padding。不传时取主题 vSpacingSm(上下) / hSpacingLg(左右)。
  ///设置该字段会导致显示区域变小。
  final EdgeInsets? innerPadding;

  ///普通状态的 border
  final BoxBorder? normalBorder;

  /// 激活状态的 Border， 默认和 border 一致
  final BoxBorder? activeBorder;

  /// 输入框圆角，不传时取主题 radiusMd
  final BorderRadius? borderRadius;

  /// 右侧操作 widget
  final Widget? action;

  /// 是否自动获取焦点
  final bool autoFocus;

  /// 用于控制键盘动作
  final TextInputAction? textInputAction;

  final TextInputType? textInputType;

  final List<TextInputFormatter>? inputFormatters;

  final TextEditingController? controller;
  final FocusNode? focusNode;

  /// 文本变化的回调
  final SantoOnSearchTextChange? onTextChange;

  /// 提交文本时的回调
  final SantoOnCommit? onTextCommit;

  /// 右侧 action 区域点击的回调
  final VoidCallback? onActionTap;

  /// 清除按钮的回调 如果用户设置了该属性
  /// 如果返回值为true，表明用户想要拦截，则不会走默认的清除行为
  /// 如果返回值为false，表明用户不想要拦截，在执行了用户的行为之后，还会走默认的行为
  final SantoOnTextClear? onTextClear;

  /// 用于控制清除 Icon 和右侧 Action 的显示与隐藏。等其他复杂的操作。
  final SantoSearchTextController? searchController;

  const SantoSearchText({
    Key? key,
    this.searchController,
    this.controller,
    this.maxLines = 1,
    this.maxLength,
    this.hintText,
    this.hintStyle,
    this.textStyle,
    this.prefixIcon,
    this.onTextChange,
    this.onTextCommit,
    this.onTextClear,
    this.onActionTap,
    this.action,
    this.maxHeight = 60,
    this.innerPadding,
    this.outSideColor,
    this.innerColor = const Color(0xfff8f8f8),
    this.normalBorder,
    this.activeBorder,
    this.borderRadius,
    this.focusNode,
    this.autoFocus = false,
    this.textInputAction,
    this.inputFormatters,
    this.textInputType,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SearchTextState();
  }
}

class _SearchTextState extends State<SantoSearchText> {
  FocusNode? focusNode;
  TextEditingController? textEditingController;
  BoxBorder? border;
  SantoSearchTextController? searchTextController;

  SantoSearchTextController? tmpController;

  @override
  void initState() {
    super.initState();

    if (widget.searchController == null) {
      tmpController = SantoSearchTextController();
    }
    searchTextController = widget.searchController ?? tmpController;
    searchTextController!.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    focusNode = widget.focusNode ?? FocusNode();
    textEditingController = widget.controller ?? TextEditingController();
    border = widget.normalBorder ??
        Border.all(
          width: SantoThemeConfigurator.instance
              .getConfig()
              .commonConfig
              .borderWidthMd,
          color: widget.innerColor,
        );

    focusNode!.addListener(_handleFocusNodeChangeListenerTick);
  }

  @override
  void dispose() {
    super.dispose();
    tmpController?.dispose();
    focusNode!.removeListener(_handleFocusNodeChangeListenerTick);
  }

  /// 焦点状态回到，用于刷新当前 UI
  void _handleFocusNodeChangeListenerTick() {
    if (focusNode!.hasFocus) {
      border = widget.activeBorder ?? border;
    } else {
      border = widget.normalBorder ?? border;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final EdgeInsets innerPadding = widget.innerPadding ??
        EdgeInsets.symmetric(
            vertical: commonConfig.vSpacingSm,
            horizontal: commonConfig.hSpacingLg);
    final BorderRadius borderRadius = widget.borderRadius ??
        BorderRadius.all(Radius.circular(commonConfig.radiusMd));
    final Color outSideColor = widget.outSideColor ?? commonConfig.fillBase;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: widget.maxHeight,
      ),
      child: Container(
        padding: innerPadding,
        color: outSideColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: widget.innerColor,
                  border: border,
                  // 边界半径（`borderRadius`）属性，对此容器框的角进行舍入。
                  borderRadius: borderRadius,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    widget.prefixIcon ??
                        Padding(
                          padding:
                              EdgeInsets.only(left: commonConfig.hSpacingMd),
                          child: Center(
                            child: SantoIcon(SantoIcons.search,
                                size: commonConfig.iconSizeMd),
                          ),
                        ),
                    Expanded(
                      child: TextField(
                          maxLength: widget.maxLength,
                          autofocus: widget.autoFocus,
                          textInputAction: this.widget.textInputAction,
                          focusNode: focusNode,
                          controller: textEditingController,
                          keyboardType: widget.textInputType,
                          inputFormatters: widget.inputFormatters,
                          cursorColor: commonConfig.brandPrimary,
                          cursorWidth: 2.0,
                          style: widget.textStyle ??
                              TextStyle(
                                  textBaseline: TextBaseline.alphabetic,
                                  color: commonConfig.colorTextBase,
                                  fontSize: commonConfig.fontSizeSubHead),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: borderRadius,
                                borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.only(
                                left: commonConfig.hSpacingSm,
                                right: commonConfig.hSpacingXs),
                            // 填充颜色属性，填充装饰容器的颜色。
                            fillColor: widget.innerColor,
                            // 是密集属性，输入子项是否是密集形式的一部分（即使用较少的垂直空间）。
                            isDense: true,
                            filled: true,
                            hintStyle: widget.hintStyle ??
                                TextStyle(
                                  fontSize: commonConfig.fontSizeSubHead,
                                  height: 1,
                                  textBaseline: TextBaseline.alphabetic,
                                  color: commonConfig.colorTextSecondary,
                                ),
                            hintText: widget.hintText ?? SantoIntl.of(context).localizedResource.inputSearchTip,
                            counterText: '',
                          ),
                          // 在改变属性，当正在编辑的文本发生更改时调用。
                          onChanged: (content) {
                            if (widget.onTextChange != null) {
                              widget.onTextChange!(content);
                            }
                            setState(() {});
                          },
                          onSubmitted: (content) {
                            if (widget.onTextCommit != null) {
                              widget.onTextCommit!(content);
                            }
                          }),
                    ),
                    Visibility(
                      visible: searchTextController!.isClearShow,
                      child: GestureDetector(
                        onTap: () {
                          if (widget.onTextClear != null) {
                            bool isIntercept = widget.onTextClear!();
                            if (isIntercept) return;
                          }
                          textEditingController!.clear();
                          if (this.widget.onTextChange != null) {
                            this.widget.onTextChange!(
                                textEditingController!.value.text);
                          }
                          setState(() {});
                        },
                        child: Visibility(
                          visible: textEditingController!.text.isNotEmpty,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: SantoIcon(SantoIcons.xmarkCircle),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: searchTextController!.isActionShow,
              child: widget.action ??
                  GestureDetector(
                    onTap: () {
                      if (widget.onActionTap != null) {
                        widget.onActionTap!();
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.fromLTRB(commonConfig.hSpacingLg, 0, 0, 0),
                      child: Text(
                        SantoIntl.of(context).localizedResource.cancel,
                        style: TextStyle(
                            color: commonConfig.colorTextBase,
                            fontSize: commonConfig.fontSizeSubHead,
                            height: 1),
                      ),
                    ),
                  ),
            )
          ],
        ),
      ),
    );
  }
}

/// 搜索框控制类，用于控制 清除 icon（x）、取消按钮的展示 隐藏
class SantoSearchTextController extends ChangeNotifier {
  bool _isClearShow = true;
  bool _isActionShow = false;

  bool get isClearShow => _isClearShow;

  bool get isActionShow => _isActionShow;

  /// 设置清除 icon 的展示隐藏
  set isClearShow(bool value) {
    _isClearShow = value;
    notifyListeners();
  }

  /// 设置取消按钮的展示隐藏
  set isActionShow(bool value) {
    _isActionShow = value;
    notifyListeners();
  }
}
