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
      const Color(0xFF1677FF),
      const Color(0xFF52C41A),
      const Color(0xFFFAAD14),
      const Color(0xFFFF4D4F),
      const Color(0xFF722ED1),
    ];
    return List.generate(colors.length, (index) {
      return Container(
        decoration: BoxDecoration(color: colors[index]),
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
    return SantoPageLayout(
      title: 'Swiper 示例',
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 基础轮播（圆点指示器）
          SantoSection(
            title: '基础轮播（圆点指示器）',
            description: '不传指示器相关参数，圆点标记当前页并支持自动播放',
            child: SantoSwiper(children: _buildColorCards()),
          ),
          // 数字指示器
          SantoSection(
            title: '数字指示器',
            description: 'indicatorType 传入 number，改为显示当前页与总页数',
            child: SantoSwiper(
              children: _buildColorCards(),
              indicatorType: SantoSwiperIndicatorType.number,
            ),
          ),
          // 不显示指示器
          SantoSection(
            title: '不显示指示器',
            description: 'indicator 设为 false 隐藏指示器，仅展示图片内容',
            child: SantoSwiper(
              children: _buildImageCards(),
              indicator: false,
            ),
          ),
          // 非循环模式
          SantoSection(
            title: '非循环模式',
            description: 'loop 为 false 时滑到末页不再回绕，自动播放随之停止',
            child: SantoSwiper(children: _buildColorCards(), loop: false),
          ),
          // 自定义高度
          SantoSection(
            title: '自定义高度',
            description: 'height 设为 250，同时开启 autoPlay、indicator 与 loop',
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
          SantoSection(
            title: '带间距',
            description: '图片卡片自带外边距形成间隔，用于展示相邻页的间隙',
            child: SantoSwiper(children: _buildImageCards()),
          ),
          // 受控轮播
          SantoSection(
            title: '受控轮播（外部控制）',
            description: '外部按钮修改页码状态，点击上一页、下一页查看联动',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SantoSwiper(
                  children: _buildColorCards(),
                  currentIndex: _currentPage,
                  autoPlay: false,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                ),
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
                        backgroundColor: const Color(0xFF1677FF),
                        text: '上一页',
                      ),
                      const SizedBox(width: 16),
                      SantoNormalButton(
                        onTap: () {
                          setState(() {
                            _currentPage = (_currentPage + 1) % 5;
                          });
                        },
                        backgroundColor: const Color(0xFF1677FF),
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
          SantoSection(
            title: '自定义自动播放间隔 (1秒)',
            description: 'interval 设为 1000 毫秒，加快自动播放的切换节奏',
            child: SantoSwiper(children: _buildColorCards(), interval: 1000),
          ),
          // 禁用滑动
          SantoSection(
            title: '禁用滑动（仅自动播放）',
            description: 'enableSwipe 为 false 后无法手动滑动，仅保留自动播放',
            child: SantoSwiper(
              children: _buildColorCards(),
              enableSwipe: false,
            ),
          ),
        ],
      ),
    );
  }
}
