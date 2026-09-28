import 'package:flutter/foundation.dart';
import 'package:santo_ui/src/components/avatar/santo_group_avatar.dart';

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

  /// 是否群聊;群聊在 [memberAvatars] 为空时回退为群图标头像
  ///
  /// @since v2.2.2
  final bool isGroup;

  /// 群聊成员头像,用于平铺九宫格群头像
  ///
  /// 会话列表接口一般不返回成员,由业务按需拉取会话详情补全;
  /// 非空且多于一个成员时,[SantoChatList] 交给 [SantoGroupAvatar] 渲染
  ///
  /// @since v2.2.2
  final List<SantoGroupAvatarItem> memberAvatars;

  const SantoChatConversation({
    required this.id,
    required this.title,
    this.avatarUrl,
    this.preview = '',
    this.updatedAt,
    this.unreadCount = 0,
    this.pinned = false,
    this.muted = false,
    this.isGroup = false,
    this.memberAvatars = const <SantoGroupAvatarItem>[],
  });

  /// 未读数超过 99 时展示 `99+`
  String get unreadText => unreadCount > 99 ? '99+' : unreadCount.toString();
}
