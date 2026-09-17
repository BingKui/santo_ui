import 'dart:async';

import 'package:santo_ui/src/components/form/base/santo_form_item_type.dart';
import 'package:santo_ui/src/components/form/base/input_item_interface.dart';
import 'package:santo_ui/src/components/form/utils/santo_form_util.dart';
import 'package:santo_ui/src/components/tooltip/santo_tooltip.dart';
import 'package:santo_ui/src/constants/santo_asset_constants.dart';
import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_form_config.dart';
import 'package:santo_ui/src/utils/santo_tools.dart';
import 'package:santo_ui/src/constants/santo_fonts_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///
/// 标题可选文本输入型录入项
///
/// 包括"标题"、"副标题"、"错误信息提示"、"必填项提示"、"添加/删除按钮"、"消息提示"、
/// "标题选择"、"单选项"等元素
///
// ignore: must_be_immutable
class SantoTitleSelectInputFormItem extends StatefulWidget {
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

  /// 提示文案
  final String? hint;

  /// 最大可输入字符数
  final int? maxCount;

  /// 输入类型
  final String inputType;

  /// 是否自动获取焦点
  bool autofocus;

  /// 选中title索引
  final int selectedIndex;

  /// title选择列表
  final List<String> selectList;
  final List<TextInputFormatter>? inputFormatters;

  /// 输入文本变化回调
  final ValueChanged<String>? onChanged;

  /// title文案选中回调
  final OnSantoFormTitleSelected? onTitleSelected;
  final TextEditingController? controller;

  /// 背景色
  final Color? backgroundColor;

  /// form配置
  SantoFormItemConfig? themeData;

  SantoTitleSelectInputFormItem(
      {Key? key,
      required this.selectList,
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
      this.hint,
      this.maxCount,
      this.inputType = SantoInputType.text,
      this.selectedIndex = -1,
      this.inputFormatters,
      this.autofocus = false,
      this.onChanged,
      this.onTitleSelected,
      this.backgroundColor,
      this.controller,
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
  SantoTitleSelectInputFormItemState createState() =>
      SantoTitleSelectInputFormItemState();
}

class SantoTitleSelectInputFormItemState
    extends State<SantoTitleSelectInputFormItem> {
  late TextEditingController _controller;
  late StreamController<bool> _showController;
  late StreamController<String> _textController;
  late GlobalKey _globalKey;
  String _title = "";

  @override
  void initState() {
    initForm();
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildLeftMenu(),
                Container(
                  width: 42,
                ),
                Expanded(child: _buildTextField())
              ],
            ),
          ),
          SantoFormUtil.buildSubTitleWidget(widget.subTitle, widget.themeData!),
          SantoFormUtil.buildErrorWidget(widget.error, widget.themeData!),
        ],
      ),
    );
  }

  Widget _buildLeftMenu() {
    return Container(
      padding: SantoFormUtil.titleEdgeInsets(
          widget.prefixIconType, widget.isRequire, widget.themeData!),
      child: Row(
        children: <Widget>[
          SantoFormUtil.buildPrefixIcon(widget.prefixIconType, widget.isEdit,
              context, widget.onAddTap, widget.onRemoveTap),
          SantoFormUtil.buildRequireWidget(widget.isRequire),
          //menu
          _buildMenuWidget(),
          //小三角
          _buildTriangle(),

          SantoFormUtil.buildTipLabelWidget(
              widget.tipLabel, widget.onTip, widget.themeData!),
        ],
      ),
    );
  }

  Widget _buildMenuWidget() {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Container(
        key: _globalKey,
        padding: EdgeInsets.only(right: commonConfig.hSpacingXs),
        child: GestureDetector(
          onTap: () {
            if (!widget.isEdit) {
              return;
            }

            RenderBox? trigle =
                _globalKey.currentContext?.findRenderObject() as RenderBox?;
            Offset? offset = trigle?.localToGlobal(Offset.zero);
            final RenderBox button = context.findRenderObject() as RenderBox;
            final RenderBox overlay =
                Overlay.of(context).context.findRenderObject() as RenderBox;
            final RelativeRect position = RelativeRect.fromRect(
              Rect.fromPoints(
                button.localToGlobal(Offset.zero, ancestor: overlay),
                button.localToGlobal(Offset.zero, ancestor: overlay),
              ),
              Offset.zero & overlay.size,
            );

            var relativeRect = RelativeRect.fromLTRB(
                position.left + (offset?.dx ?? 0.0),
                position.top + 44,
                position.right + (offset?.dx ?? 0.0),
                position.bottom + 44);
            _showController.add(true);
            Navigator.push(
              context,
              SantoPopupRoute(
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: relativeRect.top,
                      left: relativeRect.left,
                      child: TitleSelectPopWidget(
                        selectList: widget.selectList,
                        selectedIndex: widget.selectedIndex,
                        selectCallback: (item, index) {
                          _title = item;
                          _textController.add(item);
                          if (widget.onTitleSelected != null) {
                            widget.onTitleSelected!(item, index);
                          }
                        },
                        themeData: widget.themeData,
                      ),
                    )
                  ],
                ),
              ),
            ).then((data) {
              _showController.add(false);
            });
          },
          child: StreamBuilder<String>(
            stream: _textController.stream,
            initialData: _title,
            builder: (context, AsyncSnapshot<String> snapshot) {
              return Text(
                snapshot.data!,
                style: SantoFormUtil.getTitleTextStyle(widget.themeData!),
              );
            },
          ),
        ));
  }

  Widget _buildTriangle() {
    return Container(
      height: 14,
      width: 14,
      child: StreamBuilder<bool>(
        stream: _showController.stream,
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return snapshot.data!
              ? SantoTools.getAssetImageWithBandColor(
                  SantoAsset.iconSelectedUpTriangle)
              : SantoTools.getAssetImage(SantoAsset.iconUnSelectDownTriangle);
        },
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      autofocus: widget.autofocus,
      inputFormatters: widget.inputFormatters,
      textAlign: TextAlign.end,
      controller: _controller,
      enabled: widget.isEdit,
      maxLength: widget.maxCount,
      style: SantoFormUtil.getIsEditTextStyle(widget.themeData!, widget.isEdit),
      onChanged: (text) {
        SantoFormUtil.notifyInputChanged(widget.onChanged, text);
      },
      keyboardType: SantoFormUtil.getInputType(widget.inputType),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintStyle: TextStyle(
            color: Color(0xFFCCCCCC),
            fontSize: SantoFonts.f16,
            textBaseline: TextBaseline.alphabetic),
        hintText:
            widget.hint ?? SantoIntl.of(context).localizedResource.pleaseEnter,
        counterText: "",
        contentPadding: EdgeInsets.all(0),
        isDense: true,
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent)),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // 如果controller由外部创建不需要销毁, 若由内部创建则需要销毁
    if (widget.controller == null) {
      _controller.dispose();
    }
  }

  void initForm() {
    _showController = StreamController();
    _textController = StreamController();
    _controller = widget.controller ?? TextEditingController();

    _globalKey = GlobalKey();
    _title = widget.title;
  }
}

