import 'package:santo_ui/src/components/appraise/santo_appraise_emoji_list_view.dart';
import 'package:santo_ui/src/components/appraise/santo_appraise_header.dart';
import 'package:santo_ui/src/components/appraise/santo_appraise_star_list_view.dart';
import 'package:santo_ui/src/components/button/santo_big_main_button.dart';
import 'package:santo_ui/src/components/input/santo_input_text.dart';
import 'package:santo_ui/src/components/appraise/santo_appraise_config.dart';
import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';
import 'package:santo_ui/src/components/appraise/santo_appraise_interface.dart';

/// /// /// /// /// /// /// /// /// /
/// 描述: 评价组件
/// 1. 支持表情包和星星两种
/// 2. 最多支持5个表情和5颗星
/// 3. 支持自定义title，标签等，在SantoAppraiseConfig里配置
/// 4. 可以用在页面里面也可以使用在弹窗里面，使用在底部弹窗的参考[SantoAppraiseBottomPicker]
/// /// /// /// /// /// /// /// /// /

class SantoAppraise extends StatefulWidget {
  /// 标题
  final String title;

  /// 标题类型，取值[SantoAppraiseHeaderType]
  /// center 标题居中
  /// spaceBetween 标题和关闭居于两侧
  /// 默认值SantoAppraiseHeaderType.spaceBetween
  final SantoAppraiseHeaderType headerType;

  /// 评分组件类型，取值[SantoAppraiseType]
  /// Emoji 表示使用表情包评价
  /// star 使用星星打分
  /// 默认值 SantoAppraiseType.Star
  final SantoAppraiseType type;

  /// 自定义文案
  /// 若评分组件为表情，则list长度为5，不足5个时请在对应位置补空字符串
  /// 若评分组件为星星，则list长度不能比count小
  final List<String>? iconDescriptions;

  /// 标签
  final List<String>? tags;

  ///输入框允许提示文案
  final String inputHintText;

  /// 提交按钮的点击回调
  final SantoAppraiseConfirmClick? onConfirm;

  /// 评价组件的配置项
  final SantoAppraiseConfig config;

  /// create SantoAppraise
  SantoAppraise(
      {Key? key,
      this.title = '',
      this.headerType = SantoAppraiseHeaderType.spaceBetween,
      this.type = SantoAppraiseType.star,
      this.iconDescriptions,
      this.tags,
      this.inputHintText = '',
      this.onConfirm,
      this.config = const SantoAppraiseConfig()})
      : super(key: key);

  @override
  _SantoAppraiseState createState() => _SantoAppraiseState();
}

class _SantoAppraiseState extends State<SantoAppraise> {
  int _appraiseIndex = -1;
  bool? _enable;
  String? _inputText;
  List<String> _selectedTag = [];

  @override
  void initState() {
    _enable = widget.config.isConfirmButtonEnabled;
    super.initState();
  }

