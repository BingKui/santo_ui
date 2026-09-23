import 'package:flutter/foundation.dart';

/// 会话(会话列表里的一行)
///
/// @since v1.5.0
@immutable
class SantoChatConversation {
  /// 会话 id,通常是对端用户 id 或群 id
  final String id;

  /// 会话标题,群聊为群名
  final String title;

  /// 会话头像
  final String? avatarUrl;

  /// 最后一条消息摘要
  final String preview;

  /// 最后一条消息时间
  final DateTime? updatedAt;

  /// 未读数,大于 0 时展示角标
  final int unreadCount;

  /// 是否置顶
  final bool pinned;

  /// 是否免打扰,开启后未读只显示红点
  final bool muted;

  const SantoChatConversation({
    required this.id,
    required this.title,
    this.avatarUrl,
    this.preview = '',
    this.updatedAt,
    this.unreadCount = 0,
    this.pinned = false,
    this.muted = false,
  });

  /// 未读数超过 99 时展示 `99+`
  String get unreadText => unreadCount > 99 ? '99+' : unreadCount.toString();
}
