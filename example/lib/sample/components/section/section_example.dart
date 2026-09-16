import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// SantoSection 区块示例
class SectionExample extends StatelessWidget {
  const SectionExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(title: 'Section 区块'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12),
            SantoSection(
              title: '语法糖',
              titleSuffix: const Icon(Icons.edit_outlined,
                  size: 16, color: Color(0xFF17233D)),
              descriptionWidget: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: '通过 '),
                    WidgetSpan(child: _buildCodeChip('type')),
                    const TextSpan(
                        text:
                            ' 语法糖，使用预设的按钮样式：主按钮、次按钮、虚线按钮、文本按钮和链接按钮。推荐主按钮在同一个操作区域最多出现一次。'),
                  ],
                ),
              ),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SantoBigMainButton(
                    title: 'Primary Button',
                    onTap: () {},
                  ),
                  SantoBigOutlineButton(
                    title: 'Default Button',
                    onTap: () {},
                  ),
                  SantoBigGhostButton(
                    title: 'Ghost Button',
                    onTap: () {},
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      child: Text(
                        'Text Button',
                        style: TextStyle(
                          fontSize: 14,
                          color: SantoThemeConfigurator.instance
                              .getConfig()
                              .commonConfig
                              .brandPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SantoSection(
              title: '基础用法',
              description: '上方为演示内容,下方为标题和描述信息,整体为圆角卡片。',
              child: Text('这里展示具体内容'),
            ),
            SantoSection(
              description: '只有描述,没有标题与演示内容。',
            ),
          ],
        ),
      ),
    );
  }

  /// 描述中的内联代码片段
  Widget _buildCodeChip(String code) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFDCDEE2), width: 0.5),
      ),
      child: Text(
        code,
        style: const TextStyle(
            fontSize: 12, color: Color(0xFF515A6E), height: 1.2),
      ),
    );
  }
}
