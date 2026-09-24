import 'package:flutter/widgets.dart';

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

/// 审批单状态,用于 [SantoChatApprovalMessage]
///
/// @since v1.5.1
enum SantoChatApprovalStatus {
  /// 审批中
  pending,

  /// 已通过
  approved,

  /// 已驳回
  rejected,

  /// 已取消
  cancelled;

  /// 服务端字符串转枚举,未知值按 [cancelled] 处理
  static SantoChatApprovalStatus fromName(String? name) {
    switch (name) {
      case 'pending':
        return SantoChatApprovalStatus.pending;
      case 'approved':
        return SantoChatApprovalStatus.approved;
      case 'rejected':
        return SantoChatApprovalStatus.rejected;
      default:
        return SantoChatApprovalStatus.cancelled;
    }
  }
}

/// 通知类型,用于 [SantoChatNoticeMessage],决定卡片图标与配色
///
/// @since v1.5.1
enum SantoChatNoticeType {
  /// 审批通知
  approval,

  /// 被 @ 的通知
  mention,

  /// 会话消息通知
  message,

  /// 任务执行结果通知
  task,

  /// 其他通知
  other;

  /// 服务端字符串转枚举
  static SantoChatNoticeType fromName(String? name) {
    switch (name) {
      case 'approval':
        return SantoChatNoticeType.approval;
      case 'imMention':
        return SantoChatNoticeType.mention;
      case 'imMessage':
        return SantoChatNoticeType.message;
      case 'taskExecuteResult':
        return SantoChatNoticeType.task;
      default:
        return SantoChatNoticeType.other;
    }
  }
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

/// 已读回执
///
/// 只用于发送方的消息,按 [label] 展示:单聊是「已读 / 未读」,
/// 群聊是「N人未读 / 全部已读」(对标钉钉);人员列表由服务端按需下发,
/// 点击文案后可以把它交给 `SantoChatReadReceiptSheet.show` 展示。
///
/// @since v1.5.1
@immutable
class SantoChatReadReceipt {
  /// 已读人数
  final int readCount;

  /// 未读人数
  final int unreadCount;

  /// 已读人员,不传时只展示人数
  final List<SantoChatAuthor>? readMembers;

  /// 未读人员,不传时只展示人数
  final List<SantoChatAuthor>? unreadMembers;

  const SantoChatReadReceipt({
    this.readCount = 0,
    this.unreadCount = 0,
    this.readMembers,
    this.unreadMembers,
  });

  /// 两个人数都为 0,没有可展示的信息
  bool get isEmpty => readCount <= 0 && unreadCount <= 0;

  /// 回执文案:单聊「已读 / 未读」,群聊「N人未读 / 全部已读」
  String get label {
    if (readCount + unreadCount <= 1) {
      if (readCount > 0) return '已读';
      if (unreadCount > 0) return '未读';
      return '';
    }
    if (unreadCount <= 0) return '全部已读';
    return '$unreadCount人未读';
  }
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

  /// 是否已撤回,为 true 时消息本体不再渲染(撤回提示由服务端下发的系统消息展示)
  ///
  /// @since v1.5.1
  final bool recalled;

  /// 已读回执(群聊的已读/未读人数),由服务端下发,只在发送方展示
  ///
  /// @since v1.5.1
  final SantoChatReadReceipt? readReceipt;

  const SantoChatMessage({
    required this.id,
    this.author,
    this.createdAt,
    this.status = SantoChatMessageStatus.sent,
    this.quote,
    this.reactions = const <SantoChatReaction>[],
    this.isEdited = false,
    this.recalled = false,
    this.readReceipt,
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
    bool recalled = false,
    SantoChatReadReceipt? readReceipt,
  }) : super(
          id: id,
          author: author,
          createdAt: createdAt,
          status: status,
          quote: quote,
          reactions: reactions,
          isEdited: isEdited,
          recalled: recalled,
          readReceipt: readReceipt,
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
    bool recalled = false,
    SantoChatReadReceipt? readReceipt,
  }) : super(
          id: id,
          author: author,
          createdAt: createdAt,
          status: status,
          quote: quote,
          reactions: reactions,
          isEdited: isEdited,
          recalled: recalled,
          readReceipt: readReceipt,
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
    bool recalled = false,
    SantoChatReadReceipt? readReceipt,
  }) : super(
          id: id,
          author: author,
          createdAt: createdAt,
          status: status,
          quote: quote,
          reactions: reactions,
          isEdited: isEdited,
          recalled: recalled,
          readReceipt: readReceipt,
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
    bool recalled = false,
    SantoChatReadReceipt? readReceipt,
  }) : super(
          id: id,
          author: author,
          createdAt: createdAt,
          status: status,
          quote: quote,
          reactions: reactions,
          isEdited: isEdited,
          recalled: recalled,
          readReceipt: readReceipt,
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
    bool recalled = false,
    SantoChatReadReceipt? readReceipt,
  }) : super(
          id: id,
          author: author,
          createdAt: createdAt,
          status: status,
          quote: quote,
          reactions: reactions,
          isEdited: isEdited,
          recalled: recalled,
          readReceipt: readReceipt,
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
    bool recalled = false,
    SantoChatReadReceipt? readReceipt,
  }) : super(
          id: id,
          author: author,
          createdAt: createdAt,
          status: status,
          quote: quote,
          reactions: reactions,
          isEdited: isEdited,
          recalled: recalled,
          readReceipt: readReceipt,
        );
}

