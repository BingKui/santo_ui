import 'package:santo_ui/src/components/picker/base/santo_picker_title_config.dart';
import 'package:santo_ui/src/components/picker/santo_tags_common_picker.dart';
import 'package:santo_ui/src/components/picker/santo_tags_picker_config.dart';
import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:santo_ui/src/theme/santo_theme.dart';
import 'package:flutter/material.dart';

///样式的枚举类型
/// [average] 等分布局
/// [auto] 流式布局
enum SantoMultiSelectTagsLayoutStyle {
  ///等分布局
  average,

  ///流式布局
  auto,
}

typedef SantoMultiSelectTagStringBuilder<V> = String Function(V data);
typedef SantoMultiSelectTagOnItemClick = void Function(
    SantoTagItemBean onTapTag, bool isSelect);

/// 多选标签弹框,适用于底部弹出 Picker，且选择样式为 Tag 的场景。
/// 功能：多选标签弹框，适用于从底部弹出的情况，属于 Picker；
/// 可自定义标题、默认选中、字体大小等。
// ignore: must_be_immutable
class SantoMultiSelectTagsPicker extends CommonTagsPicker {
  SantoMultiSelectTagsPicker({
    Key? key,
    required this.context,
    required this.onConfirm,
    this.onCancel,
    required this.tagPickerConfig,
    required this.onTagValueGetter,
    this.onMaxSelectClick,
    this.onItemClick,
    this.maxSelectItemCount = 0,
    this.crossAxisCount,
    this.itemHeight = 34.0,
    this.layoutStyle = SantoMultiSelectTagsLayoutStyle.average,
    SantoPickerTitleConfig pickerTitleConfig = SantoPickerTitleConfig.Default,
    SantoPickerConfig? themeData,
  }) : super(
            key: key,
            context: context,
            onConfirm: onConfirm,
            onCancel: onCancel,
            pickerTitleConfig: pickerTitleConfig,
            themeData: themeData);

  /// 父类属性
  final BuildContext context;

  /// 点击提交功能
  final ValueChanged onConfirm;

  /// 点击取消按钮
  final VoidCallback? onCancel;

  /// 当点击到最大数目时的点击事件
  final VoidCallback? onMaxSelectClick;

  /// 点击某个按钮的回调
  final SantoMultiSelectTagOnItemClick? onItemClick;

  /// 一行多少个数据，默认4个
  final int? crossAxisCount;

  /// 最多选择多少个item，默认可以无限选
  final int maxSelectItemCount;

  /// 本类属性
  final SantoTagsPickerConfig tagPickerConfig;

  /// 传入的泛型数据转换为 [SantoTagItemBean]
  /// 默认以填充Widget
  final SantoMultiSelectTagStringBuilder<SantoTagItemBean> onTagValueGetter;

  /// 是等分样式还是流式布局样式，[SantoMultiSelectTagsLayoutStyle]，默认等分
  final SantoMultiSelectTagsLayoutStyle layoutStyle;

  /// item的高度, 默认数值是34
  final double itemHeight;

  /// 操作类型属性
  late List<SantoTagItemBean> _selectedTags;
  late List<SantoTagItemBean> _sourceTags;

  @override
  void show() {
    _dataSetup();
    super.show();
  }

  @override
  Object getConfirmData() {
    return this._selectedTags;
  }

  @override
  Widget createBuilder(BuildContext context, VoidCallback? onUpdate) {
    if (this.tagPickerConfig.tagItemSource.isNotEmpty) {
      return _buildContent(context, onUpdate);
    } else {
      return Container(
        height: 200,
        child: Center(
          child: Text(SantoIntl.of(context).localizedResource.noTagDataTip),
        ),
      );
    }
  }

  Widget _buildContent(BuildContext context, VoidCallback? onUpdate) {
    if (this.layoutStyle == SantoMultiSelectTagsLayoutStyle.average) {
      return LayoutBuilder(
        builder: (_, constraints) {
          double maxWidth = constraints.maxWidth;
          return _buildGridViewWidget(context, onUpdate, maxWidth);
        },
      );
    } else {
      return _buildWrapViewWidget(context, onUpdate);
    }
  }

