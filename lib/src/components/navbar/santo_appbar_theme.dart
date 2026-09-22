import 'package:flutter/material.dart';

class SantoAppBarTheme {
  const SantoAppBarTheme._();

  /// [SantoAppBar] 高度固定值
  static const double appBarHeight = 44;

  /// AppBar中添加的leading或actionItem的边长
  static const double iconSize = 20;

  /// AppBar 右侧 actions 之间的间距,图标与文字操作共用
  ///
  /// 取值与左侧 [leadingSpacing] 一致,保证左右两侧操作区间距相同
  static const double iconMargin = 5;

  /// [LeadingIcon]的大小
  static const double iconFullSize = 40;

  /// 返回键(SantoBackLeading)图标操作区域的固定边长
  static const double leadingSize = 32;

  /// [SantoDoubleLeading] 中两个操作区之间的间距
  static const double leadingSpacing = 5;

  /// [SantoAppBar] 标题的文字大小
  static const double titleFontSize = 18;

  /// [SantoAppBar] 中TextAction中的文字大小
  static const double actionFontSize = 14;

  /// [SantoAppBar] 使用[SantoDoubleLeading]添加两个leading时的固定宽度
  static const double doubleLeadingSize = 80;

  /// [Brightness.light] 时使用的文字颜色
  static const Color lightTextColor = Color(0xFF17233D);

  /// [Brightness.dark] 时使用的文字颜色
  static const Color darkTextColor = Colors.white;

  /// AppBar title的最大字符数
  static const int maxLength = 8;
}
