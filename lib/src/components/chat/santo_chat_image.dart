import 'package:santo_ui/src/components/chat/model/santo_chat_message.dart';
import 'package:santo_ui/src/components/image/santo_image.dart';
import 'package:santo_ui/src/theme/configs/santo_chat_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 图片/视频封面默认展示宽度
const double kSantoChatMediaWidth = 160;

/// 图片/视频封面默认展示高度
const double kSantoChatMediaDefaultHeight = 120;

/// 图片/视频封面展示的最大高度
const double kSantoChatMediaMaxHeight = 240;

/// 会话图片消息内容:圆角缩略图,点击回调由业务方处理预览
///
/// 未指定 [SantoChatImageMessage.width]/[height] 时,按原图宽高比缩放,
/// 高度上限见 [kSantoChatMediaMaxHeight]。
///
/// @since v1.5.0
class SantoChatImage extends StatelessWidget {
  /// 图片消息
  final SantoChatImageMessage message;

  /// 点击图片回调
  final ValueChanged<SantoChatImageMessage>? onTap;

  /// 点击图片时是否自动收起键盘
  final bool unfocusOnTap;

  const SantoChatImage({
    Key? key,
    required this.message,
    this.onTap,
    this.unfocusOnTap = true,
  }) : super(key: key);

  /// 解析展示尺寸
  Size _resolveSize() {
    final double width = message.width ?? kSantoChatMediaWidth;
    if (message.width != null && message.height != null) {
      return Size(message.width!, message.height!);
    }
    if (message.height != null) {
      return Size(width, message.height!);
    }
    final double? originalWidth = message.originalWidth;
    final double? originalHeight = message.originalHeight;
    if (originalWidth != null && originalHeight != null && originalWidth > 0) {
      final double scaled = width * originalHeight / originalWidth;
      return Size(
        width,
        scaled.clamp(1.0, kSantoChatMediaMaxHeight).toDouble(),
      );
    }
    return Size(width, kSantoChatMediaDefaultHeight);
  }

  @override
  Widget build(BuildContext context) {
    final SantoChatConfig config =
        SantoThemeConfigurator.instance.getConfig().chatConfig;
    final Size size = _resolveSize();

    return GestureDetector(
      onTap: onTap == null
          ? null
          : () {
              if (unfocusOnTap) {
                FocusScope.of(context).unfocus();
              }
              onTap!(message);
            },
      child: SantoImage(
        imageUrl: message.url,
        isNetwork: message.url.startsWith('http'),
        width: size.width,
        height: size.height,
        radius: config.bubbleRadius,
      ),
    );
  }
}
