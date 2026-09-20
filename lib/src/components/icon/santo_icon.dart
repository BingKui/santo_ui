import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:santo_ui/src/constants/santo_strings_constants.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 图标资源根目录(相对包根)
const String _kIconRoot = 'assets/iconoir';

/// 图标:渲染项目内置的 Iconoir 开源图标库(MIT, https://iconoir.com)
///
/// 图标 SVG 全量存放在 `assets/iconoir/` 下,分两种风格:
/// - `regular/` 常规描边风格,1383 个,名称清单见 [SantoIcons]
/// - `solid/` 实心风格,288 个,名称清单见 [SantoSolidIcons]
///
/// 组件按**名称**取用,名称即 SVG 文件名(不带 `.svg`):
///
/// ```dart
/// SantoIcon('search', size: 16)                        // regular
/// SantoIcon(SantoIcons.search, size: 16)
/// SantoIcon(SantoSolidIcons.star, solid: true)         // solid
/// ```
///
/// 注意 solid 只是 regular 名称的**子集**(两者同名),所以 `SantoIcons` 里的名称
/// 不一定有 solid 版本;需要 solid 时请用 [SantoSolidIcons] 里的名称。
///
/// 两种风格都是单色,颜色统一由 [color] 决定(默认取主题正文色),
/// 无法保留多色;需要多色插画请继续使用图片资源。
///
/// @since v2.0.0
class SantoIcon extends StatelessWidget {
  /// 图标名称,取值见 [SantoIcons] 或 [SantoSolidIcons],即 SVG 文件名
  final String name;

  /// 是否使用实心(solid)风格,默认 false 即常规(regular)描边风格
  ///
  /// solid 仅 288 个图标,名称见 [SantoSolidIcons];传 [SantoIcons] 中不存在的
  /// solid 名称会取不到资源。
  ///
  /// @since v2.0.0
  final bool solid;

  /// 图标边长,默认取主题 `iconSizeMd`(16)
  final double? size;

  /// 图标颜色,默认取主题正文色
  final Color? color;

  /// 无障碍语义标签,为 null 时对读屏不可见
  final String? semanticLabel;

  const SantoIcon(
    this.name, {
    super.key,
    this.solid = false,
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
        '$_kIconRoot/${solid ? 'solid' : 'regular'}/$name.svg',
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
