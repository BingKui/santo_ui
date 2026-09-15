import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'santo_resources.dart';

///
/// Santo 多语言支持
///
class SantoIntl {

  /// 内置支持的语言和资源
  final Map<String, SantoBaseResource> _defaultResourceMap = {'en': SantoResourceEn(), 'zh': SantoResourceZh()};

  /// 缓存当前语言对应的资源，用于无 context 的情况
  static SantoIntl? _current;
  static SantoBaseResource get currentResource {
    assert(_current != null,
        'No instance of SantoIntl was loaded. \n'
        'Try to initialize the SantoLocalizationDelegate before accessing SantoIntl.currentResource.');
    /// 若应用未做本地化，则默认使用 zh-CN 资源
    if(_current == null) {
      _current = SantoIntl(SantoResourceZh.locale);
    }
    return _current!.localizedResource;
  }

  final Locale locale;

  SantoIntl(this.locale);

  /// 获取当前语言下对应的资源，若为 null 则返回 [SantoResourceZh]
  SantoBaseResource get localizedResource {
    // 支持动态资源文件
    SantoBaseResource? resource = _SantoIntlHelper.findIntlResourceOfType<SantoBaseResource>(locale);
    if (resource != null) return resource;
    // 常规的多语言资源加载
    return _defaultResourceMap[locale.languageCode] ?? _defaultResourceMap['zh']!;
  }

  /// 获取[SantoIntl]实例
  static SantoIntl of(BuildContext context) {
    return Localizations.of(context, SantoIntl) ?? SantoIntl(SantoResourceZh.locale);
  }

  /// 获取当前语言下 [SantoBaseResource] 资源
  static SantoBaseResource i10n(BuildContext context) {
    return SantoIntl.of(context).localizedResource;
  }

  /// 应用加载本地化资源
  static Future<SantoIntl> _load(Locale locale) {
    _current = SantoIntl(locale);
    return SynchronousFuture<SantoIntl>(_current!);
  }

  /// 支持非内置的本地化能力
  static void add(Locale locale, SantoBaseResource resource) {
    _SantoIntlHelper.add(locale, resource);
  }

  /// 支持非内置的本地化能力
  static void addAll(Locale locale, List<SantoBaseResource> resources) {
    _SantoIntlHelper.addAll(locale, resources);
  }
}

///
/// 组件多语言适配代理
///
class SantoLocalizationDelegate extends LocalizationsDelegate<SantoIntl> {
  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<SantoIntl> load(Locale locale) {
    debugPrint(runtimeType.toString() +
        ' load: locale = $locale, ${locale.countryCode}, ${locale.languageCode}');
    return SantoIntl._load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<SantoIntl> old) => false;

  /// 需在app入口注册
  static SantoLocalizationDelegate delegate = SantoLocalizationDelegate();
}

///
/// 支持外部动态添加其他语言支的本地化
///
final Map<Locale, Map<Type, dynamic>> _additionalIntls = {};
class _SantoIntlHelper {

  ///
  /// 根据 locale 查找 value 类型为[T]的资源
  ///
  static T? findIntlResourceOfType<T>(Locale locale) {
    Map<Type, dynamic>? res = _additionalIntls[locale];
    if (res != null && res.isNotEmpty) {
      for (var entry in res.entries) {
        if (entry.value is T) {
          return entry.value;
        }
      }
    }
    return null;
  }


  ///
  /// 设置自定义 locale 的资源
  ///
  static void addAll(Locale locale, List<SantoBaseResource> resources) {
    var res = _additionalIntls[locale];
    if (res == null) {
      res = {};
      _additionalIntls[locale] = res;
    }
    for (SantoBaseResource resource in resources) {
      res[resource.runtimeType] = resource;
    }
  }

  ///
  /// 设置自定义 locale 的资源
  ///
  static void add(Locale locale, SantoBaseResource resource) {
    var res = _additionalIntls[locale];
    if (res == null) {
      res = {};
      _additionalIntls[locale] = res;
    }
    res[resource.runtimeType] = resource;
  }
}