  ///等宽度的布局
  Widget _buildGridViewWidget(
      BuildContext context, VoidCallback? onUpdate, double maxWidth) {
    int santoCrossAxisCount =
        (this.crossAxisCount == null || this.crossAxisCount == 0)
            ? 4
            : this.crossAxisCount!;
    double width =
        (maxWidth - (santoCrossAxisCount - 1) * 12 - 40) / santoCrossAxisCount;
    //计算宽高比
    double santoChildAspectRatio = width / this.itemHeight;
    Color selectedTagTitleColor = this.tagPickerConfig.selectedTagTitleColor ??
        SantoThemeConfigurator.instance.getConfig().commonConfig.brandPrimary;
    Color tagTitleColor = this.tagPickerConfig.tagTitleColor ??
        SantoThemeConfigurator.instance
            .getConfig()
            .commonConfig
            .colorTextImportant;
    Color tagBackgroundColor =
        this.tagPickerConfig.tagBackgroudColor ?? Color(0xffF8F8F8);
    Color selectedTagBackgroundColor =
        this.tagPickerConfig.selectedTagBackgroudColor ??
            SantoThemeConfigurator.instance
                .getConfig()
                .commonConfig
                .brandPrimary
                .withAlpha(0x14);
    return Container(
      padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
      constraints: BoxConstraints(maxHeight: 322, minHeight: 120),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: santoCrossAxisCount,
        //水平子Widget之间间距
        crossAxisSpacing: 6.0,
        //垂直子Widget之间间距
        mainAxisSpacing: 12.0,
        //宽高比
        childAspectRatio: santoChildAspectRatio,
        //GridView内边距
        padding:
            EdgeInsets.only(top: 20.0, left: 0.0, right: 0.0, bottom: 20.0),
        primary: true,
        children: this._sourceTags.map((choice) {
          bool selected = choice.isSelect;
          Color titleColor = selected ? selectedTagTitleColor : tagTitleColor;
          EdgeInsets edgeInsets = this.tagPickerConfig.chipPadding ??
              EdgeInsets.only(top: 9.0, left: 10.0, right: 10, bottom: 11.0);
          return ChoiceChip(
            selected: selected,
            padding: edgeInsets,
            pressElevation: 0,
            backgroundColor: tagBackgroundColor,
            selectedColor: selectedTagBackgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            label: Container(
              width: width,
              child: Text(
                onTagValueGetter(choice),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                strutStyle: StrutStyle(forceStrutHeight: true, height: 1),
                style: TextStyle(
                    height: 1,
                    color: titleColor,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: this.tagPickerConfig.tagTitleFontSize),
              ),
            ),
            onSelected: (bool value) {
              if (_selectedTags.length >= this.maxSelectItemCount &&
                  this.maxSelectItemCount > 0 &&
                  value == true) {
                if (this.onMaxSelectClick != null) {
                  // ignore: unnecessary_statements
                  this.onMaxSelectClick!();
                }
                return;
              }
              _clickTag(value, choice);
              onUpdate!();
            },
          );
        }).toList(),
      ),
    );
  }

  ///流式布局
  Widget _buildWrapViewWidget(BuildContext context, VoidCallback? onUpdate) {
    SantoTagConfig tagConfig = SantoThemeConfigurator.instance
        .getConfig(configId: themeData!.configId)
        .tagConfig
        .merge(SantoTagConfig());
    tagConfig = tagConfig.merge(SantoTagConfig(
        selectTagTextStyle: SantoTextStyle(
            height: 1,
            color: this.tagPickerConfig.selectedTagTitleColor,
            fontSize: this.tagPickerConfig.tagTitleFontSize,
            fontWeight: FontWeight.w600),
        tagTextStyle: SantoTextStyle(
            height: 1,
            color: this.tagPickerConfig.tagTitleColor,
            fontSize: this.tagPickerConfig.tagTitleFontSize,
            fontWeight: FontWeight.w400),
        tagBackgroundColor: this.tagPickerConfig.tagBackgroudColor,
        selectedTagBackgroundColor:
            this.tagPickerConfig.selectedTagBackgroudColor));

    return Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Wrap(
          spacing: 15.0,
          runSpacing: 15.0,
          children: this._sourceTags.map((choice) {
            bool selected = choice.isSelect;
            Color titleColor = selected
                ? tagConfig.selectTagTextStyle.color!
                : tagConfig.tagTextStyle.color!;
            EdgeInsets edgeInsets = this.tagPickerConfig.chipPadding ??
                EdgeInsets.only(top: 9.0, left: 10.0, right: 10, bottom: 11.0);
            return ChoiceChip(
              selected: selected,
              padding: edgeInsets,
              pressElevation: 0,
              backgroundColor: tagConfig.tagBackgroundColor,
              selectedColor: tagConfig.selectedTagBackgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              label: Text(
                onTagValueGetter(choice),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                strutStyle: StrutStyle(forceStrutHeight: true, height: 1),
                style: TextStyle(
                    height: 1,
                    color: titleColor,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: this.tagPickerConfig.tagTitleFontSize),
              ),
              onSelected: (bool value) {
                if (_selectedTags.length >= this.maxSelectItemCount &&
                    this.maxSelectItemCount > 0 &&
                    value == true) {
                  if (this.onMaxSelectClick != null) {
                    // ignore: unnecessary_statements
                    this.onMaxSelectClick!();
                  }
                  return;
                }
                _clickTag(value, choice);
                onUpdate!();
              },
            );
          }).toList(),
        ));
  }

  void _dataSetup() {
    List<SantoTagItemBean> tagItems = [];
    List<SantoTagItemBean> tagSelectItems = [];
    for (SantoTagItemBean item in this.tagPickerConfig.tagItemSource) {
      tagItems.add(item);
      //选中的按钮
      if (item.isSelect == true) {
        tagSelectItems.add(item);
      }
    }
    this._sourceTags = tagItems;

    // 默认选中tags
    this._selectedTags = tagSelectItems;
  }

  ///每一个item的点击事件
  void _clickTag(bool selected, SantoTagItemBean tagName) {
    if (selected) {
      tagName.isSelect = true;
      this._selectedTags.add(tagName);
    } else {
      tagName.isSelect = false;
      this._selectedTags.remove(tagName);
    }

    ///点击tag
    if (this.onItemClick != null) {
      this.onItemClick!(tagName, selected);
    }
  }
}
