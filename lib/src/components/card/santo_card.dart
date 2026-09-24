import 'package:flutter/material.dart';
import 'package:santo_ui/src/components/card/santo_card_meta.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 卡片:把一组相关信息组织成一块,带标题、右上角操作与元信息插槽(对标 antd Card)
///
/// 内容分三段,自上而下:
/// - 头部:[title] / [titleWidget] 在左,[extra] 在右,下有一条分割线
/// - 元信息:[meta](头像 + 标题 + 描述),对应 antd Card.Meta
/// - 内容:[child]
///
/// 只传 [child] 时就是一块纯阴影容器,渲染结果与旧 `SantoShadowCard` 完全一致。
///
/// ```dart
/// SantoCard(
///   title: '卡片标题',
///   extra: SantoIcon(SantoIcons.moreHoriz),
///   meta: const SantoCardMeta(
///     avatar: SantoAvatar(...),
///     title: '标题',
///     description: '描述文案',
///   ),
///   child: const Text('内容'),
/// )
/// ```
///
/// @since v1.1.0
class SantoCard extends StatelessWidget {
  /// 标题文案
  final String? title;

  /// 自定义标题,优先级高于 [title]
  final Widget? titleWidget;

  /// 头部右上角操作区(对应 antd Card 的 extra)
  final Widget? extra;

  /// 元信息区(对应 antd Card.Meta)
  final SantoCardMeta? meta;

  /// 卡片内容
  final Widget child;

  /// 背景色,默认取主题 `fillBase`(白)
  final Color? color;

  /// 阴影颜色,默认取主题 `dividerColorBase`
  final Color? shadowColor;

  /// 阴影偏移量,默认 Offset.zero
  final Offset offset;

  /// 内容内边距,默认 EdgeInsets.zero
  ///
  /// 有标题或元信息且未显式传值时,内容会自动取主题 `hSpacingMd` / `vSpacingMd`
  final EdgeInsetsGeometry padding;

  /// 圆角,默认取主题 `radiusMd`
  final double? circular;

  /// 阴影模糊程度,默认 5
  final double blurRadius;

  /// 阴影扩散程度,默认 0
  final double spreadRadius;

  /// 边框宽度,默认取主题 `borderWidthSm`;传 0 去掉边框
  final double? borderWidth;

  const SantoCard({
    super.key,
    required this.child,
    this.title,
    this.titleWidget,
    this.extra,
    this.meta,
    this.color,
    this.shadowColor,
    this.padding = EdgeInsets.zero,
    this.circular,
    this.blurRadius = 5.0,
    this.spreadRadius = 0,
    this.offset = Offset.zero,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final double effectiveBorderWidth =
        borderWidth ?? commonConfig.borderWidthSm;
    final Widget? headerTitle = titleWidget ??
        (title == null
            ? null
            : Text(
                title!,
                style: TextStyle(
                  fontSize: commonConfig.fontSizeSubHead,
                  fontWeight: FontWeight.w500,
                  color: commonConfig.colorTextBase,
                ),
              ));
    final bool hasHeader = headerTitle != null || extra != null;
    final bool hasMeta = meta != null;

    // 有头部/元信息时给内容一份主题内边距,显式传过 padding 的调用方不受影响
    final EdgeInsetsGeometry bodyPadding =
        (hasHeader || hasMeta) && padding == EdgeInsets.zero
            ? EdgeInsets.symmetric(
                horizontal: commonConfig.hSpacingMd,
                vertical: commonConfig.vSpacingMd,
              )
            : padding;

    Widget body = child;
    if (hasMeta) {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          meta!,
          SizedBox(height: commonConfig.vSpacingMd),
          child,
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: color ?? commonConfig.fillBase,
        borderRadius: BorderRadius.all(
            Radius.circular(circular ?? commonConfig.radiusMd)),
        border: effectiveBorderWidth > 0
            ? Border.all(
                color: commonConfig.dividerColorBase,
                width: effectiveBorderWidth,
              )
            : Border.all(style: BorderStyle.none),
        boxShadow: [
          BoxShadow(
            color: shadowColor ?? commonConfig.dividerColorBase,
            offset: offset,
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasHeader) ...[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: commonConfig.hSpacingMd,
                vertical: commonConfig.vSpacingMd,
              ),
              child: Row(
                children: [
                  Expanded(child: headerTitle ?? const SizedBox.shrink()),
                  ?extra,
                ],
              ),
            ),
            Container(
              height: commonConfig.borderWidthSm,
              color: commonConfig.dividerColorBase,
            ),
          ],
          Padding(padding: bodyPadding, child: body),
        ],
      ),
    );
  }
}
