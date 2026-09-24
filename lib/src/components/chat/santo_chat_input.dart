import 'package:santo_ui/src/components/chat/model/santo_chat_emoji_item.dart';
import 'package:santo_ui/src/components/chat/model/santo_chat_extension.dart';
import 'package:santo_ui/src/components/chat/model/santo_chat_message.dart';
import 'package:santo_ui/src/components/chat/santo_chat_message_menu.dart'
    show kSantoChatMenuItemColumns;
import 'package:santo_ui/src/components/chat/santo_chat_quote_view.dart';
import 'package:santo_ui/src/components/icon/santo_icon.dart';
import 'package:santo_ui/src/components/icon/santo_icons.dart';
import 'package:santo_ui/src/components/icon/santo_solid_icons.dart';
import 'package:santo_ui/src/theme/configs/santo_chat_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 扩展面板入口的边长
const double kSantoChatExtensionItemSize = 56;

/// 扩展面板入口的图标边长
const double kSantoChatExtensionIconSize = 26;

/// 输入区面板(表情面板与扩展菜单)的固定高度
///
/// 两个面板共用同一高度,互相切换、以及与输入法切换时输入区高度都不会跳动。
const double kSantoChatPanelHeight = 230;

/// 扩展菜单面板每页展示的排数,一页放不下的左右滑动查看
const int kSantoChatMenuItemRows = 2;

/// 面板分页指示点的直径
const double kSantoChatPanelIndicatorSize = 6;

/// 面板分页指示点的间距
const double kSantoChatPanelIndicatorGap = 3;

/// 表情面板每行几个
const int kSantoChatEmojiColumns = 8;

/// 表情面板每页展示的排数
const int kSantoChatEmojiRows = 4;

/// 表情面板里表情的展示字号
const double kSantoChatEmojiFontSize = 24;

/// 引用/编辑条右侧关闭按钮的图标边长,比 iconSizeMd(16) 大一档
const double kSantoChatBannerCloseSize = 20;

/// 按「每页 [rows] 排 × 每排 [columns] 个」把条目切页
List<List<T>> _paginate<T>(List<T> items, int columns, int rows) {
  final int perPage = columns * rows;
  return <List<T>>[
    for (int i = 0; i < items.length; i += perPage)
      items.sublist(
        i,
        i + perPage < items.length ? i + perPage : items.length,
      ),
  ];
}

/// 输入区展开的面板
enum _SantoChatInputPanel {
  /// 没有面板(输入法或普通状态)
  none,

  /// 表情面板
  emoji,

  /// 扩展菜单面板
  extension,
}

/// 会话底部输入区
///
/// 白底铺满整个底部安全区域,内容在安全区之上避让,安全区固定预留、不提供开关。
///
/// - **不带发送按钮**:发送走输入法的发送键(回车),输入为空时不触发回调
/// - **扩展菜单**:点 `+` 收起输入法并在输入框下方展开面板(与输入法换位),
///   再点收起;点输入框会收起面板并唤起输入法
/// - **[leading]/[trailing]** 是留给业务方的插槽(语音、表情),组件不内置面板
/// - **回复态与编辑态**:[replyTo] 展示引用条,[editingText] 展示编辑条并预填内容,
///   两种状态下的提交都走 [onSend],调用方按自己的状态判断是发新消息还是提交编辑
///
/// @since v1.5.0
class SantoChatInput extends StatefulWidget {
  /// 文本控制器,不传时组件内部创建
  final TextEditingController? controller;

  /// 焦点控制器
  final FocusNode? focusNode;

  /// 点击发送回调,回调后组件会清空输入框
  final ValueChanged<String>? onSend;

  /// 输入框提示文案
  final String hintText;

  /// 是否可输入
  final bool enabled;

  /// 输入框最多行数,超过后内部滚动
  final int maxLines;

  /// 输入框左侧插槽,如语音按钮
  final Widget? leading;

  /// 输入框右侧插槽,如表情按钮
  final Widget? trailing;

  /// 输入内容变化回调
  final ValueChanged<String>? onChanged;

  /// 当前回复的消息,不为空时在输入框上方展示引用条
  final SantoChatQuote? replyTo;

  /// 取消回复回调
  final VoidCallback? onCancelReply;

  /// 扩展菜单项,默认照片、拍摄、文件;传空数组则不展示 `+` 入口
  final List<SantoChatExtension> extensions;

  /// 点选扩展菜单项回调,由业务方拉起相册、相机或文件选择器
  final ValueChanged<SantoChatExtension>? onExtensionTap;

  /// 表情面板里的表情,默认内置 32 个;传空数组则不展示表情入口
  final List<SantoChatEmoji> emojis;

