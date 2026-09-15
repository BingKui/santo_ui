import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// 轮播图示例页面
class SwiperExample extends StatefulWidget {
  const SwiperExample({Key? key}) : super(key: key);

  @override
  _SwiperExampleState createState() => _SwiperExampleState();
}

class _SwiperExampleState extends State<SwiperExample> {
  int _currentPage = 0;

  /// 生成彩色占位卡片
  List<Widget> _buildColorCards() {
    final colors = [
      const Color(0xFF0984F9),
      const Color(0xFF00AE66),
      const Color(0xFFFAAD14),
      const Color(0xFFFA3F3F),
      const Color(0xFF722ED1),
    ];
    return List.generate(colors.length, (index) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: colors[index],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'Page ${index + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    });
  }

  /// 生成图片占位卡片
  List<Widget> _buildImageCards() {
    return List.generate(4, (index) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFE8E8E8),
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage('https://picsum.photos/400/200?random=$index'),
            fit: BoxFit.cover,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SantoAppBar(title: 'Swiper 示例'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 基础轮播（圆点指示器）
            SantoPanel(
              title: '基础轮播（圆点指示器）',
              child: SantoSwiper(children: _buildColorCards()),
            ),
            // 数字指示器
            SantoPanel(
              title: '数字指示器',
              child: SantoSwiper(
                children: _buildColorCards(),
                indicatorType: SantoSwiperIndicatorType.number,
              ),
            ),
            // 不显示指示器
            SantoPanel(
              title: '不显示指示器',
              child: SantoSwiper(
                children: _buildImageCards(),
                indicator: false,
              ),
            ),
            // 非循环模式
            SantoPanel(
              title: '非循环模式',
              child: SantoSwiper(children: _buildColorCards(), loop: false),
            ),
            // 自定义高度
            SantoPanel(
              title: '自定义高度',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  SantoSwiper(
                    children: _buildColorCards(),
                    height: 250,
                    autoPlay: true,
                    indicator: true,
                    loop: true,
                  ),
                ],
              ),
            ),
            // 带间距
            SantoPanel(
              title: '带间距',
              child: SantoSwiper(children: _buildImageCards()),
            ),
            // 受控轮播
            SantoPanel(
              title: '受控轮播（外部控制）',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SantoNormalButton(
                          onTap: () {
                            setState(() {
                              _currentPage = (_currentPage - 1 + 5) % 5;
                            });
                          },
                          backgroundColor: const Color(0xFF0984F9),
                          text: '上一页',
                        ),
                        const SizedBox(width: 16),
                        SantoNormalButton(
                          onTap: () {
                            setState(() {
                              _currentPage = (_currentPage + 1) % 5;
                            });
                          },
                          backgroundColor: const Color(0xFF0984F9),
                          text: '下一页',
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('当前页: ${_currentPage + 1}'),
                  ),
                ],
              ),
            ),
            // 自定义自动播放间隔
            SantoPanel(
              title: '自定义自动播放间隔 (1秒)',
              child: SantoSwiper(children: _buildColorCards(), interval: 1000),
            ),
            // 禁用滑动
            SantoPanel(
              title: '禁用滑动（仅自动播放）',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [const SizedBox(height: 40)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
