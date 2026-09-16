

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// 描述: 带按钮的通知example

class SantoNoticeBarWithButtonExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(
        title: '带按钮的通知',
      ),
      body: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            SantoPanel(
              title: '基础用法',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoBubbleText(
                    maxLines: 3,
                    text:
                        '高度56，左边为标签，中间是通知内容，右边是按钮， 其中通知内容必传，标签和按钮文案如果是空，就不显示。所有颜色均支持自定义',
                  ),
                  SizedBox(height: 12),
                  SantoNoticeBarWithButton(
                    content: '这是通知内容',
                  ),
                ],
              ),
            ),
            SantoPanel(
              title: '正常样式',
              child: SantoNoticeBarWithButton(
                leftTagText: '任务',
                content: '这是通知内容',
                rightButtonText: '去完成',
                onRightButtonTap: () {
                  SantoToast.show('点击右侧按钮', context);
                },
              ),
            ),
            SantoPanel(
              title: '跑马灯',
              child: SantoNoticeBarWithButton(
                leftTagText: '任务',
                content: '这是跑马灯的通知内容跑马灯的通知内容跑马灯的通知内容跑马灯的通知内容',
                rightButtonText: '去完成',
                marquee: true,
                onRightButtonTap: () {
                  SantoToast.show('点击右侧按钮', context);
                },
              ),
            ),
            SantoPanel(
              title: '隐藏左侧标签',
              child: SantoNoticeBarWithButton(
                content: '这是通知内容',
                rightButtonText: '去完成',
                onRightButtonTap: () {
                  SantoToast.show('点击右侧按钮', context);
                },
              ),
            ),
            SantoPanel(
              title: '隐藏右侧按钮',
              child: SantoNoticeBarWithButton(
                leftTagText: '任务',
                content: '这是通知内容',
              ),
            ),
            SantoPanel(
              title: '通知文案长，不跑马灯',
              child: SantoNoticeBarWithButton(
                leftTagText: '任务',
                content: '这是通知内容这是通知内容这是通知内容这是通知内容这是通知内容',
                rightButtonText: '去完成',
                onRightButtonTap: () {
                  SantoToast.show('点击右侧按钮', context);
                },
              ),
            ),
            SantoPanel(
              title: '自定义文字和背景颜色',
              child: SantoNoticeBarWithButton(
                leftTagText: '任务',
                leftTagBackgroundColor: Color(0xFFE6F4FF),
                leftTagTextColor: Color(0xFF1677FF),
                content: '这是通知内容这是通知内容这是通知内容这是通知内容这是通知内容',
                backgroundColor: Color(0xFFF6FFED),
                contentTextColor: Color(0xFF52C41A),
                rightButtonText: '去完成',
                rightButtonBorderColor: Color(0xFF1677FF),
                rightButtonTextColor: Color(0xFF1677FF),
                onRightButtonTap: () {
                  SantoToast.show('点击右侧按钮', context);
                },
              ),
            ),
          ])),
    );
  }
}
