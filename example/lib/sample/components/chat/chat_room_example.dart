import 'package:example/sample/components/chat/chat_demo.dart';
import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// 整屏会话示例:会话撑满页面,用来验证输入法唤起时输入区随之上移
///
/// 这里直接用 Scaffold(默认 resizeToAvoidBottomInset 为 true)承载 SantoChat,
/// 输入法弹出时页面缩短、输入区自然停在输入法上方。
class ChatRoomExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(title: 'Chat 整屏会话'),
      body: const ChatDemo(),
    );
  }
}
