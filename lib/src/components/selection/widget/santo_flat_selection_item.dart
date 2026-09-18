import 'dart:async';

import 'package:santo_ui/src/components/icon/santo_icon.dart';
import 'package:santo_ui/src/components/icon/santo_icons.dart';
import 'package:santo_ui/src/components/line/santo_line.dart';
import 'package:santo_ui/src/components/picker/base/santo_picker_title_config.dart';
import 'package:santo_ui/src/components/picker/time_picker/santo_date_time_formatter.dart';
import 'package:santo_ui/src/components/picker/time_picker/date_picker/santo_date_picker.dart';
import 'package:santo_ui/src/components/selection/bean/santo_selection_common_entity.dart';
import 'package:santo_ui/src/components/selection/santo_selection_util.dart';
import 'package:santo_ui/src/components/selection/dropdown_menu.dart';
import 'package:santo_ui/src/components/selection/controller/santo_flat_selection_controller.dart';
import 'package:santo_ui/src/components/selection/widget/santo_layer_more_selection_page.dart';
import 'package:santo_ui/src/components/toast/santo_toast.dart';
import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:santo_ui/src/theme/configs/santo_selection_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/cupertino.dart';

///更多的筛选项里面的single 项
///主要是分为两种：标签和跳到其他页面的layer
///标签类型包罗了：标题、有无更多的展开收起、自定义输入、标签项
///页面类型保罗了：标题、选择框
class SantoFlatMoreSelection extends StatefulWidget {
  /// 数据源
  final SantoSelectionEntity selectionEntity;

  /// 清空已选项 一般跟重置功能搭配使用
  final StreamController<FlatClearEvent>? clearController;

  /// 当[SantoSelectionEntity.filterType]为[SantoSelectionFilterType.layer] or[SantoSelectionFilterType.customLayer]时
  /// 跳转到二级页面的自定义操作
  final SantoOnCustomFloatingLayerClick? onCustomFloatingLayerClick;

  /// 每行tag数 默认3个
  final int preLineTagSize;

  /// 父容器宽度 根据父容器宽度来计算每个tag宽度  默认0
  /// 当不传入宽度，使用tag最小宽度 75
  final double parentWidth;

  /// 主题配置
  final SantoSelectionConfig themeData;

  SantoFlatMoreSelection({
    Key? key,
    required this.selectionEntity,
    this.clearController,
    this.onCustomFloatingLayerClick,
    this.preLineTagSize = 3,
    this.parentWidth = 0,
    required this.themeData,
  }) : super(key: key);

  @override
  _SantoFlatMoreSelectionState createState() => _SantoFlatMoreSelectionState();
}

class _SantoFlatMoreSelectionState extends State<SantoFlatMoreSelection> {
  @override
  Widget build(BuildContext context) {
    //弹出浮层
    if (widget.selectionEntity.filterType == SantoSelectionFilterType.layer ||
        widget.selectionEntity.filterType ==
            SantoSelectionFilterType.customLayer) {
      return FilterLayerTypeWidget(
        selectionEntity: widget.selectionEntity,
        onCustomFloatingLayerClick: widget.onCustomFloatingLayerClick,
        themeData: widget.themeData,
      );
    }
    //标签类型
    return _FilterCommonTypeWidget(
      selectionEntity: widget.selectionEntity,
      clearController: widget.clearController,
      preLineTagSize: widget.preLineTagSize,
      themeData: widget.themeData,
      parentWidth: widget.parentWidth,
    );
  }
}

/// 展示标签的布局：标题+更多+标签+自定义
// ignore: must_be_immutable
class _FilterCommonTypeWidget extends StatefulWidget {
  //楼层
  final SantoSelectionEntity selectionEntity;
  final StreamController<FlatClearEvent>? clearController;
  final int preLineTagSize;
  final double parentWidth;
  final SantoSelectionConfig themeData;

