import 'package:santo_ui/src/components/form/utils/santo_form_util.dart';
import 'package:santo_ui/src/components/line/santo_line.dart';
import 'package:santo_ui/src/components/radio/santo_radio_button.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_form_config.dart';
import 'package:flutter/material.dart';

/// 备选项点击时的回调。[oldStr] 旧的选项，如果初始没有选中项，该参数为null，[newStr] 新选中的选项。
typedef SantoPortraitRadioGroupOnChanged = void Function(
    SantoPortraitRadioGroupOption? oldStr, SantoPortraitRadioGroupOption newStr);

/// 纵向放置的单选 radio 视图。选项可为单行字符串，也可是标题+说明两部分。具体参见 [SantoPortraitRadioGroupOption]。
/// 选项的标题/子标题文字样式分别通过 [SantoFormItemConfig.optionTextStyle] 和 [SantoFormItemConfig.subTitleTextStyle] 控
/// 制，可通过主题配置进行修改。
// ignore: must_be_immutable
class SantoPortraitRadioGroup extends StatefulWidget {
  /// 录入项内容是否可编辑，false 时全部选项置灰，默认为 true。
  final bool isEdit;

  /// 初始化时默认选中的项，匹配逻辑是 [SantoPortraitRadioGroupOption.title] 和 [SantoPortraitRadioGroupOption.subTitle] 都相等。
  final SantoPortraitRadioGroupOption? selectedOption;

  /// 备选项数组，参数类型为 [SantoPortraitRadioGroupOption]
  final List<SantoPortraitRadioGroupOption>? options;

  /// 备选项可用状态数组
  final List<bool>? enableList;

  /// 选项变化回调
  final SantoPortraitRadioGroupOnChanged? onChanged;

  /// [options] 中 title subTitle 是否换行展示。
  /// false: 换行展示
  /// true: 只展示一行，一行展示不下末尾[...]省略展示
  /// 默认值为 false
  final bool isCollapseContent;

  /// 主题配置数据
  SantoFormItemConfig? themeData;

  /// 通过传入一个字符串数组 [options]，快捷构造出单行选项文案的纵向单选视图。
  SantoPortraitRadioGroup.withSimpleList({
    Key? key,
    this.isEdit = true,
    String selectedOption = "",
    required List<String> options,
    this.enableList,
    this.onChanged,
    this.themeData,
    this.isCollapseContent = false,
  })  : this.options = options
            .map((item) => SantoPortraitRadioGroupOption(title: item))
            .toList(),
        this.selectedOption = options.contains(selectedOption)
            ? SantoPortraitRadioGroupOption(
                title: options[options.indexOf(selectedOption)])
            : SantoPortraitRadioGroupOption(),
        super(key: key) {
    this.themeData ??= SantoFormItemConfig();
    this.themeData = SantoThemeConfigurator.instance
        .getConfig(configId: this.themeData!.configId)
        .formItemConfig
        .merge(this.themeData);
  }

  /// 通过 [SantoPortraitRadioGroupOption] 类型的数组 [options]，构造纵向单选视图。
  SantoPortraitRadioGroup.withOptions({
    Key? key,
    this.isEdit = true,
    this.selectedOption,
    this.options,
    this.enableList,
    this.onChanged,
    this.isCollapseContent = false,
    this.themeData,
  }) : super(key: key) {
    this.themeData ??= SantoFormItemConfig();
    this.themeData = SantoThemeConfigurator.instance
        .getConfig(configId: this.themeData!.configId)
        .formItemConfig
        .merge(this.themeData);
  }

  @override
  SantoPortraitRadioGroupState createState() {
    return SantoPortraitRadioGroupState();
  }
}

class SantoPortraitRadioGroupState extends State<SantoPortraitRadioGroup> {
  late SantoPortraitRadioGroupOption? _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.themeData!.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: getRadioList(widget.options),
      ),
    );
  }

  List<Widget> getRadioList(List<SantoPortraitRadioGroupOption>? options) {
    List<Widget> result = [];
    SantoPortraitRadioGroupOption option;
    if (options == null || options.isEmpty) {
      result.add(Container());
      return result;
    }

    result.add(SantoLine(
      leftInset: 20,
    ));

    for (int index = 0; index < options.length; ++index) {
      option = options[index];
      result.add(
        Container(
          padding: EdgeInsets.only(top: 14, bottom: 14, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SantoRadioButton(
                child: Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    option.title ?? '',
                    overflow:
                        widget.isCollapseContent ? TextOverflow.ellipsis : null,
                    maxLines: widget.isCollapseContent ? 1 : null,
                    style: getOptionTextStyle(option, index),
                  ),
                ),
                childOnRight: false,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                disable: getRadioEnableState(index),
                radioIndex: index,
                isSelected: index == getGroupValue(),
                onValueChangedAtIndex: (int position, bool selected) {
                  if (getRadioEnableState(position)) {
                    return;
                  }
                  SantoPortraitRadioGroupOption? oldValue = _selectedOption;
                  _selectedOption = options[position];
                  if (widget.onChanged != null) {
                    widget.onChanged!(oldValue, options[position]);
                  }
                  setState(() {});
                },
              ),
              Visibility(
                visible: option.subTitle != null && option.subTitle!.isNotEmpty,
                child: Padding(
                  padding: EdgeInsets.only(top: 4, right: 20),
                  child: Text(
                    option.subTitle ?? '',
                    overflow:
                        widget.isCollapseContent ? TextOverflow.ellipsis : null,
                    maxLines: widget.isCollapseContent ? 1 : null,
                    style: SantoFormUtil.getSubTitleTextStyle(widget.themeData!),
                  ),
                ),
              )
            ],
          ),
        ),
      );

      result.add(SantoLine(
        leftInset: 20,
        rightInset: 20,
      ));
    }

    return result;
  }

  int getGroupValue() {
    int selectedIndex = -1;
    for (int index = 0; index < widget.options!.length; index++) {
      if (isSameOption(widget.options![index], _selectedOption)) {
        selectedIndex = index;
        break;
      }
    }
    return selectedIndex;
  }

  bool isSameOption(
      SantoPortraitRadioGroupOption src, SantoPortraitRadioGroupOption? dst) {
    if (dst == null) return false;
    return src.title == dst.title && src.subTitle == dst.subTitle;
  }

  TextStyle getOptionTextStyle(SantoPortraitRadioGroupOption opt, int index) {
    TextStyle result = SantoFormUtil.getOptionTextStyle(widget.themeData!);

    if (isSameOption(opt, _selectedOption)) {
      result = SantoFormUtil.getOptionSelectedTextStyle(widget.themeData!);
    }

    if (!widget.isEdit) {
      result = SantoFormUtil.getIsEditTextStyle(widget.themeData!, widget.isEdit);
    }

    if (widget.enableList != null &&
        widget.enableList!.isNotEmpty &&
        widget.enableList!.length > index &&
        !widget.enableList![index]) {
      result = SantoFormUtil.getIsEditTextStyle(widget.themeData!, false);
    }

    return result;
  }

  bool getRadioEnableState(int index) {
    if (!widget.isEdit) {
      return true;
    }

    if (widget.enableList == null ||
        widget.enableList!.isEmpty ||
        widget.enableList!.length < index) {
      return false;
    }

    return !widget.enableList![index];
  }
}

/// 纵置单选视图的选项模型。文字样式见 [SantoPortraitRadioGroup] 说明。
class SantoPortraitRadioGroupOption {
  /// 标题
  String? title;

  /// 子标题说明文案
  String? subTitle;

  SantoPortraitRadioGroupOption({this.title, this.subTitle});
}
