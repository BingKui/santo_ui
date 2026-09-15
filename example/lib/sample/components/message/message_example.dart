import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// Message 消息通知示例页面
class MessageExample extends StatefulWidget {
  @override
  _MessageExampleState createState() => _MessageExampleState();
}

class _MessageExampleState extends State<MessageExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SantoAppBar(title: 'Message 消息通知示例'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 基础用法
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '基础用法',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '顶部轻量消息提示，支持多种类型',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
            SizedBox(height: 16),
            _buildButtonRow([
              _buildButton('成功消息', () {
                SantoMessage.show(
                  context: context,
                  content: '操作成功',
                  type: SantoMessageType.success,
                );
              }),
              _buildButton('错误消息', () {
                SantoMessage.show(
                  context: context,
                  content: '操作失败，请重试',
                  type: SantoMessageType.error,
                );
              }),
            ]),
            SizedBox(height: 12),
            _buildButtonRow([
              _buildButton('警告消息', () {
                SantoMessage.show(
                  context: context,
                  content: '请注意，该操作不可撤销',
                  type: SantoMessageType.warning,
                );
              }),
              _buildButton('信息消息', () {
                SantoMessage.show(
                  context: context,
                  content: '这是一条提示信息',
                  type: SantoMessageType.info,
                );
              }),
            ]),
            SizedBox(height: 32),

            // 快捷方法
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '快捷方法',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '使用 success / error / warning / info 快捷方法',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
            SizedBox(height: 16),
            _buildButtonRow([
              _buildButton('success()', () {
                SantoMessage.success(
                  context: context,
                  content: '保存成功',
                );
              }),
              _buildButton('error()', () {
                SantoMessage.error(
                  context: context,
                  content: '网络异常',
                );
              }),
            ]),
            SizedBox(height: 12),
            _buildButtonRow([
              _buildButton('warning()', () {
                SantoMessage.warning(
                  context: context,
                  content: '存储空间不足',
                );
              }),
              _buildButton('info()', () {
                SantoMessage.info(
                  context: context,
                  content: '新版本已发布',
                );
              }),
            ]),
            SizedBox(height: 32),

            // 自定义时长
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '自定义时长',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '设置 duration 控制消息显示时间',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
            SizedBox(height: 16),
            _buildButtonRow([
              _buildButton('显示1秒', () {
                SantoMessage.show(
                  context: context,
                  content: '这条消息显示1秒',
                  type: SantoMessageType.info,
                  duration: Duration(seconds: 1),
                );
              }),
              _buildButton('显示5秒', () {
                SantoMessage.show(
                  context: context,
                  content: '这条消息显示5秒',
                  type: SantoMessageType.info,
                  duration: Duration(seconds: 5),
                );
              }),
            ]),
            SizedBox(height: 32),

            // 自定义样式
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '自定义样式',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '自定义背景色、文字颜色和图标',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
            SizedBox(height: 16),
            _buildButtonRow([
              _buildButton('自定义背景色', () {
                SantoMessage.show(
                  context: context,
                  content: '自定义紫色背景',
                  backgroundColor: Color(0xFF7B61FF),
                  icon: Icons.palette,
                );
              }),
              _buildButton('自定义图标', () {
                SantoMessage.show(
                  context: context,
                  content: '自定义图标消息',
                  type: SantoMessageType.success,
                  icon: Icons.celebration,
                );
              }),
            ]),
            SizedBox(height: 12),
            _buildButtonRow([
              _buildButton('自定义文字颜色', () {
                SantoMessage.show(
                  context: context,
                  content: '深色文字消息',
                  backgroundColor: Color(0xFFE8F4FD),
                  textColor: Color(0xFF0984F9),
                  icon: Icons.info_outline,
                );
              }),
              _buildButton('手动关闭', () {
                SantoMessage.show(
                  context: context,
                  content: '点击按钮手动关闭',
                  type: SantoMessageType.info,
                  duration: Duration(seconds: 30),
                );
                Future.delayed(Duration(seconds: 2), () {
                  SantoMessage.dismiss();
                });
              }),
            ]),
            SizedBox(height: 32),

            // 长文本
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '长文本',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            _buildButtonRow([
              _buildButton('长文本消息', () {
                SantoMessage.show(
                  context: context,
                  content: '这是一条比较长的消息内容，用于测试消息通知在长文本情况下的显示效果。',
                  type: SantoMessageType.info,
                  duration: Duration(seconds: 4),
                );
              }),
            ]),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// 构建按钮行
  Widget _buildButtonRow(List<Widget> buttons) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: buttons.map((btn) => Expanded(child: Padding(
          padding: EdgeInsets.only(right: 8),
          child: btn,
        ))).toList(),
      ),
    );
  }

  /// 构建按钮
  Widget _buildButton(String text, VoidCallback onTap) {
    return SantoNormalButton(
      onTap: onTap,
      text: text,
    );
  }
}
