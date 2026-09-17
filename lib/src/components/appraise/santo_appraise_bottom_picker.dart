import 'package:santo_ui/src/components/appraise/santo_appraise.dart';
import 'package:santo_ui/src/components/appraise/santo_appraise_header.dart';
import 'package:santo_ui/src/components/appraise/santo_appraise_config.dart';
import 'package:santo_ui/src/components/drawer/santo_bottom_drawer.dart';
import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:flutter/material.dart';
import 'package:santo_ui/src/components/appraise/santo_appraise_interface.dart';

/// 描述: 评价组件bottom picker
///
/// 复用底部弹窗组件 [SantoBottomDrawer] 从底部弹出评价面板:
/// 圆角、最大高度、遮罩、底部安全区域都由弹窗统一处理,
/// 标题与关闭按钮沿用评价组件自身的 header
class SantoAppraiseBottomPicker {
  /// 从底部弹出评价组件
  ///
  /// * [context] 上下文
  /// * [title] 标题
  /// * [headerType] 标题类型
  /// * [type] 评分组件类型，分为表情包和星星，默认星星
  /// * [iconDescriptions] 自定义文案
  /// * [tags] 标签
  /// * [inputHintText] 输入框允许提示文案
  /// * [onConfirm] 提交按钮的点击回调
  /// * [config] 评价组件的配置项
  /// * [barrierColor] 遮罩层颜色，默认半透明黑色
  /// * [barrierDismissible] 点击遮罩是否关闭，默认 true
  static Future<T?> show<T>({
    required BuildContext context,
    String title = '',
    SantoAppraiseHeaderType headerType = SantoAppraiseHeaderType.spaceBetween,
    SantoAppraiseType type = SantoAppraiseType.star,
    List<String>? iconDescriptions,
    List<String>? tags,
    String inputHintText = '',
    SantoAppraiseConfirmClick? onConfirm,
    SantoAppraiseConfig config = const SantoAppraiseConfig(),
    Color? barrierColor,
    bool barrierDismissible = true,
  }) {
    return SantoBottomDrawer.show<T>(
      context: context,
      // 标题与关闭按钮沿用评价组件自身的 header
      showCloseButton: false,
      barrierDismissible: barrierDismissible,
      maskColor: barrierColor,
      contentPadding: EdgeInsets.zero,
      child: SingleChildScrollView(
        child: SantoAppraise(
          title: title,
          headerType: headerType,
          type: type,
          iconDescriptions:
              iconDescriptions ?? SantoIntl.of(context).localizedResource.appriseLevel,
          tags: tags,
          inputHintText: inputHintText,
          onConfirm: (index, list, input) {
            if (onConfirm != null) {
              onConfirm(index, list, input);
            }
            Navigator.of(context).pop();
          },
          config: config,
        ),
      ),
    );
  }
}
