import 'package:santo_ui/src/components/form/base/santo_form_item_type.dart';
import 'package:santo_ui/src/components/form/utils/santo_form_util.dart';
import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_form_config.dart';
import 'package:santo_ui/src/constants/santo_fonts_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///
/// 范围输入型录入项
///
/// 包括"标题"、"副标题"、"错误信息提示"、"必填项提示"、"添加/删除按钮"、"消息提示"、
/// "输入框"等元素
///
// ignore: must_be_immutable
class SantoRangeInputFormItem extends StatefulWidget {
  /// 录入项的唯一标识，主要用于录入类型页面框架中
  final String? label;

  /// 录入项标题
  final String title;

  /// 录入项子标题
  final String? subTitle;

  /// 录入项提示（问号图标&文案） 用户点击时触发onTip回调。
  /// 1. 若赋值为 空字符串（""）时仅展示"问号"图标，
  /// 2. 若赋值为非空字符串时 展示"问号图标&文案"，
  /// 3. 若不赋值或赋值为null时 不显示提示项
  /// 默认值为 3
  final String? tipLabel;

  /// 录入项前缀图标样式 "添加项" "删除项" 详见 PrefixIconType类
  final String prefixIconType;

  /// 录入项错误提示
  final String error;

  /// 录入项是否为必填项（展示*图标） 默认为 false 不必填
  final bool isRequire;

  /// 录入项 是否可编辑
  final bool isEdit;

  /// 录入项不可编辑时(isEdit: false) "+"、"-"号是否可点击
  /// true: 可点击回调 false: 不可点击回调
  /// 默认值: false
  final bool isPrefixIconEnabled;

  /// 点击"+"图标回调
  final VoidCallback? onAddTap;

  /// 点击"-"图标回调
  final VoidCallback? onRemoveTap;

  /// 点击"？"图标回调
  final VoidCallback? onTip;

  /// 最小值提示语
  String? hintMin;

  /// 最大值提示语
  String? hintMax;

  /// 最小值单位
  final String? minUnit;

  /// 最大值单位
  final String? maxUnit;

  /// 最小值输入框最大字符数
  final int? leftMaxCount;

  /// 最大值输入框最大字符数
  final int? rightMaxCount;

  /// 输入内容类型，参见[SantoInputType]
  final String? inputType;

  final TextEditingController? minController;
  final TextEditingController? maxController;
  List<TextInputFormatter>? minInputFormatters;
  List<TextInputFormatter>? maxInputFormatters;

  /// 最小值输入回调
  final ValueChanged<String>? onMinChanged;

  /// 最大值输入回调
  final ValueChanged<String>? onMaxChanged;

  /// 背景色
  final Color? backgroundColor;

  /// form配置
  SantoFormItemConfig? themeData;

  SantoRangeInputFormItem(
      {Key? key,
      this.label,
      this.title = "",
      this.subTitle,
      this.tipLabel,
      this.prefixIconType = SantoPrefixIconType.normal,
      this.error = "",
      this.isEdit = true,
      this.isRequire = false,
      this.isPrefixIconEnabled = false,
      this.onAddTap,
      this.onRemoveTap,
      this.onTip,
      this.hintMin,
      this.hintMax,
      this.minUnit,
      this.maxUnit,
      this.leftMaxCount,
      this.rightMaxCount,
      this.inputType,
      this.onMinChanged,
      this.onMaxChanged,
      this.minController,
      this.maxController,
      this.minInputFormatters,
      this.maxInputFormatters,
      this.backgroundColor,
      this.themeData})
      : super(key: key) {
    this.themeData ??= SantoFormItemConfig();
    this.themeData = SantoThemeConfigurator.instance
        .getConfig(configId: this.themeData!.configId)
        .formItemConfig
        .merge(this.themeData);
    this.themeData = this
        .themeData!
        .merge(SantoFormItemConfig(backgroundColor: backgroundColor));
  }