  _FilterCommonTypeWidget(
      {required this.selectionEntity,
      this.clearController,
      this.preLineTagSize = 3,
      this.parentWidth = 0,
      required this.themeData});

  @override
  __FilterCommonTypeWidgetState createState() =>
      __FilterCommonTypeWidgetState();
}

class __FilterCommonTypeWidgetState extends State<_FilterCommonTypeWidget> {
  bool isExpanded = false;

  ///展开收起的通知
  late ValueNotifier<bool> _valueNotifier;

  ///用于 range和 tag 之间通信
  late StreamController<Event> _streamController;

  /// 标签宽度
  double _tagWidth = 0;

  /// 标签行间距
  double _spacing = 12;

  /// 行边距
  double _padding = 20;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController.broadcast();

    //如果是输入事件
    //如果是单选的情况，将选中的tag清空
    //如果是多选则，不作处理
    _streamController.stream.listen((event) {
      if (event is InputEvent) {
        setState(() {
          if (!event.filter) {
            //将所有tag设置为未选中
            event.rangeEntity.parent?.currentTagListForEntity().forEach((data) {
              data.clearSelectedEntity();
            });
          }
        });
      }
    });

    //展开收起的事件
    _valueNotifier = ValueNotifier<bool>(isExpanded);
    _valueNotifier.addListener(() {
      setState(() {
        isExpanded = _valueNotifier.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    try {
      _tagWidth = (widget.parentWidth -
              _spacing * (widget.preLineTagSize - 1) -
              _padding * 2) /
          widget.preLineTagSize;
      //保留小数点后3位
      _tagWidth = double.parse(_tagWidth
          .toStringAsFixed(4)
          .substring(0, _tagWidth.toStringAsFixed(4).length - 1));
      _tagWidth = _tagWidth < 75 ? 75 : _tagWidth;
    } catch (e) {
      debugPrint('get tag width error');
      _tagWidth = 75;
    }
    return Padding(
      padding: EdgeInsets.only(
          left: commonConfig.hSpacingLg, right: commonConfig.hSpacingLg),
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: commonConfig.vSpacingLg),
                child: _buildTitleWidget(),
              ),
              Visibility(
                visible: widget.selectionEntity
                        .currentShowTagByExpanded(isExpanded).isNotEmpty,
                child: Container(
                  padding: EdgeInsets.only(top: commonConfig.gapMd),
                  child: _buildOptionWidgets(),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Visibility(
              visible: widget.selectionEntity.currentTagListForEntity().length >
                  widget.selectionEntity.getDefaultShowCount(),
              child: _MoreArrow(
                valueNotifier: _valueNotifier,
                themeData: widget.themeData,
              ),
            ),
          )
        ],
      ),
    );
  }

