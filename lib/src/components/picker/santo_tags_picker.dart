import 'package:santo_ui/src/components/button/santo_big_main_button.dart';
import 'package:santo_ui/src/components/input/santo_input_text.dart';
import 'package:santo_ui/src/components/picker/base/santo_picker_title_config.dart';
import 'package:santo_ui/src/components/picker/santo_tags_common_picker.dart';
import 'package:santo_ui/src/components/picker/santo_tags_picker_config.dart';
import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:santo_ui/src/components/tag/tagview/santo_select_tag.dart';
import 'package:santo_ui/src/theme/santo_theme.dart';
import 'package:flutter/material.dart';

/// 标签选择弹框的布局样式
///
/// * [average] 等分布局
/// * [auto] 流式布局
enum SantoTagsPickerLayoutStyle {
  /// 等分布局
  average,

  /// 流式布局
  auto,
}

/// 标签展示文本的取值回调
typedef SantoTagsPickerValueGetter = String Function(SantoTagItemBean data);

/// 标签点击回调
typedef SantoTagsPickerItemClick = void Function(
    SantoTagItemBean onTapTag, bool isSelect);

/// 确认回调:返回选中的标签与输入内容(未开启输入框时为空串)
typedef SantoTagsPickerConfirm = void Function(
    List<SantoTagItemBean> selectedTags, String inputText);

/// 确认结果
class SantoTagsPickerResult {
  /// 选中的标签
  final List<SantoTagItemBean> selectedTags;

  /// 输入框内容(未开启输入框时为空串)
  final String inputText;

  const SantoTagsPickerResult(this.selectedTags, this.inputText);
}

/// 标签选择弹框(底部弹出)
///
/// 由原先的「多选标签弹框」与「带输入框的选择器」合并而来,通过参数区分:
/// * [multiSelect] 多选/单选,多选时可用 [maxSelectItemCount] 限制可选个数(0 表示不限)
/// * [showTextInput] 是否带输入框,开启后可通过 [hintText]/[maxLength] 等配置输入区
/// * [layoutStyle] 等分布局或流式布局,[crossAxisCount] 控制等分布局每行个数
///
/// 示例:
/// ```dart
/// SantoTagsPicker(
///   context: context,
///   onConfirm: (tags, text) {},
///   onTagValueGetter: (tag) => tag.name,
///   multiSelect: true,
///   showTextInput: true,
///   tagPickerConfig: SantoTagsPickerConfig(tagItemSource: items),
/// ).show();
/// ```
// ignore: must_be_immutable
class SantoTagsPicker extends CommonTagsPicker {
  SantoTagsPicker({
    Key? key,
    required this.context,
    required SantoTagsPickerConfirm onConfirm,
    this.onCancel,
    required this.tagPickerConfig,
    required this.onTagValueGetter,
    this.onMaxSelectClick,
    this.onItemClick,
    this.multiSelect = true,
    this.maxSelectItemCount = 0,
    this.crossAxisCount,
    this.itemHeight = 34.0,
    this.layoutStyle = SantoTagsPickerLayoutStyle.average,
    this.showTextInput = false,
    this.hintText,
    this.maxLength = 200,
    this.defaultText,
    this.textEditingController,
    this.cursorColor,
    SantoPickerTitleConfig pickerTitleConfig = SantoPickerTitleConfig.Default,
    SantoPickerConfig? themeData,
  }) : super(
            key: key,
            context: context,
            // 带输入框时用底部提交按钮,隐藏标题栏的「完成」
            pickerTitleConfig: showTextInput
                ? pickerTitleConfig.copyWith(confirm: const SizedBox.shrink())
                : pickerTitleConfig,
            themeData: themeData,
            onCancel: onCancel,
            onConfirm: (Object? data) {
              if (data is SantoTagsPickerResult) {
                onConfirm(data.selectedTags, data.inputText);
              }
            });

  /// 父类属性
  final BuildContext context;

  /// 点击取消按钮
  final VoidCallback? onCancel;

  /// 当点击到最大数目时的点击事件
  final VoidCallback? onMaxSelectClick;

  /// 点击某个标签的回调
  final SantoTagsPickerItemClick? onItemClick;

  /// 一行多少个数据,默认 4 个
  final int? crossAxisCount;

  /// 最多选择多少个 item,0 表示不限
  final int maxSelectItemCount;

  /// 多选还是单选,默认多选
  final bool multiSelect;

