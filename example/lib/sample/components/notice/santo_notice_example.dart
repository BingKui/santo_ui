import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

/// Notice 通知栏示例
class SantoNoticeExample extends StatelessWidget {
  /// 十种内置状态样式,取色跟随主题
  final Map<String, NoticeStyle> _styles = <String, NoticeStyle>{
    '红色 + 失败 + 箭头': NoticeStyles.failWithArrow,
    '红色 + 失败 + 关闭': NoticeStyles.failWithClose,
    '主题色 + 进行中 + 箭头': NoticeStyles.runningWithArrow,
    '主题色 + 进行中 + 关闭': NoticeStyles.runningWithClose,
    '绿色 + 完成 + 箭头': NoticeStyles.succeedWithArrow,
    '绿色 + 完成 + 关闭': NoticeStyles.succeedWithClose,
    '橘色 + 警告 + 箭头': NoticeStyles.warningWithArrow,
    '橘色 + 警告 + 关闭': NoticeStyles.warningWithClose,
    '主题色 + 通知 + 箭头': NoticeStyles.normalNoticeWithArrow,
    '主题色 + 通知 + 关闭': NoticeStyles.normalNoticeWithClose,
  };

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'Notice 通知栏',
      children: <Widget>[
        ExampleIntro('notice'),
        SantoSection(
          title: '基础用法',
          description: '只传 content 就是一条默认进行中通知;noticeStyle 指定状态样式,点击触发 onNoticeTap',
          child: Column(
            children: <Widget>[
              const SantoNotice(content: '这是通知内容'),
              const SizedBox(height: 12),
              SantoNotice(
                content: '这是通知内容',
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
        SantoSection(
          title: '十种内置样式',
          description: '遍历 NoticeStyles 预置样式查看配色差异,取色跟随主题色',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (final MapEntry<String, NoticeStyle> item in _styles.entries)
                _buildStyleItem(item.key, item.value),
            ],
          ),
        ),
        SantoSection(
          title: '左侧标签 + 右侧按钮',
          description: 'leftTagText 渲染左侧标签,rightButtonText 渲染右侧按钮;都不传时只显示通知内容',
          child: Column(
            children: <Widget>[
              SantoNotice(
                leftTagText: '任务',
                content: '这是通知内容',
                rightButtonText: '去完成',
                onRightButtonTap: () {
                  SantoToast.show('点击右侧按钮', context);
                },
              ),
              const SizedBox(height: 12),
              const SantoNotice(content: '只有通知内容时,标签与按钮都不渲染'),
              const SizedBox(height: 12),
              const SantoNotice(
                leftTagText: '任务',
                content: '只传左侧标签,右侧按钮不渲染',
              ),
              const SizedBox(height: 12),
              SantoNotice(
                content: '只传右侧按钮,左侧标签不渲染',
                rightButtonText: '去完成',
                onRightButtonTap: () {
                  SantoToast.show('点击右侧按钮', context);
                },
              ),
            ],
          ),
        ),
        SantoSection(
          title: '带按钮的通知文案过长',
          description: 'content 超长且未开启 marquee 时省略,开启后横向滚动',
          child: Column(
            children: <Widget>[
              SantoNotice(
                leftTagText: '任务',
                content: '这是通知内容这是通知内容这是通知内容这是通知内容这是通知内容',
                rightButtonText: '去完成',
                marquee: true,
                onRightButtonTap: () {
                  SantoToast.show('点击右侧按钮', context);
                },
              ),
              const SizedBox(height: 12),
              SantoNotice(
                leftTagText: '任务',
                content: '这是通知内容这是通知内容这是通知内容这是通知内容这是通知内容',
                rightButtonText: '去完成',
                onRightButtonTap: () {
                  SantoToast.show('点击右侧按钮', context);
                },
              ),
            ],
          ),
        ),
        SantoSection(
          title: '跑马灯',
          description: 'marquee 为 true 时长文案滚动展示',
          child: const SantoNotice(
            content: '这是跑马灯的通知内容这是跑马灯的通知内容这是跑马灯的通知内容',
            marquee: true,
          ),
        ),
        SantoSection(
          title: '自定义左右图标',
          description: 'showLeftIcon、showRightIcon 控制显隐,leftWidget、rightWidget 替换图标',
          child: Column(
            children: <Widget>[
              const SantoNotice(content: '隐藏左侧图标', showLeftIcon: false),
              const SizedBox(height: 12),
              const SantoNotice(content: '隐藏右侧图标', showRightIcon: false),
              const SizedBox(height: 12),
              const SantoNotice(
                content: '自定义左侧图标',
                leftWidget: Icon(Icons.info_outline,
                    size: 16, color: Color(0xFF1677FF)),
              ),
              const SizedBox(height: 12),
              const SantoNotice(
                content: '自定义右侧图标',
                rightWidget: Icon(Icons.arrow_forward_ios,
                    size: 12, color: Color(0xFF1677FF)),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '自定义颜色和高度',
          description: 'textColor、backgroundColor 覆盖主题取色,minHeight 调整最小高度',
          child: Column(
            children: <Widget>[
              const SantoNotice(
                content: '自定义背景色和文字颜色',
                backgroundColor: Color(0xFFF6FFED),
                textColor: Color(0xFF52C41A),
              ),
              const SizedBox(height: 12),
              SantoNotice(
                content: '最小高度 56,内容自动垂直居中',
                minHeight: 56,
                noticeStyle: NoticeStyles.warningWithArrow,
              ),
              const SizedBox(height: 12),
              SantoNotice(
                leftTagText: '任务',
                leftTagBackgroundColor: const Color(0xFFE6F4FF),
                leftTagTextColor: const Color(0xFF1677FF),
                content: '标签、内容与按钮的颜色独立配置',
                rightButtonText: '去完成',
                rightButtonBorderColor: const Color(0xFF1677FF),
                rightButtonTextColor: const Color(0xFF1677FF),
                onRightButtonTap: () {
                  SantoToast.show('点击右侧按钮', context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStyleItem(String title, NoticeStyle style) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Color(0xFF808695)),
        ),
        const SizedBox(height: 8),
        SantoNotice(content: '这是通知内容', noticeStyle: style),
        const SizedBox(height: 16),
      ],
    );
  }
}
