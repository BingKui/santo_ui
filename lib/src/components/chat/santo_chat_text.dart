import 'package:santo_ui/src/components/chat/model/santo_chat_emoji.dart';
import 'package:santo_ui/src/components/chat/model/santo_chat_emoji_item.dart';
import 'package:santo_ui/src/components/chat/model/santo_chat_message.dart';
import 'package:santo_ui/src/components/image/santo_image.dart';
import 'package:santo_ui/src/theme/configs/santo_chat_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// 会话文本:渲染 @提及、表情与链接
///
/// - `@展示名` 命中 [mentions] 时渲染成强调色并回调 [onMentionTap]
/// - `[表情名]` 命中 [SantoChatEmojiRegistry] 时渲染成表情图,未注册则保留原文
/// - `http(s)://` 链接渲染成强调色下划线并回调 [onLinkTap]
///
/// @since v1.5.0
class SantoChatText extends StatefulWidget {
  /// 文本内容
  final String text;

  /// 文本里被 @ 的成员
  final List<SantoChatMention> mentions;

  /// 文本样式,不传取主题聊天气泡的对侧文字样式
  final TextStyle? style;

  /// @ 与链接的强调色,不传取主题聊天气泡的对侧强调色
  final Color? accentColor;

  /// 表情图片边长,不传取主题 [SantoChatConfig.emojiSize]
  final double? emojiSize;

  /// 最多展示行数
  final int? maxLines;

  /// 超出 [maxLines] 时的省略方式
  final TextOverflow overflow;

  /// 点击 @提及 回调
  final ValueChanged<SantoChatMention>? onMentionTap;

  /// 点击链接回调
  final ValueChanged<String>? onLinkTap;

  const SantoChatText(
    this.text, {
    Key? key,
    this.mentions = const <SantoChatMention>[],
    this.style,
    this.accentColor,
    this.emojiSize,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.onMentionTap,
    this.onLinkTap,
  }) : super(key: key);

  @override
  State<SantoChatText> createState() => _SantoChatTextState();
}

/// 文本里的一段特殊内容
class _ChatTextToken {
  final int start;
  final int end;
  final int priority;
  final SantoChatMention? mention;
  final String? emojiUrl;
  final String? emojiSymbol;
  final String? link;

  const _ChatTextToken({
    required this.start,
    required this.end,
    required this.priority,
    this.mention,
    this.emojiUrl,
    this.emojiSymbol,
    this.link,
  });
}

class _SantoChatTextState extends State<SantoChatText> {
  static final RegExp _emojiRegExp = RegExp(r'\[([^\[\]]{1,16})\]');
  static final RegExp _linkRegExp = RegExp(r'https?://\S+');

  /// 当前 spans 用到的点击识别器,重建前统一释放
  final List<TapGestureRecognizer> _recognizers = <TapGestureRecognizer>[];

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  void _disposeRecognizers() {
    for (final TapGestureRecognizer recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();
  }

  /// 扫描出 @提及 / 表情 / 链接,按位置排序并去掉重叠
  List<_ChatTextToken> _scanTokens(String text) {
    final List<_ChatTextToken> tokens = <_ChatTextToken>[];

    for (final SantoChatMention mention in widget.mentions) {
      if (mention.display.isEmpty) continue;
      final RegExp regExp = RegExp('@${RegExp.escape(mention.display)}');
      for (final RegExpMatch match in regExp.allMatches(text)) {
        tokens.add(_ChatTextToken(
          start: match.start,
          end: match.end,
          priority: 0,
          mention: mention,
        ));
      }
    }

    for (final RegExpMatch match in _emojiRegExp.allMatches(text)) {
      final String name = match.group(1)!;
      // 业务注册过表情图就用图,否则回退到内置的 Unicode 表情
      final String? url = SantoChatEmojiRegistry.urlOf(name);
      final String? symbol =
          url == null ? SantoChatEmoji.byName(name)?.symbol : null;
      if (url == null && symbol == null) continue;
      tokens.add(_ChatTextToken(
        start: match.start,
        end: match.end,
        priority: 1,
        emojiUrl: url,
        emojiSymbol: symbol,
      ));
    }

    for (final RegExpMatch match in _linkRegExp.allMatches(text)) {
      tokens.add(_ChatTextToken(
        start: match.start,
        end: match.end,
        priority: 2,
        link: match.group(0),
      ));
    }

    tokens.sort((_ChatTextToken a, _ChatTextToken b) {
      if (a.start != b.start) return a.start.compareTo(b.start);
      if (a.priority != b.priority) return a.priority.compareTo(b.priority);
      return b.end.compareTo(a.end);
    });

    final List<_ChatTextToken> result = <_ChatTextToken>[];
    int cursor = 0;
    for (final _ChatTextToken token in tokens) {
      if (token.start < cursor) continue;
      result.add(token);
      cursor = token.end;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    _disposeRecognizers();

    final SantoChatConfig config = SantoThemeConfigurator.instance
        .getConfig()
        .chatConfig;
    final TextStyle textStyle =
        widget.style ?? config.otherTextStyle.generateTextStyle();
    final Color accentColor = widget.accentColor ?? config.otherAccentColor;
    final double emojiSize = widget.emojiSize ?? config.emojiSize;

    final List<InlineSpan> spans = <InlineSpan>[];
    int cursor = 0;
    for (final _ChatTextToken token in _scanTokens(widget.text)) {
      if (token.start > cursor) {
        spans.add(TextSpan(
          text: widget.text.substring(cursor, token.start),
          style: textStyle,
        ));
      }

      if (token.emojiUrl != null) {
        spans.add(WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: SantoImage(
            imageUrl: token.emojiUrl!,
            isNetwork: token.emojiUrl!.startsWith('http'),
            width: emojiSize,
            height: emojiSize,
          ),
        ));
      } else if (token.emojiSymbol != null) {
        // 内置表情:直接用 Unicode 字符,由系统字体渲染
        spans.add(TextSpan(text: token.emojiSymbol, style: textStyle));
      } else if (token.mention != null) {
        spans.add(TextSpan(
          text: widget.text.substring(token.start, token.end),
          style: textStyle.copyWith(
            color: accentColor,
            fontWeight: FontWeight.w600,
          ),
          recognizer: _buildRecognizer(
            onTap: () => widget.onMentionTap?.call(token.mention!),
          ),
        ));
      } else if (token.link != null) {
        spans.add(TextSpan(
          text: token.link,
          style: textStyle.copyWith(
            color: accentColor,
            decoration: TextDecoration.underline,
            decorationColor: accentColor,
          ),
          recognizer: _buildRecognizer(
            onTap: () => widget.onLinkTap?.call(token.link!),
          ),
        ));
      }

      cursor = token.end;
    }

    if (cursor < widget.text.length) {
      spans.add(TextSpan(
        text: widget.text.substring(cursor),
        style: textStyle,
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );
  }

  TapGestureRecognizer? _buildRecognizer({required VoidCallback onTap}) {
    final TapGestureRecognizer recognizer = TapGestureRecognizer()..onTap = onTap;
    _recognizers.add(recognizer);
    return recognizer;
  }
}
