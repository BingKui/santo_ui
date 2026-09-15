import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// Image 增强图片示例
class ImageExample extends StatelessWidget {
  static const String _netImg =
      'https://zos.alipayobjects.com/rmsportal/ODdgcjrvb81sCyJ.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(title: 'Image 示例'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SantoPanel(
              title: '基础网络图片',
              child: Row(
                children: [
                  SantoImage(imageUrl: _netImg, width: 96, height: 96),
                  SizedBox(width: 16),
                  SantoImage(imageUrl: _netImg, width: 140, height: 90),
                ],
              ),
            ),
            SantoPanel(
              title: '圆角图片',
              child: Row(
                children: [
                  SantoImage(
                    imageUrl: _netImg,
                    width: 96,
                    height: 96,
                    borderRadius: 12,
                  ),
                  SizedBox(width: 16),
                  SantoImage(
                    imageUrl: _netImg,
                    width: 96,
                    height: 96,
                    borderRadius: 48,
                  ),
                ],
              ),
            ),
            SantoPanel(
              title: '不同 BoxFit',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SantoImage(
                        imageUrl: _netImg,
                        width: 90,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 12),
                      SantoImage(
                        imageUrl: _netImg,
                        width: 90,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 12),
                      SantoImage(
                        imageUrl: _netImg,
                        width: 90,
                        height: 120,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('依次为 cover / contain / fill',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            SantoPanel(
              title: '加载失败态（默认）',
              child: SantoImage(
                imageUrl: 'https://invalid.example.com/not_exist.png',
                width: 96,
                height: 96,
                borderRadius: 12,
              ),
            ),
            SantoPanel(
              title: '自定义失败态',
              child: SantoImage(
                imageUrl: 'https://invalid.example.com/not_exist.png',
                width: 96,
                height: 96,
                borderRadius: 12,
                errorWidget: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image, color: Colors.grey),
                      SizedBox(height: 4),
                      Text('加载失败',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),
            SantoPanel(
              title: '本地图片',
              child: SantoImage(
                imageUrl: 'assets/image/empty_state.png',
                width: 160,
                height: 120,
                isNetwork: false,
                borderRadius: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
