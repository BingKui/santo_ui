

import 'package:santo_ui/src/components/radio/santo_checkbox.dart';
import 'package:santo_ui/src/constants/santo_asset_constants.dart';
import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/utils/santo_tools.dart';
import 'package:flutter/material.dart';

/// 已选部分箭头状态的枚举值，共四种
enum SantoMultipleButtonArrowState {
  /// 箭头不可展开
  cantUnfold,

  /// 箭头处于收起状态
  fold,

  /// 箭头处于展开状态
  unfold,

  /// 默认
  defaultStatus,
}

/// 用于多选状态页面底部的组合按钮
/// 支持 **[全选]+[选中状态]+[次要按钮]+[主要按钮]** 的组合（中括号代表可选）
class SantoMultipleBottomButton extends StatefulWidget {
  /// 全选的点击回调，不传则不展示多选按钮，回传参数 true 表示选中全选，false 表示取消全选
  final void Function(bool?)? onSelectAll;

  /// selectedButtonOnTap, 点击已选的回调，存在三种状态：-1:不可展开（当 value 为 0 的时候），0：收起，1：展开
  final void Function(SantoMultipleButtonArrowState)? onSelectedButtonTap;

  /// 主按钮的文案，默认为主题色 可以传入自定义 Widget 以及 String 类型的文案，不传则不展示
  final dynamic mainButton;

  /// 次按钮的文案可以传入自定义 Widget 以及 String 类型的文案，不传则不展示
  final dynamic subButton;

  /// 主按钮点击回调
  final VoidCallback? onMainButtonTap;

  /// 次按钮点击回调
  final VoidCallback? onSubButtonTap;

  /// 已选后面是否需要带小箭头。默认 false
  final bool hasArrow;

  /// 暴露给外界设置多选状态的控制器
  final SantoMultipleBottomController? bottomController;

  /// create SantoMultipleBottomButton
  const SantoMultipleBottomButton(
      {Key? key,
      this.mainButton,
      this.subButton,
      this.onMainButtonTap,
      this.onSubButtonTap,
      this.onSelectedButtonTap,
      this.onSelectAll,
      this.hasArrow = false,
      this.bottomController})
      : super(key: key);

  @override
  _SantoMultipleBottomButtonState createState() =>
      _SantoMultipleBottomButtonState();
}

class _SantoMultipleBottomButtonState extends State<SantoMultipleBottomButton> {
  late SantoMultipleBottomController _controller;
  bool _unfoldState = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.bottomController ?? SantoMultipleBottomController();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> rowChildren = <Widget>[
      _allSelectedWidget(),
      _selectedCountWidget(),
      _buttonArea(),
    ];