  ///标题和更多，比如商圈
  ///更多的展示逻辑：可展示的标签>默认展示的标签
  ///比如 后端下发 默认展示3个，但是可展示的只有2个，则不展示更多
  ///可展示标签：目前的逻辑为：非自定义的项
  Widget _buildTitleWidget() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            widget.selectionEntity.title,
            style: widget.themeData.titleForMoreTextStyle.generateTextStyle(),
          ),
        ),
      ],
    );
  }

  /// 自定义筛选条件的显示
  Widget _buildRangeWidget() {
    return widget.selectionEntity.currentRangeListForEntity().isEmpty
        ? const SizedBox.shrink()
        : _MoreRangeWidget(
            streamController: _streamController,
            clearController: widget.clearController,
            rangeEntity: widget.selectionEntity.currentRangeListForEntity()[0],
            themeData: widget.themeData,
            width: _tagWidth);
  }

  /// 标签的筛选条件显示  单选和多选是由 父节点控制
  /// 如果是单选： 先将选中的清空、再添加选中
  /// 如果是多选： 直接添加筛选项
  List<Widget> _buildSelectionTag() {
    return widget.selectionEntity
        .currentShowTagByExpanded(isExpanded)
        .map((SantoSelectionEntity data) {
      return GestureDetector(
        onTap: () {
          setState(() {
            if (data.filterType == SantoSelectionFilterType.radio) {
              data.parent?.clearSelectedEntity();
              data.isSelected = true;
              //用于发送 标签点击事件
              _streamController.add(SelectEvent());
            } else if (data.filterType == SantoSelectionFilterType.checkbox) {
              if (!data.isSelected) {
                if (!SantoSelectionUtil.checkMaxSelectionCount(data)) {
                  SantoToast.show(SantoIntl.of(context).localizedResource.filterConditionCountLimited, context);
                  return;
                }
              }

              data.parent?.children
                  .where((item) => item.filterType == SantoSelectionFilterType.radio)
                  .forEach((f) => f.isSelected = false);
              data.isSelected = !data.isSelected;
              //用于发送 标签点击事件
              _streamController.add(SelectEvent());
            } else if (data.filterType == SantoSelectionFilterType.date) {
              _showDatePicker(data);
            }
          });
        },
        child: _buildSingleTag(data),
      );
    }).toList();
  }

  /// 展示规则
  /// 当默认显示tag数大于tag总数时range跟着展示
  /// 当默认显示tag数<= tag总数时，仅展示tag
  /// 当点击更多时全部展示
  Widget _buildOptionWidgets() {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    List<Widget> widgets = [];
    widgets.addAll(_buildSelectionTag());
    if (isExpanded ||
        (widget.selectionEntity.currentRangeListForEntity().isNotEmpty &&
            widget.selectionEntity.isOverCurrentTagListSize())) {
      widgets.add(_buildRangeWidget());
    }

    return Wrap(
      spacing: _spacing,
      runSpacing: commonConfig.gapMd,
      children: widgets,
    );
  }

  Widget _buildSingleTag(SantoSelectionEntity data) {
    bool isDate = data.filterType == SantoSelectionFilterType.date;

    String showName;

    if (isDate) {
      if (data.value == null || data.value!.isEmpty) {
        showName = data.title;
      } else {
        int time = int.tryParse(data.value ?? "") ??
            DateTime.now().millisecondsSinceEpoch;
        showName = DateTimeFormatter.formatDate(
            DateTime.fromMillisecondsSinceEpoch(time),
            'yyyy/MMMM/dd');
      }
    } else {
      showName = data.title;
    }
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: data.isSelected
              ? widget.themeData.tagSelectedBackgroundColor
              : widget.themeData.tagNormalBackgroundColor,
          borderRadius: BorderRadius.circular(widget.themeData.tagRadius)),
      height: 34,
      width: _tagWidth,
      child: Text(
        showName,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: data.isSelected ? _selectedTextStyle() : _tagTextStyle(),
      ),
    );
  }

  TextStyle _tagTextStyle() {
    return widget.themeData.tagNormalTextStyle.generateTextStyle();
  }

  TextStyle _selectedTextStyle() {
    return widget.themeData.tagSelectedTextStyle.generateTextStyle();
  }

  void _showDatePicker(SantoSelectionEntity data) {
    int time =
        int.tryParse(data.value ?? "") ?? DateTime.now().millisecondsSinceEpoch;
    SantoDatePicker.showDatePicker(context,
        pickerMode: SantoDateTimePickerMode.date,
        pickerTitleConfig: SantoPickerTitleConfig.Default,
        initialDateTime: DateTime.fromMillisecondsSinceEpoch(time),
        dateFormat: SantoIntl.of(context).localizedResource.dateFormatYYYYMMMMDD, onConfirm: (dateTime, list) {
      if (mounted) {
        setState(() {
          data.parent?.clearSelectedEntity();
          data.isSelected = true;
          data.value = dateTime.millisecondsSinceEpoch.toString();
        });
      }
    }, onChanged: (dateTime, list) {}, onCancel: () {}, onClose: () {});
  }
}

/// 更多和箭头widget
class _MoreArrow extends StatefulWidget {
  ///用于通知 展开和收起
  final ValueNotifier<bool>? valueNotifier;
  final SantoSelectionConfig themeData;