  @override
  void didUpdateWidget(SantoAppraise oldWidget) {
    _enable = widget.config.isConfirmButtonEnabled;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(commonConfig.radiusXs),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _headerArea(context),
          Padding(
            padding: EdgeInsets.fromLTRB(commonConfig.hSpacingLg, 0,
                commonConfig.hSpacingLg, 0),
            child: _getIconWidget(),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(commonConfig.hSpacingLg, 0,
                commonConfig.hSpacingLg, 0),
            child: _getTags(),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(commonConfig.hSpacingLg, 0,
                commonConfig.hSpacingLg, 0),
            child: _inputArea(),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(commonConfig.hSpacingLg, 0,
                commonConfig.hSpacingLg, 0),
            child: _confirmButton(),
          ),
        ],
      ),
    );
  }

  /// header
  Widget _headerArea(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    EdgeInsets defaultPadding =
        (widget.headerType == SantoAppraiseHeaderType.center)
            ? EdgeInsets.only(
                top: commonConfig.vSpacingLg,
                bottom: commonConfig.vSpacingLg)
            : EdgeInsets.only(
                left: commonConfig.hSpacingLg,
                top: commonConfig.vSpacingMd,
                right: commonConfig.hSpacingMd,
                bottom: commonConfig.vSpacingLg);
    return SantoAppraiseHeader(
      showHeader: widget.config.showHeader,
      headerType: widget.headerType,
      title: widget.title,
      maxLines: widget.config.titleMaxLines,
      headPadding: widget.config.headerPadding ?? defaultPadding,
      cancelCallBack: widget.config.onCancel,
    );
  }

  /// 获取评分组件
  Widget _getIconWidget() {
    if (widget.type == SantoAppraiseType.emoji) {
      return SantoAppraiseEmojiListView(
        indexes: widget.config.indexes,
        titles: widget.iconDescriptions ?? SantoIntl.of(context).localizedResource.appriseLevel,
        onTap: (index) {
          setState(() {
            _appraiseIndex = index;
          });
          if (widget.config.iconClickCallback != null) {
            widget.config.iconClickCallback!(index);
          }
        },
      );
    } else {
      return SantoAppraiseStarListView(
        count: widget.config.count,
        titles: widget.iconDescriptions ?? SantoIntl.of(context).localizedResource.appriseLevel,
        hint: widget.config.starAppraiseHint,
        onTap: (index) {
          setState(() {
            _appraiseIndex = index;
          });
          if (widget.config.iconClickCallback != null) {
            widget.config.iconClickCallback!(index);
          }
        },
      );
    }
  }

  /// 标签
  Widget _getTags() {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    if (widget.tags?.isEmpty ?? true) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.only(top: commonConfig.vSpacingLg),
      child: _AppraiseTagSelector(
        tags: widget.tags!,
        multiSelect: widget.config.multiSelect,
        tagCountEachRow: widget.config.tagCountEachRow,
        onSelected: (selected) {
          _selectedTag = selected;
          if (widget.config.tagSelectCallback != null) {
            widget.config.tagSelectCallback!(_selectedTag);
          }
        },
      ),
    );
  }

  /// 输入框
  Widget _inputArea() {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    if (widget.config.showTextInput) {
      return Padding(
        padding: EdgeInsets.only(top: commonConfig.vSpacingLg),
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: widget.config.inputMaxHeight, minHeight: 40),
          child: SantoInputText(
            maxLines: null,
            minLines: 3,
            maxLength: widget.config.maxLength,
            indicator: true,
            hintText: widget.inputHintText,
            initialValue: (_inputText ?? widget.config.inputDefaultText) ?? '',
            onChanged: (input) {
              _inputText = input;
              if (widget.config.inputTextChangeCallback != null) {
                widget.config.inputTextChangeCallback!(input);
              }
            },
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  /// 提交按钮
  Widget _confirmButton() {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    if (widget.config.showConfirmButton) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: commonConfig.vSpacingMd),
        child: SantoBigMainButton(
          title: widget.config.confirmButtonText ?? SantoIntl.of(context).localizedResource.submit,
          isEnable: _enable ?? _appraiseIndex != -1,
          onTap: () {
            if (_enable ?? _appraiseIndex != -1) {
              if (widget.onConfirm != null) {
                widget.onConfirm!(
                    _appraiseIndex, _selectedTag, _inputText ?? '');
              }
            }
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

/// 评价组件内部的标签选择器
class _AppraiseTagSelector extends StatefulWidget {
  final List<String> tags;
  final bool multiSelect;
  final int tagCountEachRow;
  final ValueChanged<List<String>> onSelected;

  const _AppraiseTagSelector({
    Key? key,
    required this.tags,
    required this.multiSelect,
    required this.tagCountEachRow,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<_AppraiseTagSelector> createState() => _AppraiseTagSelectorState();
}

class _AppraiseTagSelectorState extends State<_AppraiseTagSelector> {
  final Set<int> _selectedIndexes = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final int count = widget.tagCountEachRow > 0 ? widget.tagCountEachRow : 2;
    final double spacing = commonConfig.hSpacingMd;

    return Wrap(
      spacing: spacing,
      runSpacing: commonConfig.vSpacingMd,
      children: widget.tags.asMap().entries.map((entry) {
        final index = entry.key;
        final tag = entry.value;
        final isSelected = _selectedIndexes.contains(index);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (!widget.multiSelect) {
                _selectedIndexes.clear();
                _selectedIndexes.add(index);
              } else {
                if (isSelected) {
                  _selectedIndexes.remove(index);
                } else {
                  _selectedIndexes.add(index);
                }
              }
              widget.onSelected(_selectedIndexes
                  .map((i) => widget.tags[i])
                  .toList());
            });
          },
          child: Container(
            constraints: BoxConstraints(minWidth: 75),
            decoration: BoxDecoration(
              color: isSelected
                  ? SantoThemeConfigurator.instance
                      .getConfig()
                      .commonConfig
                      .brandPrimary
                      .withAlpha(0x14)
                  : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(commonConfig.radiusXs),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: commonConfig.hSpacingSm,
              vertical: commonConfig.vSpacingSm,
            ),
            alignment: Alignment.center,
            child: Text(
              tag,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                fontSize: commonConfig.fontSizeCaption,
                color: isSelected
                    ? SantoThemeConfigurator.instance
                        .getConfig()
                        .commonConfig
                        .brandPrimary
                    : SantoThemeConfigurator.instance
                        .getConfig()
                        .commonConfig
                        .colorTextBase,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