    return Container(
      height: 82,
      color: Colors.white,
      padding: EdgeInsets.only(top: 16, bottom: 16, left: 20, right: 20),
      child: Row(
        children: rowChildren,
      ),
    );
  }

  Widget _allSelectedWidget() {
    return widget.onSelectAll != null
        ? GestureDetector(
            onTap: () {
              //点击全选将当前状态置反，回调到外界，行为与单独点击圆圈保持一致
              bool currentState =
                  !_controller.valueNotifier.value.selectAllState;
              _controller.setState(selectAllState: currentState);
              if (widget.onSelectAll != null) widget.onSelectAll!(currentState);
            },
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: <Widget>[
                Container(
                  width: 16,
                  height: 16,
                  child: ValueListenableBuilder<MultiSelectState>(
                    valueListenable: _controller.valueNotifier,
                    builder: (context, value, _) {
                      return SantoCheckbox(
                        isSelected: value.selectAllState,
                        radioIndex: 0,
                        iconPadding: EdgeInsets.all(0),
                        onValueChangedAtIndex: (index, value) {
                          //同步到外界的当前的全选状态
                          _controller.setState(selectAllState: value);
                          if (widget.onSelectAll != null) {
                            widget.onSelectAll!(value);
                          }
                        },
                        key: Key(DateTime.now().toString()),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 4, right: 8),
                  child: Text(
                    SantoIntl.of(context).localizedResource.selectAll,
                    style: TextStyle(color: Color(0XFF222222), fontSize: 16),
                  ),
                ),
              ],
            ),
          )
        : Row();
  }

  Widget _selectedCountWidget() {
    Image unfoldWidget = SantoTools.getAssetImageWithColor(
        SantoAsset.iconSelectedUpTriangle,
        SantoThemeConfigurator.instance.getConfig().commonConfig.brandPrimary);
    Image foldWidget =
        SantoTools.getAssetImage(SantoAsset.iconUnSelectDownTriangle);

    Image cantFoldWidget = SantoTools.getAssetImageWithColor(
        SantoAsset.iconUnSelectDownTriangle, Color(0XCCCCCCCC));

    return GestureDetector(
      onTap: () {
        setState(() {
          if (widget.onSelectedButtonTap != null) {
            if (_controller.valueNotifier.value.selectedCount == 0) {
              _unfoldState = false;
              widget
                  .onSelectedButtonTap!(SantoMultipleButtonArrowState.cantUnfold);
              return;
            }
            _unfoldState = !_unfoldState;
            if (_unfoldState) {
              widget.onSelectedButtonTap!(SantoMultipleButtonArrowState.unfold);
            } else {
              widget.onSelectedButtonTap!(SantoMultipleButtonArrowState.fold);
            }
          }
        });
      },
      child: Container(
        padding: EdgeInsets.only(right: 16),
        child: Row(
          children: <Widget>[
            Text(
              SantoIntl.of(context).localizedResource.selected,
              style: TextStyle(color: Color(0XFF222222), fontSize: 16),
            ),
            ValueListenableBuilder<MultiSelectState>(
              valueListenable: _controller.valueNotifier,
              builder: (context, value, _) {
                List<Widget> rowChildren = <Widget>[];
                rowChildren.add(Text(
                  '(${value.selectedCount})',
                  style: TextStyle(
                      color: value.selectedCount != 0
                          ? SantoThemeConfigurator.instance
                              .getConfig()
                              .commonConfig
                              .brandPrimary
                          : Color(0x99999999),
                      fontSize: 16),
                ));
                if (value.selectedCount == 0) _unfoldState = false;
                if (widget.hasArrow) {
                  if (value.arrowStatus !=
                      SantoMultipleButtonArrowState.defaultStatus) {
                    //使用方主动设置箭头状态的时候
                    Widget? arrow;
                    switch (value.arrowStatus!) {
                      case SantoMultipleButtonArrowState.cantUnfold:
                        arrow = cantFoldWidget;
                        break;
                      case SantoMultipleButtonArrowState.unfold:
                        arrow = unfoldWidget;
                        break;
                      case SantoMultipleButtonArrowState.fold:
                        arrow = foldWidget;
                        break;
                      case SantoMultipleButtonArrowState.defaultStatus:
                        break;
                    }
                    //重置unfold的状态，避免主动设置箭头方向后，影响原本逻辑
                    _unfoldState =
                        value.arrowStatus == SantoMultipleButtonArrowState.fold;
                    value.arrowStatus =
                        SantoMultipleButtonArrowState.defaultStatus;

                    rowChildren.add(Container(
                      margin: EdgeInsets.only(left: 2, top: 2),
                      width: 6,
                      child: arrow ?? Row(),
                    ));
                  } else {
                    if (_unfoldState == false) {
                      rowChildren.add(Container(
                        margin: EdgeInsets.only(left: 2, top: 2),
                        width: 6,
                        child: value.selectedCount == 0
                            ? cantFoldWidget
                            : foldWidget,
                      ));
                    } else {
                      rowChildren.add(Container(
                        margin: EdgeInsets.only(left: 2, top: 2),
                        width: 6,
                        child: unfoldWidget,
                      ));
                    }
                  }
                }
                return Row(
                  children: rowChildren,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 构建右侧的按钮区域 (主按钮和次要按钮)
  Widget _buttonArea() {
    return Expanded(
      child: Row(
        children: <Widget>[_subButton(), _mainButton()],
      ),
    );
  }

  Widget _mainButton() {
    return widget.mainButton != null
        ? Expanded(
            child: GestureDetector(
              onTap: () {
                if (widget.onMainButtonTap != null) widget.onMainButtonTap!();
              },
              child: ValueListenableBuilder<MultiSelectState>(
                valueListenable: _controller.valueNotifier,
                builder: (context, value, _) {
                  return Container(
                    margin: EdgeInsets.only(left: 8),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        color: value.mainButtonState
                            ? SantoThemeConfigurator.instance
                                .getConfig()
                                .commonConfig
                                .brandPrimary
                            : Color(0xFFCCCCCC)),
                    child: widget.mainButton is String
                        ? Center(
                            child: Text(
                            widget.mainButton,
                            style: TextStyle(
                                color: value.mainButtonState
                                    ? Colors.white
                                    : Color(0xAAFFFFFF),
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ))
                        : widget.mainButton,
                  );
                },
              ),
            ),
          )
        : Row();
  }

  Widget _subButton() {
    return widget.subButton != null
        ? Expanded(
            child: GestureDetector(
              onTap: () {
                if (widget.onSubButtonTap != null) widget.onSubButtonTap!();
              },
              child: ValueListenableBuilder<MultiSelectState>(
                valueListenable: _controller.valueNotifier,
                builder: (context, value, _) {
                  return Container(
                    margin: EdgeInsets.only(left: 8),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        color: value.subButtonState
                            ? SantoThemeConfigurator.instance
                                .getConfig()
                                .commonConfig
                                .brandAuxiliary
                            : Color(0xFFCCCCCC)),
                    child: widget.subButton is String
                        ? Center(
                            child: Text(
                            widget.subButton,
                            style: TextStyle(
                                color: value.subButtonState
                                    ? Colors.white
                                    : Color(0xAAFFFFFF),
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ))
                        : widget.subButton,
                  );
                },
              ),
            ),
          )
        : Row();
  }
}

/// 多选状态栏的控制器，控制展示数量的多少
class SantoMultipleBottomController {
  SantoMultipleBottomController({this.initMultiSelectState}) {
    valueNotifier = ValueNotifier(initMultiSelectState ?? MultiSelectState());
  }

  ///
  final MultiSelectState? initMultiSelectState;

  late ValueNotifier<MultiSelectState> valueNotifier;

  /// 设置按钮的状态,当主按钮或者此按钮置灰的时候，对应的点击任然会回调，控件只做按钮置灰
  /// [selectedCount] 已选括号中的数目
  /// [selectAllState] 全选按钮的选中状态
  /// [mainButtonState] 主按钮是否置灰
  /// [subButtonState] 次按钮是否置灰
  /// [arrowStatus] 控制箭头的状态
  void setState(
      {int? selectedCount,
      bool? selectAllState,
      bool? mainButtonState,
      bool? subButtonState,
      SantoMultipleButtonArrowState? arrowStatus}) {
    MultiSelectState data = MultiSelectState(
        selectedCount: selectedCount ?? valueNotifier.value.selectedCount,
        selectAllState: selectAllState ?? valueNotifier.value.selectAllState,
        mainButtonState: mainButtonState ?? valueNotifier.value.mainButtonState,
        subButtonState: subButtonState ?? valueNotifier.value.subButtonState,
        arrowStatus: arrowStatus ?? valueNotifier.value.arrowStatus);
    valueNotifier.value = data;
  }
}

class MultiSelectState {
  /// 已选的数量
  int selectedCount;

  /// 全选按钮的状态
  bool selectAllState;

  /// 主按钮是否置灰
  bool mainButtonState;

  /// 次按钮是否置灰
  bool subButtonState;

  /// 控制箭头的状态
  SantoMultipleButtonArrowState? arrowStatus;

  MultiSelectState(
      {this.selectedCount = 0,
      this.selectAllState = false,
      this.mainButtonState = true,
      this.subButtonState = true,
      this.arrowStatus = SantoMultipleButtonArrowState.defaultStatus});
}
