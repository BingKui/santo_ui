import 'package:santo_ui/src/components/chat/model/santo_chat_message.dart';
import 'package:santo_ui/src/components/chat/santo_chat_text.dart';
import 'package:santo_ui/src/theme/configs/santo_chat_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 长按气泡时可选的表情回应
const List<String> kSantoChatDefaultReactions = <String>[
  '👍',
  '❤️',
  '😂',
  '😮',
  '😢',
];

/// 表情回应展示:气泡下方的回应胶囊
///
/// @since v1.5.0
class SantoChatReactionView extends StatelessWidget {
  /// 回应列表
  final List<SantoChatReaction> reactions;

  /// 是否为我方气泡下方,决定胶囊在自己一侧的排列对齐
  final bool isMine;

  /// 点击某个回应回调,可用于取消自己的回应
  final ValueChanged<SantoChatReaction>? onTap;

  const SantoChatReactionView({
    Key? key,
    required this.reactions,
    this.isMine = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (reactions.isEmpty) return const SizedBox.shrink();
    final SantoChatConfig config =
        SantoThemeConfigurator.instance.getConfig().chatConfig;

    return Padding(
      padding: EdgeInsets.only(top: config.commonConfig.vSpacingXs),
      child: Wrap(
        spacing: config.commonConfig.hSpacingXs,
        runSpacing: config.commonConfig.vSpacingXs,
        children: <Widget>[
          for (final SantoChatReaction reaction in reactions)
            _buildPill(config, reaction),
        ],
      ),
    );
  }

  Widget _buildPill(SantoChatConfig config, SantoChatReaction reaction) {
    final Color borderColor = reaction.reactedByMe
        ? config.myBubbleColor
        : config.commonConfig.dividerColorBase;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap == null ? null : () => onTap!(reaction),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: config.commonConfig.hSpacingXs,
          vertical: config.commonConfig.vSpacingXs / 2,
        ),
        decoration: BoxDecoration(
          color: config.otherBubbleColor,
          borderRadius: BorderRadius.circular(config.commonConfig.radiusXs),
          border: Border.all(
            color: borderColor,
            width: config.commonConfig.borderWidthSm,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SantoChatText(
              reaction.emoji,
              emojiSize: config.emojiSize,
              style: config.otherTextStyle.generateTextStyle(),
            ),
            if (reaction.count > 1) ...<Widget>[
              SizedBox(width: config.commonConfig.hSpacingXs / 2),
              Text(
                reaction.count.toString(),
                style: config.timeTextStyle.generateTextStyle(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
