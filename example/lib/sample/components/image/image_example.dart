import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// Image 增强图片示例
class ImageExample extends StatefulWidget {
  @override
  _ImageExampleState createState() => _ImageExampleState();
}

class _ImageExampleState extends State<ImageExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SantoAppBar(title: 'Image 示例'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 基础网络图片
            SantoPanel(
              title: '基础网络图片',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [const SizedBox(height: 24)],
              ),
            ),
            // 圆角图片
            SantoPanel(
              title: '圆角图片',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [const SizedBox(height: 24)],
              ),
            ),
            // 不同 BoxFit
            SantoPanel(
              title: '不同 BoxFit',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [const SizedBox(height: 24)],
              ),
            ),
            // 加载失败态
            SantoPanel(
              title: '加载失败态（默认）',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [const SizedBox(height: 24)],
              ),
            ),
            // 自定义失败态
            SantoPanel(
              title: '自定义失败态',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [const SizedBox(height: 24)],
              ),
            ),
            // 本地图片
            SantoPanel(
              title: '本地图片',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [const SizedBox(height: 32)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
