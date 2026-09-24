import 'package:santo_ui/src/components/button/santo_button.dart';
import 'package:santo_ui/src/components/chat/model/santo_chat_message.dart';
import 'package:santo_ui/src/components/tag/santo_tag.dart';
import 'package:santo_ui/src/theme/configs/santo_chat_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 审批卡片展示宽度
const double kSantoChatApprovalWidth = 258;

/// 审批卡片里元信息(审批流/申请人/当前节点)的标签列宽
const double kSantoChatApprovalLabelWidth = 56;

/// 审批单状态文案
const Map<SantoChatApprovalStatus, String> kSantoChatApprovalStatusText =
    <SantoChatApprovalStatus, String>{
  SantoChatApprovalStatus.pending: '审批中',
  SantoChatApprovalStatus.approved: '已通过',
  SantoChatApprovalStatus.rejected: '已驳回',
  SantoChatApprovalStatus.cancelled: '已取消',
};

/// 审批单状态对应的标签状态
SantoTagState santoChatApprovalTagState(SantoChatApprovalStatus status) {
  switch (status) {
    case SantoChatApprovalStatus.approved:
      return SantoTagState.succeed;
    case SantoChatApprovalStatus.rejected:
      return SantoTagState.failed;
    case SantoChatApprovalStatus.pending:
      return SantoTagState.running;
    case SantoChatApprovalStatus.cancelled:
      return SantoTagState.invalidate;
  }
}

/// 会话审批消息:一张审批卡片(单号 + 状态标签 + 标题 + 审批流信息 + 通过/驳回)
///
/// 卡片自带白底与描边,不套气泡。待审批且 [SantoChatApprovalMessage.canApprove]
/// 为 true 时才展示操作按钮,点击后回调 [onApprove] / [onReject],
/// 具体审批请求由业务方发起。
///
/// @since v1.5.1
class SantoChatApprovalCard extends StatelessWidget {
  /// 审批消息
  final SantoChatApprovalMessage message;

  /// 点击卡片(打开审批详情)
  final ValueChanged<SantoChatApprovalMessage>? onTap;

  /// 点击「通过」
  final ValueChanged<SantoChatApprovalMessage>? onApprove;

  /// 点击「驳回」
  final ValueChanged<SantoChatApprovalMessage>? onReject;

  const SantoChatApprovalCard({
    Key? key,
    required this.message,
    this.onTap,
    this.onApprove,
    this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SantoChatConfig config =
        SantoThemeConfigurator.instance.getConfig().chatConfig;
    final bool showActions = message.approvalStatus ==
            SantoChatApprovalStatus.pending &&
        message.canApprove;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap == null ? null : () => onTap!(message),
      child: Container(
        constraints: const BoxConstraints(maxWidth: kSantoChatApprovalWidth),
        padding: EdgeInsets.symmetric(
          horizontal: config.commonConfig.hSpacingSm,
          vertical: config.commonConfig.vSpacingSm,
        ),
        decoration: BoxDecoration(
          color: config.otherBubbleColor,
          border: Border.all(
            color: config.commonConfig.dividerColorBase,
            width: config.commonConfig.borderWidthSm,
          ),
          borderRadius: BorderRadius.circular(config.commonConfig.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                if (message.taskNo != null && message.taskNo!.isNotEmpty)
                  Expanded(
                    child: Text(
                      message.taskNo!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: config.commonConfig.colorTextSecondary,
                        fontSize: config.commonConfig.fontSizeCaptionSm,
                        fontFamily: 'monospace',
                      ),
                    ),
                  )
                else
                  const Spacer(),
                SantoTag(
                  text: kSantoChatApprovalStatusText[message.approvalStatus],
                  state: santoChatApprovalTagState(message.approvalStatus),
                ),
              ],
            ),
            SizedBox(height: config.commonConfig.vSpacingSm),
            Text(
              message.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: config.otherTextStyle
                  .generateTextStyle()
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            if (message.flowName != null && message.flowName!.isNotEmpty) ...[
              SizedBox(height: config.commonConfig.vSpacingSm),
              _buildMetaRow(config, '审批流', message.flowName!),
            ],
            if (message.applicatorName != null &&
                message.applicatorName!.isNotEmpty) ...[
              SizedBox(height: config.commonConfig.vSpacingSm),
              _buildMetaRow(config, '申请人', message.applicatorName!),
            ],
            if (message.currentNodeName != null &&
                message.currentNodeName!.isNotEmpty) ...[
              SizedBox(height: config.commonConfig.vSpacingSm),
              _buildMetaRow(config, '当前节点', message.currentNodeName!),
            ],
            if (showActions) ...[
              SizedBox(height: config.commonConfig.vSpacingSm),
              Row(
                children: <Widget>[
                  Expanded(
                    child: SantoButton(
                      text: '通过',
                      type: SantoButtonType.primary,
                      size: SantoButtonSize.middle,
                      fontSize: config.commonConfig.fontSizeCaption,
                      autoInsertSpace: false,
                      isEnable: onApprove != null,
                      onTap: onApprove == null
                          ? null
                          : () => onApprove!(message),
                      block: true,
                    ),
                  ),
                  SizedBox(width: config.commonConfig.hSpacingSm),
                  Expanded(
                    child: SantoButton(
                      text: '驳回',
                      type: SantoButtonType.primary,
                      danger: true,
                      size: SantoButtonSize.middle,
                      fontSize: config.commonConfig.fontSizeCaption,
                      autoInsertSpace: false,
                      isEnable: onReject != null,
                      onTap:
                          onReject == null ? null : () => onReject!(message),
                      block: true,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetaRow(SantoChatConfig config, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: kSantoChatApprovalLabelWidth,
          child: Text(
            label,
            style: TextStyle(
              color: config.commonConfig.colorTextSecondary,
              fontSize: config.commonConfig.fontSizeCaptionSm,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: config.commonConfig.colorTextBase,
              fontSize: config.commonConfig.fontSizeCaptionSm,
            ),
          ),
        ),
      ],
    );
  }
}