  _MoreArrow({this.valueNotifier, required this.themeData});

  @override
  __MoreArrowState createState() => __MoreArrowState();
}

class __MoreArrowState extends State<_MoreArrow> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    Widget icon = isExpanded
        ? SantoIcon(SantoIcons.navArrowUp)
        : SantoIcon(SantoIcons.navArrowDown);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
          if (widget.valueNotifier != null) {
            widget.valueNotifier!.value = isExpanded;
          }
        });
      },
      child: Container(
        padding: EdgeInsets.only(
            top: commonConfig.vSpacingLg, bottom: commonConfig.vSpacingLg),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(SantoIntl.of(context).localizedResource.more,
                style: widget.themeData.moreTextStyle.generateTextStyle()),
            Container(
              height: 16,
              width: 16,
              padding: EdgeInsets.only(left: commonConfig.hSpacingXs),
              child: icon,
            )
          ],
        ),
      ),
    );
  }
}

/// 自定义筛选条件
// ignore: must_be_immutable
class _MoreRangeWidget extends StatefulWidget {
  ///用于标签和自定义输入 通信
  final StreamController? streamController;

  ///用于自定义的筛选条件 最大值最小值
  final SantoSelectionEntity rangeEntity;

  ///用于监听重置事件
  final StreamController<FlatClearEvent>? clearController;

  final double width;

  final SantoSelectionConfig themeData;

  _MoreRangeWidget({
    Key? key,
    required this.rangeEntity,
    this.streamController,
    this.clearController,
    this.width = 0,
    required this.themeData,
  }) : super(key: key);

  @override
  __MoreRangeWidgetState createState() => __MoreRangeWidgetState();
}

class __MoreRangeWidgetState extends State<_MoreRangeWidget> {
  /// 最小值 输入框监听
  TextEditingController minController = TextEditingController();

  /// 最大值 输入框监听
  TextEditingController maxController = TextEditingController();

  /// 最小值 焦点监听
  FocusNode minFocusNode = FocusNode();

  /// 最大值 焦点监听
  FocusNode maxFocusNode = FocusNode();

  //默认的最大值
  int max = 9999;

  //默认的最小值
  int min = 0;

