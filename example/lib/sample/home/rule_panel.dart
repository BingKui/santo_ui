import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// 示例规则说明面板
///
/// 统一展示各组件示例中的「规则」信息,内容为气泡文本。
class RulePanel extends StatelessWidget {
  /// 规则文案
  final String text;

  /// 最多显示的行数,超出可展开收起
  final int? maxLines;

  const RulePanel(
    this.text, {
    Key? key,
    this.maxLines = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SantoPanel(
      title: '规则',
      child: SantoBubbleText(
        maxLines: maxLines,
        text: text,
      ),
    );
  }
}