  /// 正在编辑的消息内容,不为空时进入编辑态:输入框预填该内容并展示编辑条
  final String? editingText;

  /// 取消编辑回调
  final VoidCallback? onCancelEdit;

  const SantoChatInput({
    Key? key,
    this.controller,
    this.focusNode,
    this.onSend,
    this.hintText = '请输入内容',
    this.enabled = true,
    this.maxLines = 4,
    this.leading,
    this.trailing,
    this.onChanged,
    this.replyTo,
    this.onCancelReply,
    this.extensions = SantoChatExtension.defaults,
    this.onExtensionTap,
    this.emojis = kSantoChatDefaultEmojis,
    this.editingText,
    this.onCancelEdit,
  }) : super(key: key);

  @override
  State<SantoChatInput> createState() => _SantoChatInputState();
}

class _SantoChatInputState extends State<SantoChatInput> {
  TextEditingController? _internalController;
  FocusNode? _internalFocusNode;

  /// 当前展开的面板
  _SantoChatInputPanel _panel = _SantoChatInputPanel.none;

  TextEditingController get _controller =>
      widget.controller ?? (_internalController ??= TextEditingController());

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  bool get _showExtensions =>
      widget.extensions.isNotEmpty && widget.enabled;

  bool get _showEmojis => widget.emojis.isNotEmpty && widget.enabled;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
    // 挂载时就已经处于编辑态:预填内容,但不抢焦点
    final String? editingText = widget.editingText;
    if (editingText != null) {
      _controller
        ..text = editingText
        ..selection = TextSelection.collapsed(offset: editingText.length);
    }
  }

  @override
  void didUpdateWidget(covariant SantoChatInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _internalFocusNode)
          ?.removeListener(_handleFocusChange);
      _focusNode.addListener(_handleFocusChange);
    }
    if (widget.editingText != null &&
        widget.editingText != oldWidget.editingText) {
      _fillEditingText(widget.editingText!);
    }
  }

  @override
  void dispose() {
    (widget.focusNode ?? _internalFocusNode)?.removeListener(_handleFocusChange);
    _internalFocusNode?.dispose();
    _internalController?.dispose();
    super.dispose();
  }

  /// 编辑态:把待编辑内容填进输入框并聚焦,同时收起面板
  void _fillEditingText(String text) {
    _controller
      ..text = text
      ..selection = TextSelection.collapsed(offset: text.length);
    setState(() => _panel = _SantoChatInputPanel.none);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  /// 唤起输入法时收起面板,保证面板与输入法不会同时出现
  void _handleFocusChange() {
    if (_focusNode.hasFocus && _panel != _SantoChatInputPanel.none) {
      setState(() => _panel = _SantoChatInputPanel.none);
    }
  }

  /// 点工具栏按钮:同一按钮再点收起,点另一个按钮直接换面板
  void _togglePanel(_SantoChatInputPanel panel) {
    if (_panel == panel) {
      setState(() => _panel = _SantoChatInputPanel.none);
      return;
    }
    // 先收起输入法,再在输入框下方展开面板,两者在同一位置换位
    _focusNode.unfocus();
    setState(() => _panel = panel);
  }

  void _closePanel() {
    if (_panel != _SantoChatInputPanel.none) {
      setState(() => _panel = _SantoChatInputPanel.none);
    }
  }

  /// 把表情 token 插到光标处,插完保持面板展开继续选
  void _insertEmoji(SantoChatEmoji emoji) {
    final TextEditingValue value = _controller.value;
    final TextSelection selection = value.selection;
    final bool valid = selection.isValid;
    final int start = valid ? selection.start : value.text.length;
    final int end = valid ? selection.end : value.text.length;
    final String text = value.text.replaceRange(start, end, emoji.token);
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: start + emoji.token.length),
    );
    widget.onChanged?.call(text);
  }

  void _handleSend() {
    if (!widget.enabled) return;
    final String text = _controller.text.trim();
    // 输入法的发送键可能连按,空内容直接忽略即可
    if (text.isEmpty) return;
    widget.onSend?.call(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final SantoChatConfig config =
        SantoThemeConfigurator.instance.getConfig().chatConfig;
    final bool editing = widget.editingText != null;
    final SantoChatQuote? banner = editing
        ? SantoChatQuote(title: '编辑消息', preview: widget.editingText!)
        : widget.replyTo;

    return Container(
      color: config.inputBackgroundColor,
      child: Column(
        // 撑满宽度:分割线、面板都要占满整行,否则会被居中或缩成 0 宽
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: config.commonConfig.borderWidthSm,
            color: config.commonConfig.dividerColorBase,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: config.commonConfig.hSpacingMd,
              vertical: config.commonConfig.vSpacingSm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (banner != null)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: config.commonConfig.vSpacingSm,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: SantoChatQuoteView(quote: banner)),
                        SizedBox(width: config.commonConfig.hSpacingSm),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: editing
                              ? widget.onCancelEdit
                              : widget.onCancelReply,
                          child: SantoIcon(
                            SantoSolidIcons.xmarkCircle,
                            solid: true,
                            size: kSantoChatBannerCloseSize,
                            color: config.commonConfig.brandError,
                          ),
                        ),
                      ],
                    ),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    if (widget.leading != null) ...<Widget>[
                      widget.leading!,
                      SizedBox(width: config.commonConfig.hSpacingSm),
                    ],
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: config.commonConfig.hSpacingSm,
                          vertical: config.commonConfig.vSpacingXs,
                        ),
                        decoration: BoxDecoration(
                          color: config.backgroundColor,
                          borderRadius: BorderRadius.circular(
                            config.commonConfig.radiusMd,
                          ),
                        ),
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          enabled: widget.enabled,
                          minLines: 1,
                          maxLines: widget.maxLines,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _handleSend(),
                          // 发送后不收起键盘,连续发送时键盘不闪
                          onEditingComplete: () {},
                          onTap: _closePanel,
                          onChanged: widget.onChanged,
                          cursorColor: config.myBubbleColor,
                          style: config.inputTextStyle.generateTextStyle(),
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            // 提示文案不换行,超出直接省略
                            hint: Text(
                              widget.hintText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: config.inputHintTextStyle
                                  .generateTextStyle(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (widget.trailing != null) ...<Widget>[
                      SizedBox(width: config.commonConfig.hSpacingSm),
                      widget.trailing!,
                    ],
                    if (_showEmojis) ...<Widget>[
                      SizedBox(width: config.commonConfig.hSpacingSm),
                      _InputToolButton(
                        icon: SantoIcons.emoji,
                        highlight: _panel == _SantoChatInputPanel.emoji,
                        onTap: () =>
                            _togglePanel(_SantoChatInputPanel.emoji),
                      ),
                    ],
                    if (_showExtensions) ...<Widget>[
                      SizedBox(width: config.commonConfig.hSpacingSm),
                      _InputToolButton(
                        icon: SantoIcons.plus,
                        highlight: _panel == _SantoChatInputPanel.extension,
                        onTap: () =>
                            _togglePanel(_SantoChatInputPanel.extension),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (_panel == _SantoChatInputPanel.emoji)
            _EmojiPanel(emojis: widget.emojis, onTap: _insertEmoji),
          if (_panel == _SantoChatInputPanel.extension)
            _ExtensionPanel(
              extensions: widget.extensions,
              onTap: widget.onExtensionTap,
            ),
          // 底部安全区固定预留,不可配置
          SizedBox(height: MediaQuery.paddingOf(context).bottom),
        ],
      ),
    );
  }
}

