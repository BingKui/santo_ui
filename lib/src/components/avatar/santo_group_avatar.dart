import 'package:flutter/material.dart';

import 'package:santo_ui/src/components/avatar/santo_avatar.dart';
import 'package:santo_ui/src/components/icon/santo_icon.dart';
import 'package:santo_ui/src/components/icon/santo_icons.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 群头像外框默认边长
const double kSantoGroupAvatarSize = 40;

/// 群头像默认最多展示的成员数
const int kSantoGroupAvatarMaxCount = 9;

/// 群头像九宫格默认内边距
const double kSantoGroupAvatarPadding = 2;

/// 群头像单元格默认间距
const double kSantoGroupAvatarGap = 1;

/// 群头像里的单个成员头像单元格
///
/// [imageUrl] 为空或加载失败时，用 [text] 兜底展示首字。
///
/// @since v2.2.2
@immutable
class SantoGroupAvatarItem {
  /// 头像地址，支持 http(s) / Data URI / 纯 base64
  final String? imageUrl;

  /// 兜底展示的文字，一般为昵称首字
  final String? text;

  const SantoGroupAvatarItem({this.imageUrl, this.text});
}

/// 群头像：平铺成员头像的九宫格（微信群头像同款）
///
/// 与「头像重叠堆叠」的 [SantoAvatarGroup] 是两个组件：本组件是**网格平铺**，
/// 专用于群聊会话头像。规则与 DevOps 桌面端一致：
/// - [items] 为空：回退为圆角方形 + 群图标（[fallbackIcon]）
/// - 只有 1 个成员：整格展示该成员头像
/// - 2~4 个成员 2 列，5~9 个成员 3 列；超过 [maxCount] 只取前 [maxCount] 个
///
/// ```dart
/// SantoGroupAvatar(
///   items: <SantoGroupAvatarItem>[
///     SantoGroupAvatarItem(imageUrl: 'https://example.com/a.png', text: '张'),
///     SantoGroupAvatarItem(imageUrl: 'https://example.com/b.png', text: '李'),
///   ],
///   size: 48,
/// )
/// ```
///
/// @since v2.2.2
class SantoGroupAvatar extends StatelessWidget {
  /// 成员头像单元格，按会话成员顺序传入
  final List<SantoGroupAvatarItem> items;

  /// 外框边长
  final double size;

  /// 最多展示的成员数
  final int maxCount;

  /// 九宫格四周内边距
  final double padding;

  /// 单元格之间的间距
  final double gap;

  /// 圆角，不传取主题 `radiusSm`；单元格按自身尺寸等比缩放
  final double? radius;

  /// 没有成员时的兜底图标名，取值见 [SantoIcons]
  final String fallbackIcon;

  const SantoGroupAvatar({
    Key? key,
    required this.items,
    this.size = kSantoGroupAvatarSize,
    this.maxCount = kSantoGroupAvatarMaxCount,
    this.padding = kSantoGroupAvatarPadding,
    this.gap = kSantoGroupAvatarGap,
    this.radius,
    this.fallbackIcon = SantoIcons.group,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final double cornerRadius = radius ?? commonConfig.radiusSm;

    // 成员数据未就绪：回退为圆角方形 + 群图标
    if (items.isEmpty) {
      return Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: commonConfig.fillBody,
          borderRadius: BorderRadius.circular(cornerRadius),
        ),
        child: SantoIcon(
          fallbackIcon,
          size: size / 2,
          color: commonConfig.colorTextSecondary,
        ),
      );
    }

    // 只有 1 个成员：整格展示，不再套九宫格外框
    if (items.length == 1) {
      final SantoGroupAvatarItem only = items.first;
      return SantoAvatar(
        imageUrl: only.imageUrl,
        text: only.text,
        size: size,
        shape: SantoAvatarShape.round,
        radius: cornerRadius,
      );
    }

    final List<SantoGroupAvatarItem> visible =
        items.length > maxCount ? items.sublist(0, maxCount) : items;
    // 2~4 个成员 2 列，5~9 个成员 3 列
    final int columns = visible.length <= 4 ? 2 : 3;
    final double cell =
        ((size - padding * 2 - gap * (columns - 1)) / columns).floorToDouble();
    // 单元格圆角随尺寸等比缩放，小格不会被圆角糊成圆形
    final double cellRadius = cornerRadius * cell / size;

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: commonConfig.fillBody,
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
      child: Center(
        child: Wrap(
          spacing: gap,
          runSpacing: gap,
          children: <Widget>[
            for (final SantoGroupAvatarItem item in visible)
              SantoAvatar(
                imageUrl: item.imageUrl,
                text: item.text,
                size: cell,
                shape: SantoAvatarShape.round,
                radius: cellRadius,
              ),
          ],
        ),
      ),
    );
  }
}
