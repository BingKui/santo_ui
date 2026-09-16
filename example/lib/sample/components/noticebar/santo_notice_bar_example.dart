import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/components/noticebar/notice_bar_with_button_example.dart';
import 'package:flutter/material.dart';

/// NoticeBar 通知栏示例
class SantoNoticeBarExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(title: 'NoticeBar 示例'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SantoPanel(
              title: '基础用法',
              child: Column(
                children: [
                  SantoNoticeBar(content: '这是通知内容'),
                  const SizedBox(height: 12),
                  SantoNoticeBar(
                    content: '这是通知内容',
                    noticeStyle: NoticeStyles.runningWithArrow,
                    onNoticeTap: () {
                      SantoToast.show('点击通知', context);
                    },
                    onRightIconTap: () {
                      SantoToast.show('点击右侧图标', context);
                    },
                  ),
                ],
              ),
            ),
            SantoPanel(
              title: '十种默认样式',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStyleItem('红色 + 失败 + 箭头', NoticeStyles.failWithArrow),
                  _buildStyleItem('红色 + 失败 + 关闭', NoticeStyles.failWithClose),
                  _buildStyleItem(
                      '蓝色 + 进行中 + 箭头', NoticeStyles.runningWithArrow),
                  _buildStyleItem(
                      '蓝色 + 进行中 + 关闭', NoticeStyles.runningWithClose),
                  _buildStyleItem(
                      '绿色 + 完成 + 箭头', NoticeStyles.succeedWithArrow),
                  _buildStyleItem(
                      '绿色 + 完成 + 关闭', NoticeStyles.succeedWithClose),
                  _buildStyleItem(
                      '橘色 + 警告 + 箭头', NoticeStyles.warningWithArrow),
                  _buildStyleItem(
                      '橘色 + 警告 + 关闭', NoticeStyles.warningWithClose),
                  _buildStyleItem(
                      '橘色 + 通知 + 箭头', NoticeStyles.normalNoticeWithArrow),
                  _buildStyleItem(
                      '橘色 + 通知 + 关闭', NoticeStyles.normalNoticeWithClose),
                ],
              ),
            ),
            SantoPanel(
              title: '跑马灯',
              child: Column(
                children: [
                  SantoNoticeBar(
                    content: '这是跑马灯的通知内容这是跑马灯的通知内容这是跑马灯的通知内容',
                    noticeStyle: NoticeStyles.runningWithArrow,
                    marquee: true,
                  ),
                ],
              ),
            ),
            SantoPanel(
              title: '自定义左右图标',
              child: Column(
                children: [
                  SantoNoticeBar(
                    content: '隐藏左侧图标',
                    showLeftIcon: false,
                    noticeStyle: NoticeStyles.normalNoticeWithArrow,
                  ),
                  const SizedBox(height: 12),
                  SantoNoticeBar(
                    content: '隐藏右侧图标',
                    showRightIcon: false,
                    noticeStyle: NoticeStyles.normalNoticeWithArrow,
                  ),
                  const SizedBox(height: 12),
                  SantoNoticeBar(
                    content: '自定义左侧图标',
                    leftWidget: const Icon(Icons.info_outline,
                        size: 16, color: Color(0xFF1677FF)),
                    noticeStyle: NoticeStyles.runningWithArrow,
                  ),
                  const SizedBox(height: 12),
                  SantoNoticeBar(
                    content: '自定义右侧图标',
                    rightWidget: const Icon(Icons.arrow_forward_ios,
                        size: 12, color: Color(0xFF1677FF)),
                    noticeStyle: NoticeStyles.runningWithArrow,
                  ),
                ],
              ),
            ),
            SantoPanel(
              title: '自定义颜色和高度',
              child: Column(
                children: [
                  SantoNoticeBar(
                    content: '自定义背景色和文字颜色',
                    backgroundColor: const Color(0xFFEBFFF7),
                    textColor: const Color(0xFF52C41A),
                  ),
                  const SizedBox(height: 12),
                  SantoNoticeBar(
                    content: '最小高度 56,内容自动垂直居中',
                    minHeight: 56,
                    noticeStyle: NoticeStyles.warningWithArrow,
                  ),
                ],
              ),
            ),
            SantoPanel(
              title: '带按钮通知栏 (SantoNoticeBarWithButton)',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('高度 56,左侧标签 + 中间通知内容 + 右侧按钮'),
                  const SizedBox(height: 12),
                  SantoNoticeBarWithButton(
                    leftTagText: '任务',
                    content: '这是通知内容',
                    rightButtonText: '去完成',
                    onRightButtonTap: () {
                      SantoToast.show('点击右侧按钮', context);
                    },
                  ),
                  const SizedBox(height: 12),
                  SantoNoticeBarWithButton(
                    leftTagText: '任务',
                    content: '这是跑马灯的通知内容这是跑马灯的通知内容这是跑马灯的通知内容',
                    rightButtonText: '去完成',
                    marquee: true,
                    onRightButtonTap: () {
                      SantoToast.show('点击右侧按钮', context);
                    },
                  ),
                  const SizedBox(height: 12),
                  SantoNormalButton.outline(
                    text: '查看更多 WithButton 示例',
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return SantoNoticeBarWithButtonExample();
                      }));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyleItem(String title, NoticeStyle style) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Color(0xFF808695)),
        ),
        const SizedBox(height: 8),
        SantoNoticeBar(
          content: '这是通知内容',
          noticeStyle: style,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
