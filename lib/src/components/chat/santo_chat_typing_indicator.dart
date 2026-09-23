import 'package:santo_ui/src/components/chat/model/santo_chat_message.dart';
import 'package:santo_ui/src/components/chat/santo_chat_bubble.dart';
import 'package:santo_ui/src/theme/configs/santo_chat_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 对方正在输入
///
/// 气泡内是三个循环起伏的圆点,由 [SantoChatMessageList] 在列表底部自动展示。
///
/// @since v1.5.0
class SantoChatTypingIndicator extends StatefulWidget {
  /// 正在输入的对方
  final SantoChatAuthor? author;

  /// 是否展示头像
  final bool showAvatar;

  /// 是否展示昵称
  final bool showName;

  const SantoChatTypingIndicator({
    Key? key,
    this.author,
    this.showAvatar = true,
    this.showName = false,
  }) : super(key: key);

  @override
  State<SantoChatTypingIndicator> createState() =>
      _SantoChatTypingIndicatorState();
}

class _SantoChatTypingIndicatorState extends State<SantoChatTypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SantoChatConfig config =
        SantoThemeConfigurator.instance.getConfig().chatConfig;

    return SantoChatBubble(
      author: widget.author,
      isMine: false,
      showAvatar: widget.showAvatar,
      showName: widget.showName,
      child: SizedBox(
        height: config.commonConfig.fontSizeBase,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (int i = 0; i < 3; i++) ...<Widget>[
                  if (i > 0) SizedBox(width: config.commonConfig.hSpacingXs),
                  _buildDot(config, i),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDot(SantoChatConfig config, int index) {
    final double progress = (_controller.value - index * 0.2) % 1.0;
    final double wave = progress < 0.5 ? progress * 2 : (1 - progress) * 2;
    final double opacity = 0.3 + wave * 0.7;
    final double size = config.commonConfig.fontSizeBase / 3;

    return Transform.translate(
      offset: Offset(0, -wave * size),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: config.otherTextStyle.color?.withOpacity(opacity) ??
              config.commonConfig.colorTextBase.withOpacity(opacity),
        ),
      ),
    );
  }
}
