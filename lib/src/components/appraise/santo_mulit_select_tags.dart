import 'package:santo_ui/src/components/picker/santo_tags_picker_config.dart';
import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 描述: 标签组，支持多选

/// 标签组的样式
enum SantoMultiSelectStyle {
  /// 等分布局
  average,

  /// 流式布局
  auto,
}

/// 获取tag显示的内容
/// data tag对应的数据模型，根据data获取tag显示的内容
typedef SantoMultiSelectTagText<V> = String Function(V data);

///提交按钮事件回调
typedef SantoMultiSelectedTagsCallback = void Function(
    List<SantoTagItemBean> selectedTags);

class SantoMultiSelectTags extends StatefulWidget {
  ///当点击到最大数目时的点击事件
  final VoidCallback? onMaxSelectClick;

  ///一行多少个数据，默认 2
  final int santoCrossAxisCount;

  ///最多选择多少个item - 默认0，可以无限选
  final int maxSelectItemCount;

  /// 本类属性
  final SantoTagsPickerConfig tagPickerBean;

  /// 获取tag显示文案
  final SantoMultiSelectTagText<SantoTagItemBean> tagText;

  /// 已选中列表
  final SantoMultiSelectedTagsCallback? selectedTagsCallback;

  /// 没有数据时的样式
  final Widget? emptyWidget;

  /// 没有数据时的样式，如果为 null，默认 EdgeInsets.only(top: 0.0, left: hSpacingLg, right: hSpacingLg, bottom: 0.0)
  final EdgeInsets? padding;

  ///是等分样式还是流式布局样式 默认等分
  final SantoMultiSelectStyle tagStyle;

  /// 是否为多选
  final bool multiSelect;

  /// 滑动选项
  final ScrollPhysics? physics;

  /// 最小宽度，默认 75
  final double minWidth;

  /// create SantoMultiSelectTags
  SantoMultiSelectTags({
    Key? key,
    required this.tagPickerBean,
    required this.tagText,
    this.onMaxSelectClick,
    this.maxSelectItemCount = 0,
    this.santoCrossAxisCount = 2,
    this.tagStyle = SantoMultiSelectStyle.average,
    this.selectedTagsCallback,
    this.emptyWidget,
    this.padding,
    this.multiSelect = true,
    this.physics,
    this.minWidth = 75,
  }) : super(key: key);

  @override
  _SantoMultiSelectTagsState createState() => _SantoMultiSelectTagsState();
}

class _SantoMultiSelectTagsState extends State<SantoMultiSelectTags> {
  /// 操作类型属性
  List<SantoTagItemBean> _selectedTags = [];
  List<SantoTagItemBean> _sourceTags = [];

