import 'package:santo_ui/src/components/chat/model/santo_chat_menu_item.dart';
import 'package:santo_ui/src/components/icon/santo_icon.dart';
import 'package:santo_ui/src/components/icon/santo_icons.dart';
import 'package:santo_ui/src/theme/configs/santo_chat_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 多选操作项的图标边长
const double kSantoChatSelectionActionIconSize = 22;

/// 多选操作栏的默认操作项:转发、删除
const List<SantoChatMenuItem> kSantoChatDefaultSelectionActions =
    <SantoChatMenuItem>[
  SantoChatMenuItem.forward,
  SantoChatMenuItem.delete,
];

/// 会话多选态底部操作栏
///
/// 展示已选条数,右侧是按项配置的操作(默认转发、删除),由 [SantoChat] 在
/// 多选态替换输入区,也可以单独使用。
///
/// @since v1.5.0
class SantoChatSelectionBar extends StatelessWidget {
  /// 已选条数
  final int selectedCount;

  /// 操作项,未选中任何消息时置灰
  final List<SantoChatMenuItem> actions;

  /// 退出多选
  final VoidCallback? onCancel;

  /// 点击操作项回调
  final ValueChanged<SantoChatMenuItem>? onAction;

  const SantoChatSelectionBar({
    Key? key,
    required this.selectedCount,
    this.actions = kSantoChatDefaultSelectionActions,
    this.onCancel,
    this.onAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SantoChatConfig config =
        SantoThemeConfigurator.instance.getConfig().chatConfig;
    final bool enabled = selectedCount > 0;

    return Container(
      color: config.inputBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: config.commonConfig.borderWidthSm,
            color: config.commonConfig.dividerColorBase,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: config.commonConfig.hSpacingMd,
              vertical: config.commonConfig.vSpacingSm,
            ),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onCancel,
                  child: SantoIcon(
                    SantoIcons.xmark,
                    size: config.commonConfig.iconSizeMd,
                    color: config.commonConfig.colorTextSecondary,
                  ),
                ),
                SizedBox(width: config.commonConfig.hSpacingSm),
                Text(
                  '已选 $selectedCount 条',
                  style: config.otherTextStyle.generateTextStyle(),
                ),
                const Spacer(),
                for (final SantoChatMenuItem action in actions)
                  Padding(
                    padding: EdgeInsets.only(
                      left: config.commonConfig.hSpacingMd,
                    ),
                    child: _buildAction(config, action, enabled),
                  ),
              ],
            ),
          ),
          // 底部安全区固定预留,不可配置
          SizedBox(height: MediaQuery.paddingOf(context).bottom),
        ],
      ),
    );
  }

  Widget _buildAction(
    SantoChatConfig config,
    SantoChatMenuItem action,
    bool enabled,
  ) {
    final Color color = !enabled
        ? config.commonConfig.colorTextDisabled
        : action.danger
            ? config.commonConfig.brandError
            : config.commonConfig.colorTextBase;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: !enabled || onAction == null ? null : () => onAction!(action),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (action.icon != null) ...<Widget>[
            SantoIcon(
              action.icon!,
              size: kSantoChatSelectionActionIconSize,
              color: color,
            ),
            SizedBox(width: config.commonConfig.hSpacingXs),
          ],
          Text(
            action.label,
            style: config.otherTextStyle.generateTextStyle().copyWith(
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}
