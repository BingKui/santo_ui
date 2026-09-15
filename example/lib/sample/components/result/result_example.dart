import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// Result 结果页示例
class ResultExample extends StatefulWidget {
  @override
  _ResultExampleState createState() => _ResultExampleState();
}

class _ResultExampleState extends State<ResultExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(title: 'Result 示例'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 成功状态
            SantoPanel(
              title: '成功状态',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [const SizedBox(height: 24)],
              ),
            ),
            // 失败状态
            SantoPanel(
              title: '失败状态',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [const SizedBox(height: 24)],
              ),
            ),
            // 警告状态
            SantoPanel(
              title: '警告状态',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [const SizedBox(height: 24)],
              ),
            ),
            // 信息状态
            SantoPanel(
              title: '信息状态',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [const SizedBox(height: 24)],
              ),
            ),
            // 带操作按钮
            SantoPanel(
              title: '带操作按钮',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [const SizedBox(height: 24)],
              ),
            ),
            // 自定义图标和颜色
            SantoPanel(
              title: '自定义图标和颜色',
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
