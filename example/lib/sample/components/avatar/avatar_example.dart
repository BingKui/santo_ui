import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// 头像组件示例
class AvatarExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(      title: 'Avatar 示例',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SantoSection(
            title: '图片头像',
            description: 'imageUrl 加载图片，size 分别取 48、64、80',
            child: Row(
              children: [
                SantoAvatar(
                  imageUrl: 'https://zos.alipayobjects.com/rmsportal/ODdgcjrvb81sCyJ.png',
                  size: 48,
                ),
                SizedBox(width: 16),
                SantoAvatar(
                  imageUrl: 'https://zos.alipayobjects.com/rmsportal/ODdgcjrvb81sCyJ.png',
                  size: 64,
                ),
                SizedBox(width: 16),
                SantoAvatar(
                  imageUrl: 'https://zos.alipayobjects.com/rmsportal/ODdgcjrvb81sCyJ.png',
                  size: 80,
                ),
              ],
            ),
          ),
          SantoSection(
            title: '文字头像',
            description: 'text 展示文字头像，backgroundColor 自定义底色',
            child: Row(
              children: [
                SantoAvatar(text: '张', size: 40),
                SizedBox(width: 12),
                SantoAvatar(text: '李', size: 40),
                SizedBox(width: 12),
                SantoAvatar(
                  text: '王',
                  size: 40,
                  backgroundColor: Color(0xFF1677FF),
                ),
              ],
            ),
          ),
          SantoSection(
            title: '图标头像',
            description: 'icon 传入图标作为头像内容',
            child: Row(
              children: [
                SantoAvatar(icon: Icons.person, size: 40),
                SizedBox(width: 12),
                SantoAvatar(
                  icon: Icons.person,
                  size: 40,
                  backgroundColor: Color(0xFF52C41A),
                ),
              ],
            ),
          ),
          SantoSection(
            title: '不同形状',
            description: 'shape 切换圆形或圆角方形，radius 调圆角',
            child: Row(
              children: [
                SantoAvatar(text: '圆', size: 40),
                SizedBox(width: 16),
                SantoAvatar(
                  text: '方',
                  size: 40,
                  shape: SantoAvatarShape.round,
                  radius: 8,
                ),
              ],
            ),
          ),
          SantoSection(
            title: '带边框',
            description: 'borderColor 为文字或图片头像添加描边',
            child: Row(
              children: [
                SantoAvatar(
                  text: '边',
                  size: 40,
                  borderColor: Color(0xFF1677FF),
                ),
                SizedBox(width: 16),
                SantoAvatar(
                  imageUrl: 'https://zos.alipayobjects.com/rmsportal/ODdgcjrvb81sCyJ.png',
                  size: 40,
                  borderColor: Color(0xFF52C41A),
                ),
              ],
            ),
          ),
          SantoSection(
            title: '头像组',
            description: 'SantoAvatarGroup 配合 maxCount 折叠多余头像',
            child: SantoAvatarGroup(
              avatars: [
                SantoAvatar(
                  imageUrl: 'https://zos.alipayobjects.com/rmsportal/ODdgcjrvb81sCyJ.png',
                  size: 36,
                ),
                SantoAvatar(text: '张', size: 36),
                SantoAvatar(text: '李', size: 36),
                SantoAvatar(text: '王', size: 36),
              ],
              maxCount: 3,
            ),
          ),
        ],
      ),
    );
  }
}
