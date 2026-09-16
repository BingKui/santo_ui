import 'package:flutter/foundation.dart';

/// 防止多次点击工具类
class SantoMultiClickUtils {
  const SantoMultiClickUtils._();

  static DateTime? _lastClickTime;

  /// 判断是否是多次点击
  /// [intervalMilliseconds] 间隔时间，单位毫秒，默认500毫秒
  static bool isMultiClick({int intervalMilliseconds = 500}) {
    if (_lastClickTime == null ||
        DateTime.now().difference(_lastClickTime!) >
            Duration(milliseconds: intervalMilliseconds)) {
      _lastClickTime = DateTime.now();
      return false;
    }
    return true;
  }

  /// 重置上次点击时间
  ///
  /// 记录的是静态状态,测试里连续点击会被当成多次点击,需要按用例重置
  @visibleForTesting
  static void reset() {
    _lastClickTime = null;
  }
}