  @override
  void initState() {
    super.initState();
    _dataSetup();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tagPickerBean.tagItemSource.isNotEmpty) {
      return _buildContent(context);
    } else {
      return widget.emptyWidget ??
          Container(
            height: 200,
            child: Center(
              child: Text(SantoIntl.of(context).localizedResource.noTagDataTip),
            ),
          );
    }
  }

  Widget _buildContent(BuildContext context) {
    if (widget.tagStyle == SantoMultiSelectStyle.average) {
      return _buildGridViewWidget(context);
    } else {
      return _buildWrapViewWidget(context);
    }
  }

  ///等宽度的布局
  Widget _buildGridViewWidget(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    int santoCrossAxisCount = widget.santoCrossAxisCount;
    double width = (MediaQuery.of(context).size.width -
            (santoCrossAxisCount - 1) * 12 -
            40) /
        santoCrossAxisCount;
    //计算宽高比
    double santoChildAspectRatio = width / 34.0;

    return Container(
      padding: widget.padding ??
          EdgeInsets.symmetric(horizontal: commonConfig.hSpacingLg),
      constraints: BoxConstraints(maxHeight: 322, minHeight: 120),
      child: GridView.count(
        shrinkWrap: true,
        physics: widget.physics,
        crossAxisCount: santoCrossAxisCount,
        //水平子Widget之间间距
        crossAxisSpacing: 12.0,
        //垂直子Widget之间间距
        mainAxisSpacing: 12.0,
        //宽高比
        childAspectRatio: santoChildAspectRatio,
        children: _sourceTags.map((choice) {
          return _getItem(
              choice,
              EdgeInsets.only(
                left: commonConfig.hSpacingSm,
                right: commonConfig.hSpacingSm,
                bottom: 1,
              ));
        }).toList(),
      ),
    );
  }

  ///流式布局
  Widget _buildWrapViewWidget(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Container(
        padding: widget.padding ??
            EdgeInsets.symmetric(horizontal: commonConfig.hSpacingLg),
        child: Wrap(
          spacing: commonConfig.pageGap,
          runSpacing: commonConfig.pageGap,
          children: _sourceTags.map((choice) {
            return _getItem(
                choice, EdgeInsets.all(commonConfig.vSpacingSm));
          }).toList(),
        ));
  }

  void _dataSetup() {
    List<SantoTagItemBean> tagItems = [];
    List<SantoTagItemBean> tagSelectItems = [];
    for (SantoTagItemBean item in widget.tagPickerBean.tagItemSource) {
      tagItems.add(item);
      //选中的按钮
      if (item.isSelect == true) {
        tagSelectItems.add(item);
      }
    }
    _sourceTags = tagItems;

    // 默认选中tags
    _selectedTags = tagSelectItems;
  }

  void _clickTag(bool selected, SantoTagItemBean tagName) {
    if (!widget.multiSelect) {
      /// 单选
      _sourceTags.forEach((tag) {
        tag.isSelect = false;
      });
      _selectedTags.clear();
      tagName.isSelect = true;
      _selectedTags.add(tagName);
      if (widget.selectedTagsCallback != null) {
        widget.selectedTagsCallback!(_selectedTags);
      }
    } else {
      /// 多选
      if (selected) {
        tagName.isSelect = true;
        _selectedTags.add(tagName);
      } else {
        tagName.isSelect = false;
        _selectedTags.remove(tagName);
      }
      if (widget.selectedTagsCallback != null) {
        widget.selectedTagsCallback!(_selectedTags);
      }
    }
  }

  Widget _getItem(SantoTagItemBean choice, EdgeInsets padding) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    Color selectedTagTitleColor = widget.tagPickerBean.selectedTagTitleColor ??
        SantoThemeConfigurator.instance.getConfig().commonConfig.brandPrimary;
    Color tagTitleColor = widget.tagPickerBean.tagTitleColor ??
        SantoThemeConfigurator.instance.getConfig().commonConfig.colorTextBase;
    Color tagBackgroundColor =
        widget.tagPickerBean.tagBackgroudColor ?? Color(0xFFF5F5F5);
    Color selectedTagBackgroundColor =
        widget.tagPickerBean.selectedTagBackgroudColor ??
            SantoThemeConfigurator.instance
                .getConfig()
                .commonConfig
                .brandPrimary
                .withAlpha(0x14);

    bool selected = choice.isSelect;
    Color titleColor = selected ? selectedTagTitleColor : tagTitleColor;
    Color bgColor = selected ? selectedTagBackgroundColor : tagBackgroundColor;
    String textToDisplay = widget.tagText(choice);

    return GestureDetector(
      onTap: () {
        _clickTag(!selected, choice);
        setState(() {});
      },
      child: Container(
        constraints: BoxConstraints(minWidth: widget.minWidth),
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(commonConfig.radiusXs)),
        padding: padding,
        alignment: widget.tagStyle == SantoMultiSelectStyle.average
            ? Alignment.center
            : null,
        child: Text(
          textToDisplay,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
            fontSize: commonConfig.fontSizeCaption,
            color: titleColor,
          ),
        ),
      ),
    );
  }
}
