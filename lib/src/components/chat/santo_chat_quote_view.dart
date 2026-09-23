import 'package:santo_ui/src/components/chat/model/santo_chat_message.dart';
import 'package:santo_ui/src/components/image/santo_image.dart';
import 'package:santo_ui/src/theme/configs/santo_chat_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 会话引用块:展示被回复消息的来源与摘要
///
/// 我方与对方的引用块样式一致,由 [SantoChatBubble] 渲染在气泡内首行,
/// 也可单独使用。
///
/// @since v1.5.0
class SantoChatQuoteView extends StatelessWidget {
  /// 引用信息
  final SantoChatQuote quote;

  /// 点击引用块回调,可用于跳转到原消息
  final VoidCallback? onTap;

  const SantoChatQuoteView({
    Key? key,
    required this.quote,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SantoChatConfig config =
        SantoThemeConfigurator.instance.getConfig().chatConfig;

    final Widget body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          quote.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: config.quoteTitleTextStyle.generateTextStyle(),
        ),
        if (quote.preview.isNotEmpty) ...<Widget>[
          SizedBox(height: config.commonConfig.vSpacingXs / 2),
          Text(
            quote.preview,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: config.quotePreviewTextStyle.generateTextStyle(),
          ),
        ],
      ],
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: config.commonConfig.hSpacingSm,
          vertical: config.commonConfig.vSpacingXs,
        ),
        decoration: BoxDecoration(
          color: config.quoteBackgroundColor,
          borderRadius: BorderRadius.circular(config.commonConfig.radiusXs),
          border: Border(
            left: BorderSide(
              color: config.commonConfig.brandPrimary,
              width: config.commonConfig.borderWidthLg,
            ),
          ),
        ),
        child: quote.thumbnailUrl == null
            ? body
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SantoImage(
                    imageUrl: quote.thumbnailUrl!,
                    isNetwork: quote.thumbnailUrl!.startsWith('http'),
                    width: config.avatarSize / 2,
                    height: config.avatarSize / 2,
                    radius: config.commonConfig.radiusXs,
                  ),
                  SizedBox(width: config.commonConfig.hSpacingSm),
                  Flexible(child: body),
                ],
              ),
      ),
    );
  }
}
