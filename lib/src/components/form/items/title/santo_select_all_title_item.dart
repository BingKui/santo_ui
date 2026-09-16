import 'package:santo_ui/src/components/form/base/input_item_interface.dart';
import 'package:santo_ui/src/components/form/items/title/santo_base_title_item.dart';
import 'package:santo_ui/src/components/form/utils/santo_form_util.dart';
import 'package:santo_ui/src/components/checkbox/santo_checkbox.dart';
import 'package:santo_ui/src/theme/santo_theme.dart';
import 'package:flutter/widgets.dart';

///
/// 全选类型类型录入项
///
/// 包括"标题"、"副标题"、"错误信息提示"、"必填项提示"、"消息提示"、
///
// ignore: must_be_immutable
class SantoSelectAllTitle extends StatefulWidget {
  /// 标题
  final String title;

  /// 子标题
  final String? subTitle;

  /// 是否必填项
  final bool isRequire;

  /// 是否可编辑
  final bool isEdit;

  /// 错误提示文案
  final String error;

  /// 录入项提示（问号图标&文案） 用户点击时触发onTip回调。
  /// 1. 若赋值为 空字符串（""）时仅展示"问号"图标，
  /// 2. 若赋值为非空字符串时 展示"问号图标&文案"，
  /// 3. 若不赋值或赋值为null时 不显示提示项
  /// 默认值为 3
  final String? tipLabel;

  /// 标题Widget
  final Widget? titleWidget;

  /// 子标题Widget
  final Widget? subTitleWidget;

  /// 右侧自定义操作区
  final Widget? customActionWidget;

  /// 点击"？"图标回调
  final VoidCallback? onTip;

  /// 全选状态回调
  final OnSantoFormSelectAll? onSelectAll;

  /// 选中项文案
  final String? selectText;

  /// 选中项Widget
  final Widget? selectTextWidget;

  /// 选中项状态
  final bool selectState;

  /// 背景色
  final Color? backgroundColor;

  /// form配置
  SantoFormItemConfig? themeData;

  SantoSelectAllTitle({
    Key? key,
    this.title = "",
    this.subTitle,
    this.isRequire = false,
    this.isEdit = true,
    this.error = "",
    this.tipLabel,
    this.titleWidget,
    this.subTitleWidget,
    this.onTip,
    this.onSelectAll,
    this.selectText,
    this.selectTextWidget,
    this.selectState = true,
    this.themeData,
    this.customActionWidget,
    this.backgroundColor,
  }) : super(key: key) {
    this.themeData ??= SantoFormItemConfig();
    this.themeData = SantoThemeConfigurator.instance
        .getConfig(configId: this.themeData!.configId)
        .formItemConfig
        .merge(this.themeData);
    this.themeData = this.themeData!.merge(
        SantoFormItemConfig(backgroundColor: backgroundColor));
  }

  @override
  State<StatefulWidget> createState() {
    return SantoSelectAllTitleState();
  }
}

class SantoSelectAllTitleState extends State<SantoSelectAllTitle> {
  late bool _selectState;

  @override
  void initState() {
    super.initState();
    _selectState = widget.selectState;
  }

  @override
  void didUpdateWidget(SantoSelectAllTitle oldWidget) {
    super.didUpdateWidget(oldWidget);
    _selectState = oldWidget.selectState;
  }

  @override
  Widget build(BuildContext context) {
    return SantoBaseTitle(
      key: widget.key,
      title: widget.title,
      subTitle: widget.subTitle,
      isRequire: widget.isRequire,
      error: widget.error,
      tipLabel: widget.tipLabel,
      titleWidget: widget.titleWidget,
      subTitleWidget: widget.subTitleWidget,
      customActionWidget: SantoCheckbox(
        customSpace: EdgeInsets.zero,
        customContentBuilder: (context, checked, content) =>
            getSelectTextWidget() ?? const SizedBox.shrink(),
        enable: widget.isEdit,
        checked: _selectState,
        onChanged: (value) {
          _selectState = value;

          if (widget.onSelectAll != null) {
            widget.onSelectAll!(0, value);
          }
        },
      ),
      onTip: widget.onTip,
    );
  }

  Widget? getSelectTextWidget() {
    if (widget.selectTextWidget != null) {
      return widget.selectTextWidget;
    } else {
      return Container(
        child: Text(
          widget.selectText ?? "",
          style: getOptionTextStyle(widget.themeData),
        ),
      );
    }
  }

  TextStyle getOptionTextStyle(SantoFormItemConfig? themeData) {
    if (_selectState) {
      return SantoFormUtil.getOptionSelectedTextStyle(widget.themeData!);
    }
    if (!widget.isEdit) {
      return SantoFormUtil.getIsEditTextStyle(widget.themeData!, widget.isEdit);
    }
    return SantoFormUtil.getOptionTextStyle(widget.themeData!);
  }
}
