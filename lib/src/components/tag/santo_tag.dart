import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:santo_ui/src/components/icon/santo_icon.dart';
import 'package:santo_ui/src/components/icon/santo_icons.dart';
import 'package:santo_ui/src/theme/base/santo_text_style.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:santo_ui/src/theme/configs/santo_tag_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 标签状态,决定预设配色:底色为状态色 10% 透明度,文字为状态色
///
/// @since v1.1.0 由 TagState 更名而来
enum SantoTagState {
  /// 等待,黄色
  waiting,

  /// 失效,灰色
  invalidate,

  /// 运行,蓝色
  running,

  /// 失败,红色
  failed,

  /// 成功,绿色
  succeed,
}

/// 默认纵向内边距,横向取主题 hSpacingSm
const double _kDefaultPaddingVertical = 2;

/// 选中态底色透明度
const double _kSelectedBackgroundOpacity = 0.12;

/// 删除图标与文字的间距
const double _kDeleteIconGap = 4;

/// 标签控制器,用于在外部主动增删标签组里的标签
///
/// 只在标签组([SantoTag.tags] 非空)且可删除([SantoTag.deletable])时生效;
/// 选中状态由 [SantoTag] 内部掌管,通过 [SantoTag.initTagState] 指定初始选中、
/// [SantoTag.onChanged] 接收下标回调。
///
/// @since v1.5.0 由 SantoDeleteTagController 更名而来
class SantoTagController {
  /// 标签数据监听,标签变化后 [SantoTag] 会自动重建
  late ValueNotifier<List<String>> notifier;

  List<String> _tags = <String>[];

  /// 当前标签集合
  List<String> get tags => notifier.value;

  SantoTagController({List<String>? initTags}) {
    _tags = initTags ?? <String>[];
    notifier = ValueNotifier<List<String>>(_tags);
  }

  /// 初始时设置全量的标签
  void setTags(List<String> tags) {
    _tags = tags;
    _asyncData();
  }

  /// 添加标签集合
  void addTags(List<String> tags) {
    _tags.addAll(tags);
    _asyncData();
  }

  /// 添加单个标签到集合末尾
  void addTag(String tag) {
    _tags.add(tag);
    _asyncData();
  }

  /// 清空所有标签
  void clear() {
    _tags.clear();
    _asyncData();
  }

  /// 删除指定 index 的标签,并返回其内容
  String? deleteForIndex(int index) {
    if (index < _tags.length) {
      final String result = _tags.removeAt(index);
      _asyncData();
      return result;
    }
    return null;
  }

  /// 删除某个具体内容的标签,成功返回 true,失败返回 false
  bool deleteForTag(String tag) {
    final bool result = _tags.remove(tag);
    _asyncData();
    return result;
  }

  /// 通知监听者标签已变化
  void _asyncData() {
    // notifier 里的引用就是 _tags,直接改 _tags 不会触发回调,这里重新赋值
    final List<String> values = <String>[];
    _tags.forEach(values.add);
    notifier.value = values;
  }
}

