import 'package:santo_ui/src/components/chat/model/santo_chat_menu_item.dart';
import 'package:santo_ui/src/components/chat/santo_chat_text.dart';
import 'package:santo_ui/src/components/icon/santo_icon.dart';
import 'package:santo_ui/src/theme/configs/santo_chat_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 表情回应选项的边长
const double kSantoChatReactionItemSize = 40;

/// 操作项块的宽度
const double kSantoChatMenuItemWidth = 64;

/// 操作项块的高度
const double kSantoChatMenuItemHeight = 64;

/// 操作项块的图标边长
const double kSantoChatMenuItemIconSize = 20;

/// 表情回应与操作项每行最多几个
const int kSantoChatMenuItemColumns = 5;

/// 长按菜单:气泡旁浮层,顶部是表情回应,下面是操作列表
///
/// 由 [SantoChatMessageList] 在长按气泡时弹出,也可以自行调用 [show]。
/// 操作项按消息类型由调用方给出(见 [SantoChatMenuItem.defaults]),
/// 组件只负责展示与回调。
///
/// 同一时刻只会有一个菜单:重复调用 [show] 会先关掉上一个,换到新的消息上;
/// 需要主动关闭时调用 [dismiss]。
///
/// @since v1.5.0
class SantoChatMessageMenu {
  SantoChatMessageMenu._();

  /// 当前弹出的菜单
  static OverlayEntry? _current;

  /// 关闭当前菜单
  static void dismiss() {
    final OverlayEntry? entry = _current;
    _current = null;
    if (entry != null && entry.mounted) {
      entry.remove();
    }
  }

  static void _close(OverlayEntry entry) {
    if (identical(_current, entry)) {
      _current = null;
    }
    if (entry.mounted) {
      entry.remove();
    }
  }

  /// 在 [anchor](消息整行的全局矩形)的正上方弹出菜单
  ///
  /// 水平方向统一**屏幕居中**,不受长按落点影响;垂直方向贴在该行上方,
  /// 上方放不下时落到该行下方。返回 [OverlayEntry],调用方可手动 `remove()` 关闭。
  /// 菜单宽度会按表情行与操作项自适应。
  static OverlayEntry? show({
    required BuildContext context,
    required Rect anchor,
    List<String> reactions = const <String>[],
    ValueChanged<String>? onReaction,
    List<SantoChatMenuItem> items = const <SantoChatMenuItem>[],
    ValueChanged<SantoChatMenuItem>? onItemSelected,
    VoidCallback? onDismiss,
  }) {
    final bool showReactions = reactions.isNotEmpty && onReaction != null;
    final bool showItems = items.isNotEmpty && onItemSelected != null;
    final List<SantoChatMenuItem> menuItems =
        showItems ? items : const <SantoChatMenuItem>[];
    if (!showReactions && !showItems) return null;

    // 只保留一个:换到新的消息上时先关掉上一个
    dismiss();

    final OverlayState overlayState = Overlay.of(context);
    final SantoChatConfig config =
        SantoThemeConfigurator.instance.getConfig().chatConfig;
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final Size screen = mediaQuery.size;
    final double gap = config.commonConfig.gapSm;
    final double padding = config.commonConfig.hSpacingSm;

    // 表情回应与操作项都按块排列,一排最多 5 个,多出的换行
    final int reactionColumns = reactions.length < kSantoChatMenuItemColumns
        ? reactions.length
        : kSantoChatMenuItemColumns;
    final int reactionRows = reactionColumns == 0
        ? 0
        : (reactions.length + reactionColumns - 1) ~/ reactionColumns;
    final int itemColumns = menuItems.length < kSantoChatMenuItemColumns
        ? menuItems.length
        : kSantoChatMenuItemColumns;
    final int itemRows =
        itemColumns == 0 ? 0 : (menuItems.length + itemColumns - 1) ~/ itemColumns;

    final double reactionsWidth = showReactions
        ? reactionColumns * kSantoChatMenuItemWidth + padding * 2
        : 0;
    final double itemsWidth =
        itemColumns * kSantoChatMenuItemWidth + padding * 2;
    final double width = reactionsWidth > itemsWidth ? reactionsWidth : itemsWidth;
    final double height = padding * 2 +
        (showReactions ? reactionRows * kSantoChatReactionItemSize : 0) +
        (showReactions && menuItems.isNotEmpty
            ? config.commonConfig.borderWidthSm +
                config.commonConfig.vSpacingXs * 2
            : 0) +
        itemRows * kSantoChatMenuItemHeight;

    // 水平居中,垂直贴在消息整行上方;上方放不下就落到该行下方
    final double left =
        ((screen.width - width) / 2).clamp(gap, screen.width - width - gap).toDouble();
    double top = anchor.top - height - gap;
    if (top < mediaQuery.padding.top + gap) {
      top = anchor.bottom + gap;
    }

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _close(entry);
                  onDismiss?.call();
                },
              ),
            ),
            Positioned(
              left: left,
              top: top,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: width,
                  decoration: BoxDecoration(
                    color: config.otherBubbleColor,
                    borderRadius: BorderRadius.circular(config.bubbleRadius),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: config.commonConfig.gapSm,
                        offset: Offset(0, config.commonConfig.vSpacingXs / 2),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        if (showReactions)
                          Wrap(
                            children: <Widget>[
                              for (final String emoji in reactions)
                                _buildReaction(config, entry, emoji, onReaction),
                            ],
                          ),
                        if (showReactions && menuItems.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: config.commonConfig.vSpacingXs,
                            ),
                            child: Container(
                              height: config.commonConfig.borderWidthSm,
                              color: config.commonConfig.dividerColorBase,
                            ),
                          ),
                        if (showItems)
                          Wrap(
                            children: <Widget>[
                              for (final SantoChatMenuItem item in menuItems)
                                _buildItem(config, entry, item, onItemSelected),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    overlayState.insert(entry);
    _current = entry;
    return entry;
  }

  static Widget _buildReaction(
    SantoChatConfig config,
    OverlayEntry entry,
    String emoji,
    ValueChanged<String> onReaction,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _close(entry);
        onReaction(emoji);
      },
      child: SizedBox(
        width: kSantoChatMenuItemWidth,
        height: kSantoChatReactionItemSize,
        child: Center(
          child: SantoChatText(
            emoji,
            emojiSize: config.commonConfig.fontSizeHead,
            style: config.otherTextStyle
                .generateTextStyle()
                .copyWith(fontSize: config.commonConfig.fontSizeHead),
          ),
        ),
      ),
    );
  }

  /// 操作项:块级排列,图标在上、文案在下
  static Widget _buildItem(
    SantoChatConfig config,
    OverlayEntry entry,
    SantoChatMenuItem item,
    ValueChanged<SantoChatMenuItem> onItemSelected,
  ) {
    final Color color = item.danger
        ? config.commonConfig.brandError
        : config.commonConfig.colorTextBase;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _close(entry);
        onItemSelected(item);
      },
      child: SizedBox(
        width: kSantoChatMenuItemWidth,
        height: kSantoChatMenuItemHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (item.icon != null) ...<Widget>[
              SantoIcon(
                item.icon!,
                size: kSantoChatMenuItemIconSize,
                color: color,
              ),
              SizedBox(height: config.commonConfig.vSpacingXs),
            ],
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: config.timeTextStyle
                  .generateTextStyle()
                  .copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
