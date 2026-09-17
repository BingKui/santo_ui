import 'package:santo_ui/src/components/picker/santo_picker_cliprrect.dart';
import 'package:santo_ui/src/constants/santo_asset_constants.dart';
import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/utils/santo_tools.dart';
import 'package:flutter/material.dart';

///传入的泛型数据转换为值 以填充Widget
typedef SelectTagWithInputValueGetter<V> = String Function(V data);

///提交按钮事件回调
typedef SantoTagInputConfirmClickCallback = Future<void>? Function(
    BuildContext dialogContext,
    List<SantoTagInputItemBean>? selectedTags,
    String content);

///关闭 picker回调
typedef SantoTagInputCancelClickCallBack = void Function(BuildContext context);

/// 底部弹出的标签选择器，支持文本内容输入。支持单选、多选标签。
class SantoSelectTagsWithInputPicker extends Dialog {
  ///弹窗自定义标题
  final String title;

  ///输入框默认提示文案
  final String? hintText;

  ///输入框最大能输入的字符长度。默认值 200
  final int maxLength;

  ///输入内容事件回调
  final SantoTagInputConfirmClickCallback? confirm;

  ///关闭 picker 回调
  final SantoTagInputCancelClickCallBack? cancelCallBack;

  ///光标颜色
  final Color? cursorColor;

  /// 默认文本
  final String? defaultText;

  /// 用于对 TextField 更精细的控制，若传入该字段，[defaultText] 参数将失效，可使用 TextEditingController.text 进行赋值。
  final TextEditingController? textEditingController;

  /// 强制显示文本框
  final bool forceShowTextInput;

  /// 多选/单选
  final bool multiSelect;

  /// tags 数据源
  final SantoTagsInputPickerConfig tagPickerConfig;

  /// 动态获取标签的展示文本回调
  final SelectTagWithInputValueGetter<SantoTagInputItemBean> onTagValueGetter;

  const SantoSelectTagsWithInputPicker(
      {this.maxLength = 200,
      this.hintText,
      this.title = "",
      this.confirm,
      this.cancelCallBack,
      this.cursorColor,
      this.forceShowTextInput = false,
      this.multiSelect = false,
      this.defaultText,
      this.textEditingController,
      required this.tagPickerConfig,
      required this.onTagValueGetter});

  @override
  Widget build(BuildContext context) {
    return SantoSelectTagsWithInputPickerWidget(
      title: title,
      confirm: confirm,
      maxLength: maxLength,
      hintText: hintText ?? SantoIntl.of(context).localizedResource.pleaseEnter,
      cursorColor: cursorColor ??
          SantoThemeConfigurator.instance.getConfig().commonConfig.brandPrimary,
      forceShowTextInput: forceShowTextInput,
      multiSelect: multiSelect,
      defaultText: defaultText,
      textEditingController: textEditingController,
      tagPickerBean: tagPickerConfig,
      onTagValueGetter: onTagValueGetter,
    );
  }
}

class SantoSelectTagsWithInputPickerWidget extends StatefulWidget {
  final String? title;
  final SantoTagInputConfirmClickCallback? confirm;
  final SantoTagInputCancelClickCallBack? cancelCallBack;
  final int? maxLength;
  final String? hintText;
  final Color? cursorColor;
  final bool forceShowTextInput;
  final bool multiSelect;
  final String? defaultText;
  final TextEditingController? textEditingController;
  final SantoTagsInputPickerConfig? tagPickerBean;
  final SelectTagWithInputValueGetter<SantoTagInputItemBean>? onTagValueGetter;

  const SantoSelectTagsWithInputPickerWidget(
      {Key? key,
      this.title,
      this.confirm,
      this.cancelCallBack,
      this.maxLength,
      this.hintText,
      this.cursorColor,
      this.forceShowTextInput = false,
      this.multiSelect = false,
      this.defaultText,
      this.textEditingController,
      this.tagPickerBean,
      this.onTagValueGetter})
      : super(key: key);

  @override
  _SantoSelectTagsWithInputPickerWidgetState createState() =>
      _SantoSelectTagsWithInputPickerWidgetState();
}