// ignore: must_be_immutable
class TitleSelectPopWidget extends StatefulWidget {
  List<String> selectList;
  int? selectedIndex;
  final Function(String item, int index) selectCallback;
  SantoFormItemConfig? themeData;

  TitleSelectPopWidget(
      {required this.selectList,
      this.selectedIndex,
      required this.selectCallback,
      this.themeData});

  @override
  _TitleSelectPopWidgetState createState() => _TitleSelectPopWidgetState();
}

class _TitleSelectPopWidgetState extends State<TitleSelectPopWidget> {
  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    List<Widget> showList = [];
    for (int i = 0, n = widget.selectList.length; i < n; ++i) {
      showList.add(selectItem(widget.selectList[i], i, i == n - 1));
    }
    return Container(
      padding: EdgeInsets.only(
          left: commonConfig.hSpacingMd, right: commonConfig.hSpacingMd),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 2, //阴影范围
            spreadRadius: 1, //阴影浓度
            color: Colors.white.withOpacity(0.08), //阴影颜色
          ),
        ],
        color: Colors.white,
        border: Border.all(
            color: widget.themeData!.commonConfig.dividerColorBase, width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(commonConfig.radiusXs)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: showList,
      ),
    );
  }

  Widget selectItem(String item, int index, bool isLast) {
    bool isSelected = widget.selectedIndex == index;
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;

    if (index == 0 && widget.selectedIndex == -1) {
      isSelected = true;
    }
    return GestureDetector(
      onTap: () {
        if (widget.selectedIndex == index) {
        } else {
          widget.selectedIndex = index;
        }
        widget.selectCallback(item, index);
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: EdgeInsets.only(left: 0, right: 0, top: commonConfig.vSpacingSm),
        child: Container(
          padding:
              EdgeInsets.only(left: 0, right: 0, bottom: commonConfig.vSpacingSm),
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: isLast
                        ? Colors.transparent
                        : widget.themeData!.commonConfig.dividerColorBase,
                    width: 0.5)), // 也可控件一边圆角大小
          ),
          child: Text(
            item,
            style: TextStyle(
              decoration: TextDecoration.none,
              color: isSelected
                  ? widget.themeData!.commonConfig.brandPrimary
                  : widget.themeData!.commonConfig.colorTextBase,
              fontWeight: FontWeight.w500,
              fontSize: commonConfig.fontSizeSubHead,
            ),
          ),
        ),
      ),
    );
  }
}
