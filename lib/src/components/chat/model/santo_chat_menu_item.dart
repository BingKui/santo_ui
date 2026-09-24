import 'package:santo_ui/src/components/chat/model/santo_chat_message.dart';
import 'package:santo_ui/src/components/icon/santo_icons.dart';
import 'package:flutter/foundation.dart';

/// 长按菜单 / 多选操作栏里的一项
///
/// [key] 是业务标识,组件只负责展示,回调里按 [key] 分发具体行为:
///
/// ```dart
/// const SantoChatMenuItem.copy      // key = 'copy'
/// const SantoChatMenuItem.quote     // key = 'quote'
/// const SantoChatMenuItem.forward   // key = 'forward'
/// const SantoChatMenuItem.edit      // key = 'edit'
/// const SantoChatMenuItem.delete    // key = 'delete'
/// const SantoChatMenuItem.multiSelect // key = 'multiSelect'
/// const SantoChatMenuItem.voiceToText // key = 'voiceToText'
/// ```
///
/// @since v1.5.0
@immutable
class SantoChatMenuItem {
  /// 业务标识,回调里用它区分操作
  final String key;

  /// 展示文案
  final String label;

  /// 图标名称,取值见 [SantoIcons]
  final String? icon;

  /// 是否危险操作,开启后文字与图标取失败色
  final bool danger;

  const SantoChatMenuItem({
    required this.key,
    required this.label,
    this.icon,
    this.danger = false,
  });

  /// 复制
  static const SantoChatMenuItem copy =
      SantoChatMenuItem(key: 'copy', label: '复制', icon: SantoIcons.copy);

  /// 引用(回复)
  static const SantoChatMenuItem quote =
      SantoChatMenuItem(key: 'quote', label: '引用', icon: SantoIcons.reply);

  /// 转发
  static const SantoChatMenuItem forward = SantoChatMenuItem(
    key: 'forward',
    label: '转发',
    icon: SantoIcons.arrowUpRight,
  );

  /// 编辑
  static const SantoChatMenuItem edit = SantoChatMenuItem(
    key: 'edit',
    label: '编辑',
    icon: SantoIcons.editPencil,
  );

  /// 删除
  static const SantoChatMenuItem delete = SantoChatMenuItem(
    key: 'delete',
    label: '删除',
    icon: SantoIcons.trash,
    danger: true,
  );

  /// 多选
  static const SantoChatMenuItem multiSelect = SantoChatMenuItem(
    key: 'multiSelect',
    label: '多选',
    icon: SantoIcons.checkSquare,
  );

  /// 语音转文本
  static const SantoChatMenuItem voiceToText = SantoChatMenuItem(
    key: 'voiceToText',
    label: '转文字',
    icon: SantoIcons.text,
  );

  /// 按消息类型给出默认的长按菜单项
  ///
  /// - 文本消息:复制、引用、转发、(自己的)编辑、删除、多选
  /// - 语音消息:额外在最前面提供「转文字」
  /// - 图片、视频、文件:引用、转发、删除、多选
  /// - 只有自己发的消息能删除和编辑;多选对所有消息开放
  /// - 系统消息:不提供菜单
  static List<SantoChatMenuItem> defaults(
    SantoChatMessage message, {
    required bool isMine,
  }) {
    if (message is SantoChatSystemMessage) {
      return const <SantoChatMenuItem>[];
    }
    return <SantoChatMenuItem>[
      if (message is SantoChatTextMessage) copy,
      if (message is SantoChatVoiceMessage) voiceToText,
      quote,
      forward,
      if (isMine && message is SantoChatTextMessage) edit,
      if (isMine) delete,
      multiSelect,
    ];
  }
}
