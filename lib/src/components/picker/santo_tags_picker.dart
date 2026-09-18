import 'package:santo_ui/src/components/button/santo_button.dart';
import 'package:santo_ui/src/components/input/santo_input_text.dart';
import 'package:santo_ui/src/components/picker/base/santo_picker_title_config.dart';
import 'package:santo_ui/src/components/picker/santo_tags_common_picker.dart';
import 'package:santo_ui/src/components/tag/tagview/santo_select_tag.dart';
import 'package:santo_ui/src/l10n/santo_intl.dart';
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

/// 标签点击回调,index 为 [SantoTagsPicker.tags] 中的下标
typedef SantoTagsPickerItemClick = void Function(int index, bool isSelect);

/// 确认回调:返回选中标签的下标与输入内容(未开启输入框时为空串)
typedef SantoTagsPickerConfirm = void Function(
    List<int> selectedIndexes, String inputText);

/// 确认结果
class SantoTagsPickerResult {
  /// 选中的下标,对应传入的 tags 顺序
  final List<int> selectedIndexes;

  /// 输入框内容(未开启输入框时为空串)
  final String inputText;

  const SantoTagsPickerResult(this.selectedIndexes, this.inputText);
}

/// 标签选择弹框(底部弹出)
///
/// 标签区复用可选择标签组件 [SantoSelectTag],数据直接用标签文案列表,
/// 选中结果以下标形式回调,与 [SantoSelectTag] 的 API 保持一致。
///
/// 通过参数区分形态:
/// * [multiSelect] 多选/单选,多选时可用 [maxSelectItemCount] 限制可选个数(0 表示不限)
/// * [showTextInput] 是否带输入框,开启后可通过 [hintText]/[maxLength] 等配置输入区
/// * [layoutStyle] 等分布局或流式布局,[crossAxisCount] 控制等分布局每行个数
///
/// 示例:
/// ```dart
/// SantoTagsPicker(
///   context: context,
///   tags: const ['标签一', '标签二', '标签三'],
///   onConfirm: (indexes, text) {},
///   multiSelect: true,
///   showTextInput: true,
/// ).show();
/// ```
// ignore: must_be_immutable
class SantoTagsPicker extends CommonTagsPicker {
  SantoTagsPicker({
    Key? key,
    required this.context,
    required this.tags,
    required SantoTagsPickerConfirm onConfirm,
    this.onCancel,
    this.onItemClick,
    this.onMaxSelectClick,
    this.multiSelect = true,
    this.maxSelectItemCount = 0,
    this.initialSelectedIndexes,
    this.crossAxisCount,
    this.layoutStyle = SantoTagsPickerLayoutStyle.average,
    this.tagHeight = 34.0,
    this.tagTextStyle,
    this.selectedTagTextStyle,
    this.tagBackgroundColor,
    this.selectedTagBackgroundColor,
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
                onConfirm(data.selectedIndexes, data.inputText);
              }
            });

  /// 父类属性
  final BuildContext context;

  /// 标签文案列表,回调里的下标对应这里的顺序
  final List<String> tags;

  /// 点击取消按钮
  final VoidCallback? onCancel;

  /// 点击某个标签的回调
  final SantoTagsPickerItemClick? onItemClick;

  /// 当点击到最大数目时的点击事件
  final VoidCallback? onMaxSelectClick;

  /// 一行多少个数据,默认 4 个
  final int? crossAxisCount;

  /// 最多选择多少个 item,0 表示不限
  final int maxSelectItemCount;

  /// 多选还是单选,默认多选
  final bool multiSelect;

  /// 初始选中的下标,单选时只取第一个
  final List<int>? initialSelectedIndexes;

  /// 布局样式,默认等分
  final SantoTagsPickerLayoutStyle layoutStyle;

  /// 标签高度,默认 34
  final double tagHeight;

  /// 未选中标签的文字样式,默认取标签主题配置
  final TextStyle? tagTextStyle;

  /// 选中标签的文字样式,默认取标签主题配置
  final TextStyle? selectedTagTextStyle;

  /// 未选中标签底色,默认 0xFFF5F5F5
  final Color? tagBackgroundColor;

  /// 选中标签底色,默认品牌色
  final Color? selectedTagBackgroundColor;

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

  /// 每个标签是否选中,下标与 [tags] 对齐
  late List<bool> _selected;

  /// 输入框内容(未传 [textEditingController] 时由组件自己记录)
  String _inputText = '';

  /// 选择超限被拒绝时自增,用于重建 [SantoSelectTag] 回滚选中状态
  int _tagStateEpoch = 0;

  /// 已选中的下标
  List<int> get _selectedIndexes {
    final List<int> indexes = <int>[];
    for (int index = 0; index < _selected.length; index++) {
      if (_selected[index]) indexes.add(index);
    }
    return indexes;
  }

  @override
  void show() {
    _dataSetup();
    super.show();
  }

  @override
  Object getConfirmData() {
    return SantoTagsPickerResult(
      _selectedIndexes,
      textEditingController?.text ?? _inputText,
    );
  }

  @override
  Widget createBuilder(BuildContext context, VoidCallback? onUpdate) {
    if (tags.isEmpty) {
      return Container(
        height: 200,
        child: Center(
          child: Text(SantoIntl.of(context).localizedResource.noTagDataTip),
        ),
      );
    }
    return _buildContent(context, onUpdate);
  }

  void _dataSetup() {
    _inputText = defaultText ?? '';
    _selected = List<bool>.filled(tags.length, false);
    for (final int index in initialSelectedIndexes ?? const <int>[]) {
      if (index >= 0 && index < _selected.length) {
        _selected[index] = true;
      }
    }
    // 单选只保留第一个已选项
    if (!multiSelect) {
      final int firstSelected = _selected.indexOf(true);
      if (firstSelected >= 0) {
        _selected = List<bool>.filled(tags.length, false);
        _selected[firstSelected] = true;
      }
    }
  }

  Widget _buildContent(BuildContext context, VoidCallback? onUpdate) {
    final Widget tagsWidget = _buildTagsWidget(context, onUpdate);
    if (!showTextInput) {
      return tagsWidget;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        tagsWidget,
        _buildInputArea(context, onUpdate),
      ],
    );
  }

  /// 标签区:复用可选择标签组件 [SantoSelectTag]
  ///
  /// 等分布局用固定宽度排 [crossAxisCount] 列,流式布局按内容自适应宽度;
  /// 内容区四周留白与标签间距统一取 gapMd
  Widget _buildTagsWidget(BuildContext context, VoidCallback? onUpdate) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final bool average = layoutStyle == SantoTagsPickerLayoutStyle.average;
    final double spacing = commonConfig.gapMd;
    return LayoutBuilder(builder: (_, constraints) {
      final int count =
          (this.crossAxisCount == null || this.crossAxisCount == 0)
              ? 4
              : this.crossAxisCount!;
      // 固定宽度向下取整,保证一行排满 count 个
      final double tagWidth =
          ((constraints.maxWidth - spacing * 2 - spacing * (count - 1)) / count)
              .floorToDouble();
      return Container(
        padding: EdgeInsets.symmetric(
            vertical: commonConfig.gapMd, horizontal: commonConfig.gapMd),
        child: SantoSelectTag(
          // 选中状态由本组件掌管:单选收敛、超限回滚时自增 epoch 重建,
          // 让 SantoSelectTag 回到 _selected 的选中状态
          key: ValueKey<int>(_tagStateEpoch),
          tags: tags,
          isSingleSelect: false,
          initTagState: _selected,
          fixWidthMode: average,
          tagWidth: average ? tagWidth : null,
          tagHeight: tagHeight,
          spacing: spacing,
          verticalSpacing: commonConfig.gapMd,
          tagTextStyle: tagTextStyle,
          selectedTagTextStyle: selectedTagTextStyle,
          tagBackgroundColor: tagBackgroundColor ?? const Color(0xFFF5F5F5),
          selectedTagBackgroundColor:
              selectedTagBackgroundColor ?? commonConfig.brandPrimary,
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
    final List<int> previous = _selectedIndexes;
    List<int> next = selectedIndexes;
    if (!multiSelect && next.length > 1) {
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
    _selected = List<bool>.filled(tags.length, false);
    for (final int index in next) {
      if (index >= 0 && index < _selected.length) {
        _selected[index] = true;
      }
    }
    if (this.onItemClick != null) {
      for (int index = 0; index < tags.length; index++) {
        final bool selected = next.contains(index);
        if (selected == previous.contains(index)) continue;
        this.onItemClick!(index, selected);
      }
    }
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
          vertical: commonConfig.gapMd, horizontal: commonConfig.gapMd),
      child: SantoButton(
        text: SantoIntl.of(context).localizedResource.submit,
        type: SantoButtonType.primary,
        size: SantoButtonSize.large,
        block: true,
        isEnable: _selected.contains(true),
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
      padding: EdgeInsets.symmetric(horizontal: commonConfig.gapMd),
      child: SantoInputText(
        controller: textEditingController,
        initialValue:
            textEditingController == null ? (defaultText ?? '') : null,
        hintText: hintText ?? SantoIntl.of(context).localizedResource.pleaseEnter,
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