/// 输入区工具栏按钮:32×32 点击区 + 22 图标,展开对应面板时取主题色
class _InputToolButton extends StatelessWidget {
  final String icon;
  final bool highlight;
  final VoidCallback? onTap;

  const _InputToolButton({
    required this.icon,
    this.highlight = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final SantoChatConfig config =
        SantoThemeConfigurator.instance.getConfig().chatConfig;
    final double size = config.commonConfig.iconSizeLg;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox.square(
        dimension: size,
        child: Center(
          child: SantoIcon(
            icon,
            size: kSantoChatExtensionIconSize,
            color: highlight
                ? config.myBubbleColor
                : config.commonConfig.colorTextSecondary,
          ),
        ),
      ),
    );
  }
}

/// 面板外壳:固定高度 + 上下留白,内容按页左右滑动,多于一页时底部显示指示点
class _PanelFrame extends StatelessWidget {
  final List<Widget> pages;
  final int page;
  final ValueChanged<int> onPageChanged;

  const _PanelFrame({
    required this.pages,
    required this.page,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final SantoChatConfig config =
        SantoThemeConfigurator.instance.getConfig().chatConfig;

    return SizedBox(
      height: kSantoChatPanelHeight,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: config.commonConfig.hSpacingMd,
          vertical: config.commonConfig.vSpacingMd,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView(
                onPageChanged: onPageChanged,
                children: pages,
              ),
            ),
            if (pages.length > 1)
              Padding(
                padding: EdgeInsets.only(top: config.commonConfig.vSpacingXs),
                child: Row(
                  key: const ValueKey<String>('santoChatPanelIndicator'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (int i = 0; i < pages.length; i++)
                      Container(
                        width: kSantoChatPanelIndicatorSize,
                        height: kSantoChatPanelIndicatorSize,
                        margin: EdgeInsets.symmetric(
                          horizontal: kSantoChatPanelIndicatorGap,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == page
                              ? config.commonConfig.brandPrimary
                              : config.commonConfig.borderColorBase,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 表情面板:高度与扩展菜单一致,一排 8 个、只展示两排,超出的左右滑动翻页
class _EmojiPanel extends StatefulWidget {
  final List<SantoChatEmoji> emojis;
  final ValueChanged<SantoChatEmoji>? onTap;

  const _EmojiPanel({required this.emojis, this.onTap});

  @override
  State<_EmojiPanel> createState() => _EmojiPanelState();
}

class _EmojiPanelState extends State<_EmojiPanel> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final SantoChatConfig config =
        SantoThemeConfigurator.instance.getConfig().chatConfig;

    return _PanelFrame(
      page: _page,
      onPageChanged: (int index) => setState(() => _page = index),
      pages: <Widget>[
        for (final List<SantoChatEmoji> page in _paginate(
          widget.emojis,
          kSantoChatEmojiColumns,
          kSantoChatEmojiRows,
        ))
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              // 与扩展菜单同一套网格:排满可用高度、左上角起排、空位保留
              final double rowHeight = (constraints.maxHeight -
                      config.commonConfig.vSpacingMd *
                          (kSantoChatEmojiRows - 1)) /
                  kSantoChatEmojiRows;
              return GridView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: kSantoChatEmojiColumns,
                  mainAxisSpacing: config.commonConfig.vSpacingMd,
                  mainAxisExtent: rowHeight,
                ),
                itemCount: page.length,
                itemBuilder: (BuildContext context, int index) {
                  final SantoChatEmoji emoji = page[index];
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap:
                        widget.onTap == null ? null : () => widget.onTap!(emoji),
                    child: Center(
                      child: Text(
                        emoji.symbol,
                        style: const TextStyle(
                          fontSize: kSantoChatEmojiFontSize,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
      ],
    );
  }
}

/// 扩展菜单面板:网格布局,一排 5 个、只展示两排、左上角起排,超出的左右滑动翻页
class _ExtensionPanel extends StatefulWidget {
  final List<SantoChatExtension> extensions;
  final ValueChanged<SantoChatExtension>? onTap;

  const _ExtensionPanel({required this.extensions, this.onTap});

  @override
  State<_ExtensionPanel> createState() => _ExtensionPanelState();
}

class _ExtensionPanelState extends State<_ExtensionPanel> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final SantoChatConfig config =
        SantoThemeConfigurator.instance.getConfig().chatConfig;

    return _PanelFrame(
      page: _page,
      onPageChanged: (int index) => setState(() => _page = index),
      pages: <Widget>[
        for (final List<SantoChatExtension> page in _paginate(
          widget.extensions,
          kSantoChatMenuItemColumns,
          kSantoChatMenuItemRows,
        ))
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              // 铺满可用高度,单元格固定;不足一页的空位保留、不回流
              final double rowHeight = (constraints.maxHeight -
                      config.commonConfig.vSpacingMd *
                          (kSantoChatMenuItemRows - 1)) /
                  kSantoChatMenuItemRows;
              return GridView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: kSantoChatMenuItemColumns,
                  mainAxisSpacing: config.commonConfig.vSpacingMd,
                  mainAxisExtent: rowHeight,
                ),
                itemCount: page.length,
                itemBuilder: (BuildContext context, int index) =>
                    _buildItem(config, page[index]),
              );
            },
          ),
      ],
    );
  }

  Widget _buildItem(SantoChatConfig config, SantoChatExtension extension) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap == null ? null : () => widget.onTap!(extension),
      child: Column(
        // 图标贴各自格子的左侧,整体左对齐;文案在图标宽度内居中
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: kSantoChatExtensionItemSize,
            height: kSantoChatExtensionItemSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: config.backgroundColor,
              borderRadius: BorderRadius.circular(
                config.commonConfig.radiusMd,
              ),
            ),
            child: SantoIcon(
              extension.icon,
              size: kSantoChatExtensionIconSize,
              color: config.commonConfig.colorTextBase,
            ),
          ),
          SizedBox(height: config.commonConfig.vSpacingXs),
          SizedBox(
            width: kSantoChatExtensionItemSize,
            child: Text(
              extension.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: config.systemTextStyle.generateTextStyle(),
            ),
          ),
        ],
      ),
    );
  }
}
