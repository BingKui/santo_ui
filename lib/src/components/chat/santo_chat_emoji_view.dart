import 'package:santo_ui/src/components/chat/model/santo_chat_emoji.dart';
import 'package:santo_ui/src/components/chat/model/santo_chat_emoji_item.dart';
import 'package:santo_ui/src/components/image/santo_image.dart';
import 'package:flutter/material.dart';

/// 表情消息的展示字号与图片边长
const double kSantoChatEmojiMessageSize = 36;

/// 表情消息内容:单个大表情
///
/// [symbol] 是 `[表情名]` 且已注册图片时渲染图片,否则按 Unicode 字符展示;
/// 内置表情表见 `kSantoChatDefaultEmojis`。
///
/// @since v1.5.1
class SantoChatEmojiView extends StatelessWidget {
  /// Unicode 表情或 `[表情名]` token
  final String symbol;

  /// 展示边长,不传取 [kSantoChatEmojiMessageSize]
  final double? size;

  const SantoChatEmojiView({
    Key? key,
    required this.symbol,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double side = size ?? kSantoChatEmojiMessageSize;
    final String? url = _imageUrl();

    if (url != null) {
      return SantoImage(
        imageUrl: url,
        isNetwork: url.startsWith('http'),
        width: side,
        height: side,
      );
    }
    return Text(
      _unicodeSymbol(),
      style: TextStyle(fontSize: side),
    );
  }

  /// `[表情名]` 已注册图片时返回图片地址
  String? _imageUrl() {
    final SantoChatEmoji? emoji = _registered();
    if (emoji == null) return null;
    return SantoChatEmojiRegistry.urlOf(emoji.name);
  }

  /// 内置表情表里命中 `[表情名]` 时取它的 Unicode 字符
  String _unicodeSymbol() {
    final SantoChatEmoji? emoji = _registered();
    return emoji?.symbol ?? symbol;
  }

  SantoChatEmoji? _registered() {
    if (!symbol.startsWith('[') || !symbol.endsWith(']')) return null;
    return SantoChatEmoji.byName(symbol.substring(1, symbol.length - 1));
  }
}
