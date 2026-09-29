import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';
import 'package:santo_ui/santo_ui.dart';

/// Timeline 时间轴示例(SantoTimeline)
class TimelineExample extends StatelessWidget {
  const TimelineExample({Key? key}) : super(key: key);

  /// 基础节点:只有内容
  static const List<SantoTimelineItem> _basicItems = <SantoTimelineItem>[
    SantoTimelineItem(content: Text('创建服务站点 2015-09-01')),
    SantoTimelineItem(content: Text('解决初始网络问题 2015-09-01')),
    SantoTimelineItem(content: Text('技术测试 2015-09-01')),
    SantoTimelineItem(content: Text('网络问题已解决 2015-09-01')),
  ];

  /// 带时间标题的节点
  static const List<SantoTimelineItem> _titledItems = <SantoTimelineItem>[
    SantoTimelineItem(title: '2015-09-01', content: Text('创建服务')),
    SantoTimelineItem(title: '2015-09-01 09:12:11', content: Text('解决初始网络问题')),
    SantoTimelineItem(content: Text('技术测试')),
    SantoTimelineItem(title: '2015-09-01 09:12:11', content: Text('网络问题已解决')),
  ];

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'Timeline 时间轴',
      children: <Widget>[
        ExampleIntro('timeline'),
        const SantoSection(
          title: '基础用法',
          description: '节点自上而下按时间排列,默认轴线在左侧、内容在轴线右侧',
          child: SantoTimeline(items: _basicItems),
        ),
        const SantoSection(
          title: '时间标题',
          description: '传 title 后标题与内容分列轴线两侧,标题列默认占一半宽度',
          child: SantoTimeline(items: _titledItems),
        ),
        const SantoSection(
          title: '节点颜色',
          description: 'color 取主题语义色 blue/red/green/gray,dotColor 可传入任意色值',
          child: SantoTimeline(
            items: <SantoTimelineItem>[
              SantoTimelineItem(content: Text('创建服务站点'), color: SantoTimelineColor.blue),
              SantoTimelineItem(content: Text('技术测试'), color: SantoTimelineColor.green),
              SantoTimelineItem(content: Text('网络异常'), color: SantoTimelineColor.red),
              SantoTimelineItem(content: Text('等待中'), color: SantoTimelineColor.gray),
              SantoTimelineItem(
                content: Text('自定义色值'),
                dotColor: Color(0xFF722ED1),
              ),
            ],
          ),
        ),
        const SantoSection(
          title: '实心节点',
          description: 'variant 默认 outlined 空心描边,设为 filled 后节点实心填充',
          child: SantoTimeline(
            items: _basicItems,
            variant: SantoTimelineVariant.filled,
          ),
        ),
        const SantoSection(
          title: '自定义节点',
          description: 'icon 传入任意组件替换圆形节点,组件以节点圆心为中心展示',
          child: SantoTimeline(
            items: <SantoTimelineItem>[
              SantoTimelineItem(content: Text('创建服务站点')),
              SantoTimelineItem(
                icon: SantoIcon(SantoIcons.clock, color: Color(0xFF1677FF)),
                content: Text('排期评审'),
              ),
              SantoTimelineItem(
                icon: SantoIcon(SantoIcons.checkCircle, color: Color(0xFF52C41A)),
                content: Text('技术测试'),
              ),
            ],
          ),
        ),
        const SantoSection(
          title: '加载中',
          description: '节点传 loading 展示加载指示器,指向它的那段轴线转为虚线',
          child: SantoTimeline(
            items: <SantoTimelineItem>[
              SantoTimelineItem(content: Text('创建服务站点 2015-09-01')),
              SantoTimelineItem(content: Text('解决初始网络问题 2015-09-01')),
              SantoTimelineItem(loading: true, content: Text('录制中...')),
            ],
          ),
        ),
        const SantoSection(
          title: '倒序',
          description: 'reverse 为 true 时倒序渲染,节点的侧位仍按传入顺序决定',
          child: SantoTimeline(items: _basicItems, reverse: true),
        ),
        const SantoSection(
          title: '左右交替',
          description: 'mode 设为 alternate 后内容左右交替,轴线居中',
          child: SantoTimeline(
            items: _basicItems,
            mode: SantoTimelineMode.alternate,
          ),
        ),
        const SantoSection(
          title: '标题列宽度',
          description: 'titleSpan 用逻辑像素固定标题列宽度,不传时标题与内容各占一半',
          child: SantoTimeline(
            items: _titledItems,
            titleSpan: 100,
          ),
        ),
        const SantoSection(
          title: '标题在右',
          description: 'mode 设为 end 后内容在轴线左侧、标题在轴线右侧',
          child: SantoTimeline(
            items: _titledItems,
            mode: SantoTimelineMode.end,
          ),
        ),
        const SantoSection(
          title: '横向·起始',
          description: 'orientation 设为 horizontal 后节点自左向右排开,默认内容在轴线下方',
          child: SantoTimeline(
            items: _basicItems,
            orientation: SantoTimelineOrientation.horizontal,
          ),
        ),
        const SantoSection(
          title: '横向·结束',
          description: '横向 + mode 为 end 时内容排在轴线上方,与起始模式上下镜像',
          child: SantoTimeline(
            items: _basicItems,
            orientation: SantoTimelineOrientation.horizontal,
            mode: SantoTimelineMode.end,
          ),
        ),
        const SantoSection(
          title: '横向·交替',
          description: '横向 + mode 为 alternate 时内容上下交替,轴线在中间',
          child: SantoTimeline(
            items: _basicItems,
            orientation: SantoTimelineOrientation.horizontal,
            mode: SantoTimelineMode.alternate,
          ),
        ),
      ],
    );
  }
}
