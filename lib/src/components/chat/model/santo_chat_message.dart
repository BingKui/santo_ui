import 'package:flutter/foundation.dart';

/// 消息发送状态
enum SantoChatMessageStatus {
  /// 发送中
  sending,

  /// 已发送(对方未收到)
  sent,

  /// 已送达(对方已收到未读)
  delivered,

  /// 已读
  read,

  /// 发送失败
  failed,
}

/// 会话参与者
@immutable
class SantoChatAuthor {
  /// 业务侧用户 id
  final String id;

  /// 展示名,群聊里会显示在对方气泡上方
  final String name;

  /// 头像地址
  final String? avatarUrl;

  const SantoChatAuthor({
    required this.id,
    required this.name,
    this.avatarUrl,
  });
}

/// 被 @ 的成员
///
/// 文本里以 `@展示名` 的形式出现,[SantoChatText] 会把它渲染成高亮并可点击。
@immutable
class SantoChatMention {
  /// 业务侧成员 id
  final String id;

  /// 展示名,需与文本里 `@` 后面的内容一致
  final String display;

  const SantoChatMention({required this.id, required this.display});

  /// 从文本里解析出命中的 @ 成员
  ///
  /// 同一展示名重复出现只返回一次,顺序按 [candidates] 顺序。
  /// 展示名互为前缀时按**长名优先**匹配,避免 `@张三` 命中 `@张`。
  static List<SantoChatMention> parse(
    String text,
    List<SantoChatMention> candidates,
  ) {
    if (text.isEmpty || candidates.isEmpty) {
      return const <SantoChatMention>[];
    }
    final List<SantoChatMention> sorted = List<SantoChatMention>.of(candidates)
      ..sort((SantoChatMention a, SantoChatMention b) =>
          b.display.length.compareTo(a.display.length));
    final Map<String, SantoChatMention> hit = <String, SantoChatMention>{};
    String rest = text;
    for (final SantoChatMention mention in sorted) {
      if (mention.display.isEmpty) continue;
      final String token = '@${mention.display}';
      if (rest.contains(token)) {
        hit[mention.display] = mention;
        rest = rest.replaceAll(token, '');
      }
    }
    return <SantoChatMention>[
      for (final SantoChatMention mention in candidates)
        if (hit.containsKey(mention.display)) mention,
    ];
  }
}

/// 引用(回复)信息
@immutable
class SantoChatQuote {
  /// 被引用消息的 id,用于点击跳转
  final String? messageId;

  /// 引用来源展示名,如「张三」
  final String title;

  /// 引用内容摘要
  final String preview;

  /// 引用缩略图地址,图片/视频消息可传
  final String? thumbnailUrl;

  const SantoChatQuote({
    this.messageId,
    required this.title,
    required this.preview,
    this.thumbnailUrl,
  });
}

/// 表情回应
///
/// [emoji] 既可以是 unicode 表情(`👍`),也可以是注册过的表情名(`[赞]`)。
@immutable
class SantoChatReaction {
  /// 表情内容
  final String emoji;

  /// 回应人数
  final int count;

  /// 我是否回应过,决定高亮样式
  final bool reactedByMe;

  const SantoChatReaction({
    required this.emoji,
    this.count = 1,
    this.reactedByMe = false,
  });
}

/// 消息基类
///
/// 系统消息没有发送者,[author] 为 null。
abstract class SantoChatMessage {
  /// 消息 id
  final String id;

  /// 发送者,系统消息为 null
  final SantoChatAuthor? author;

  /// 发送时间
  final DateTime? createdAt;

  /// 发送状态
  final SantoChatMessageStatus status;

  /// 引用(回复)的消息
  final SantoChatQuote? quote;

  /// 表情回应
  final List<SantoChatReaction> reactions;

  /// 是否被编辑过,展示「已编辑」标记
  final bool isEdited;

  const SantoChatMessage({
    required this.id,
    this.author,
    this.createdAt,
    this.status = SantoChatMessageStatus.sent,
    this.quote,
    this.reactions = const <SantoChatReaction>[],
    this.isEdited = false,
  });

  /// 判断该消息是否由 [userId] 发出
  bool isMine(String? userId) => userId != null && author?.id == userId;
}

/// 文本消息
class SantoChatTextMessage extends SantoChatMessage {
  /// 文本内容,表情以 `[表情名]` 形式内联
  final String text;

  /// 文本里被 @ 的成员
  final List<SantoChatMention> mentions;

  const SantoChatTextMessage({
    required String id,
    required SantoChatAuthor author,
    required this.text,
    this.mentions = const <SantoChatMention>[],
    DateTime? createdAt,
    SantoChatMessageStatus status = SantoChatMessageStatus.sent,
    SantoChatQuote? quote,
    List<SantoChatReaction> reactions = const <SantoChatReaction>[],
    bool isEdited = false,
  }) : super(
          id: id,
          author: author,
          createdAt: createdAt,
          status: status,
          quote: quote,
          reactions: reactions,
          isEdited: isEdited,
        );
}

