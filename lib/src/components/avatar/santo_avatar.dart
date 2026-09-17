import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 头像形状枚举
enum SantoAvatarShape {
  /// 圆形
  circle,

  /// 圆角方形
  round,
}

/// 头像组件
///
/// 支持三种模式：
/// - 图片模式：通过 [imageUrl] 显示网络图片
/// - 文字模式：通过 [text] 显示文字（通常为用户名首字）
/// - 图标模式：通过 [icon] 显示图标
///
/// 支持圆形和圆角方形两种形状
///
/// 示例：
/// ```dart
/// SantoAvatar(imageUrl: 'https://example.com/avatar.jpg')
/// SantoAvatar(text: '张', size: 48)
/// SantoAvatar(icon: Icons.person, shape: SantoAvatarShape.round)
/// ```
///
class SantoAvatar extends StatelessWidget {
  /// 图片地址
  final String? imageUrl;

  /// 显示的文字
  final String? text;

  /// 显示的图标
  final IconData? icon;

  /// 头像尺寸（宽高），默认 40
  final double size;

  /// 头像形状，默认圆形
  final SantoAvatarShape shape;

  /// 背景颜色
  final Color? backgroundColor;

  /// 边框颜色
  final Color? borderColor;

  /// 圆角大小，仅在 [shape] 为 [SantoAvatarShape.round] 时生效，默认 4
  final double radius;

  /// 文字样式
  final TextStyle? textStyle;

  /// 图标颜色
  final Color? iconColor;

  /// 头像组件构造函数
  const SantoAvatar({
    Key? key,
    this.imageUrl,
    this.text,
    this.icon,
    this.size = 40,
    this.shape = SantoAvatarShape.circle,
    this.backgroundColor,
    this.borderColor,
    this.radius = 12,
    this.textStyle,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ??
        SantoThemeConfigurator.instance
            .getConfig()
            .commonConfig
            .colorTextSecondary;
    final ShapeBorder shapeBorder = shape == SantoAvatarShape.circle
        ? CircleBorder(side: BorderSide(color: borderColor ?? Colors.transparent))
        : RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: BorderSide(color: borderColor ?? Colors.transparent),
          );

    Widget content;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      content = ClipPath(
        clipper: shape == SantoAvatarShape.circle
            ? _CircleClipper()
            : _RoundRectClipper(radius),
        child: Image.network(
          imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildFallback(bgColor),
        ),
      );
    } else if (text != null) {
      content = _buildFallback(bgColor, child: Text(
        text!,
        style: textStyle ??
            TextStyle(
              color: SantoThemeConfigurator.instance
                  .getConfig()
                  .commonConfig
                  .colorTextBaseInverse,
              fontSize: size * 0.4,
              fontWeight: FontWeight.w500,
            ),
      ));
    } else if (icon != null) {
      content = _buildFallback(bgColor, child: Icon(
        icon,
        size: size * 0.5,
        color: iconColor ??
            SantoThemeConfigurator.instance
                .getConfig()
                .commonConfig
                .colorTextBaseInverse,
      ));
    } else {
      content = _buildFallback(bgColor);
    }

    return SizedBox(
      width: size,
      height: size,
      child: content,
    );
  }

  /// 构建带背景色的容器
  Widget _buildFallback(Color bgColor, {Widget? child}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: shape == SantoAvatarShape.circle
            ? BoxShape.circle
            : BoxShape.rectangle,
        borderRadius: shape == SantoAvatarShape.round
            ? BorderRadius.circular(radius)
            : null,
        border: borderColor != null
            ? Border.all(color: borderColor!)
            : null,
      ),
      alignment: Alignment.center,
      child: child ??
          Icon(
            Icons.person,
            size: size * 0.5,
            color: SantoThemeConfigurator.instance
                .getConfig()
                .commonConfig
                .colorTextBaseInverse,
          ),
    );
  }
}

/// 圆形裁剪器
class _CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()..addOval(Rect.fromLTWH(0, 0, size.width, size.height));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// 圆角矩形裁剪器
class _RoundRectClipper extends CustomClipper<Path> {
  final double radius;

  _RoundRectClipper(this.radius);

  @override
  Path getClip(Size size) {
    return Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// 头像组组件
///
/// 将多个头像以重叠方式水平排列展示，常用于显示参与者、协作者等场景
///
/// 示例：
/// ```dart
/// SantoAvatarGroup(
///   avatars: [
///     SantoAvatar(text: '张'),
///     SantoAvatar(text: '李'),
///     SantoAvatar(text: '王'),
///   ],
/// )
/// ```
///
class SantoAvatarGroup extends StatelessWidget {
  /// 头像列表
  final List<SantoAvatar> avatars;

  /// 头像之间的重叠距离，默认 10
  final double overlap;

  /// 头像尺寸，默认 36
  final double size;

  /// 最大显示数量，超出部分显示 "+N"
  final int? maxCount;

  /// 头像组构造函数
  const SantoAvatarGroup({
    Key? key,
    required this.avatars,
    this.overlap = 10,
    this.size = 36,
    this.maxCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    final int displayCount =
        maxCount != null && avatars.length > maxCount! ? maxCount! : avatars.length;

    for (int i = 0; i < displayCount; i++) {
      children.add(
        Positioned(
          left: i * (size - overlap),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: SantoAvatar(
              imageUrl: avatars[i].imageUrl,
              text: avatars[i].text,
              icon: avatars[i].icon,
              size: size,
              shape: avatars[i].shape,
              backgroundColor: avatars[i].backgroundColor,
            ),
          ),
        ),
      );
    }

    // 超出部分显示 "+N"
    if (maxCount != null && avatars.length > maxCount!) {
      final int remaining = avatars.length - maxCount!;
      children.add(
        Positioned(
          left: displayCount * (size - overlap),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: SantoThemeConfigurator.instance
                  .getConfig()
                  .commonConfig
                  .colorTextSecondary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            alignment: Alignment.center,
            child: Text(
              '+$remaining',
              style: TextStyle(
                color: SantoThemeConfigurator.instance
                    .getConfig()
                    .commonConfig
                    .colorTextBaseInverse,
                fontSize: size * 0.35,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }

    final double totalWidth =
        displayCount * (size - overlap) + overlap +
        (maxCount != null && avatars.length > maxCount! ? size - overlap : 0);

    return SizedBox(
      width: totalWidth,
      height: size + 4, // 额外空间给边框
      child: Stack(children: children),
    );
  }
}