/// 标签组件,库内唯一的标签入口
///
/// 按数据形态分两种模式:
/// * 单标签:[text] 传一个文案,与 [bordered] / [state] / 自定义配色组合出
///   普通、描边、状态、多彩四种形态(参考 antd Tag)
/// * 标签组:[tags] 传文案列表(或传 [controller],以控制器里的标签为准),
///   按 [spacing] / [verticalSpacing] / [softWrap] / [fixWidthMode] /
///   [tagWidth] / [tagHeight] 排列成一组标签
///
/// 按交互能力分两个开关:
/// * [selectable]:可选择。单标签用 [initSelected] 定初始态、[onSelectedChange]
///   收回调;标签组用 [isSingleSelect] / [initTagState] / [onChanged] 掌管
/// * [deletable]:可删除。单标签用 [onDelete] 收回调;标签组配 [controller] 可在
///   外部增删,或用 [onTagDelete] 只收回调
///
/// 两个开关都不开时是纯展示标签。
///
/// 默认外观取主题 [SantoTagConfig]:高度 [height](tagHeight,32)、字号
/// [fontSize](tagTextStyle 字号,12)、圆角 tagRadius、组内间距与配色;
/// 单标签不开 [selectable] / [deletable] 时为主题色底反白文字的经典样式。
///
/// 标签自适应内容宽度(勿在外部包 alignment),[maxWidth] 限制最大宽度,
/// 超出省略;高度是下限,文字在高度内垂直居中。
///
/// @since v1.1.0 由 SantoTagCustom 与 SantoStateTag 收敛而来
/// @changed v1.5.0 新增 [height] 参数,字号默认值由 11 改为 12,
/// 左右内边距由 4 改为主题 hSpacingSm,[padding] 改为可空
/// @changed v1.5.0 收敛 SantoSelectTag 与 SantoDeleteTag:新增 [tags] 标签组、
/// [selectable] / [deletable] 开关与 [SantoTagController],[themeData] 可覆盖标签配置
///
/// 示例:
/// ```dart
/// // 单标签
/// SantoTag(text: '标签')
/// SantoTag(text: '已盘点', bordered: true)
/// SantoTag(text: '进行中', state: SantoTagState.running)
/// SantoTag(text: '红色标签', backgroundColor: Color(0xFFFF4D4F))
///
/// // 可选择
/// SantoTag(text: '可选中', selectable: true, onSelectedChange: (v) {})
/// SantoTag(tags: ['标签', '标签1'], selectable: true, onChanged: (i) {})
///
/// // 可删除
/// SantoTag(text: '可删除', deletable: true, onDelete: () {})
/// SantoTag(tags: ['标签', '标签1'], deletable: true, onTagDelete: (t, tag, i) {})
/// ```
class SantoTag extends StatefulWidget {
  /// 单标签文字,单标签模式必填(与 [tags] / [controller] 二选一)
  final String? text;

  /// 标签状态,非 null 时按状态取预设配色;
  /// 显式传入 [backgroundColor] / [textColor] 可覆盖预设配色
  final SantoTagState? state;

  /// 背景色,优先级高于状态预设配色与模式默认配色;
  /// 描边标签([bordered] 为 true)不传时为透明
  final Color? backgroundColor;

  /// 文字颜色,优先级高于状态预设配色与模式默认配色
  final Color? textColor;

  /// 是否为描边标签,描边标签透明底、文字与边框同色
  final bool bordered;

  /// 边框颜色,默认取状态色([state] 非 null)或主题品牌色
  final Color? borderColor;

  /// 边框宽度,不传时取主题 borderWidthMd
  final double? borderWidth;

  /// 标签圆角,不传时单标签取主题 tagRadius、标签组取主题 tagRadius 或 [shape]
  final BorderRadius? borderRadius;

  /// 内边距,单标签不传时横向取主题 hSpacingSm(默认 10)、纵向 2;
  /// 标签组固定横向取 hSpacingSm
  final EdgeInsetsGeometry? padding;

  /// 单标签高度,不传时取主题 tagHeight(默认 32)
  final double? height;

  /// 文字大小,不传时取主题 tagTextStyle 字号(默认 12)
  final double? fontSize;

  /// 文字粗细,默认正常;选中态不传时取主题 selectTagTextStyle 的粗细
  final FontWeight fontWeight;

  /// 最大宽度,超出省略
  final double? maxWidth;

  /// 是否可选择,默认 false;开启后点击可切换选中态
  final bool selectable;

  /// 单标签的初始选中态,默认 false
  final bool initSelected;

  /// 单标签选中态变化回调
  final ValueChanged<bool>? onSelectedChange;

  /// 标签组是否单选,默认 true;为 false 时多项可同时选中
  final bool isSingleSelect;

  /// 标签组的初始选中状态,与 [tags] 按下标对应
  final List<bool>? initTagState;

