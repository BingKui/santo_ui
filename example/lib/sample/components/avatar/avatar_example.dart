import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// 头像组件示例
class AvatarExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SantoAppBar(title: 'Avatar 示例'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SantoPanel(
              title: '图片头像',
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
            SantoPanel(
              title: '文字头像',
              child: Row(
                children: [
                  SantoAvatar(text: '张', size: 40),
                  SizedBox(width: 12),
                  SantoAvatar(text: '李', size: 40),
                  SizedBox(width: 12),
                  SantoAvatar(
                    text: '王',
                    size: 40,
                    backgroundColor: Color(0xFF0984F9),
                  ),
                ],
              ),
            ),
            SantoPanel(
              title: '图标头像',
              child: Row(
                children: [
                  SantoAvatar(icon: Icons.person, size: 40),
                  SizedBox(width: 12),
                  SantoAvatar(
                    icon: Icons.person,
                    size: 40,
                    backgroundColor: Color(0xFF00AE66),
                  ),
                ],
              ),
            ),
            SantoPanel(
              title: '不同形状',
              child: Row(
                children: [
                  SantoAvatar(text: '圆', size: 40),
                  SizedBox(width: 16),
                  SantoAvatar(
                    text: '方',
                    size: 40,
                    shape: SantoAvatarShape.round,
                    borderRadius: 8,
                  ),
                ],
              ),
            ),
            SantoPanel(
              title: '带边框',
              child: Row(
                children: [
                  SantoAvatar(
                    text: '边',
                    size: 40,
                    borderColor: Color(0xFF0984F9),
                  ),
                  SizedBox(width: 16),
                  SantoAvatar(
                    imageUrl: 'https://zos.alipayobjects.com/rmsportal/ODdgcjrvb81sCyJ.png',
                    size: 40,
                    borderColor: Color(0xFF00AE66),
                  ),
                ],
              ),
            ),
            SantoPanel(
              title: '头像组',
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
      ),
    );
  }
}