  @override
  void initState() {
    super.initState();

    widget.clearController?.stream.listen((event) {
      minController.clear();
      maxController.clear();
    });

    if (widget.rangeEntity.customMap == null) {
      widget.rangeEntity.customMap = Map<String, String>();
    }

    minController.text = (widget.rangeEntity.customMap!['min'] != null)
        ? widget.rangeEntity.customMap!['min']?.toString() ?? ''
        : '';
    maxController.text = (widget.rangeEntity.customMap!['max'] != null)
        ? widget.rangeEntity.customMap!['max']?.toString() ?? ''
        : '';

    min = int.tryParse(widget.rangeEntity.extMap['min']?.toString() ?? '') ?? 0;
    max = int.tryParse(widget.rangeEntity.extMap['max']?.toString() ?? '') ??
        9999;

    ///处理的逻辑：
    ///       1：将输入框的 文本写入 customMap中
    ///       2：如果最大值和最小值满足条件 则将range选中
    minController.addListener(() {
      String maxInput = maxController.text;
      String minInput = minController.text;

      widget.rangeEntity.customMap!['min'] = minInput;

      if (minInput.isNotEmpty && maxInput.isNotEmpty) {
        int? inputMin = int.tryParse(minController.text);
        int? inputMax = int.tryParse(maxController.text);

        if (inputMin != null &&
            inputMin >= min &&
            inputMax != null &&
            inputMax <= max &&
            inputMin <= inputMax) {
          widget.rangeEntity.isSelected = true;
        } else {
          widget.rangeEntity.isSelected = false;
        }
      } else {
        widget.rangeEntity.isSelected = false;
      }
    });

    maxController.addListener(() {
      String maxInput = maxController.text;
      String minInput = minController.text;
      widget.rangeEntity.customMap!['max'] = maxInput;

      if (minInput.isNotEmpty && maxInput.isNotEmpty) {
        int inputMin = int.tryParse(minController.text) ?? -1;
        int inputMax = int.tryParse(maxController.text) ?? -1;
        if (inputMin >= min && inputMax <= max && inputMin <= inputMax) {
          widget.rangeEntity.isSelected = true;
        } else {
          widget.rangeEntity.isSelected = false;
        }
      } else {
        widget.rangeEntity.isSelected = false;
      }
    });

    ///只要获取了焦点
    ///        如果是单选 则将选中的清楚
    ///        如果是多选 则不处理
    minFocusNode.addListener(() {
      if (minFocusNode.hasFocus) {
        widget.streamController
            ?.add(InputEvent(filter: false, rangeEntity: widget.rangeEntity));
      }
    });

    maxFocusNode.addListener(() {
      if (maxFocusNode.hasFocus) {
        widget.streamController
            ?.add(InputEvent(filter: false, rangeEntity: widget.rangeEntity));
      }
    });

    ///用于监听tab的点击事件
    ///如果父亲是单选 则将输入框清空并失去焦点，并且将自定义筛选设置为 未选中,以及更新用于显示的map
    widget.streamController?.stream.listen((event) {
      if (event is SelectEvent) {
        maxController.clear();
        minController.clear();
        widget.rangeEntity.customMap?.remove('min');
        widget.rangeEntity.customMap?.remove('max');
        minFocusNode.unfocus();
        maxFocusNode.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _buildRangeField(
            SantoIntl.of(context).localizedResource.minValue, minController, minFocusNode, widget.width, widget.themeData),
        Padding(
          padding: EdgeInsets.only(left: 2),
        ),
        Container(
          color: Color(0xffDCDEE2),
          height: 1,
          width: 8,
        ),
        Padding(
          padding: EdgeInsets.only(right: 2),
        ),
        _buildRangeField(
            SantoIntl.of(context).localizedResource.maxValue, maxController, maxFocusNode, widget.width, widget.themeData),
      ],
    );
  }

  Widget _buildRangeField(
    String hint,
    TextEditingController textEditingController,
    FocusNode focusNode,
    double width,
    SantoSelectionConfig themeData,
  ) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFF9F9F9),
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      height: 32,
      width: width,
      child: Center(
          child: CupertinoTextField(
        maxLines: 1,
        placeholder: hint,
        placeholderStyle: widget.themeData.hintTextStyle.generateTextStyle(),
        focusNode: focusNode,
        textAlign: TextAlign.center,
        controller: textEditingController,
        cursorColor: themeData.commonConfig.brandPrimary,
        keyboardType: TextInputType.number,
        style: widget.themeData.inputTextStyle.generateTextStyle(),
        decoration: null,
      )),
    );
  }
}

/// 浮层类型的项 ： 标题 + 点击跳转的layout
class FilterLayerTypeWidget extends StatefulWidget {
  //entity是 商圈
  final SantoSelectionEntity selectionEntity;
  final SantoOnCustomFloatingLayerClick? onCustomFloatingLayerClick;
  final SantoSelectionConfig themeData;

  FilterLayerTypeWidget(
      {required this.selectionEntity,
      this.onCustomFloatingLayerClick,
      required this.themeData});

  @override
  _FilterLayerTypeWidgetState createState() => _FilterLayerTypeWidgetState();
}