  /// 本类属性
  final SantoTagsPickerConfig tagPickerConfig;

  /// 传入的泛型数据转换为展示文本
  final SantoTagsPickerValueGetter onTagValueGetter;

  /// 布局样式,默认等分
  final SantoTagsPickerLayoutStyle layoutStyle;

  /// item 的高度,默认 34
  final double itemHeight;

  /// 是否展示输入框,默认 false
  final bool showTextInput;

  /// 输入框提示文案
  final String? hintText;

  /// 输入框最大字符数,默认 200
  final int maxLength;

  /// 输入框默认文本
  final String? defaultText;

  /// 输入框控制器
  final TextEditingController? textEditingController;

  /// 输入框光标颜色
  final Color? cursorColor;

  /// 操作类型属性
  late List<SantoTagItemBean> _selectedTags;
  late List<SantoTagItemBean> _sourceTags;

  /// 输入框内容(未传 [textEditingController] 时由组件自己记录)
  String _inputText = '';

  /// 选择超限被拒绝时自增,用于重建 [SantoSelectTag] 回滚选中状态
  int _tagStateEpoch = 0;

  @override
  void show() {
    _dataSetup();
    super.show();
  }

  @override
  Object getConfirmData() {
    return SantoTagsPickerResult(
      this._selectedTags,
      textEditingController?.text ?? _inputText,
    );
  }

  @override
  Widget createBuilder(BuildContext context, VoidCallback? onUpdate) {
    if (this.tagPickerConfig.tagItemSource.isNotEmpty) {
      return _buildContent(context, onUpdate);
    }
    return Container(
      height: 200,
      child: Center(
        child: Text(SantoIntl.of(context).localizedResource.noTagDataTip),
      ),
    );
  }

  void _dataSetup() {
    _inputText = defaultText ?? '';
    List<SantoTagItemBean> tagItems = [];
    List<SantoTagItemBean> tagSelectedItems = [];
    for (SantoTagItemBean item in this.tagPickerConfig.tagItemSource) {
      tagItems.add(item);
      if (item.isSelect) {
        tagSelectedItems.add(item);
      }
      if (!multiSelect && tagSelectedItems.length > 1) {
        tagSelectedItems.removeRange(1, tagSelectedItems.length);
      }
    }
    this._sourceTags = tagItems;
    // name 越长越靠后
    this._sourceTags.sort((left, right) {
      return (left.name.length).compareTo(right.name.length);
    });
    this._selectedTags = tagSelectedItems;
  }

