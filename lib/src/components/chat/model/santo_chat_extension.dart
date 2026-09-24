import 'package:santo_ui/src/components/icon/santo_icons.dart';
import 'package:flutter/foundation.dart';

/// 输入区扩展菜单里的一项(如照片、拍摄、文件)
///
/// [key] 是业务标识,点选后通过 `onExtensionTap` 回调出去,由业务方拉起
/// 相册、相机或文件选择器。
///
/// @since v1.5.0
@immutable
class SantoChatExtension {
  /// 业务标识
  final String key;

  /// 展示文案
  final String label;

  /// 图标名称,取值见 [SantoIcons]
  final String icon;

  const SantoChatExtension({
    required this.key,
    required this.label,
    required this.icon,
  });

  /// 默认扩展项:照片、拍摄、文件
  static const SantoChatExtension photo = SantoChatExtension(
    key: 'photo',
    label: '照片',
    icon: SantoIcons.mediaImage,
  );

  /// 拍摄
  static const SantoChatExtension camera = SantoChatExtension(
    key: 'camera',
    label: '拍摄',
    icon: SantoIcons.camera,
  );

  /// 文件
  static const SantoChatExtension file = SantoChatExtension(
    key: 'file',
    label: '文件',
    icon: SantoIcons.page,
  );

  /// 默认扩展项列表
  static const List<SantoChatExtension> defaults = <SantoChatExtension>[
    photo,
    camera,
    file,
  ];
}
