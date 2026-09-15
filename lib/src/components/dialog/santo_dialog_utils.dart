import 'package:santo_ui/src/theme/configs/santo_dialog_config.dart';
import 'package:flutter/material.dart';

/// 弹窗的工具类
class SantoDialogUtils {
  /// dialog标题配置
  static TextStyle getDialogTitleStyle(SantoDialogConfig themeData) {
    return themeData.titleTextStyle.generateTextStyle();
  }

  /// dialog圆角配置
  static double getDialogRadius(SantoDialogConfig themeData) {
    return themeData.radius;
  }
}
