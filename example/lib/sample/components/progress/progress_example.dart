import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// 进度条示例页面
class ProgressExample extends StatefulWidget {
  const ProgressExample({Key? key}) : super(key: key);

  @override
  _ProgressExampleState createState() => _ProgressExampleState();
}

class _ProgressExampleState extends State<ProgressExample> {
  double _progressValue = 0.3;
  double _circularValue = 0.6;

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'Progress 示例',
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 基础进度条
          SantoSection(
            title: '基础进度条',
            description: 'value 取 0 到 1 的进度值，1.0 表示已全部完成',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SantoProgress(value: 0.6),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SantoProgress(value: 1.0),
                ),
              ],
            ),
          ),
          // 显示百分比
          SantoSection(
            title: '显示百分比',
            description: 'showLabel 为 true 时在进度条右侧显示百分比数值',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SantoProgress(value: 0.75, showLabel: true),
                ),
              ],
            ),
          ),
          // 自定义颜色
          SantoSection(
            title: '自定义颜色',
            description: 'color 覆盖默认主题色，可按业务语义区分进度状态',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SantoProgress(
                    value: 0.8,
                    color: const Color(0xFFFAAD14),
                    showLabel: true,
                  ),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SantoProgress(
                    value: 0.4,
                    color: const Color(0xFFFF4D4F),
                    showLabel: true,
                  ),
                ),
              ],
            ),
          ),
          // 自定义高度
          SantoSection(
            title: '自定义高度',
            description: 'strokeWidth 控制进度条高度，加粗后更醒目',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SantoProgress(
                    value: 0.6,
                    strokeWidth: 12.0,
                    color: const Color(0xFF1677FF),
                  ),
                ),
              ],
            ),
          ),
          // 动态进度条
          SantoSection(
            title: '动态进度条（可拖动）',
            description: '拖动下方 SantoSlider 时实时更新 value，进度条随动',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SantoProgress(
                    value: _progressValue,
                    showLabel: true,
                  ),
                ),
                SantoSlider(
                  value: _progressValue,
                  onChanged: (v) {
                    setState(() {
                      _progressValue = v;
                    });
                  },
                ),
              ],
            ),
          ),
          // 环形进度条
          SantoSection(
            title: '环形进度条',
            description: 'SantoCircularProgress 以 value 控制弧度与完成比例',
            child: Wrap(
              spacing: 24,
              children: [
                SantoCircularProgress(value: 0.6),
                SantoCircularProgress(
                  value: 0.8,
                  color: const Color(0xFF52C41A),
                ),
                SantoCircularProgress(value: 1.0),
              ],
            ),
          ),
          // 动态环形进度条
          SantoSection(
            title: '动态环形进度条',
            description: '拖动滑块实时改变 value，环形进度与百分比同步更新',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: SantoCircularProgress(value: _progressValue)),
                SantoSlider(
                  value: _progressValue,
                  onChanged: (v) {
                    setState(() {
                      _progressValue = v;
                    });
                  },
                ),
              ],
            ),
          ),
          // 不同样式的环形
          SantoSection(
            title: '自定义环形样式',
            description: '通过 radius、strokeWidth 与 color 定制环形进度外观',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('不同尺寸（radius / strokeWidth）'),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 24,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SantoCircularProgress(
                      value: 0.6,
                      radius: 20,
                      strokeWidth: 4,
                    ),
                    SantoCircularProgress(value: 0.6),
                    SantoCircularProgress(
                      value: 0.6,
                      radius: 44,
                      strokeWidth: 10,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('自定义颜色（进度色 + 背景环色）'),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 24,
                  children: [
                    SantoCircularProgress(
                      value: 0.45,
                      color: const Color(0xFFFF4D4F),
                      backgroundColor: const Color(0xFFFFF2F0),
                    ),
                    SantoCircularProgress(
                      value: 0.75,
                      color: const Color(0xFF52C41A),
                      backgroundColor: const Color(0xFFF6FFED),
                    ),
                    SantoCircularProgress(
                      value: 0.3,
                      color: const Color(0xFFFAAD14),
                      backgroundColor: const Color(0xFFFFFBE6),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('自定义百分比标签样式'),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 24,
                  children: [
                    SantoCircularProgress(
                      value: 0.85,
                      showLabel: true,
                      labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF52C41A),
                      ),
                    ),
                    SantoCircularProgress(
                      value: 0.5,
                      showLabel: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