  /// 标签组选中变化回调,返回选中标签的下标集合
  final ValueChanged<List<int>>? onChanged;

  /// 是否可删除,默认 false;开启后标签右侧展示删除图标
  final bool deletable;

  /// 单标签删除回调
  final VoidCallback? onDelete;

  /// 标签组删除回调,参数依次为剩余标签集合、被删除的标签内容、被删除的下标
  final Function(List<String>, String?, int)? onTagDelete;

  /// 标签组控制器,用于在外部主动增删标签;传入时以控制器里的标签为准
  final SantoTagController? controller;

  /// 删除图标大小,不传时取主题 iconSizeMd(默认 16)
  final Size? deleteIconSize;

  /// 删除图标颜色,不传时取标签文字颜色
  final Color? deleteIconColor;

  /// 标签组标签的形状,默认圆角矩形;只认 [RoundedRectangleBorder] 的圆角
  final OutlinedBorder? shape;

  /// 标签组的标签文案列表,非空时按标签组渲染;与 [controller] 二选一即可
  final List<String>? tags;

  /// 标签组水平间距,默认 12
  final double spacing;

  /// 标签组纵向间距,默认 10
  final double? verticalSpacing;

  /// 标签组是否流式换行,默认 true;为 false 时横向滑动
  final bool softWrap;

  /// 标签组是否需要固定宽度,默认 true;为 false 时按内容自适应
  ///
  /// 可删除([deletable] 为 true)时固定宽度不生效——删除图标会挤掉文案,
  /// 此时按内容自适应;需要定宽请显式传 [tagWidth]
  final bool fixWidthMode;

  /// 标签组标签宽度,默认取主题 tagWidth(75),仅 [fixWidthMode] 为 true 时生效
  final double? tagWidth;

  /// 标签组标签高度,默认取主题 tagHeight(32)
  final double? tagHeight;

  /// 标签组标签的文字样式,默认取主题 tagTextStyle
  final TextStyle? tagTextStyle;

  /// 标签组选中标签的文字样式,默认取主题 selectTagTextStyle
  final TextStyle? selectedTagTextStyle;

  /// 标签组标签背景色,默认取主题 tagBackgroundColor
  final Color? tagBackgroundColor;

  /// 标签组选中标签背景色,默认取主题 selectedTagBackgroundColor
  final Color? selectedTagBackgroundColor;

  /// 标签组的对齐模式,默认 [Alignment.centerLeft]
  final Alignment alignment;

  /// 标签主题配置,覆盖主题里的 [SantoTagConfig]
  final SantoTagConfig? themeData;

  const SantoTag({
    Key? key,
    this.text,
    this.state,
    this.backgroundColor,
    this.textColor,
    this.bordered = false,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.height,
    this.fontSize,
    this.fontWeight = FontWeight.normal,
    this.maxWidth,
    this.selectable = false,
    this.initSelected = false,
    this.onSelectedChange,
    this.isSingleSelect = true,
    this.initTagState,
    this.onChanged,
    this.deletable = false,
    this.onDelete,
    this.onTagDelete,
    this.controller,
    this.deleteIconSize,
    this.deleteIconColor,
    this.shape,
    this.tags,
    this.spacing = 12,
    this.verticalSpacing,
    this.softWrap = true,
    this.fixWidthMode = true,
    this.tagWidth,
    this.tagHeight,
    this.tagTextStyle,
    this.selectedTagTextStyle,
    this.tagBackgroundColor,
    this.selectedTagBackgroundColor,
    this.alignment = Alignment.centerLeft,
    this.themeData,
  })  : assert(
            text != null || tags != null || controller != null,
            'SantoTag 需要 text(单标签)、tags 或 controller(标签组)至少一个'),
        assert(!isSingleSelect || initTagState == null || initTagState.length <= 1,
            '单选时 initTagState 最多只能有一项'),
        super(key: key);

  @override
  State<SantoTag> createState() => _SantoTagState();
}

