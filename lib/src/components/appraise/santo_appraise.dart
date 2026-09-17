import 'package:santo_ui/src/components/appraise/santo_appraise_emoji_list_view.dart';
import 'package:santo_ui/src/components/appraise/santo_appraise_header.dart';
import 'package:santo_ui/src/components/appraise/santo_appraise_star_list_view.dart';
import 'package:santo_ui/src/components/appraise/santo_mulit_select_tags.dart';
import 'package:santo_ui/src/components/button/santo_big_main_button.dart';
import 'package:santo_ui/src/components/input/santo_input_text.dart';
import 'package:santo_ui/src/components/picker/santo_tags_picker_config.dart';
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
                top: 16,
                right: 16,
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
    if (widget.tags?.isEmpty ?? true) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.only(top: 24),
      child: SantoMultiSelectTags(
        padding: EdgeInsets.all(0),
        physics: NeverScrollableScrollPhysics(),
        tagPickerBean: SantoTagsPickerConfig(
          tagItemSource: _string2Tag(widget.tags),
        ),
        tagText: (choice) {
          return choice.name;
        },
        // tagStyle: SantoMultiSelectStyle.auto,
        multiSelect: widget.config.multiSelect,
        santoCrossAxisCount: widget.config.tagCountEachRow,
        selectedTagsCallback: (list) {
          _selectedTag = _tag2String(list);
          if (widget.config.tagSelectCallback != null) {
            widget.config.tagSelectCallback!(_selectedTag);
          }
        },
      ),
    );
  }

  /// 输入框
  Widget _inputArea() {
    if (widget.config.showTextInput) {
      return Padding(
        padding: EdgeInsets.only(top: 24),
        child: Container(
          constraints: BoxConstraints(
              maxHeight: widget.config.inputMaxHeight, minHeight: 40),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xfff8f8f8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SantoInputText(
            borderless: true,
            maxLines: null,
            minLines: 1,
            maxLength: widget.config.maxLength,
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
    if (widget.config.showConfirmButton) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
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

  List<SantoTagItemBean> _string2Tag(List<String>? tags) {
    List<SantoTagItemBean> items = [];
    if (tags?.isNotEmpty ?? false) {
      for (int i = 0; i < tags!.length; i++) {
        items.add(SantoTagItemBean(name: tags[i], code: tags[i], index: i));
      }
    }
    return items;
  }

  List<String> _tag2String(List<SantoTagItemBean> tags) {
    List<String> result = [];
    tags.forEach((item) {
      result.add(item.name);
    });
    return result;
  }
}
