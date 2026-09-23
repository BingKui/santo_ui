import 'package:santo_ui/src/components/chat/model/santo_chat_message.dart';
import 'package:santo_ui/src/components/icon/santo_icon.dart';
import 'package:santo_ui/src/components/icon/santo_icons.dart';
import 'package:santo_ui/src/theme/configs/santo_chat_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 文件消息最大展示宽度
const double kSantoChatFileWidth = 180;

/// 会话文件消息内容:文件图标 + 文件名 + 大小
///
/// 点击后回调 [onTap],由业务方负责下载或预览。
///
/// @since v1.5.0
class SantoChatFile extends StatelessWidget {
  /// 文件消息
  final SantoChatFileMessage message;

  /// 是否位于我方气泡内,决定取色
  final bool isMine;

  /// 点击回调
  final ValueChanged<SantoChatFileMessage>? onTap;

  const SantoChatFile({
    Key? key,
    required this.message,
    this.isMine = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SantoChatConfig config =
        SantoThemeConfigurator.instance.getConfig().chatConfig;
    final Color contentColor = isMine
        ? config.myTextStyle.color ?? config.commonConfig.colorTextBaseInverse
        : config.otherTextStyle.color ?? config.commonConfig.colorTextBase;
    final String? sizeText = formatFileSize(message.size);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap == null ? null : () => onTap!(message),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: kSantoChatFileWidth),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: config.avatarSize,
              height: config.avatarSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: contentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(config.commonConfig.radiusXs),
              ),
              child: SantoIcon(
                SantoIcons.page,
                size: config.commonConfig.iconSizeMd,
                color: contentColor,
              ),
            ),
            SizedBox(width: config.commonConfig.hSpacingSm),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    message.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: config.otherTextStyle
                        .generateTextStyle()
                        .copyWith(color: contentColor),
                  ),
                  if (sizeText != null)
                    Text(
                      sizeText,
                      style: config.timeTextStyle
                          .generateTextStyle()
                          .copyWith(color: contentColor.withOpacity(0.7)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 把字节数格式化成 `1.2 MB`,为 null 时返回 null
String? formatFileSize(int? bytes) {
  if (bytes == null || bytes < 0) return null;
  if (bytes < 1024) return '$bytes B';
  const List<String> units = <String>['KB', 'MB', 'GB', 'TB'];
  double value = bytes / 1024;
  int unitIndex = 0;
  while (value >= 1024 && unitIndex < units.length - 1) {
    value /= 1024;
    unitIndex++;
  }
  return '${value.toStringAsFixed(1)} ${units[unitIndex]}';
}
