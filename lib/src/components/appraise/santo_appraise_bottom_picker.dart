import 'package:santo_ui/src/components/appraise/santo_appraise.dart';
import 'package:santo_ui/src/components/appraise/santo_appraise_header.dart';
import 'package:santo_ui/src/components/appraise/santo_appraise_config.dart';
import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:flutter/material.dart';
import 'package:santo_ui/src/components/appraise/santo_appraise_interface.dart';

/// 描述: 评价组件bottom picker，
/// 使用 showModalBottomSheet 从底部弹出，支持顶部圆角和安全区域处理
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
  /// * [isScrollControlled] 是否允许弹窗高度自适应，默认 true
  /// * [barrierColor] 遮罩层颜色，默认半透明黑色
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
    bool isScrollControlled = true,
    Color? barrierColor,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor ?? Colors.black.withAlpha(0x66),
      builder: (BuildContext context) {
        return _SantoAppraiseBottomSheet(
          title: title,
          headerType: headerType,
          type: type,
          iconDescriptions: iconDescriptions ?? SantoIntl.of(context).localizedResource.appriseLevel,
          tags: tags,
          inputHintText: inputHintText,
          onConfirm: onConfirm,
          config: config,
        );
      },
    );
  }
}

/// 底部弹出评价组件的内部实现
class _SantoAppraiseBottomSheet extends StatefulWidget {
  final String title;
  final SantoAppraiseHeaderType headerType;
  final SantoAppraiseType type;
  final List<String>? iconDescriptions;
  final List<String>? tags;
  final String inputHintText;
  final SantoAppraiseConfirmClick? onConfirm;
  final SantoAppraiseConfig config;

  const _SantoAppraiseBottomSheet({
    Key? key,
    this.title = '',
    this.headerType = SantoAppraiseHeaderType.spaceBetween,
    this.type = SantoAppraiseType.star,
    this.iconDescriptions,
    this.tags,
    this.inputHintText = '',
    this.onConfirm,
    this.config = const SantoAppraiseConfig(),
  }) : super(key: key);

  @override
  State<_SantoAppraiseBottomSheet> createState() =>
      _SantoAppraiseBottomSheetState();
}

class _SantoAppraiseBottomSheetState extends State<_SantoAppraiseBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: SantoAppraise(
                title: widget.title,
                headerType: widget.headerType,
                type: widget.type,
                iconDescriptions: widget.iconDescriptions,
                tags: widget.tags,
                inputHintText: widget.inputHintText,
                onConfirm: (index, list, input) {
                  if (widget.onConfirm != null) {
                    widget.onConfirm!(index, list, input);
                  }
                  Navigator.of(context).pop();
                },
                config: widget.config,
              ),
            ),
          ),
          // 底部安全区域
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }
}