/// 图片消息
class SantoChatImageMessage extends SantoChatMessage {
  /// 图片地址
  final String url;

  /// 展示宽度,不传按 [width]/[height] 比例取默认宽度
  final double? width;

  /// 展示高度,不传按 [width]/[height] 比例取默认高度
  final double? height;

  /// 原图宽度,用于计算展示尺寸
  final double? originalWidth;

  /// 原图高度,用于计算展示尺寸
  final double? originalHeight;

  const SantoChatImageMessage({
    required String id,
    required SantoChatAuthor author,
    required this.url,
    this.width,
    this.height,
    this.originalWidth,
    this.originalHeight,
    DateTime? createdAt,
    SantoChatMessageStatus status = SantoChatMessageStatus.sent,
    SantoChatQuote? quote,
    List<SantoChatReaction> reactions = const <SantoChatReaction>[],
    bool isEdited = false,
  }) : super(
          id: id,
          author: author,
          createdAt: createdAt,
          status: status,
          quote: quote,
          reactions: reactions,
          isEdited: isEdited,
        );
}

/// 视频消息
class SantoChatVideoMessage extends SantoChatMessage {
  /// 视频地址
  final String? url;

  /// 封面地址
  final String? coverUrl;

  /// 视频时长,展示在封面右下角
  final Duration? duration;

  /// 展示宽度
  final double? width;

  /// 展示高度
  final double? height;

  const SantoChatVideoMessage({
    required String id,
    required SantoChatAuthor author,
    this.url,
    this.coverUrl,
    this.duration,
    this.width,
    this.height,
    DateTime? createdAt,
    SantoChatMessageStatus status = SantoChatMessageStatus.sent,
    SantoChatQuote? quote,
    List<SantoChatReaction> reactions = const <SantoChatReaction>[],
    bool isEdited = false,
  }) : super(
          id: id,
          author: author,
          createdAt: createdAt,
          status: status,
          quote: quote,
          reactions: reactions,
          isEdited: isEdited,
        );
}

/// 语音消息
class SantoChatVoiceMessage extends SantoChatMessage {
  /// 语音地址
  final String url;

  /// 语音时长
  final Duration duration;

  /// 波形高度比例,取值范围 0~1,不传时用内置的固定波形
  final List<double>? waveform;

  const SantoChatVoiceMessage({
    required String id,
    required SantoChatAuthor author,
    required this.url,
    required this.duration,
    this.waveform,
    DateTime? createdAt,
    SantoChatMessageStatus status = SantoChatMessageStatus.sent,
    SantoChatQuote? quote,
    List<SantoChatReaction> reactions = const <SantoChatReaction>[],
    bool isEdited = false,
  }) : super(
          id: id,
          author: author,
          createdAt: createdAt,
          status: status,
          quote: quote,
          reactions: reactions,
          isEdited: isEdited,
        );
}

/// 文件消息
class SantoChatFileMessage extends SantoChatMessage {
  /// 文件地址
  final String url;

  /// 文件名
  final String name;

  /// 文件大小(字节),用于展示 `1.2 MB`
  final int? size;

  const SantoChatFileMessage({
    required String id,
    required SantoChatAuthor author,
    required this.url,
    required this.name,
    this.size,
    DateTime? createdAt,
    SantoChatMessageStatus status = SantoChatMessageStatus.sent,
    SantoChatQuote? quote,
    List<SantoChatReaction> reactions = const <SantoChatReaction>[],
    bool isEdited = false,
  }) : super(
          id: id,
          author: author,
          createdAt: createdAt,
          status: status,
          quote: quote,
          reactions: reactions,
          isEdited: isEdited,
        );
}

/// 文档消息
///
/// 消息体是一张文档卡片,展示文档标题与附言,点击由业务方去校验权限并打开文档。
class SantoChatDocMessage extends SantoChatMessage {
  /// 文档标题
  final String title;

  /// 文档 ID
  final String docId;

  /// 文档所在空间 ID
  final String? spaceId;

  /// 文档地址
  final String? url;

  /// 发送时的附言,为空时不展示
  final String? content;

  const SantoChatDocMessage({
    required String id,
    required SantoChatAuthor author,
    required this.title,
    required this.docId,
    this.spaceId,
    this.url,
    this.content,
    DateTime? createdAt,
    SantoChatMessageStatus status = SantoChatMessageStatus.sent,
    SantoChatQuote? quote,
    List<SantoChatReaction> reactions = const <SantoChatReaction>[],
    bool isEdited = false,
  }) : super(
          id: id,
          author: author,
          createdAt: createdAt,
          status: status,
          quote: quote,
          reactions: reactions,
          isEdited: isEdited,
        );
}

/// 系统消息
///
/// 居中展示的弱化提示,如「张三加入了群聊」,不带头像与气泡。
class SantoChatSystemMessage extends SantoChatMessage {
  /// 提示文案
  final String text;

  const SantoChatSystemMessage({
    required String id,
    required this.text,
    DateTime? createdAt,
    SantoChatQuote? quote,
  }) : super(id: id, createdAt: createdAt, quote: quote);
}
