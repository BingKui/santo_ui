/// 会话表情:面板里展示 [symbol],插入输入框的是 `[name]`
///
/// 消息文本里存的是 `[name]` 这种 token:
/// - 业务在 [SantoChatEmojiRegistry] 注册过同名表情图时,渲染成表情图
/// - 没注册时按内置的 [symbol] 渲染成 Unicode 表情
///
/// @since v1.5.0
class SantoChatEmoji {
  /// 表情名,对应文本里的 `[表情名]`
  final String name;

  /// 展示用的 Unicode 表情字符
  final String symbol;

  const SantoChatEmoji({required this.name, required this.symbol});

  /// 插入输入框的 token,如 `[微笑]`
  String get token => '[$name]';

  static final Map<String, SantoChatEmoji> _byName = <String, SantoChatEmoji>{
    for (final SantoChatEmoji emoji in kSantoChatDefaultEmojis) emoji.name: emoji,
  };

  /// 按名字取内置表情,没有返回 null
  static SantoChatEmoji? byName(String name) => _byName[name];
}

/// 内置表情表(与 DevOpsMobile `imEmojiMap` 一致)
const List<SantoChatEmoji> kSantoChatDefaultEmojis = <SantoChatEmoji>[
  SantoChatEmoji(name: '微笑', symbol: '😊'),
  SantoChatEmoji(name: '大笑', symbol: '😄'),
  SantoChatEmoji(name: '捂脸', symbol: '🤣'),
  SantoChatEmoji(name: '可爱', symbol: '😍'),
  SantoChatEmoji(name: '害羞', symbol: '😳'),
  SantoChatEmoji(name: '亲亲', symbol: '😘'),
  SantoChatEmoji(name: '思考', symbol: '🤔'),
  SantoChatEmoji(name: '无语', symbol: '😒'),
  SantoChatEmoji(name: '惊讶', symbol: '😮'),
  SantoChatEmoji(name: '哭', symbol: '😭'),
  SantoChatEmoji(name: '委屈', symbol: '🥺'),
  SantoChatEmoji(name: '生气', symbol: '😡'),
  SantoChatEmoji(name: 'OK', symbol: '👌'),
  SantoChatEmoji(name: '鼓掌', symbol: '👏'),
  SantoChatEmoji(name: '握手', symbol: '🤝'),
  SantoChatEmoji(name: '加油', symbol: '💪'),
  SantoChatEmoji(name: '庆祝', symbol: '🎉'),
  SantoChatEmoji(name: '烟花', symbol: '🎆'),
  SantoChatEmoji(name: '红包', symbol: '🧧'),
  SantoChatEmoji(name: '玫瑰', symbol: '🌹'),
  SantoChatEmoji(name: '咖啡', symbol: '☕'),
  SantoChatEmoji(name: '啤酒', symbol: '🍺'),
  SantoChatEmoji(name: '蛋糕', symbol: '🎂'),
  SantoChatEmoji(name: '爱心', symbol: '❤️'),
  SantoChatEmoji(name: '破防', symbol: '💔'),
  SantoChatEmoji(name: '赞', symbol: '👍'),
  SantoChatEmoji(name: '踩', symbol: '👎'),
  SantoChatEmoji(name: '抱拳', symbol: '🙏'),
  SantoChatEmoji(name: '旺柴', symbol: '🐶'),
  SantoChatEmoji(name: '太阳', symbol: '☀️'),
  SantoChatEmoji(name: '月亮', symbol: '🌙'),
  SantoChatEmoji(name: '礼物', symbol: '🎁'),
];
