

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// 通知样式example

class SantoNoticeBarExample extends StatelessWidget {
  final List<NoticeStyle> defaultStyles = [
    NoticeStyles.failWithArrow,
    NoticeStyles.failWithClose,
    NoticeStyles.runningWithArrow,
    NoticeStyles.runningWithClose,
    NoticeStyles.succeedWithArrow,
    NoticeStyles.succeedWithClose,
    NoticeStyles.warningWithArrow,
    NoticeStyles.warningWithClose,
    NoticeStyles.normalNoticeWithArrow,
    NoticeStyles.normalNoticeWithClose,
  ];

  final List<String> defaultContents = [
    "样式1：failWithArrow失败 + 箭头",
    "样式2：failWithClose失败 + 关闭",
    "样式3：runningWithArrow运行中 + 箭头",
    "样式4：runningWithClose运行中 + 关闭",
    "样式5：succeedWithArrow成功 + 箭头",
    "样式6：succeedWithClose成功 + 关闭",
    "样式7：warningWithArrow警告 + 箭头",
    "样式8：warningWithClose警告 + 关闭",
    "样式9：normalNoticeWithArrow普通通知 + 箭头",
    "样式10：normalNoticeWithClose普通通知 + 关闭",
  ];

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          SantoSection(
            title: '基础用法',
            description: 'noticeStyle 指定预设样式，点击通知或右侧图标触发回调',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SantoBubbleText(
                  maxLines: 3,
                  text: '默认支持10种通知样式，支持自定义icon、文字颜色和背景颜色，支持是否显示icon',
                ),
                SizedBox(height: 12),
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
          SantoSection(
            title: '跑马灯',
            description: 'marquee 为 true 时通知内容滚动播放',
            child: SantoNoticeBar(
              content: '这是跑马灯的通知内容跑马灯的通知内容跑马灯的通知内容跑马灯的通知内容',
              marquee: true,
              noticeStyle: NoticeStyles.runningWithArrow,
              onNoticeTap: () {
                SantoToast.show('点击通知', context);
              },
              onRightIconTap: () {
                SantoToast.show('点击右侧图标', context);
              },
            ),
          ),
          SantoSection(
            title: '隐藏左侧图标',
            description: 'showLeftIcon 为 false 隐藏左侧状态图标',
            child: SantoNoticeBar(
              content: '这是通知内容',
              showLeftIcon: false,
              noticeStyle: NoticeStyles.runningWithArrow,
              onNoticeTap: () {
                SantoToast.show('点击通知', context);
              },
              onRightIconTap: () {
                SantoToast.show('点击右侧图标', context);
              },
            ),
          ),
          SantoSection(
            title: '隐藏右侧图标',
            description: 'showRightIcon 为 false 隐藏右侧箭头或关闭图标',
            child: SantoNoticeBar(
              content: '这是通知内容',
              showRightIcon: false,
              noticeStyle: NoticeStyles.runningWithArrow,
              onNoticeTap: () {
                SantoToast.show('点击通知', context);
              },
              onRightIconTap: () {
                SantoToast.show('点击右侧图标', context);
              },
            ),
          ),
          SantoSection(
            title: '不显示图标',
            description: '同时关闭左右图标后仅保留通知文案',
            child: SantoNoticeBar(
              content: '这是通知内容',
              showLeftIcon: false,
              showRightIcon: false,
              noticeStyle: NoticeStyles.runningWithArrow,
              onNoticeTap: () {
                SantoToast.show('点击通知', context);
              },
              onRightIconTap: () {
                SantoToast.show('点击右侧图标', context);
              },
            ),
          ),
          SantoSection(
            title: '异常案例：通知文案特别长',
            description: '超长通知文案在非跑马灯模式下的截断表现',
            child: SantoNoticeBar(
              content: '这是通知内容这是通知内容这是通知内容这是通知内容这是通知内容这是通知内容这是通知内容',
              noticeStyle: NoticeStyles.runningWithArrow,
              onNoticeTap: () {
                SantoToast.show('点击通知', context);
              },
              onRightIconTap: () {
                SantoToast.show('点击右侧图标', context);
              },
            ),
          ),
          SantoSection(
            title: '自定义颜色和图标',
            description: 'textColor 与 backgroundColor 自定义配色及左右图标',
            child: SantoNoticeBar(
              content: '这是通知内容',
              textColor: Color(0xFF17233D),
              // 通知颜色
              backgroundColor: Colors.grey,
              // 背景色
              leftWidget: SantoTools.getAssetImage(SantoAsset.iconMore),

              ///左侧图标
              rightWidget: SantoTools.getAssetImage(SantoAsset.iconMore),

              ///右侧图标
              onNoticeTap: () {
                SantoToast.show('点击通知', context);
              },
              onRightIconTap: () {
                SantoToast.show('点击右侧图标', context);
              },
            ),
          ),
          SantoSection(
            title: '10种默认样式',
            description: '遍历十种 NoticeStyles 预置样式查看配色差异',
            child: Container(
              height: 460,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: SantoNoticeBar(
                      noticeStyle: defaultStyles[index],
                      content: defaultContents[index],
                      onNoticeTap: () {
                        SantoToast.show('点击通知', context);
                      },
                      onRightIconTap: () {
                        SantoToast.show('点击右侧图标', context);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ]),
    );
  }
}