class _SantoTagState extends State<SantoTag> {
  /// 标签组每个标签的选中态
  List<bool> _tagSelected = <bool>[];

  /// 未传 controller 且可删除时,内部自建一个,保证删除能生效
  SantoTagController? _internalController;

  /// 单标签的选中态
  bool _selected = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.initSelected;
    _resetTagSelection();
    _ensureInternalController();
  }

  @override
  void didUpdateWidget(covariant SantoTag oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.tags, widget.tags)) {
      _resetTagSelection();
      // 内部控制器自己拿着标签列表,外部换了 tags 要同步过去
      final List<String>? tags = widget.tags;
      if (_internalController != null && tags != null) {
        _internalController!.setTags(List<String>.of(tags));
      }
    }
    _ensureInternalController();
  }

  /// 需要删除能力但没传 controller 时,内部自建一个,保证点击删除图标能生效
  void _ensureInternalController() {
    final List<String>? tags = widget.tags;
    if (_internalController != null ||
        widget.controller != null ||
        !widget.deletable ||
        tags == null) {
      return;
    }
    // 复制一份,避免删除时改动调用方传进来的列表
    _internalController = SantoTagController(initTags: List<String>.of(tags));
  }

  /// 按 [SantoTag.initTagState] 重置标签组选中态
  void _resetTagSelection() {
    final List<String> tags = widget.tags ?? const <String>[];
    final List<bool> selection = List<bool>.filled(tags.length, false);
    final List<bool>? initTagState = widget.initTagState;
    if (initTagState != null) {
      final int count = initTagState.length < selection.length
          ? initTagState.length
          : selection.length;
      for (int i = 0; i < count; i++) {
        selection[i] = initTagState[i];
      }
    }
    _tagSelected = selection;
  }

  /// 合并主题配置、[SantoTag.themeData] 与组件级参数
  SantoTagConfig _resolveConfig() {
    final SantoTagConfig? themeData = widget.themeData;
    final SantoTagConfig base = SantoThemeConfigurator.instance
        .getConfig(configId: (themeData ?? SantoTagConfig()).configId)
        .tagConfig;
    return base.merge(themeData).merge(SantoTagConfig(
          tagWidth: widget.tagWidth,
          tagHeight: widget.tagHeight,
          tagBackgroundColor: widget.tagBackgroundColor,
          selectedTagBackgroundColor: widget.selectedTagBackgroundColor,
          tagTextStyle: SantoTextStyle.withStyle(widget.tagTextStyle),
          selectTagTextStyle:
              SantoTextStyle.withStyle(widget.selectedTagTextStyle),
        ));
  }

  bool _isTagSelected(int index) =>
      index < _tagSelected.length && _tagSelected[index];

  List<int> get _selectedIndexes => <int>[
        for (int i = 0; i < _tagSelected.length; i++)
          if (_tagSelected[i]) i,
      ];

  void _toggleSelected() {
    setState(() => _selected = !_selected);
    widget.onSelectedChange?.call(_selected);
  }

  void _toggleTag(int index) {
    if (index >= _tagSelected.length) return;
    if (widget.isSingleSelect) {
      if (_tagSelected[index]) return;
      setState(() {
        _tagSelected = List<bool>.filled(_tagSelected.length, false);
        _tagSelected[index] = true;
      });
    } else {
      setState(() => _tagSelected[index] = !_tagSelected[index]);
    }
    widget.onChanged?.call(_selectedIndexes);
  }

  void _deleteTag(int index) {
    final SantoTagController? controller =
        widget.controller ?? _internalController;
    final String? removed = controller?.deleteForIndex(index);
    widget.onTagDelete
        ?.call(controller?.tags ?? const <String>[], removed, index);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tags != null || widget.controller != null) {
      return _buildGroup(context);
    }
    return _buildSingle(context);
  }

  Widget _buildSingle(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final SantoTagConfig config = _resolveConfig();
    final Color? stateColor = _stateColor(commonConfig, widget.state);
    final bool selected = widget.selectable && _selected;
    final bool chipped = widget.selectable || widget.deletable;

    Color background;
    Color foreground;
    FontWeight fontWeight = widget.fontWeight;
    if (widget.bordered) {
      background = Colors.transparent;
      foreground = widget.textColor ??
          widget.borderColor ??
          stateColor ??
          commonConfig.brandPrimary;
    } else if (stateColor != null) {
      background = widget.backgroundColor ?? stateColor.withOpacity(0.1);
      foreground = widget.textColor ?? stateColor;
    } else if (widget.backgroundColor != null || widget.textColor != null) {
      background = widget.backgroundColor ?? commonConfig.brandPrimary;
      foreground = widget.textColor ?? commonConfig.colorTextBaseInverse;
    } else if (chipped && selected) {
      background = config.selectedTagBackgroundColor
          .withOpacity(_kSelectedBackgroundOpacity);
      foreground = config.selectTagTextStyle.color ?? commonConfig.brandPrimary;
      fontWeight = config.selectTagTextStyle.fontWeight ?? widget.fontWeight;
    } else if (chipped) {
      background = config.tagBackgroundColor;
      foreground = config.tagTextStyle.color ?? commonConfig.colorTextBase;
    } else {
      background = commonConfig.brandPrimary;
      foreground = commonConfig.colorTextBaseInverse;
    }

    final double fontSize = widget.fontSize ??
        config.tagTextStyle.fontSize ??
        commonConfig.fontSizeCaption;
    final double height = widget.height ?? config.tagHeight;
    final BorderRadius radius = widget.borderRadius ??
        BorderRadius.all(Radius.circular(config.tagRadius));

    Widget content = Text(
      widget.text ?? '',
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize,
        color: foreground,
        fontWeight: fontWeight,
      ),
    );
    if (widget.deletable) {
      content = _buildDeleteRow(
        content,
        onTap: widget.onDelete,
        fallbackColor: foreground,
      );
    }

    // 不设置 alignment:标签默认按内容自适应宽度;
    // 设置 alignment 会让 Container 在有界约束下撑满可用宽度。
    // 用 Center(widthFactor/heightFactor 为 1)既保持宽度贴合内容,又让文字在固定高度内垂直居中
    Widget result = Container(
      constraints: BoxConstraints(
        minHeight: height,
        maxWidth: widget.maxWidth ?? double.infinity,
      ),
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.rectangle,
        borderRadius: radius,
        border: widget.bordered
            ? Border.all(
                color: widget.borderColor ?? foreground,
                width: widget.borderWidth ?? commonConfig.borderWidthMd,
              )
            : null,
      ),
      padding: widget.padding ??
          EdgeInsets.symmetric(
            horizontal: commonConfig.hSpacingSm,
            vertical: _kDefaultPaddingVertical,
          ),
      child: Center(
        widthFactor: 1,
        heightFactor: 1,
        child: content,
      ),
    );

    if (widget.selectable) {
      result = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggleSelected,
        child: result,
      );
    }
    return result;
  }

  Widget _buildGroup(BuildContext context) {
    final SantoTagController? controller =
        widget.controller ?? _internalController;
    if (controller == null) {
      return _buildGroupContent(context, widget.tags ?? const <String>[]);
    }
    return ValueListenableBuilder<List<String>>(
      valueListenable: controller.notifier,
      builder: (BuildContext context, List<String> tags, Widget? child) =>
          _buildGroupContent(context, tags),
    );
  }

  Widget _buildGroupContent(BuildContext context, List<String> tags) {
    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final SantoTagConfig config = _resolveConfig();
    final List<Widget> items = <Widget>[
      for (int i = 0; i < tags.length; i++)
        _buildGroupItem(context, commonConfig, config, tags, i),
    ];

    Widget content;
    if (widget.softWrap) {
      content = Wrap(
        spacing: widget.spacing,
        runSpacing: widget.verticalSpacing ?? commonConfig.gapSm,
        children: items,
      );
    } else {
      content = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            for (int i = 0; i < items.length; i++)
              Padding(
                padding: EdgeInsets.only(
                  right: i == items.length - 1 ? 0 : widget.spacing,
                ),
                child: items[i],
              ),
          ],
        ),
      );
    }

    return Align(alignment: widget.alignment, child: content);
  }

  Widget _buildGroupItem(
    BuildContext context,
    SantoCommonConfig commonConfig,
    SantoTagConfig config,
    List<String> tags,
    int index,
  ) {
    final bool selected = widget.selectable && _isTagSelected(index);
    final TextStyle textStyle =
        (selected ? config.selectTagTextStyle : config.tagTextStyle)
            .generateTextStyle();

    Widget label = Text(
      tags[index],
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: textStyle,
    );
    if (widget.deletable) {
      label = _buildDeleteRow(
        label,
        onTap: () => _deleteTag(index),
        fallbackColor: textStyle.color,
      );
    }

    final Widget chip = Container(
      constraints: BoxConstraints(minWidth: config.tagMinWidth),
      width: _groupChipWidth(config),
      height: config.tagHeight,
      padding: EdgeInsets.symmetric(horizontal: commonConfig.hSpacingSm),
      decoration: BoxDecoration(
        color: selected
            ? config.selectedTagBackgroundColor
                .withOpacity(_kSelectedBackgroundOpacity)
            : config.tagBackgroundColor,
        borderRadius: _resolveGroupRadius(config),
      ),
      child: Center(
        widthFactor: 1,
        heightFactor: 1,
        child: label,
      ),
    );

    if (!widget.selectable && !widget.deletable) {
      return chip;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.selectable ? () => _toggleTag(index) : null,
      child: chip,
    );
  }

  /// 组内标签的宽度:定宽模式取 [SantoTag.tagWidth] 或主题 tagWidth,否则按内容自适应
  ///
  /// 可删除时只有显式传 [SantoTag.tagWidth] 才定宽——否则删除图标会把文案挤到
  /// 只剩省略号
  double? _groupChipWidth(SantoTagConfig config) {
    if (!widget.fixWidthMode) return null;
    if (widget.deletable) return widget.tagWidth;
    return widget.tagWidth ?? config.tagWidth;
  }

  /// 标签组的圆角:显式 [SantoTag.borderRadius] > [SantoTag.shape] > 主题 tagRadius
  BorderRadius _resolveGroupRadius(SantoTagConfig config) {
    final BorderRadius? borderRadius = widget.borderRadius;
    if (borderRadius != null) return borderRadius;
    final OutlinedBorder? shape = widget.shape;
    if (shape is RoundedRectangleBorder && shape.borderRadius is BorderRadius) {
      return shape.borderRadius as BorderRadius;
    }
    return BorderRadius.all(Radius.circular(config.tagRadius));
  }

  /// 文案 + 删除图标的横向排列,宽度有界时文字可压缩省略
  Widget _buildDeleteRow(
    Widget label, {
    required VoidCallback? onTap,
    required Color? fallbackColor,
  }) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (constraints.maxWidth.isFinite)
              Flexible(child: label)
            else
              label,
            const SizedBox(width: _kDeleteIconGap),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: SantoIcon(
                SantoIcons.xmark,
                size: widget.deleteIconSize?.width,
                color: widget.deleteIconColor ?? fallbackColor,
              ),
            ),
          ],
        );
      },
    );
  }

  static Color? _stateColor(SantoCommonConfig commonConfig, SantoTagState? state) {
    switch (state) {
      case SantoTagState.invalidate:
        return commonConfig.colorTextSecondary;
      case SantoTagState.running:
        return commonConfig.brandPrimary;
      case SantoTagState.failed:
        return commonConfig.brandError;
      case SantoTagState.succeed:
        return commonConfig.brandSuccess;
      case SantoTagState.waiting:
        return commonConfig.brandWarning;
      case null:
        return null;
    }
  }
}