class _FilterLayerTypeWidgetState extends State<FilterLayerTypeWidget> {
  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    widget.selectionEntity.configDefaultValue();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              left: commonConfig.hSpacingLg, top: commonConfig.vSpacingLg),
          child: Text(
            widget.selectionEntity.title,
            style: widget.themeData.titleForMoreTextStyle.generateTextStyle(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: commonConfig.hSpacingLg,
              right: commonConfig.hSpacingLg,
              top: commonConfig.vSpacingXs),
          child: GestureDetector(
            onTap: () {
              if (widget.selectionEntity.filterType ==
                  SantoSelectionFilterType.layer) {
                Navigator.of(context)
                    .push(PageRouteBuilder<SantoSelectionEntity>(
                        opaque: false,
                        pageBuilder: (context, animation, second) {
                          return SantoLayerMoreSelectionPage(
                            entityData: widget.selectionEntity,
                            themeData: widget.themeData,
                          );
                        }))
                    .then((data) {
                  updateContent();
                });
              } else if (widget.selectionEntity.filterType ==
                  SantoSelectionFilterType.customLayer) {
                if (widget.onCustomFloatingLayerClick != null) {
                  int entityIndex = -1;
                  if (widget.selectionEntity.parent != null &&
                      widget.selectionEntity.parent!.children.isNotEmpty) {
                    entityIndex = widget.selectionEntity.parent!.children
                        .indexOf(widget.selectionEntity);
                  }
                  widget.onCustomFloatingLayerClick!(
                      entityIndex, widget.selectionEntity,
                      (List<SantoSelectionEntity> customFloatingLayerParams) {
                    widget.selectionEntity.children.clear();
                    widget.selectionEntity.children
                        .addAll(customFloatingLayerParams);
                    widget.selectionEntity.configDefaultValue();
                    setState(() {});
                  });
                }
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(isEmptyCondition() ? SantoIntl.of(context).localizedResource.pleaseChoose : getCondition(),
                      style: isEmptyCondition()
                          ? widget.themeData.hintTextStyle.generateTextStyle()
                          : widget.themeData.optionTextStyle
                              .generateTextStyle()),
                ),
                SantoIcon(SantoIcons.navArrowRight, size: 16)
              ],
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: commonConfig.vSpacingMd),
            child: SantoLine())
      ],
    );
  }

  void updateContent() {
    setState(() {});
  }

  bool isEmptyCondition() {
    String condition = getCondition();
    return condition.isEmpty;
  }

  String getCondition() {
    String tmp = "";
    //返回所有选中的
    List<SantoSelectionEntity> selectedList =
        widget.selectionEntity.selectedList();

    //判断步骤：
    //第一步：取出来所有选中的： 房山 不限 小白楼 西城 不限
    //第二步：判断显示的条件（非不限，没有选中的子节点）
    //       比如：房山 的不限---需要展示房山，但是由于选了房山的小白楼 则显示小白楼
    //场景1 ： 选中了房山的不限
    //       selectedList返回了 房山   不限
    //       迭代房山是非不限  并且没有选中的非不限子节点    结果会添加房山
    //       迭代了不限      不限是不限类型    结果不添加不限
    //场景2 ： 选中了房山的小白楼
    //        selectedList返回了 房山   小白楼
    //        迭代房山是非不限  并且有选中的非不限子节点    结果不会添加房山
    //        迭代小白楼是非不限  并且没有有选中的非不限子节点    结果添加小白楼

    //过滤规则
    //  1：滤掉不限
    //  2：滤掉有选中的非不限的叶子节点
    List<SantoSelectionEntity> result = selectedList.where((value) {
      return !value.isUnLimit() && value.selectedListWithoutUnlimit().isEmpty;
    }).toList();

    for (int i = 0; i < result.length; i++) {
      tmp += result[i].title;
      if (i != result.length - 1) {
        tmp += '、';
      }
    }
    return tmp;
  }
}

/// tag 和 range 之间的通信
abstract class Event {}

/// tag点击的事件
class SelectEvent extends Event {}

/// 输入框的事件:携带 自定义的筛选条件 和 过滤标识位
/// 由于点击标签之后，会清空筛选条件，清空的时候，textField的监听也会执行一遍，因此需要过滤
class InputEvent extends Event {
  SantoSelectionEntity rangeEntity;
  bool filter;

  InputEvent({required this.rangeEntity, required this.filter});
}