/// 自定义消息
///
/// 内容由业务方通过 [builder] 自行渲染(如审批卡片),组件只负责左右分栏、头像、
/// 昵称、时间与发送状态。内容自带容器,走**裸气泡**(不画气泡底色与内边距),
/// 因此不必再包一层卡片。
class SantoChatCustomMessage extends SantoChatMessage {
  /// 内容构建器,返回的 Widget 自带容器
  final Widget Function(BuildContext context) builder;

  const SantoChatCustomMessage({
    required String id,
    required SantoChatAuthor author,
    required this.builder,
    DateTime? createdAt,
    SantoChatMessageStatus status = SantoChatMessageStatus.sent,
    SantoChatQuote? quote,
    List<SantoChatReaction> reactions = const <SantoChatReaction>[],
    bool isEdited = false,
    bool recalled = false,
    SantoChatReadReceipt? readReceipt,
  }) : super(
          id: id,
          author: author,
          createdAt: createdAt,
          status: status,
          quote: quote,
          reactions: reactions,
          isEdited: isEdited,
          recalled: recalled,
          readReceipt: readReceipt,
        );
}

/// 审批消息
///
/// 消息体是一张审批卡片,可带通过 / 驳回操作,状态取 [approvalStatus]
/// (与基类的发送状态 [status] 无关)。
///
/// @since v1.5.1
class SantoChatApprovalMessage extends SantoChatMessage {
  /// 审批任务 id,业务回调里用它定位审批单
  final String taskId;

  /// 审批标题
  final String title;

  /// 审批单状态
  final SantoChatApprovalStatus approvalStatus;

  /// 审批单号
  final String? taskNo;

  /// 审批流名称
  final String? flowName;

  /// 申请人
  final String? applicatorName;

  /// 当前节点名称
  final String? currentNodeName;

  /// 是否可审批,为 true 且状态是 [SantoChatApprovalStatus.pending] 时展示操作按钮
  final bool canApprove;

  const SantoChatApprovalMessage({
    required String id,
    required SantoChatAuthor author,
    required this.taskId,
    required this.title,
    this.approvalStatus = SantoChatApprovalStatus.pending,
    this.taskNo,
    this.flowName,
    this.applicatorName,
    this.currentNodeName,
    this.canApprove = false,
    DateTime? createdAt,
    SantoChatMessageStatus status = SantoChatMessageStatus.sent,
    SantoChatQuote? quote,
    List<SantoChatReaction> reactions = const <SantoChatReaction>[],
    bool isEdited = false,
    bool recalled = false,
    SantoChatReadReceipt? readReceipt,
  }) : super(
          id: id,
          author: author,
          createdAt: createdAt,
          status: status,
          quote: quote,
          reactions: reactions,
          isEdited: isEdited,
          recalled: recalled,
          readReceipt: readReceipt,
        );
}

/// 通知消息
///
/// 消息体是一张通知卡片(类型图标 + 标题 + 正文 + 时间),
/// 也可以直接当通知中心的列表项使用 [SantoChatNoticeCard]。
///
/// @since v1.5.1
class SantoChatNoticeMessage extends SantoChatMessage {
  /// 通知标题
  final String title;

  /// 通知正文
  final String content;

  /// 通知类型,决定卡片图标与配色
  final SantoChatNoticeType noticeType;

  /// 是否已读,未读时标题前展示红点
  final bool read;

  /// 业务跳转标识,点击时原样回调给业务
  final String? targetId;

  const SantoChatNoticeMessage({
    required String id,
    required SantoChatAuthor author,
    required this.title,
    required this.content,
    this.noticeType = SantoChatNoticeType.other,
    this.read = false,
    this.targetId,
    DateTime? createdAt,
    SantoChatMessageStatus status = SantoChatMessageStatus.sent,
    SantoChatQuote? quote,
    List<SantoChatReaction> reactions = const <SantoChatReaction>[],
    bool isEdited = false,
    bool recalled = false,
    SantoChatReadReceipt? readReceipt,
  }) : super(
          id: id,
          author: author,
          createdAt: createdAt,
          status: status,
          quote: quote,
          reactions: reactions,
          isEdited: isEdited,
          recalled: recalled,
          readReceipt: readReceipt,
        );
}

/// 表情消息:单个大表情
///
/// [symbol] 既可以是 Unicode 表情(`👍`),也可以是注册过图片的表情名
/// (写 `[表情名]`,由 [SantoChatEmojiRegistry] 决定渲染成图片还是字符)。
///
/// @since v1.5.1
class SantoChatEmojiMessage extends SantoChatMessage {
  /// Unicode 表情或 `[表情名]` token
  final String symbol;

  const SantoChatEmojiMessage({
    required String id,
    required SantoChatAuthor author,
    required this.symbol,
    DateTime? createdAt,
    SantoChatMessageStatus status = SantoChatMessageStatus.sent,
    SantoChatQuote? quote,
    List<SantoChatReaction> reactions = const <SantoChatReaction>[],
    bool isEdited = false,
    bool recalled = false,
    SantoChatReadReceipt? readReceipt,
  }) : super(
          id: id,
          author: author,
          createdAt: createdAt,
          status: status,
          quote: quote,
          reactions: reactions,
          isEdited: isEdited,
          recalled: recalled,
          readReceipt: readReceipt,
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
