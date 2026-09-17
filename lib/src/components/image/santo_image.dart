import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 增强图片组件
///
/// 支持圆角、占位图、加载失败态，支持网络图片和本地图片。
///
/// 使用示例：
/// ```dart
/// SantoImage(
///   imageUrl: 'https://example.com/image.png',
///   width: 200,
///   height: 200,
///   borderRadius: 12,
///   fit: BoxFit.cover,
/// )
/// ```
class SantoImage extends StatelessWidget {
  /// 图片地址（网络 URL 或本地资源路径）
  final String imageUrl;

  /// 图片宽度
  final double? width;

  /// 图片高度
  final double? height;

  /// 圆角半径，默认 0
  final double radius;

  /// 图片缩放模式
  final BoxFit fit;

  /// 加载中的占位组件
  final Widget? placeholder;

  /// 加载失败的组件
  final Widget? errorWidget;

  /// 是否为网络图片，默认为 true
  final bool isNetwork;

  const SantoImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.radius = 0,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.isNetwork = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: width,
        height: height,
        child: isNetwork ? _buildNetworkImage(commonConfig) : _buildAssetImage(commonConfig),
      ),
    );
  }

  /// 构建网络图片
  Widget _buildNetworkImage(dynamic commonConfig) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return placeholder ??
            Container(
              width: width,
              height: height,
              color: commonConfig.dividerColorBase.withAlpha(0x14),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  color: commonConfig.brandPrimary,
                ),
              ),
            );
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? _buildDefaultErrorWidget(commonConfig);
      },
    );
  }

  /// 构建本地图片
  Widget _buildAssetImage(dynamic commonConfig) {
    return Image.asset(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? _buildDefaultErrorWidget(commonConfig);
      },
    );
  }

  /// 默认加载失败组件
  Widget _buildDefaultErrorWidget(dynamic commonConfig) {
    return Container(
      width: width,
      height: height,
      color: commonConfig.dividerColorBase.withAlpha(0x14),
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: 32,
          color: commonConfig.colorTextHint,
        ),
      ),
    );
  }
}
