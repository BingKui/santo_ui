import 'package:santo_ui/src/components/chat/model/santo_chat_message.dart';
import 'package:santo_ui/src/components/chat/santo_chat_image.dart';
import 'package:santo_ui/src/components/icon/santo_icon.dart';
import 'package:santo_ui/src/components/icon/santo_solid_icons.dart';
import 'package:santo_ui/src/components/image/santo_image.dart';
import 'package:santo_ui/src/theme/configs/santo_chat_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 会话视频消息内容:封面 + 播放按钮 + 时长角标
///
/// 组件不负责播放,点击后回调 [onTap],由业务方跳转播放页或自建播放器。
///
/// @since v1.5.0
class SantoChatVideo extends StatelessWidget {
  /// 视频消息
  final SantoChatVideoMessage message;

  /// 点击播放回调
  final ValueChanged<SantoChatVideoMessage>? onTap;

  /// 点击时是否自动收起键盘
  final bool unfocusOnTap;

  const SantoChatVideo({
    Key? key,
    required this.message,
    this.onTap,
    this.unfocusOnTap = true,
  }) : super(key: key);

  /// 时长文案,如 `01:30`;视频超过一小时会带上小时位
  static String formatDuration(Duration duration) {
    final int seconds = duration.inSeconds;
    final String mm = (seconds % 3600 ~/ 60).toString().padLeft(2, '0');
    final String ss = (seconds % 60).toString().padLeft(2, '0');
    if (seconds >= 3600) {
      return '${seconds ~/ 3600}:$mm:$ss';
    }
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final SantoChatConfig config =
        SantoThemeConfigurator.instance.getConfig().chatConfig;
    final double width = message.width ?? kSantoChatMediaWidth;
    final double height = message.height ?? kSantoChatMediaDefaultHeight;
    final String? coverUrl = message.coverUrl;

    return GestureDetector(
      onTap: onTap == null
          ? null
          : () {
              if (unfocusOnTap) {
                FocusScope.of(context).unfocus();
              }
              onTap!(message);
            },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(config.bubbleRadius),
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              if (coverUrl == null || coverUrl.isEmpty)
                Container(color: config.commonConfig.fillBody)
              else
                SantoImage(
                  imageUrl: coverUrl,
                  isNetwork: coverUrl.startsWith('http'),
                  width: width,
                  height: height,
                  fit: BoxFit.cover,
                ),
              Center(
                child: Container(
                  width: config.avatarSize,
                  height: config.avatarSize,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.45),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SantoIcon(
                      SantoSolidIcons.play,
                      solid: true,
                      size: config.commonConfig.iconSizeSm,
                      color: config.commonConfig.colorTextBaseInverse,
                    ),
                  ),
                ),
              ),
              if (message.duration != null)
                Positioned(
                  right: config.commonConfig.hSpacingXs,
                  bottom: config.commonConfig.vSpacingXs,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: config.commonConfig.hSpacingXs,
                      vertical: config.commonConfig.vSpacingXs / 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      borderRadius:
                          BorderRadius.circular(config.commonConfig.radiusXs / 2),
                    ),
                    child: Text(
                      formatDuration(message.duration!),
                      style: config.timeTextStyle.generateTextStyle().copyWith(
                            color: config.commonConfig.colorTextBaseInverse,
                          ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
