import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// Image 增强图片示例
class ImageExample extends StatelessWidget {
  static const String _netImg =
      'https://zos.alipayobjects.com/rmsportal/ODdgcjrvb81sCyJ.png';

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SantoSection(
            title: '基础网络图片',
            description: '通过 imageUrl 加载网络图片，width、height 控制展示尺寸',
            child: Row(
              children: [
                SantoImage(imageUrl: _netImg, width: 96, height: 96),
                SizedBox(width: 16),
                SantoImage(imageUrl: _netImg, width: 140, height: 90),
              ],
            ),
          ),
          SantoSection(
            title: '圆角图片',
            description: 'radius 传入半径值控制圆角，传入边长一半时呈圆形',
            child: Row(
              children: [
                SantoImage(
                  imageUrl: _netImg,
                  width: 96,
                  height: 96,
                  radius: 12,
                ),
                SizedBox(width: 16),
                SantoImage(
                  imageUrl: _netImg,
                  width: 96,
                  height: 96,
                  radius: 48,
                ),
              ],
            ),
          ),
          SantoSection(
            title: '不同 BoxFit',
            description: '固定宽高下对比 cover、contain、fill 三种缩放模式',
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
          SantoSection(
            title: '加载失败态（默认）',
            description: 'imageUrl 不可用时触发默认失败态，展示破图占位',
            child: SantoImage(
              imageUrl: 'https://invalid.example.com/not_exist.png',
              width: 96,
              height: 96,
              radius: 12,
            ),
          ),
          SantoSection(
            title: '自定义失败态',
            description: 'errorWidget 替换默认失败态为自定义占位样式',
            child: SantoImage(
              imageUrl: 'https://invalid.example.com/not_exist.png',
              width: 96,
              height: 96,
              radius: 12,
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
          SantoSection(
            title: '本地图片',
            description: 'isNetwork 传 false 并指定 assets 路径即可加载本地图片',
            child: SantoImage(
              imageUrl: 'assets/image/empty_state.png',
              width: 160,
              height: 120,
              isNetwork: false,
              radius: 12,
            ),
          ),
        ],
      ),
    );
  }
}