class _SantoSelectTagsWithInputPickerWidgetState
    extends State<SantoSelectTagsWithInputPickerWidget>
    with AutomaticKeepAliveClientMixin {
  TextEditingController? _textEditingController;

  /// 暂定只支持两列标签
  int santoCrossAxisCount = 2;

  late List<SantoTagInputItemBean> _selectedTags;
  late List<SantoTagInputItemBean> _sourceTags;

  @override
  void initState() {
    super.initState();
    _dataSetup();
    _textEditingController = widget.textEditingController ??
        TextEditingController.fromValue(TextEditingValue(
            text: widget.defaultText == null ? "" : widget.defaultText!,
            selection: TextSelection.fromPosition(TextPosition(
                affinity: TextAffinity.downstream,
                offset: widget.defaultText != null
                    ? widget.defaultText!.length
                    : 0))));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0x33808695),
      body: Container(
        alignment: Alignment.bottomCenter,
        child: SantoPickerClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SantoThemeConfigurator.instance
                .getConfig()
                .pickerConfig
                .cornerRadius),
            topRight: Radius.circular(SantoThemeConfigurator.instance
                .getConfig()
                .pickerConfig
                .cornerRadius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: (widget.tagPickerBean?.tagItemSource.isNotEmpty ?? false)
                ? _buildBody(context)
                : _buildNoTagsBody(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNoTagsBody(BuildContext context) {
    return [
      _headerArea(context),
      Container(
        color: Colors.white,
        height: 200,
        child: Center(
          child: Text(SantoIntl.of(context).localizedResource.noTagDataTip),
        ),
      ),
    ];
  }

  List<Widget> _buildBody(BuildContext context) {
    return [
      _headerArea(context),
      Container(
        color: Colors.white,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 220),
          child: ListView(
            shrinkWrap: true,
            controller: ScrollController(keepScrollOffset: false),
            children: <Widget>[
              _tagsArea(context),
              Offstage(
                offstage: !isShowTextInput(),
                child: _inputArea(context),
              ),
            ],
          ),
        ),
      ),
      _confirmButton(context),
    ];
  }

  void _dataSetup() {
    List<SantoTagInputItemBean> tagItems = [];
    List<SantoTagInputItemBean> tagSelectedItems = [];
    if (widget.tagPickerBean != null) {
      for (SantoTagInputItemBean item in widget.tagPickerBean!.tagItemSource) {
        tagItems.add(item);
        //选中的按钮
        if (item.isSelect == true) {
          tagSelectedItems.add(item);
        }
      }
    }


    this._sourceTags = tagItems;
    // 重新排序，name 越长，越靠后
    this._sourceTags.sort((left, right) {
      return (left.name.length).compareTo(right.name.length);
    });

    // 默认选中tags
    this._selectedTags = tagSelectedItems;
  }

  Widget _headerArea(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
          left: commonConfig.hSpacingLg,
          right: commonConfig.hSpacingLg,
          top: commonConfig.vSpacingLg,
          bottom: commonConfig.vSpacingLg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            widget.title ?? '',
            style: TextStyle(
              color: SantoThemeConfigurator.instance
                  .getConfig()
                  .commonConfig
                  .colorTextBase,
              fontSize: commonConfig.fontSizeHead,
              fontWeight: FontWeight.w500,
            ),
          ),
          GestureDetector(
              onTap: () {
                if (widget.cancelCallBack != null) {
                  widget.cancelCallBack!(context);
                }
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: EdgeInsets.all(commonConfig.vSpacingXs),
                child: SantoTools.getAssetImage(SantoAsset.iconPickerClose),
              ))
        ],
      ),
    );
  }

  double paintWidthWithTextStyle(String content, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: content, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.width;
  }

  double preferredWidthWithText(String content) {
    double originalTextWidth = paintWidthWithTextStyle(
        content, TextStyle(fontSize: widget.tagPickerBean!.tagTitleFontSize));
    double maxTextWidthInHalf = (MediaQuery.of(context).size.width -
                (santoCrossAxisCount - 1) * 12 -
                20 * 2) /
            santoCrossAxisCount -
        16;
    return originalTextWidth > maxTextWidthInHalf
        ? (MediaQuery.of(context).size.width - 20 * 2 - 8 * 2)
        : maxTextWidthInHalf;
  }

  Widget _tagsArea(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    Color selectedTagTitleColor = widget.tagPickerBean?.selectedTagTitleColor ??
        SantoThemeConfigurator.instance.getConfig().commonConfig.brandPrimary;
    Color tagTitleColor = widget.tagPickerBean?.tagTitleColor ??
        SantoThemeConfigurator.instance
            .getConfig()
            .commonConfig
            .colorTextImportant;
    Color tagBackgroundColor =
        widget.tagPickerBean?.tagBackgroundColor ?? Color(0xffF5F5F5);
    Color selectedTagBackgroundColor =
        widget.tagPickerBean?.selectedTagBackgroundColor ??
            SantoThemeConfigurator.instance
                .getConfig()
                .commonConfig
                .brandPrimary
                .withOpacity(0.14);

    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(
            left: commonConfig.hSpacingLg,
            right: commonConfig.hSpacingSm,
            bottom: 12),
        child: Wrap(
          spacing: commonConfig.pageGap,
          children: this._sourceTags.map((choice) {
            bool selected = choice.isSelect;
            Color titleColor = selected ? selectedTagTitleColor : tagTitleColor;
            String textToDisplay = widget.onTagValueGetter!(choice);
            return ChoiceChip(
              selected: selected,
              backgroundColor: tagBackgroundColor,
              selectedColor: selectedTagBackgroundColor,
              pressElevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(commonConfig.radiusXs)),
              padding: EdgeInsets.zero,
              labelPadding: EdgeInsets.only(
                  left: commonConfig.hSpacingSm,
                  right: commonConfig.hSpacingSm),
              labelStyle: TextStyle(
                  color: titleColor,
                  fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                  fontSize: widget.tagPickerBean!.tagTitleFontSize),
              label: Container(
                width: preferredWidthWithText(textToDisplay),
                child: Text(
                  textToDisplay,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              onSelected: (bool value) {
                _clickTag(value, choice);
                setState(() {});
              },
            );
          }).toList(),
        ));
  }

  void _clickTag(bool selected, SantoTagInputItemBean tagName) {
    if (selected) {
      if (!widget.multiSelect) {
        this._selectedTags.forEach((tagItem) {
          tagItem.isSelect = false;
        });
        this._selectedTags.clear();
      }
      tagName.isSelect = true;
      this._selectedTags.add(tagName);
    } else {
      tagName.isSelect = false;
      this._selectedTags.remove(tagName);
    }
  }

  Widget _inputArea(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Container(
      height: 100,
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(
            left: commonConfig.hSpacingLg, right: commonConfig.hSpacingLg),
        padding: EdgeInsets.only(
            left: commonConfig.hSpacingLg,
            right: commonConfig.hSpacingLg,
            bottom: commonConfig.vSpacingMd),
        decoration: BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(commonConfig.radiusXs),
        ),
        child: TextField(
            style: TextStyle(
                fontSize: commonConfig.fontSizeSubHead,
                color: SantoThemeConfigurator.instance
                    .getConfig()
                    .commonConfig
                    .colorTextBase),
            controller: _textEditingController,
            maxLines: 6,
            maxLength: widget.maxLength,
            cursorColor: widget.cursorColor,
            onChanged: (text) {
              setState(() {});
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(
                  fontSize: commonConfig.fontSizeSubHead,
                  color: SantoThemeConfigurator.instance
                      .getConfig()
                      .commonConfig
                      .colorTextHint),
              counterStyle: TextStyle(
                  fontSize: commonConfig.fontSizeCaption,
                  color: SantoThemeConfigurator.instance
                      .getConfig()
                      .commonConfig
                      .colorTextHint),
              hintText: widget.hintText,
            )),
      ),
    );
  }

  Widget _confirmButton(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 72,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
            left: commonConfig.hSpacingLg,
            right: commonConfig.hSpacingLg,
            top: commonConfig.vSpacingMd,
            bottom: commonConfig.vSpacingMd),
        child: GestureDetector(
          onTap: () {
            if (!isCommitBtnEnable()) return;
            if (widget.confirm != null) {
              widget.confirm!(
                  context, this._selectedTags, _textEditingController!.text);
            }
          },
          child: Container(
            height: 48,
            decoration: BoxDecoration(
                color: isCommitBtnEnable()
                    ? SantoThemeConfigurator.instance
                        .getConfig()
                        .commonConfig
                        .brandPrimary
                    : Color(0xffcccccc),
                borderRadius: BorderRadius.all(
                    Radius.circular(commonConfig.radiusXs))),
            child: Center(
              child: Text(
                  SantoIntl.of(context).localizedResource.submit,
                style: TextStyle(
                    fontSize: commonConfig.fontSizeSubHead,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isCommitBtnEnable() {
    bool needExpend = false;
    for (int i = 0; i < this._selectedTags.length; i++) {
      SantoTagInputItemBean santoTagInputItemBean = this._selectedTags[i];
      if (true == santoTagInputItemBean.needExpend) {
        needExpend = true;
        break;
      }
    }
    return this._selectedTags.isNotEmpty &&
        (needExpend ? _textEditingController!.text.isNotEmpty : true);
  }

  bool isShowTextInput() {
    if (widget.forceShowTextInput) {
      return true;
    }
    for (int i = 0; i < this._selectedTags.length; i++) {
      SantoTagInputItemBean santoTagInputItemBean = this._selectedTags[i];
      if (true == santoTagInputItemBean.needExpend) {
        return true;
      }
    }
    _textEditingController!.clear();
    return false;
  }

  @override
  bool get wantKeepAlive => true;
}

/// 数据源
class SantoTagInputItemBean {
  /// 标签展示的文案
  String name;

  ///选中状态
  bool isSelect;

  ///选中tag的index
  int? index;

  /// 选中后是否展示文本输入框
  bool needExpend;

  /// 附带的更多数据，方便在点击回调中取用。
  Map? ext;

  SantoTagInputItemBean({
    this.name = '',
    this.isSelect = false,
    this.index,
    this.needExpend = false,
    this.ext,
  });
}

class SantoTagsInputPickerConfig {
  SantoTagsInputPickerConfig(
      {this.tagTitleFontSize = 16.0,
      this.tagTitleColor,
      this.selectedTagTitleColor,
      this.tagBackgroundColor,
      this.selectedTagBackgroundColor,
      this.tagItemSource = const []}) {
    this.tagTitleColor =
        SantoThemeConfigurator.instance.getConfig().commonConfig.colorTextBase;
  }

  double tagTitleFontSize;
  Color? tagTitleColor;
  Color? selectedTagTitleColor;
  Color? tagBackgroundColor;
  Color? selectedTagBackgroundColor;

  List<SantoTagInputItemBean> tagItemSource;
}
