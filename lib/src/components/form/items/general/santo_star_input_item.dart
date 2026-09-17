import 'package:santo_ui/src/components/form/base/santo_form_item_type.dart';
import 'package:santo_ui/src/components/form/base/input_item_interface.dart';
import 'package:santo_ui/src/components/form/utils/santo_form_util.dart';
import 'package:santo_ui/src/constants/santo_asset_constants.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_form_config.dart';
import 'package:santo_ui/src/utils/santo_tools.dart';
import 'package:flutter/material.dart';

///
/// 评星型录入项
///
/// 包括"标题"、"副标题"、"错误信息提示"、"必填项提示"、"添加/删除按钮"、"消息提示"、
/// "星级选择"等元素
///
// ignore: must_be_immutable
class SantoStarsFormItem extends StatefulWidget {
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

  /// 点击"+"图标回调
  final VoidCallback? onAddTap;

  /// 点击"-"图标回调
  final VoidCallback? onRemoveTap;

  /// 点击"？"图标回调
  final VoidCallback? onTip;

  /// 特有字段
  int value;

  /// 内容
  final int sumStar;

  /// 星值数量变化回调
  final OnSantoFormValueChanged? onChanged;

  /// 背景色
  final Color? backgroundColor;

  /// form配置
  SantoFormItemConfig? themeData;

  SantoStarsFormItem(
      {Key? key,
      this.label,
      this.title = "",
      this.subTitle,
      this.tipLabel,
      this.prefixIconType = SantoPrefixIconType.normal,
      this.error = "",
      this.isEdit = true,
      this.isRequire = false,
      this.onAddTap,
      this.onRemoveTap,
      this.onTip,
      this.sumStar = 5,
      this.value = 0,
      this.onChanged,
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
  SantoStarsFormItemState createState() {
    return SantoStarsFormItemState();
  }
}

class SantoStarsFormItemState extends State<SantoStarsFormItem> {
  List<Widget> _result = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.themeData!.backgroundColor,
      padding: SantoFormUtil.itemEdgeInsets(widget.themeData!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  padding: SantoFormUtil.titleEdgeInsets(widget.prefixIconType,
                      widget.isRequire, widget.themeData!),
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 25,
                      ),
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
                      ))),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: getStarWidgets(),
              ),
            ],
          ),

          // 副标题
          SantoFormUtil.buildSubTitleWidget(widget.subTitle, widget.themeData!),

          SantoFormUtil.buildErrorWidget(widget.error, widget.themeData!)
        ],
      ),
    );
  }

  List<Widget> getStarWidgets() {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    _result.clear();
    int sum = widget.sumStar;

    for (int index = 0; index < sum; ++index) {
      _result.add(GestureDetector(
        onTap: () {
          if (!isEnable()) {
            return;
          }

          final int label = index;
          int oldValue = widget.value;
          widget.value = label + 1;
          SantoFormUtil.notifyValueChanged(
              widget.onChanged, context, oldValue, widget.value);
          setState(() {});
        },
        child: Container(
          padding: (index == sum - 1)
              ? EdgeInsets.only(
                  left: commonConfig.hSpacingLg,
                  top: commonConfig.vSpacingXs,
                  bottom: commonConfig.vSpacingXs)
              : EdgeInsets.only(
                  left: commonConfig.hSpacingLg,
                  right: commonConfig.hSpacingLg,
                  top: commonConfig.vSpacingXs,
                  bottom: commonConfig.vSpacingXs),
          child: getStar(index, widget.value, sum),
        ),
      ));
    }

    return _result;
  }

  bool isEnable() {
    return widget.isEdit;
  }

  Image getStar(int index, int selectCount, int sum) {
    if (selectCount <= 0) {
      return SantoTools.getAssetImage(SantoAsset.iconStarUnSelect);
    }

    if (index < selectCount) {
      return SantoTools.getAssetImage(SantoAsset.iconStarSelect);
    }

    return SantoTools.getAssetImage(SantoAsset.iconStarUnSelect);
  }
}