  @override
  SantoRangeInputFormItemState createState() {
    return SantoRangeInputFormItemState();
  }
}

class SantoRangeInputFormItemState extends State<SantoRangeInputFormItem> {
  late TextEditingController _minController;
  late TextEditingController _maxController;
  late SantoFormItemConfig config;

  @override
  void initState() {
    config = SantoThemeConfigurator.instance.getConfig().formItemConfig;
    _minController = widget.minController ?? TextEditingController();
    _maxController = widget.maxController ?? TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.themeData!.backgroundColor,
      padding: SantoFormUtil.itemEdgeInsets(widget.themeData!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 25,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: SantoFormUtil.titleEdgeInsets(widget.prefixIconType,
                      widget.isRequire, widget.themeData!),
                  child: Row(
                    children: <Widget>[
                      SantoFormUtil.buildPrefixIcon(
                          widget.prefixIconType,
                          widget.isEdit,
                          context,
                          widget.onAddTap,
                          widget.onRemoveTap),
                      SantoFormUtil.buildRequireWidget(widget.isRequire),
                      SantoFormUtil.buildTitleWidget(
                          widget.title, widget.themeData!),
                      SantoFormUtil.buildTipLabelWidget(
                          widget.tipLabel, widget.onTip, widget.themeData!),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 50,
                        ),
                        child: TextField(
                          keyboardType:
                              SantoFormUtil.getInputType(widget.inputType),
                          enabled: widget.isEdit,
                          maxLines: 1,
                          maxLength: widget.leftMaxCount,
                          style: SantoFormUtil.getIsEditTextStyle(
                              widget.themeData!, widget.isEdit),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle:
                                SantoFormUtil.getHintTextStyle(widget.themeData!),
                            hintText: widget.hintMin ??
                                SantoIntl.of(context).localizedResource.min,
                            counterText: "",
                            contentPadding: EdgeInsets.all(0),
                            isDense: true,
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                          ),
                          textAlign: TextAlign.end,
                          controller: _minController,
                          onChanged: (text) {
                            SantoFormUtil.notifyInputChanged(
                                widget.onMinChanged, text);
                          },
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          widget.minUnit ?? "",
                          style: TextStyle(
                            color: Color(0xFF17233D),
                            fontSize: SantoFonts.f16,
                          ),
                        )),
                    Container(
                        padding: EdgeInsets.only(left: 20, right: 6),
                        child: Text(
                          "—",
                          style: TextStyle(
                            color: Color(0xFF17233D),
                            fontSize: SantoFonts.f16,
                          ),
                        )),
                    Container(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 50,
                        ),
                        child: TextField(
                          keyboardType:
                              SantoFormUtil.getInputType(widget.inputType),
                          enabled: widget.isEdit,
                          maxLines: 1,
                          maxLength: widget.rightMaxCount,
                          style: SantoFormUtil.getIsEditTextStyle(
                              widget.themeData!, widget.isEdit),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle:
                                SantoFormUtil.getHintTextStyle(widget.themeData!),
                            hintText: widget.hintMax ??
                                SantoIntl.of(context).localizedResource.max,
                            counterText: "",
                            contentPadding: EdgeInsets.all(0),
                            isDense: true,
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                          ),
                          textAlign: TextAlign.end,
                          controller: _maxController,
                          onChanged: (text) {
                            SantoFormUtil.notifyInputChanged(
                                widget.onMaxChanged, text);
                          },
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          widget.maxUnit ?? "",
                          style: TextStyle(
                            color: Color(0xFF17233D),
                            fontSize: SantoFonts.f16,
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),

          // 副标题
          SantoFormUtil.buildSubTitleWidget(widget.subTitle, widget.themeData!),

          SantoFormUtil.buildErrorWidget(widget.error, widget.themeData!)
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // 如果controller由外部创建不需要销毁, 若由内部创建则需要销毁
    _minController.dispose();
    _maxController.dispose();
  }
}
