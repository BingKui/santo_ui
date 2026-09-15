import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// SantoToast 轻提示示例
class ToastExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(title: 'SantoToast 示例'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SantoPanel(
              title: '基础用法',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoNormalButton(
                    onTap: () {
                      SantoToast.show(
                        '普通长 Toast',
                        context,
                        duration: SantoDuration.long,
                        gravity: SantoToastGravity.center,
                      );
                    },
                    text: '普通长 Toast（屏幕居中）',
                  ),
                  const SizedBox(height: 16),
                  SantoNormalButton(
                    onTap: () {
                      SantoToast.show('普通短 Toast', context);
                    },
                    text: '普通短 Toast',
                  ),
                ],
              ),
            ),
            SantoPanel(
              title: '带图标 Toast',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoNormalButton(
                    onTap: () {
                      SantoToast.show(
                        '失败图标 Toast',
                        context,
                        preIcon: Image.asset(
                          'assets/image/icon_toast_fail.png',
                          width: 24,
                          height: 24,
                        ),
                        duration: SantoDuration.short,
                      );
                    },
                    text: '失败图标 Toast',
                  ),
                  const SizedBox(height: 16),
                  SantoNormalButton(
                    onTap: () {
                      SantoToast.show(
                        '成功图标 Toast',
                        context,
                        preIcon: Image.asset(
                          'assets/image/icon_toast_success.png',
                          width: 24,
                          height: 24,
                        ),
                        duration: SantoDuration.short,
                      );
                    },
                    text: '成功图标 Toast',
                  ),
                ],
              ),
            ),
            SantoPanel(
              title: '不同弹出位置',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoNormalButton(
                    onTap: () {
                      SantoToast.show(
                        '顶部 Toast',
                        context,
                        gravity: SantoToastGravity.top,
                        duration: SantoDuration.short,
                      );
                    },
                    text: '顶部弹出',
                  ),
                  const SizedBox(height: 16),
                  SantoNormalButton(
                    onTap: () {
                      SantoToast.show(
                        '底部 Toast',
                        context,
                        gravity: SantoToastGravity.bottom,
                        duration: SantoDuration.short,
                      );
                    },
                    text: '底部弹出',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
