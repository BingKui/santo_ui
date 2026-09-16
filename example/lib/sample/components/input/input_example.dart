import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// SantoInputText 输入框示例
class SantoInputTextExample extends StatefulWidget {
  const SantoInputTextExample({Key? key}) : super(key: key);

  @override
  State<SantoInputTextExample> createState() => _SantoInputTextExampleState();
}

class _SantoInputTextExampleState extends State<SantoInputTextExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(title: 'Input 输入框示例'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SantoSection(
              title: '基础用法',
              description: '最简用法，配置 hint 占位文字与 onTextChange 回调',
              child: SantoInputText(
                minHeight: 40,
                borderRadius: 8,
                bgColor: const Color(0xFFF5F6FA),
                hint: '请输入内容',
                onTextChange: (text) {},
              ),
            ),
            SantoSection(
              title: '清除按钮',
              description: '输入内容后自动显示内置清除按钮，needClear 可控制',
              child: SantoInputText(
                minHeight: 40,
                borderRadius: 8,
                bgColor: const Color(0xFFF5F6FA),
                hint: '输入内容后展示清除按钮',
                onTextChange: (text) {},
              ),
            ),
            SantoSection(
              title: '字数限制与计数',
              description: 'maxLength 限制最大字数，showCounter 默认展示实时计数',
              child: SantoInputText(
                minHeight: 40,
                borderRadius: 8,
                bgColor: const Color(0xFFF5F6FA),
                maxLength: 10,
                hint: '最多输入 10 个字',
                onTextChange: (text) {},
              ),
            ),
            SantoSection(
              title: '前后缀插槽',
              description: 'prefix、suffix 插入自定义前后缀，传 suffix 时隐藏清除按钮',
              child: Column(
                children: [
                  SantoInputText(
                    minHeight: 44,
                    borderRadius: 8,
                    bgColor: const Color(0xFFF5F6FA),
                    prefix: const Icon(Icons.search,
                        size: 18, color: Color(0xFF999999)),
                    hint: '搜索',
                    onTextChange: (text) {},
                  ),
                  const SizedBox(height: 12),
                  SantoInputText(
                    minHeight: 44,
                    borderRadius: 8,
                    bgColor: const Color(0xFFF5F6FA),
                    suffix: const Text(
                      '发送',
                      style: TextStyle(
                          fontSize: 14, color: Color(0xFF0984F9)),
                    ),
                    hint: '带后缀按钮',
                    onTextChange: (text) {},
                  ),
                ],
              ),
            ),
            SantoSection(
              title: '密码输入(显隐切换)',
              description: 'obscureText 开启密码模式，由内置按钮切换显隐',
              child: SantoInputText(
                minHeight: 44,
                borderRadius: 8,
                bgColor: const Color(0xFFF5F6FA),
                obscureText: true,
                showPasswordToggle: true,
                inputType: TextInputType.text,
                hint: '请输入密码',
                onTextChange: (text) {},
              ),
            ),
            SantoSection(
              title: '只读 / 禁用',
              description: 'readOnly 保留选中复制，enabled 传 false 后完全禁用',
              child: Column(
                children: [
                  SantoInputText(
                    minHeight: 40,
                    borderRadius: 8,
                    bgColor: const Color(0xFFF5F6FA),
                    textString: '只读状态,可选择复制但不可编辑',
                    readOnly: true,
                    onTextChange: (text) {},
                  ),
                  const SizedBox(height: 12),
                  SantoInputText(
                    minHeight: 40,
                    borderRadius: 8,
                    bgColor: const Color(0xFFF5F6FA),
                    textString: '禁用状态,不可交互',
                    enabled: false,
                    onTextChange: (text) {},
                  ),
                ],
              ),
            ),
            SantoSection(
              title: '聚焦边框高亮',
              description: '聚焦时边框切换为 focusedBorderColor，失焦后还原',
              child: SantoInputText(
                minHeight: 44,
                borderRadius: 8,
                bgColor: Colors.white,
                borderColor: const Color(0xFFE5E5E5),
                focusedBorderColor: const Color(0xFF0984F9),
                hint: '聚焦时边框高亮',
                onTextChange: (text) {},
              ),
            ),
            SantoSection(
              title: '多行自适应高度',
              description: 'minLines 与 maxHeight 决定自适应范围，可输入多行文本',
              child: SantoInputText(
                maxHeight: 200,
                minHeight: 60,
                minLines: 3,
                borderRadius: 8,
                bgColor: const Color(0xFFF5F6FA),
                maxLength: 100,
                hint: 'input动态算高input动态算高input动态算高input动态算高',
                textInputAction: TextInputAction.newline,
                onTextChange: (text) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
