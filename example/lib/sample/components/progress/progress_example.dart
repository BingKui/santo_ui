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
    return Scaffold(
      appBar: SantoAppBar(title: 'Progress 示例'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 基础进度条
            SantoPanel(
              title: '基础进度条',
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
            SantoPanel(
              title: '显示百分比',
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
            SantoPanel(
              title: '自定义颜色',
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
                      color: const Color(0xFFFA3F3F),
                      showLabel: true,
                    ),
                  ),
                ],
              ),
            ),
            // 自定义高度
            SantoPanel(
              title: '自定义高度',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SantoProgress(
                      value: 0.6,
                      strokeWidth: 12.0,
                      color: const Color(0xFF0984F9),
                    ),
                  ),
                ],
              ),
            ),
            // 动态进度条
            SantoPanel(
              title: '动态进度条（可拖动）',
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
            SantoPanel(
              title: '环形进度条',
              child: Wrap(
                spacing: 24,
                children: [
                  SantoCircularProgress(value: 0.6),
                  SantoCircularProgress(
                    value: 0.8,
                    color: const Color(0xFF00AE66),
                  ),
                  SantoCircularProgress(value: 1.0),
                ],
              ),
            ),
            // 动态环形进度条
            SantoPanel(
              title: '动态环形进度条',
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
            SantoPanel(
              title: '自定义环形样式',
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
