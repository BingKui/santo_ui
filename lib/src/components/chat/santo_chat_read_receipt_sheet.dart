import 'package:santo_ui/src/components/avatar/santo_avatar.dart';
import 'package:santo_ui/src/components/chat/model/santo_chat_message.dart';
import 'package:santo_ui/src/components/empty/santo_empty.dart';
import 'package:santo_ui/src/components/icon/santo_icon.dart';
import 'package:santo_ui/src/components/icon/santo_icons.dart';
import 'package:santo_ui/src/theme/configs/santo_chat_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 已读回执面板的最大高度占屏幕比例
const double kSantoChatReceiptSheetMaxHeightRatio = 0.6;

/// 已读回执面板里人员头像的边长
const double kSantoChatReceiptAvatarSize = 32;

/// 已读回执面板:按已读/未读分组列出人员
///
/// 一般不用直接构造,点我方消息气泡下方的「已读/未读」后调 [show] 即可;
/// 人员列表由服务端下发,`SantoChatReadReceipt.readMembers` /
/// `unreadMembers` 为空时只展示人数。
///
/// @since v1.5.1
class SantoChatReadReceiptSheet extends StatelessWidget {
  /// 已读回执
  final SantoChatReadReceipt receipt;

  /// 面板标题
  final String title;

  const SantoChatReadReceiptSheet({
    Key? key,
    required this.receipt,
    this.title = '消息已读',
  }) : super(key: key);

  /// 弹出面板
  static Future<void> show({
    required BuildContext context,
    required SantoChatReadReceipt receipt,
    String title = '消息已读',
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) =>
          SantoChatReadReceiptSheet(receipt: receipt, title: title),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SantoChatConfig config =
        SantoThemeConfigurator.instance.getConfig().chatConfig;
    final List<SantoChatAuthor> read = receipt.readMembers ?? const <SantoChatAuthor>[];
    final List<SantoChatAuthor> unread =
        receipt.unreadMembers ?? const <SantoChatAuthor>[];
    final bool empty = read.isEmpty && unread.isEmpty;

    return Container(
      // 白底铺到屏幕底部,内容再避开安全区
      decoration: BoxDecoration(
        color: config.otherBubbleColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(config.commonConfig.radiusLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: config.commonConfig.hSpacingMd,
              vertical: config.commonConfig.vSpacingMd,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: config.commonConfig.fontSizeSubHead,
                      fontWeight: FontWeight.w600,
                      color: config.commonConfig.colorTextBase,
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(context).pop(),
                  child: SantoIcon(
                    SantoIcons.xmark,
                    size: config.commonConfig.iconSizeMd,
                    color: config.commonConfig.colorTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: config.commonConfig.borderWidthSm,
            color: config.commonConfig.dividerColorBase,
          ),
          if (empty)
            SantoEmpty(
              imageType: SantoEmptyImageType.listEmpty,
              content: '暂无人员信息',
              height: 180,
            )
          else
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height *
                    kSantoChatReceiptSheetMaxHeightRatio,
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  vertical: config.commonConfig.vSpacingSm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (receipt.readCount > 0 || read.isNotEmpty)
                      _buildGroup(
                        config,
                        '已读',
                        receipt.readCount,
                        read,
                      ),
                    if (receipt.unreadCount > 0 || unread.isNotEmpty)
                      _buildGroup(
                        config,
                        '未读',
                        receipt.unreadCount,
                        unread,
                      ),
                  ],
                ),
              ),
            ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom),
        ],
      ),
    );
  }

  Widget _buildGroup(
    SantoChatConfig config,
    String label,
    int count,
    List<SantoChatAuthor> members,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        left: config.commonConfig.hSpacingMd,
        right: config.commonConfig.hSpacingMd,
        bottom: config.commonConfig.vSpacingSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '$label $count',
            style: TextStyle(
              fontSize: config.commonConfig.fontSizeCaption,
              fontWeight: FontWeight.w500,
              color: config.commonConfig.colorTextSecondary,
            ),
          ),
          for (final SantoChatAuthor member in members)
            Padding(
              padding: EdgeInsets.only(top: config.commonConfig.vSpacingSm),
              child: Row(
                children: <Widget>[
                  SantoAvatar(
                    imageUrl: member.avatarUrl,
                    text: member.name.isEmpty ? null : member.name.substring(0, 1),
                    size: kSantoChatReceiptAvatarSize,
                  ),
                  SizedBox(width: config.commonConfig.hSpacingSm),
                  Expanded(
                    child: Text(
                      member.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: config.commonConfig.fontSizeBase,
                        color: config.commonConfig.colorTextBase,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
