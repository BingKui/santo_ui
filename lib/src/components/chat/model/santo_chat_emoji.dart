/// 表情注册表
///
/// 文本里的 `[表情名]` 会先到这里查图片地址,查到就渲染成表情图,
/// 查不到则原样保留文字。表情资源由业务方提供,App 启动时注册一次即可:
///
/// ```dart
/// SantoChatEmojiRegistry.registerAll(<String, String>{
///   '微笑': 'assets/emoji/smile.png',
///   '赞': 'https://cdn.example.com/emoji/like.png',
/// });
/// ```
///
/// 地址以 `http` 开头按网络图加载,否则按包内资源加载。
///
/// @since v1.5.0
class SantoChatEmojiRegistry {
  SantoChatEmojiRegistry._();

  static final Map<String, String> _urls = <String, String>{};

  /// 注册单个表情
  static void register(String name, String url) {
    if (name.isEmpty || url.isEmpty) return;
    _urls[name] = url;
  }

  /// 批量注册表情
  static void registerAll(Map<String, String> emojis) {
    emojis.forEach(register);
  }

  /// 移除单个表情
  static void unregister(String name) {
    _urls.remove(name);
  }

  /// 取表情地址,未注册返回 null
  static String? urlOf(String name) => _urls[name];

  /// 已注册的全部表情
  static Map<String, String> get all => Map<String, String>.unmodifiable(_urls);

  /// 清空注册表
  static void clear() => _urls.clear();
}