  Widget _buildContent(BuildContext context, VoidCallback? onUpdate) {
    final Widget tags = _buildTagsWidget(context, onUpdate);
    if (!showTextInput) {
      return tags;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        tags,
        _buildInputArea(context, onUpdate),
      ],
    );
  }

  /// 标签区:复用可选择标签组件 [SantoSelectTag]
  ///
  /// 等分布局用固定宽度排 [crossAxisCount] 列,流式布局按内容自适应宽度;
  /// 内容区四周留白与标签间距统一取 hSpacingMd / vSpacingMd
  Widget _buildTagsWidget(BuildContext context, VoidCallback? onUpdate) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final bool average = layoutStyle == SantoTagsPickerLayoutStyle.average;
    final double spacing = commonConfig.hSpacingMd;
    return LayoutBuilder(builder: (_, constraints) {
      final int count =
          (this.crossAxisCount == null || this.crossAxisCount == 0)
              ? 4
              : this.crossAxisCount!;
      // 固定宽度向下取整,保证一行排满 count 个
      final double tagWidth = ((constraints.maxWidth -
                  spacing * 2 -
                  spacing * (count - 1)) /
              count)
          .floorToDouble();
      return Container(
        padding: EdgeInsets.symmetric(
            vertical: commonConfig.vSpacingMd,
            horizontal: commonConfig.hSpacingMd),
        child: SantoSelectTag(
          // 选中状态由本组件掌管:单选收敛、超限回滚时自增 epoch 重建,
          // 让 SantoSelectTag 回到 _sourceTags 的选中状态
          key: ValueKey<int>(_tagStateEpoch),
          tags: _sourceTags.map((tag) => onTagValueGetter(tag)).toList(),
          isSingleSelect: false,
          initTagState: _sourceTags.map((tag) => tag.isSelect).toList(),
          fixWidthMode: average,
          tagWidth: average ? tagWidth : null,
          tagHeight: itemHeight,
          spacing: spacing,
          verticalSpacing: commonConfig.vSpacingMd,
          tagTextStyle: TextStyle(
            height: 1,
            fontSize: this.tagPickerConfig.tagTitleFontSize,
            color: this.tagPickerConfig.tagTitleColor ??
                commonConfig.colorTextImportant,
          ),
          selectedTagTextStyle: TextStyle(
            height: 1,
            fontSize: this.tagPickerConfig.tagTitleFontSize,
            fontWeight: FontWeight.w500,
            color: this.tagPickerConfig.selectedTagTitleColor ??
                commonConfig.brandPrimary,
          ),
          tagBackgroundColor:
              this.tagPickerConfig.tagBackgroudColor ?? const Color(0xFFF5F5F5),
          selectedTagBackgroundColor:
              this.tagPickerConfig.selectedTagBackgroudColor ??
                  commonConfig.brandPrimary,
          onChanged: (indexes) => _handleTagChanged(indexes, onUpdate),
        ),
      );
    });
  }

  /// 标签选中变化
  ///
  /// 单选时只保留最新点选的一项;超出可选上限时回滚本次选择并回调
  /// [onMaxSelectClick]
  void _handleTagChanged(List<int> selectedIndexes, VoidCallback? onUpdate) {
    List<int> next = selectedIndexes;
    if (!multiSelect && next.length > 1) {
      final List<int> previous = <int>[];
      for (int index = 0; index < _sourceTags.length; index++) {
        if (_sourceTags[index].isSelect) previous.add(index);
      }
      next = <int>[
        next.firstWhere((index) => !previous.contains(index),
            orElse: () => next.last),
      ];
    }
    if (maxSelectItemCount > 0 && next.length > maxSelectItemCount) {
      if (this.onMaxSelectClick != null) {
        this.onMaxSelectClick!();
      }
      // 回滚:重建选择组件,回到上一次的选中状态
      _tagStateEpoch++;
      onUpdate!();
      return;
    }
    if (next.length != selectedIndexes.length) {
      // 单选收敛后的结果与组件内部状态不同,重建组件以同步
      _tagStateEpoch++;
    }
    for (int index = 0; index < _sourceTags.length; index++) {
      final SantoTagItemBean tag = _sourceTags[index];
      final bool selected = next.contains(index);
      if (tag.isSelect == selected) {
        continue;
      }
      tag.isSelect = selected;
      if (this.onItemClick != null) {
        this.onItemClick!(tag, selected);
      }
    }
    _selectedTags = next.map((index) => _sourceTags[index]).toList();
    onUpdate!();
  }

  @override
  Widget? buildFooter(BuildContext context, VoidCallback? onUpdate) {
    if (!showTextInput) {
      return null;
    }
    return _buildSubmitButton(context);
  }

  /// 带输入框时允许更高,保证标签、输入区与底部按钮都能放下
  @override
  double maxContentHeight(BuildContext context) {
    if (!showTextInput) {
      return 370.0;
    }
    return MediaQuery.of(context).size.height * 0.8;
  }

  /// 底部提交按钮:未选中标签时置灰
  Widget _buildSubmitButton(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: commonConfig.vSpacingMd,
          horizontal: commonConfig.hSpacingMd),
      child: SantoBigMainButton(
        title: SantoIntl.of(context).localizedResource.submit,
        isEnable: _selectedTags.isNotEmpty,
        onTap: () {
          Navigator.of(context).pop(SantoCommonPickBackType.confirm);
        },
      ),
    );
  }

  /// 输入区:复用输入框组件,支持多行与字数限制
  Widget _buildInputArea(BuildContext context, VoidCallback? onUpdate) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Container(
      color: Colors.white,
      // 底边留白交给底部提交按钮,避免与按钮的间距翻倍
      padding: EdgeInsets.symmetric(horizontal: commonConfig.hSpacingMd),
      child: SantoInputText(
        controller: textEditingController,
        initialValue:
            textEditingController == null ? (defaultText ?? '') : null,
        hintText: hintText ??
            SantoIntl.of(context).localizedResource.pleaseEnter,
        maxLength: maxLength,
        indicator: true,
        maxLines: null,
        minLines: 2,
        cursorColor: cursorColor ?? commonConfig.brandPrimary,
        onChanged: (text) {
          _inputText = text;
          onUpdate?.call();
        },
      ),
    );
  }
}
