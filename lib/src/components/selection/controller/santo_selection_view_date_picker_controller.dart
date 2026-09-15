import 'package:flutter/material.dart';

/// 日期选择器动画控制器
class SantoSelectionDatePickerController extends ChangeNotifier {

  /// 是否显示下拉筛选列表
  bool isShow;

  /// OverlayEntry 用于展示隐藏子组件
  OverlayEntry? entry;

  SantoSelectionDatePickerController({
    this.isShow = false,
    this.entry,
  });

  void show() {
    isShow = true;
  }

  void hide() {
    isShow = false;
    entry?.remove();
    entry = null;
  }
}
