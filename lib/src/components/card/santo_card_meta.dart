import 'package:flutter/material.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 卡片元信息:头像 + 标题 + 描述(对应 antd Card.Meta)
///
/// 用在 [SantoCard.meta] 上:
///
/// ```dart
/// SantoCard(
///   meta: const SantoCardMeta(
///     avatar: SantoAvatar(url: '...'),
///     title: '标题',
///     description: '描述文案',
///   ),
///   child: const Text('内容'),
/// )
/// ```
///
/// @since v4.0.0
class SantoCardMeta extends StatelessWidget {
  /// 头像或图标
  final Widget? avatar;

  /// 标题文案
  final String? title;

  /// 描述文案,支持换行
  final String? description;

  const SantoCardMeta({
    super.key,
    this.avatar,
    this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final bool hasTitle = title != null && title!.isNotEmpty;
    final bool hasDescription = description != null && description!.isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (avatar != null) ...[
          avatar!,
          SizedBox(width: commonConfig.hSpacingMd),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasTitle)
                Text(
                  title!,
                  style: TextStyle(
                    fontSize: commonConfig.fontSizeBase,
                    fontWeight: FontWeight.w500,
                    color: commonConfig.colorTextBase,
                  ),
                ),
              if (hasTitle && hasDescription)
                SizedBox(height: commonConfig.vSpacingXs),
              if (hasDescription)
                Text(
                  description!,
                  style: TextStyle(
                    fontSize: commonConfig.fontSizeCaption,
                    color: commonConfig.colorTextSecondary,
                    height: 1.5,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
