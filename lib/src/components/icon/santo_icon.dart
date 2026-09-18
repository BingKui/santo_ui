import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:santo_ui/src/constants/santo_strings_constants.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 图标目录(相对包根)
const String _kIconDir = 'assets/icons/iconoir';

/// 图标:渲染项目内置的 Iconoir 开源图标库(MIT, https://iconoir.com)
///
/// 图标 SVG 全量存放在 `assets/icons/iconoir/`,共 1383 个常规图标,
/// 组件按**名称**取用,名称即 SVG 文件名(不带 `.svg`):
///
/// ```dart
/// SantoIcon('search', size: 16)
/// ```
///
/// 名称清单见 [SantoIcons],用常量代替字符串可获得补全与拼写检查:
///
/// ```dart
/// SantoIcon(SantoIcons.search, size: 16)
/// ```
///
/// 图标为单色描边风格,颜色统一由 [color] 决定(默认取主题正文色),
/// 无法保留多色;需要多色插画请继续使用图片资源。
///
/// @since v2.0.0
class SantoIcon extends StatelessWidget {
  /// 图标名称,取值见 [SantoIcons],即 `assets/icons/iconoir/<名称>.svg` 的文件名
  final String name;

  /// 图标边长,默认取主题 `iconSizeMd`(16)
  final double? size;

  /// 图标颜色,默认取主题正文色
  final Color? color;

  /// 无障碍语义标签,为 null 时图标对读屏不可见
  final String? semanticLabel;

  const SantoIcon(
    this.name, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final double dimension = size ?? commonConfig.iconSizeMd;
    final Color resolvedColor = color ?? commonConfig.colorTextBase;

    Widget result = SizedBox.square(
      dimension: dimension,
      child: SvgPicture.asset(
        '$_kIconDir/$name.svg',
        package: SantoStrings.flutterPackageName,
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(resolvedColor, BlendMode.srcIn),
      ),
    );

    if (semanticLabel != null) {
      result = Semantics(label: semanticLabel, image: true, child: result);
    }
    return result;
  }
}
