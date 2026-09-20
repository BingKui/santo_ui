import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

class BubbleTextExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(      title: '气泡信息',
      children: <Widget>[
        ExampleIntro('bubble_text'),
        SantoSection(
          title: '左侧气泡（start）',
          description: 'placement 为 start 时气泡居左，maxLines 限制最多展示 3 行',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoBubbleText(
                maxLines: 3,
                placement: SantoBubblePlacement.start,
                text:
                    '最多显示三行文本，整体圆角12，左上角是小圆角，\n '
                    '文本的字号是14，颜色为深色',
              ),
            ],
          ),
        ),
        SantoSection(
          title: '右侧气泡（end）',
          description: 'placement 为 end 时气泡居右，右上角收为小圆角',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoBubbleText(
                maxLines: 3,
                placement: SantoBubblePlacement.end,
                text:
                    '最多显示三行文本，整体圆角12，右上角是小圆角，\n '
                    '文本的字号是14，颜色为深色',
              ),
            ],
          ),
        ),
        SantoSection(
          title: '自定义圆角',
          description: 'radius 分别设为 24 与 4，对比大小圆角的气泡外观',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoBubbleText(
                placement: SantoBubblePlacement.start,
                radius: 24,
                text: '大圆角气泡 radius 24',
              ),
              SizedBox(height: 12),
              SantoBubbleText(
                placement: SantoBubblePlacement.end,
                radius: 4,
                text: '小圆角气泡 radius 4',
              ),
            ],
          ),
        ),
        SantoSection(
          title: '自定义背景色和文字颜色',
          description: 'backgroundColor 与 textColor 分别控制气泡背景和文字颜色',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoBubbleText(
                placement: SantoBubblePlacement.end,
                backgroundColor: Color(0xFF1677FF),
                textColor: Colors.white,
                text: '蓝色气泡，白色文字',
              ),
              SizedBox(height: 12),
              SantoBubbleText(
                placement: SantoBubblePlacement.start,
                backgroundColor: Color(0xFFE8F8EE),
                textColor: Color(0xFF07C160),
                text: '绿色气泡，绿色文字',
              ),
            ],
          ),
        ),
        SantoSection(
          title: '展开收起',
          description: '超出 maxLines 2 时显示更多按钮，点击展开或收起并回调 onExpanded',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoBubbleText(
                maxLines: 2,
                text:
                    '推荐理由："满五唯一""临近地铁""首付低"，多出折行显示，文字展开的样式文式文文字展开的样式文式文。问我',
                onExpanded: (isExpanded) {
                  String str = isExpanded ? "展开了" : "收起了";
                  SantoToast.show("我$str", context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
